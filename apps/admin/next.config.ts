import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  transpilePackages: ["@kuttiomp/database", "@kuttiomp/types", "@kuttiomp/ui"],
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