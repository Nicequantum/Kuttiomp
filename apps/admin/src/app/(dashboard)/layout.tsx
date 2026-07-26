import { Sidebar } from "@/components/layout/sidebar";
import { ModeProviders } from "@/components/layout/mode-providers";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <ModeProviders>
      <div className="flex h-screen bg-background text-foreground">
        <Sidebar />
        <main className="flex-1 overflow-y-auto">{children}</main>
      </div>
    </ModeProviders>
  );
}
