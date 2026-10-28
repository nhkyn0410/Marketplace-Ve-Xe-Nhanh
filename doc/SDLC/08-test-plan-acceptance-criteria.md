# 08. Test Plan & Acceptance Criteria - Hệ thống đặt vé xe khách

## 1. Thông tin tài liệu

### 1.1. Metadata

| Thuộc tính    | Giá trị                          |
| ------------- | -------------------------------- |
| Tên tài liệu  | Test Plan & Acceptance Criteria  |
| Mã tài liệu   | 08-test-plan-acceptance-criteria |
| Dự án         | Marketplace-Ve-Xe-Nhanh          |
| Trạng thái    | Draft                            |
| Người viết    | Nguyễn Hồng Khanh, AI Agent        |
| Người duyệt   | Nguyễn Hồng Khanh                |
| Ngày tạo      | 11/05/2026                       |
| Ngày cập nhật | 28/10/2026                       |

### 1.2. Lịch sử thay đổi

| Phiên bản | Ngày       | Người cập nhật | Nội dung thay đổi                         |
| --------- | ---------- | -------------- | ----------------------------------------- |
| v0.1      | 11/05/2026 | AI Agent       | Tạo bản nháp Test Plan & Acceptance Criteria |
| v0.2      | 01/06/2026 | AI Agent       | **Sprint 4 Rework** — bake **ADR-025** test framework (Vitest + Supertest + Playwright + Maestro) + stack ADR. §4 strategy map tool cụ thể; §6 môi trường Postgres/Mongo Testcontainers + VNPay/MoMo sandbox; §8/§9 thêm mandatory test money BIGINT/idempotency dedup/tenant RLS/webhook HMAC/OAuth (ADR-009/011/015/017/019). Đóng TEST-OQ-02 (sandbox VNPay+MoMo+Resend+Expo per ADR-019/020); refine TEST-OQ-01. |
| v0.3      | 25/09/2026 | AI Agent       | **TASK-OQ-05 / TASK-IAM-006:** thêm acceptance + Supertest/Playwright cho dual transport, cookie flags, CSRF/CORS, `/auth/me`, first-login/TOTP, refresh single-flight và hồi quy Mobile JSON/Bearer. Giữ trạng thái Draft. |
| v0.4      | 28/09/2026 | AI Agent       | **ADR-017 amend / TASK-IAM-006 (Khanh chốt 28/09):** thêm TC-SEC-009..011 cho tách cổng Owner/Employee, cổng Employee chỉ Bearer, CHECK tiền tố `nv.` và migration đổi tên. Giữ trạng thái Draft. |
| v0.5      | 29/09/2026 | AI Agent       | **Loyalty VXN Plus / ví voucher / bài viết (Khanh chốt 29/09/2026, SRS v1.21):** §5 scope Loyalty / Content; §7 truy vết `FR-LOY-*`, `FR-PROM-08..10`; §8 AC; §9 `TC-LOY-001..007`, `TC-CNT-001` (loyalty ledger / voucher vào nhóm bắt buộc money + idempotency). |
| v0.6      | 30/09/2026 | AI Agent       | **A2 — đăng ký nhà xe theo closed enrollment (Khanh duyệt 30/09/2026, SRS v1.23)**: thêm `TC-OPR-001..003` (link bảo mật, duyệt hồ sơ tạo đúng một Operator + Owner, form công khai không lộ email). |
| v0.7      | 30/09/2026 | AI Agent       | **TASK-TRN-003:** §9 thêm `TC-TRN-001..003` (một xe không chạy hai chuyến chồng giờ kể cả request đồng thời — không đệm quay đầu; tenant-RLS/IDOR chuyến; sơ đồ ghế đang được chuyến dùng không sửa được). |
| v0.8      | 30/09/2026 | AI Agent       | **TASK-TRN-005:** §9 thêm `TC-FARE-001..003` (rule cụ thể nhất thắng + biên khung giờ, money `BIGINT`; lịch sử giá ghi trong transaction — audit lỗi thì không đổi giá; tenant-RLS bảng giá). |
| v0.9      | 30/09/2026 | AI Agent       | **TASK-TRN-006:** §9 thêm `TC-TRN-004..007` (điều kiện mở bán trả đủ lý do, bảng chuyển trạng thái + đồng thời, khóa ghế theo lô + giữ khi đổi xe, audit / tenant). Giữ trạng thái Review. |
| v0.10     | 30/09/2026 | AI Agent       | **TASK-TRN-006 (review):** `TC-TRN-005` sửa mô tả đồng thời (xếp hàng, không phải "một thắng" khi cả hai chuyển đều hợp lệ) + thêm hủy lúc ghế đang được bán. Giữ trạng thái Review. |
| v0.11     | 03/10/2026 | AI Agent       | **Hình ảnh phương tiện (SRS v1.32):** §7 truy vết `FR-OPS-16`, `FR-MKT-15`, `FR-ADM-20`; §8 AC ảnh phương tiện; §9 thêm `TC-TRN-008..011` (giới hạn + kiểm file, tenant-RLS, đồng thời, hiển thị công khai + Admin gỡ). Giữ trạng thái Draft. |
| v0.12     | 04/10/2026 | AI Agent       | **Phân loại xe và loại chỗ (Khanh chốt 04/10/2026, SRS v1.33):** §9 thêm `TC-TRN-012..013` (lọc dạng chỗ / hạng xe độc lập; 5 loại chỗ, sức chứa chỗ đôi, giá riêng cho chỗ đôi). Giữ trạng thái Draft. |
| v0.13     | 04/10/2026 | AI Agent       | **Đối chiếu Figma nhà xe (Khanh chốt 04/10/2026):** `TC-TRN-008` thêm chú thích ảnh; thêm `TC-TRN-014` (`deckCount`, `inUse`, `seatMapLocked`). Giữ trạng thái Draft. |
| v0.14     | 04/10/2026 | AI Agent       | **Thiết kế lại điểm dừng (Khanh chốt 04/10/2026, SRS v1.35):** §7 truy vết; §8 AC điểm dừng; §9 thêm `TC-TRN-015..019` (loại điểm + đề xuất, cho đón / cho trả, Admin duyệt, Admin khóa, tìm theo vị trí). Giữ trạng thái Draft. |
| v0.15     | 13/10/2026 | AI Agent       | **Đưa `TASK-TRN-003` về repo chính:** §9 thêm `TC-TRN-020` (điểm dừng của chuyến chép cho đón / cho trả từ tuyến + CHECK ở DB) và `TC-TRN-021` (E2E màn Chuyến xe Operator OS). Giữ trạng thái Draft. |
| v0.16     | 13/10/2026 | AI Agent       | **Đưa `TASK-TRN-005` về repo chính:** §9 thêm `TC-FARE-004` (ràng buộc trùng phạm vi đủ 5 loại chỗ + khoảng giá ở danh sách) và `TC-FARE-005` (E2E màn Bảng giá Operator OS). Giữ trạng thái Draft. |
| v0.17     | 14/10/2026 | AI Agent       | **Đưa `TASK-TRN-006` về repo chính:** §9 thêm `TC-TRN-022` (E2E màn Chuyến xe — mở bán, khóa chỗ, tạm dừng, thu hồi về nháp, hủy). `TC-TRN-004..007` giữ nguyên. Giữ trạng thái Draft. |
| v0.18     | 14/10/2026 | AI Agent       | **Màn Nhân viên và màn Tài khoản của Operator OS:** §9 thêm `TC-SEC-012` (E2E quản lý nhân viên có xác nhận lại danh tính + thu hồi phiên). Giữ trạng thái Draft. |
| v0.19     | 14/10/2026 | AI Agent       | **`TASK-TRN-009` (ảnh phương tiện):** `TC-TRN-008..010` có test tự động (`vehicle-image.int.spec.ts` trên Postgres thật, role app); §9 thêm `TC-TRN-023` (E2E khối ảnh của form xe). Giữ trạng thái Draft. |
| v0.20     | 14/10/2026 | AI Agent       | **`TASK-OPR-001` (đăng ký nhà xe):** `TC-OPR-001`, `TC-OPR-003` có test tự động (`operator-application.int.spec.ts` + `.http.spec.ts`); §9 thêm `TC-OPR-004` (E2E trang đăng ký công khai). Giữ trạng thái Draft. |
| v0.21     | 15/10/2026 | AI Agent       | **`TASK-ADM-001` (duyệt hồ sơ nhà xe):** `TC-OPR-002` có test tự động (`operator-application-review.int.spec.ts` trên Postgres thật, role app: gửi lặp cùng khóa / đồng thời / hai Admin khác slug → một Operator + một Owner; slug trùng không tạo gì) — **trừ** vế giấy tờ và tài khoản nhận tiền sang tenant (chưa làm, `ADM-001-todo.md` G1); §9 thêm `TC-OPR-005` (E2E màn duyệt hồ sơ của Admin). Giữ trạng thái Draft. |
| v0.22     | 15/10/2026 | AI Agent       | **`TASK-ADM-004`:** `TC-TRN-017` và phần Admin của `TC-TRN-018` có test tự động (`admin-stop-point.int.spec.ts` trên Postgres thật, role app; `.http.spec.ts` guard thật); §9 thêm `TC-TRN-024` (E2E màn Điểm dừng của Admin). Giữ trạng thái Draft. |
| v0.23     | 16/10/2026 | AI Agent       | **`TASK-ADM-001` phần danh mục:** §9 thêm `TC-ADM-002` (màn Danh mục chuẩn, E2E `catalog.e2e.ts`); test tích hợp `admin-catalog.int.spec.ts` (Postgres thật, role app: trùng mã, audit trước–sau, ngừng dùng → ẩn khỏi API công khai, ngừng lần nữa 409, audit lỗi → 503 không lưu) + `admin-catalog.http.spec.ts` (guard thật 14 route). Giữ trạng thái Draft. |
| v0.24     | 16/10/2026 | AI Agent       | **A5 Admin:** §9 thêm `TC-ADM-003` (gỡ ảnh phương tiện) và `TC-ADM-004` (nhật ký audit) — test tích hợp `admin-vehicle-image.int.spec.ts` (Postgres thật, role app + kho ổ đĩa), `admin-audit-log.int.spec.ts` (Mongo + Postgres thật), guard thật ở hai `.http.spec.ts`, E2E `moderation-audit.e2e.ts`. Giữ trạng thái Draft. |
| v0.25     | 17/10/2026 | AI Agent       | **Đợt hoàn thiện Admin + Operator OS (Khanh 16/10/2026, chờ duyệt):** `TC-OPR-002` đủ vế giấy tờ + tài khoản nhận tiền sang tenant (`operator-application-review.int.spec.ts`); §9 thêm `TC-CNT-002` (bài viết), `TC-OPR-006` (hồ sơ & KYC, đổi tài khoản nhận tiền), `TC-ADM-005` (quản lý tài khoản), `TC-ADM-006` (chính sách, hoa hồng, khung giá), `TC-ADM-007` (tích hợp & hệ thống chỉ đọc, khung màn chờ đặt vé), `TC-TRN-025` (lịch xe), `TC-FARE-006` (cảnh báo khung giá). Giữ trạng thái Draft. |
| v0.26     | 17/10/2026 | AI Agent       | **Phần không cần đặt vé (Khanh 17/10/2026, chờ duyệt):** §9 thêm `TC-TRN-026` (lịch chuyến lặp lại), `TC-EMP-003` (phân công tài xế), `TC-ADM-008` (nội dung công khai). Giữ trạng thái Draft. |
| v0.27     | 19/10/2026 | AI Agent       | **Sáu phần tiếp theo (Khanh 19/10/2026, chờ duyệt):** §9 thêm `TC-EMP-004/005` (soát vé, vận hành chuyến), `TC-PAY-004` (đối soát tự động), `TC-RPT-001/002`, `TC-DSP-001..003`, `TC-PROM-001..003`; ghi trạng thái hiện thực `TC-LOY-001/005/006/007` (`TC-LOY-002..004` chờ ví voucher). Giữ trạng thái Draft. |
| v0.28     | 25/10/2026 | AI Agent       | **`TASK-IAM-007` — phân quyền theo từng tài khoản (Done 25/10/2026, thiết kế chờ duyệt):** §8 thêm AC "Phân quyền theo tài khoản"; §9 thêm `TC-SEC-013..016` (`can()` + trần quyền, claim `perms`, Admin phân quyền không leo thang, Owner quản lý tài khoản quản lý) kèm file test đã có; ghi rõ phần **chưa có test tự động** (người cuối cùng có `access:manage`, E2E hai màn). Giữ trạng thái Draft. |
| v0.29     | 28/10/2026 | AI Agent       | **Giờ đến theo tuyến (Khanh 27/10/2026, chờ duyệt):** §9 thêm `TC-TRN-027`; `TC-TRN-021` giờ đến không còn ô nhập. |
| v0.30     | 28/10/2026 | AI Agent       | **Admin giám sát (Khanh 28/10/2026, chờ duyệt):** §9 thêm `TC-ADM-009` (chi tiết nhà xe / tài khoản hành khách, tuyến + chuyến + danh sách người đi, ẩn tiền khi thiếu quyền, audit lượt xem, báo cáo theo tuyến / khu vực, tìm giao dịch theo SĐT người đặt). |
| v0.29     | 27/10/2026 | AI Agent       | **Logo nhà xe + trang công khai (FR-OPR-02, TASK-MKT-001; Khanh 27/10/2026, tự thiết kế — chờ duyệt):** §9 thêm `TC-OPR-007` (logo: gắn / thay / gỡ, file sai, tenant-RLS, đồng thời, audit lỗi, guard route) và `TC-OPR-008` (E2E logo + Mở trang nhà xe + Xem trước trên ứng dụng). Giữ trạng thái Draft. |
| v0.30     | 27/10/2026 | AI Agent       | **Tìm theo phường + gợi ý địa điểm (chờ duyệt):** §9 thêm `TC-TRN-027`. Giữ trạng thái Draft. |

---

## 2. Mục lục

1. Thông tin tài liệu
2. Mục lục
3. Giới thiệu
4. Test strategy
5. Test scope
6. Test environment
7. Traceability matrix
8. Acceptance criteria theo nhóm
9. Test case nháp trọng yếu
10. Entry / Exit criteria
11. Open Questions / TBD

---

## 3. Giới thiệu

Tài liệu này mô tả chiến lược kiểm thử, tiêu chí nghiệm thu và test case nháp. Test framework đã chốt (ADR-025): **Vitest** (unit+integration BE+FE monorepo), **Supertest** (e2e API), **Playwright** (e2e web), **Maestro** (e2e mobile Flutter) + `flutter_test` / `integration_test` (widget + E2E in-app). Tham chiếu: `01-srs`, `03-lld`, `04-db`, `05-api`, `07-security`, `10-adr` (v0.21 — ADR-025 + 009/011/015/017/019).

---

## 4. Test strategy

| Cấp độ test | Tool (ADR-025) | Mục tiêu | Chủ thể |
| ----------- | -------------- | -------- | ------- |
| Unit | **Vitest** | Logic service, policy, validation, state transition, money math | Developer |
| Integration | **Vitest** + Testcontainers | Module với Postgres/Mongo/Redis thật, queue, provider mock | Developer/QA |
| API contract / e2e | **Supertest** | Endpoint, Zod DTO, RFC 7807 error code, permission, RLS | QA/Developer |
| E2E Web | **Playwright** | Luồng marketplace/operator/admin chính | QA |
| E2E Mobile | **Maestro** + `integration_test` | Luồng passenger + employee (booking, check-in) | QA |
| Security | Vitest + Supertest | Auth, RBAC, tenant RLS, IDOR, rate limit, webhook HMAC | QA/Security |
| Performance | k6/Artillery (chốt LLD) | Search, seat hold, payment callback, report export | QA/DevOps |
| UAT | Manual | Người duyệt xác nhận nghiệp vụ | Người duyệt/PO |

---

## 5. Test scope

| Nhóm | Trong scope | Mức ưu tiên |
| ---- | ----------- | ----------- |
| IAM | Đăng ký, login 3-namespace, OTP/OAuth, refresh rotation, TOTP, session revoke; Web cookie/CSRF/CORS/bootstrap và hồi quy Mobile Bearer | Cao |
| Marketplace | Search, filter, trip detail, seat map, booking, ticket | Cao |
| Booking/Payment | SeatHold (Redis), create booking, VNPay/MoMo callback, refund, escrow | Rất cao |
| Operator OS | KYC, vehicle, route, trip, booking list, finance, payout | Cao |
| Employee | Assignment, passenger list, QR check-in, incident report | Cao |
| Admin | KYC approval, policy, payment/refund, payout confirm, dispute, audit | Cao |
| Notification | Fan-out email/push/sms-noop, delivery retry, preference | Trung bình |
| Reporting | Dashboard, filter, async export | Trung bình |
| Loyalty / ví voucher | Tích điểm, hạng, đổi điểm, hết hạn, voucher giữ / dùng / trả, phần giảm Platform chịu | Rất cao |
| Content | Bài viết CRUD / xuất bản, đọc công khai, sanitize | Thấp |

---

## 6. Test environment

| Môi trường | Tool | Ghi chú |
| ---------- | ---- | ------- |
| Local | Vitest + Testcontainers | Postgres 16 + Mongo 7 ephemeral; Redis local/Upstash dev |
| CI | GitHub Actions + Vitest + Turborepo affected | Seed data ổn định; tách unit (mọi commit) vs integration/e2e (scheduled) (ADR-026) |
| Staging | Playwright + Maestro + Supertest | Sandbox **VNPay + MoMo** + **Resend** + **FCM/APNs**; KYC local adapter |
| Production | Smoke test sau deploy | Không dùng dữ liệu giả nhạy cảm |

---

## 7. Traceability matrix

| Nguồn | Test artifact cần có |
| ----- | -------------------- |
| FR-IAM-* | Auth Vitest/Supertest/security (3-namespace, token, TOTP, RLS) |
| FR-MKT-* | Search/trip/booking Vitest/Playwright |
| FR-BTP-* | SeatHold/payment/ticket/refund/escrow Vitest integration + Supertest |
| FR-OPR-* | Operator onboarding/finance/payout Supertest/Playwright |
| FR-OPS-* | Vehicle/route/trip/fare/inventory Vitest |
| FR-EMP-* | Employee Maestro (mobile)/Supertest/check-in |
| FR-ADM-* | Admin Playwright/Supertest/security/audit |
| FR-NSR-* | Notification/support/review/reporting Vitest |
| FR-DSP-* | Dispute state machine Vitest |
| FR-LOY-* | Sổ điểm / đổi điểm / hết hạn Vitest integration (money + idempotency bắt buộc); màn VXN Plus Playwright + Maestro |
| FR-PROM-08..10 | Ví voucher Vitest / Supertest; chọn voucher ở checkout Playwright |
| FR-MKT-14, FR-ADM-18..19 | Bài viết Supertest (public chỉ `PUBLISHED`) + sanitize |
| FR-OPS-16, FR-MKT-15, FR-ADM-20 | Ảnh phương tiện: Vitest integration (giới hạn, kiểm file, tenant-RLS) + Supertest (Admin gỡ, audit) + Playwright (tải ảnh ở Operator OS, hiển thị ở Marketplace) |
| FR-OPS-04..05, FR-OPS-17, FR-ADM-21, FR-MKT-01, FR-MKT-09 | Điểm dừng: Vitest integration (loại điểm, cho đón / cho trả, khóa, tenant-RLS, tìm theo vị trí) + Supertest (Admin duyệt / khóa, audit) + Playwright (màn Điểm dừng của nhà xe và Admin) |
| NFR-* | Performance, security (RLS/IDOR), availability, privacy |

---

## 8. Acceptance criteria theo nhóm

| Nhóm | Acceptance criteria |
| ---- | ------------------- |
| User booking | User tìm chuyến, chọn ghế, tạo booking, thanh toán (VNPay/MoMo) thành công, nhận ticket QR, xem lại ticket. |
| Seat safety | Hai user không thể mua cùng một ghế trên cùng chuyến dù thao tác đồng thời (Redis SET NX EX). |
| Payment safety | Callback trùng không tạo payment/booking/ticket/ledger trùng (dedup `(provider, provider_txn_id)`). |
| Money correctness | Mọi tính tiền dùng BIGINT/Decimal; commission/refund/payout không sai số làm tròn (ADR-009/011). |
| Refund | User/Admin hủy vé đúng policy snapshot, refund state rõ, audit ghi. |
| Tenant isolation | Operator chỉ xem/quản lý dữ liệu tenant mình; RLS chặn cả khi app guard miss (ADR-011/017). |
| Web auth | Operator OS/Admin hoàn tất first-login/TOTP, nhận cookie đúng flags, reload bootstrap được; CSRF/origin sai bị chặn; Mobile JSON/Bearer không đổi. |
| Phân quyền theo tài khoản | Tài khoản quản trị / quản lý nhà xe chỉ dùng được quyền được tick (trong trần của role); người cấp không cấp được quyền mình không có; đổi quyền / khóa có hiệu lực ngay (thu hồi phiên); menu / nút ẩn theo quyền nhưng server vẫn kiểm từng request. |
| Employee | Employee chỉ check-in chuyến được phân công, không xem dữ liệu ngoài scope. |
| Admin | Admin xử lý KYC/refund/dispute/payout có re-auth/TOTP/audit với quyền phù hợp. |
| Notification | Ticket vẫn xem được dù email/push thất bại; delivery retry ghi nhận (BullMQ DLQ). |
| Reporting | Báo cáo lớn không làm chậm luồng booking/payment/check-in chính. |
| Loyalty | Điểm cộng đúng một lần khi chuyến `COMPLETED`; đổi điểm không âm số dư, không tạo voucher trùng; escrow Operator không bị giảm bởi voucher đổi điểm, phần Platform chịu khớp ledger. |
| Content | Chỉ bài `PUBLISHED` hiển thị công khai; nội dung chứa script không chạy. |
| Ảnh phương tiện | Operator quản lý tối đa 8 ảnh / xe trong tenant của mình; file sai loại / quá dung lượng bị từ chối; Marketplace hiển thị ảnh đại diện và bộ ảnh, có hình thay thế; Admin gỡ ảnh vi phạm có lý do + audit. |
| Điểm dừng | Nhà xe chỉ tạo văn phòng trung chuyển / trạm dừng nghỉ; bến xe / điểm dừng đón trả chỉ có qua Admin; cho đón / cho trả đúng loại điểm và vị trí; tìm chuyến khớp theo vị trí; Admin khóa điểm riêng có lý do + audit. |

---

## 9. Test case nháp trọng yếu

Mandatory (rủi ro cao, ADR-025): money math, idempotency, tenant RLS, seat-hold race, webhook HMAC; loyalty ledger + voucher thuộc nhóm money / idempotency.

| ID | Test case | Loại test | Ưu tiên |
| -- | --------- | --------- | ------- |
| TC-BOOK-001 | Giữ ghế thành công với Redis hold còn TTL | Integration | Cao |
| TC-BOOK-002 | Hai user giữ cùng ghế đồng thời, chỉ một thành công | Integration/Concurrency | Rất cao |
| TC-BOOK-003 | Redis hold hết TTL tự giải phóng ghế | Integration | Cao |
| TC-PAY-001 | VNPay/MoMo callback success cập nhật booking/payment/ticket/escrow/commission | Integration | Rất cao |
| TC-PAY-002 | Callback trùng (dedup provider+txn) không ghi trùng tiền/ticket | Integration | Rất cao |
| TC-PAY-003 | Webhook HMAC sai (SHA512/SHA256) bị từ chối | Security | Rất cao |
| TC-PAY-004 | Job đối soát: thanh toán quá hạn mà cổng báo đã trả → đơn còn chờ được xác nhận + vé, đơn đã hết hạn → "Cần đối soát"; cổng báo thất bại → payment thất bại; không có / lỗi → giữ nguyên, không tra lại trong 30 phút; refund đứng yên xếp hàng lại đúng `jobId`; chữ ký phản hồi `querydr` sai bị bỏ qua (chờ duyệt) | Integration | Cao |
| TC-MONEY-001 | Commission 5% + refund + payout tính BIGINT/Decimal không sai số | Unit | Rất cao |
| TC-REF-001 | Hủy vé trước hạn tạo refund đúng policy snapshot | E2E | Cao |
| TC-SEC-001 | Operator A không xem booking Operator B (RLS) | Security | Rất cao |
| TC-SEC-002 | Refresh token reuse bị family invalidation | Security | Cao |
| TC-SEC-003 | Bearer/default Mobile giữ nguyên JSON schema, không có `Set-Cookie`; cookie mode không lộ token thô | Contract/Security | Rất cao |
| TC-SEC-004 | Cookie access/refresh/CSRF đúng HttpOnly/Secure/SameSite/Path/TTL; logout/revoke current family xóa đúng attributes | Security | Rất cao |
| TC-SEC-005 | CSRF thiếu/sai/cũ và unsafe request có Origin ngoài allowlist/`null` bị từ chối; preflight hợp lệ không qua auth | Security | Rất cao |
| TC-SEC-006 | Bearer và access cookie đồng thời bị `AUTH_TRANSPORT_AMBIGUOUS`; transport lạ bị `AUTH_TRANSPORT_INVALID` | Security | Cao |
| TC-SEC-007 | `/auth/me` không trả secret/không tự refresh; access hết hạn → web refresh single-flight rồi retry | API/E2E Web | Cao |
| TC-SEC-008 | Playwright Operator: temp password → đổi → login lại → TOTP enrollment → backup code một lần → reload/protected route; Admin password → TOTP → protected route | E2E Web | Rất cao |
| TC-SEC-009 | Sai cổng Owner/Employee (DB thật): Employee đúng mật khẩu ở `/auth/operator/login` và Owner đúng mật khẩu ở `/auth/employee/login` → `401 AUTH_INVALID_CREDENTIALS`, không tạo `auth_sessions`, không trả MFA/password-change challenge; unit: mỗi cổng chỉ tra đúng bảng account | Security | Rất cao |
| TC-SEC-010 | `/auth/employee/login` trả token JSON, không `Set-Cookie`; `X-Auth-Transport: cookie` → `400 AUTH_TRANSPORT_INVALID`; `/auth/me` với token Employee đọc đúng Employee | API/Security | Cao |
| TC-SEC-011 | DB từ chối Employee thiếu `nv.`/có chữ hoa và Owner dùng `nv.` ở mọi kiểu hoa/thường; migration đổi tên Employee cũ (`Driver01` → `nv.driver01`) + đồng bộ registry, dừng khi có Owner `nv.`, tên quá 64 ký tự hoặc trùng sau khi đổi | Integration | Cao |
| TC-SEC-012 | Operator OS — Nhân viên và Tài khoản: thêm nhân viên thiếu ô báo tại ô; sai mật khẩu xác nhận lại danh tính báo tại ô và **không** làm mất phiên; trong 5 phút không hỏi lại; trùng tên đăng nhập báo tại ô; khóa / mở khóa / cấp lại mật khẩu bắt buộc lý do, cấp lại lần hai trong giờ bị chặn; gửi mật khẩu tạm lỗi thì tài khoản vẫn có trong danh sách kèm hướng dẫn; thu hồi một phiên ở trình duyệt khác thì trình duyệt đó về màn đăng nhập | E2E (Playwright) | Cao |
| TC-SEC-013 | Phân quyền theo tài khoản — `can()` (`TASK-IAM-007`): quyền tick được ⊆ grant của role; trần tài khoản quản lý ⊆ quyền Owner, không có hồ sơ / tài khoản nhận tiền / `manager:manage`; `access:manage` chỉ phía Platform, `manager:manage` chỉ Owner; tài khoản có danh sách chỉ có quyền tick được trong danh sách, quyền không tick được vẫn theo role; Platform chưa có danh sách (`NULL`) → đủ quyền tick được; `OPERATOR_MANAGER` thiếu danh sách → không có quyền tick được nào (fail-closed); danh sách rỗng ≠ `NULL`; mã quyền lạ bị bỏ, chỉ làm mất quyền (`permissions.spec.ts`) | Unit/Security | Rất cao |
| TC-SEC-014 | Claim `perms`: đăng nhập / MFA / làm mới phiên đọc danh sách từ DB; Owner và role không phân quyền không mang `perms`; token `OPERATOR_MANAGER` thiếu `perms` bị từ chối; `/auth/me.permissions` = quyền hiệu lực (`token.service.spec.ts`, `auth.service.spec.ts`) | Unit/Security | Cao |
| TC-SEC-015 | Admin phân quyền tài khoản quản trị (Postgres thật, role app): đổi quyền → `auth_epoch + 1`, thu hồi phiên trước + sau, audit trước / sau; quyền ngoài trần vai trò → 400 `PERMISSION_NOT_ASSIGNABLE`; thêm / bớt quyền người thao tác không có → 403 `PERMISSION_GRANT_FORBIDDEN`; người thao tác đã mất `access:manage` (đọc lại từ DB) → 403; tự sửa mình → 409 `PLATFORM_ACCOUNT_SELF_ACTION` (`admin-account.int.spec.ts`). **Chưa có test tự động:** gỡ / khóa người cuối cùng có `access:manage` → 409 `PLATFORM_ACCOUNT_LAST_ADMIN` | Integration/Security | Rất cao |
| TC-SEC-016 | Owner quản lý tài khoản quản lý (Postgres thật, role app + guard thật): tạo → `OPERATOR_MANAGER`, quyền lưu theo thứ tự danh mục, mật khẩu tạm qua email, trùng tên → 409; đổi quyền → epoch tăng + thu hồi phiên + audit, không đổi gì thì không đá phiên; khóa → `LOCKED`; đặt lại 2FA xóa TOTP + mật khẩu tạm mới; Owner nhà xe khác / dòng Owner → 404; tài khoản quản lý (kể cả đủ quyền tick) / nhân viên / Admin → 403, không token → 401, ghi thiếu xác nhận lại danh tính → 401; DB CHECK Owner ⇔ `permissions IS NULL` (`operator-manager.int.spec.ts`, `.http.spec.ts`). **Chưa có E2E** màn Tài khoản quản lý (Operator OS) và màn phân quyền (Admin) | Integration/Security | Rất cao |
| TC-TRN-001 | Hai request đồng thời gắn cùng xe vào hai chuyến chồng giờ → đúng một thành công, bên kia `409 VEHICLE_SCHEDULE_CONFLICT`; chuyến khởi hành đúng giờ đến chuyến trước được (BR-14, không đệm quay đầu); chuyến `CANCELLED` không giữ xe | Integration/Concurrency | Rất cao |
| TC-TRN-002 | Nhà xe B không đọc/sửa chuyến, điểm dừng, ghế của A (RLS, kể cả query quên lọc); `routeId`/`vehicleId` của B trong body → 422 như không tồn tại | Security | Rất cao |
| TC-TRN-003 | Sơ đồ ghế đang được chuyến chưa kết thúc dùng: `PUT` sơ đồ / đổi sơ đồ của xe → `409 SEAT_MAP_IN_USE`; ghế của chuyến là bản chụp, không đổi theo sơ đồ (UC-12 A3) | Integration | Cao |
| TC-TRN-004 | Mở bán chuyến thiếu điều kiện → 422 `TRIP_NOT_READY_FOR_SALE` kèm **mọi** lý do (chưa gắn xe, xe ngừng dùng, điểm dừng ngừng dùng, tuyến chưa có bảng giá, ghế thiếu giá / giá 0, quá giờ ngừng bán online); đủ điều kiện → `OPEN_FOR_SALE`; khóa ↔ mở lại (mở lại kiểm lại) (BR-39, FR-OPS-10) | Integration | Rất cao |
| TC-TRN-005 | Chuyển trạng thái sai bảng (vd `CANCELLED → OPEN_FOR_SALE`) → 409; hủy thiếu lý do → 400; hai request cùng mở bán đồng thời → đúng một thành công (request xếp hàng, bên sau chạy trên trạng thái mới); hủy trong lúc ghế đang được bán (chưa commit) → chờ rồi 409; hủy xong xe rảnh ngay | Integration | Cao |
| TC-TRN-006 | Khóa / mở ghế theo lô: được cả lô hoặc không; ghế đã bán / đang giữ → 409; mã ghế lạ → 422; đổi xe giữ ghế khóa theo mã, sơ đồ mới thiếu ghế đã khóa → 409 (BR-42, chống overbooking) | Integration | Rất cao |
| TC-TRN-007 | Đổi trạng thái chuyến: audit lỗi → 503, không đổi; khóa ghế khi audit lỗi vẫn thành công; nhà xe B không đổi trạng thái / khóa ghế chuyến của A (404) | Security | Cao |
| TC-TRN-008 | Bộ ảnh xe: gắn ảnh thứ 9 → 422 `VEHICLE_IMAGE_LIMIT_EXCEEDED`; object không tồn tại / sai content-type / quá 5 MB / file không phải ảnh đổi đuôi → 422 `VEHICLE_IMAGE_INVALID`, bộ ảnh cũ giữ nguyên; thứ tự gửi lên = thứ tự trả về, phần tử đầu là ảnh đại diện; chú thích trả về đúng theo từng ảnh, dài hơn 60 ký tự → 400 (BR-76) | Integration | Cao |
| TC-TRN-009 | Nhà xe B không xin được URL upload và không đổi được bộ ảnh xe của A (404); `objectKey` của xe / nhà xe khác trong body → 422; RLS chặn đọc / ghi `vehicle_images` của A kể cả query quên lọc | Security | Rất cao |
| TC-TRN-010 | Hai `PUT` bộ ảnh đồng thời trên một xe không trộn hai danh sách; lỗi giữa chừng giữ bộ ảnh cũ; ảnh bị bỏ được xóa object sau commit | Integration/Concurrency | Trung bình |
| TC-TRN-011 | Search trả `vehicleCoverImageUrl`, chi tiết chuyến trả `vehicleImages` đúng thứ tự; xe chưa có ảnh → `null` / mảng rỗng và giao diện hiện hình thay thế; Admin gỡ ảnh → ảnh biến mất khỏi API công khai, có `audit_event` kèm lý do; thiếu lý do → 400 | Integration/E2E | Cao |
| TC-TRN-012 | Catalog loại xe trả `form` + `class`; tìm chuyến lọc dạng chỗ và hạng xe độc lập — xe `SLEEPER_LIMOUSINE` khớp cả lọc `SLEEPER` lẫn lọc `LIMOUSINE`, không khớp lọc `SEATER` (BR-77) | Integration | Cao |
| TC-TRN-013 | SeatMap nhận đủ 5 loại chỗ, loại lạ → 400; `passengerCapacity` = số chỗ + số chỗ đôi; bảng giá đặt giá riêng cho `BED_DOUBLE` / `CABIN_DOUBLE` và ghế của chuyến lấy đúng giá theo loại chỗ (BR-78, money) | Integration | Cao |
| TC-TRN-014 | SeatMap trả `deckCount` đúng số tầng; `inUse` / `seatMapLocked` = `true` khi còn chuyến chưa kết thúc dùng sơ đồ / xe, về `false` khi chuyến `COMPLETED` / `CANCELLED` hoặc đã qua giờ đến; cờ đang `false` mà trạng thái vừa đổi thì thao tác ghi vẫn trả 409 `SEAT_MAP_IN_USE`; nhà xe B không đọc được cờ của A | Integration | Cao |
| TC-TRN-015 | Điểm riêng loại `BUS_STATION` / `PICKUP_POINT` → 422 `STOP_POINT_TYPE_NOT_ALLOWED` và bị CHECK DB chặn; đề xuất loại `OFFICE` / `REST_STOP` hoặc thiếu `legalBasis` → 400; nhà xe không tự chuyển đề xuất sang `APPROVED` kể cả ghi thẳng DB bằng role app (BR-38) | Integration/Security | Rất cao |
| TC-TRN-016 | Route: điểm đầu chỉ đón, điểm cuối chỉ trả; trạm dừng nghỉ bật đón / trả hoặc đứng đầu / cuối → 422 `ROUTE_STOP_PICKUP_DROPOFF_INVALID`; chuyến chép đúng hai cờ; đặt vé với điểm đón không cho đón, điểm trả không cho trả hoặc trả trước đón → 422 (BR-23, BR-79) | Integration | Cao |
| TC-TRN-017 | Admin duyệt đề xuất → đúng một điểm dùng chung, mọi nhà xe gắn được vào route; hai Admin duyệt đồng thời → một thành công, một 409; từ chối thiếu lý do → 400; nhà xe không thấy đề xuất của nhà xe khác | Integration/Concurrency | Cao |
| TC-TRN-018 | Admin khóa điểm riêng: thiếu lý do → 400; có `audit_event`; nhà xe sửa hoặc tự mở lại → 409 `STOP_POINT_SUSPENDED`, kể cả ghi thẳng DB bằng role app; điểm bị khóa không gắn mới vào route; chuyến dùng điểm đó không mở bán được, chuyến đã có vé giữ nguyên (BR-81) | Integration/Security | Cao |
| TC-TRN-019 | Tìm chuyến: theo tỉnh → đúng chuyến có điểm cho đón ở tỉnh đi và sau đó điểm cho trả ở tỉnh đến; theo địa danh → khớp cả văn phòng riêng trong bán kính, không khớp điểm ngoài bán kính; trạm dừng nghỉ và điểm không cho đón / trả không khớp; chiều ngược lại không khớp (BR-80) | Integration | Cao |
| TC-TRN-020 | Tạo / sửa chuyến chép `allow_pickup` / `allow_dropoff` và loại điểm từ tuyến vào `trip_stops` (BR-79); ghi thẳng DB điểm đầu cho trả hoặc điểm cuối cho đón → CHECK `trip_stops_pickup_dropoff_by_role` từ chối | Integration | Cao |
| TC-TRN-021 | Operator OS — màn Chuyến xe: tạo chuyến nháp (thiếu ô báo tại ô, giờ đến tính theo tuyến — không có ô nhập, giờ từng điểm tự chia), xe trùng giờ báo tại ô Xe và khởi hành đúng giờ đến chuyến trước thì lưu được, sửa chuyến với giờ tự nhập (vượt giờ đến bị chặn), lọc danh sách, sơ đồ ghế của xe đang có chuyến hiện "Đang dùng cho chuyến" | E2E (Playwright) | Cao |
| TC-TRN-022 | Operator OS — vòng đời bán và khóa chỗ: mở bán khi tuyến chưa có bảng giá đang áp dụng bị chặn, khối Điều kiện mở bán nêu mục chưa đạt và chuyến vẫn Nháp; bật bảng giá thì mở bán được; chọn chỗ còn trống để khóa kèm ghi chú, chọn chỗ đã khóa để mở khóa (đang chọn một loại thì loại kia không bấm được); tạm dừng bán, mở bán lại, thu hồi về nháp giữ chỗ đã khóa; hủy chuyến thiếu lý do bị chặn, hủy xong không còn nút thao tác và không khóa chỗ được nữa | E2E (Playwright) | Cao |
| TC-TRN-023 | Operator OS — ảnh xe: tệp sai định dạng / không đọc được báo tại chỗ, tệp hợp lệ chọn cùng lúc vẫn nhận; chú thích, đổi chỗ bằng phím (ảnh đưa lên đầu thành ảnh đại diện), lưu cùng nút "Lưu phương tiện", tải lại trang thấy đúng thứ tự + chú thích, ảnh hiển thị được; xóa ảnh; danh sách xe hiện ảnh đại diện + số ảnh. Tạo xe kèm hai ảnh, một ảnh tải lỗi → xe vẫn được tạo, ảnh còn lại được lưu, ô lỗi "Thử lại" lưu được (Figma 08) | E2E (Playwright) | Cao |
| TC-TRN-024 | Admin — màn Điểm dừng: duyệt đề xuất có chỉnh tên → điểm mới có trong tab Dùng chung kèm căn cứ; từ chối thiếu lý do báo tại ô, có lý do → Bị từ chối; thêm bến xe thiếu căn cứ báo tại ô, thêm trạm dừng nghỉ, ngừng dùng; khóa điểm riêng thiếu lý do báo tại ô, khóa → Bị khóa kèm lý do, mở khóa → Hoạt động | E2E (Playwright) | Cao |
| TC-TRN-025 | Operator OS — Lịch xe: công tắc Danh sách / Lịch xe; mỗi xe một hàng, chuyến qua đêm hiện đúng ngày, chuyến hủy không giữ xe, hàng "Chưa gắn xe", "Rảnh từ (dự kiến)" + nơi xe dừng, chấm nối sát giờ; bấm khoảng trống → form chuyến điền sẵn xe + giờ; ô Xe chia Rảnh / Trùng giờ (xe trùng không chọn được, có lý do), thẻ Lịch xe trong ngày (`vehicle-schedule.test.ts`, `trips.e2e.ts`) | Unit/E2E (Playwright) | Trung bình |
| TC-TRN-026 | Lịch chuyến lặp lại: sinh đúng ngày theo thứ + giờ VN (chuyến 22:30 thuộc đúng ngày), chép điểm dừng + ghế; **chạy lại / hai lần đồng thời không sinh trùng** (UNIQUE `(schedule_id, service_date)`); xe trùng giờ → bỏ đúng ngày đó, ngày đã qua bỏ qua; sửa lịch không đổi chuyến cũ; mở bán ngay qua luồng BR-39 (thiếu xe / giá → nháp + lý do); tenant khác 404 (`trip-schedule.int.spec.ts`, `.http.spec.ts`, `trips.e2e.ts`) | Integration/Concurrency/E2E | Cao |
| TC-TRN-027 | Giờ đến theo tuyến (chờ duyệt 27/10/2026): body chuyến / đổi chuyến / lịch không nhận giờ đến hay thời gian chạy; giờ đến = giờ đi + tổng chặng (làm tròn phút, ≥ 1 phút), đổi giờ đi thì dời theo; nhà xe chỉnh thời gian chặng 1–1440 phút, để trống quay về số hệ thống không gọi lại Goong, tổng > 7 ngày → 422 `ROUTE_DURATION_INVALID`; `stopTimes` điểm cuối lệch giờ đến theo tuyến → 422 | Unit + Integration (Vitest) | Cao |
| TC-TRN-028 | Tìm theo phường / xã + gợi ý địa điểm (chờ duyệt 27/10/2026): phường đi / đến khớp đúng chuyến; phường không có chuyến → kết quả cả tỉnh + `widenedToProvince`; nới vẫn rỗng → rỗng, không bật cờ; phường không tồn tại → rỗng; gửi hai loại điểm cho một phía → 400; `/catalog/places`: phường mới (kèm tỉnh), địa danh (không có trạm nghỉ), tên cũ cấp xã → phường mới, cấp huyện → tỉnh, tên cũ trùng tên mới bị bỏ, gõ không dấu khớp, gõ có dấu xếp đúng tên trước, `q` < 2 ký tự / `limit` > 20 → 400 (`trip-search.int.spec.ts`, `public-trip.http.spec.ts`, `catalog.http.spec.ts`; web `trip-mappers.test.ts`) | Integration/E2E thủ công | Cao |
| TC-FARE-001 | Giá ghế = rule cụ thể nhất (khung giờ > không; đúng loại xe > mọi loại; đúng loại chỗ > mọi loại); biên `[validFrom, validTo)` đúng giờ khởi hành; đổi xe thường → xe VIP thì giá đổi theo; tiền `BIGINT` không qua số thực | Unit/Integration (money) | Rất cao |
| TC-FARE-002 | Mỗi lần tạo/sửa bảng giá có đúng một bản ghi lịch sử (Mongo `audit_event`) chứa before/after; Mongo lỗi → không đổi giá | Integration | Cao |
| TC-FARE-003 | Nhà xe B không đọc/sửa bảng giá, rule, lịch sử giá của A; `routeId` của B → 422 | Security | Rất cao |
| TC-FARE-004 | Hai rule cùng loại xe × cùng loại chỗ (đủ 5 loại, BR-78) không cùng là giá thường và không chồng khung giờ — DB chặn kể cả ghi thẳng; rule của hai loại chỗ khác nhau không đụng nhau. Danh sách bảng giá trả đúng `minPrice` / `maxPrice` (`null` khi chưa có rule) và `hasDoubleSeatPrice` | Integration | Cao |
| TC-FARE-005 | Operator OS — màn Bảng giá: tạo bảng giá cho tuyến chưa có giá (thiếu giá, quy tắc trùng, khung giờ ngược chiều báo tại khối nhập), danh sách hiện khoảng giá; giá hiện trên từng chỗ của chuyến theo quy tắc cụ thể nhất; sửa giá ghi vào lịch sử (giá cũ → giá mới); ngừng áp dụng thì chỗ của chuyến ghi "Chưa có giá" | E2E (Playwright) | Cao |
| TC-FARE-006 | Bảng giá có quy tắc ngoài khung giá đang hiệu lực / sắp tới → `bandWarnings` đúng khung + quy tắc (quy tắc có khung giờ chỉ xét khi giao thời gian), vẫn lưu được và ghi audit `fare.band_warning`; Operator OS hiện dải cảnh báo + đánh dấu dòng (`fare.int.spec.ts`, `fare-format.test.ts`) | Integration/Unit (money) | Cao |
| TC-EMP-001 | Employee check-in ticket hợp lệ được phân công (Maestro) | E2E | Cao |
| TC-EMP-002 | Employee không check-in chuyến ngoài assignment | Security | Cao |
| TC-EMP-003 | Owner phân công tài xế: nhân viên khóa / không phải tài xế / khác tenant → 422; **một tài xế không chạy hai chuyến chồng giờ kể cả hai lần phân công đồng thời** (409); chuyến hủy / hoàn thành → 409; chuyến < 2 giờ / đang chạy cần lý do; audit lỗi → 503; DB chặn hai tài xế một chuyến + nhân viên tenant khác (`employee-assignment.int.spec.ts`, `.http.spec.ts`, `assignments.e2e.ts`) | Integration/Concurrency/E2E | Cao |
| TC-EMP-004 | Soát vé QR / mã vé đúng chuyến được phân công; vé chuyến khác → `WRONG_TRIP` không lộ thông tin khách; **hai máy quét cùng vé đồng thời → đúng một check-in**; vắng mặt trước khi bắt đầu đón → 409 (chờ duyệt) | Integration/Security | Cao |
| TC-EMP-005 | Tài xế đổi trạng thái theo thứ tự (nhân viên vé → 403); hoàn thành → vé đã lên `USED`, chưa lên `NO_SHOW`, `payout_eligible_at` theo giờ hoàn thành, màn Tài chính thấy tiền đủ điều kiện (chờ duyệt) | Integration | Cao |
| TC-ADM-001 | Admin refund/payout thủ công yêu cầu re-auth/TOTP + audit | E2E/Security | Cao |
| TC-ADM-002 | Admin — màn Danh mục chuẩn: thêm loại xe (mã sai / trùng mã báo tại ô Mã), đổi tên, ngừng dùng thiếu lý do báo tại ô, có lý do → Ngừng dùng và hộp thoại hiện mức ảnh hưởng (số xe / nhà xe / quy tắc giá), dùng lại; thêm tiện ích, phường / xã rồi ngừng dùng; mục ngừng dùng không còn trong API công khai `/catalog/*` | E2E/Integration | Trung bình |
| TC-ADM-003 | Admin gỡ ảnh phương tiện vi phạm: thiếu lý do báo tại ô; có lý do → ảnh và object bị xóa, ảnh kế tiếp thành ảnh đại diện, audit ghi trong transaction (audit lỗi → 503, ảnh còn nguyên), chủ nhà xe nhận email; nhà xe gửi lại ảnh đã gỡ → 422; chủ nhà xe / hỗ trợ nền tảng gọi route → 403 | E2E/Integration/Security | Cao |
| TC-ADM-004 | Admin tra cứu nhật ký audit: lọc thời gian / loại người thực hiện / phân hệ / kết quả, tìm theo tài khoản hoặc mã đối tượng ra đúng bản ghi; chi tiết che email / số tài khoản / bí mật / IP, có chuỗi bản ghi cùng đối tượng; lượt xem chi tiết được ghi audit; chủ nhà xe / hỗ trợ nền tảng → 403 | E2E/Integration/Security | Cao |
| TC-ADM-005 | Admin quản lý tài khoản: tạm khóa nhà xe thiếu lý do → 400, có lý do + TOTP → Tạm khóa (CHECK lý do ↔ trạng thái), mở khóa; khóa hành khách → không đăng nhập / làm mới phiên được, mở khóa; cấp tài khoản quản trị → mật khẩu tạm buộc đổi, khóa / mở, không tự khóa mình; nhân viên nhà xe chỉ xem; chủ nhà xe / hỗ trợ nền tảng → 403, thiếu xác nhận lại → 401 `AUTH_REAUTH_REQUIRED` (`admin-operator.int.spec.ts`, `admin-account.int.spec.ts`, `.http.spec.ts`, `users.e2e.ts`) | E2E/Integration/Security | Cao |
| TC-ADM-006 | Admin chính sách: nháp sửa tự do, kích hoạt hiệu lực quá khứ → 422, phạm vi đã có bản chờ → 409, hủy lịch rồi kích hoạt lại; bản đã có hiệu lực không sửa / hủy; trạng thái Đang áp dụng / Hết hiệu lực / Đã lên lịch suy đúng; hoa hồng riêng chồng thời gian → 409, đã bắt đầu chỉ đổi ngày kết thúc; khung giá sàn > trần → 400; tenant không ghi được (RLS); audit lỗi → 503 không đổi gì (`admin-policy.int.spec.ts`, `admin-commission.int.spec.ts`, `admin-policy.http.spec.ts`, `policies.e2e.ts`) | E2E/Integration/Security (money) | Cao |
| TC-ADM-007 | Admin Tích hợp & hệ thống (chỉ đọc): hạ tầng lỗi → "Lỗi", dịch vụ có khóa → "Đã cấu hình" và không trả khóa, chưa tích hợp / SMS tắt đúng nhãn; tác vụ nền hiện lịch, lần chạy kế (trễ lịch), lần chạy gần nhất + lỗi; Redis lỗi → không đọc được hàng đợi; chủ nhà xe / hỗ trợ nền tảng → 403. Khung màn chờ đặt vé hiện tiêu đề cột + "Chưa có dữ liệu", **không số liệu mẫu**; Tổng quan đếm đúng việc cần xử lý (`system-status.service.spec.ts`, `.http.spec.ts`, `policies.e2e.ts`, `auth.e2e.ts`, `profile.e2e.ts`) | Unit/E2E/Security | Trung bình |
| TC-ADM-008 | Admin nội dung công khai: ràng buộc theo loại (vị trí, đường dẫn trang tĩnh, ảnh banner, liên kết chỉ `/…` / `https://`), tạo nháp + sửa audit trong transaction, trùng đường dẫn 409, đổi loại 422, hiển thị / ẩn (lặp 409), API công khai chỉ trả mục đang hiển thị, audit lỗi → 503, tenant không ghi (RLS); chủ nhà xe / hỗ trợ nền tảng → 403 (`content-page.int.spec.ts`, `.http.spec.ts`, `moderation-audit.e2e.ts`) | E2E/Integration/Security | Trung bình |
| TC-ADM-009 | Admin giám sát (chờ duyệt 28/10/2026, `TASK-ADM-005`): chi tiết nhà xe (TK nhận tiền che số, thẻ 30 ngày chỉ tính chuyến đã khởi hành, đội xe), tuyến mọi nhà xe (tỉnh đầu / cuối, số liệu kỳ, lọc tỉnh, xếp), chi tiết tuyến (điểm dừng, chuyến sắp chạy), chuyến + danh sách người đi (khách vãng lai / tài khoản, SĐT che), chi tiết tài khoản hành khách + đơn kèm người đi; tiền `null` khi thiếu `payment:monitor`; lượt xem chi tiết hành khách / danh sách người đi ghi audit, audit lỗi → 503; báo cáo theo tuyến / khu vực + CSV theo khu vực; tìm giao dịch theo SĐT người đặt (`admin-monitoring.int.spec.ts`, `monitoring.e2e.ts`) | E2E/Integration/Security | Trung bình |
| TC-RPT-001 | Báo cáo nhà xe theo kỳ khởi hành (tổng / theo tuyến / nhân viên), tenant khác không thấy; CSV có BOM, chặn công thức, audit trước khi trả — audit lỗi → 503 (chờ duyệt) | Integration/Security | Cao |
| TC-RPT-002 | Báo cáo + Tổng quan Admin: GMV theo giờ trả, doanh thu sau hoàn (tạm tính khi còn cần đối soát), lọc nhà xe / cổng; chủ nhà xe gọi route Admin → 403 (chờ duyệt) | Integration/E2E | Trung bình |
| TC-DSP-001 | Khiếu nại: khách vãng lai cần `X-Booking-Token`; nhà xe chỉ thấy sau khi Vé Xe Nhanh chuyển; khóa tệp của bên khác bị từ chối; xem tệp có audit (chờ duyệt) | Integration/Security | Cao |
| TC-DSP-002 | Tranh chấp: mở lần hai 409; mỗi bên chỉ thấy minh chứng của mình; quá hạn → `ESCALATED`; hoàn vượt phần đã trả 422; hoàn xong trừ sổ giữ hộ + đơn về đã xác nhận; quyết định lần hai 409; quyết định cần TOTP + chỉ PlatformAdmin (chờ duyệt) | Integration/Security | Rất cao |
| TC-DSP-003 | Đánh giá: chỉ hành khách, chuyến hoàn thành + có vé đã đi, một lần / đơn; ẩn có lý do → không tính điểm trung bình (BR-55) (chờ duyệt) | Integration | Cao |
| TC-PROM-001 | Khuyến mãi nền tảng: nhà xe chưa tham gia → không áp; **hai đơn đồng thời còn một lượt → đúng một đơn được giảm**; đơn hết hạn trả lượt; thanh toán → đã dùng (chờ duyệt) | Integration | Rất cao |
| TC-PROM-002 | Tiền khi có giảm: sổ giữ hộ nhận số khách thực trả, hoa hồng trên tiền vé sau giảm; hủy vé hoàn trên phần đã trả của từng vé, tổng không vượt số đã trả (chờ duyệt) | Integration | Rất cao |
| TC-PROM-003 | Khuyến mãi nhà xe vượt giới hạn được cấp → 422 `PROMOTION_GUARDRAIL`; nhà xe khác không thấy / sửa (RLS); không sửa điều kiện khi đã có đơn dùng (BR-47) (chờ duyệt) | Integration/Security | Cao |
| TC-LOY-001 | Trip `COMPLETED` cộng `EARN` đúng công thức BR-66 (Decimal, làm tròn xuống); event trùng không cộng lần hai; booking Guest không cộng Hiện thực (chờ duyệt): `loyalty.int.spec.ts` — tích một lần, hai lần chạy song song → một giao dịch, vé vắng mặt + khách vãng lai không tính, hệ số hạng Bạc ×1,2. | Integration | Rất cao |
| TC-LOY-002 | Hai request đổi điểm song song vượt số dư → chỉ một thành công; cùng `Idempotency-Key` → cùng voucher; số dư không âm | Integration/Concurrency | Rất cao |
| TC-LOY-003 | Booking dùng voucher đổi điểm: escrow Operator + commission tính trên giá trước giảm; entry `PLATFORM_FUNDED_DISCOUNT` khớp; hoàn vé đảo phần Platform chịu theo tỷ lệ | Integration (money) | Rất cao |
| TC-LOY-004 | Voucher `RESERVED → USED` khi payment `SUCCESS`; booking `EXPIRED` / fail → `AVAILABLE`; không giữ được cho booking thứ hai; voucher của User khác bị từ chối | Integration/Security | Rất cao |
| TC-LOY-005 | Job hết hạn điểm theo FIFO; chạy hai lần cùng ngày không trừ thêm Hiện thực (chờ duyệt): job hết hạn chạy lại không trừ thêm. | Integration | Cao |
| TC-LOY-006 | Hoàn ticket đã tích điểm → `REVERSAL`, số dư không âm Hiện thực (chờ duyệt): thu hồi theo tỷ lệ tiền hoàn, thiếu số dư ghi phần thiếu. | Integration | Cao |
| TC-LOY-007 | Scope `tenant` không đọc / ghi được `loyalty_accounts`, `loyalty_point_transactions`, `user_vouchers` (RLS) Hiện thực (chờ duyệt): scope tenant không đọc / ghi sổ điểm; sổ điểm không sửa / xóa; `user_vouchers` chưa có. | Security | Cao |
| TC-CNT-001 | Bài `DRAFT` / `ARCHIVED` không trả qua API công khai; nội dung chứa `<script>` bị loại khi render | Security/E2E | Cao |
| TC-CNT-002 | Admin bài viết: chuyên mục trùng slug / ngừng dùng; vòng đời nháp → xuất bản → hẹn giờ (chưa tới giờ không ra API công khai) → gỡ → xuất bản lại, sai trạng thái 409, rỗng 422, xuất bản đồng thời một thành công; ảnh bìa khóa lạ / chưa tải → 422; lượt xem giới hạn theo IP; tenant không ghi được (RLS); audit lỗi → 503 (`article.int.spec.ts`, `article.http.spec.ts`, `articles.e2e.ts`) | E2E/Integration/Security | Cao |
| TC-OPR-001 | Link hồ sơ nhà xe: token sai / hết hạn / đã thu hồi → `OPERATOR_APPLICATION_LINK_INVALID`; token hồ sơ A không đọc được hồ sơ B; sửa hồ sơ `SUBMITTED` bị chặn; link hết hiệu lực sau `APPROVED` / `REJECTED` | Security | Rất cao |
| TC-OPR-002 | Duyệt hồ sơ gửi lặp (cùng `Idempotency-Key` và khác key) chỉ tạo một Operator + một Owner; slug trùng → `OPERATOR_SLUG_CONFLICT`, không tạo gì; giấy tờ và tài khoản nhận tiền sang đúng tenant (RLS) | Integration | Rất cao |
| TC-OPR-003 | `POST /operator-applications` và gửi lại link trả cùng `202` cho email có / chưa có hồ sơ; vượt rate limit bị chặn | Security | Cao |
| TC-OPR-004 | Operator OS — đăng ký nhà xe công khai: màn đăng nhập có lối "Đăng ký"; form bước 1 báo lỗi tại ô, gửi xong chỉ nhắc kiểm tra hộp thư; mở link → token rời thanh địa chỉ, thiếu giấy tờ thì khóa Gửi duyệt, tệp sai loại báo tại chỗ, lưu nháp kèm ba giấy tờ, số tài khoản chỉ hiện 4 số cuối, xem giấy tờ mở URL có hạn; gửi duyệt → trang Chờ duyệt; link sai → trang gửi lại link; gửi lại link thu hồi link cũ | Security | Cao |
| TC-OPR-005 | Admin — duyệt hồ sơ nhà xe: hàng đợi hiện hồ sơ vừa gửi duyệt kèm cảnh báo trùng mã số thuế / tài khoản nhận tiền, lọc trạng thái rỗng thì "Bỏ lọc"; chi tiết che số tài khoản, nêu hồ sơ trùng, có lịch sử, "Mở tệp" mở URL có hạn ở tab mới; yêu cầu bổ sung không hỏi TOTP → Cần bổ sung, người nộp gửi lại → từ chối kèm TOTP → Bị từ chối kèm lý do; duyệt: tên đăng nhập `nv.` và slug đã dùng báo tại ô, duyệt xong hiện tài khoản `slug/username` + mật khẩu tạm chờ gửi lại | E2E (Playwright) | Cao |
| TC-OPR-006 | Operator OS hồ sơ & KYC: chủ nhà xe sửa thông tin công khai (audit chỉ trường đổi; tenant không đổi được tên pháp lý / trạng thái kể cả ghi thẳng DB; nhà xe khác không sửa được); thay giấy tờ (khóa nhà xe khác / sai loại / chưa tải → 422, bản cũ tự tải lên bị xóa), xem giấy tờ có audit; đổi tài khoản nhận tiền cần xác nhận lại, trùng → 422, đang chờ → 409, tenant không tự xác minh; Admin xem số đầy đủ (audit) → từ chối kèm lý do / xác minh (bản cũ `REPLACED`), email kết quả; nhân viên / Admin gọi route nhà xe → 403 (`operator-profile.int.spec.ts`, `.http.spec.ts`, `profile.e2e.ts`, `users.e2e.ts`) | E2E/Integration/Security (money) | Rất cao |
| TC-OPR-007 | Logo nhà xe (FR-OPR-02, Postgres thật, role app + kho local thật): gắn logo → `logoUrl` ở hồ sơ + `public-profile`, audit `operator.logo.update` (trước / sau); gửi lại đúng logo → không đổi gì, không audit; thay → object cũ bị xóa; gỡ → `null`, object bị xóa, gỡ lần nữa không audit; khóa của nhà xe khác / ảnh xe, object chưa tải lên, không phải ảnh, khai sai loại, quá 2 MB → 422 `OPERATOR_LOGO_INVALID`, hồ sơ giữ nguyên; tenant khác không gắn được logo của nhà xe này kể cả ghi thẳng DB (RLS); hai lần đổi đồng thời → còn đúng một object, khớp hồ sơ; audit lỗi → 503 không đổi gì; route logo: không token 401, nhân viên / Admin 403, SVG / GIF / > 2 MB → 400 (`operator-profile.int.spec.ts`, `.http.spec.ts`, `operator-logo-format.spec.ts`); `featured-operators` ghép `logoUrl`, không lộ khóa object (`catalog.service.spec.ts`) | Integration/Security (tenant-RLS) | Rất cao |
| TC-OPR-008 | E2E màn Hồ sơ & KYC — logo + trang công khai (TASK-MKT-001): tệp không phải ảnh báo lỗi; tải PNG → logo hiện (ảnh tải được), nút "Đổi logo"; "Mở trang nhà xe" là link tab mới tới `/operators/{id}`; "Xem trước trên ứng dụng" mở khung điện thoại có logo, hotline, chỉ số chất lượng, "Chưa có đánh giá."; gỡ logo có hộp xác nhận → về chữ viết tắt (`profile.e2e.ts`) | E2E (Playwright) | Cao |

---

### COUNTER-SALES — Tiêu chí hồi quy bổ sung (27/10/2026)

- Cổng quầy nhận Owner/SALES_STAFF, giữ MFA/đổi mật khẩu tạm; role khác không có phiên/challenge, cookie thiếu CSRF/sai Origin bị chặn. Chủ nhà xe tạo/khóa/cấp lại mật khẩu nhân viên bán vé được; nhân viên không tự quản lý tài khoản.
- Hai office và online cùng giữ/mua một ghế chỉ có một kết quả hợp lệ. Guest không dùng được hold quầy. Nhân viên không đọc/bán/thu văn phòng chưa được cấp hoặc tenant khác; chứng minh bằng role PostgreSQL không BYPASSRLS.
- Giờ lịch đã qua nhưng chưa depart vẫn bán; sau xác nhận thực tế giữ mới và chốt vé bị chặn. Giao dịch bán/khởi hành cùng khóa trip; retry không đổi mốc khởi hành.
- Gửi lặp xác nhận thu/in lại không tăng receipt/vé/phí; khóa dùng payload khác hoặc bank reference đã dùng bị409. Thiếu/thừa/đến muộn được ghi EXCEPTION, không phát vé và không mất dấu tiền đã nhận.
- Counter mặc định0%, không dùng rule ONLINE; configuredcounter thấp hơn online trên mọi khoảng hiệu lực, kể cả sửa/hủy ruleonline tương lai. Snapshot không tính lại; bigint làm tròn xuống đồng.
- Thu trực tiếp không tăng escrow/payout. Thu phí thủ công có unique reference/key, không vượt khoản phải thu; retry không thu thêm. Online payment/webhook/refund và mandatory HMAC/refresh reuse không hồi quy.

Kết quả thực chạy ghi tại [COUNTER-SALES todo](../task-propreties/COUNTER-SALES-todo.md); checklist này không mặc nhiên chứng minh test đã chạy hay được review.

## 10. Entry / Exit criteria

### 10.1. Entry criteria

| Điều kiện | Trạng thái |
| --------- | --------- |
| SRS liên quan đã Review/Approved | TBD |
| HLD/LLD/API/DB/Security liên quan đã Review/Approved | TBD (rework v0.x chờ Khanh promote) |
| Test environment có seed data + Testcontainers | TBD |
| Provider sandbox (VNPay/MoMo/Resend/FCM) sẵn sàng | TBD |

### 10.2. Exit criteria

| Điều kiện | Quy định |
| --------- | -------- |
| Test case critical pass | 100% critical (money/idempotency/tenant/seat) pass hoặc chấp nhận rủi ro có ghi |
| High bug | Không còn high severity chưa xử lý |
| Security blocker | Không còn lỗi IDOR/RBAC/RLS/payment/seat critical |
| Test evidence | Có log/screenshot/Playwright trace/report cho UAT và regression |

---

## 11. Open Questions / TBD

| ID | Câu hỏi | Tác động | Trạng thái |
| -- | ------- | -------- | ---------- |
| TEST-OQ-01 | Ưu tiên automation backend hay E2E trước? | Kế hoạch QA | Refined per ADR-025: **BE unit/integration (Vitest) trước** (ROI cao, nhanh); E2E critical path sau |
| TEST-OQ-02 | Provider sandbox nào cho payment/notification? | Integration test | **Đóng theo ADR-019/020**: VNPay + MoMo sandbox; Resend; FCM + APNs |
| TEST-OQ-03 | Performance baseline cụ thể cho seat hold/payment? | Load test | Mở; cần target số liệu (k6/Artillery chốt LLD) |
| TEST-OQ-04 | UAT data set do ai chuẩn bị? | UAT | Mở (solo: Khanh + AI seed) |

---

### Quy ước mã trong Test Plan

- `TC-...`: Test case.
- `TEST-OQ-NN`: Câu hỏi mở của Test Plan.
