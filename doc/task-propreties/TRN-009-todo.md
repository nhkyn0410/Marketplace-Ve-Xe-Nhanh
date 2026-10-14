# TASK-TRN-009 — Todo: Hình ảnh phương tiện

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` §7.3 — adapter lưu trữ `external/storage/` (R2 public; dev dùng adapter local), bảng `vehicle_images` + RLS, `POST …/images/upload-url` + `PUT …/images` (tối đa 8 ảnh, JPEG / PNG / WebP ≤ 5 MB, ảnh đầu là ảnh đại diện, chú thích ≤ 60 ký tự), job dọn object mồ côi, khối ảnh trong form xe Operator OS. Nguồn chi tiết: SRS `FR-OPS-16`, `BR-76`, `UC-12`; ADR-018; LLD §6.12, §7, `LLD-OQ-08`; DB §7 (`vehicle_images`), §8; API §7.3; UI §7; Test `TC-TRN-008..010`; Figma section `Nhà xe · Phương tiện · Shadcn/ui` khung 01, 02, 04, 08 và "Ảnh · Lỗi tại tệp" (`1106:5855`).
> **Nhánh:** `TASK-TRN-009`, tách từ nhánh `TASK-IAM-005-web` khi phần màn Nhân viên / Tài khoản **chưa commit** — cây làm việc của nhánh này đang chứa cả thay đổi của IAM-005-web (xem `IAM-005-web-todo.md`).
> **Ngoài task:** hiển thị ảnh cho khách (`vehicleCoverImageUrl`, `vehicleImages`) làm ở `TASK-TRN-004`; Admin rà soát / gỡ ảnh làm ở `TASK-ADM-003`; kho private cho KYC (OQ-21) làm ở `TASK-OPR-001`.

## Trạng thái (14/10/2026) — 🔨 **XONG BE + màn Operator OS, chưa commit — chờ Khanh review + CI**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).
- **Chưa thử với Cloudflare R2 thật** (chưa có tài khoản / bucket). Adapter R2 chỉ được kiểm bằng client giả + ký URL thật (không gọi mạng). Mọi test và E2E chạy với kho ổ đĩa local.

## Đã làm

### Backend (`apps/api`)

- **Kho object** `src/external/storage/`: port `StorageProvider` (`createUploadUrl`, `head`, `readStart`, `delete`, `list`, `publicUrl`), token `PUBLIC_STORAGE`.
  - `R2StorageProvider` — `@aws-sdk/client-s3` + `@aws-sdk/s3-request-presigner` (chỉ lệnh S3 chuẩn, ADR-018), presigned `PUT` ký kèm `Content-Type`.
  - `LocalStorageProvider` — ổ đĩa cho dev / test: URL tải lên là token HMAC có hạn, ràng đúng khóa + loại + dung lượng; hai route dev `PUT /v1/dev-storage/upload` và `GET /v1/dev-storage/public/*` (không vào OpenAPI, trả 404 khi kho là R2).
  - `StorageModule` chọn adapter theo env: đủ năm biến `R2_*` → R2; trống cả năm → ổ đĩa (`STORAGE_LOCAL_DIR`, mặc định `.storage/public`, đã `.gitignore`); khai dở → từ chối khởi động; production bắt buộc R2.
- **DB**: migration `20261014020000_add_vehicle_images` — FK ghép `(vehicle_id, operator_id)` RESTRICT, unique `object_key` và `(vehicle_id, position)`, CHECK vị trí 0–7, dung lượng 1–5.242.880, loại JPEG / PNG / WebP, chú thích 1–60 ký tự không toàn khoảng trắng; RLS `tenant_isolation`; thêm vào `RLS_TABLES`.
- **API** (`vehicle:manage`): `POST /operator/vehicles/{id}/images/upload-url`, `PUT /operator/vehicles/{id}/images`; xe (list + chi tiết) trả kèm `images`.
  - Kiểm object mới trước transaction (gọi kho là gọi mạng): tồn tại, tải lên chưa quá 23 giờ, dung lượng, `Content-Type`, chữ ký định dạng ở 12 byte đầu. Transaction khóa dòng xe `FOR NO KEY UPDATE` rồi xóa + ghi lại; ảnh giữ lại giữ nguyên `id`. Xóa object của ảnh bị bỏ **sau commit**, lỗi thì để job dọn.
  - Mọi trường hợp ảnh sai dùng chung `VEHICLE_IMAGE_INVALID` và một thông báo, không lộ lý do (LLD §7); lý do ghi log `vehicle.image.invalid`.
- **Job dọn object mồ côi**: hàng đợi BullMQ mới `storage-maintenance`, job `vehicle-image-cleanup` chạy 03:30 giờ VN mỗi ngày trong worker (ADR-024), concurrency 1. Xóa object dưới `vehicles/` cũ hơn 24 giờ không còn dòng tham chiếu. Truy vấn xuyên tenant đặt ở `src/database/vehicle-image-keys.ts` (luật ESLint chỉ cho ngữ cảnh `system` ở `database/`, `iam/`).
- **Client**: `pnpm gen:api-client` (TS) + client Dart sinh lại (558 test Dart đạt).

### Operator OS (`apps/operator-os`)

- Khối **Ảnh phương tiện** của form Thêm / Sửa xe theo Figma 02 / 04 / 08: thêm ảnh bằng nút hoặc kéo thả tệp, đổi chỗ bằng kéo thả **hoặc phím mũi tên** trên nút đổi chỗ, chú thích từng ảnh (≤ 60 ký tự), xóa; ảnh đầu ghi "Đại diện"; lỗi tại tệp theo khung "Ảnh · Lỗi tại tệp".
- Ảnh được **nén ở trình duyệt**: cạnh dài ≤ 1600 px, xuất lại JPEG (chất lượng 0,85).
- Lưu cùng nút **"Lưu phương tiện"**: lưu xe trước, rồi tải từng ảnh mới lên kho, rồi thay bộ ảnh. Ảnh tải lỗi giữ ô "Tải ảnh thất bại" + "Thử lại", ảnh khác vẫn được lưu (Figma 08, "Giữ ảnh hợp lệ khi một ảnh lỗi"). Vừa tạo xe mà còn ảnh lỗi → màn sửa nhận lại ô ảnh lỗi.
- Danh sách xe: ảnh đại diện thu nhỏ + "N ảnh" / "Chưa có ảnh" (Figma 01); ảnh lỗi tải → hình thay thế.

## Kiểm tra đã chạy (14/10/2026)

- API trên Postgres + Redis thật, role app: test mới `vehicle-image.int.spec.ts` (RLS, invariant DB, giới hạn 8 ảnh, object không có / sai loại / quá 5 MB / HTML đổi đuôi / quá cũ, hai lần thay đồng thời, ảnh bị gỡ giữa chừng, kho hỏng → 503, xóa lỗi sau commit + job dọn), unit (định dạng, bộ đếm, job dọn, adapter local, adapter R2, route dev), HTTP (route + quyền + 400). Số liệu chạy toàn bộ: xem mục "Kiểm tra cuối" bên dưới.
- Operator OS: unit `vehicle-images.test.ts`; E2E `fleet.e2e.ts` thêm 2 ca (ảnh xe đầy đủ thao tác; tạo xe kèm ảnh có một ảnh tải lỗi rồi thử lại).

## Chờ Khanh (G1–G9)

| #   | Điểm | Đã làm theo | Cần Khanh |
| --- | ---- | ----------- | --------- |
| G1  | `LLD-OQ-08` ảnh thu nhỏ | Mặc định v1 của LLD: nén ở trình duyệt, cạnh dài 1600 px. Thêm: **luôn xuất lại JPEG** — bỏ EXIF (vị trí GPS của ảnh điện thoại) trước khi ảnh thành công khai; PNG / WebP trong suốt thành nền trắng | Chốt để đóng `LLD-OQ-08` |
| G2  | Lúc nào ảnh được lưu | Theo Figma: lưu cùng nút "Lưu phương tiện" (không tự lưu từng thao tác). "Thử lại" ở ô lỗi chỉ lưu bộ ảnh | Xác nhận |
| G3  | Ảnh lỗi khi vừa tạo xe | Giữ ô lỗi trong bộ nhớ của tab khi chuyển sang màn sửa; tải lại trang thì ô lỗi mất (ảnh đã lưu vẫn còn) | Xác nhận |
| G4  | API trả thêm `objectKey` cho từng ảnh | Cần để client gửi lại ảnh giữ nguyên ở `PUT …/images`. Đã ghi vào API v0.29 | Duyệt |
| G5  | Giới hạn xin URL tải ảnh | LLD chỉ ghi "rate limit theo tài khoản": đặt **120 URL / 10 phút / tài khoản** → 429 `VEHICLE_IMAGE_UPLOAD_RATE_LIMITED` (mã lỗi mới); Redis lỗi → 503 | Duyệt con số + mã lỗi |
| G6  | Tuổi object | Chỉ gắn object tải lên < 23 giờ; job dọn object > 24 giờ không còn dòng — để job không bao giờ xóa object vừa gắn | Xác nhận |
| G7  | Dung lượng thật của file trên R2 | Presigned `PUT` của S3 / R2 không giới hạn được dung lượng; API kiểm bằng `HEAD` trước khi gắn, file quá lớn không gắn được và bị job dọn sau 24 giờ. Người có URL hợp lệ vẫn đặt được file lớn vào bucket trong thời gian đó | Chấp nhận rủi ro, hoặc chọn cách khác (vd Worker của Cloudflare chặn theo `Content-Length`) |
| G8  | Ô ảnh lỗi có nút ✕ "Bỏ ảnh" | Figma 08 không có — thêm để người dùng bỏ được ảnh không tải nổi | Xác nhận |
| G9  | **Ảnh hưởng tới deploy** | Production bắt buộc đủ năm biến `R2_*` (giống `GOONG_API_KEY`): ổ đĩa của Render mất sau mỗi lần deploy nên không được rơi về kho local. Đã khai năm biến trong `render.yaml` (API + khối worker đang tắt), dạng `sync: false` | **Trước khi merge vào nhánh deploy:** tạo bucket R2 + nhập năm biến trên Render, nếu không bản deploy mới không khởi động được |

## Việc vận hành còn thiếu trước khi dùng R2 thật

- Tạo bucket `vexenhanh-public` + custom domain / CDN; khai năm biến `R2_*` cho API **và** worker trên Render (Deploy §… — tài liệu 09 đang Approved nên chưa sửa).
- CORS của bucket: cho phép `PUT` từ origin Operator OS với header `Content-Type`.
- Thử một vòng tải lên / gắn / xóa / job dọn với R2 thật.

## Kiểm tra cuối (14/10/2026)

- API, Postgres + Redis + Mongo thật, role app: **83 file / 1102 test đạt** (migration `20261014020000_add_vehicle_images` đã áp vào DB test + `db:app-role`).
- Như CI ở gốc repo (không biến môi trường test): `pnpm lint` + `pnpm typecheck` + `pnpm test` (Operator OS 417 test, API 867 đạt / 235 bỏ qua vì cần DB) + `pnpm build` — đạt.
- E2E Operator OS (API build chạy với `RESEND_API_KEY=''`, kho ổ đĩa local): **32/32 đạt**, gồm 2 ca ảnh xe mới.
- Client Dart sinh lại: `dart analyze` 0 lỗi, 558 test đạt.
- Worker (`dist/worker.js`) khởi động sạch, lịch `vehicle-image-cleanup` đã đăng ký trên hàng đợi `storage-maintenance`.
- Sửa kèm: ba test dựng cấu hình production (`auth.service.spec.ts`, `proxy-auth.integration.spec.ts`, `web-auth.service.spec.ts`) thêm năm biến `R2_*` — vì production nay bắt buộc R2.
