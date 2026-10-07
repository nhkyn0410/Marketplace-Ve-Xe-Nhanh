import { defineConfig } from "@playwright/test";

// E2E web auth (TASK-IAM-006, TC-SEC-008). API phải chạy sẵn ở http://localhost:3000 với DB đã migrate
// (xem doc/task-propreties/IAM-006-guide.md §3); Playwright tự bật Next dev ở 3002 nếu chưa chạy.
// Local có Chrome: đặt PLAYWRIGHT_CHANNEL=chrome để khỏi tải Chromium của Playwright.
export default defineConfig({
  testDir: "./e2e",
  testMatch: /.*\.e2e\.ts$/,
  globalSetup: "./e2e/global-setup.ts",
  timeout: 60_000,
  workers: 1,
  reporter: [["list"]],
  use: {
    baseURL: "http://localhost:3002",
    channel: process.env.PLAYWRIGHT_CHANNEL || undefined,
    trace: "retain-on-failure"
  },
  webServer: {
    command: "pnpm dev",
    url: "http://localhost:3002",
    reuseExistingServer: true,
    timeout: 180_000,
    // Bật các khối bản đồ (TASK-TRN-014). Khóa giả là đủ vì spec thay bản đồ nền bằng nền trống
    // (`stubMapTiles`). Máy chủ dev chạy sẵn mà không có khóa thì các ca bản đồ tự bỏ qua.
    env: { NEXT_PUBLIC_GOONG_MAPTILES_KEY: process.env.NEXT_PUBLIC_GOONG_MAPTILES_KEY ?? "e2e-map-key" }
  }
});
