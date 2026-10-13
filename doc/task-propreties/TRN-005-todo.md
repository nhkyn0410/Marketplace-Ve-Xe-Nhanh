# TASK-TRN-005 — Todo: Fare + FareRule

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` §7.3 — Fare + FareRule theo chuyến / loại ghế / thời điểm (= giờ khởi hành), lưu lịch sử giá, VND `BIGINT` không âm; giá theo chặng ngoài v1; **test money bắt buộc**. Nguồn chi tiết: SRS `FR-OPS-08`, `UC-14` bước 4, `BR-40`, `BR-41`, `OQ-08` (Fare/FareRule bảng riêng, Trip tham chiếu rule đang hiệu lực, booking lưu snapshot), `MQ-02`; DB §5.2 (`fares`, `fare_rules`), `DB-PRIN-03`, `DB-OQ-02`; LLD `LLD-PRIN-03` (thao tác tạo/sửa tiền phải audit), `LLD-PRIN-06` (tiền `BIGINT` + Decimal.js); ADR-011 (Mongo = audit/log); API §4 (VND = số nguyên đồng); UI §5 "fare form"; DOMAIN-MAP `fare/`; GLOSSARY `Fare / FareRule`, `VehicleType`.
> **Dependency:** TASK-TRN-003 (chuyến) — nhánh `TASK-TRN-005` tách từ nhánh TRN-003 (`claude/admiring-thompson-38d7s8`), chưa merge `develop`. Merge TRN-003 trước rồi đưa `develop` vào nhánh này.
> **Mở khóa:** TASK-TRN-006 (mở bán cần fare hợp lệ — BR-39), TASK-TRN-004 (search hiển thị giá), TASK-BTP-002 (booking snapshot giá).

## Trạng thái (13/10/2026) — 🔨 **ĐÃ ĐƯA VỀ REPO CHÍNH (BE + màn Operator OS), chờ Khanh review + CI**

- ✅ 13/10/2026: port sang repo chính trên nhánh `TASK-TRN-005` (từ `develop` sau khi TRN-003 merge PR #31) — chi tiết ở mục "Đưa về repo chính" cuối file.
- Các dòng dưới đây và bảng "Kết quả review" là ghi chép gốc ở repo bản sao (30/09/2026); tên migration và số test trong đó là của repo đó.

- ✅ Review `code-reviewer` + `security-auditor` đã xử lý (bảng "Kết quả review"); tài liệu đồng bộ: API v0.15, DB v0.17, LLD v0.11.

- ✅ Tạo nhánh `TASK-TRN-005`; đối chiếu SDLC (mới có nguyên tắc, chưa có cột bảng / endpoint / cách tính giá / nơi lưu lịch sử).
- ✅ Khanh chốt **Q2, Q3, Q5, Q6, Q7** theo khuyến nghị (30/09/2026). Tài liệu đã đồng bộ ngay: SRS `BR-41` v1.29 + GLOSSARY (Q3 — thời điểm = giờ khởi hành); file 11 TRN-005 + **ADM-001** (Q6 — cảnh báo trần/sàn chuyển sang ADM-001).
- ✅ Khanh chốt **Q1 = PA1** (bảng giá theo tuyến × loại xe catalog) và **Q4 = Mongo `audit_event`** (30/09/2026). **Đồng bộ tài liệu trước khi code** (rà mọi chỗ nhắc tới fare): SRS v1.30 (`FR-OPS-08`, §9, `UC-14` bước 4), GLOSSARY `Fare / FareRule`, HLD v0.9 (`HLD-OQ-05`), LLD v0.10 (FareService + dòng audit), DB v0.16 (§7 `fares`, `fare_rules`; không bảng lịch sử), API v0.14 (§7.3 route fare + giá ghế), Security v0.12, Test plan v0.8 (`TC-FARE-001..003`), file 11 v0.27.

---

## Phạm vi chuẩn

### Thuộc TRN-005

- Module `apps/api/src/fare/` (DOMAIN-MAP §2).
- Bảng giá + quy tắc giá theo loại xe / loại chỗ / khung giờ khởi hành; tính giá từng ghế của chuyến.
- Lịch sử thay đổi giá (BR-40) + audit (LLD-PRIN-03). Tiền `BIGINT` VND ≥ 0, **test money bắt buộc** (ADR-025).
- Zod DTO + OpenAPI + client TS/Dart; RLS + test tenant; màn Operator OS (M1 — sau khi có đăng nhập web).

### Không tự kéo vào task

- Giá theo chặng (BR-41); giá theo lúc mua vé (Q3).
- Khuyến mãi / voucher / VXN Plus (PROM-001/002, LOY-001); phí dịch vụ phụ thu khách (MQ-04: chưa v1).
- Booking snapshot giá (BTP-002) — TRN-005 chỉ cung cấp hàm tính giá để BTP-002 chụp lại.
- Mở bán kiểm "đã có giá" (TRN-006). Hiển thị giá ở search công khai (TRN-004).
- Khung trần/sàn + cảnh báo (FR-OPS-09, FR-ADM-09, OQ-17) → **TASK-ADM-001** (Q6).

---

## Quyết định đã chốt (30/09/2026)

| ID | Điểm | Quyết định |
| --- | --- | --- |
| Q2 | Dạng quy tắc giá | ✅ Mỗi rule = **giá tuyệt đối (VND)**, có hoặc không có khung giờ khởi hành. Rule không khung giờ = giá thường; có khung giờ = giá dịp lễ/Tết. **Rule cụ thể hơn thắng**; DB chặn hai rule cùng phạm vi chồng khung giờ. Không tăng/giảm theo % ở v1. |
| Q3 | "Theo thời điểm" | ✅ Theo **giờ khởi hành** của chuyến. Giá theo lúc mua vé ngoài v1. (SRS `BR-41` v1.29.) |
| Q5 | API + quyền | ✅ `GET/POST /operator/fares`, `GET/PUT /operator/fares/{fareId}` (PUT thay toàn bộ rule), `GET /operator/fares/{fareId}/revisions`; chi tiết chuyến trả **giá từng ghế**; quyền **dùng lại `trip:manage`** (Owner). Việc chuyến có trường `fareId` hay không phụ thuộc Q1. |
| Q6 | Khung trần/sàn (OQ-17) | ✅ **Chuyển sang TASK-ADM-001** (Admin cấu hình khung, M4). TRN-005 không cảnh báo. |
| Q7 | Sửa bảng giá đang được chuyến mở bán dùng | ✅ **Cho sửa**, ghi lịch sử; vé đã bán giữ giá (booking snapshot — BTP-002), đặt mới dùng giá mới. Bảng giá `INACTIVE` không dùng cho chuyến mới. |

---

## Q1 — Giá tách bạch theo loại xe — ✅ Khanh chọn **PA1** (30/09/2026)

**Yêu cầu:** cùng một tuyến, xe thường và xe VIP có giá khác nhau; đổi xe của chuyến (thường → VIP) thì giá đổi theo.

Hiện catalog loại xe (Platform quản lý, TRN-001 chỉ cho chọn từ catalog) có 4 loại: **Ghế ngồi** (`SEATER`), **Giường nằm** (`SLEEPER`), **Limousine**, **Cabin**. Mỗi xe có đúng một loại + mỗi ghế có loại chỗ `SEAT` (ghế) / `BED` (giường).

| Phương án | Giá được xác định bởi | Ví dụ SG → Đà Lạt | Ưu | Nhược |
| --- | --- | --- | --- | --- |
| **PA1 — Bảng giá theo tuyến, tách theo loại xe catalog** *(khuyến nghị)* | **Tuyến** × **loại xe** (catalog) × loại chỗ × khung giờ khởi hành. Mỗi tuyến một bảng giá; chuyến **tự** lấy giá theo tuyến + loại xe của xe đang gắn — **không cần chọn bảng giá cho chuyến**. | Giường nằm 300.000 · Limousine 450.000 · Cabin 550.000 · Tết: Limousine 600.000 | Tách bạch rõ nhất theo loại xe; đổi xe thường → VIP giá tự đổi; lịch lặp (TRN-007) tự có giá; không thêm khái niệm mới. | "VIP" phải là một loại xe trong catalog. Nhà xe có "giường nằm VIP" khác "giường nằm thường" → Admin thêm loại xe vào catalog (ADM-001), không đổi code. Không đặt được giá riêng cho một chuyến lẻ (mở lại nếu cần). |
| **PA2 — Như PA1 nhưng theo "hạng xe" do nhà xe tự đặt** | Tuyến × **hạng xe** (vd Thường / VIP / Royal — nhà xe tự tạo, gắn cho từng xe) × loại chỗ × khung giờ. | Thường 300.000 · VIP 450.000 | Linh hoạt nhất: hai xe cùng loại catalog (cùng giường nằm) vẫn tách giá theo chất lượng. | **Thêm khái niệm mới** ngoài SDLC: bảng hạng xe + cột trên xe + màn quản lý → mở rộng phạm vi TRN-001, sửa SRS/DB/API. |
| **PA3 — Bảng giá rời, chọn cho từng chuyến (`fareId`), có cột loại xe** *(khuyến nghị cũ + loại xe)* | Bảng giá do nhà xe đặt tên (nhiều bảng / tuyến), mỗi chuyến chọn một bảng; rule theo loại xe × loại chỗ × khung giờ. | "Giá thường", "Giá VIP cuối tuần"… chọn cho từng chuyến | Linh hoạt từng chuyến (chuyến đặc biệt giá riêng). | Mỗi chuyến phải chọn bảng giá; đổi xe mà bảng giá thiếu dòng cho loại xe mới → chuyến mất giá; dễ gắn nhầm bảng giá. |

**Khuyến nghị PA1**: đáp ứng đúng ví dụ (xe thường ≠ xe VIP, đổi xe là đổi giá) mà không thêm khái niệm; phần "VIP cùng loại catalog" xử lý bằng thêm loại xe ở catalog. Nếu Khanh xác nhận nhà xe **cần** VIP trong cùng một loại catalog → PA2.

Hệ quả của PA1 lên Q5: `POST /operator/fares` có `routeId` (một bảng giá / tuyến, unique), **không** thêm `fareId` vào chuyến; rule = (`vehicleTypeId` | mọi loại, `seatType` | mọi loại, khung giờ | không) → giá. Rule cụ thể hơn thắng theo thứ tự: có khung giờ > không; đúng loại xe > mọi loại; đúng loại chỗ > mọi loại. TRN-006 mở bán kiểm tuyến có giá cho loại xe của chuyến × mọi loại chỗ trên xe.

---

## Q4 — Lịch sử giá: Postgres hay Mongo? — ✅ Khanh chọn **M (Mongo `audit_event`)** (30/09/2026)

Bối cảnh:
- ADR-011: Mongo (cluster riêng) = **audit/log**, append-only (`audit_event`, FND-007; production chỉ cấp quyền `find` + `insert`).
- `LLD-PRIN-03`: tạo/sửa **tiền** phải audit → sửa bảng giá **dù sao cũng phải ghi `audit_event`**.
- Giá dùng để **thu tiền** được chụp vào booking (BTP-002, DB-PRIN-03) → lịch sử bảng giá chỉ để **xem lại + kiểm tra**, không dùng để tính tiền.
- IAM (IAM-005) đã có mẫu ghi audit Mongo: ghi "ý định" **trước** khi đổi Postgres (Mongo lỗi → không đổi gì), kết quả ghi sau (best-effort).

| Tiêu chí | **P — bảng `fare_revisions` (Postgres)** | **M — `audit_event` (Mongo)** |
| --- | --- | --- |
| Khớp thiết kế hiện có | Thêm bảng mới ngoài DB §5.2 | Dùng đúng hạ tầng ADR-011/FND-007; DB §5.2 không đổi |
| Số lần ghi mỗi lần sửa giá | 2 (revision Postgres + audit Mongo bắt buộc theo LLD-PRIN-03) | **1** (audit event chính là lịch sử) |
| Nhất quán với thay đổi giá | Tuyệt đối (cùng transaction) | Gần tuyệt đối: ghi audit **bên trong** transaction Postgres, **trước commit** → Mongo lỗi thì huỷ sửa giá; chỉ lệch nếu commit Postgres lỗi sau khi đã ghi Mongo (rất hiếm) → một dòng lịch sử "ma" |
| Chống sửa/xoá lịch sử | Cần policy RLS chỉ INSERT/SELECT (làm được, mẫu `stop_point_proposals`) | Mạnh hơn: app guard + user Mongo production không có quyền update/delete |
| Cách ly tenant khi đọc | RLS tự động | Chỉ ở tầng app: kiểm bảng giá thuộc tenant (Postgres) rồi lọc `operatorId` + `targetId` ở Mongo |
| Khi Mongo sập | Sửa giá vẫn chạy | Sửa giá bị chặn (giống thao tác tài khoản IAM); xem lịch sử lỗi |
| Báo cáo (RPT, ADM-001 khung giá) | JOIN SQL trực tiếp | Qua Mongo aggregation (RPT-002 vốn đọc audit Mongo) |

**Khuyến nghị sau khi xem xét: M (Mongo `audit_event`)** — vì sửa giá **bắt buộc** ghi audit Mongo (LLD-PRIN-03), dùng chính bản ghi đó làm lịch sử thì chỉ một nguồn, không thêm bảng ngoài DB §5.2; độ lệch hiếm gặp chấp nhận được vì lịch sử giá **không dùng để tính tiền** (tiền đã chụp vào booking). Cách ghi: bên trong transaction Postgres, sau khi ghi bảng giá, trước commit: `audit_event { action: "fare.create" | "fare.update", targetType: "fare", targetId, operatorId, actorId, before, after }` (before/after = toàn bộ rule). `GET /operator/fares/{fareId}/revisions` đọc từ Mongo sau khi kiểm bảng giá thuộc tenant.

Chọn **P** nếu Khanh muốn lịch sử giá vẫn xem/sửa giá được khi Mongo sập, hoặc báo cáo giá cần JOIN SQL.

---

### Giả định (không cần chốt riêng — Khanh phản đối thì sửa)

- **A1** — Tiền trong JSON là **số nguyên đồng** (API §4), Zod `int ≥ 0`, trần kỹ thuật 100.000.000 đ/ghế để chặn gõ nhầm; trong code dùng `bigint` / `BIGINT`, không `number` cho phép tính tiền.
- **A2** — Trạng thái bảng giá `ACTIVE`/`INACTIVE`, không xoá cứng.
- **A3** — Ghế không tìm được giá → `null` trong chi tiết chuyến; TRN-006 chặn mở bán khi còn ghế thiếu giá.
- **A4** — Khung giờ rule là `[từ, đến)` theo giờ khởi hành, lưu UTC như `trips`.

---

## Todo (ID = thứ tự thực hiện, sau khi chốt Q1 + Q4)

- [x] #0 Chốt Q2, Q3, Q5, Q6, Q7; đồng bộ SRS BR-41, GLOSSARY, file 11 (TRN-005 + ADM-001).
- [x] #1 [TRN-005.1] Chốt Q1 + Q4; đồng bộ SRS, GLOSSARY, HLD, LLD, DB, API, Security, Test plan, file 11 — đã rà mọi tài liệu nhắc tới fare (bài học TRN-003).
- [x] #2 [TRN-005.2] Schema + migration `20260930110000_add_fare` + RLS — `migrate diff` rỗng. Ghi chú: Postgres không cho ép `enum::text` trong EXCLUDE (không IMMUTABLE) → dùng `CASE` đổi loại chỗ sang số; thêm giá trị vào `SeatType` thì phải sửa hai ràng buộc.
- [x] #3 [TRN-005.3] Module `fare/` + API + giá ghế trong chi tiết chuyến; `AuditService.listAuditEvents`; `audit/audit.testing.ts` (luật ESLint cấm Mongoose ngoài `audit/`, kể cả file test).
- [x] #4 [TRN-005.4] OpenAPI (+5 operation, +5 schema, `TripResponse` thêm `price`) + client TS/Dart; phép so CI Contract khớp.
- [x] #5 [TRN-005.5] Test: 71/71 file, **835/835** test, 0 skip (Postgres/Redis/Mongo thật, role app); mutation 3/3 (EXCLUDE, RLS, nuốt lỗi audit) đỏ đúng chỗ.
- [x] #6 [TRN-005.6] Review (`code-reviewer` + `security-auditor`): không blocking; 1 High = 1 Medium trùng nhau (audit Mongo chậm trong transaction) đã sửa + test — bảng dưới. Sau sửa: 72/72 file, **849/849** test, 0 skip; lint + typecheck + build sạch.
- [x] #7 [TRN-005.7] Màn Operator OS — xong 13/10/2026 (mục "Đưa về repo chính"). CI: chờ Khanh mở PR vào `develop`.

### Kết quả review (30/09/2026)

| Nguồn | Mức | Finding | Xử lý |
| --- | --- | --- | --- |
| code-reviewer + security-auditor | **High / Medium** | Ghi audit Mongo trong transaction Postgres **không giới hạn thời gian**: Mongo chậm / failover (5–30s) → giữ kết nối pool + khoá dòng tới khi transaction hết hạn (5s) → trả 500, và lệnh Mongo vẫn ghi sau đó → **dòng lịch sử "ma"** (reviewer tái hiện: 500 sau 6s, lịch sử có giá 999 không tồn tại) | ✅ `AuditService.recordAuditEvent(…, { timeoutMs })`: kiểm schema như cũ → Mongo chưa kết nối thì **từ chối ngay** (Mongoose sẽ xếp hàng 10s rồi ghi "về sau") → ghi thẳng driver `insertOne` + CSOT `timeoutMS` (server nhận `maxTimeMS`, tự huỷ lệnh quá hạn). Fare dùng 2s; lỗi → `AuditWriteError` / P2028 → **503 `SERVICE_UNAVAILABLE`**. Evidence thủ công (failpoint `failCommand` chặn insert 6s, `AuditService` thật): **503 sau 2.018 ms, giá giữ nguyên, chờ 7s không có dòng "ma"**. Probe driver: `Model.create` bỏ qua `timeoutMS` (ghi xong sau 3s); `insertOne`/`timeoutMS` báo lỗi sau 0,8s và không có bản ghi về sau, cả khi Mongo sập hẳn. Test: audit lỗi → 503; audit chậm 6s → P2028 → 503, khoá dòng được nhả; Mongo chưa kết nối → lỗi < 1s; FareService luôn truyền `timeoutMs` (mutation bỏ → đỏ; bỏ kiểm `readyState` → đỏ). Rủi ro còn lại: commit Postgres lỗi **sau** khi Mongo đã ghi (rất hiếm) — như Q4 đã chấp nhận |
| security-auditor L1 + code-reviewer nit | Low | `PUT` không đổi gì vẫn ghi một dòng lịch sử; trang lịch sử 100 dòng × 2 bản chụp × 200 rule = vài MB; thiếu index Mongo cho đọc lịch sử | ✅ `PUT` trùng nội dung (kể cả đảo thứ tự rule) → không ghi DB, không thêm lịch sử (test). Trang lịch sử tối đa **20** (OpenAPI + Zod). Index `{targetType, targetId, createdAt: -1}` (schema + `mongo:audit:hardening`). Không thêm rate limit: chỉ Owner đã MFA sửa được bảng giá của chính mình |
| security-auditor L2 | Low | `InstantSchema` không chặn năm nhỏ: `0000-01-01T00:00+01:00` → UTC năm −1 → lưu được nhưng đọc lại 500 | ✅ Năm UTC 1970–9999 (test fare DTO: năm âm, 1969, > 9999; cursor lịch sử) |
| security-auditor L3 + code-reviewer #3 | Low | `listAuditEvents` đọc chung, trả cả tài liệu (`requestId`, `reason`…); action lạ trong `targetType: "fare"` làm hỏng cả trang lịch sử | ✅ Bắt buộc liệt kê `actions` (lọc `$in`), projection chỉ 5 trường của màn lịch sử, từ chối `operatorId` / `targetId` rỗng (test unit + int) |
| code-reviewer #2 | Low | `nextCursor` khác null khi trang vừa đủ → thêm một trang rỗng | ✅ Đọc `limit + 1`. Không thêm `_id` vào cursor: các lần ghi của một bảng giá tuần tự qua khoá dòng nên không trùng mili-giây; lệch đồng hồ giữa nhiều instance — v1 một instance |
| code-reviewer #4 | Low | DB chỉ chặn `price >= 0`; dòng ghi thẳng DB > 2^53 làm xem bảng giá / chi tiết chuyến trả 500 | ✅ Migration `20260930120000_fare_price_cap`: CHECK `price <= 100000000` (test: vượt trần bị chặn, đúng trần được) |
| code-reviewer #5 | Low | P2002 ở `update` cũng thành `FARE_ROUTE_CONFLICT` | ✅ Chỉ `create` đổi P2002 → 409. Giữ ánh xạ 23P01 làm chốt chặn cuối (service kiểm trước) |
| code-reviewer nit | Nit | `CASE … ELSE 2` coi loại chỗ mới là `BED` | ✅ Test khoá `SeatType = [SEAT, BED]` — thêm loại chỗ phải sửa EXCLUDE |
| security-auditor TRN-006 (L-1) | Low | Request xếp hàng chờ khoá dòng đã tiêu một phần hạn 5s của transaction; ghi audit thêm tối đa 2s có thể xong ở Mongo SAU khi Postgres hết hạn → dòng "ma" | ✅ `withScope` ghi tường minh hạn Prisma (chờ 2s, chạy 5s); `transactionDeadline(startedAt)` = 5s − 0,5s; `recordAuditEvent(…, { timeoutMs, deadline })` rút ngắn giới hạn theo phần còn lại, không đủ 200ms thì từ chối **trước khi ghi** (503). Fare truyền `deadline` (test: spy + audit int) |
| code-reviewer + security-auditor I1 | Nit | `audit.testing.ts` vào `dist` | ✅ `tsconfig.build.json` loại `**/*.testing.ts` |
| code-reviewer nit | Nit | fare ↔ trip dùng chéo `InstantSchema`, `routeUnavailable` | Giữ nguyên: không có vòng import file, chuyển sang `common/` là refactor ngoài phạm vi |
| code-reviewer nit | Nit | Ghim `w: "majority"` cho kết nối audit | Giữ nguyên: đổi cấu hình kết nối chung của IAM; Atlas mặc định `majority` |
| security-auditor I2–I4 | Info | Path param không kiểm UUID; cursor theo đồng hồ app; audit fare không có IP/thiết bị | Giữ nguyên: giống module khác (id sai → 404); v1 một instance; event đã có `requestId`/`traceId` để đối chiếu log truy cập |

## Rủi ro phải test chủ động

- Hai rule cùng phạm vi chồng khung giờ → giá không xác định.
- Khung giờ biên (đúng giờ bắt đầu / kết thúc Tết) chọn sai rule.
- Gắn bảng giá / tuyến của nhà xe khác (IDOR qua body).
- Sửa giá mà không có lịch sử, hoặc lịch sử bị sửa/xoá.
- Tiền bị ép qua `number` rồi làm tròn sai.

---

## Đưa về repo chính (13/10/2026)

Nhánh `TASK-TRN-005` từ `develop` (đã có TRN-003, PR #31). Chưa commit — chờ Khanh review.

### Khác với bản ở repo bản sao

| # | Điểm | Lý do |
| --- | --- | --- |
| 1 | Một migration `20261013020000_add_fare` thay cho hai (`add_fare` + `fare_price_cap`) | Repo chính chưa có bản nào chạy migration cũ nên gộp; thứ tự đặt sau `20261013010000_add_trip` |
| 2 | Hai ràng buộc EXCLUDE của `fare_rules` đổi loại chỗ sang số bằng `CASE` đủ 5 giá trị (`SEAT` 1 … `CABIN_DOUBLE` 5, "mọi loại" 0) | Bản gốc chỉ biết `SEAT` / `BED` (`ELSE 2`) nên giá thường của giường đơn và cabin sẽ bị chặn nhầm là trùng (BR-78, `TASK-TRN-010`). Test `fare-dto.spec.ts` khoá danh sách 5 loại; `fare.int.spec.ts` kiểm từng loại không đụng nhau và trùng thì bị chặn |
| 3 | `GET /operator/fares` trả thêm `minPrice`, `maxPrice`, `hasDoubleSeatPrice` | Cột "Khoảng giá mỗi chỗ" + dòng "Gồm giá chỗ đôi" của Figma `1665:24187`. **Bổ sung của AI ngoài contract gốc — cần Khanh duyệt.** Tính trong service từ các rule của trang (so `bigint`), không thêm truy vấn |
| 4 | Test tích hợp dựng tuyến với `allowPickup` / `allowDropoff` và loại xe có `form` + `class` | Schema hiện tại của `TASK-TRN-012` / `TASK-TRN-010` |

Không đổi: quyết định Q1–Q7, cách tính giá (`resolveSeatPrice`), ghi lịch sử vào Mongo trong transaction có giới hạn thời gian, mã lỗi.

### Màn Operator OS

- Thanh bên thêm mục **Bảng giá** (sau "Tuyến đường") — đúng thành phần sidebar của Figma đã có mục này.
- `/fares` — danh sách: mỗi tuyến một dòng (ghép danh sách tuyến với danh sách bảng giá ở phía giao diện), tìm không dấu, lọc trạng thái gồm "Chưa có bảng giá".
- `/fares/new` (nhận `?routeId=`), `/fares/{id}` — bảng quy tắc + khối thêm / sửa quy tắc + thông tin bảng giá + lịch sử thay đổi.
- Trang chi tiết chuyến: chỗ còn trống ghi giá, thiếu giá ghi "Chưa có giá" kèm dòng nhắc mở Bảng giá.

### Điểm làm khác khung Figma — cần Khanh xem

| # | Figma `1665:24475` | Đã làm | Lý do |
| --- | --- | --- | --- |
| F1 | Cột "Giờ khởi hành" ghi giờ trong ngày ("Cả ngày", "18:00 – 24:00"); hai ô "Từ giờ" / "Đến giờ" | Cột "Khung giờ khởi hành" ghi khoảng ngày giờ ("Mọi ngày", "20/01/2031 00:00 – 27/01/2031 00:00"); hai ô ngày giờ "Khởi hành từ" / "Đến trước" | Q2 + Q3 + A4 đã chốt 30/09: khung giờ là khoảng thời điểm khởi hành `[validFrom, validTo)` cho giá dịp lễ / Tết; backend, DB và test đều theo nghĩa này. Giá theo giờ trong ngày (lặp lại hằng ngày) **không có trong thiết kế đã chốt** — muốn có thì phải mở lại Q2 |
| F2 | Dải vàng "Vé Xe Nhanh có thể cảnh báo khi giá nằm ngoài khung giá…" | Không hiện | Khung trần / sàn và cảnh báo đã chuyển sang `TASK-ADM-001` (Q6); hiện chưa có gì để cảnh báo |
| F3 | Lịch sử ghi ngày ngắn "08/10 · 14:20", có link "Xem toàn bộ lịch sử ›" | Ghi đủ năm "08/10/2026 14:20"; nút "Xem thêm lịch sử ›" tải thêm 5 dòng ngay trong thẻ | Lịch sử kéo dài qua nhiều năm; chưa có màn lịch sử riêng trong thiết kế |
| F4 | Nút "Tạo bảng giá" ở đầu trang danh sách | Mở `/fares/new` với ô chọn tuyến (chỉ tuyến đang hoạt động chưa có bảng giá) | Figma không vẽ bước chọn tuyến |

### Evidence (13/10/2026)

- Migration áp trên PostgreSQL 16 (database thử riêng), `db:app-role` pass.
- API, `REQUIRE_DB_TESTS=1`, role app, Postgres 16 + Redis + Mongo 7 thật: **74 / 74 file, 937 / 937 test, 0 skip**; lint sạch.
- `pnpm lint`, `pnpm typecheck`, `pnpm test`, `pnpm build` cả monorepo: đạt (chạy lại sau khi sửa review). Operator OS 280 test (61 test cho `lib/fare`).
- OpenAPI: thêm đúng 5 operation + 5 schema, `TripResponseDto_Output` thêm `price`; không mất gì. Client Dart sinh bằng openapi-generator v7.25.0, `dart analyze` 0 lỗi, `dart test` 539 / 539.
- E2E Playwright (Chrome): 23 / 23 (chạy lại sau khi sửa review) — hai ca mới ở cuối `trips.e2e.ts` (tạo bảng giá, quy tắc trùng bị chặn, giá hiện trên chỗ của chuyến, sửa giá ghi lịch sử, ngừng áp dụng thì chỗ mất giá).
- Soi trên trình duyệt với API chạy thật: màn danh sách và màn chỉnh sửa đúng bố cục Figma (trừ F1–F4).

### Kết quả review phần port + màn Operator OS (13/10/2026)

`security-auditor`: không có Critical / High / Medium. `code-reviewer`: không có Blocking / High. Không finding nào chặn đóng task.

| Nguồn | Mức | Finding | Xử lý |
| --- | --- | --- | --- |
| cả hai | Medium / Low | `parsePrice` xóa mọi dấu chấm: gõ `300.00` ra 30.000 đ, `1.5` ra 15 đ, `300.5` ra 3.005 đ | ✅ Chỉ nhận dãy chữ số liền hoặc dấu chấm / khoảng trắng ngăn đúng nhóm ba số; còn lại báo lỗi tại ô. Thêm 9 ca từ chối vào `fare-form.test.ts` |
| cả hai | Low | Tạo bảng giá: `routeId` lấy từ `?routeId=` vẫn được gửi dù ô "Tuyến" hiện trống (tuyến không nằm trong danh sách chọn, hoặc danh sách chưa tải / tải lỗi) | ✅ Chỉ lưu khi tuyến đúng là lựa chọn đang hiện; danh sách tuyến tải lỗi thì báo ngay tại ô |
| code-reviewer | Low | Tải lại ngầm bị lỗi (đổi tab rồi quay lại) thay cả form đang sửa bằng khung lỗi → mất quy tắc chưa lưu | ✅ Khung lỗi chỉ hiện khi chưa có dữ liệu; tắt tải lại khi quay lại tab cho bảng giá đang mở. Sửa luôn cùng lỗi ở `trip-form.tsx` (TRN-003) |
| code-reviewer | Low | Sửa / xóa / thêm quy tắc trong lúc đang lưu bị kết quả lưu ghi đè lặng lẽ | ✅ Khóa ba nút khi đang lưu |
| code-reviewer | Low | Sơ đồ ghế của chuyến mất chỉ dấu "· Đôi" sau khi ô ghế đổi sang ghi giá | ✅ Ghi lại "· Đôi" sau giá / tình trạng |
| code-reviewer | Low | Danh mục loại xe chưa tải xong hoặc tải lỗi bị hiện thành "Loại xe đã ngừng dùng" | ✅ Ghi "Đang tải…" / "Chưa tải được loại xe"; tải lỗi có dòng báo kèm nút Thử lại |
| code-reviewer | Low | Chặn năm trước 1970 ở giờ vào API làm bộ lọc ngày của danh sách chuyến trả 400 khi đang gõ dở năm (`0202-…`) | ✅ Màn danh sách chuyến không gửi mốc có năm trước 1970 (coi như chưa nhập xong); thêm ca 400 vào `trip.http.spec.ts` |
| code-reviewer | Low | Mở / đóng khối nhập quy tắc làm mất tiêu điểm bàn phím | ✅ Mở thì tiêu điểm vào ô "Loại xe"; đóng thì trả về nút "Thêm quy tắc" |
| code-reviewer | Nit | Chú thích của `sameContent` lạc sang `priceRange`; khoảng ký tự dấu viết bằng ký tự thô; `key` theo vị trí dòng; dải "Đã lưu" không tắt khi đổi trạng thái / ghi chú; lỗi "Xem thêm lịch sử" bị nuốt; câu báo 503 gán cứng nguyên nhân "lịch sử giá" | ✅ Đã sửa cả sáu |
| code-reviewer | Nit | `minPrice` / `maxPrice` tính cả quy tắc có khung giờ đã qua (giá Tết năm trước vẫn nằm trong khoảng giá) | ⏸ Đúng mô tả hiện tại của API; nêu để Khanh quyết có lọc theo thời điểm hay không |
| code-reviewer | Nit | Lịch sử luôn ghi "Chủ nhà xe", không dùng `actorId` | ⏸ Chỉ Owner sửa được bảng giá; cần tên hiển thị của tài khoản (chưa có API) mới ghi được ai |
| code-reviewer | Nit | Trang chuyến chỉ nhắc khi chỗ thiếu giá, không nhắc chỗ giá 0 đ (BR-39 đòi giá > 0) | ⏸ Điều kiện mở bán thuộc `TASK-TRN-006` |
| code-reviewer | Nit | `take: limit + 1` tải thừa rule của một dòng; sửa quy tắc tạo ngoài giao diện thì mất phần giây | ⏸ Không đáng kể |
| security-auditor | Info | Hạn chót ghi audit tính sau lệnh `set_config` (ăn bớt một lượt gọi Postgres trong biên 500 ms) | ⏸ Giữ như bản gốc; cùng loại rủi ro đã chấp nhận ở Q4 |
| security-auditor | Info | `fareId` nối thẳng vào URL API không mã hóa (mẫu chung của mọi `*-api.ts`); dải "Đã lưu" bật theo `?saved=1` khi tải lại trang | ⏸ Mẫu có sẵn của các màn khác, không riêng TRN-005 |
| security-auditor | Info | Ghi chú tự do nằm trong bản chụp audit không xóa được | ⏸ Xét khi làm chính sách lưu trữ dữ liệu |
| security-auditor | Info | Giá 0 hợp lệ và bảng giá sửa được sau khi mở bán → luồng đặt vé phải tự kiểm giá `null` / 0 lúc giữ chỗ | ⏸ Bàn giao `TASK-TRN-006` / `TASK-BTP-002` |
