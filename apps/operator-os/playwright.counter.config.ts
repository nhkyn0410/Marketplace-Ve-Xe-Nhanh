import { defineConfig } from "@playwright/test";

// Kiểm luồng giao diện bằng API giả định danh rõ ràng; không seed hoặc dùng database của worktree khác.
export default defineConfig({
  testDir: "./e2e-mocked",
  testMatch: /counter\.e2e\.ts$/,
  timeout: 60_000,
  workers: 1,
  reporter: [["list"]],
  use: { baseURL: "http://127.0.0.1:3152", channel: process.env.PLAYWRIGHT_CHANNEL || undefined, trace: "retain-on-failure" },
  webServer: {
    command: "pnpm exec next dev --hostname 127.0.0.1 --port 3152",
    url: "http://127.0.0.1:3152",
    reuseExistingServer: false,
    timeout: 180_000,
    env: { NEXT_PUBLIC_API_BASE_URL: "http://127.0.0.1:3152/v1" },
  },
});
