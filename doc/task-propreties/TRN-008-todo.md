# TASK-TRN-008 + TASK-NSR-001 (email) — Todo: đổi / hủy chuyến đã bán vé + thông báo

> Nhánh `TASK-TRN-008`, chưa commit. Bảng / API / mã lỗi AI tự đề xuất, **chờ Khanh duyệt**. Chưa qua `code-reviewer` / `security-auditor`.

## Đã làm (18–19/10/2026)

- Migration `20261019010000_notifications_trip_changes`: `notifications` + `notification_deliveries` (outbox ghi cùng transaction nghiệp vụ, worker gửi email Resend, job quét 5 phút gửi lại bản ghi `PENDING`), `trip_changes` (lý do, trước / sau, số đơn bị ảnh hưởng). RLS cả 3 bảng.
- Thông báo email: vé điện tử sau thanh toán, hủy vé, hoàn tiền xong, đổi chuyến, hủy chuyến, Admin hoàn tay (báo chủ nhà xe). Dev không có `RESEND_API_KEY` → `SKIPPED`. Nhật ký gửi vào Mongo `system_log` (không chứa email).
- `GET /operator/trips/{id}/sales`, `POST /operator/trips/{id}/changes` (giờ / xe / điểm đón trả, lý do bắt buộc; đổi xe phải giữ chỗ đã bán cùng mã + loại; còn khách đang thanh toán → 409). `PUT …/status` = `CANCELLED` giờ hủy được cả chuyến có vé: hủy đơn chờ thanh toán, hủy vé + hoàn 100% giá vé (refund nguồn "Nhà xe hủy chuyến"), báo từng đơn. Booking trả `tripChanges` để khách tra cứu.
- Operator OS: nút "Đổi lịch chạy" + màn đổi, hộp thoại hủy nêu số hoàn, thẻ "Lịch sử thay đổi". Admin: nguồn hoàn tiền "Nhà xe hủy chuyến".

## Chờ Khanh

| # | Điểm | Đã làm theo |
|---|------|-------------|
| G1 | Hoàn khi nhà xe hủy chuyến | 100% giá vé còn hiệu lực, trả toàn bộ hoa hồng |
| G2 | Đổi xe thiếu chỗ đã bán | Từ chối kèm mã chỗ; chưa có đổi ghế / chuyển chuyến cho khách (BR-20 phần còn lại) |
| G3 | Push / SMS | Chưa làm (cần app di động / SMS hoãn — ADR-020) |
| G4 | Tùy chọn nhận thông báo (NSR-002) | Chưa làm — các loại hiện có đều là thông báo bắt buộc |
| G5 | Lý do hủy chuyến | Tối thiểu 3 ký tự (trước chỉ cần không rỗng) |

## Kiểm tra

- `trip-change.int.spec.ts` 4 ca (đổi giờ / xe / điểm, 409 / 422 / 503, hủy có vé + hoàn + sổ về 0, hai lần hủy đồng thời chỉ một, gửi email SENT / SKIPPED / thử lại / FAILED); `notification-templates.spec.ts` 3 ca; spec cũ cập nhật pass.
- E2E Operator OS `bookings.e2e.ts` 7/7 (thêm đổi lịch chạy + hủy chuyến đã bán), `trips.e2e.ts` 13/13. Chưa chạy lại E2E Admin + toàn bộ suite API sau thay đổi này.
