#!/usr/bin/env node
// Nhat ky su dung AI — hook cuong che ghi nhat ky. Quy tac: doc/AI-JOURNAL.md
// Dung: node .claude/hooks/ai-journal.mjs <session-start|stop|skip> ["ly do"]
// Fail-open: moi loi noi bo deu thoat 0, khong bao gio chan nham.
import { execFileSync } from "node:child_process";
import { createHash } from "node:crypto";
import {
  appendFileSync,
  existsSync,
  mkdirSync,
  readdirSync,
  readFileSync,
  writeFileSync,
} from "node:fs";
import { join } from "node:path";

const COLS = [
  "Mảng kỹ thuật",
  "AI sử dụng",
  "Mục đích",
  "Phần AI sinh",
  "Phần SV chỉnh",
  "Nhận xét",
];
const HEADER = `| ${COLS.join(" | ")} |`;
const SEPARATOR = "| --- | --- | --- | --- | --- | --- |";
/** Tran do dai moi o — chan viec dan ca block ma nguon vao nhat ky. */
const MAX_CELL = 300;

const mode = process.argv[2];
const input = readStdinJson();
const root = process.env.CLAUDE_PROJECT_DIR || input.cwd || process.cwd();
const dir = join(root, ".ai-journal");
const stateDir = join(dir, ".state");
const baselineFile = join(stateDir, "baseline.json");

try {
  if (mode === "session-start") sessionStart();
  else if (mode === "stop") stop();
  else if (mode === "skip") skip();
  else if (mode === "add") add();
} catch (err) {
  // `add` do agent goi truc tiep -> phai bao loi; hook thi fail-open.
  if (mode === "add") fail(`Lỗi ghi nhật ký: ${err.message}`);
}
process.exit(0);

// ---------------------------------------------------------------- commands

function sessionStart() {
  // eslint-disable-next-line no-unused-vars
  const file = ensureTodaySection();
  if (!existsSync(baselineFile)) writeBaseline(gitState(), countRows());
  emit({
    hookSpecificOutput: {
      hookEventName: "SessionStart",
      additionalContext:
        `NHẬT KÝ AI (bắt buộc, KHÔNG commit) — quy tắc đầy đủ: doc/AI-JOURNAL.md.\n` +
        `Mỗi lần sinh/sửa code đáng kể, ghi 1 dòng bằng lệnh sau — KHÔNG đọc, KHÔNG mở, KHÔNG sửa tay file nhật ký:\n` +
        `  node .claude/hooks/ai-journal.mjs add "<${COLS.join('>" "<')}>"\n` +
        `Mỗi ô ≤ ${MAX_CELL} ký tự, một dòng. "Phần AI sinh" = đường dẫn + phạm vi, TUYỆT ĐỐI không dán mã nguồn.\n` +
        `"Phần SV chỉnh" để chuỗi rỗng "" (Khanh tự điền). Hook Stop sẽ CHẶN kết thúc lượt nếu code đổi mà chưa ghi.`,
    },
  });
}

function stop() {
  const cur = gitState();
  const base = readBaseline();
  const rows = countRows();

  if (cur === null) return; // khong phai git repo -> bo qua
  if (!base) return writeBaseline(cur, rows);
  if (cur === base.state) return; // khong co thay doi code moi
  if (rows > base.rows) return writeBaseline(cur, rows); // da ghi nhat ky

  if (input.stop_hook_active) {
    // Da chan 1 lan roi — canh bao thay vi lap vo han. Giu nguyen baseline
    // de luot sau van chan.
    return emit({
      systemMessage:
        "⚠ Nhật ký AI chưa được ghi cho thay đổi code lần này (.ai-journal/). Ghi bù trước khi tiếp tục.",
    });
  }

  emit({
    decision: "block",
    reason:
      `Code trong repo đã thay đổi nhưng chưa có dòng nhật ký AI mới.\n` +
      `Chạy lệnh này — KHÔNG đọc, KHÔNG mở, KHÔNG sửa tay file nhật ký:\n` +
      `  node .claude/hooks/ai-journal.mjs add "<${COLS.join('>" "<')}>"\n` +
      `- Mảng kỹ thuật: vd "Backend / IAM", "DB / Prisma", "CI".\n` +
      `- AI sử dụng: tên + model cụ thể (vd "Claude Code (Opus 5)").\n` +
      `- Mục đích: 1 câu, vì sao dùng AI cho phần này.\n` +
      `- Phần AI sinh: ĐƯỜNG DẪN + phạm vi vừa sinh/sửa. TUYỆT ĐỐI không dán mã nguồn.\n` +
      `- Phần SV chỉnh: truyền chuỗi rỗng "" — Khanh tự điền, KHÔNG bịa.\n` +
      `- Nhận xét: chất lượng output, lỗi phải sửa, bài học.\n` +
      `Mỗi ô một dòng, ≤ ${MAX_CELL} ký tự.\n` +
      `Nếu thay đổi KHÔNG phải code do AI sinh (sửa doc, sửa chính nhật ký), chạy:\n` +
      `  node .claude/hooks/ai-journal.mjs skip "lý do cụ thể"`,
  });
}

/**
 * Append 1 dong nhat ky tu dong lenh — agent KHONG can doc/mo file nhat ky.
 * node .claude/hooks/ai-journal.mjs add "<mang>" "<ai>" "<muc dich>" "<AI sinh>" "<SV chinh>" "<nhan xet>"
 */
function add() {
  const cells = process.argv.slice(3);
  if (cells.length !== 6) {
    return fail(
      `Cần đúng 6 tham số theo thứ tự: ${COLS.join(" | ")}\n` +
        `Ví dụ: node .claude/hooks/ai-journal.mjs add "Backend / IAM" "Claude Code (Opus 5)" ` +
        `"Sinh service đăng nhập theo LLD §4.2" "apps/api/src/modules/iam/auth/*.ts — service, guard, Zod DTO" "" ` +
        `"Bịa field ngoài schema, phải sửa tay"`,
    );
  }
  const clean = cells.map((c) =>
    String(c)
      .replace(/\r?\n/g, " · ")
      .split("|")
      .join("\\|") // escape Markdown — giu nguyen nghia, khong vo bang
      .trim(),
  );
  if (!clean[4]) clean[4] = "⟨chờ SV điền⟩";

  const over = clean.findIndex((c) => c.length > MAX_CELL);
  if (over >= 0) {
    return fail(
      `Cột "${COLS[over]}" dài ${clean[over].length} ký tự (tối đa ${MAX_CELL}).\n` +
        `Nhật ký chỉ ghi ĐƯỜNG DẪN + PHẠM VI, KHÔNG dán mã nguồn. Tóm tắt ngắn lại rồi chạy lại.`,
    );
  }

  const file = ensureTodaySection();
  appendFileSync(file, `| ${clean.join(" | ")} |\n`, "utf8");
  process.stdout.write(
    `Đã ghi 1 dòng nhật ký vào ${rel(file)} (mục ${today()}).\n`,
  );
}

function fail(message) {
  process.stderr.write(`${message}\n`);
  process.exit(1);
}

function skip() {
  const reason = process.argv.slice(3).join(" ").trim() || "(không nêu lý do)";
  mkdirSync(stateDir, { recursive: true });
  appendFileSync(
    join(stateDir, "skips.log"),
    `${new Date().toISOString()}\t${reason}\n`,
    "utf8",
  );
  writeBaseline(gitState(), countRows());
  emit({ systemMessage: `Nhật ký AI: bỏ qua 1 lần — ${reason}` });
}

// ----------------------------------------------------------------- helpers

function readStdinJson() {
  try {
    return JSON.parse(readFileSync(0, "utf8"));
  } catch {
    return {};
  }
}

function pad(n) {
  return String(n).padStart(2, "0");
}

function today() {
  const d = new Date();
  return `${pad(d.getDate())}/${pad(d.getMonth() + 1)}/${d.getFullYear()}`;
}

function monthFile() {
  const d = new Date();
  return join(dir, `${d.getFullYear()}-${pad(d.getMonth() + 1)}.md`);
}

function rel(p) {
  return p.slice(root.length + 1).replaceAll(String.fromCharCode(92), "/");
}

/** Tao file thang + muc ngay hom nay neu chua co. Tra ve duong dan file. */
function ensureTodaySection() {
  const file = monthFile();
  mkdirSync(dir, { recursive: true });
  const d = new Date();
  if (!existsSync(file)) {
    writeFileSync(
      file,
      `# Nhật ký sử dụng AI — ${d.getFullYear()}-${pad(d.getMonth() + 1)}\n\n` +
        `> KHÔNG commit (đã gitignore). Quy tắc + template: \`doc/AI-JOURNAL.md\`.\n`,
      "utf8",
    );
  }
  const text = readFileSync(file, "utf8");
  if (!text.includes(`## ${today()}`)) {
    appendFileSync(
      file,
      `\n## ${today()}\n\n${HEADER}\n${SEPARATOR}\n`,
      "utf8",
    );
  }
  return file;
}

/** Dem so dong du lieu trong moi bang nhat ky (bo header + dong ke). */
function countRows() {
  if (!existsSync(dir)) return 0;
  let n = 0;
  for (const name of readdirSync(dir)) {
    if (!name.endsWith(".md")) continue;
    for (const line of readFileSync(join(dir, name), "utf8").split("\n")) {
      const t = line.trim();
      if (!t.startsWith("|")) continue;
      if (/^\|[\s|:-]*$/.test(t)) continue;
      if (t === HEADER) continue; // khop chinh xac — dong du lieu co the chua ten cot
      n += 1;
    }
  }
  return n;
}

/** Hash trang thai working tree + HEAD. null neu khong phai git repo. */
function gitState() {
  try {
    const git = (args) =>
      execFileSync("git", args, {
        cwd: root,
        encoding: "utf8",
        stdio: ["ignore", "pipe", "ignore"],
      });
    return createHash("sha1")
      .update(
        git(["rev-parse", "HEAD"]).trim() +
          "\n" +
          git(["status", "--porcelain"]),
      )
      .digest("hex");
  } catch {
    return null;
  }
}

function readBaseline() {
  try {
    return JSON.parse(readFileSync(baselineFile, "utf8"));
  } catch {
    return null;
  }
}

function writeBaseline(state, rows) {
  mkdirSync(stateDir, { recursive: true });
  writeFileSync(
    baselineFile,
    JSON.stringify({ state, rows, ts: Date.now() }),
    "utf8",
  );
}

function emit(obj) {
  process.stdout.write(JSON.stringify(obj));
}
