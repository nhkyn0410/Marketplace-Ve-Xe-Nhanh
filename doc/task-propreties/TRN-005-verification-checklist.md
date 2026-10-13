# TASK-TRN-005 — Checklist nghiệm thu: Fare + FareRule

> Mục tiêu: bảng giá theo tuyến × loại xe có schema + RLS + ràng buộc chống trùng rule ở DB, giá ghế của chuyến đúng rule cụ thể nhất, lịch sử giá ghi cùng transaction, API Owner đúng tenant, tiền `BIGINT` không qua số thực.
> Chạy theo thứ tự **A → H**; chỉ tick `[x]` khi có evidence. Lệnh: `TRN-005-guide.md`. Phạm vi/sub-task: `TRN-005-todo.md`.

## Snapshot trạng thái (30/09/2026)

- [x] Tạo nhánh `TASK-TRN-005` (tách từ nhánh TRN-003); bộ ba todo/guide/checklist.
- [x] Q1–Q7 được Khanh chốt 30/09/2026 (Q1 = PA1, Q4 = Mongo).

## PHẦN A — Quyết định & tài liệu

- [x] Tài liệu đồng bộ **trước khi code**: SRS v1.29–v1.30, GLOSSARY, HLD v0.9, LLD v0.10, DB v0.16, API v0.14, Security v0.12, Test plan v0.8, file 11 v0.26–v0.27.
- [x] Cảnh báo khung trần/sàn (OQ-17) chuyển sang TASK-ADM-001 (file 11).
- [x] Không kéo giá theo chặng, giá theo lúc mua, khuyến mãi, booking snapshot, mở bán vào TRN-005.

## PHẦN B — Schema, migration & RLS

- [x] 2 bảng + enum `FareStatus` đúng migration `20260930110000_add_fare`; mọi bảng có `operator_id`.
- [x] 2 bảng `ENABLE + FORCE RLS`, policy `tenant_isolation`; có trong `RLS_TABLES`; `rlsProblems()` rỗng.
- [x] Tenant B không đọc/sửa/xoá bảng giá, rule của A dù query quên lọc.
- [x] FK ghép chặn bảng giá của A gắn tuyến của B, kể cả đi đường system.
- [x] Ghi thẳng DB: giá âm / vượt 100.000.000, khung giờ thiếu một đầu / ngược chiều, trùng giá thường, chồng khung giờ đều bị chặn; đúng trần, khung giờ nối tiếp và phạm vi khác thì được.
- [x] 14 migration áp tuần tự (thêm `20260930120000_fare_price_cap` sau review); `db:app-role` pass; `prisma migrate diff` rỗng.
- [x] Mutation: bỏ `fare_rules_base_unique` → 2 test đỏ; tắt RLS `fare_rules` → 2 test đỏ.

## PHẦN C — Tiền (test money bắt buộc)

- [x] Rule cụ thể nhất thắng (khung giờ > không; đúng loại xe > mọi loại; đúng loại chỗ > mọi loại); thứ tự rule không ảnh hưởng.
- [x] Biên khung giờ `[từ, đến)`: đúng giờ bắt đầu thuộc dịp, đúng giờ kết thúc thì không.
- [x] Giá 0 hợp lệ; không có rule khớp → `null`.
- [x] Tiền giữ `bigint` (kể cả > 2^53); đổi sang JSON chỉ ở biên, từ chối âm / vượt số nguyên an toàn.
- [x] `BIGINT` qua DB giữ đúng giá trị (99.999.999).
- [x] Zod: giá âm, lẻ đồng, vượt 100.000.000, dạng chuỗi bị từ chối.

## PHẦN D — Tạo / sửa bảng giá

- [x] Tuyến của B / tuyến ngừng dùng → 422 `ROUTE_UNAVAILABLE`; tuyến đã có bảng giá → 409 `FARE_ROUTE_CONFLICT`.
- [x] Hai request tạo bảng giá cùng tuyến đồng thời → đúng một thành công.
- [x] Rule trùng phạm vi trong body → 400 `FARE_RULES_OVERLAP`, không ghi gì.
- [x] Loại xe mới phải `ACTIVE`; loại xe đang có được giữ dù đã ngừng dùng.

## PHẦN E — Lịch sử giá (Mongo audit)

- [x] Mỗi lần tạo/sửa đúng một bản ghi; mới nhất trước; `before` = `after` của lần trước; người sửa đúng; phân trang theo `createdAt`.
- [x] Nhà xe khác → 404 `FARE_NOT_FOUND`.
- [x] Ghi audit lỗi → 503, không đổi giá, không tạo bảng giá. Mutation "nuốt lỗi audit" → test đỏ.
- [x] Audit chậm (review High): ghi giới hạn 2s ở driver, Mongo chưa kết nối từ chối ngay, transaction hết hạn → 503; failpoint Mongo treo 6s → 503 sau ~2s, không có dòng lịch sử "ma" (evidence todo). Mutation bỏ giới hạn / bỏ kiểm kết nối → đỏ.
- [x] `PUT` không đổi gì (kể cả đảo thứ tự rule) → không thêm lịch sử; trang lịch sử tối đa 20, không trả trang rỗng thừa.

## PHẦN F — Giá ghế của chuyến (Q1 = PA1)

- [x] Giường nằm: ghế 300.000 / giường 320.000; đổi xe sang Limousine → 450.000; chuyến dịp Tết → 600.000.
- [x] Bảng giá `INACTIVE`, tuyến chưa có bảng giá, không có rule cho loại xe → `price = null`.

## PHẦN G — Contract & quyền

- [x] OpenAPI có 5 route fare (Bearer, requestBody, path param, 409, 503), route lịch sử (`limit` ≤ 20), `price` trong ghế chuyến (`openapi.spec.ts`).
- [x] HTTP: Owner được; không token 401; Employee/Platform 403; người sửa lấy từ token; body không mang `operatorId`; dữ liệu sai 400 không gọi service.
- [x] Client TS sinh lại (chỉ thêm phần fare + `price`); Dart client v7.25.0 + `build_runner`; `dart analyze` 0 error; `dart test` 528/528; phép so CI Contract khớp.

## PHẦN H — Test, review, CI & đóng task

- [x] `REQUIRE_DB_TESTS=1`, role app, Postgres 16 + Redis 7 + Mongo 7: 72/72 file, 849/849 test, 0 skip (sau sửa review).
- [x] Monorepo: lint + test + build 26/26, typecheck 10/10.
- [x] `code-reviewer` + `security-auditor` không còn finding blocking/high (High audit chậm đã sửa + test; bảng trong todo).
- [ ] Smoke guide §3 trên API chạy thật — chưa chạy. Tương đương: `fare.http.spec.ts` (route + guard thật) + `fare.int.spec.ts` (Postgres + Mongo thật).
- [x] AI journal đã ghi; không commit journal.
- [ ] CI branch xanh — Khanh xác nhận.
- [x] Màn Operator OS (danh sách + tạo / chỉnh sửa + lịch sử, giá trên chỗ của chuyến) — 13/10/2026, E2E 23 / 23.
- [ ] Task row §7.3 → `Done`.

## PHẦN I — Đưa về repo chính (13/10/2026)

- [x] Migration `20261013020000_add_fare` (gộp `add_fare` + `fare_price_cap`) áp được sau `20261013010000_add_trip`; `db:app-role` pass.
- [x] EXCLUDE phân biệt đủ 5 loại chỗ: giá thường của `BED_DOUBLE` / `CABIN` / `CABIN_DOUBLE` cùng tồn tại, dòng thứ hai cùng loại bị chặn; khung giờ chồng nhau của cùng loại bị chặn (`fare.int.spec.ts`).
- [x] `SeatType` khoá 5 giá trị trong `fare-dto.spec.ts` — thêm loại chỗ mà quên sửa `CASE` thì test đỏ.
- [x] Giá riêng của chỗ đôi không lấy nhầm giá loại đơn (`fare-pricing.spec.ts`).
- [x] Danh sách bảng giá trả `minPrice` / `maxPrice` / `hasDoubleSeatPrice` đúng, `null` khi chưa có rule (`fare.int.spec.ts`).
- [x] `REQUIRE_DB_TESTS=1`, role app, Postgres 16 + Redis + Mongo 7: 74 / 74 file, 937 / 937 test, 0 skip.
- [x] `pnpm lint` + `typecheck` + `test` + `build` cả monorepo đạt; client TS + Dart sinh lại (`dart analyze` 0 lỗi).
- [x] Operator OS: test đơn vị `lib/fare` (đọc giá gõ vào, khung giờ theo giờ Việt Nam, trùng phạm vi khớp máy chủ, tóm tắt lịch sử); E2E hai ca bảng giá.
- [x] `code-reviewer` + `security-auditor` cho phần port và màn Operator OS: không có finding chặn; 1 Medium + 8 Low đã sửa, phần hoãn có lý do — bảng ở todo. Sau sửa: Operator OS 280 test, E2E 23 / 23, lint + typecheck + build đạt.
- [x] Khanh chốt 14/10/2026: duyệt bổ sung API (#3); F1 (khung giờ = khoảng ngày giờ khởi hành) và F2 (dải cảnh báo để `TASK-ADM-001`) giữ như đã làm; khoảng giá tính cả quy tắc có khung giờ đã qua. F3, F4 không nằm trong các điểm Khanh trả lời — giữ như đã làm.
- [ ] CI branch xanh — Khanh xác nhận.
