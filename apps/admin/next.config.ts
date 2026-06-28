import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  transpilePackages: ["@kuttiomp/database", "@kuttiomp/types", "@kuttiomp/ui", "@kuttiomp/validation"],
  env: {
    NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL,
    NEXT_PUBLIC_ADMIN_URL: process.env.NEXT_PUBLIC_ADMIN_URL,
  },
  outputFileTracingIncludes: {
    "/knowledge-keepers-guide": ["../../docs/KNOWLEDGE_KEEPERS_GUIDE.md"],
    "/docs/knowledge-keepers": ["../../docs/KNOWLEDGE_KEEPERS_GUIDE.md"],
  },
  async redirects() {
    return [
      {
        source: "/docs/knowledge-keepers",
        destination: "/knowledge-keepers-guide",
        permanent: true,
      },
    ];
  },
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