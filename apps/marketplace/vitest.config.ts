import { defineConfig } from "vitest/config";

// Kiểm thử component bằng JSX tự động; giữ nguyên chế độ preserve cho Next.js.
export default defineConfig({
  oxc: { jsx: { runtime: "automatic" } }
});
