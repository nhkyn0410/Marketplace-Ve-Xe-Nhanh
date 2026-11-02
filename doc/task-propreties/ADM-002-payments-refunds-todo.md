# TASK-ADM-002 — Todo: Thanh toán & hoàn tiền phía Admin (giám sát, cần đối soát, xử lý hoàn tiền thất bại)

> **Khanh (17/10/2026):** lõi đặt vé theo lát dọc (SRS / ADR); không làm giao diện khách hàng.
> Nguồn: FR-ADM-10, FR-BTP-17, UC-27 (bước 8, A4), UC-32 (bước 8), UC-08 A5, Security §8 "Refund thủ công", NFR-AUDIT-04, Figma ADM-07a–d. API / cột / mã lỗi bổ sung AI tự đề xuất, **chờ Khanh duyệt**.
> **Nhánh:** `TASK-TRN-004` (làm tiếp), chưa commit. Thay khung giao diện trống của màn này (`ADM-system-shells-todo.md`).

## Trạng thái (18/10/2026) — 🔨 **Backend + màn xong, chưa commit — chờ Khanh duyệt + review**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).
- Chưa cập nhật SDLC 04 / 05 / 07 cho cả chuỗi đặt vé (BTP-002 → 006 + phần này) — làm một lượt cuối đợt.

## Đã làm — backend

- Migration `20261018020000_refund_admin`: `refunds.attempt` (lần gửi cổng, ≥ 1) + `refunds.bank_reference` (3–64 ký tự, khi Admin ghi nhận đã hoàn ngoài cổng); index `created_at` cho `payments` / `refunds`.
- `GET /admin/payments` (`payment:monitor`): lọc ngày tạo (giờ VN) / nhà xe / cổng / trạng thái, `reconcile=open` (thanh toán `RECONCILING` chưa có hoàn tiền đang / đã hoàn), tìm mã thanh toán / mã đặt vé / mã giao dịch cổng; trả `total` + `reconcileOpen` (nhãn tab).
- `GET /admin/payments/{id}`: dòng lịch sử, callback gần nhất, số tiền khớp đơn, booking (tên liên hệ đã che), phân bổ theo sổ giữ hộ (hoa hồng, nhà xe nhận), vé, bút toán, hoàn tiền, `canRefund`.
- `GET /admin/refunds` + `GET /admin/refunds/{id}` (`payment:monitor`): lọc ngày / nhà xe / nguồn (`CUSTOMER` / `PLATFORM`) / trạng thái, tìm mã hoàn / mã đặt vé; chi tiết có vé, lịch sử (người thao tác `platform/{tên}`), `canRetry` / `canResolve`.
- Thao tác (`finance:configure` + **xác nhận lại danh tính** + lý do 3–500 ký tự + audit Mongo trong transaction — Mongo lỗi → 503, không đổi gì):
  - `POST /admin/refunds/{id}/retry`: refund `FAILED → APPROVED`, `attempt + 1`, booking về `REFUND_PENDING`, xếp job mới (`{id}-{attempt}`); worker gửi cổng mã yêu cầu `{mã refund}R{lần}` (cổng không nhận mã trùng).
  - `POST /admin/refunds/{id}/resolve { reference, reason }`: refund `FAILED → SUCCESS` như khi cổng xác nhận — vé `REFUNDED`, ghi sổ hoàn + trả hoa hồng, suy lại booking.
  - `POST /admin/payments/{id}/refunds { reason }`: thanh toán cần đối soát (đơn hết hạn / ghế đã nhả / trả trùng) → refund `APPROVED` 100% số tiền thanh toán, worker hoàn qua cổng. Lệch số tiền / thiếu mã giao dịch cổng → 409.
- Refund của **thanh toán cần đối soát** không đụng booking: không vé, không ghi sổ giữ hộ (tiền chưa vào sổ), không suy lại trạng thái booking, không chặn kỳ chi trả (loại khỏi 4 chỗ kiểm "hoàn tiền treo" + `settleBookingStatus`).
- `processRefund` tách bước "hoàn xong" thành `completeRefund` (worker + Admin dùng chung).
- Mã lỗi mới: `REFUND_NOT_FOUND`, `REFUND_STATUS_INVALID`, `PAYMENT_NOT_FOUND`.

## Đã làm — giao diện (Admin `/payments`, Figma ADM-07a–d)

- Tab Thanh toán / Hoàn tiền / Cần đối soát (N) (`?tab=`), lọc từ ngày – đến ngày, cổng, trạng thái / nguồn, tìm kiếm, "Đã tải X / Y", tải thêm, đủ trạng thái tải / lỗi / trống / lọc rỗng.
- Chi tiết thanh toán `/payments/{id}`: dòng thời gian (tạo đơn → thanh toán → cổng → ghi sổ → phát hành vé → hoàn tiền → đủ điều kiện chi trả, mốc tương lai "Dự kiến"), phân bổ số tiền, cổng thanh toán, hoàn tiền (mở chi tiết), liên kết; "Hoàn toàn bộ cho khách" (lý do + TOTP) khi cần đối soát.
- Hộp thoại hoàn tiền: thất bại → chọn "Gửi lại cổng" / "Đã hoàn ngoài cổng" (mã tham chiếu) + lý do + TOTP; trạng thái khác → xem tóm tắt + tiến trình.

## Chờ Khanh (G1–G9)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | API khác doc | API §7.5 ghi `POST /admin/refunds/{id}/decision`; làm `retry` / `resolve` cho refund **thất bại** + `POST /admin/payments/{id}/refunds` cho thanh toán cần đối soát. Quyết định duyệt / từ chối refund `REQUESTED` (Figma ADM-07d) để module tranh chấp (UC-27, TASK-DSP) — hiện chưa luồng nào tạo `REQUESTED` | Duyệt → sửa API §7.5 |
| G2 | Quyền thao tác | `finance:configure` (chỉ PlatformAdmin) — không dùng `refund:request` vì chủ nhà xe có quyền đó theo tenant | Duyệt → Security §7 / §8 |
| G3 | Cột mới | `attempt`, `bank_reference` | Duyệt → DB §4 |
| G4 | Gửi lại cổng | Mã yêu cầu mới mỗi lần (`R{lần}`); Admin phải tự kiểm trên trang quản trị cổng trước (hộp thoại nhắc) để không hoàn hai lần | Duyệt |
| G5 | "Hoàn tiền thủ công" cho thanh toán **thành công** (Figma ADM-07b) | Chưa làm — ngoài chính sách cần hồ sơ tranh chấp (UC-27) | Quyết làm ở TASK-DSP |
| G6 | Phần Figma chưa làm | "Xuất danh sách", "Đánh dấu cần đối soát", lọc theo nhà xe (API có `operatorId`, chưa có ô chọn), liên kết sang đơn / nhật ký audit (Admin chưa có màn chi tiết đơn) | Quyết v1 hay sau |
| G7 | Thông báo | Security §8 đòi báo nhà xe khi refund thủ công — chưa có module thông báo | Làm cùng TASK-NTF |
| G8 | Refund `APPROVED` đứng yên (xếp job lỗi) | Chưa có thao tác / job quét (giống G6 của BTP-005) | Quyết |
| G9 | Đối soát tự động với cổng (`querydr`, FR-BTP-17) | Chưa làm | Xếp vào task nào |

## Kiểm tra (18/10/2026)

- `admin-refund.int.spec.ts` 4 ca trên Postgres + Redis thật, role app: giám sát (lọc nhà xe / trạng thái / mã / ngày, phân bổ hoa hồng 4% BIGINT, vé, callback cổng, tên che); thanh toán trùng → cần đối soát → hoàn toàn bộ (refund 100%, job, audit), worker hoàn xong mà booking vẫn `CONFIRMED` + sổ giữ hộ không đổi, hoàn lần nữa 409, lệch tiền 409, không có 404; refund thất bại → gửi lại cổng (lần 2, booking `REFUND_PENDING`, job `{id}-2`, worker gửi `…R2`) → hoàn xong + sổ ghi hoàn 270.000 / trả hoa hồng 10.800; ghi nhận đã hoàn: audit lỗi 503 không đổi gì, **hai thao tác đồng thời chỉ một thành công**, `SUCCESS` + mã tham chiếu, vé `REFUNDED`, sổ ghi hoàn, booking `REFUNDED`.
- `admin-refund.http.spec.ts` 2 ca (guard: Admin + hỗ trợ nền tảng xem, chủ nhà xe 403; thao tác: hỗ trợ nền tảng / chủ nhà xe 403, cần xác nhận lại danh tính, body / bộ lọc sai 400).
- Suite liên quan (refund / payout / payment / escrow / openapi / booking): 73 test pass.
- Unit FE `payment-format.test.ts` 3 ca; Admin unit 49 / 49.
- E2E Playwright (Chrome thật + API build): Admin `payments.e2e.ts` 3/3 (tìm theo mã đặt vé → chi tiết; cần đối soát → hoàn toàn bộ + TOTP; hoàn tiền thất bại → ghi nhận đã hoàn ngoài cổng), `payouts.e2e.ts` 2/2; Operator OS `bookings.e2e.ts` 5/5 (seed mới không ảnh hưởng).
- Lint + typecheck sạch; client TS + Dart sinh lại (`dart analyze` 0 lỗi).
