import { SignUp } from "@clerk/nextjs";

export default function SignUpPage() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-kuttiomp-mist">
      <div className="text-center space-y-6">
        <div>
          <h1 className="font-serif text-3xl text-kuttiomp-bark">Kuttiomp</h1>
          <p className="text-sm text-muted-foreground mt-1">
            Narragansett Language Revitalization
          </p>
        </div>
        <SignUp />
      </div>
    </div>
  );
}