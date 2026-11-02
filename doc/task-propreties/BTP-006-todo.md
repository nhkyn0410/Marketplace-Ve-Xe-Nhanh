# TASK-BTP-006 — Todo: Sổ giữ hộ (escrow), hoa hồng, kỳ chi trả T+3 + màn Tài chính (OPR-002) / Chi trả nhà xe (ADM-002)

> **Khanh (17/10/2026):** lõi đặt vé theo lát dọc (SRS / ADR); không làm giao diện khách hàng.
> Nguồn: FR-BTP-15/16, BR-30/31, SRS §17.10, ADR-005 (escrow in-house), ADR-022 (chi trả thủ công + T+3, không ngưỡng tối thiểu), ADR-016 / 024 (cron BullMQ concurrency 1), LLD §6.3, DB §4 `escrow_ledgers` / `payouts`, Figma "Nhà xe · Tài chính" 01–03 + ADM-08a–c. Bảng / cột / API / mã lỗi bổ sung AI tự đề xuất, **chờ Khanh duyệt**.
> **Nhánh:** `TASK-TRN-004` (làm tiếp), chưa commit.

## Trạng thái (18/10/2026) — 🔨 **Backend + 2 màn xong, chưa commit — chờ Khanh duyệt + review**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).
- Màn Thanh toán & hoàn tiền của Admin (ADM-07, hoàn tiền tay / chạy lại) làm ở bước sau.

## Đã làm — backend

- Migration `20261018010000_escrow_payouts`: enum `EscrowEntryType` (`PAYMENT_CAPTURED`, `COMMISSION`, `REFUND`, `COMMISSION_REVERSAL`, `PAYOUT`, `ADJUSTMENT`) + `PayoutStatus` (7 trạng thái); bảng `escrow_ledgers` (tiền BIGINT **có dấu** theo loại — CHECK dấu, CHECK mức ‱ 0–10.000, CHECK liên kết payment / refund / payout theo loại), `payouts` (mã `PO-YYYYMMDD-NNN` từ sequence `payout_code_seq`, unique `(operator_id, period)`, chụp tài khoản nhận lúc tạo, CHECK `PAID` phải có mã giao dịch + giờ chuyển), `payout_items` (mỗi bút toán vào đúng một kỳ — unique `ledger_entry_id`), `payout_status_histories`. RLS `tenant_isolation` cả 4 bảng.
- **Sổ chỉ ghi thêm**: trigger chặn UPDATE / DELETE trên `escrow_ledgers` (chỉ test dọn dữ liệu bật `app.allow_ledger_delete`). Partial unique `(payment_id | refund_id | payout_id, entry_type)` → callback / job chạy lặp không ghi trùng.
- Ghi sổ (`escrow/escrow-entries.ts`) TRONG transaction:
  - Thanh toán thành công (BTP-003): `+PAYMENT_CAPTURED` tổng khách trả, `−COMMISSION` trên tiền vé. Mức: luật hoa hồng riêng nhà xe đang hiệu lực → mặc định nền tảng → 5% (BR-31). **Làm tròn xuống tới đồng**.
  - Hoàn tiền thành công (BTP-005): `−REFUND` số đã hoàn, `+COMMISSION_REVERSAL` hoa hồng trên phần đã hoàn, **cùng mức lúc thu**.
  - Đủ điều kiện chi trả = giờ đến dự kiến của chuyến + T ngày (chính sách `PAYOUT` đang phát hành, mặc định 3).
- Tạo kỳ (`payout/payout-generation.ts`, hàng đợi `payout-maintenance`, cron `0 0 * * *` giờ VN, concurrency 1): gom bút toán đã tới hạn, chưa vào kỳ nào, theo từng nhà xe → một kỳ / nhà xe / ngày (`PENDING_REVIEW`). Thực chi = gom − hoa hồng ròng − hoàn ± điều chỉnh. Booking còn hoàn tiền treo (`REQUESTED` / `APPROVED` / `PROCESSING` / `FAILED`) **giữ ngoài kỳ** tới khi xong. Nhà xe chưa có tài khoản nhận tiền đã xác minh → kỳ `ON_HOLD`. Chạy lại cùng ngày không tạo thêm.
- Admin (`/admin/payouts`): danh sách (lọc kỳ / trạng thái / tìm mã, nhà xe), thống kê 4 thẻ, chi tiết (chuyến trong kỳ, cách tính, kiểm tra trước khi chi, tài khoản đã che, tiến trình). Thao tác: rà soát xong → `READY_TO_TRANSFER` (chặn nếu kiểm tra hỏng: lệch sổ / hoàn tiền treo / tài khoản chưa xác minh); giữ lại (bắt buộc lý do); mở lại; hủy (bút toán trả về, vào kỳ sau); **xác nhận đã chuyển khoản** (mã giao dịch ngân hàng + giờ chuyển ≤ hiện tại + ghi chú, **cần xác nhận lại danh tính**) → `PAID` + bút toán `−PAYOUT` (số dư kỳ về 0); xem đầy đủ số tài khoản (xác nhận lại danh tính + audit). Mọi thao tác ghi lịch sử + audit Mongo trong transaction (Mongo lỗi → 503, không đổi gì).
- Nhà xe (`/operator/finance/*`, `/operator/payouts*`, quyền `finance:read`): tổng quan (đang giữ / đủ điều kiện / chờ đủ điều kiện / kỳ gần nhất), giao dịch theo đơn có tình trạng, danh sách + chi tiết kỳ (số tài khoản đã che, người thao tác hiện "Vé Xe Nhanh").
- Mã lỗi mới: `PAYOUT_NOT_FOUND`, `PAYOUT_STATUS_INVALID`, `PAYOUT_CHECKS_FAILED`, `PAYOUT_TRANSFER_TIME_INVALID`.

## Đã làm — giao diện

- Operator OS `/finance` (Figma Tài chính 01–03): tab Tổng quan (4 thẻ + bảng giao dịch theo đơn, lọc ngày / tuyến / tình trạng / mã) · tab Chi trả (danh sách kỳ, lọc tháng / trạng thái) · chi tiết kỳ (chuyến trong kỳ, cách tính, tài khoản đã che, tiến trình). Chỉ xem.
- Admin `/payouts` (Figma ADM-08a–c): 4 thẻ thống kê + bảng (che số tài khoản, thao tác tiếp theo cuối dòng) · chi tiết + kiểm tra trước khi chi · hộp thoại giữ lại / hủy (lý do) · hộp thoại xác nhận đã chuyển khoản (TOTP) · nút xem đầy đủ số tài khoản (TOTP, 5 phút không hỏi lại).

## Chờ Khanh (G1–G10)

| #   | Điểm | Đã làm theo | Cần Khanh |
| --- | ---- | ----------- | --------- |
| G1  | Bảng / cột escrow + payout | Thiết kế ở trên (DB §4 chỉ có tên bảng) | Duyệt |
| G2  | Sổ đơn (DB-OQ-03) | **Bút toán đơn có dấu** theo nhà xe (không phải sổ kép); số dư = tổng bút toán | Duyệt |
| G3  | Mốc đủ điều kiện | Giờ đến **dự kiến** + T — chưa có trạng thái chuyến `COMPLETED` thật (Employee / chuyến chạy làm sau) | Duyệt / đổi khi có |
| G4  | `TRANSFERRING` / `FAILED` | Có trong enum, **chưa dùng** (chi thủ công: rà soát → xác nhận). Dùng khi có chi hộ tự động (ADR-022 v1.x) | Duyệt |
| G5  | Hoa hồng hoàn tiền | Trả lại hoa hồng trên phần đã hoàn, cùng mức lúc thu | Duyệt |
| G6  | Kỳ khi chưa có tài khoản | Vẫn tạo kỳ nhưng `ON_HOLD`; mở lại khi tài khoản đã xác minh | Duyệt |
| G7  | Quyền đọc màn Admin | `payment:monitor` (Admin + Hỗ trợ nền tảng xem), thao tác `finance:configure` (chỉ Admin) — vì `finance:read` theo tenant để chủ nhà xe xem tài chính của mình | Duyệt → Security §7 |
| G8  | Maker-checker | Tắt (một người rà soát + xác nhận) — ADR-022 bật khi team Platform > 1 | Duyệt |
| G9  | Phần Figma chưa làm | Tab "Hoa hồng và điều chỉnh", nút "Xuất đối soát", lọc theo nhà xe ở danh sách Admin, điều chỉnh tay (`ADJUSTMENT`) | Quyết làm v1 hay sau |
| G10 | Đối soát cổng (FR-BTP-17) | Chưa làm job `querydr` đối chiếu VNPay / MoMo | Xếp vào task nào |

## Kiểm tra (18/10/2026)

- `escrow-entries.spec.ts` 2 ca (hoa hồng ‱ làm tròn xuống, 0 ‱, số lớn không mất chính xác; mức ngoài 0–10.000 / lẻ → lỗi).
- `payout.int.spec.ts` trên Postgres + Redis + Mongo thật, role app: thu tiền → +tổng / −hoa hồng 4% BIGINT, mốc đủ điều kiện, callback lặp không ghi trùng, hoàn 90% → −hoàn / +trả hoa hồng, **UPDATE / DELETE sổ bị chặn**; tạo kỳ (chưa tới hạn không tạo, tới hạn `PENDING_REVIEW`, chạy lại không tạo thêm, hoàn tiền treo bị giữ ngoài kỳ, chưa có tài khoản → `ON_HOLD`); Admin rà soát → sẵn sàng, giờ chuyển ở tương lai 422, xác nhận → `PAID` + `PAYOUT` (sổ kỳ về 0) + audit, xác nhận lại 409, Mongo lỗi 503 không đổi gì; giữ lại / mở lại / hủy → bút toán vào kỳ hôm sau; màn nhà xe + **RLS: nhà xe khác không thấy**.
- `payout.http.spec.ts` 3 ca (guard: Admin + hỗ trợ nền tảng xem, chủ nhà xe 403; hỗ trợ nền tảng không thao tác; xác nhận / xem số tài khoản cần xác nhận lại danh tính; chủ nhà xe xem tài chính, nhân viên 403; query sai → 400).
- Unit FE: `finance-format.test.ts` (Operator OS), `payout-format.test.ts` (Admin).
- E2E Playwright (Chrome thật + API build): Operator OS `bookings.e2e.ts` 5/5 (có 2 ca Tài chính: tổng quan + kỳ chi trả); Admin `payouts.e2e.ts` 2/2 (danh sách → rà soát → xác nhận đã chuyển khoản + TOTP → đã chi trả → xem đầy đủ số tài khoản).
- Lint + typecheck sạch cho phần đã sửa.
