# TASK-TRN-012 — Checklist nghiệm thu: Thiết kế lại điểm dừng (backend nhà xe)

> Mục tiêu: điểm riêng chỉ còn văn phòng / trạm dừng nghỉ, nhà xe không vượt được khóa của Admin, đề xuất kèm căn cứ công bố, tuyến lưu đúng quyền đón / trả, ô tìm gõ không dấu vẫn ra.
> Chỉ tick `[x]` khi có evidence. Lệnh: `TRN-012-guide.md`. Phạm vi: `TRN-012-todo.md`.

## Snapshot trạng thái (05/10/2026)

- [x] Nhánh `TASK-TRN-012` từ `develop`; tạo bộ ba todo / guide / checklist.
- [x] Code, migration, test, client TS + Dart xong; đo trên máy dev bằng container tạm (Postgres 16, Redis 7, Mongo 7), test chạy bằng **role app** (không superuser, không BYPASSRLS).
- [ ] Khanh review diff → commit → CI xanh.
- [ ] Rollout database đã triển khai (guide §5).

## PHẦN A — Schema và migration

- [x] Database mới hoàn toàn: chạy toàn bộ migration từ đầu thành công.
- [x] Database cũ có dữ liệu sai loại, chủ database **không** phải superuser, bảng bật FORCE RLS (giống Supabase): sau migrate chỉ còn tuyến hợp lệ; điểm riêng chỉ còn `OFFICE` / `REST_STOP`; đề xuất chỉ còn `BUS_STATION` / `PICKUP_POINT`.
- [x] Tuyến còn lại được điền cờ đúng: điểm đầu đón / không trả, điểm giữa cả hai, trạm dừng nghỉ không đón không trả, điểm cuối trả / không đón.
- [x] Đề xuất đúng loại gửi trước đây được giữ, căn cứ công bố ghi "Chưa khai…".
- [x] `stop_points`: CHECK loại; CHECK lý do khóa có khi và chỉ khi `SUSPENDED` — chặn cả scope `system` (test "Invariant DB").
- [x] `stop_point_proposals`: CHECK loại; `legal_basis` bắt buộc, không rỗng, tối đa 300 ký tự — chặn cả scope `system`.
- [x] `route_stops`: `allow_pickup` / `allow_dropoff` bắt buộc; CHECK điểm đầu / điểm cuối.
- [x] Cột `search_text` do database sinh ở `stop_points` và `stop_points_catalog`: chữ thường, không dấu; hàm `vxn_search_text` chạy được bằng role app.
- [ ] Migration dừng sạch khi tuyến cần xóa đang được chuyến trỏ tới — **chưa thử** (repo chính chưa có bảng chuyến); dựa vào cơ chế một transaction đã kiểm ở TRN-010.

## PHẦN B — Tenant-RLS (bắt buộc, ADR-025)

- [x] `stop_points` có đúng 4 policy theo lệnh; bảng vẫn ENABLE + FORCE RLS; `rlsProblems()` rỗng.
- [x] Ghi thẳng database bằng scope tenant (bỏ qua service): không tạo được dòng `SUSPENDED`, không đưa được điểm sang `SUSPENDED`, không sửa / mở lại được điểm đang bị khóa, không xóa được điểm (`TC-TRN-018` phần nhà xe).
- [x] Query cố ý quên lọc `operator_id`: tenant B không đọc / sửa / xóa được điểm, tuyến, điểm dừng tuyến của tenant A.
- [x] Đề xuất: tenant không tự duyệt / từ chối, không tạo hay chuyển sang `operator_id` khác (giữ nguyên từ TRN-002).
- [x] Scope `platform` khóa và mở khóa được (lệnh SQL ở guide §3, chạy bằng chủ database không phải superuser).

## PHẦN C — API

- [x] Điểm riêng loại `BUS_STATION` / `PICKUP_POINT` → 422 `STOP_POINT_TYPE_NOT_ALLOWED`, cả tạo lẫn sửa (`TC-TRN-015`).
- [x] Body gửi `status = SUSPENDED` → 400; sửa điểm đang bị khóa → 409 `STOP_POINT_SUSPENDED`; `GET` trả `suspensionReason`.
- [x] Điểm bị khóa không gắn mới được vào tuyến (422 `STOP_POINT_UNAVAILABLE`); tuyến đã có điểm đó vẫn sửa được phần khác.
- [x] Đề xuất loại `OFFICE` / `REST_STOP`, thiếu hoặc rỗng `legalBasis`, quá 300 ký tự → 400; response trả lại `legalBasis` (`TC-TRN-015`).
- [x] Tuyến: lưu và trả đúng `allowPickup` / `allowDropoff` + `type` từng điểm; đổi cờ không gọi lại Goong (`TC-TRN-016` phần tuyến).
- [x] Tuyến sai quy tắc → 422 `ROUTE_STOP_PICKUP_DROPOFF_INVALID`, không gọi Goong, không lưu gì: điểm đầu cho trả / không cho đón, điểm cuối cho đón / không cho trả, điểm giữa tắt cả hai, trạm dừng nghỉ bật đón hoặc trả, trạm dừng nghỉ đứng đầu / cuối. Thiếu cờ → 400.
- [x] Văn phòng làm điểm đầu tuyến được chấp nhận (hai đầu không phải bến xe không bị chặn ở v1, `OQ-24`).
- [x] List điểm riêng: lọc `status` / `type` / `provinceId`; `routeCount` đúng; không lộ điểm tenant khác.
- [x] Tìm `q` ở điểm riêng và catalog: gõ không dấu, khác hoa / thường, theo tên hoặc địa chỉ đều ra; quá 100 ký tự → 400.
- [x] Tìm `q` với ký tự đặc biệt (kiểm ở điểm riêng; catalog dùng chung một hàm): `%`, `_` không khớp bừa; ký hiệu in ấn (gạch ngang dài, ngoặc cong) dán nguyên hay gõ tay đều ra.
- [x] Chuỗi guard: Owner được; không token 401; Employee và Platform 403; tenant lấy từ JWT, không từ body.
- [ ] Smoke HTTP trên API đang chạy (guide §3) — **chưa chạy**; hiện có test route thật + test database thật.

Phần còn lại của `TC-TRN-016` (chuyến chép cờ, đặt vé) thuộc `TASK-TRN-003` / BTP; phần Admin của `TC-TRN-018` và `TC-TRN-017` thuộc `TASK-ADM-004`; `TC-TRN-019` thuộc `TASK-TRN-004`.

## PHẦN D — Chất lượng

- [x] `vitest` toàn bộ `apps/api` với `REQUIRE_DB_TESTS=1`: **66 file, 816 test pass, 0 skip** (riêng `route.int.spec`: 38 test).
- [x] `pnpm turbo run typecheck lint test`: 29/29 task pass.
- [x] Client TS: `openapi.json` + `schema.ts` chỉ đổi phần điểm dừng, đề xuất, tuyến, catalog điểm dừng; query `q` / `type` / `provinceId` có trong contract.
- [x] Client Dart sinh bằng `openapi-generator-cli:v7.25.0`: 30 file đổi nội dung, đều thuộc các phần trên; `dart analyze` 0 lỗi; `dart test` 431 pass.
- [ ] `code-reviewer` + `security-auditor` trước khi đóng task (DoD §6.3 — task chạm tenant) — chưa chạy.

## Bàn giao cho task sau

- `TASK-TRN-013` (màn Điểm dừng): cột "số tuyến đang dùng" chỉ ở tab Của nhà xe (`routeCount`); tab Dùng chung gọi `/catalog/stop-points?q=`; form tuyến gửi đủ hai cờ cho mỗi điểm và tự cảnh báo khi hai đầu không phải bến xe (dùng `type`).
- `TASK-ADM-004`: khóa / mở khóa ghi `status` + `suspension_reason` trong scope `platform` (mở khóa phải xóa lý do); thêm ràng buộc cho `stop_points_catalog` (loại, `legal_basis`); đề xuất cũ mang căn cứ "Chưa khai…" cần Admin bổ sung khi duyệt.
- Port `TASK-TRN-003` / `TASK-TRN-006`: `trip_stops` chép `allow_pickup` / `allow_dropoff`; mở bán chuyến có điểm `SUSPENDED` → `TRIP_NOT_READY_FOR_SALE`.
- Nếu danh mục điểm dừng lớn lên (hàng chục nghìn dòng) và tìm `q` chậm: thêm chỉ mục `pg_trgm` trên `search_text`.
