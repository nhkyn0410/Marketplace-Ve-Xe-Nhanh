import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // `@vexenhanh/ui` xuất thẳng source TSX (không build) → Next phải tự biên dịch.
  transpilePackages: ["@vexenhanh/ui"]
};

export default nextConfig;
