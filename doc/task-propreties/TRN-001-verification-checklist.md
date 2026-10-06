# TASK-TRN-001 — Checklist nghiệm thu: Vehicle + SeatMap/Seat

> Mục tiêu: Owner quản lý đội xe + sơ đồ ghế trong tenant của mình, đủ nền cho TRN-003; tenant khác, Employee, Platform không đọc/ghi được qua các route này.
> Chạy theo thứ tự **A → G**; chỉ tick `[x]` khi có evidence. Lệnh: `TRN-001-guide.md`. Phạm vi/sub-task: `TRN-001-todo.md`.

## Snapshot trạng thái (25/09/2026)

- [x] Đã đối chiếu SDLC/code và tạo bộ ba todo/guide/checklist; nhánh `TASK-TRN-001` tạo từ `TASK-CAT-001`.
- [x] Q1–Q4 được Khanh chốt 25/09/2026.
- [x] **Port 30/09/2026** (code viết 25/09 ở repo bản sao `Marketplace-Ve-Xe-Nhanh-Clould`, commit `1b59a9b`): nhánh `TASK-TRN-001` mới từ `develop`; `apps/api/src/vehicle/*` + migration **giống hệt** bản đã review; migration đổi tên `20260925020000` → `20260930020000_add_vehicle` để chạy sau `split_employee_login` của IAM-006; gỡ xung đột `app.module.ts`, `openapi.module.ts`, `openapi.spec.ts` (giữ cả Catalog lẫn Vehicle); client TS + Dart sinh lại trên `develop`. Evidence bên dưới đo lại sau port.

## PHẦN A — Quyết định & ranh giới

- [x] Q1: nhà xe tự cấu hình SeatMap làm mẫu dùng chung; tùy chỉnh từng xe = bản sao của mẫu; bố cục `JSONB` + bảng `seats`.
- [x] Q2: `VehicleStatus` 3 giá trị, bảng `vehicle_amenities`, chỉ gán catalog `ACTIVE`.
- [x] Q3: 8 route, `PUT` thay toàn bộ, quyền `vehicle:manage`, 404 chung cho khác tenant.
- [x] Q4: chỉ BE.
- [x] API §7.3 (v0.7) + DB §5.2/§7 (v0.9) + task row (v0.13) cập nhật 25/09/2026, giữ Approved.
- [x] Không kéo chặn-sửa-khi-có-chuyến, xung đột lịch xe, Employee/Admin xem xe vào TRN-001.

## PHẦN B — Schema, migration & RLS

- [x] 4 bảng + enum đúng migration; mọi bảng có `operator_id`.
- [x] Unique `(operator_id, plate_number)`; tenant khác được trùng biển số.
- [x] FK ghép chặn gắn SeatMap/ghế/tiện ích xe của tenant khác (test DB + mutation).
- [x] Unique mã ghế và vị trí ghế trong SeatMap; CHECK tầng/hàng/cột ≥ 1.
- [x] FK RESTRICT, không cascade.
- [x] 4 bảng `ENABLE + FORCE RLS`, policy `app_rls_allows(operator_id)` cho USING + WITH CHECK; có trong `RLS_TABLES`; `rlsProblems()` rỗng.
- [x] Role app: tenant B không đọc/sửa/xoá/tạo dữ liệu tenant A dù query quên lọc; không ngữ cảnh → 0 dòng.
- [x] 9 migration áp tuần tự trên DB trống; `db:app-role` pass. Sau port (30/09): **10** migration trên DB trống, `db:app-role` pass, `prisma migrate diff` DB ↔ `schema.prisma` rỗng, `migrate status` up to date.

## PHẦN C — SeatMap

- [x] Tạo/sửa SeatMap đúng; `seatCount` = số ghế; ghế sắp theo tầng/hàng/cột.
- [x] Bố cục sai (trùng mã, trùng vị trí, ngoài lưới, tầng không liên tục, 0 ghế, quá giới hạn) → 400, không ghi gì.
- [x] `PUT` thay ghế nguyên tử (lỗi giữa chừng giữ ghế cũ).
- [x] Trùng tên trong tenant → 409; tenant khác → 404; bản sao tùy chỉnh độc lập với mẫu gốc (Q1).

## PHẦN D — Vehicle

- [x] Tạo/sửa/list/chi tiết đúng shape; lọc `status`; cursor không lặp/sót.
- [x] Biển số chuẩn hóa (DB có CHECK dạng chuẩn); trùng trong tenant (khác cách gõ) → 409 ở cả POST và PUT.
- [x] POST/PUT thiếu trường → 400 (không tự reset trạng thái/SeatMap/tiện ích).
- [x] Loại xe/tiện ích không tồn tại hoặc INACTIVE → 422; xe cũ giữ item đã INACTIVE vẫn sửa được.
- [x] SeatMap của tenant khác → 404; xe tenant khác → 404.
- [x] Employee (3 role)/PlatformAdmin → 403 `PERMISSION_DENIED`; không token → 401.
- [x] Controller mỏng; logic ở service; lọc `operatorId` tường minh + RLS.

## PHẦN E — Contract

- [x] OpenAPI có 8 route, Bearer, requestBody/param/query, RFC 7807.
- [x] `openapi.spec.ts` chặn mất route/requestBody/path param.
- [x] Client TS + Dart sinh lại, chỉ thêm phần vehicle/seat-map; `dart test` 250/250, `dart analyze` 0 error. Sau port: OpenAPI so với `develop` chỉ **thêm** 8 operation, không operation/schema cũ nào đổi hay mất; `dart test` 250/250, `dart analyze` 0 error (13 warning `unused_import` / `unused_element_parameter` của generator).

## PHẦN F — Test & regression

- [x] Unit + HTTP: DTO/bố cục/biển số/RBAC/400/mass assignment/`requireTenant`.
- [x] Tích hợp Postgres thật bằng role app: RLS (cả `vehicle_amenities`), IDOR, FK ghép 3 quan hệ, unique, CHECK, transaction `PUT`, PUT đồng thời.
- [x] Mutation tắt RLS / bỏ unique / bỏ FK ghép làm 4 test đỏ.
- [x] `REQUIRE_DB_TESTS=1` pass, 0 skip: 55/55 file, 560/560 test (sau khi sửa review); regression IAM + CAT xanh. Sau port trên `develop` (có IAM-006): **56/56 file, 576/576 test**, 0 skip.
- [x] Hai `PUT` đồng thời cùng xe: bản sau thắng trọn vẹn (test bắt được lỗi cũ 2/3 lần).
- [x] `pnpm turbo run typecheck lint build` xanh 26/26. Sau port: `pnpm turbo run typecheck lint test build --force` **35/35**.

## PHẦN G — Review, CI & đóng task

- [x] `code-reviewer` + `security-auditor` không có finding blocking/high; medium đã sửa (bảng ở todo #7). Port 30/09 không đổi dòng nào trong `vehicle/` và migration nên không review lại; phần riêng của port (3 file gỡ xung đột + tên migration) do Khanh review trên diff.
- [x] Smoke guide §3 trên API chạy thật — 30/09/2026, API build (`dist/main.js`) + Postgres/Redis/Mongo container tạm: Owner 2 tenant + Platform login qua MFA, Driver qua `/auth/employee/login`; **28/28 kiểm tra đạt** (3A bố cục sai 400 không ghi, trùng tên 409, bản sao độc lập mẫu; 3B biển số chuẩn hoá, 409, 422 cho id lạ / loại xe + tiện ích `INACTIVE`, xe cũ giữ item `INACTIVE` vẫn sửa được, thiếu trường 400; 3C khác tenant 404, `SEAT_MAP_NOT_FOUND`, list tách tenant, Driver / Platform 403, không token 401).
- [x] AI journal đã ghi (4 dòng `add`); không commit journal.
- [ ] CI branch xanh — Khanh xác nhận.
- [ ] Task row §7.3 → `Done`; không đổi trạng thái Approved của tài liệu SDLC.

## PHẦN H — DoD theo sub-task

| Sub-task | DoD | ✓ |
| --- | --- | --- |
| `.1` Quyết định | Q1–Q4 chốt + API/DB doc cập nhật | [x] |
| `.2` Schema | Migration/FK ghép/RLS chạy DB thật | [x] |
| `.3` SeatMap | Bố cục hợp lệ, `PUT` nguyên tử | [x] |
| `.4` Vehicle | Biển số, catalog ACTIVE, tenant | [x] |
| `.5` Contract | OpenAPI + TS/Dart không drift | [x] |
| `.6` Test | Hạ tầng thật + mutation + regression | [x] |
| `.7` Đóng task | Review + CI + state update | [ ] |

## PHẦN J — Màn Operator OS, phần 1 (04/10/2026, nhánh `TASK-TRN-001-web`)

Đo trên máy dev: API thật + Postgres / Redis / Mongo tạm, đăng nhập Owner qua giao diện, trình duyệt Chrome 1440×1160.

- [x] Danh sách xe (`/vehicles`) khớp Figma `1095:3344`: cột, nhãn trạng thái, sơ đồ + số chỗ / sức chứa / số tầng, tiện ích hai dòng.
- [x] Trạng thái: đang tải, chưa có xe, lỗi kết nối + thử lại, lọc theo trạng thái, lọc không có kết quả, "Tải thêm" theo `nextCursor`.
- [x] Form thêm / sửa (`/vehicles/new`, `/vehicles/{id}`) khớp Figma `1096:3496`: 13 / 13 bước kiểm tay bằng script — lỗi tại ô, biển số sai dạng, 6 loại xe đúng thứ tự, tạo → sang trang sửa + báo đã lưu, sửa → danh sách cập nhật, trùng biển số báo tại ô, hủy khi chưa lưu hỏi lại, id lạ báo không tìm thấy.
- [x] Màn 1280 không tràn ngang (danh sách + form).
- [x] `vitest` Operator OS 46 pass (định dạng biển số, nhãn loại xe, luật form, đổi lỗi API thành thông báo); `turbo typecheck lint test` 29 / 29; `next build` qua.
- [x] API (`TASK-TRN-011`): Vehicle trả `seatMap` tóm tắt + `seatMapLocked`, SeatMap trả `inUse`; `vitest` API 766 pass với `REQUIRE_DB_TESTS=1`; client TS + Dart sinh lại (`dart analyze` 0 lỗi, `dart test` 431 pass).
- [ ] Khối ảnh xe: mới dựng giao diện theo mock, chưa tải được ảnh — chờ `TASK-TRN-009`.
- [x] Nút "Tùy chỉnh bản sao" — làm ở phần 2 (PHẦN K). Trạng thái khóa sơ đồ khi có chuyến đã có giao diện, chờ TRN-003 để API trả cờ thật.
- [x] Khung trang theo Figma — làm ở phần 2 (PHẦN K).
- [x] E2E Playwright cho màn xe — `fleet.e2e.ts` (PHẦN K).

## PHẦN K — Màn Operator OS, phần 2 (05/10/2026, nhánh `TASK-TRN-001-web`)

Đo trên máy dev: API thật + Postgres / Redis / Mongo tạm, đăng nhập Owner qua giao diện, Chrome 1440×1160.

- [x] Danh sách sơ đồ ghế (`/seat-maps`) khớp Figma `1180:6017`: cột, ngày cập nhật, số tầng / số chỗ / sức chứa, nhãn sử dụng, nút Chỉnh sửa / Xem / Tạo bản sao / Tạo sơ đồ; trạng thái đang tải, rỗng, lỗi, "Tải thêm".
- [x] Trình soạn bốn chế độ theo Figma `1197:6838`, kiểm tay bằng script 20 / 20 bước: khóa nút khi chưa đủ cấu hình; tạo lưới theo từng tầng, mã `A01…` / `B01…`; đổi loại chỗ, ô trống và đặt lại chỗ (lấy mã còn trống); trùng mã báo tại ô và chặn lưu; tầng không có chỗ; trùng tên báo tại ô tên; tạo lại lưới hỏi xác nhận; kích thước chưa áp dụng có dòng nhắc; rời trang chưa lưu hỏi lại; tạo bản sao lưu thành dòng riêng; chế độ xem khóa mọi ô.
- [x] Chế độ xem chỉ đọc kiểm bằng cách giả lập API trả `inUse = true` (trước TRN-003 API luôn trả `false`).
- [x] Từ form xe: "Tùy chỉnh bản sao" cảnh báo mất dữ liệu chưa lưu → trình soạn (nút "Về phương tiện") → lưu → quay lại form với sơ đồ mới chọn sẵn → lưu xe, danh sách xe hiện đúng sơ đồ.
- [x] Khung trang theo Figma: thương hiệu hai dòng, thẻ nhà xe, thẻ hỗ trợ, khối tài khoản + nút đăng xuất (đăng xuất xóa cookie phiên; menu trượt ở màn hẹp có đủ các khối). App Admin không đổi.
- [x] Hai màn danh sách dùng chung một kiểu (thụt lề tiêu đề cột, dòng cao 84, nút đặc ở trạng thái rỗng / lỗi, câu hết danh sách có số).
- [x] Màn 1280 không tràn ngang (danh sách sơ đồ, trình soạn).
- [x] `vitest` Operator OS 74 pass (thêm lõi trình soạn: tạo lưới, đổi ô, số chỗ / sức chứa, luật kiểm, tham số URL); `turbo typecheck lint test` 29 / 29; `next build` qua.
- [x] E2E Playwright `pnpm --filter @vexenhanh/operator-os test:e2e`: 8 / 8 pass (4 ca đăng nhập cũ + 4 ca `fleet.e2e.ts`: tạo sơ đồ, tạo xe gắn sơ đồ, trùng biển số, đăng xuất). Seed E2E thêm Owner `fleetOwner`.
- [ ] Thẻ nhà xe đang hiện **mã nhà xe** (slug) vì `/auth/me` chưa trả tên hiển thị — cần bổ sung API nếu muốn hiện tên như Figma.
- [ ] Thứ tự dòng hai danh sách theo mã, chưa "mới cập nhật trước" như mock — bổ sung API sau.
- [ ] Hình ô cho "Ghế" và "Giường đôi" do AI suy từ ký hiệu "Loại ô" (Figma chỉ vẽ cabin) — Khanh xem lại.
- [ ] `code-reviewer` trước khi đóng task (DoD §6.3) — chưa chạy.

## PHẦN I — Ranh giới không chặn nghiệm thu

- Chặn sửa xe/SeatMap đã gắn chuyến, xung đột lịch xe → TASK-TRN-003; đổi xe có vé → TASK-TRN-008.
- Employee xem xe được phân công → TASK-EMP-001; Admin giám sát → task Admin.
- Màn hình Operator OS (nếu Q4 giữ khuyến nghị) → khi Operator OS có auth.
