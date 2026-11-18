import { defineConfig } from "@playwright/test";
import base from "./playwright.config";

// Kiểm giao diện bằng API giả lập, không seed DB và không gửi email thật.
export default defineConfig(base, {
  globalSetup: undefined,
  testMatch: /.*\.mock\.e2e\.ts$/,
  outputDir: "test-results/mock",
});
