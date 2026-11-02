# TASK-ADM-002 (phần audit) — Todo: màn Nhật ký audit của Admin

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` — `TASK-ADM-002` "Admin payment/refund/payout confirm/dispute/audit" (phần audit làm trước; thanh toán / hoàn tiền / chi trả / tranh chấp chờ `TASK-BTP-005`). Nguồn chi tiết: SRS `FR-ADM-16`, `UC-30`, `BR-58`, `NFR-AUDIT-03`; LLD §9; DB Mongo `audit_event` (ADR-011); API §7.5 `/admin/audit-logs`; Security §7 dòng Audit log, §10; Figma section `Giao diện Admin` (`1663:23890`): `ADM-15a` Tìm kiếm (`1677:39740`), `ADM-15b` Chi tiết bản ghi (`1677:40148`).
> **Khanh (16/10/2026):** "Tiến tới hoàn thiện admin giúp tôi" → A5 = kiểm duyệt ảnh xe (`ADM-003-vehicle-images-todo.md`) + nhật ký audit (file này).
> **Nhánh:** làm tiếp trên `TASK-ADM-004`, chưa commit.

## Trạng thái (16/10/2026) — 🔨 **Code xong, chưa commit — chờ Khanh review + CI**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).
- Không đổi schema Mongo; chỉ thêm truy vấn đọc vào `AuditService`.
- **Chưa làm:** "Xuất nhật ký" (G6).

## Đã làm

### Backend (`apps/api/src/audit/`)

- `AuditService` thêm `searchAuditEvents` / `countAuditEvents` / `findAuditEvent` / `listTargetAuditEvents` (đọc toàn hệ thống — chỉ gọi từ route Admin phạm vi `any`) và `isFailureAction` (quy ước tên hành động thất bại).
- `AdminAuditLogModule` (tách khỏi `AuditModule` vì `IamModule` dùng `AuditModule`), quyền `audit:read` có sẵn (PLATFORM_ADMIN):
  - `GET /admin/audit-logs` — mới nhất trước, cursor `{createdAt}_{ObjectId}`, `limit` ≤ 100, `total`; lọc `from` / `to`, `actorType` (Nền tảng / Chủ nhà xe / Nhân viên / Hành khách / Hệ thống), `module` (phân hệ = nhóm tiền tố hành động), `result`; tìm `q` = đúng mã đối tượng HOẶC tài khoản (`platform/khanh`, `saoviet/owner01`, `saoviet/`, một phần tên, email hành khách). Mỗi dòng: người thực hiện (tên đăng nhập tra từ Postgres; hành khách hiện email đã che), vai trò, phân hệ, kết quả, đối tượng, nhà xe, lý do.
  - `GET /admin/audit-logs/{id}` — thêm trước / sau (che ở server), IP đã che + thiết bị (sự kiện đăng nhập có ghi), mã yêu cầu, chuỗi tối đa 20 bản ghi cùng đối tượng; mỗi lượt mở ghi `audit.event.view` (lỗi ghi không chặn việc xem). Id lạ → 404 `AUDIT_LOG_NOT_FOUND`; Mongo không phản hồi → 503.
- Che theo tên trường, đệ quy: email, số điện thoại, số tài khoản (giữ 4 số cuối), IP, user-agent → nhãn thiết bị, trường bí mật (`password` / `secret` / `token` / `otp` / `hash`) → "[đã ẩn]".

### Admin (`apps/admin`) — theo Figma ADM-15a / 15b

- `/audit-logs`: bảng Thời điểm (giờ VN, có giây) / Người thực hiện + vai trò / Hành động (nhãn tiếng Việt, hành động lạ hiện mã) / Đối tượng + mã / Nhà xe / Kết quả / "Xem"; lọc Khoảng thời gian (mặc định 7 ngày), Loại người thực hiện, Phân hệ, Kết quả, ô tìm; "Đã tải 7 / 1.284 bản ghi", "Tải thêm".
- `/audit-logs/{id}`: tiêu đề = hành động, dòng phụ thời điểm · người thực hiện, nhãn kết quả; thẻ Trước và sau (trường đổi in đậm), Lý do và ghi chú, Chuỗi bản ghi liên quan (bấm sang bản ghi khác), Tóm tắt (người thực hiện, vai trò, phân hệ, hành động, đối tượng, nhà xe, IP, thiết bị, mã yêu cầu), ghi chú "Lượt xem chi tiết này đã được ghi vào nhật ký audit".

## Chờ Khanh (G1–G8)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Hợp đồng API | API §7.5 chỉ ghi `GET /admin/audit-logs`; định nghĩa query / response và thêm `GET /admin/audit-logs/{id}` (chi tiết + chuỗi bản ghi) | Duyệt |
| G2 | "Kết quả" | Audit chưa có trường kết quả → suy từ tên hành động (`….failure`, `…failed`, `….rate_limited`, `….reuse_detected`, `….locked` = Thất bại). Thao tác bị từ chối quyền (403) không ghi audit nên chưa có "Bị từ chối" như Figma | Có thêm trường `result` + ghi lần bị từ chối không (đổi schema audit) |
| G3 | IP / thiết bị / cách xác nhận lại danh tính | Chỉ sự kiện đăng nhập / phiên / xác thực hai lớp có IP + user-agent; thao tác nghiệp vụ chưa ghi (BR-58 "nếu có"). "Xác nhận lại danh tính: TOTP hợp lệ" của Figma chưa có dữ liệu | Có ghi IP / thiết bị cho mọi thao tác Admin không |
| G4 | Che dữ liệu "theo quyền" | Chỉ PLATFORM_ADMIN có `audit:read` nên một mức che duy nhất (quy tắc ở trên) | Có cần quyền xem không che (vd xem đủ số tài khoản kèm xác nhận lại danh tính) |
| G5 | Ghi lượt xem | Ghi MỌI lượt mở chi tiết (`audit.event.view`) — SRS chỉ nói "nếu thuộc nhóm nhạy cảm" mà chưa định nghĩa nhóm đó | Giữ, hay chỉ ghi với nhóm nhạy cảm (cần danh sách) |
| G6 | "Xuất nhật ký" | **Chưa làm**: định dạng tệp, thời hạn lưu audit, giới hạn / tác vụ nền xuất (UC-30 A4) chưa có trong tài liệu (ghi chú nhóm Figma) | Chốt định dạng (CSV?), giới hạn số dòng, có cần tác vụ nền |
| G7 | Tên đối tượng | Hiện loại + mã (id); Figma hiện mã nghiệp vụ ("Hồ sơ OA-2026-0431", "Chi trả PO-…") — audit chỉ lưu id, tra mã theo từng loại phải đọc từng bảng | Có cần tra mã nghiệp vụ không |
| G8 | Danh sách nhiều sự kiện đăng nhập | Mọi sự kiện đăng nhập / phiên / xác thực hai lớp đều hiện (lọc "Phân hệ" để gọn) | Giữ, hay mặc định ẩn phân hệ Đăng nhập & phiên |

## Kiểm tra (16/10/2026)

- `admin-audit-log.int.spec.ts` 4 ca trên Mongo + Postgres thật (bản ghi thử ở một giờ ngẫu nhiên năm 2001 vì collection chỉ ghi thêm): danh sách mới nhất trước + tên đăng nhập + nhà xe + kết quả + tác vụ nền + cursor + tổng; lọc loại người thực hiện / phân hệ / kết quả, tìm theo tài khoản / `slug/` / mã đối tượng, `%` không khớp tất cả; chi tiết che email / số tài khoản / bí mật / IP, thiết bị, chuỗi bản ghi, lượt xem được ghi, id lạ 404; quy tắc che đệ quy. `admin-audit-log.http.spec.ts` 3 ca (guard thật 401 / 403 cho chủ nhà xe và hỗ trợ nền tảng; validate cursor / loại / phân hệ / kết quả / id).
- E2E `moderation-audit.e2e.ts` ca 2: sau khi gỡ ảnh, lọc Phân hệ "Phương tiện" + tìm tài khoản ra đúng một dòng "Gỡ ảnh phương tiện" (đúng người thực hiện, nhà xe, Thành công); chi tiết có lý do, `plateNumber` / `caption` ở Trước, chuỗi bản ghi; lượt xem hiện ở phân hệ "Nhật ký audit".
- Đối chiếu Figma ADM-15a / 15b ở 1440 px; 390 px không tràn ngang (bảng cuộn trong khung).

## Việc tiếp theo

1. Khanh review, chốt G1–G8.
2. A6 — Chính sách + khung giá (phần còn lại của `TASK-ADM-001`).
