const path = require("path");

const root = __dirname;
const uvicorn = path.join(root, ".venv", "Scripts", "uvicorn.exe");
const logs = path.join(root, "logs");

module.exports = {
  apps: [
    {
      name: "kuttiomp-api",
      cwd: root,
      script: uvicorn,
      args: "app.main:app --host 0.0.0.0 --port 8000",
      interpreter: "none",
      autorestart: true,
      max_restarts: 15,
      min_uptime: "10s",
      restart_delay: 3000,
      kill_timeout: 5000,
      env: {
        PYTHONUNBUFFERED: "1",
      },
      error_file: path.join(logs, "pm2-error.log"),
      out_file: path.join(logs, "pm2-out.log"),
      merge_logs: true,
      time: true,
    },
  ],
};