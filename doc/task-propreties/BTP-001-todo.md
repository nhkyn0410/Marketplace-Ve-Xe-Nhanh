# TASK-BTP-001 — Todo: Giữ chỗ

> **Khanh (17/10/2026):** lõi đặt vé theo lát dọc, quy tắc SRS/ADR (giữ chỗ 10 phút), không làm giao diện khách hàng.
> Nguồn: LLD §6.1, ADR-015 (Redis `SET NX EX`, Redis down → 503), 05 API §7.2 `/seat-holds`, BR-22, BR-23, OQ-06 (10 phút), chính sách giữ chỗ có phiên bản (A6). Chi tiết AI tự quyết, **chờ Khanh duyệt**.
> **Nhánh:** `TASK-TRN-004` (làm tiếp), chưa commit.

## Trạng thái (17/10/2026) — 🔨 **Backend xong, chưa commit — chờ Khanh duyệt + review**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8). Không có màn hình (phía khách hàng).

## Đã làm

- Guard mới `GuestOrPassenger(permission)` (`iam/role/guest-or-passenger.ts`): không token = khách vãng lai; có token thì phải hợp lệ + phiên còn sống (sai → 401) và role có quyền qua `can()` (chủ nhà xe / nhân viên / Admin → 403). Dùng lại cho đặt vé / thanh toán.
- Module `seat-hold/`: `POST /seat-holds { tripId, seatCodes (1–10), pickupSequence, dropoffSequence }` → `{ holdId, pickup, dropoff, seats [{ code, type, price }], subtotal, expiresAt }`; `GET` / `DELETE /seat-holds/{holdId}`.
- Kiểm: chuyến đang hiển thị công khai (BR-22, dùng chung truy vấn chi tiết chuyến), điểm đón cho đón + điểm trả cho trả + đón trước trả (BR-23), chỗ thuộc chuyến, còn `AVAILABLE` trong Postgres và có giá. Giữ cả lô trên Redis bằng Lua (`SET … PX` cho mọi chỗ hoặc không chỗ nào) — chỗ đang bị giữ → 409 `SEAT_HOLD_CONFLICT` kèm mã chỗ.
- Hạn giữ = `holdMinutes` của chính sách giữ chỗ nền tảng đang áp dụng (dữ liệu nền 10 phút), không quá giờ ngừng bán online.
- Giữ chỗ của hành khách đăng nhập chỉ chính họ xem / bỏ; của khách vãng lai thì `holdId` (UUID ngẫu nhiên) là quyền sở hữu. Chống giữ hàng loạt: 20 lần / 10 phút / IP → 429. Redis lỗi → 503 (không giữ trong bộ nhớ — ADR-015).
- Chi tiết chuyến công khai đánh dấu chỗ đang được giữ là `UNAVAILABLE` (Redis lỗi thì bỏ qua lớp này).

## Chờ Khanh (G1–G6)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Quyền sở hữu giữ chỗ của khách vãng lai | `holdId` ngẫu nhiên là "chìa khóa" (như giỏ hàng), hết hạn sau 10 phút | Duyệt |
| G2 | Chống giữ chỗ hàng loạt | 20 lần / 10 phút / IP; chưa giới hạn số giữ chỗ đang mở cùng lúc | Duyệt con số / thêm giới hạn |
| G3 | Một lần giữ nhiều chỗ | Tối đa 10 chỗ (= số khách tối đa khi tìm) | Duyệt |
| G4 | Hạn giữ chỗ | Theo chính sách đang áp dụng (A6), cắt bớt nếu sắp tới giờ ngừng bán online | Duyệt |
| G5 | Khóa Redis | Đúng mẫu ADR-015 `seat:{tripId}:{seatCode}:hold`; bản ghi `seat-hold:{holdId}` | — |
| G6 | Tìm chuyến | Số chỗ trống ở danh sách chưa trừ chỗ đang giữ (xem `TRN-004-todo.md` G1) | Duyệt |

## Kiểm tra (17/10/2026)

- `seat-hold.int.spec.ts` 5 ca trên Postgres + Redis thật, role app: giữ 2 chỗ (giá, tổng, hạn 10 phút, TTL Redis, chi tiết chuyến hiện chỗ đang giữ, bỏ giữ chỗ trả lại); **hai lần giữ đồng thời chồng chỗ → đúng một thành công, bên thua không giữ dở chỗ nào**; chỗ khóa 409 / mã lạ 422 / điểm đón là trạm nghỉ 422 / trả trước đón 422 / chuyến nháp 404; quyền sở hữu (hành khách khác / khách vãng lai không xem / bỏ được giữ chỗ của hành khách); hạn bị cắt theo giờ ngừng bán, 21 lần / IP → 429, Redis mất kết nối → 503.
- `seat-hold.http.spec.ts` 8 ca (guard thật: khách vãng lai được, hành khách được + kiểm phiên, token rác 401, chủ nhà xe / tài xế / Admin 403; 5 ca body sai → 400).
