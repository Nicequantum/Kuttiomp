import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  transpilePackages: ["@kuttiomp/database", "@kuttiomp/types", "@kuttiomp/ui", "@kuttiomp/validation"],
  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "tumwmmnvadrqfbkktcgc.supabase.co",
      },
    ],
  },
};

export default nextConfig;