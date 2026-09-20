# AI-JOURNAL.md — nhật ký sử dụng AI (bắt buộc, KHÔNG commit)

Quy tắc ghi nhật ký minh bạch phần nào do AI sinh, phần nào SV (Khanh) tự chỉnh. **Mọi agent** (Claude Code / Codex / Copilot / Cursor) đọc file này và tuân thủ.

## 1. Nơi ghi

`.ai-journal/YYYY-MM.md` — 1 file / tháng, đã `.gitignore` (**KHÔNG commit, KHÔNG push**). File quy tắc này thì commit; dữ liệu nhật ký thì không.

> ⚠ Vì nằm ngoài git, thư mục này **không có backup**. `git clean -fdx` sẽ xoá sạch — sao lưu ra ngoài repo trước khi chạy lệnh đó.

## 2. Khi nào ghi

**Mỗi lần AI sinh code đáng kể** — tức mỗi lượt làm việc có tạo/sửa file nguồn (module, service, schema, migration, test, config CI…). Không ghi cho: đọc file, chạy lệnh, trả lời câu hỏi thuần tuý, sửa chính nhật ký.

## 3. Cách ghi — dùng lệnh, KHÔNG mở file

Agent **không đọc, không mở, không sửa tay** file nhật ký. Chỉ chạy:

```bash
node .claude/hooks/ai-journal.mjs add "<Mảng kỹ thuật>" "<AI sử dụng>" "<Mục đích>" "<Phần AI sinh>" "" "<Nhận xét>"
```

Script tự tạo mục ngày, tự append vào cuối, tự escape ký tự `|`. Nhờ vậy nhật ký **chỉ lớn thêm, không bao giờ bị đọc lại** — dù sang tháng thứ 10 thì chi phí ghi vẫn bằng 0 token đọc, và agent không có cơ hội sửa/xoá dòng cũ.

| Cột | Ghi gì | Ví dụ |
| --- | --- | --- |
| **Mảng kỹ thuật** | Lớp/domain đụng tới | `Backend / IAM`, `DB / Prisma`, `Frontend / Operator OS`, `Mobile / Flutter`, `CI` |
| **AI sử dụng** | Tên tool + model cụ thể | `Claude Code (Opus 5)`, `GitHub Copilot`, `Codex` |
| **Mục đích** | 1 câu — vì sao dùng AI cho phần này | `Sinh khung service + guard theo LLD §4.2` |
| **Phần AI sinh** | **Đường dẫn + phạm vi**, không hơn | `apps/api/src/modules/iam/auth/*.ts — service, guard, Zod DTO` |
| **Phần SV chỉnh** | Truyền `""` — Khanh tự điền sau khi review | `Sửa lại logic rotation refresh token` |
| **Nhận xét** | Chất lượng output, lỗi phải sửa, bài học | `Bịa field không có trong schema — phải đối chiếu DB doc` |

**Giới hạn: mỗi ô một dòng, tối đa 300 ký tự** — script từ chối ghi nếu vượt. Đây là thứ chặn việc dán cả block mã nguồn vào cột "Phần AI sinh": nhật ký là **mục lục** trỏ tới code, không phải bản sao của code. Chi tiết dài → trỏ tới commit hoặc file.

Cấu trúc file sinh ra (hook tự lo, agent không cần biết):

```markdown
## 20/09/2026

| Mảng kỹ thuật | AI sử dụng | Mục đích | Phần AI sinh | Phần SV chỉnh | Nhận xét |
| --- | --- | --- | --- | --- | --- |
```

## 4. Luật cho agent

1. **Append-only qua lệnh `add`** (mục 3). KHÔNG `Read`/`cat` file nhật ký, KHÔNG sửa hay xoá dòng cũ — kể cả dòng chính mình vừa ghi sai (ghi dòng mới đính chính, để Khanh tự dọn).
2. **KHÔNG dán mã nguồn** vào bất kỳ ô nào. "Phần AI sinh" = đường dẫn + phạm vi. Trần 300 ký tự/ô.
3. **KHÔNG bịa cột "Phần SV chỉnh" và "Nhận xét"**. Agent không biết Khanh sẽ sửa gì → truyền `""`, script tự điền `⟨chờ SV điền⟩`. Hai cột này là phần Khanh tự chịu trách nhiệm học thuật.
4. **Ghi đúng model mình đang chạy**, không ghi chung chung "AI".
5. **KHÔNG commit `.ai-journal/`**, kể cả khi Khanh yêu cầu commit phần còn lại.
6. Chỉ **agent chính** ghi nhật ký. Subagent không tự ghi (tránh ghi đè); agent chính gộp lại và nêu tên subagent đã dùng trong cột "AI sử dụng".

## 5. Cưỡng chế (chỉ Claude Code)

`.claude/settings.json` cài 2 hook chạy `.claude/hooks/ai-journal.mjs`:

- **SessionStart** — tạo file tháng + mục ngày hôm nay, nhắc luật vào context.
- **Stop** — so trạng thái git (`HEAD` + working tree) với mốc lần ghi nhật ký gần nhất. Nếu code đã đổi mà số dòng nhật ký không tăng → **chặn kết thúc lượt** kèm hướng dẫn. Chặn tối đa 1 lần/lượt (lần sau chỉ cảnh báo) để không lặp vô hạn. Không phải git repo / lỗi nội bộ → bỏ qua, không chặn nhầm.

Thay đổi không phải code do AI sinh (sửa doc, sửa chính nhật ký) thì bỏ qua mốc bằng:

```bash
node .claude/hooks/ai-journal.mjs skip "lý do cụ thể"
```

Mỗi lần skip được ghi vào `.ai-journal/.state/skips.log` để đối chiếu.

Codex / Copilot / Cursor **không có hook** — chỉ tuân theo mục 1-4 qua `AGENTS.md` / `.github/copilot-instructions.md`.
