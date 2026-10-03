// Dev runner cho apps/api — THAY THẾ `tsx watch`.
//
// Vì sao không dùng tsx: tsx chạy trên esbuild, mà esbuild không hỗ trợ `emitDecoratorMetadata`.
// Thiếu `design:paramtypes` thì tham số constructor **suy theo kiểu** nhận `undefined`, trong khi
// tham số có `@Inject(TOKEN)` tường minh và provider `useFactory` + `inject: [...]` vẫn đúng.
// Nest KHÔNG ném lỗi, app vẫn boot — nên biểu hiện là **hỏng một nửa và im lặng**: mở được
// Swagger UI (file tĩnh) nhưng gọi endpoint là `TypeError: Cannot read properties of undefined`.
// Đã đo 09/09/2026: tsc → OK, vitest 4 (rolldown/oxc) → OK, tsx (esbuild) → HỎNG.
// `assertDecoratorMetadata()` ở main.ts/worker.ts chặn trường hợp này từ xa.
//
// Cách làm: build một lần, rồi `tsc --watch` biên dịch lại vào dist/ và `node --watch` chạy lại
// khi dist/ đổi. Không thêm dependency mới — chỉ dùng `typescript` và `node` có sẵn.
//
// Dùng: node scripts/dev.mjs [main|worker]
import { spawn } from "node:child_process";
import { existsSync } from "node:fs";
import { createRequire } from "node:module";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const require = createRequire(import.meta.url);
const apiRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const entry = process.argv[2] === "worker" ? "worker" : "main";
const outFile = resolve(apiRoot, "dist", `${entry}.js`);
// Gọi thẳng tsc.js bằng node: tránh shim `.cmd` trên Windows và cảnh báo deprecation của
// spawn(shell: true) khi truyền mảng args.
const tscJs = join(dirname(require.resolve("typescript")), "tsc.js");

const children = [];
let shuttingDown = false;

function shutdown(code) {
  if (shuttingDown) return;
  shuttingDown = true;
  for (const child of children) child.kill();
  process.exit(code);
}

for (const signal of ["SIGINT", "SIGTERM"]) {
  process.on(signal, () => shutdown(0));
}

/** Tiến trình chạy dài: thoát bất ngờ = dừng cả runner. */
function runLongLived(command, args, label) {
  const child = spawn(command, args, { cwd: apiRoot, stdio: "inherit" });
  child.on("exit", (code, signal) => {
    if (signal || shuttingDown) return;
    console.error(`\n[dev] ${label} thoát với mã ${code}. Dừng dev runner.`);
    shutdown(code ?? 1);
  });
  children.push(child);
}

console.log("[dev] Build lần đầu...");
// Build một lần qua pnpm (script `build` còn build cả packages/types). Truyền nguyên chuỗi lệnh
// cho shell thay vì mảng args — spawn(shell: true) + args bị Node 24 cảnh báo deprecation.
const firstBuild = spawn("pnpm run build", { cwd: apiRoot, stdio: "inherit", shell: true });

firstBuild.on("exit", (code) => {
  if (shuttingDown) return;
  if (code !== 0) {
    console.error(`[dev] Build thất bại (mã ${code}).`);
    return shutdown(code ?? 1);
  }
  if (!existsSync(outFile)) {
    console.error(`[dev] Không thấy ${outFile} sau khi build.`);
    return shutdown(1);
  }

  console.log(`[dev] Watch: tsc --watch + node --watch dist/${entry}.js`);
  runLongLived(process.execPath, [tscJs, "-p", "tsconfig.build.json", "--watch", "--preserveWatchOutput"], "tsc --watch");
  runLongLived(process.execPath, ["--watch", outFile], `node dist/${entry}.js`);
});
