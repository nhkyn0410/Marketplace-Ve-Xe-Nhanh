# TASK-ADM-003 (phần ảnh xe) — Todo: Admin rà soát / gỡ ảnh phương tiện

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` — `TASK-ADM-003` "… rà soát + gỡ ảnh phương tiện vi phạm (`/admin/vehicle-images`, lý do + audit) …". Nguồn chi tiết: SRS `FR-ADM-20`, `BR-76`, `UC-28` A6; LLD §6.12 bước 7, §9; API §7.5; Security §7 dòng Ảnh phương tiện, §8 "Gỡ ảnh phương tiện vi phạm"; Figma section `Giao diện Admin` (`1663:23890`): `ADM-10b` Ảnh phương tiện (`1675:36918`), `ADM-10c` Hộp thoại gỡ ảnh (`1675:37285`).
> **Khanh (16/10/2026):** "Tiến tới hoàn thiện admin giúp tôi" → A5 trong thứ tự A1…A7 (`ADM-001-todo.md`): kiểm duyệt ảnh xe + nhật ký audit (`ADM-002-audit-log-todo.md`).
> **Nhánh:** làm tiếp trên `TASK-ADM-004` (chung với A3, A4 — chưa commit). Gợi ý commit tách A3 / A4 / A5.

## Trạng thái (16/10/2026) — 🔨 **Code xong, chưa commit — chờ Khanh review + CI**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).
- Không đổi schema: RLS của `vehicle_images` đã cho scope `platform` (migration `TASK-TRN-009`).
- **Chưa làm (phần còn lại của `TASK-ADM-003`):** tab Đánh giá, Nội dung công khai (review, báo cáo vi phạm, banner, FAQ, trang tĩnh) — Figma ghi chú nhóm: trường / trạng thái / API chưa có trong tài liệu.

## Đã làm

### Backend (`apps/api/src/vehicle/admin-vehicle-image.*`)

- **Quyền mới `content:moderate`** (chỉ `PLATFORM_ADMIN`, phạm vi `any`).
- `GET /admin/vehicle-images` — ảnh của mọi nhà xe, mới tải lên trước, lọc `operatorId` / `uploadedSince`, cursor `{createdAt}_{id}`, `limit` ≤ 48; mỗi ảnh kèm URL, chú thích, vị trí, `isCover` (vị trí nhỏ nhất của xe), biển số, tên nhà xe; trả thêm `total` và `operators` (nhà xe đang có ảnh — lựa chọn của ô lọc).
- `POST /admin/vehicle-images/{imageId}/remove` — lý do 3–500 ký tự; một transaction khóa dòng xe (như lần nhà xe thay bộ ảnh), xóa dòng ảnh, ghi audit `vehicle_image.remove` (trước: xe, biển số, khóa object, vị trí, chú thích; lý do) TRONG transaction — audit lỗi → 503, ảnh còn nguyên. Sau commit: xóa object (lỗi để job dọn object mồ côi lo), email báo chủ nhà xe (lỗi chỉ ghi log). Trả 204; ảnh không còn → 404 `VEHICLE_IMAGE_NOT_FOUND`.
- Nhà xe đang giữ ảnh vừa bị gỡ trong danh sách gửi lên (`PUT …/images`) nhận 422 `VEHICLE_IMAGE_INVALID` — không gắn lại được ảnh đã gỡ.
- Email `EmailNotifier.sendVehicleImageRemoved` (Resend + bộ ghi log dev).
- Seed E2E: một nhà xe riêng có xe hai ảnh (file PNG thật ở kho local) + tài khoản Admin `platformModeration`; seed đặt lại thêm bộ đếm đăng nhập theo IP (`login:ip:*`) của Redis local — chạy lại E2E nhiều lượt trong một giờ không còn bị "Bạn đã thử quá nhiều lần".

### Admin (`apps/admin`) — theo Figma ADM-10b / 10c

- `/moderation` (mục "Kiểm duyệt" trên thanh bên): tab Ảnh phương tiện; lưới thẻ ảnh 4 cột (ảnh, nhà xe, biển số · chú thích, thời điểm tải lên, nút "Gỡ ảnh"), lọc Nhà xe / Thời gian tải lên (mặc định 7 ngày), "Tải thêm", dải ghi chú cuối trang.
- Hộp thoại gỡ ảnh: dòng phụ "nhà xe · xe … · “chú thích”", ảnh thu nhỏ + thời điểm tải lên, cảnh báo không khôi phục được, Lý do bắt buộc (3–500), nút đỏ "Gỡ ảnh"; gỡ xong báo "Đã gỡ ảnh của xe …".

## Chờ Khanh (G1–G7)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Quyền | Thêm `content:moderate` (PLATFORM_ADMIN). PLATFORM_SUPPORT không có (giữ giả định "chỉ đọc / giám sát") | Duyệt tên quyền; có cho Hỗ trợ nền tảng gỡ ảnh không |
| G2 | Hợp đồng API | Danh sách thêm `uploadedSince`, `total`, `operators`, `isCover`; gỡ trả 204, lý do 3–500 (Figma) | Duyệt |
| G3 | Gỡ là xóa hẳn | Xóa dòng + object (LLD §6.12 bước 7), không khôi phục; không đánh số lại vị trí — ảnh kế tiếp tự thành ảnh đại diện | Xác nhận |
| G4 | Thông báo nhà xe | Email tới mọi Owner đang hoạt động có email liên hệ (như `ADM-004` G4) — chỉ gửi thật sau khi cấu hình Resend; chưa có thông báo trong ứng dụng | Xác nhận |
| G5 | Tab Đánh giá / Nội dung công khai | Hiện nhưng khóa ("Chưa có trong bản này") để giữ bố cục Figma | Giữ, hay ẩn hẳn tới khi làm |
| G6 | Nhãn "Ảnh đại diện" trên thẻ | Thêm (Figma không có) — gỡ ảnh đại diện làm đổi ảnh ở kết quả tìm | Giữ hay bỏ |
| G7 | Xác nhận lại danh tính | Không đòi TOTP (Figma ADM-10c không có ô TOTP) | Xác nhận |

## Kiểm tra (16/10/2026)

- API trên Postgres thật, role app: `admin-vehicle-image.int.spec.ts` 4 ca (danh sách mọi nhà xe + lọc + cursor + ảnh đại diện + ô lọc nhà xe; gỡ ảnh xóa dòng + object, audit kèm lý do trong transaction, email chủ nhà xe, gỡ lần nữa 404; nhà xe gửi lại ảnh đã gỡ → 422; audit lỗi → 503 ảnh và object còn nguyên, email lỗi không làm hỏng việc gỡ), `admin-vehicle-image.http.spec.ts` 4 ca (guard thật: không token 401, chủ nhà xe / hỗ trợ nền tảng 403; validate), email Resend escape HTML.
- Toàn bộ API: 98 file / 1237 test — 1236 đạt; 1 ca `mfa.int.spec.ts` (trần lần sai TOTP) hết giờ 5 giây khi chạy cả bộ cùng lúc với API E2E, chạy riêng 15/15 đạt — không liên quan thay đổi này.
- Gốc repo: lint 9/9, typecheck 11/11; test Admin 23, Operator OS 409; build production Admin + Operator OS + API đạt.
- E2E Admin **16/16** (mới `moderation-audit.e2e.ts` ca 1: lọc theo nhà xe, gỡ thiếu lý do báo tại ô, gỡ có lý do → ảnh biến mất, ảnh còn lại thành ảnh đại diện). E2E Operator OS **36/36**.
- Client Dart: 0 lỗi analyzer, 1012 test đạt.
- Đối chiếu Figma ADM-10b / 10c ở 1440 px; 390 px không tràn ngang.

## Việc tiếp theo

1. Khanh review, chốt G1–G7; commit.
2. Phần còn lại của `TASK-ADM-003` khi có thiết kế dữ liệu review / FAQ / banner.
