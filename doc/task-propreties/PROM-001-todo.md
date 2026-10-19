# Khuyến mãi (TASK-PROM-001) — Todo

> Khanh 18/10/2026 (LLD-OQ-07): khuyến mãi cấp nền tảng do **nhà xe chịu phần giảm** và **nhà xe phải tham gia** chương trình. Khanh 19/10/2026: "Khuyến mãi (PROM-001)". Schema / API AI tự thiết kế theo SRS (FR-PROM-01..07, FR-MKT-10, BR-46/47/48/72) + Figma ADM-11a/b, "Nhà xe · Khuyến mãi" 01–03 — **chờ Khanh duyệt**. Nhánh `TASK-TRN-008`, chưa commit; chưa qua `code-reviewer` / `security-auditor`.

## Đã làm

- Migration `20261019050000_promotions`: `promotion_permissions` (quyền + giới hạn từng nhà xe), `promotions` (nền tảng / nhà xe; mã duy nhất), `promotion_participations` (nhà xe tham gia khuyến mãi nền tảng), `promotion_redemptions` (lượt áp dụng theo đơn, `funded_by`). RLS: nhà xe **đọc** khuyến mãi nền tảng + của mình, **ghi** chỉ của mình; quyền chỉ Admin ghi. Hàm `promotion_claim` / `promotion_release` (SECURITY DEFINER, đổi scope trong lời gọi) giữ / trả lượt dùng nguyên tử — kể cả khuyến mãi nền tảng mà tenant không được ghi.
- Quyền: `promotion:manage` (chủ nhà xe, tenant), `promotion:configure` (chỉ PlatformAdmin).
- Đặt vé: `promotionCode` tùy chọn trong `POST /bookings` (tối đa một mã, `expectedTotal` là tổng sau giảm); kiểm trạng thái / hiệu lực / nhà xe đã tham gia (nền tảng) / tuyến + chuyến (nhà xe) / đơn tối thiểu / lượt dùng / ngân sách tháng; giữ lượt trong cùng transaction đơn; snapshot `promotion` trong đơn (BR-47); đơn hết hạn / nhà xe hủy chuyến khi chưa thanh toán → trả lượt; thanh toán → "đã dùng".
- Tiền (nhà xe chịu phần giảm): sổ giữ hộ nhận số khách thực trả, **hoa hồng tính trên tiền vé sau giảm**; khách hủy vé → hoàn trên **phần đã trả của từng vé** (phần giảm chia theo tỷ lệ giá, làm tròn lên để tổng không vượt số đã trả). Khách trả tối thiểu 10.000 ₫ sau giảm.
- `POST /promotions/check` (khách vãng lai / hành khách): báo trước số tiền giảm, không giữ lượt.
- Admin: khuyến mãi nền tảng (tạo / sửa khi chưa có đơn dùng / kích hoạt / tạm dừng / kết thúc), quyền của nhà xe (bật / mức giảm tối đa % và / hoặc số tiền / hiệu lực tối đa / ngân sách tháng), khuyến mãi của các nhà xe (tạm dừng / kết thúc khi vi phạm). Số liệu 30 ngày: lượt áp dụng, tổng giảm, doanh thu có mã.
- Nhà xe: khuyến mãi của nhà xe trong giới hạn (kiểm lại khi kích hoạt), màn chưa được cấp quyền (Figma 03), tab "Khuyến mãi Vé Xe Nhanh" để tham gia / rời.
- UI dùng chung: `packages/ui/components/promotion-form.tsx`, `packages/ui/lib/promotion-format.ts`.

## Chờ Khanh

| # | Điểm | Đã làm theo |
|---|------|-------------|
| G1 | Khuyến mãi nền tảng giới hạn tuyến (Figma "Tuyến Hà Nội – Sapa") | Chưa — tuyến thuộc từng nhà xe; khuyến mãi nền tảng áp mọi chuyến của nhà xe đã tham gia |
| G2 | Giới hạn lượt dùng của khuyến mãi nền tảng | Một tổng lượt chung mọi nhà xe (không chia theo nhà xe) |
| G3 | Hoa hồng khi có giảm giá | Tính trên tiền vé sau giảm (nhà xe chịu phần giảm) |
| G4 | Mức tối thiểu khách phải trả sau giảm | 10.000 ₫ (`MIN_PAYABLE`) — cần đối chiếu mức tối thiểu thật của VNPay / MoMo |
| G5 | Chỉ một mã duy nhất toàn hệ thống | Có — mã không trùng cả giữa các nhà xe |
| G6 | Ví voucher (FR-PROM-08..10), voucher đổi điểm VXN Plus khi đặt vé | Chưa — phần hành khách; LOY-001 chỉ làm phía Admin |
| G7 | Rời khuyến mãi nền tảng | Được bất cứ lúc nào; đơn đã giữ mã không bị ảnh hưởng |
| G8 | "Doanh thu có áp mã" | Tổng tiền đơn (sau giảm) của đơn đã thanh toán có mã, 30 ngày |
| G9 | Hủy chuyến của nhà xe — số tiền hoàn hiển thị trước khi hủy | Hoàn theo số đã trả (đã đúng ở luồng hủy); số "dự kiến hoàn" ở màn chi tiết chuyến vẫn tính theo giá vé |

## Kiểm tra

- `promotion.int.spec.ts` 2 ca (Postgres + Redis thật): khuyến mãi nền tảng chưa tham gia → không áp; tham gia → giảm; **hai đơn đồng thời còn 1 lượt → đúng một đơn** (lượt giữ nguyên tử); hết hạn trả lượt; thanh toán → đã dùng, sổ giữ hộ nhận số đã trả, hoa hồng trên số đó; BR-47 không sửa khi đã có đơn; khuyến mãi nhà xe: chưa có quyền / vượt %, trần, thời hạn → chặn; trong giới hạn → chạy; trùng mã; **nhà xe khác không thấy / không sửa** (RLS); hủy vé hoàn trên phần đã trả; Admin tạm dừng khuyến mãi nhà xe, không tự kích hoạt lại.
- `promotion.http.spec.ts` 2 ca: guard (chỉ Admin cho route Admin — đã tách quyền sau khi phát hiện chủ nhà xe lọt route Admin khi dùng chung một quyền), validate body.
- Unit: tính giảm / phần đã trả / đầu tháng (4), `promotion-format` (2).
- Bộ test booking / refund / payment / trip: 246 pass sau khi nối khuyến mãi.
- E2E: `operator-os/e2e/promotions.e2e.ts` (2), `admin/e2e/promotions.e2e.ts` (2, tài khoản E2E riêng `platformPromo`).
