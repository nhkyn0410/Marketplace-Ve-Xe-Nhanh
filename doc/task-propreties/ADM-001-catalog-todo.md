# TASK-ADM-001 (phần danh mục) — Todo: Admin quản lý danh mục chuẩn

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` — `TASK-ADM-001` "… / catalog (trừ điểm dừng — chuyển sang `TASK-ADM-004`) / …". Nguồn chi tiết: SRS `FR-ADM-04`, `UC-24` (A1 / A2), `BR-38`, `BR-77`; LLD §5.2 "Catalog & Search"; DB §5.2 nhóm Catalog; API §7.5 `/admin/catalog/*`; Security §7; UI §9 dòng Catalog / policy; Figma section `Giao diện Admin` (`1663:23890`): `ADM-04a` Loại xe (`1671:31751`), `ADM-04b` Tỉnh thành (`1671:32120`), `ADM-04c` Hộp thoại ngừng dùng loại xe (`1671:32470`).
> **Khanh (15/10/2026):** "Hướng tới dựng hoàn thiện phần admin" → A4 trong thứ tự A1…A7 (`ADM-001-todo.md`); "Tiếp tục" sau khi chốt G3 / G4 của `TASK-ADM-004`.
> **Nhánh:** làm tiếp trên `TASK-ADM-004` (cần quyền `catalog:manage` và các thành phần của A3). Gợi ý commit tách A3 / A4.

## Trạng thái (16/10/2026) — 🔨 **Code xong, chưa commit — chờ Khanh review + CI**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).
- Không đổi schema / migration: bảng danh mục của `TASK-CAT-001` đã có `status`, đủ dùng.
- **Chưa làm:** nhập danh mục hành chính chính thức (34 tỉnh / phường) — vẫn chờ file từ Khanh như `TASK-CAT-001`; màn chỉ thêm từng mục.

## Đã làm

### Backend (`apps/api/src/catalog/admin-catalog.*`)

- **14 route `/admin/catalog/*`**, quyền `catalog:manage` (chỉ `PLATFORM_ADMIN`), scope DB `platform`; mọi thay đổi ghi audit TRONG transaction (`catalog.{province|ward|vehicle_type|amenity}.{create|update|activate|deactivate}`, có trước–sau) — audit lỗi → 503, không lưu gì:

| Route | Việc |
| ----- | ---- |
| `GET /admin/catalog/provinces` | Mọi trạng thái, lọc `status`, tìm `q` (mã bắt đầu bằng / tên chứa; `%`, `_` là ký tự thường), xếp theo mã, cursor = mã dòng cuối, `limit` ≤ 100; kèm `wardCount`, `stopPointCount` (điểm dùng chung), `total` |
| `POST /admin/catalog/provinces` · `PUT …/{id}` | Thêm (mã 2 chữ số + tên) · đổi tên |
| `GET /admin/catalog/wards` | Như trên, lọc thêm `provinceId`; kèm `provinceName`, `stopPointCount` |
| `POST /admin/catalog/wards` · `PUT …/{id}` | Thêm (tỉnh + mã 5 chữ số + tên; tỉnh lạ → 404) · đổi tên |
| `GET /admin/catalog/vehicle-types` | Mọi loại (ít mục, không phân trang), lọc `status`; kèm `vehicleCount`, `operatorCount`, `fareRuleCount` |
| `POST /admin/catalog/vehicle-types` · `PUT …/{id}` | Thêm (mã chữ hoa không dấu, tên, mô tả ≤ 300, dạng chỗ, hạng xe) · sửa tên + mô tả |
| `GET /admin/catalog/amenities` | Mọi tiện ích; kèm `vehicleCount` |
| `POST /admin/catalog/amenities` · `PUT …/{id}` | Thêm (mã + tên) · đổi tên |
| `POST /admin/catalog/{kind}/{id}/deactivate` | Ngừng dùng, lý do 3–500 ký tự vào audit; 204. Đã ngừng → 409 `CATALOG_STATE_INVALID`; id lạ → 404 `CATALOG_ITEM_NOT_FOUND` |
| `POST /admin/catalog/{kind}/{id}/activate` | Dùng lại; 204 |

- Đổi trạng thái kiểu so-rồi-đặt (`updateMany` theo trạng thái cũ) — hai Admin bấm cùng lúc thì một người nhận 409. Trùng mã → 409 `CATALOG_CODE_CONFLICT`.
- Mục ngừng dùng biến mất khỏi API công khai `/catalog/*` (phường / điểm dùng chung thuộc tỉnh ngừng dùng cũng ẩn — có sẵn từ `TASK-CAT-001`); xe, tuyến, chuyến đang dùng mục đó giữ nguyên.
- Client TS + Dart sinh lại.

### Admin (`apps/admin`) — theo Figma ADM-04a…04c

- `/catalog` bốn tab Tỉnh / thành · Phường / xã · Loại xe · Tiện ích (tab nằm trên địa chỉ `?tab=`); nút "Thêm …" theo tab đang mở.
- Tỉnh / phường: tìm tên / mã, lọc trạng thái, "Tải thêm"; phường lọc theo tỉnh. Loại xe: cột dạng chỗ, hạng xe (nhãn Tiêu chuẩn / Limousine), số xe đang dùng. Dải ghi chú cuối trang theo Figma.
- Hộp thoại thêm / sửa: mã báo sai tại ô (tự viết hoa với loại xe / tiện ích), trùng mã báo tại ô Mã; khi sửa không cho đổi mã / tỉnh / dạng chỗ / hạng xe.
- Hộp thoại ngừng dùng (ADM-04c): dòng phụ "Mã … · dạng chỗ … · hạng …", khối **Mức ảnh hưởng** theo loại danh mục, ghi chú hệ quả, Lý do bắt buộc (3–500); dùng lại chỉ cần xác nhận.
- `PageHeader` dùng chung của Admin: tiêu đề giữ bề ngang tối thiểu nên ở 390 px nút "Thêm …" xuống dòng thay vì bóp tiêu đề (áp cho cả màn Điểm dừng).

## Chờ Khanh (G1–G8)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Hợp đồng API §7.5 chỉ ghi `GET/POST/PUT /admin/catalog/*` | Định nghĩa 14 route (bảng trên), ngừng dùng / dùng lại là route con chung `{kind}/{id}/deactivate` / `…/activate` (ADR-012 "POST + sub-resource"), trả 204. Quyền `catalog:manage` của A3 | Duyệt |
| G2 | Trường không sửa được | Mã của mọi mục; tỉnh của phường; dạng chỗ / hạng xe của loại xe (xe và bảng giá dựa vào hai thuộc tính này — BR-77). Muốn đổi thì ngừng dùng rồi thêm mục mới | Xác nhận |
| G3 | Không xóa | Chỉ ngừng dùng / dùng lại (UC-24 A2). Dùng lại không cần lý do; không đòi TOTP (Figma ADM-04c không có ô TOTP) | Xác nhận |
| G4 | Mã lỗi mới | `CATALOG_CODE_CONFLICT` (409), `CATALOG_ITEM_NOT_FOUND` (404), `CATALOG_STATE_INVALID` (409); audit lỗi → 503 `SERVICE_UNAVAILABLE` | Duyệt |
| G5 | Thêm phường vào tỉnh đang ngừng dùng | Cho phép (phường vẫn ẩn khỏi công khai vì tỉnh ngừng) | Xác nhận, hay chặn |
| G6 | Tìm tỉnh / phường **phân biệt dấu** | "ha noi" không ra "Hà Nội" (không phân biệt hoa thường). Điểm dừng tìm không dấu nhờ cột riêng; làm tương tự cần thêm cột + migration | Có cần tìm không dấu không |
| G7 | Thứ tự loại xe / tiện ích | Xếp theo mã; Figma ADM-04a xếp tay (Ghế ngồi → Giường nằm → Cabin → bản Limousine). Không có ô tìm (Figma không có) | Giữ theo mã, hay thêm cột thứ tự |
| G8 | Nhập danh mục hành chính | Màn chỉ thêm từng mục; nhập 34 tỉnh / phường chính thức vẫn là việc còn lại của `TASK-CAT-001` (chờ file) | Gửi file; có cần nhập CSV trên màn không |

## Kiểm tra (16/10/2026)

- API, Postgres + Redis + Mongo thật, role app: **94 file / 1222 test đạt**. Mới: `admin-catalog.int.spec.ts` 4 ca (tỉnh / phường: thêm, trùng mã 409, đổi tên + audit trước–sau, đếm, lọc / tìm, `%` / `_` tìm đúng ký tự; ngừng dùng → ẩn khỏi API công khai, ngừng lần nữa 409, dùng lại hiện lại, id lạ 404; loại xe + tiện ích; audit lỗi → 503 không lưu), `admin-catalog.http.spec.ts` 15 ca (guard thật cho 14 route: không token 401, chủ nhà xe / hỗ trợ nền tảng 403; validate mã / lý do / loại danh mục).
- Gốc repo: lint 9/9, typecheck 11/11; test Admin 16, Operator OS 409 đạt; build production Admin + Operator OS + API đạt.
- E2E Admin **14/14** (mới `catalog.e2e.ts` 3 ca: loại xe — mã sai / trùng mã báo tại ô, thêm, đổi tên, ngừng dùng kèm lý do + mức ảnh hưởng, dùng lại; tiện ích + phường thêm rồi ngừng dùng; tỉnh tìm theo tên + hộp thoại mức ảnh hưởng). Mục E2E tạo ra được ngừng dùng ở cuối để không hiện trong form của Operator OS. Seed E2E thêm tài khoản `platformData`. E2E Operator OS **36/36**.
- Client Dart: 0 lỗi analyzer, 954 test đạt.
- Đối chiếu Figma ADM-04a / 04b / 04c ở 1440 px khớp bố cục; 390 px không tràn ngang (bảng cuộn ngang trong khung).

## Việc tiếp theo

1. Khanh review, chốt G1–G8; commit A3 và A4 thành hai commit riêng.
2. A5 — Kiểm duyệt ảnh xe (phần ảnh xe của `TASK-ADM-003`: API `/admin/vehicle-images` chưa làm) + Nhật ký audit.
