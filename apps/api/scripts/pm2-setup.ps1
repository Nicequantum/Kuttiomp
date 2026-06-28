# Kuttiomp API - PM2 persistent setup (Windows)
# Run once:  npm run pm2:setup   (from apps/api)

$ErrorActionPreference = "Stop"
$ApiRoot = Split-Path -Parent $PSScriptRoot

function Stop-PortListener {
  param([int]$Port)

  $listeners = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
  foreach ($conn in $listeners) {
    $parentPid = $conn.OwningProcess
    Get-CimInstance Win32_Process -Filter "Name='python.exe'" -ErrorAction SilentlyContinue |
      Where-Object { $_.CommandLine -match "parent_pid=$parentPid" } |
      ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
    Stop-Process -Id $parentPid -Force -ErrorAction SilentlyContinue
  }

  Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
    Where-Object { $_.CommandLine -match "uvicorn.*app\.main:app" } |
    ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
}

Write-Host "=== Kuttiomp API - PM2 Setup ===" -ForegroundColor Cyan

if (-not (Test-Path "$ApiRoot\.venv\Scripts\uvicorn.exe")) {
  Write-Host "Missing venv. Run:" -ForegroundColor Red
  Write-Host "  cd apps/api" -ForegroundColor Gray
  Write-Host "  python -m venv .venv" -ForegroundColor Gray
  Write-Host "  .venv\Scripts\pip install -r requirements.txt" -ForegroundColor Gray
  exit 1
}

if (-not (Test-Path "$ApiRoot\.env")) {
  Write-Host "Warning: apps/api/.env not found. Copy from .env.example and fill credentials." -ForegroundColor Yellow
}

New-Item -ItemType Directory -Force -Path "$ApiRoot\logs" | Out-Null

Write-Host "Clearing stale listeners on port 8000..." -ForegroundColor Green
Stop-PortListener -Port 8000
Start-Sleep -Seconds 1

Write-Host "Installing PM2 globally..." -ForegroundColor Green
npm install -g pm2 pm2-windows-startup

Write-Host "Registering PM2 to start on Windows login..." -ForegroundColor Green
pm2-startup install

Write-Host "Stopping any existing kuttiomp-api process..." -ForegroundColor Green
$prevErrorAction = $ErrorActionPreference
$ErrorActionPreference = "Continue"
pm2 delete kuttiomp-api 2>&1 | Out-Null
$ErrorActionPreference = $prevErrorAction

Set-Location $ApiRoot
pm2 start ecosystem.config.cjs
pm2 save

Write-Host "Waiting for API to become ready..." -ForegroundColor Green
$ready = $false
for ($i = 0; $i -lt 15; $i++) {
  try {
    $health = Invoke-RestMethod -Uri "http://localhost:8000/health" -TimeoutSec 3
    if ($health.status -eq "healthy") {
      $ready = $true
      break
    }
  } catch {}
  Start-Sleep -Seconds 1
}

Write-Host ""
if ($ready) {
  Write-Host "Done. API is healthy at http://localhost:8000" -ForegroundColor Green
} else {
  Write-Host "PM2 started but health check did not pass. Check: pm2 logs kuttiomp-api" -ForegroundColor Yellow
}
Write-Host "  pm2 status" -ForegroundColor Gray
Write-Host "  pm2 logs kuttiomp-api" -ForegroundColor Gray
Write-Host "  pm2 restart kuttiomp-api" -ForegroundColor Gray
Write-Host "  pm2 stop kuttiomp-api" -ForegroundColor Gray