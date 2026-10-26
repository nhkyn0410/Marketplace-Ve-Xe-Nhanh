# 05. API Specification - Hệ thống đặt vé xe khách

## 1. Thông tin tài liệu

### 1.1. Metadata

| Thuộc tính    | Giá trị                     |
| ------------- | --------------------------- |
| Tên tài liệu  | API Specification           |
| Mã tài liệu   | 05-api-specification        |
| Dự án         | Marketplace-Ve-Xe-Nhanh     |
| Trạng thái    | Review                      |
| Người viết    | Nguyễn Hồng Khanh, AI Agent |
| Người duyệt   | Nguyễn Hồng Khanh           |
| Ngày tạo      | 11/05/2026                  |
| Ngày cập nhật | 17/10/2026                  |

### 1.2. Lịch sử thay đổi

| Phiên bản | Ngày       | Người cập nhật | Nội dung thay đổi                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| --------- | ---------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| v0.1      | 11/05/2026 | AI Agent       | Tạo bản nháp API Specification                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| v0.2      | 01/06/2026 | AI Agent       | **Sprint 5 Rework** — reset theo **ADR-012** (REST + OpenAPI 3.1 auto từ Zod single source, URL `/v1/*`, RFC 7807 error, webhook HMAC), **ADR-017** (auth 3-namespace + Hybrid token + MFA), **ADR-019** (webhook VNPay/MoMo HMAC dedup), **ADR-020** (OAuth + notification). §4 quy ước OpenAPI/Zod/versioning; §5 auth 3-namespace; §6 error → RFC 7807; §7 endpoint cập nhật (auth OTP/OAuth/MFA, admin complex-action POST sub-resource); §10 webhook HMAC + realtime transport TBD. Đóng API-OQ-01 (cookie+Bearer per ADR-017), API-OQ-02 (guest checkout per SRS), API-OQ-03 (VNPay+MoMo per ADR-019). |
| v0.3      | 19/09/2026 | AI Agent       | **§7.1 làm rõ khi hiện thực TASK-IAM-004 (MFA)**: `/auth/operator/login` + `/auth/platform/login` với role bắt buộc TOTP (Owner/PlatformAdmin/PlatformSupport) trả **challenge** (`mfaRequired: true`, `challengeToken`, `challengeExpiresIn: 300`, `otpAuthUri` chỉ ở lần enrollment đầu) thay vì token; `/auth/mfa/verify` được xác thực bằng `challengeToken` (không phải Bearer) và là endpoint duy nhất cấp token cho các role đó; `/auth/re-auth` nhận đúng một trong `password` / `otp` / `mfaCode`. Không thêm endpoint. Hợp đồng chi tiết = OpenAPI sinh từ Zod (ADR-012). |
| v0.4      | 22/09/2026 | AI Agent       | **TASK-IAM-005 Q1–Q8 do Khanh duyệt:** §7.1 bổ sung first-login password-change challenge và session family list/revoke; §7.3 chốt Employee CRUD/lifecycle tối thiểu. Provision Operator+Owner là service primitive cho OPR-001, chưa có HTTP KYC giả. OpenAPI sinh từ Zod là contract chi tiết. Giữ trạng thái Approved, không tự promote. |
| v0.5      | 23/09/2026 | AI Agent       | Hardening IAM-005: cờ chờ giao mật khẩu riêng trạng thái khóa, challenge vô hiệu theo `authEpoch`, quota/cooldown email mật khẩu tạm (429), recovery khi gửi mail lỗi. Giữ quyết định Q8 re-auth bằng mật khẩu hoặc MFA theo Khanh; không đổi trạng thái Approved. |
| v0.6      | 25/09/2026 | AI Agent       | **Đóng TASK-OQ-05 / mở khóa TASK-IAM-006:** chốt dual transport bằng `X-Auth-Transport`; cookie `vxn_access`/`vxn_refresh`; signed double-submit CSRF `vxn_csrf`; CORS credentialed allowlist; thêm `GET /auth/csrf` + `GET /auth/me`. Giữ nguyên JSON/Bearer mặc định cho Mobile; không thay đổi trạng thái Approved. |
| v0.7      | 25/09/2026 | AI Agent       | **TASK-CAT-001 Q1 do Khanh duyệt:** thêm §7.6 — 5 endpoint đọc catalog công khai `/catalog/*` (provinces, wards, stop-points, vehicle-types, amenities), chỉ item `ACTIVE`. Ghi catalog vẫn ở `/admin/catalog/*` (ADM-001). Giữ trạng thái Approved, không tự promote. |
| v0.8      | 25/09/2026 | AI Agent       | **TASK-TRN-001 Q1–Q3 do Khanh duyệt:** §7.3 tách route Vehicle/SeatMap có path param (`GET/PUT /{id}`), quyền Owner `vehicle:manage`, lỗi `VEHICLE_PLATE_CONFLICT` / `CATALOG_ITEM_UNAVAILABLE`, SeatMap mẫu dùng chung + tùy chỉnh bằng bản sao. Giữ trạng thái Approved, không tự promote. |
| v0.9      | 26/09/2026 | AI Agent       | **TASK-TRN-002 Q1–Q8 do Khanh duyệt:** §7.3 thêm route chi tiết `/operator/routes`, `/operator/stop-points`, `/operator/stop-point-proposals` (endpoint đề xuất StopPoint mới), quyền `route:manage`, lỗi Goong 503. Giữ trạng thái Approved, không tự promote. |
| v0.10     | 28/09/2026 | AI Agent       | **ADR-017 amend / TASK-IAM-006 (Khanh chốt 28/09):** §5 tách actor Owner/Employee; §7.1 `/auth/operator/login` chỉ Owner, thêm `/auth/employee/login` chỉ Employee + chỉ Bearer; sai cổng = `401 AUTH_INVALID_CREDENTIALS`; §7.1.1 Employee không nhận cookie session; §7.3 username Employee bắt buộc `nv.`, Owner cấm `nv.`. Giữ trạng thái Approved. |
| v0.11     | 29/09/2026 | AI Agent       | **Loyalty VXN Plus / ví voucher / bài viết (Khanh chốt 29/09/2026, SRS v1.21):** §6.3 thêm prefix `LOYALTY_*`, `VOUCHER_*`, `ARTICLE_*`; §7.2 endpoint bài viết (public), `/me/loyalty*`, `/me/vouchers`, `POST /bookings` nhận `userVoucherId` / `promotionCode` (tối đa một); §7.5 `/admin/loyalty/*`, `/admin/articles*`, `/admin/article-categories`; §8 idempotency đổi điểm / cộng điểm / hết hạn / điều chỉnh. Trạng thái Approved → **Review**. |
| v0.12     | 30/09/2026 | AI Agent       | **A2 — đăng ký nhà xe theo closed enrollment (Khanh duyệt 30/09/2026, SRS v1.23)**: §5 thêm actor người nộp hồ sơ (link bảo mật, header `X-Application-Token`); §6.3 prefix `OPERATOR_*` gồm hồ sơ đăng ký; §7.3 thêm nhóm endpoint công khai `/operator-applications*`; §7.5 thay `/admin/operators/{operatorId}/kyc*` bằng `/admin/operator-applications*` (duyệt = tạo Operator + Owner qua `provisionOperatorOwner`); §8 idempotency cho duyệt hồ sơ. Giữ trạng thái Review. |
| v0.13     | 30/09/2026 | AI Agent       | **TASK-TRN-003 (Khanh duyệt Q1–Q6 ngày 30/09/2026):** §7.3 tách route Trip `GET/POST /operator/trips` + `GET/PUT /operator/trips/{tripId}` (quyền Owner `trip:manage`, chỉ chuyến `DRAFT`), lỗi `TRIP_NOT_FOUND` / `TRIP_NOT_EDITABLE` / `ROUTE_UNAVAILABLE` / `VEHICLE_UNAVAILABLE` / `TRIP_STOP_TIMES_INVALID` / `VEHICLE_SCHEDULE_CONFLICT`; Vehicle/SeatMap thêm 409 `SEAT_MAP_IN_USE` (UC-12 A3). Giữ trạng thái Review. |
| v0.14     | 30/09/2026 | AI Agent       | **TASK-TRN-005 (Khanh chốt Q1 = PA1, Q2–Q7):** §7.3 thêm `GET/POST /operator/fares`, `GET/PUT /operator/fares/{fareId}`, `GET /operator/fares/{fareId}/revisions` (quyền `trip:manage`); chi tiết chuyến trả `price` từng ghế; lỗi `FARE_NOT_FOUND` / `FARE_ROUTE_CONFLICT` / `FARE_RULES_OVERLAP`. Giữ trạng thái Review. |
| v0.15     | 30/09/2026 | AI Agent       | **TASK-TRN-005 (review):** §7.3 Fare — ghi lịch sử giới hạn 2 giây, lỗi/chậm → 503 `SERVICE_UNAVAILABLE` (không đổi giá); `PUT` không đổi gì không ghi lịch sử; lịch sử tối đa 20 dòng / trang (mỗi dòng mang bản trước + sau tới 200 rule). Giữ trạng thái Review. |
| v0.16     | 30/09/2026 | AI Agent       | **TASK-TRN-006 (Khanh chốt Q1–Q8):** §6.2 member mở rộng `reasons`; §7.3 thêm `PUT /operator/trips/{tripId}/status` (bảng chuyển trạng thái, điều kiện mở bán BR-39 trả mọi lý do, lý do hủy bắt buộc, audit trong transaction) và `PUT /operator/trips/{tripId}/seats/status` (khóa / mở ghế theo lô); body chuyến thêm `onlineSaleCutoffMinutes`; đổi xe giữ ghế khóa. Giữ trạng thái Review. |
| v0.17     | 30/09/2026 | AI Agent       | **TASK-TRN-006 (review):** §7.3 — request đồng thời xếp hàng (mở bán rồi hủy cả hai chạy); ghế Postgres `HOLDING` / `BOOKED` / `CHECKED_IN` chặn khóa ghế và sinh lại ghế; giữ ghế Redis để BTP-001 tự kiểm; `TRIP_BLOCKED_SEATS_MISSING` nêu mã ghế; 503 khi quá hạn transaction. Giữ trạng thái Review. |
| v0.18     | 03/10/2026 | AI Agent       | **Hình ảnh phương tiện (Khanh chốt 03/10/2026, SRS v1.32):** §7.2 `/trips/search` thêm `vehicleCoverImageUrl`, `/trips/{tripId}` thêm `vehicleImages`; §7.3 thêm `POST /operator/vehicles/{vehicleId}/images/upload-url`, `PUT /operator/vehicles/{vehicleId}/images`, vehicle trả kèm `images`, lỗi `VEHICLE_IMAGE_*`; §7.5 thêm `GET /admin/vehicle-images`, `POST /admin/vehicle-images/{imageId}/remove`. Giữ trạng thái Review. |
| v0.19     | 04/10/2026 | AI Agent       | **Phân loại xe và loại chỗ (Khanh chốt 04/10/2026, SRS v1.33):** §7.6 `/catalog/vehicle-types` trả thêm `form`, `class`; §7.2 `/trips/search` lọc `vehicleForm`, `vehicleClass`; §7.3 ghế nhận 5 loại chỗ, SeatMap trả `passengerCapacity`; rule giá dùng chung 5 loại chỗ. Giữ trạng thái Review. |
| v0.20     | 04/10/2026 | AI Agent       | **Đối chiếu Figma nhà xe (Khanh chốt 04/10/2026):** §7.3 — ảnh xe thêm `caption` (body `PUT …/images` đổi thành `{ images: [{ objectKey, caption }] }`); SeatMap trả thêm `deckCount`, `inUse`; Vehicle trả thêm `seatMapLocked` (`TASK-TRN-011`); §7.2 `vehicleImages` kèm `caption`. Giữ trạng thái Review. |
| v0.21     | 04/10/2026 | AI Agent       | **Thiết kế lại điểm dừng (Khanh chốt 04/10/2026, SRS v1.35):** §7.2 tìm chuyến theo vị trí (`provinceId` hoặc `stopPointId` mỗi phía), điểm dừng của chuyến trả `type` + `allowPickup` / `allowDropoff`; §7.3 điểm riêng chỉ `OFFICE` / `REST_STOP`, `SUSPENDED`, lọc + `routeCount`, đề xuất thêm `legalBasis`, route thêm hai cờ; §7.5 bộ endpoint Admin cho điểm dừng; §7.6 `/catalog/stop-points` thêm `q`. Giữ trạng thái Review. |
| v0.22     | 04/10/2026 | AI Agent       | **Bổ sung cho màn xe Operator OS (Khanh chốt 04/10/2026, `TASK-TRN-011`):** §7.3 — Vehicle (list + chi tiết) trả thêm `seatMap`, tóm tắt sơ đồ đang gắn, để danh sách xe không phải ghép với danh sách SeatMap. Giữ trạng thái Review. |
| v0.23     | 05/10/2026 | AI Agent       | **Hiện thực `TASK-TRN-012` (Khanh chốt 05/10/2026):** §7.3 + §7.6 — tham số `q` của `/operator/stop-points` và `/catalog/stop-points` tìm theo tên hoặc địa chỉ, **không phân biệt dấu và hoa / thường**, tối đa 100 ký tự; `routeCount` tính cả tuyến ngừng dùng; `status = SUSPENDED` trong body → 400; thiếu `allowPickup` / `allowDropoff` → 400. Giữ trạng thái Review. |
| v0.24     | 07/10/2026 | AI Agent       | **Bổ sung cho màn Tuyến đường Operator OS (Khanh chốt 07/10/2026, `TASK-TRN-013`):** §7.3 — danh sách route trả thêm tên điểm đầu / điểm cuối (`originName`, `destinationName`) để hiện cột "Điểm đầu → Điểm cuối". Đã hiện thực ở phần 2 của `TASK-TRN-013`; client TS + Dart đã sinh lại. Giữ trạng thái Review. |
| v0.25     | 13/10/2026 | AI Agent       | **Đưa `TASK-TRN-003` về repo chính (Khanh yêu cầu 13/10/2026):** §7.3 — điểm dừng của chuyến trả thêm `type`, `allowPickup`, `allowDropoff` (chép từ route, BR-79 / `TASK-TRN-012`); hai cờ `inUse` / `seatMapLocked` (`TASK-TRN-011`) tính thật theo chuyến chưa kết thúc. Phần của `TASK-TRN-005` (`price` từng ghế) và `TASK-TRN-006` (`onlineSaleCutoffMinutes`, `statusReason`, `/status`, `/seats/status`) giữ nguyên mô tả, có trong code khi port hai task đó. Giữ trạng thái Review. |
| v0.26     | 13/10/2026 | AI Agent       | **Đưa `TASK-TRN-005` về repo chính (Khanh yêu cầu 13/10/2026):** §7.3 — `GET /operator/fares` trả thêm `minPrice`, `maxPrice`, `hasDoubleSeatPrice` cho cột "Khoảng giá mỗi chỗ" của màn Bảng giá; `seatType` của rule nhận đủ 5 loại chỗ (BR-78); giờ vào API (chuyến, bảng giá) chỉ nhận năm UTC 1970–9999. Phần còn lại của route fare giữ như đã mô tả. Giữ trạng thái Review. |
| v0.27     | 14/10/2026 | AI Agent       | **`TASK-TRN-005` — Khanh chốt 14/10/2026:** duyệt ba trường `minPrice`, `maxPrice`, `hasDoubleSeatPrice` của `GET /operator/fares`; §7.3 ghi rõ khoảng giá tính trên **mọi** rule của bảng giá, kể cả rule có khung giờ đã qua (không lọc theo thời điểm). Khung giờ của rule giữ là khoảng ngày giờ khởi hành `[validFrom, validTo)` — không có giá lặp theo giờ trong ngày. Không đổi contract. Giữ trạng thái Review. |
| v0.28     | 14/10/2026 | AI Agent       | **Màn Nhân viên của Operator OS (phần giao diện của `TASK-IAM-005`):** §7.3 — tài khoản nhân viên trả thêm `passwordChangeRequired` và `temporaryPasswordExpiresAt` (chỉ đọc) để màn hình biết ai còn dùng mật khẩu tạm và mật khẩu tạm nào đã hết hạn. **Bổ sung của AI, chờ Khanh duyệt.** Không đổi route, quyền hay lỗi. Giữ trạng thái Review. |
| v0.29     | 14/10/2026 | AI Agent       | **`TASK-TRN-009` (ảnh phương tiện):** §7.3 — mỗi ảnh trả thêm `objectKey` (client gửi lại khi giữ ảnh ở `PUT …/images`; chờ Khanh duyệt); `upload-url` giới hạn 120 lần / 10 phút / tài khoản → 429 `VEHICLE_IMAGE_UPLOAD_RATE_LIMITED` (mã mới, chờ Khanh duyệt); kho lưu ảnh hoặc bộ đếm không phản hồi → 503; `PUT …/images` trả `{ images }`, object tải lên quá 23 giờ chưa gắn → 422 `VEHICLE_IMAGE_INVALID`. Giữ trạng thái Review. |
| v0.30     | 14/10/2026 | AI Agent       | **`TASK-OPR-001` (đăng ký nhà xe, chờ Khanh duyệt):** §7.3 ghi body / response của các route `/operator-applications*`; giấy tờ gắn vào hồ sơ qua `PUT …/current`; route mới `POST …/current/documents/{type}/download-url`; giới hạn tần suất và mã lỗi `OPERATOR_APPLICATION_INCOMPLETE`, `…_DOCUMENT_INVALID`, `…_DOCUMENT_NOT_FOUND`, `…_RATE_LIMITED`; kho giấy tờ chưa cấu hình → 503. Giữ trạng thái Review. |
| v0.31     | 15/10/2026 | AI Agent       | **`TASK-ADM-001` (duyệt hồ sơ nhà xe, chờ Khanh duyệt):** §7.5 ghi query / body / response của `/admin/operator-applications*`; thêm `POST …/{applicationId}/documents/{type}/download-url` và `POST …/{applicationId}/resend-owner-credentials`; lỗi `OPERATOR_APPLICATION_NOT_FOUND`; §8 cách lưu và đối chiếu `Idempotency-Key` của duyệt. Giữ trạng thái Review. |
| v0.32     | 15/10/2026 | AI Agent       | **`TASK-ADM-004` (chờ Khanh duyệt):** §7.5 ghi query / body / response của `/admin/stop-points*`, `/admin/stop-point-proposals*`, `/admin/operator-stop-points*` (quyền `catalog:manage`); thêm `GET /admin/stop-point-proposals/{proposalId}` và trường `total` của ba danh sách; lỗi `STOP_POINT_STATE_INVALID`. Giữ trạng thái Review. |
| v0.33     | 16/10/2026 | AI Agent       | **`TASK-ADM-001` phần danh mục (chờ Khanh duyệt — `ADM-001-catalog-todo.md`):** §7.5 tách dòng `/admin/catalog/*` thành 14 route (tỉnh / thành, phường / xã, loại xe, tiện ích: danh sách mọi trạng thái kèm số mục đang dùng, thêm, sửa tên; ngừng dùng / dùng lại qua `POST /admin/catalog/{kind}/{id}/deactivate` / `…/activate`, 204), quyền `catalog:manage`; mã lỗi `CATALOG_CODE_CONFLICT`, `CATALOG_ITEM_NOT_FOUND`, `CATALOG_STATE_INVALID`. Giữ trạng thái Review. |
| v0.34     | 16/10/2026 | AI Agent       | **A5 Admin (chờ Khanh duyệt — `ADM-003-vehicle-images-todo.md`, `ADM-002-audit-log-todo.md`):** §7.5 ghi query / response của `/admin/vehicle-images` (quyền mới `content:moderate`, `uploadedSince`, `total`, `operators`, `isCover`; gỡ ảnh lý do 3–500, 204) và `/admin/audit-logs` (lọc thời gian / loại người thực hiện / phân hệ / kết quả, tìm tài khoản hoặc mã đối tượng, `total`); thêm `GET /admin/audit-logs/{logId}` (trước / sau đã che, IP / thiết bị, chuỗi bản ghi cùng đối tượng, lượt xem được ghi audit); mã lỗi `AUDIT_LOG_NOT_FOUND`. Giữ trạng thái Review. |
| v0.35     | 17/10/2026 | AI Agent       | **Đợt hoàn thiện Admin + Operator OS (Khanh 16/10/2026, chờ duyệt — `CNT-001-todo.md`, `ADM-001-accounts-todo.md`, `OPR-001b-todo.md`, `ADM-001-policy-todo.md`, `ADM-system-shells-todo.md`):** §7.2 / §7.5 ghi bài viết đã làm (quyền `content:manage`; chưa revalidate ISR); §7.3 tách `/operator/profile` thành 6 route (hồ sơ, giấy tờ KYC, yêu cầu đổi tài khoản nhận tiền) và ghi `bandWarnings` ở bảng giá; §7.5 thêm nhà xe (tạm khóa / mở, xác minh đổi tài khoản nhận tiền), hành khách, nhân viên, tài khoản quản trị (quyền `user:manage`), chính sách có phiên bản + khung giá + hoa hồng (`finance:configure`), trang hệ thống chỉ đọc (`system:read`). Giữ trạng thái Review. |
| v0.36     | 17/10/2026 | AI Agent       | **Phần không cần đặt vé (Khanh 17/10/2026, chờ duyệt):** §7.3 thêm `/operator/trip-schedules*` (`TASK-TRN-007`), `/operator/trip-assignments`, `PUT /operator/trips/{tripId}/driver` (`TASK-EMP-001`); §7.5 thêm `/admin/content-pages*`; §7.2 thêm `/content-pages*` công khai (`TASK-ADM-003`). Giữ trạng thái Review. |
| v0.37     | 19/10/2026 | AI Agent       | **Sáu phần tiếp theo (Khanh 19/10/2026, chờ duyệt):** §7.2 thêm khiếu nại / tranh chấp / đánh giá theo đơn, `POST /promotions/check`; §7.3 thêm Tổng quan + Báo cáo, Hỗ trợ (khiếu nại, tranh chấp, đánh giá), Khuyến mãi; §7.4 ghi hiện thực soát vé + trạng thái chuyến; §7.5 thêm Tổng quan + Báo cáo, Khiếu nại & tranh chấp, đánh giá, Khuyến mãi, ghi hiện thực VXN Plus (đường dẫn tài khoản theo email, tham số qua `/admin/policies/LOYALTY`). Giữ trạng thái Review. |
| v0.38     | 21/10/2026 | AI Agent       | **Phân quyền theo từng tài khoản (`TASK-IAM-007`, chờ duyệt):** §7.1 `GET /auth/me` trả `permissions`; §7.3 thêm `/operator/managers*`; GET xe / sơ đồ ghế / tuyến / điểm dừng / chuyến / lịch / bảng giá đổi sang `transport:read`; §7.5 thêm `PUT /admin/platform-accounts/{id}/permissions`, route tài khoản quản trị dùng `access:manage`, thao tác chi trả `payout:manage`, hoàn tiền Admin `refund:manage`. |
| v0.39     | 26/10/2026 | AI Agent       | **Voucher trong ví khi đặt vé (`TASK-PROM-002`, Khanh 26/10/2026 "mở rộng api", chờ duyệt):** §7.2 `POST /promotions/check` nhận `userVoucherId` (báo giá, không giữ voucher) bên cạnh `code`; web bước 2 hiện tab Ví voucher theo Figma 1444:12945. Giữ trạng thái Review. |
| v0.40     | 26/10/2026 | AI Agent       | **Tuyến phổ biến + nhà xe tiêu biểu cho trang chủ (SCR-PSG-01, Khanh 26/10/2026 "bổ sung api", chờ duyệt):** §7.6 thêm `GET /catalog/popular-routes`, `GET /catalog/featured-operators` (công khai, đọc ở ngữ cảnh system, chỉ dữ liệu được phép hiển thị). Giữ trạng thái Review. |
| v0.41     | 26/10/2026 | AI Agent       | **Tra cứu vé khách vãng lai bắt buộc OTP (UX-OQ-09, Khanh 26/10/2026, chờ duyệt):** §7.2 thêm `POST /guest/ticket-lookup/otp`, `/guest/ticket-lookup/verify`; `POST /guest/ticket-lookup` chỉ nhận phiên tra cứu `lookupToken`. Chỉ email (SMS hoãn v1). Giữ trạng thái Review. |
| v0.42     | 27/10/2026 | AI Agent       | **Tra cứu vé không cần mã đặt vé (Khanh 27/10/2026, chờ duyệt):** §7.2 `bookingCode` không bắt buộc ở `/guest/ticket-lookup/otp` + `/verify`, giới hạn gửi mã tính theo email; thêm `POST /guest/ticket-lookup/bookings`; `POST /guest/ticket-lookup` nhận `bookingId`. Giữ trạng thái Review. |

---

## 2. Mục lục

1. Thông tin tài liệu
2. Mục lục
3. Giới thiệu
4. Quy ước API
5. Auth và permission
6. Response và error format
7. Endpoint groups
8. Idempotency
9. Pagination, filtering, sorting
10. Webhook và realtime API
11. Open Questions / TBD

---

## 3. Giới thiệu

Tài liệu này mô tả API contract cho frontend, mobile và backend. Theo **ADR-012**, API style v1 = **REST + OpenAPI 3.1** với **Zod là single source** (nestjs-zod + `@nestjs/swagger` auto-gen OpenAPI → `openapi-typescript` + `orval`/`@hey-api` gen client TS — tool client cụ thể chốt khi setup). Chi tiết request/response DTO hoàn thiện cùng LLD + DB Design.

Tài liệu tham chiếu: `01-srs`, `02-hld`, `03-lld`, `04-database-design`, `10-adr` (v0.21 — ADR-012/017/019/020), `07-security`, `context/GLOSSARY` (error code).

---

## 4. Quy ước API

| Quy ước            | Giá trị                                                                                                                 |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| Base path          | `/v1` (URL versioning; breaking change → `/v2`, ADR-012)                                                                |
| Spec               | OpenAPI 3.1 auto-gen từ Zod schema (sticky 3.0 v1 cho tới khi tool ecosystem support 3.1, ADR-012)                      |
| Format             | JSON; error = `application/problem+json` (RFC 7807)                                                                     |
| Auth               | Web Operator OS/Admin opt-in `X-Auth-Transport: cookie`; Mobile mặc định/`bearer` giữ JSON + `Authorization: Bearer <jwt>` (ADR-017/028, TASK-IAM-006) |
| Timezone hiển thị  | `Asia/Ho_Chi_Minh`                                                                                                      |
| Time lưu trữ       | UTC                                                                                                                     |
| Currency           | VND (amount = integer đồng)                                                                                             |
| Naming             | camelCase cho JSON field                                                                                                |
| Deprecation        | OpenAPI `deprecated: true` + response header `Deprecation: <date>` (ADR-012)                                            |
| Idempotency header | `Idempotency-Key` cho thao tác payment/refund/booking nhạy cảm                                                          |
| Correlation header | `X-Request-Id` nếu client/gateway cung cấp                                                                              |

---

## 5. Auth và permission

Identity 3 namespace tách biệt (ADR-017). Hybrid token: JWT RS256 access 15min + opaque refresh 30d (rotation + family invalidation).

| Actor               | Auth flow                                                                    | Ghi chú                                                  |
| ------------------- | ---------------------------------------------------------------------------- | -------------------------------------------------------- |
| Guest               | Không token cho public search/detail; guest session cho hold/book/pay/lookup | Guest checkout có trong v1 (SRS/GLOSSARY)                |
| Người nộp hồ sơ nhà xe | Không tài khoản; link bảo mật gửi email liên hệ, token gửi qua header `X-Application-Token` | Chỉ xem / sửa đúng một hồ sơ đăng ký (BR-75); không vào Operator OS |
| Passenger (User)    | Email + OTP (primary) hoặc OAuth Google/Facebook/Apple (ADR-020)             | Self-register; Hybrid token                              |
| Operator Owner      | `{operatorSlug}/{username}` + password qua `/auth/operator/login` (closed enrollment); username cấm tiền tố `nv.` | Web Operator OS (cookie) hoặc Bearer; scope theo `operatorId`; không public/OAuth |
| Employee            | `{operatorSlug}/nv.{…}` + password qua `/auth/employee/login` (closed enrollment) | Chỉ app `employee_mobile`, chỉ Bearer; scope theo `operatorId` + assignment; không public/OAuth |
| Admin / Platform    | `platform/{username}` + password (closed enrollment)                         | TOTP mandatory; không public/OAuth                       |

MFA: TOTP bắt buộc OperatorOwner / PlatformAdmin / PlatformSupport; optional Driver / TicketStaff / SupportStaff (ADR-017).

---

## 6. Response và error format

### 6.1. Response thành công

HTTP status code là nguồn chuẩn. Body bọc nhẹ:

```json
{
  "data": {},
  "meta": { "requestId": "..." }
}
```

### 6.2. Response lỗi — RFC 7807 Problem Details (ADR-012)

`Content-Type: application/problem+json`

```json
{
  "type": "https://api.vexenhanh.vn/problems/booking-expired",
  "title": "Booking đã hết hạn thanh toán",
  "status": 409,
  "detail": "SeatHold đã hết TTL trước khi thanh toán.",
  "instance": "/v1/bookings/{bookingId}/payments",
  "code": "BOOKING_EXPIRED"
}
```

Field `code` dùng error code chuẩn (GLOSSARY); `type` là URI ổn định; `status` khớp HTTP status. Lỗi cần liệt kê nhiều nguyên nhân thêm member mở rộng `reasons: string[]` (RFC 7807 cho phép) — vd `TRIP_NOT_READY_FOR_SALE` trả mọi điều kiện mở bán chưa đạt để client sửa một lần.

### 6.3. Nhóm error code

| Prefix         | Nhóm lỗi                                                     |
| -------------- | ------------------------------------------------------------ |
| `AUTH_*`       | Đăng nhập, session, token, MFA                               |
| `PERMISSION_*` | RBAC, ownership, tenant boundary                             |
| `VALIDATION_*` | Input/Zod schema không hợp lệ                                |
| `SEAT_*`       | Chọn ghế, giữ ghế, xung đột ghế                              |
| `BOOKING_*`    | Booking state/snapshot                                       |
| `PAYMENT_*`    | Payment, callback, reconciliation                            |
| `REFUND_*`     | Refund policy/state                                          |
| `TICKET_*`     | Ticket, QR, check-in                                         |
| `OPERATOR_*`   | Hồ sơ đăng ký nhà xe, KYC, profile, status                                         |
| `PAYOUT_*`     | Payout, escrow, commission                                   |
| `LOYALTY_*`    | Tài khoản thành viên, điểm, đổi điểm                         |
| `VOUCHER_*`    | Ví voucher, áp voucher vào booking                           |
| `ARTICLE_*`    | Bài viết, chuyên mục                                         |
| `SYSTEM_*`     | Provider lỗi, bảo trì, 503 (Redis down), lỗi không phân loại |

---

## 7. Endpoint groups

Path dưới đây tương đối với base `/v1`.

### 7.1. Auth

| Method | Path                     | Actor              | Mục đích                                  |
| ------ | ------------------------ | ------------------ | ----------------------------------------- |
| POST   | `/auth/register`         | Passenger          | Đăng ký Passenger (Email)                 |
| POST   | `/auth/otp/request`      | Passenger, Guest   | Gửi Email OTP (Resend)                    |
| POST   | `/auth/otp/verify`       | Passenger          | Xác thực OTP + cấp token                  |
| POST   | `/auth/oauth/{provider}` | Passenger          | OAuth Google / Facebook / Apple (ADR-020) |
| POST   | `/auth/operator/login`   | Operator Owner     | Login `{slug}/{username}` + password; chỉ tra account Owner; Owner nhận MFA challenge thay vì token |
| POST   | `/auth/employee/login`   | Employee           | Login `{slug}/nv.{…}` + password; chỉ tra account Employee; **chỉ Bearer** (app Nhân viên) |
| POST   | `/auth/platform/login`   | Admin, Platform    | Login `platform/{username}` + password; nhận MFA challenge thay vì token |
| POST   | `/auth/mfa/verify`       | Có `challengeToken` từ login (không Bearer) | Xác thực TOTP / backup code (lần đầu = enrollment) → cấp token |
| POST   | `/auth/password/change-required` | Có `passwordChangeToken` từ login (không Bearer) | Đổi mật khẩu tạm một lần; token TTL 5 phút; phải login lại trước MFA/token |
| GET    | `/auth/csrf`             | Web Operator/Admin | Cấp signed double-submit CSRF token; đặt cookie `vxn_csrf`; `no-store` |
| GET    | `/auth/me`               | Authenticated      | Bootstrap phiên hiện tại từ access cookie hoặc Bearer; không tự refresh, không trả token thô |
| POST   | `/auth/refresh`          | Authenticated      | Refresh token (rotation + family)         |
| POST   | `/auth/logout`           | Authenticated      | Logout + revoke session                   |
| POST   | `/auth/re-auth`          | Authenticated      | Re-auth thao tác nhạy cảm (password / OTP / mã MFA) |
| GET    | `/auth/sessions`         | Authenticated      | List active device family của chính subject; cursor 20/tối đa 100, IP đã mask |
| DELETE | `/auth/sessions/{sessionId}` | Authenticated   | Revoke đúng family của chính subject, idempotent 204; foreign/missing 404 |

Operator/Employee login bằng mật khẩu tạm còn hạn trả `passwordChangeRequired`, `passwordChangeToken`, `passwordChangeExpiresIn` thay vì access/refresh token hay MFA secret. Khi `credentialDeliveryPending` hoặc `status` không `ACTIVE`, login bị chặn. Challenge cấp trước reset/retry bị vô hiệu bởi `authEpoch`; lệnh đổi mật khẩu kiểm lại epoch và `ACTIVE`. Password change thành công không tự đăng nhập. V1 không hard-cap số phiên.

Tách cổng Owner/Employee (ADR-017 amend 28/09/2026, TASK-IAM-006): mỗi cổng chỉ tra đúng bảng account của mình. Account đúng mật khẩu nhưng gọi sai cổng (Employee ở `/auth/operator/login`, Owner ở `/auth/employee/login`) bị xử lý như account không tồn tại: `401 AUTH_INVALID_CREDENTIALS`, không tạo session, không trả MFA challenge hay password-change challenge.

#### 7.1.1. Dual transport Web / Mobile (TASK-OQ-05 — đóng 25/09/2026)

- Client chọn tường minh bằng `X-Auth-Transport: cookie | bearer`; **không sniff User-Agent**. Thiếu header = `bearer` để giữ tương thích Mobile. Giá trị khác → `400 AUTH_TRANSPORT_INVALID`.
- Header áp dụng cho login Operator/Platform, MFA verify, đổi mật khẩu bắt buộc, refresh, logout và re-auth. Employee chỉ nhận phiên Bearer: `/auth/employee/login` và `/auth/mfa/verify` với challenge của Employee nhận `X-Auth-Transport: cookie` → `400 AUTH_TRANSPORT_INVALID`. Challenge `passwordChangeToken`/`challengeToken` vẫn ở JSON và web chỉ giữ trong memory; chưa cấp cookie auth trước khi hoàn tất login/MFA.
- `bearer`: response token giữ nguyên `{accessToken, refreshToken, tokenType, expiresIn, refreshExpiresIn, scope, role}`; không có `Set-Cookie`.
- `cookie`: response cấp session **không chứa** access/refresh token thô; trả metadata `{authenticated, scope, role, expiresIn, refreshExpiresIn}` và `backupCodes` đúng một lần nếu vừa enrollment MFA. CSRF token mới trả qua header `X-CSRF-Token`.
- Protected endpoint nhận đúng một credential: `Authorization: Bearer` **hoặc** `vxn_access`. Có cả hai → `400 AUTH_TRANSPORT_AMBIGUOUS`; không có ưu tiên ngầm.

| Cookie        | HttpOnly | Secure                              | SameSite | Path               | Domain    | Max-Age |
| ------------- | -------- | ----------------------------------- | -------- | ------------------ | --------- | ------- |
| `vxn_access`  | Có       | Có ở staging/prod; local HTTP = false | `Lax`  | `/v1`              | host-only | 900s    |
| `vxn_refresh` | Có       | Như trên                            | `Strict` | `/v1/auth/refresh` | host-only | 30 ngày |
| `vxn_csrf`    | Không    | Như trên                            | `Strict` | `/v1`              | host-only | 30 ngày, rotate |

Gửi cả `Max-Age` và `Expires`; logout/reuse/revoke current family phải xóa bằng đúng attributes. Không đặt `Domain=.vexenhanh.vn`, không chia sẻ auth credential giữa các app web.

#### 7.1.2. CSRF, CORS và bootstrap

- CSRF dùng **signed double-submit cookie**: web gọi `GET /auth/csrf`, nhận cookie `vxn_csrf` và body `{csrfToken}`; giữ token trong memory, gửi `X-CSRF-Token`.
- Bắt buộc CSRF + `Origin` hợp allowlist cho mọi `POST/PUT/PATCH/DELETE` dùng cookie trong `/v1/**`, gồm login/MFA/password-change/refresh/logout/re-auth/session revoke và mutation nghiệp vụ. `GET/HEAD/OPTIONS` và Bearer mode được miễn; các method an toàn không được tạo side effect.
- Rotate CSRF khi cấp session, refresh hoặc đổi mật khẩu thành công; clear khi logout/current family bị revoke. Thiếu/sai/cũ → `403 AUTH_CSRF_INVALID`; origin sai/thiếu ở unsafe cookie request → `403 AUTH_ORIGIN_FORBIDDEN`.
- CORS: `credentials: true`, echo đúng exact origin từ `CORS_ALLOWED_ORIGINS`, `Vary: Origin`, tuyệt đối không `*`; `OPTIONS` không qua auth/CSRF. Cho phép `Content-Type`, `Authorization`, `X-Auth-Transport`, `X-CSRF-Token`, `X-Request-Id`, `Idempotency-Key`; expose `X-CSRF-Token`, `X-Request-Id`, `Deprecation`.
- `GET /auth/me` trả `subjectId`, `scope`, `role`, `username`, `sessionId`, `accessExpiresAt`, `mfaVerified`; Operator thêm `operatorId`, `operatorSlug`. Response `no-store`, không trả access/refresh token, MFA secret hay backup code và **không tự refresh**. Web nhận 401 thì chạy đúng một refresh single-flight rồi retry `/auth/me`.

### 7.2. Marketplace

| Method | Path                                     | Actor       | Mục đích                          |
| ------ | ---------------------------------------- | ----------- | --------------------------------- |
| GET    | `/trips/search`                          | User, Guest | Tìm kiếm chuyến (cache Redis 60s); mỗi chuyến kèm `vehicleCoverImageUrl` (ảnh đại diện của xe, `null` nếu chưa có); lọc `vehicleForm`, `vehicleClass` độc lập (BR-77) |
| GET    | `/trips/{tripId}`                        | User, Guest | Xem chi tiết chuyến; kèm `vehicleImages` (`[{ url, caption }]` theo thứ tự, mảng rỗng nếu chưa có) |
| GET    | `/operators/{operatorId}/public-profile` | User, Guest | Xem profile Operator              |
| POST   | `/seat-holds`                            | User, Guest | Giữ ghế (Redis SET NX EX 600)     |
| DELETE | `/seat-holds/{holdId}`                   | User, Guest | Hủy hold                          |
| POST   | `/bookings`                              | User, Guest | Tạo booking                       |
| GET    | `/bookings/{bookingId}`                  | User, Guest | Xem booking                       |
| POST   | `/bookings/{bookingId}/payments`         | User, Guest | Tạo payment (VNPay/MoMo)          |
| GET    | `/tickets/{ticketId}`                    | User        | Xem vé                            |
| POST   | `/guest/ticket-lookup/otp`               | Guest       | Chờ duyệt (26/10/2026, UX-OQ-09 Khanh chốt bắt buộc OTP; 27/10/2026 mã đặt vé không bắt buộc): `{ email, bookingCode? }` (`bookingCode` = mã đặt vé hoặc mã vé "-NN") → 202 `{ maskedEmail, expiresInSeconds: 300, resendAfterSeconds: 60, maxAttempts: 5 }` **như nhau dù có đơn hay không**; chỉ gửi mã 6 số về email khi đúng mã + email, hoặc (không mã) email có đơn trong 12 tháng (SMS hoãn v1 — ADR-020). 429 `TICKET_LOOKUP_RATE_LIMITED`: 10 lần / 10 phút / IP, chờ 60 giây giữa hai lần gửi và ≤ 5 mã / giờ — tính theo email; Redis lỗi → 503 |
| POST   | `/guest/ticket-lookup/verify`            | Guest       | Chờ duyệt: `{ email, bookingCode?, otp }` → `{ lookupToken, expiresAt }` (phiên tra cứu 15 phút, Redis giữ băm token + phạm vi email / đơn). 422 `TICKET_LOOKUP_OTP_INVALID` — sai mã (câu báo kèm "Còn N lần thử"), hết hạn hoặc hết 5 lượt (phải gửi lại mã); mã dùng một lần |
| POST   | `/guest/ticket-lookup/bookings`          | Guest       | Chờ duyệt (27/10/2026): `{ lookupToken }` → `{ maskedEmail, scope: BOOKING \| EMAIL, hasAccount, items[] }` — `BOOKING` (đã nhập mã) chỉ đơn đó; `EMAIL` các đơn có `contact_email` là email đã xác minh, tạo trong 12 tháng gần nhất, mới nhất trước, tối đa 50, **gồm cả đơn đặt khi đã đăng nhập** (`bookedWithAccount`). `hasAccount` = email có tài khoản hành khách đang hoạt động → web hỏi khách có muốn đăng nhập. 404 `TICKET_LOOKUP_EXPIRED` |
| POST   | `/guest/ticket-lookup`                   | Guest       | Tra cứu vé khách vãng lai. Chờ duyệt: `{ lookupToken, bookingId? }` (bỏ tra trực tiếp bằng mã + SĐT / email) → booking kèm vé, chỉ xem; phiên `EMAIL` bắt buộc `bookingId` thuộc danh sách của phiên. 404 `TICKET_LOOKUP_EXPIRED` / `BOOKING_NOT_FOUND`. Hủy vé / khiếu nại vẫn cần mã truy cập booking của trình duyệt đã đặt hoặc tài khoản |
| GET    | `/article-categories`                    | User, Guest | Chuyên mục bài viết + số bài đã xuất bản |
| GET    | `/articles`                              | User, Guest | Bài `PUBLISHED` (lọc `category`, `q`, `featured`; phân trang) |
| GET    | `/articles/{slug}`                       | User, Guest | Chi tiết bài `PUBLISHED` (khác → 404) |
| POST   | `/articles/{slug}/views`                 | User, Guest | Ghi lượt xem best-effort (rate limit). `TASK-CNT-001` (chờ duyệt): 204; mỗi IP một lượt / bài / 30 phút (Redis); danh sách / chi tiết chỉ bài `PUBLISHED` có `publishedAt` ≤ hiện tại (hẹn giờ không cần job) |
| GET    | `/content-pages`                         | User, Guest | `?type=FAQ\|BANNER\|PAGE&placement` → mục đang hiển thị theo thứ tự — `TASK-ADM-003` (chờ duyệt) |
| GET    | `/content-pages/{slug}`                  | User, Guest | Trang tĩnh đang hiển thị (nháp / không có → 404) |
| POST   | `/promotions/check`                      | User, Guest | `TASK-PROM-001` (chờ duyệt): `{ tripId, subtotal }` + **đúng một** trong `code` (mã công khai) hoặc `userVoucherId` (voucher trong ví — cần đăng nhập, `TASK-PROM-002`, 26/10/2026 chờ duyệt) → `{ code, name, discount, total }`; không giữ lượt mã / không giữ voucher. Lỗi voucher: 422 `VOUCHER_NOT_AVAILABLE` (chưa đăng nhập) / `VOUCHER_EXPIRED` / `VOUCHER_NOT_APPLICABLE`, 409 `VOUCHER_NOT_AVAILABLE` (của người khác / đang giữ). `POST /bookings` nhận `promotionCode` hoặc `userVoucherId` (`expectedTotal` là tổng sau giảm) |
| GET/POST | `/bookings/{bookingId}/support-tickets` | User, Guest | `TASK-TRUST-001` (chờ duyệt), quyền `support:create` (khách vãng lai gửi `X-Booking-Token`): khiếu nại của đơn / gửi `{ category, subject, body, attachmentIds }` |
| GET / POST | `/bookings/{bookingId}/support-tickets/{ticketId}` · `…/messages` | User, Guest | Xem trao đổi (liên hệ nội bộ ẩn) / trả lời kèm tệp |
| POST   | `/bookings/{bookingId}/support-attachments/upload-url` · `…/{attachmentId}/download-url` | User, Guest | Xin URL tải thẳng kho riêng tư (khóa server sinh) / URL xem 5 phút (audit mỗi lần); production chưa có kho riêng tư → 503 (OQ-21) |
| GET / POST | `/bookings/{bookingId}/disputes` · `/{disputeId}` · `/{disputeId}/responses` | User, Guest | Tranh chấp của đơn; gửi minh chứng khi được yêu cầu (chỉ thấy minh chứng của mình + Vé Xe Nhanh) |
| GET/POST | `/bookings/{bookingId}/review`          | User        | Quyền `review:create` (không cho khách vãng lai): xem / gửi đánh giá `{ rating 1–5, comment }` một lần khi chuyến hoàn thành và có vé đã đi (BR-18) |
| GET    | `/me/loyalty`                            | User        | Hạng, điểm khả dụng, điểm cần lên hạng, bảng hạng theo policy hiện hành |
| GET    | `/me/loyalty/transactions`               | User        | Lịch sử điểm (lọc `type`, thời gian) + tổng đã tích / đổi / hết hạn |
| POST   | `/me/loyalty/redemptions`                | User        | Đổi điểm → voucher (`Idempotency-Key` bắt buộc) |
| GET    | `/me/vouchers`                           | User        | Ví voucher (lọc `status`) |
| POST   | `/me/vouchers`                           | User        | Lưu mã khuyến mãi công khai vào ví (`promotionCode`) |

`POST /bookings` nhận thêm **tối đa một** trong hai field tùy chọn: `userVoucherId` (User đăng nhập, voucher của chính mình) hoặc `promotionCode`; gửi cả hai → `422 VOUCHER_ONE_PER_BOOKING`. Response booking tách dòng giảm giá kèm `fundedBy` (CO-12, BR-72/73).

Tìm chuyến theo vị trí (TASK-TRN-004, BR-80): điểm đi và điểm đến mỗi phía gửi **một** trong hai — tỉnh / thành (`fromProvinceId`, `toProvinceId`) hoặc địa danh là điểm dừng dùng chung (`fromStopPointId`, `toStopPointId`); thiếu hoặc gửi cả hai ở một phía → 400. Theo tỉnh: khớp điểm dừng của chuyến thuộc tỉnh đó. Theo địa danh: khớp điểm dừng của chuyến, dùng chung hay riêng, trong bán kính cấu hình quanh địa danh (mặc định 5 km). Chỉ xét điểm cho đón ở phía đi và cho trả ở phía đến, điểm đón đứng trước điểm trả; trạm dừng nghỉ không tham gia. Mỗi chuyến trong kết quả kèm điểm đón / trả khớp gần nhất. `GET /trips/{tripId}` trả từng điểm dừng kèm `type`, `allowPickup`, `allowDropoff`; điểm loại `OFFICE` là điểm trung chuyển miễn phí. `POST /bookings`: điểm đón phải `allowPickup`, điểm trả phải `allowDropoff`, đón trước trả — sai → 422 (BR-23).

### 7.3. Operator OS

Đăng ký nhà xe — **công khai, trước khi có tài khoản** (BR-75). Mọi endpoint `current` yêu cầu header `X-Application-Token`; rate limit theo IP và email; `POST` tạo hồ sơ / gửi lại link luôn trả `202` giống nhau để không lộ email đã có hồ sơ.

| Method | Path                                           | Actor                  | Mục đích                                                                 |
| ------ | ---------------------------------------------- | ---------------------- | ------------------------------------------------------------------------ |
| POST   | `/operator-applications`                       | Public                 | Tạo hồ sơ `DRAFT` (tên nhà xe, người liên hệ, email) + gửi link bảo mật  |
| POST   | `/operator-applications/access-link`           | Public                 | Gửi lại link (email liên hệ + mã hồ sơ); link cũ hết hiệu lực            |
| GET    | `/operator-applications/current`               | Người nộp hồ sơ        | Xem hồ sơ và trạng thái                                                  |
| PUT    | `/operator-applications/current`               | Người nộp hồ sơ        | Cập nhật thông tin doanh nghiệp, tài khoản nhận tiền (`DRAFT` / `NEEDS_INFO`) |
| POST   | `/operator-applications/current/documents`     | Người nộp hồ sơ        | Presigned upload giấy tờ KYC (R2 private)                                |
| POST   | `/operator-applications/current/submit`        | Người nộp hồ sơ        | Gửi duyệt → `SUBMITTED`                                                  |
| POST   | `/operator-applications/current/documents/{type}/download-url` | Người nộp hồ sơ | URL xem một giấy tờ đã gắn (presigned 5 phút, audit) — `TASK-OPR-001`, chờ duyệt |

Chi tiết (`TASK-OPR-001`, chờ Khanh duyệt): tạo hồ sơ `{ operatorName, contactName, contactEmail, acceptTerms: true }`; gửi lại link `{ contactEmail, applicationCode }` (mã dạng `OA-2026-043152`) — cả hai giới hạn 3 lần / email / giờ và 10 lần / IP / giờ, vượt → 429 `OPERATOR_APPLICATION_RATE_LIMITED`. `GET …/current` trả hồ sơ kèm `documents`, `missing` (mục còn thiếu để gửi duyệt), `linkExpiresAt`; số tài khoản chỉ trả bản che `bankAccountNumberMasked`. `PUT …/current` lưu nháp (mọi trường cho phép `null`; mã số thuế 10 / 13 số, hotline 8–15 số, số tài khoản 6–20 số; bỏ `bankAccountNumber` = giữ số cũ) và thay toàn bộ `documents: [{ type, objectKey, fileName }]` — giấy tờ mới phải là object đã tải lên hợp lệ dưới khóa của chính hồ sơ (PDF / JPEG / PNG ≤ 10 MB, kiểm chữ ký file), sai → 422 `OPERATOR_APPLICATION_DOCUMENT_INVALID`. `POST …/current/documents` `{ type, contentType, sizeBytes, fileName }` → `{ uploadUrl, objectKey, expiresAt }`, tối đa 30 lần / hồ sơ / giờ. Sửa / tải / gửi duyệt khi hồ sơ không ở `DRAFT` / `NEEDS_INFO` → 409 `OPERATOR_APPLICATION_INVALID_STATE`; gửi duyệt còn thiếu → 422 `OPERATOR_APPLICATION_INCOMPLETE` kèm `reasons` (mọi mục thiếu). Kho giấy tờ chưa cấu hình (production, OQ-21) / Redis / audit lỗi → 503.

Sau khi được duyệt (Owner đã đăng nhập):

| Method       | Path                        | Actor    | Mục đích                          |
| ------------ | --------------------------- | -------- | --------------------------------- |
| GET/PUT      | `/operator/profile`         | Operator Owner | Xem / sửa hồ sơ. `TASK-OPR-001b` (chờ duyệt): quyền `kyc:submit`; `GET` trả thông tin công khai + pháp lý, trạng thái, giấy tờ (metadata), tài khoản đang dùng (`accountNumberMasked`), yêu cầu đổi gần nhất còn chờ / bị từ chối; `PUT` `{ displayName, hotline, publicEmail, address, description }` — tên pháp lý / MST không sửa; audit trường đổi |
| POST         | `/operator/profile/documents/upload-url` | Operator Owner | `TASK-OPR-001b`: `{ contentType (PDF/JPEG/PNG), sizeBytes ≤ 10 MB }` → `{ uploadUrl, objectKey, expiresAt }`; khóa `operator-kyc/{operatorId}/{uuid}.{ext}` (R2 private, 5 phút); kho chưa cấu hình → 503 (OQ-21) |
| PUT          | `/operator/profile/documents/{type}` | Operator Owner | `TASK-OPR-001b`: `{ objectKey, fileName }` thay giấy tờ loại `type`; kiểm object (đúng tiền tố nhà xe, đủ mới, dung lượng, chữ ký file) → sai 422 `KYC_DOCUMENT_INVALID`; audit; bản cũ tự tải lên bị xóa sau commit |
| POST         | `/operator/profile/documents/{type}/download-url` | Operator Owner | `TASK-OPR-001b`: URL xem 5 phút, mỗi lần cấp ghi audit; chưa có → 404 `KYC_DOCUMENT_NOT_FOUND` |
| POST         | `/operator/profile/bank-account-change` | Operator Owner | `TASK-OPR-001b`: `{ bankName, accountNumber, accountHolder (tự viết hoa, bỏ dấu), reason 3–500 }` — **xác nhận lại danh tính**; tạo yêu cầu `PENDING` chờ Admin; đã có yêu cầu chờ → 409 `BANK_ACCOUNT_CHANGE_PENDING`; trùng tài khoản đang dùng → 422 `BANK_ACCOUNT_UNCHANGED` |
| GET          | `/operator/finance/escrow`  | Operator | Xem escrow balance                |
| GET          | `/operator/finance/payouts` | Operator | Xem lịch sử payout                |
| GET/POST | `/operator/vehicles`        | Operator Owner | List (cursor 20/tối đa 100, lọc `status`) / tạo vehicle |
| GET/PUT  | `/operator/vehicles/{vehicleId}` | Operator Owner | Xem / thay toàn bộ vehicle; khác tenant → 404 |
| POST     | `/operator/vehicles/{vehicleId}/images/upload-url` | Operator Owner | Xin presigned `PUT` (R2 public, TTL 5 phút) cho một ảnh xe: body `{ contentType, sizeBytes }` → `{ uploadUrl, objectKey, expiresAt }` |
| PUT      | `/operator/vehicles/{vehicleId}/images` | Operator Owner | Thay toàn bộ bộ ảnh của xe theo thứ tự: body `{ images: [{ objectKey, caption }] }` (0–8 phần tử); phần tử đầu là ảnh đại diện |
| GET/POST | `/operator/seat-maps`       | Operator Owner | List (không kèm ghế) / tạo seat map do nhà xe tự cấu hình |
| GET/PUT  | `/operator/seat-maps/{seatMapId}` | Operator Owner | Xem kèm ghế / thay toàn bộ bố cục + ghế; khác tenant → 404 |
| GET/POST | `/operator/routes`          | Operator Owner | List (cursor 20/tối đa 100, lọc `status`; mỗi item kèm `stopCount`, `originName`, `destinationName`) / tạo route + tính khoảng cách/thời gian qua Goong |
| GET/PUT  | `/operator/routes/{routeId}` | Operator Owner | Xem kèm điểm dừng / thay toàn bộ route; chỉ tính lại khi chuỗi toạ độ đổi |
| GET/POST | `/operator/stop-points`     | Operator Owner | List (lọc `status`, `type`, `provinceId`, tìm `q` theo tên / địa chỉ; kèm `routeCount`) / tạo điểm dừng riêng — chỉ loại `OFFICE`, `REST_STOP`, dùng ngay trong tenant |
| GET/PUT  | `/operator/stop-points/{stopPointId}` | Operator Owner | Xem / thay toàn bộ điểm riêng; điểm đang bị Admin khóa → 409 `STOP_POINT_SUSPENDED` |
| GET/POST | `/operator/stop-point-proposals` | Operator Owner | List / gửi đề xuất bến xe hoặc điểm dừng đón trả khách vào danh mục dùng chung (`PENDING`), bắt buộc `legalBasis` |
| PUT      | `/operator/stop-point-proposals/{proposalId}` | Operator Owner | Sửa + gửi lại đề xuất đang `REJECTED` (→ `PENDING`); trạng thái khác → 409 |
| GET/POST | `/operator/trips`           | Operator Owner | List chuyến sắp theo giờ đi (lọc `routeId`/`vehicleId`/`status`/`departureFrom`/`departureTo`, cursor = id chuyến cuối trang, 20/tối đa 100) / tạo chuyến `DRAFT` |
| GET/PUT  | `/operator/trips/{tripId}`  | Operator Owner | Xem kèm điểm dừng + ghế (kèm `price` từng ghế) / thay toàn bộ chuyến còn `DRAFT`; khác tenant → 404 |
| PUT      | `/operator/trips/{tripId}/status` | Operator Owner | Mở bán / khóa (tạm dừng) / mở lại / thu hồi về nháp / hủy chuyến chưa có vé (TRN-006) |
| PUT      | `/operator/trips/{tripId}/seats/status` | Operator Owner | Khóa / mở ghế thủ công theo lô (`BLOCKED` ↔ `AVAILABLE`, bán ngoài Platform — BR-42) |
| GET/POST | `/operator/trip-schedules` | Operator Owner | `TASK-TRN-007` (chờ duyệt), quyền `trip:manage`: danh sách lịch (còn hiệu lực trước) / tạo lịch `{ routeId, vehicleId \| null, departureTime HH:mm (giờ VN), durationMinutes, daysOfWeek [1..7], startDate, endDate (≤ 92 ngày sau), onlineSaleCutoffMinutes, note }`; tuyến ngừng / xe không dùng được → 422 |
| GET/PUT | `/operator/trip-schedules/{scheduleId}` | Operator Owner | Chi tiết (kèm `tripCount`, `lastGeneratedAt`) / thay toàn bộ quy tắc — chuyến đã sinh giữ nguyên; khác tenant → 404 `TRIP_SCHEDULE_NOT_FOUND` |
| POST | `/operator/trip-schedules/{scheduleId}/generate` | Operator Owner | `{ openForSale }` → `{ created: [{ tripId, serviceDate, departureAt, status, notOpenedReasons }], skipped: [{ serviceDate, reason: EXISTS \| PAST \| VEHICLE_CONFLICT }] }`; chạy lại không sinh trùng |
| GET | `/operator/trip-assignments` | Operator Owner | `TASK-EMP-001` (chờ duyệt), quyền `employee:manage`: `?date (giờ VN)&routeId&state=ASSIGNED\|UNASSIGNED&cursor&limit` → chuyến chưa hủy trong ngày + `driver`, `conflict`, `reasonRequired`, `editable` |
| PUT | `/operator/trips/{tripId}/driver` | Operator Owner | `{ employeeId \| null, reason }` phân công / đổi / bỏ tài xế; 409 `DRIVER_SCHEDULE_CONFLICT` / `TRIP_NOT_ASSIGNABLE`, 422 `EMPLOYEE_NOT_ASSIGNABLE` / `ASSIGNMENT_REASON_REQUIRED`; audit trong transaction |
| GET/POST | `/operator/fares`           | Operator Owner | List bảng giá (lọc `routeId`/`status`, cursor 20/tối đa 100) / tạo bảng giá cho một tuyến (mỗi tuyến một bảng) |
| GET/PUT  | `/operator/fares/{fareId}`  | Operator Owner | Xem kèm rule / thay toàn bộ trạng thái + ghi chú + rule; khác tenant → 404 |
| GET      | `/operator/fares/{fareId}/revisions` | Operator Owner | Lịch sử thay đổi bảng giá (mới nhất trước, cursor = `createdAt`, 20/tối đa 20), đọc từ audit |
| GET          | `/operator/bookings`        | Operator | Xem booking/ticket thuộc Operator |
| GET/POST | `/operator/employees`       | Operator Owner | List/tạo Employee trong tenant; create gửi mật khẩu tạm qua email. Mỗi tài khoản trả `credentialDeliveryPending`, `passwordChangeRequired` (đang dùng mật khẩu tạm chưa đổi) và `temporaryPasswordExpiresAt` (hạn của mật khẩu tạm, `null` khi không có) — hai trường sau thêm 14/10/2026 cho màn Nhân viên, chờ Khanh duyệt |
| PATCH | `/operator/employees/{employeeId}` | Operator Owner | Đổi username/contactEmail/role/status; reason + recent re-auth bắt buộc. Response có `credentialDeliveryPending`; đổi email revoke phiên và cần password-reset tới email mới trước khi login lại |
| POST | `/operator/employees/{employeeId}/password-reset` | Operator Owner | Cấp mật khẩu tạm mới và revoke-all; reason + recent re-auth bắt buộc |
| GET / POST | `/operator/managers` | Operator Owner (`manager:manage`) | Tài khoản quản lý dùng Operator OS (`TASK-IAM-007`, chờ duyệt): danh sách (quyền, 2FA, trạng thái, đăng nhập gần nhất); cấp mới `{ username, contactEmail, permissions, reason }` — mật khẩu tạm qua email, lần đầu đổi mật khẩu + bật TOTP. `permissions` ⊆ 8 quyền tick được (không gồm `kyc:submit`, `manager:manage`) |
| PATCH | `/operator/managers/{managerId}` | Operator Owner | `{ permissions?, status? (ACTIVE / LOCKED), reason }`; có đổi thì tăng `auth_epoch` + thu hồi mọi phiên. Dòng Owner không đụng được (404) |
| POST | `/operator/managers/{managerId}/password-reset` · `…/mfa-reset` | Operator Owner | `{ reason }`; mật khẩu tạm mới (reset 2FA xóa TOTP + backup code) + thu hồi phiên |
| GET | `/operator/overview` · `/operator/reports/summary` · `/operator/reports/export` | Operator Owner | `TASK-RPT-001` (chờ duyệt), quyền `finance:read`: tổng quan (hôm nay / 7 ngày tới / tháng, chuyến sắp chạy, việc cần chú ý); báo cáo `?from&to (giờ VN, ≤ 366 ngày)&routeId&vehicleId&status` (thẻ, theo tuyến, nhân viên); CSV có audit `report.export` |
| GET / POST | `/operator/support-tickets` · `/{ticketId}` · `/{ticketId}/messages` · `/operator/support-attachments/*` | Operator Owner | `TASK-TRUST-001` (chờ duyệt), quyền `support:respond`: chỉ khiếu nại Vé Xe Nhanh đã chuyển cho nhà xe; phản hồi khách kèm tệp |
| GET / POST | `/operator/disputes` · `/{disputeId}` · `/{disputeId}/responses` | Operator Owner | Tranh chấp của nhà xe; gửi giải trình + minh chứng theo yêu cầu |
| GET / PUT / POST | `/operator/reviews` · `/{reviewId}/reply` · `/{reviewId}/report` | Operator Owner | Đánh giá đang hiển thị + giữ chờ, điểm trung bình; phản hồi; báo vi phạm (không sửa / xóa được) |
| GET / POST / PUT | `/operator/promotions` · `/{promotionId}` · `/{promotionId}/status` · `/{promotionId}/participation` · `/operator/promotion-permission` | Operator Owner | `TASK-PROM-001` (chờ duyệt), quyền `promotion:manage`: khuyến mãi của nhà xe trong giới hạn được cấp (kiểm lại khi kích hoạt → 422 `PROMOTION_GUARDRAIL`); tham gia / rời khuyến mãi nền tảng (nhà xe chịu phần giảm) |

Vehicle/SeatMap (TASK-TRN-001): quyền `vehicle:manage`. POST và PUT (thay toàn bộ) phải gửi đủ trường, thiếu → 400. Biển số chuẩn hóa (chữ hoa, bỏ khoảng trắng/`.`/`-`), trùng trong tenant → 409 `VEHICLE_PLATE_CONFLICT`. Loại xe/tiện ích phải là catalog `ACTIVE`, sai → 422 `CATALOG_ITEM_UNAVAILABLE`. SeatMap là mẫu dùng chung nhiều xe; tùy chỉnh cho một xe = tạo SeatMap mới từ bản sao rồi gắn cho xe đó. Sơ đồ đang được xe của chuyến chưa kết thúc (chưa `COMPLETED`/`CANCELLED` và chưa qua giờ đến) dùng thì `PUT` sơ đồ và đổi `seatMapId` của xe → 409 `SEAT_MAP_IN_USE` (UC-12 A3, TASK-TRN-003).

Ảnh xe (TASK-TRN-009, BR-76): quyền `vehicle:manage`. `GET` xe (list + chi tiết) trả thêm `images: [{ id, objectKey, url, position, caption }]` (`objectKey` để client gửi lại ảnh giữ nguyên ở `PUT …/images`) — `url` là địa chỉ công khai (CDN R2 public); ảnh không đổi qua `POST` / `PUT` xe. `upload-url`: `contentType` là `image/jpeg`, `image/png` hoặc `image/webp`, `sizeBytes` 1–5.242.880, sai → 400; `objectKey` do server sinh, không chứa tên file gốc; mỗi tài khoản xin tối đa 120 URL / 10 phút, vượt → 429 `VEHICLE_IMAGE_UPLOAD_RATE_LIMITED`; kho lưu ảnh hoặc bộ đếm không phản hồi → 503 `SERVICE_UNAVAILABLE`. `PUT …/images` thay toàn bộ, trả `{ images }` theo thứ tự mới: mỗi `objectKey` phải thuộc đúng xe đó và object đã tải lên hợp lệ (tồn tại, tải lên chưa quá 23 giờ, đúng loại, đúng dung lượng, đúng chữ ký định dạng), sai → 422 `VEHICLE_IMAGE_INVALID` với một thông báo chung, không nêu lý do (LLD §7); quá 8 phần tử → 422 `VEHICLE_IMAGE_LIMIT_EXCEEDED`; gửi `images: []` = xóa hết ảnh. `caption` là chú thích ngắn tùy chọn: `null` hoặc 1–60 ký tự sau khi cắt khoảng trắng, dài hơn → 400. Xe khác tenant → 404 `VEHICLE_NOT_FOUND`.

Loại xe và loại chỗ (TASK-TRN-010, BR-77, BR-78): `vehicleTypeId` trỏ một dòng catalog đã mang sẵn `form` + `class`; xe không khai riêng hai thuộc tính này. Ghế trong SeatMap có `type` ∈ `SEAT` / `BED` / `BED_DOUBLE` / `CABIN` / `CABIN_DOUBLE`, giá trị khác → 400; SeatMap (list + chi tiết) trả thêm `passengerCapacity` = số chỗ + số chỗ đôi. Không ràng buộc loại chỗ theo `form` của loại xe (xe hỗn hợp ghế + giường vẫn hợp lệ). Số tầng = số phần tử `layout.decks` (tối đa 2). `seatType` trong rule giá dùng chung 5 giá trị này, nên giường đôi / cabin đôi có giá riêng.

Bổ sung cho màn Operator OS (TASK-TRN-011): SeatMap (list + chi tiết) trả thêm `deckCount` (số tầng = số phần tử `layout.decks`) và `inUse` — `true` khi sơ đồ đang được xe của chuyến chưa kết thúc dùng, tức `PUT` sơ đồ sẽ nhận 409 `SEAT_MAP_IN_USE`. Vehicle (list + chi tiết) trả thêm `seatMapLocked` — `true` khi xe còn chuyến chưa kết thúc nên chưa đổi được `seatMapId`. "Chưa kết thúc" dùng đúng điều kiện của lỗi `SEAT_MAP_IN_USE` (chưa `COMPLETED` / `CANCELLED` và chưa qua giờ đến). Hai cờ chỉ để giao diện khóa trước và nêu lý do; server vẫn kiểm lại khi ghi và trả 409 nếu trạng thái vừa đổi. Hai cờ tính thật từ khi module chuyến có ở repo chính (`TASK-TRN-003`, 13/10/2026). Vehicle (list + chi tiết) còn trả `seatMap` — tóm tắt sơ đồ đang gắn (`id`, `name`, `seatCount`, `passengerCapacity`, `deckCount`, `inUse`, `createdAt`, `updatedAt`), hoặc `null` khi xe chưa gắn sơ đồ — để danh sách xe hiện tên sơ đồ, số chỗ, sức chứa và số tầng mà không phải ghép với danh sách SeatMap (hai danh sách phân trang riêng). `seatMapId` vẫn giữ để đối xứng với body ghi.

Trip (TASK-TRN-003): quyền `trip:manage` (Owner). Body `{ routeId, vehicleId | null, departureAt, arrivalAt, stopTimes | null, onlineSaleCutoffMinutes, note }` — POST và PUT (thay toàn bộ) gửi đủ trường; `onlineSaleCutoffMinutes` = số phút trước giờ khởi hành thì ngừng bán online (0–1440, UI gợi ý 60 — cột DB mặc định 60, AS-20); giờ ISO 8601 có múi giờ, lưu UTC; giờ đi ở tương lai, giờ đến sau giờ đi, tối đa 7 ngày. Trạng thái không nằm trong body: chỉ tạo/sửa `DRAFT`, chuyến đã rời `DRAFT` → 409 `TRIP_NOT_EDITABLE` (đổi trạng thái qua `/status`, thu hồi về nháp để sửa). Điểm dừng chép từ route, mỗi điểm trả kèm `type` (loại điểm hiện tại, như route detail), `allowPickup`, `allowDropoff` (BR-79); `stopTimes = null` thì giờ từng điểm chia [giờ đi, giờ đến] theo tỉ lệ thời gian chặng đã lưu của route, gửi `stopTimes` thì phải đủ số điểm (sai → 422 `TRIP_STOP_TIMES_INVALID`), đầu/cuối trùng giờ đi/đến, không giảm dần. Ghế chuyến sinh từ SeatMap của xe lúc gắn/đổi xe (tham chiếu `seat_code`, bắt đầu `AVAILABLE`); ghế đang `BLOCKED` được giữ theo `seat_code`, sơ đồ mới thiếu ghế đã khóa → 409 `TRIP_BLOCKED_SEATS_MISSING` (`detail` nêu mã ghế); còn ghế `HOLDING` / `BOOKED` / `CHECKED_IN` thì không sinh lại ghế → 409 `TRIP_SEAT_NOT_AVAILABLE`. Chi tiết chuyến trả thêm `onlineSaleCutoffMinutes`, `statusReason`. Route mới chọn phải `ACTIVE` của tenant (sai → 422 `ROUTE_UNAVAILABLE`); xe mới chọn phải `ACTIVE` và có SeatMap (sai → 422 `VEHICLE_UNAVAILABLE`); route/xe đang gắn được giữ dù đã ngừng dùng. Một xe không chạy hai chuyến chồng giờ trong `[departureAt, arrivalAt)` — không có thời gian đệm quay đầu, chuyến huỷ không giữ xe (BR-14, ràng buộc DB) → 409 `VEHICLE_SCHEDULE_CONFLICT`.

Trạng thái bán (TASK-TRN-006): quyền `trip:manage` (Owner). `PUT /status` body `{ status, reason | null }` (lý do 1–500 ký tự; **hủy bắt buộc**, thiếu → 400). Chuyển hợp lệ: `DRAFT → OPEN_FOR_SALE`; `OPEN_FOR_SALE ↔ LOCKED` (khóa = tạm dừng bán); `OPEN_FOR_SALE / LOCKED → DRAFT` (thu hồi nháp); `DRAFT / OPEN_FOR_SALE / LOCKED → CANCELLED` (terminal, xe rảnh ngay). Chuyển khác (kể cả sang chính trạng thái hiện tại), hoặc thu hồi nháp / hủy khi chuyến đã có ghế `BOOKED` / `CHECKED_IN` (luồng TRN-008) → 409 `TRIP_STATUS_TRANSITION_INVALID`. Request đồng thời xếp hàng theo khoá dòng chuyến: bên sau chạy trên trạng thái mới (hai lần mở bán → một 409; mở bán rồi hủy → cả hai chạy). Mở bán / mở lại kiểm BR-39, chưa đạt → 422 `TRIP_NOT_READY_FOR_SALE` kèm `reasons` gồm mọi mã: `OPERATOR_INACTIVE`, `ROUTE_INACTIVE`, `STOP_POINT_INACTIVE`, `VEHICLE_MISSING`, `VEHICLE_INACTIVE`, `SEATS_MISSING`, `FARE_MISSING` (tuyến chưa có bảng giá / `INACTIVE`), `SEAT_PRICE_MISSING` (có ghế không có rule giá), `SEAT_PRICE_ZERO` (có ghế giá 0), `SALE_WINDOW_CLOSED` (đã qua giờ khởi hành − `onlineSaleCutoffMinutes`). Chỉ kiểm lúc mở bán / mở lại; dữ liệu gốc đổi sau đó không tự khóa chuyến (Q8). Hết bán online theo giờ được so lúc search / giữ ghế, không có job đổi trạng thái. Mỗi lần đổi trạng thái lưu `statusReason` + ghi audit trong cùng transaction (lỗi / chậm quá 2 giây hoặc quá hạn transaction → 503 `SERVICE_UNAVAILABLE`, không đổi). `PUT /seats/status` body `{ seatCodes (1–100, không trùng), status: BLOCKED | AVAILABLE, note | null }`: được cả lô hoặc không; ghế đã ở trạng thái đích bỏ qua; mã ghế không thuộc chuyến → 422 `TRIP_SEAT_UNKNOWN`; ghế `HOLDING` / `BOOKED` / `CHECKED_IN` trong Postgres → 409 `TRIP_SEAT_NOT_AVAILABLE` (giữ ghế Redis của BTP-001 chưa có — BTP-001 phải tự kiểm ghế `BLOCKED` và trạng thái chuyến); chuyến không ở `DRAFT` / `OPEN_FOR_SALE` / `LOCKED` → 409 `TRIP_NOT_EDITABLE`. Khóa / mở ghế ghi audit sau commit (best-effort — Mongo lỗi không chặn khóa ghế). Không có đồng bộ tự động với hệ thống quầy / đại lý (chưa có trong tài liệu).

Fare (TASK-TRN-005): quyền `trip:manage` (Owner). `GET /operator/fares` (lọc `routeId` / `status`, cursor theo `id`, 20/tối đa 100) trả mỗi bảng giá kèm `routeName`, `ruleCount`, `minPrice` / `maxPrice` (giá thấp nhất / cao nhất trong **mọi** rule của bảng giá — kể cả rule có khung giờ đã qua, không lọc theo thời điểm; VND số nguyên đồng; `null` khi chưa có rule) và `hasDoubleSeatPrice` (có rule riêng cho `BED_DOUBLE` / `CABIN_DOUBLE`); không kèm rule. Mỗi tuyến **một** bảng giá: `POST` body `{ routeId, status, note, rules }`, tuyến phải `ACTIVE` của tenant (sai → 422 `ROUTE_UNAVAILABLE`), tuyến đã có bảng giá → 409 `FARE_ROUTE_CONFLICT`; `PUT` body `{ status, note, rules }` (không đổi tuyến). Rule `{ vehicleTypeId | null, seatType | null, validFrom | null, validTo | null, price }`: `null` = mọi loại xe / mọi loại chỗ / không khung giờ; khung giờ theo **giờ khởi hành**, là một khoảng ngày giờ `[validFrom, validTo)` (giá dịp lễ, Tết — không có khung lặp theo giờ trong ngày), gửi đủ cả hai hoặc bỏ cả hai; `price` = số nguyên đồng 0–100.000.000; tối đa 200 rule; hai rule cùng loại xe × loại chỗ mà cùng không khung giờ hoặc chồng khung giờ → 400 `FARE_RULES_OVERLAP`. Loại xe mới thêm phải `ACTIVE` trong catalog (sai → 422 `CATALOG_ITEM_UNAVAILABLE`). Giá ghế của chuyến = rule **cụ thể nhất** khớp tuyến của chuyến, loại xe đang gắn, loại chỗ của ghế và giờ khởi hành (có khung giờ > không; đúng loại xe > mọi loại; đúng loại chỗ > mọi loại); không có rule / bảng giá `INACTIVE` / chuyến chưa gắn xe → `price = null`. Sửa bảng giá không đổi giá vé đã bán (booking snapshot, BTP-002). Mỗi lần tạo/sửa ghi audit (lịch sử, BR-40) trong cùng transaction — audit lỗi hoặc chậm quá 2 giây thì không đổi giá, trả 503 `SERVICE_UNAVAILABLE` (thử lại); `PUT` không đổi gì (kể cả chỉ đảo thứ tự rule) thì không ghi DB, không thêm lịch sử.

Khung giá (`TASK-ADM-001` phần chính sách, chờ duyệt — OQ-17): `GET` / `POST` / `PUT /operator/fares*` trả thêm `bandWarnings: [{ ruleIndex, price, bandId, bandName, minPrice, maxPrice, effectiveFrom, effectiveTo, message }]` — quy tắc nằm ngoài khung giá còn hiệu lực / sắp tới (quy tắc có khung giờ chỉ xét khi giao thời gian); **không chặn lưu**; lưu giá ngoài khung ghi audit `fare.band_warning`.

Route/StopPoint (TASK-TRN-002): quyền `route:manage` (Owner). Route gồm 2–25 điểm theo thứ tự, mỗi điểm là catalog `ACTIVE` **hoặc** điểm riêng `ACTIVE` của tenant, không lặp; vai trò `ORIGIN`/`INTERMEDIATE`/`DESTINATION` suy từ vị trí. Khoảng cách/thời gian tính lúc tạo/đổi chuỗi toạ độ và lưu DB (ADR-027 cache-once); Goong lỗi → 503 `ROUTING_PROVIDER_UNAVAILABLE`, không lưu gì. Điểm không dùng được / khác tenant → 422 `STOP_POINT_UNAVAILABLE`. Admin duyệt đề xuất ở `/admin/stop-point-proposals` (ADM-004).

Điểm dừng — thiết kế lại (TASK-TRN-012, BR-38, BR-79, BR-81): điểm riêng chỉ nhận `type` ∈ `OFFICE` / `REST_STOP`, khác → 422 `STOP_POINT_TYPE_NOT_ALLOWED`. `status` nhà xe đặt được là `ACTIVE` / `INACTIVE`; `SUSPENDED` chỉ Admin đặt (body gửi `SUSPENDED` → 400), response kèm `suspensionReason`; sửa điểm đang bị khóa → 409 `STOP_POINT_SUSPENDED` dù body không đổi gì; điểm bị khóa không gắn mới được vào route (422 `STOP_POINT_UNAVAILABLE`), route đã có điểm đó vẫn giữ. List điểm riêng lọc `status` / `type` / `provinceId`; `q` (tối đa 100 ký tự, dùng chung cho `/catalog/stop-points`) khớp một phần tên hoặc địa chỉ, không phân biệt dấu và hoa / thường — gõ "ben xe mien dong" ra "Bến xe Miền Đông"; `routeCount` = số route của nhà xe đang có điểm đó, tính cả route ngừng dùng. Đề xuất chỉ nhận `type` ∈ `BUS_STATION` / `PICKUP_POINT` và thêm `legalBasis` (căn cứ công bố, 1–300 ký tự). Body route: mỗi điểm thêm `allowPickup`, `allowDropoff` (bắt buộc, thiếu → 400) — điểm đầu `true` / `false`, điểm cuối `false` / `true`, điểm giữa do nhà xe chọn (ít nhất một quyền), trạm dừng nghỉ luôn `false` / `false` và không đứng đầu / cuối; sai → 422 `ROUTE_STOP_PICKUP_DROPOFF_INVALID`. Hai đầu route không phải bến xe không bị chặn ở v1; giao diện tự cảnh báo từ loại điểm (OQ-24). Response route trả lại hai cờ và `type` của từng điểm.

Username Employee (create/PATCH) bắt buộc `nv.` + 2–61 ký tự `[a-z0-9._-]` (Owner đặt phần sau tiền tố); sai → 400 validation. Provisioning Owner từ chối username bắt đầu bằng `nv.` (không phân biệt hoa/thường). DB CHECK giữ cả hai (04 DB §7).

`POST /operator/employees` và password-reset áp giới hạn email mật khẩu tạm: 30/24h toàn hệ thống, 10/24h/tenant, 5/24h/actor, cùng Employee reset tối đa một lần/giờ. Vượt ngưỡng trả 429 `ACCOUNT_TEMP_EMAIL_RATE_LIMITED`; Redis lỗi thì fail-closed 503. Reset giữ nguyên `status` kỷ luật. Khi create đã ghi DB nhưng delivery lỗi, 503 `detail` chứa `employeeId`; Owner dùng `GET /operator/employees` và password-reset để phục hồi, không create lại. Các thao tác nhạy cảm giữ Q8 recent re-auth bằng mật khẩu hoặc MFA, chưa bắt buộc TOTP riêng.

### 7.4. Employee operations

| Method | Path                                  | Actor    | Mục đích                           |
| ------ | ------------------------------------- | -------- | ---------------------------------- |
| GET    | `/employee/assignments`               | Employee | Xem nhiệm vụ/chuyến được phân công |
| GET    | `/employee/trips/{tripId}/passengers` | Employee | Xem danh sách hành khách           |
| POST   | `/employee/tickets/verify`            | Employee | Xác thực QR/mã vé                  |
| POST   | `/employee/check-ins`                 | Employee | Check-in hành khách                |
| POST   | `/employee/trips/{tripId}/status`     | Employee | Cập nhật trạng thái chuyến         |
| POST   | `/employee/incidents`                 | Employee | Báo cáo sự cố                      |

Hiện thực (`TASK-EMP-002` backend, chờ duyệt — `EMP-002-todo.md`): soát vé quyền `checkin:perform` (mọi role Employee, chỉ chuyến được phân công); `GET /employee/assignments?from&to`; `GET …/passengers` (số điện thoại đã che); `POST /employee/tickets/verify { tripId, code }` (QR hoặc mã vé) → `OK` / `WRONG_TRIP` / `ALREADY_CHECKED_IN` / `CANCELLED` / `REFUNDED` / `NO_SHOW` / `USED`; `POST /employee/check-ins { tripId, code, status: CHECKED_IN | NO_SHOW }` (quét lại 409); `POST …/status { status, note }` quyền `trip:operate` (chỉ tài xế) theo thứ tự `BOARDING` → `DEPARTED` → `IN_PROGRESS` → `COMPLETED`. `/employee/incidents` chưa làm.

### 7.5. Admin

Thao tác phức tạp dùng `POST` + sub-resource (ADR-012).

| Method       | Path                                        | Actor | Mục đích                                 |
| ------------ | ------------------------------------------- | ----- | ---------------------------------------- |
| GET          | `/admin/dashboard`                          | Admin | Dashboard tổng quan — **chưa làm**; màn Tổng quan hiện dùng các API danh sách sẵn có (hồ sơ chờ duyệt, đề xuất điểm dừng, yêu cầu đổi tài khoản, nhà xe, trạng thái hệ thống) |
| GET          | `/admin/operators`                          | Admin | Nhà xe đã duyệt (chờ duyệt — `ADM-001-accounts-todo.md`): quyền `user:manage`; tìm `q` (tên / slug / chủ nhà xe), lọc `status`, `bankChange=PENDING`; kèm chủ nhà xe, số tuyến / chuyến mở bán, `bankChangePending`, `total` |
| POST         | `/admin/operators/{id}/suspend` · `…/unsuspend` | Admin | Tạm khóa `{ reason }` / mở khóa — xác nhận lại danh tính; thu hồi mọi phiên của nhà xe, email chủ nhà xe; sai trạng thái → 409 `OPERATOR_STATE_INVALID` |
| GET          | `/admin/operators/{id}/bank-account-change` | Admin | `TASK-OPR-001b`: quyền `kyc:review`; yêu cầu đổi tài khoản đang chờ + tài khoản đang dùng (**số đầy đủ** để đối chiếu, mỗi lần xem ghi audit); không có → 404 `BANK_ACCOUNT_CHANGE_NOT_FOUND` |
| POST         | `/admin/operators/{id}/bank-account-change/approve` · `…/reject` | Admin | `{ changeId }` / `{ changeId, reason }` — xác nhận lại danh tính; duyệt: tài khoản cũ → `REPLACED`, mới → `VERIFIED`; audit + email chủ nhà xe |
| GET          | `/admin/passengers` · `POST /admin/passengers/{id}/lock` · `…/unlock` | Admin | Hành khách (quyền `user:manage`): tìm theo email / tên, lọc trạng thái; khóa `{ reason }` (thu hồi phiên) / mở khóa — xác nhận lại danh tính |
| GET          | `/admin/employees`                          | Admin | Nhân viên mọi nhà xe, **chỉ xem** (lọc nhà xe / vai trò) |
| GET / POST   | `/admin/platform-accounts`                  | Admin | Tài khoản quản trị; cấp mới `{ username, email, role }` (mật khẩu tạm qua email, phải đổi + bật TOTP lần đầu; gửi lỗi → `credentialDeliveryPending`) — xác nhận lại danh tính |
| POST         | `/admin/platform-accounts/{id}/reset-password` · `…/reset-mfa` · `…/lock` · `…/unlock` | Admin | Cấp lại mật khẩu / đặt lại 2FA (kèm mật khẩu tạm mới) / khóa `{ reason }` / mở khóa; không thao tác trên chính mình (409 `PLATFORM_ACCOUNT_SELF_ACTION`), không khóa quản trị viên cuối (409 `PLATFORM_ACCOUNT_LAST_ADMIN`) |
| PUT          | `/admin/platform-accounts/{id}/permissions` | Admin (`access:manage`) | Phân quyền (FR-IAM-07, `TASK-IAM-007`, chờ duyệt): `{ permissions, reason }` + xác nhận lại danh tính. 400 `PERMISSION_NOT_ASSIGNABLE` (ngoài trần vai trò), 403 `PERMISSION_GRANT_FORBIDDEN` (thêm / bớt quyền mình không có), 409 `PLATFORM_ACCOUNT_SELF_ACTION` / `PLATFORM_ACCOUNT_LAST_ADMIN` (phải còn ≥ 1 tài khoản hoạt động có `access:manage`). Mọi route `/admin/platform-accounts*` đổi từ `user:manage` sang `access:manage`; danh sách trả thêm `permissions` từng dòng + `grantable` theo vai trò; cấp mới bắt buộc `permissions` |
| GET          | `/admin/system/integrations` · `/admin/system/jobs` | Admin | Trang Tích hợp & hệ thống **chỉ đọc** (quyền `system:read`): kiểm tra thật Postgres / Redis / Mongo / BullMQ / kho lưu trữ, cấu hình email / bản đồ (không gửi thử, không trả khóa); tác vụ nền BullMQ (lịch, lần chạy gần nhất, lỗi) |
| GET          | `/admin/operator-applications`              | Admin | Danh sách hồ sơ đăng ký nhà xe (lọc trạng thái). `TASK-ADM-001`: chỉ hồ sơ đã gửi duyệt, mới gửi trước, cursor `{submittedAt}_{id}`; query `status`, `q` (mã / tên / email / mã số thuế), `submittedSince`, `duplicatesOnly`, `limit` ≤ 50; mỗi dòng kèm `duplicates` (`CONTACT_EMAIL` / `TAX_CODE` / `BANK_ACCOUNT`) |
| GET          | `/admin/operator-applications/{applicationId}` | Admin | Xem hồ sơ + giấy tờ KYC (presigned, audit). `TASK-ADM-001`: giấy tờ chỉ metadata, số tài khoản che 4 số cuối, hồ sơ trùng (≤ 10 / loại), `operator` (khi đã duyệt), `history` (`null` khi audit không đọc được); nháp / id lạ → 404 `OPERATOR_APPLICATION_NOT_FOUND` |
| POST         | `/admin/operator-applications/{applicationId}/documents/{type}/download-url` | Admin | `TASK-ADM-001` (chờ duyệt): URL xem một giấy tờ, hạn 5 phút, mỗi lần cấp ghi audit — thay cho ký URL mọi giấy tờ ở `GET` chi tiết |
| POST         | `/admin/operator-applications/{applicationId}/approve` | Admin | Duyệt: nhập slug + username Owner → tạo Operator + Owner mật khẩu tạm (`Idempotency-Key`, TOTP, audited). `TASK-ADM-001`: body `{ operatorSlug, ownerUsername }`; response `{ applicationCode, status, operatorId, operatorSlug, ownerUsername, credentialDeliveryPending }`; 409 `OPERATOR_SLUG_CONFLICT` / `OPERATOR_APPLICATION_INVALID_STATE` |
| POST         | `/admin/operator-applications/{applicationId}/request-info` | Admin | Yêu cầu bổ sung (lý do) → `NEEDS_INFO` + link mới. `TASK-ADM-001`: body `{ reason }` 3–500 ký tự, không cần xác nhận lại danh tính; response `{ applicationCode, status, emailDelivered }` |
| POST         | `/admin/operator-applications/{applicationId}/reject` | Admin | Từ chối (lý do) → `REJECTED`, thu hồi link. `TASK-ADM-001`: như `request-info` + cần xác nhận lại danh tính |
| POST         | `/admin/operator-applications/{applicationId}/resend-owner-credentials` | Admin | `TASK-ADM-001` (chờ duyệt): gửi lại mật khẩu tạm khi lần gửi lúc duyệt lỗi (UC-23 A4), hạn mức IAM-005, cần xác nhận lại danh tính |
| GET/POST/PUT | `/admin/catalog/*`                          | Admin | Catalog chuẩn (tỉnh, phường, loại xe, tiện ích); điểm dừng ở `/admin/stop-points`. `TASK-ADM-001` (chờ duyệt): quyền `catalog:manage`; mọi thay đổi audit trong transaction (audit lỗi → 503, không lưu); trùng mã → 409 `CATALOG_CODE_CONFLICT`; id lạ → 404 `CATALOG_ITEM_NOT_FOUND`; không xóa |
| GET          | `/admin/catalog/provinces` · `/admin/catalog/wards` | Admin | `TASK-ADM-001`: mọi trạng thái, lọc `status` (+ `provinceId` với phường), tìm `q` (mã bắt đầu bằng / tên chứa), xếp theo mã, cursor = mã dòng cuối, `limit` ≤ 100; kèm `wardCount` / `provinceName`, `stopPointCount`, `total` |
| GET          | `/admin/catalog/vehicle-types` · `/admin/catalog/amenities` | Admin | `TASK-ADM-001`: mọi mục (không phân trang), lọc `status`; loại xe kèm `vehicleCount`, `operatorCount`, `fareRuleCount`; tiện ích kèm `vehicleCount` |
| POST / PUT   | `/admin/catalog/{kind}`, `/admin/catalog/{kind}/{id}` | Admin | `TASK-ADM-001`: thêm — tỉnh `{ code (2 số), name }`, phường `{ provinceId, code (5 số), name }`, loại xe `{ code, name, description, form, class }`, tiện ích `{ code, name }` (mã loại xe / tiện ích chữ hoa không dấu, tự viết hoa); sửa — chỉ `name` (+ `description` với loại xe); mã, tỉnh của phường, dạng chỗ / hạng xe không đổi |
| POST         | `/admin/catalog/{kind}/{id}/deactivate` · `…/activate` | Admin | `TASK-ADM-001`: ngừng dùng (body `{ reason }` 3–500 ký tự, vào audit) / dùng lại; 204; sai trạng thái → 409 `CATALOG_STATE_INVALID`. Mục ngừng dùng biến mất khỏi `/catalog/*` (§7.6), dữ liệu đang dùng giữ nguyên |
| GET          | `/admin/policies/{type}`                    | Admin | `TASK-ADM-001` phần chính sách (chờ duyệt): quyền `finance:configure`; `type` ∈ `CANCELLATION` / `SEAT_HOLD` / `PAYOUT`, `?operatorId=` (chỉ hủy / hoàn tiền) — lịch sử phiên bản mới nhất trước kèm `state` (Nháp / Đã lên lịch / Đang áp dụng / Hết hiệu lực / Đã hủy), số nhà xe đang hoạt động, nhà xe có chính sách riêng |
| POST         | `/admin/policies/{type}/versions`           | Admin | Tạo nháp `{ operatorId \| null, rules, description, effectiveFrom \| null }` (rules theo loại: mốc `{ minHoursBefore, refundPercent }` phải có mốc 0 giờ, không trùng, sát giờ không hoàn cao hơn; `{ holdMinutes 5–30 }`; `{ delayDays 1–30, channel: BANK_TRANSFER, manualConfirmation: true, minimumAmount: null }`) |
| GET / PUT    | `/admin/policy-versions/{id}`               | Admin | Xem / sửa nháp; đã kích hoạt / hủy → 409 `POLICY_VERSION_LOCKED` |
| POST         | `/admin/policy-versions/{id}/publish` · `…/cancel` | Admin | Kích hoạt `{ changeReason }` (hiệu lực phải ở tương lai → 422 `POLICY_EFFECTIVE_INVALID`; phạm vi đã có bản chờ hiệu lực → 409 `POLICY_SCHEDULE_CONFLICT`) / hủy nháp hoặc bản đã lên lịch `{ reason }`; cả hai **xác nhận lại danh tính**, audited |
| GET / POST   | `/admin/fare-bands` · `/admin/fare-bands/{id}/cancel` | Admin | Khung giá trần / sàn theo dịp `{ name, minPrice \| null, maxPrice \| null, effectiveFrom, effectiveTo, message, reason }` — chỉ cảnh báo nhà xe (OQ-17); tạo / hủy cần xác nhận lại danh tính |
| GET / POST / PUT | `/admin/commission-rules` · `/{id}` · `/{id}/cancel` | Admin | Hoa hồng mặc định (5%, chưa sửa trên giao diện) + mức riêng `{ operatorId, rateBps (phần vạn), effectiveFrom, effectiveTo \| null, reason }`: bắt đầu ở tương lai, không chồng mức khác của nhà xe (409 `COMMISSION_RULE_OVERLAP`), mức đã bắt đầu chỉ đổi ngày kết thúc (422 `COMMISSION_RULE_LOCKED`); ngừng = hủy (chưa bắt đầu) / kết thúc ngay; xác nhận lại danh tính |
| GET          | `/admin/payments`                           | Admin | Giám sát payment                         |
| POST         | `/admin/refunds/{refundId}/decision`        | Admin | Refund thủ công (audited)                |
| POST         | `/admin/escrow/{ledgerId}/adjust`           | Admin | Điều chỉnh ledger (audited)              |
| POST         | `/admin/payouts/{payoutId}/confirm`         | Admin | Confirm payout + nhập bank ref (ADR-022) |
| GET/PUT      | `/admin/disputes`                           | Admin | Dispute workflow (final arbiter)         |
| GET          | `/admin/overview` · `/admin/reports/summary` · `/admin/reports/export` | Admin | `TASK-RPT-002` (chờ duyệt), quyền `payment:monitor` (PlatformAdmin + PlatformSupport): tổng quan (so kỳ trước, việc cần xử lý, sổ giữ hộ, GMV theo ngày, thao tác gần đây); báo cáo `?from&to&operatorId&provider` (theo nhà xe, phương thức thanh toán); CSV có audit |
| GET / PATCH / POST | `/admin/support-tickets` · `/{ticketId}` · `/{ticketId}/messages` · `/{ticketId}/status` · `/{ticketId}/attachments/upload-url` · `/admin/support-assignees` · `/admin/support-attachments/{id}/download-url` | Admin | `TASK-TRUST-001` (chờ duyệt), quyền `support:manage`: lọc trạng thái / danh mục / nhà xe / người phụ trách (`assigneeId` = UUID hoặc `none`) / mã; phân loại `{ category, priority, handler, assigneeId }` (bên xử lý = nhà xe → chuyển nhà xe + email); trả lời / yêu cầu bổ sung; giải quyết / đóng |
| GET / POST   | `/admin/support-tickets/{ticketId}/escalate` · `/admin/disputes` · `/{disputeId}` · `/{disputeId}/evidence-requests` · `/{disputeId}/status` · `/{disputeId}/attachments/upload-url` | Admin | Hiện thực dispute workflow (thay `GET/PUT /admin/disputes`): chuyển khiếu nại thành tranh chấp (lần hai 409), yêu cầu minh chứng (hạn ≤ 30 ngày), đổi trạng thái |
| POST         | `/admin/disputes/{disputeId}/decision`      | Admin | Quyền `dispute:decide` (chỉ PlatformAdmin) + xác nhận lại danh tính: `{ decision: REFUND \| NO_REFUND \| OTHER, amount, reason }`; hoàn vượt phần đã trả còn lại → 422; quyết định lần hai 409 |
| GET / POST   | `/admin/reviews` · `/{reviewId}/moderation` | Admin | Quyền `content:moderate`: lọc + tín hiệu "Cần xem xét"; giữ chờ / ẩn (lý do bắt buộc) / hiển thị lại (audit) |
| GET / POST / PUT | `/admin/promotions` · `/{promotionId}` · `/{promotionId}/status` · `/admin/promotion-permissions` · `/{operatorId}` | Admin | `TASK-PROM-001` (chờ duyệt), quyền `promotion:configure` (chỉ PlatformAdmin): khuyến mãi nền tảng (sửa khi chưa có đơn dùng — BR-47), khuyến mãi của các nhà xe (tạm dừng / kết thúc), quyền + giới hạn từng nhà xe |
| GET          | `/admin/audit-logs`                         | Admin | Truy xuất audit (Mongo). `TASK-ADM-002` phần audit (chờ duyệt): quyền `audit:read`; mới nhất trước, cursor `{createdAt}_{ObjectId}`, `limit` ≤ 100, `total`; lọc `from` / `to`, `actorType` (`PLATFORM` / `OPERATOR` / `EMPLOYEE` / `PASSENGER` / `SYSTEM`), `module` (nhóm tiền tố hành động), `result` (`SUCCESS` / `FAILURE` — suy từ tên hành động); `q` = đúng mã đối tượng hoặc tài khoản (`platform/x`, `slug/user`, `slug/`, một phần tên, email hành khách); mỗi dòng kèm tên đăng nhập người thực hiện, nhà xe, lý do |
| GET          | `/admin/audit-logs/{logId}`                 | Admin | `TASK-ADM-002` (chờ duyệt): một bản ghi + `before` / `after` đã che ở server (email, điện thoại, số tài khoản, IP, bí mật), IP đã che + thiết bị (nếu sự kiện có ghi), `requestId`, `related` (tối đa 20 bản ghi cùng đối tượng); mỗi lượt xem ghi audit `audit.event.view`; không có → 404 `AUDIT_LOG_NOT_FOUND`; Mongo không phản hồi → 503 |
| GET/PUT      | `/admin/loyalty/policy`                     | Admin | Tham số loyalty theo phiên bản + effective date (audited). **Hiện thực (chờ duyệt): dùng API chính sách chung** `/admin/policies/LOYALTY`, `/admin/policy-versions/*` (quyền `finance:configure`) |
| GET          | `/admin/loyalty/accounts/{userId}`          | Admin | Tài khoản thành viên + giao dịch điểm. **Hiện thực (`TASK-LOY-001`, chờ duyệt), quyền `loyalty:manage` (chỉ PlatformAdmin):** `GET /admin/loyalty/accounts?email=` (thẻ thành viên: hạng, điểm khả dụng, tích 12 tháng, hạng kế; 404 `LOYALTY_MEMBER_NOT_FOUND`) + `GET /admin/loyalty/accounts/{userId}/transactions?offset&limit` (sổ điểm, `total`) |
| POST         | `/admin/loyalty/accounts/{userId}/adjustments` | Admin | Điều chỉnh điểm thủ công (lý do, audited). Hiện thực: `{ direction: CREDIT \| DEBIT, points, reason }` + `Idempotency-Key` + xác nhận lại danh tính; trừ quá số dư → 409 `LOYALTY_INSUFFICIENT_POINTS`; khóa đã dùng cho thành viên khác → 409 `LOYALTY_REQUEST_CONFLICT` |
| GET          | `/admin/loyalty/reports`                    | Admin | Điểm phát hành / đổi / hết hạn, giảm Platform chịu theo kỳ. Hiện thực: `?year&quarter&tier` → tháng trong quý (giờ VN) + tổng; voucher / phần giảm = 0 tới khi có ví voucher |
| GET/POST/PUT | `/admin/articles`                           | Admin | CRUD bài viết (`DRAFT`). `TASK-CNT-001` (chờ duyệt): quyền `content:manage`; lọc trạng thái / chuyên mục, tìm; trùng slug → 409 |
| POST         | `/admin/articles/{articleId}/publish`       | Admin | Xuất bản ngay hoặc hẹn giờ qua `publishedAt` (audited); chưa có nội dung → 422 `ARTICLE_INCOMPLETE`; **chưa revalidate ISR** (Marketplace chưa dựng) |
| POST         | `/admin/articles/{articleId}/archive`       | Admin | Gỡ bài (audited)                         |
| POST         | `/admin/articles/images`                    | Admin | Presigned upload ảnh (R2 public)         |
| GET/POST/PUT | `/admin/article-categories`                 | Admin | Chuyên mục bài viết                      |
| GET/POST     | `/admin/content-pages`                      | Admin | `TASK-ADM-003` (chờ duyệt), quyền `content:moderate`: danh sách (lọc `type`, `status`, `q`; `total`) / tạo bản nháp `{ type, placement, title, slug \| null, bodyMarkdown, imageKey \| null, linkUrl \| null, displayOrder }` (ràng buộc theo loại) |
| GET/PUT      | `/admin/content-pages/{id}`                 | Admin | Chi tiết / thay toàn bộ (không đổi loại → 422 `CONTENT_PAGE_TYPE_IMMUTABLE`; trùng đường dẫn 409) |
| PUT          | `/admin/content-pages/{id}/status`          | Admin | `{ status: PUBLISHED \| DRAFT }` hiển thị / ẩn; lặp → 409 `CONTENT_PAGE_STATE_INVALID` |
| POST         | `/admin/content-pages/image-upload-url`     | Admin | Presigned upload ảnh banner (R2 public, 5 phút) |
| GET          | `/admin/vehicle-images`                     | Admin | Ảnh phương tiện để rà soát (lọc `operatorId`, mới nhất trước, cursor) `TASK-ADM-003` phần ảnh xe (chờ duyệt): quyền `content:moderate`; lọc thêm `uploadedSince`; cursor `{createdAt}_{id}`, `limit` ≤ 48; mỗi ảnh kèm URL, chú thích, vị trí, `isCover`, biển số, tên nhà xe; trả `total` + `operators` (nhà xe đang có ảnh) |
| POST         | `/admin/vehicle-images/{imageId}/remove`    | Admin | Gỡ ảnh vi phạm (lý do bắt buộc, audited); không tồn tại → 404 `VEHICLE_IMAGE_NOT_FOUND` `TASK-ADM-003`: body `{ reason }` 3–500 ký tự; 204; xóa dòng + object, audit trong transaction (lỗi → 503, ảnh còn nguyên), email báo chủ nhà xe sau commit |
| GET/POST     | `/admin/stop-points`                        | Admin | Điểm dừng dùng chung: list (lọc `type`, `provinceId`, `status`, tìm `q`; kèm `routeCount`) / tạo — `BUS_STATION`, `PICKUP_POINT` bắt buộc `legalBasis` (audited) `TASK-ADM-004`: quyền `catalog:manage`; list mọi trạng thái, mới tạo trước, cursor `{createdAt}_{id}`, kèm `provinceName`, `legalBasis`, `total`; body = mọi trường + `legalBasis` (null với trạm dừng nghỉ) + `status` |
| GET/PUT      | `/admin/stop-points/{stopPointId}`          | Admin | Xem / sửa / ngừng dùng điểm dùng chung (audited); không xóa |
| GET          | `/admin/stop-point-proposals`               | Admin | Đề xuất của nhà xe (lọc `status`, `operatorId`); kèm cảnh báo điểm dùng chung ở gần `TASK-ADM-004`: lọc thêm `type`; mỗi đề xuất kèm `operatorName` + `nearby` (cùng loại, đang hoạt động, ≤ 200 m, có tọa độ, khoảng cách, số tuyến); kèm `total` |
| GET          | `/admin/stop-point-proposals/{proposalId}`  | Admin | `TASK-ADM-004` (chờ duyệt): một đề xuất, cùng dạng phần tử của danh sách (trang xem xét mở bằng địa chỉ) |
| POST         | `/admin/stop-point-proposals/{proposalId}/approve` | Admin | Duyệt (được chỉnh tên, địa chỉ, tọa độ) → tạo điểm dùng chung (audited); không còn `PENDING` → 409 `TASK-ADM-004`: body = tên, loại (`BUS_STATION` / `PICKUP_POINT`), địa chỉ, tỉnh / phường, tọa độ, ghi chú, căn cứ (bắt buộc); 409 `STOP_POINT_PROPOSAL_STATE_INVALID` |
| POST         | `/admin/stop-point-proposals/{proposalId}/reject` | Admin | Từ chối, lý do bắt buộc → `REJECTED` (audited) |
| GET          | `/admin/operator-stop-points`               | Admin | Điểm dừng riêng của mọi nhà xe (lọc `operatorId`, `type`, `provinceId`, `status`, tìm `q`; kèm `routeCount`) |
| POST         | `/admin/operator-stop-points/{stopPointId}/suspend` | Admin | Khóa điểm riêng, lý do bắt buộc → `SUSPENDED` (audited, thông báo nhà xe) `TASK-ADM-004`: lý do 1–500 ký tự; đang khóa → 409 `STOP_POINT_STATE_INVALID`; duyệt / từ chối / khóa / mở khóa gửi email cho chủ nhà xe sau commit (lỗi không ảnh hưởng phản hồi) |
| POST         | `/admin/operator-stop-points/{stopPointId}/unsuspend` | Admin | Mở khóa → `ACTIVE` (audited) |

### 7.6. Catalog (đọc công khai)

Dữ liệu chuẩn Platform (DB §5.2 nhóm Catalog) cho Marketplace search và Operator OS cấu hình xe/tuyến. Không cần token; chỉ trả item `ACTIVE` và field công khai (Security §6 "Public catalog"). Ghi/vô hiệu hóa catalog vẫn qua `/admin/catalog/*` (§7.5).

| Method | Path                     | Actor                   | Mục đích                                                                                   |
| ------ | ------------------------ | ----------------------- | ------------------------------------------------------------------------------------------ |
| GET    | `/catalog/provinces`     | Guest, User, Operator   | Danh sách tỉnh / thành                                                                     |
| GET    | `/catalog/wards`         | Guest, User, Operator   | Phường / xã của một tỉnh (`provinceId` bắt buộc)                                           |
| GET    | `/catalog/stop-points`   | Guest, User, Operator   | Điểm dừng dùng chung (bến xe, điểm dừng đón trả, trạm dừng nghỉ); lọc `provinceId`, `wardId`, `type`, tìm `q`; cursor mặc định 20 / tối đa 100 |
| GET    | `/catalog/vehicle-types` | Guest, User, Operator   | Loại phương tiện chuẩn; mỗi item kèm `form` (`SEATER` / `SLEEPER` / `CABIN`) và `class` (`STANDARD` / `LIMOUSINE`) — BR-77 |
| GET    | `/catalog/amenities`     | Guest, User, Operator   | Tiện ích chuẩn                                                                             |
| GET    | `/catalog/popular-routes` | Guest, User | Chờ duyệt (26/10/2026): tuyến phổ biến cho trang chủ — gộp tuyến `ACTIVE` của nhà xe `ACTIVE` theo **cặp tỉnh** điểm đầu → điểm cuối, chỉ tuyến có chuyến `OPEN_FOR_SALE` đã gắn xe trong 30 ngày tới; xếp theo vé đã thanh toán 30 ngày qua, rồi số chuyến sắp chạy. Mỗi mục: tỉnh đi / đến (tên ngắn), quãng đường + thời gian ngắn nhất, `minPrice` (giá thấp nhất của bảng giá đang áp dụng, VND, có thể `null`), `vehicleTypeNames`, `nextDepartureAt`, `operatorCount`, `averageRating` (review `VISIBLE`, `null` khi chưa có) + `reviewCount`. `limit` mặc định 7 / tối đa 20 |
| GET    | `/catalog/featured-operators` | Guest, User | Chờ duyệt (26/10/2026): nhà xe tiêu biểu — nhà xe `ACTIVE` có chuyến mở bán 30 ngày tới, xếp theo số review `VISIBLE`, rồi điểm trung bình, rồi tên; mỗi mục kèm tối đa 6 cặp tỉnh đang mở bán (cho tab "Theo nhà xe"). Không trả logo (schema chưa có). `limit` mặc định 5 / tối đa 20 |

---

## 8. Idempotency

| API                                | Idempotency bắt buộc | Key                                                  |
| ---------------------------------- | -------------------- | ---------------------------------------------------- |
| `POST /seat-holds`                 | Có                   | actor/session + trip + seats hoặc client key         |
| `POST /bookings`                   | Có                   | SeatHold id + client key                             |
| `POST /bookings/{id}/payments`     | Có                   | booking id + method + client key                     |
| Payment callback (webhook)         | Có                   | dedup unique `(provider, provider_txn_id)` (ADR-019) |
| Refund request                     | Có                   | booking/payment/refund id + reason                   |
| Ticket issuance                    | Có                   | booking item id                                      |
| `POST /admin/payouts/{id}/confirm` | Có                   | `(operator_id, period)`                              |
| `POST /admin/operator-applications/{applicationId}/approve` | Có | `Idempotency-Key` + mỗi hồ sơ tối đa một Operator (unique `operator_applications.operator_id`). `TASK-ADM-001`: khóa 8–128 ký tự `[A-Za-z0-9_-]` (thiếu / sai → 400 `VALIDATION_FAILED`), lưu ở `approval_idempotency_key`; lặp cùng khóa → trả lại kết quả, khác khóa sau khi đã duyệt → 409 |
| `POST /me/loyalty/redemptions`     | Có                   | `Idempotency-Key` bắt buộc → unique trong sổ điểm   |
| `POST /admin/loyalty/accounts/{userId}/adjustments` | Có  | `Idempotency-Key` bắt buộc                          |
| Loyalty earn / reversal (job)      | Có                   | `earn:{bookingId}` / `reversal:{refundId}` — hiện thực `EARN:{bookingId}` / `REVERSAL:{refundId}` (chờ duyệt) |
| Point expiry (job)                 | Có                   | `expire:{accountId}:{date}` — hiện thực `EXPIRE:{accountId}:{lô tới hạn mới nhất}` + mốc `expired_through` (chờ duyệt) |

---

## 9. Pagination, filtering, sorting

| Quy ước    | Giá trị nháp                                                        |
| ---------- | ------------------------------------------------------------------- |
| Pagination | `page`, `limit` hoặc cursor cho dữ liệu lớn (per-endpoint chốt LLD) |
| Sorting    | `sortBy`, `sortOrder`                                               |
| Filtering  | Query params theo từng endpoint (Zod schema)                        |
| Max limit  | TBD (chốt LLD)                                                      |
| Export lớn | Async job (BullMQ), không trả file lớn trực tiếp nếu vượt ngưỡng    |

---

## 10. Webhook và realtime API

### 10.1. Webhook inbound

| Loại                   | Path                           | Ghi chú                                                                                                                                 |
| ---------------------- | ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------- |
| Payment callback (IPN) | `/webhooks/payment/{provider}` | `provider` ∈ {vnpay, momo}; verify HMAC (VNPay SHA512 / MoMo SHA256) + timestamp + nonce + dedup; xử lý async BullMQ (ADR-012, ADR-019) |
| Refund callback        | `/webhooks/refund/{provider}`  | Provider-dependent; verify HMAC + idempotent                                                                                            |

### 10.2. Realtime event

Transport realtime (Socket.IO / SSE / polling) **chưa thuộc 15-layer selection** — xem HLD-OQ-11; v1 fallback polling.

| Event                         | Người nhận            |
| ----------------------------- | --------------------- |
| `booking.updated`             | User, Operator        |
| `trip.operation.updated`      | Operator, Admin       |
| `employee.assignment.updated` | Employee              |
| `dispute.updated`             | User, Operator, Admin |

---

## 11. Open Questions / TBD

| ID        | Câu hỏi                                              | Tác động           | Trạng thái                                                                                     |
| --------- | ---------------------------------------------------- | ------------------ | ---------------------------------------------------------------------------------------------- |
| API-OQ-01 | Auth token lưu/cấp qua Bearer hay cookie cho web?    | FE/API/Security    | **Đóng theo ADR-017 + TASK-OQ-05 (25/09/2026)**: Web Operator/Admin opt-in cookie qua `X-Auth-Transport`; Mobile mặc định giữ JSON/Bearer; contract §7.1.1–§7.1.2 |
| API-OQ-02 | Guest checkout có nằm trong v1 không?                | Booking API        | **Đóng theo SRS/GLOSSARY**: Guest có guest session cho hold/book/pay/lookup                    |
| API-OQ-03 | Provider payment đầu tiên là gì?                     | Webhook contract   | **Đóng theo ADR-019**: VNPay (HMAC-SHA512) + MoMo (HMAC-SHA256)                                |
| API-OQ-04 | Chuẩn pagination dùng page hay cursor cho từng list? | API consistency    | Mở; chốt per-endpoint khi LLD                                                                  |
| API-OQ-05 | Error code chính thức có cần versioning không?       | FE/Mobile handling | Mở; cơ chế deprecation OpenAPI (`deprecated` + header) đã có (ADR-012); danh mục code chốt LLD |

---

### Quy ước mã trong API Spec

- `API-OQ-NN`: Câu hỏi mở của API Specification.
