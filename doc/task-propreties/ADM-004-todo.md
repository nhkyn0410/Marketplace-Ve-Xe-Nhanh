# TASK-ADM-004 — Todo: Admin quản lý điểm dừng

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` — API `/admin/stop-points` (điểm dùng chung, căn cứ công bố), `/admin/stop-point-proposals` (duyệt / từ chối, cảnh báo điểm trùng ở gần), `/admin/operator-stop-points` (xem, khóa / mở khóa) + audit + thông báo nhà xe; màn Điểm dừng ba tab (hộp thoại dùng lại bản đồ chọn tọa độ của `TASK-TRN-014`); nhập sẵn danh sách bến xe các tỉnh. Nguồn chi tiết: SRS `FR-ADM-04..05`, `FR-ADM-21`, `UC-24`, `BR-38`, `BR-81`; LLD §6.13 bước 3, 6; DB §7, §8; API §7.5; Security §7; UI §9; Test `TC-TRN-017`, `TC-TRN-018`; Figma section `Giao diện Admin` (`1663:23890`): `ADM-05a` Dùng chung (`1672:32105`), `ADM-05b` Chờ duyệt (`1672:32512`), `ADM-05c` Xem xét đề xuất (`1672:32805`), `ADM-05d` Của nhà xe (`1672:33114`), `ADM-05e` Hộp thoại khóa (`1672:33463`).
> **Nhánh:** `TASK-ADM-004` tạo từ `TASK-IAM-006-admin` (cần khung Admin). Thứ tự merge: `TASK-OPR-001` (PR #35) → `TASK-IAM-006-admin` (PR #36) → `TASK-ADM-004`.
> **Khanh (15/10/2026):** "Thực hiện" — commit / PR A1 + A2 rồi làm A3 (task này).

## Trạng thái (15/10/2026) — 🔨 **Code xong, chưa commit — chờ Khanh review + CI**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).
- Bản đồ của Admin đã chụp thử với khóa Goong của Operator OS (chỉ trong tiến trình, không ghi file); E2E chạy không có khóa (tọa độ nhập tay).
- **Chưa làm:** nhập sẵn danh sách bến xe các tỉnh (chờ Khanh cung cấp nguồn công bố).
- **Khanh chốt 15/10/2026:** G3 làm theo Figma; G4 gửi email (Khanh có tên miền, chưa cấu hình Resend) — đã làm email báo chủ nhà xe + hướng dẫn `RESEND-setup-guide.md`.

## Đã làm

### Backend (`apps/api`)

- **Migration `20261015020000_admin_stop_points`** (phần `TASK-TRN-012` để lại): `stop_points_catalog` thêm `legal_basis`; CHECK loại chỉ `BUS_STATION` / `PICKUP_POINT` / `REST_STOP`; CHECK căn cứ công bố bắt buộc với bến xe / điểm dừng đón trả, tối đa 300 ký tự; index `(province_id, type, status)`. Môi trường còn điểm loại `OFFICE` trong danh mục thì migration **dừng** (không tự xóa / đổi). Bến xe / điểm đón trả có từ trước được ghi căn cứ "Chưa khai (…)". Seed catalog dev điền căn cứ giả lập.
- **Quyền mới `catalog:manage`** (chỉ `PLATFORM_ADMIN`, phạm vi `any`) — Security §7 cột Admin của dòng Route/StopPoint.
- **10 route** (`src/stop-point/admin-stop-point.*`, scope DB `platform`, mọi thay đổi ghi audit TRONG transaction — audit lỗi → 503, không đổi gì):

| Route | Việc |
| ----- | ---- |
| `GET /admin/stop-points` | Điểm dùng chung mọi trạng thái, lọc `type` / `provinceId` / `status`, tìm `q` không dấu, mới tạo trước, cursor `{createdAt}_{id}`, kèm `routeCount` (mọi nhà xe), `provinceName`, `total` |
| `GET /admin/stop-points/{id}` | Một điểm |
| `POST /admin/stop-points` | Thêm; bến xe / điểm dừng đón trả thiếu căn cứ → 400 tại `legalBasis`; tỉnh / phường không còn hiệu lực → 422 |
| `PUT /admin/stop-points/{id}` | Thay toàn bộ, kể cả ngừng dùng (không xóa) |
| `GET /admin/stop-point-proposals` | Đề xuất của mọi nhà xe, lọc `status` / `type` / `operatorId`, kèm `operatorName` + `nearby` (điểm dùng chung cùng loại, đang hoạt động, trong 200 m — gần nhất trước, tối đa 5) |
| `GET /admin/stop-point-proposals/{id}` | Một đề xuất |
| `POST …/{id}/approve` | Body = thông tin Admin đã chỉnh; một transaction khóa dòng đề xuất, còn `PENDING` mới tạo điểm dùng chung + đặt `APPROVED` + `catalog_stop_point_id`; hai Admin duyệt cùng lúc → một 409 (TC-TRN-017) |
| `POST …/{id}/reject` | Lý do 1–500 ký tự → `REJECTED`; nhà xe sửa rồi gửi lại được |
| `GET /admin/operator-stop-points` | Điểm riêng của mọi nhà xe, lọc `operatorId` / `type` / `provinceId` / `status`, tìm `q`, kèm `operatorName`, `routeCount` |
| `POST …/{id}/suspend` · `…/unsuspend` | Khóa (lý do bắt buộc) / mở khóa → `ACTIVE` + xóa lý do; sai trạng thái → 409 `STOP_POINT_STATE_INVALID` |

- Email báo chủ nhà xe (G4): duyệt / từ chối đề xuất, khóa (kèm lý do) / mở khóa điểm riêng — Resend + bộ ghi log dev; gửi sau commit, lỗi chỉ ghi log.
- Client TS + Dart sinh lại.

### Admin (`apps/admin`) — theo Figma ADM-05a…05e

- `/stop-points` ba tab (tab nằm trên địa chỉ `?tab=`; số trên tab = tổng không lọc, "Chờ duyệt" = đề xuất đang chờ):
  - **Dùng chung:** bản đồ tổng quan đóng mở (nhớ lựa chọn), bảng tên / loại / tỉnh / căn cứ / số tuyến / trạng thái, sửa, ngừng dùng / dùng lại (hộp thoại xác nhận). Nút "Thêm điểm dừng" mở hộp thoại có bản đồ bấm / kéo ghim lấy tọa độ (không có khóa bản đồ thì nhập tay).
  - **Chờ duyệt:** lọc trạng thái (mặc định Chờ duyệt) / loại, cột cảnh báo "Điểm cùng loại cách … m", "Xem xét".
  - **Của nhà xe:** lọc loại / tỉnh / trạng thái, tìm; "Khóa" (Mức ảnh hưởng = số tuyến, lý do bắt buộc) / "Mở khóa".
- `/stop-points/proposals/{id}`: form chỉnh tên / loại / địa chỉ / tỉnh / phường / tọa độ / căn cứ, bản đồ kéo ghim vàng + điểm đã có màu xám, thẻ "Điểm cùng loại trong 200 m", dải cảnh báo trùng; "Duyệt và thêm vào danh mục" / "Từ chối" (lý do).
- Dùng chung với Operator OS (chuyển sang `packages/ui`, Operator OS giữ re-export): bản đồ chọn vị trí, bản đồ tổng quan, ghim / chú giải, `stop-map` (phần không thuộc bản đồ lộ trình), cấu hình khóa Goong, nhớ trạng thái bản đồ, dòng bảng bấm được để đưa bản đồ tới điểm. `apps/admin/.env.example` thêm `NEXT_PUBLIC_GOONG_MAPTILES_KEY`.

## Chờ Khanh (G1–G10)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Quyền | Thêm quyền `catalog:manage` (PLATFORM_ADMIN). PLATFORM_SUPPORT không có (giữ nguyên giả định "chỉ đọc / giám sát") | Duyệt tên quyền |
| G2 | Route mới ngoài API §7.5 | `GET /admin/stop-point-proposals/{id}` (trang xem xét mở lại được bằng địa chỉ); mỗi danh sách trả thêm `total` (số trên tab, "Đã tải 5 / 1.284") | Duyệt |
| G3 | Duyệt được chỉnh gì | ✅ **Khanh chốt 15/10/2026: làm theo Figma** — chỉnh được tên, loại (bến xe / điểm dừng đón trả), địa chỉ, tỉnh / phường, tọa độ, căn cứ. Đề xuất giữ tên nhà xe gửi; điểm dùng chung mang tên Admin chỉnh | — |
| G4 | Thông báo nhà xe (LLD §6.13 bước 3, 6) | ✅ **Khanh 15/10/2026: có tên miền, chưa cấu hình Resend** → làm email (cổng `EmailNotifier.sendStopPointDecision`) tới mọi Owner đang hoạt động có email liên hệ khi duyệt / từ chối đề xuất, khóa / mở khóa điểm riêng; gửi SAU commit, lỗi chỉ ghi log. Email thật tới nhà xe chỉ đi được sau khi xác minh tên miền — `RESEND-setup-guide.md` | Cấu hình Resend theo hướng dẫn |
| G5 | Mã lỗi mới | `STOP_POINT_STATE_INVALID` (409) khi khóa điểm đang khóa / mở khóa điểm không khóa; duyệt / từ chối đề xuất đã có kết quả dùng lại `STOP_POINT_PROPOSAL_STATE_INVALID` (409) | Duyệt |
| G6 | Xác nhận lại danh tính | Không đòi TOTP cho thao tác điểm dừng (API §7.5 không ghi; Figma ADM-05e không có ô TOTP) | Xác nhận |
| G7 | Lý do 1–500 ký tự | Theo Figma ADM-05e ("1–500"); hồ sơ nhà xe dùng 3–500 | Xác nhận |
| G8 | Hộp thoại khóa — "Chuyến sắp chạy đã có vé" | Figma có dòng này; chưa có đặt vé nên chỉ hiện số tuyến đang dùng | Làm khi có booking |
| G9 | Lọc theo nhà xe | API có `operatorId`; giao diện chưa có ô "Nhà xe" (chưa có API danh sách nhà xe cho Admin — thuộc task quản lý nhà xe chưa duyệt) | Theo task quản lý nhà xe |
| G10 | SRS chưa có dòng NTF cho quyết định điểm dừng | Email theo LLD §6.13; danh mục NTF của SRS (§ thông báo) chưa có dòng tương ứng | Thêm `NTF-27` vào SRS (kênh Email / In-app) |

## Kiểm tra (15/10/2026)

- API, Postgres + Redis + Mongo thật, role app: **92 file / 1202 test đạt** (migration đã áp vào DB test + `db:app-role`). Mới: `admin-stop-point.int.spec.ts` 9 ca (CHECK danh mục; RLS tenant không ghi danh mục; DTO căn cứ; thêm / sửa / ngừng dùng + audit + lọc / tìm / cursor; cảnh báo trong 200 m; duyệt đồng thời → một 409 + đúng một điểm (TC-TRN-017); từ chối + nhà xe gửi lại; audit lỗi → 503 không tạo gì; khóa → nhà xe sửa bị 409, khóa lại 409, mở khóa (TC-TRN-018 phần Admin)), `admin-stop-point.http.spec.ts` 12 ca (guard thật cho 11 route + validate). Fixture các spec cũ thêm căn cứ công bố cho bến xe.
- Gốc repo: lint + typecheck 20/20; test Admin, Operator OS, `packages/ui` đạt; build production Admin + Operator OS đạt.
- E2E Admin **11/11** (mới `stop-points.e2e.ts` 4 ca: duyệt có chỉnh tên → có trong Dùng chung; từ chối thiếu / có lý do; bến xe thiếu căn cứ báo tại ô, thêm trạm dừng nghỉ, ngừng dùng; khóa / mở khóa điểm riêng). E2E Operator OS **36/36** sau khi chuyển phần bản đồ sang gói dùng chung. Seed E2E thêm tài khoản `platformCatalog` + hai đề xuất + một văn phòng riêng (tọa độ ngẫu nhiên mỗi lần chạy).
- Client Dart: 0 lỗi analyzer, 844 test đạt.
- Đối chiếu Figma ở 1440 px (có bản đồ Goong thật) và 390 px (không tràn ngang — thanh tab cuộn ngang khi hẹp).

## Việc tiếp theo

1. Khanh review, chốt G1–G9; commit / PR sau PR #35, #36.
2. Nhập danh sách bến xe các tỉnh khi có nguồn công bố.
3. A4 — Danh mục (phần catalog của `TASK-ADM-001`): ✅ code xong 16/10/2026, chờ duyệt — `ADM-001-catalog-todo.md`.
