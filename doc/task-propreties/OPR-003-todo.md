# TASK-OPR-003 — Todo: Màn Đặt vé của nhà xe

> **Khanh (17/10/2026):** hoàn thiện phần nhà xe; lõi đặt vé theo lát dọc. Task đề xuất 14/10/2026 (11 Task v0.46), chờ Khanh duyệt.
> Nguồn: FR-OPS-14/15, UC-15, AC-20, BR-08, API §7.3 (`GET /operator/bookings`), Figma "Giao diện nhà xe · Màn bổ sung" → "Nhà xe · Đặt vé" 01 Danh sách đơn (1665:24943), 02 Chi tiết đơn (1665:25345), 03 Danh sách hành khách theo chuyến (1665:25686). API chi tiết / quyền / che dữ liệu AI tự đề xuất, **chờ Khanh duyệt**.
> **Nhánh:** `TASK-TRN-004` (làm tiếp), chưa commit.

## Trạng thái (17/10/2026) — 🔨 **Backend + Operator OS xong, chưa commit — chờ Khanh duyệt + review**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).

## Đã làm

- Quyền mới `booking:read` (Owner, phạm vi tenant) — API §7.3 `/operator/bookings`.
- API (scope tenant + RLS, tenant lấy từ JWT):
  - `GET /operator/bookings?date&tripId&status&q&cursor&limit` — đơn của các chuyến khởi hành trong ngày (giờ VN), mới đặt trước; tìm theo mã đặt vé, mã vé, SĐT (chữ số) hoặc tên; SĐT che `0*** *** 567`.
  - `GET /operator/bookings/{id}` — chỗ + vé (chưa phát hành = trống), điểm đón / trả, tiền, chính sách hủy lưu lúc đặt, lịch sử (người làm: hành khách / khách vãng lai / hệ thống / cổng thanh toán); liên hệ che.
  - `POST /operator/bookings/{id}/contact-reveal` — liên hệ đầy đủ; **ghi audit `booking.contact.reveal` trước khi trả** (Mongo lỗi → 503, không trả dữ liệu).
  - `GET /operator/trips/{tripId}/passengers?pickupSequence&ticketStatus&q` — hành khách đã có vé theo chỗ + số liệu cả chuyến (đã bán / đã lên xe / chưa lên xe / vắng mặt) + điểm đón cho ô lọc.
  - `GET /operator/trips/{tripId}/passengers/export` — CSV UTF-8 có BOM (Excel đọc đúng tiếng Việt), SĐT đầy đủ cho tài xế liên hệ đón; chặn công thức (CSV injection); **audit `trip.passengers.export` trước khi trả**; `cache-control: no-store`. CORS expose `Content-Disposition` để web lấy tên tệp.
- Operator OS theo Figma 01–03: `/bookings` (lọc ngày đi / chuyến / trạng thái / tìm, tải thêm, ghi chú che SĐT), `/bookings/{id}` (vé, chuyến, lịch sử, "Hiện đầy đủ", thanh toán, chính sách hủy), `/bookings/passengers?tripId=` (số liệu, lọc, In danh sách = in trang, Xuất danh sách = tải CSV; chưa chọn chuyến → chọn ngày + chuyến). Đủ trạng thái tải / lỗi / rỗng / không tìm thấy.

## Chờ Khanh (G1–G7)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Quyền | Thêm `booking:read` chỉ cho Owner; nhân viên (vé / hỗ trợ) chưa xem | Duyệt / mở cho nhân viên theo phân công |
| G2 | Che dữ liệu cá nhân | Danh sách / chi tiết / hành khách luôn che; xem đầy đủ từng đơn hoặc xuất CSV đều ghi audit | Duyệt |
| G3 | SĐT trong danh sách hành khách | SĐT hành khách, không có thì SĐT người liên hệ của đơn | Duyệt |
| G4 | "Kênh bán" (Figma có ô lọc) | Bỏ: v1 chỉ bán online qua Marketplace | Duyệt / mở lại khi có bán tại quầy |
| G5 | "Giảm giá do Vé Xe Nhanh chịu" (Figma 02) | Hiện dòng "Giảm giá" khi > 0; v1 chưa có voucher (TASK-LOY-001) | — |
| G6 | Thao tác trên đơn (hủy / hoàn) | Không có — nhà xe chỉ xem, hoàn tiền theo luồng BTP-005 | — |
| G7 | Số "Còn n chỗ chưa bán" | Tổng chỗ − vé còn hiệu lực (không trừ chỗ khóa / đang giữ) | Duyệt |

## Kiểm tra (17/10/2026)

- `operator-booking.int.spec.ts` 4 ca trên Postgres + Redis thật, role app: danh sách theo ngày (thứ tự, che SĐT, khách vãng lai, phân trang, lọc trạng thái / chuyến, tìm mã đặt vé / mã vé có gạch / SĐT có khoảng trắng / tên không dấu hoa thường, ngày khác rỗng, **nhà xe khác rỗng**); chi tiết (vé, đơn chưa có vé, lịch sử, khác tenant 404); hiện đầy đủ ghi audit trước, Mongo lỗi → 503; hành khách theo chuyến (số liệu, lọc, CSV có BOM + header + SĐT đầy đủ + nhãn trạng thái, audit, Mongo lỗi → 503, khác tenant 404).
- `operator-booking.http.spec.ts` (guard thật: Owner được, không token 401, tài xế / nhân viên / hành khách / Admin 403; query sai 400; header CSV tải về + `no-store`).
- Operator OS: `booking-format.test.ts` 6 ca; E2E `bookings.e2e.ts` 3 ca (danh sách che SĐT + lọc + tìm; chi tiết + hiện đầy đủ; hành khách theo chuyến + lọc + tải CSV có SĐT đầy đủ). Toàn bộ Operator OS 436 test + 49/49 E2E, Admin 31/31 E2E pass (seed E2E thêm nhà xe đặt vé riêng).
- Đối chiếu ảnh chụp 3 màn với Figma: bố cục / nội dung khớp; đã nới cột Thanh toán cho badge "Chưa thanh toán".
