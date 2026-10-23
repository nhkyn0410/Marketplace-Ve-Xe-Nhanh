# TASK-ADM-001 (phần chính sách + khung giá) — Todo: Chính sách nền tảng, hoa hồng, khung giá vé

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` — `TASK-ADM-001` (policy; khung giá trần / sàn + cảnh báo Operator — chuyển từ TRN-005 theo Q6, 30/09/2026; dải cảnh báo trên màn Bảng giá Operator OS, Figma `1665:24475` — Khanh chốt 14/10/2026). Nguồn chi tiết: SRS `FR-ADM-06..09`, `FR-OPS-09`, `UC-25`, `AS-23`, `BR-02`, `BR-07`, `BR-31`, `BR-32`, `OQ-06`, `OQ-13`, `OQ-16`, `OQ-17`, `OQ-18`; DB §5.2 (`policy_versions`, `commission_rules`); Figma section `Giao diện Admin` (`1663:23890`): `ADM-06a` Hủy và hoàn tiền · Các phiên bản (`1673:33189`), `ADM-06b` Soạn phiên bản mới (`1673:33513`), `ADM-06c` Hoa hồng (`1673:33888`), `ADM-06d` Giữ chỗ, chi trả và khung giá (`1673:34199`).
> **Khanh (16/10/2026):** "Hiện còn những gì chưa hoàn thiện của phần admin và op thì làm giúp tôi" — phần dữ liệu chưa có thiết kế: "Tự thiết kế + code" (ghi tài liệu, chờ duyệt).
> **Nhánh:** làm tiếp trên `TASK-ADM-004`, chưa commit.

## Trạng thái (16/10/2026) — 🔨 **Code xong, chưa commit — chờ Khanh review + CI**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).
- Chính sách mới **được lưu và quản lý** nhưng **chưa được dùng** ở luồng đặt vé / hoàn tiền / chi trả (chưa xây — `TASK-BTP-*`); `policy_snapshots` chưa tạo (G11).

## Đã làm

### DB — migration `20261016050000_platform_policies` (tự thiết kế, chờ duyệt — G1)

- `policy_versions`: `type` (`CANCELLATION` / `SEAT_HOLD` / `PAYOUT`), `operator_id` (null = mặc định nền tảng; chỉ hủy / hoàn tiền có phạm vi riêng nhà xe — OQ-13, BR-02), `version`, `status` (`DRAFT` / `PUBLISHED` / `CANCELLED`), `rules` (JSONB, Zod kiểm theo loại), `description`, `change_reason`, `effective_from`, người tạo / kích hoạt / hủy. Unique (loại, phạm vi, số phiên bản) và (loại, phạm vi, thời điểm hiệu lực) của bản đã kích hoạt; CHECK bản kích hoạt phải có lý do + hiệu lực.
- `commission_rules`: `operator_id` (null = mặc định), `rate_bps` (phần vạn, 500 = 5% — số nguyên, không float), `effective_from`, `effective_to` (không gồm, null = không thời hạn), `status` (`ACTIVE` / `CANCELLED`), `reason`, người tạo / ngừng + lý do ngừng.
- `fare_bands`: `name`, `min_price` / `max_price` (BIGINT VND, ít nhất một), `effective_from` / `effective_to`, `message` (nội dung cảnh báo nhà xe), `reason`, `status`, người tạo / hủy.
- RLS: ai cũng đọc chính sách / khung giá (thông tin công khai); nhà xe chỉ đọc hoa hồng mặc định + của mình; chỉ platform / system ghi.
- Dữ liệu nền (giá trị đã chốt, hiệu lực từ 11/05/2026): giữ chỗ 10 phút (OQ-06); chi trả T+3, chuyển khoản, Admin xác nhận thủ công, không ngưỡng (OQ-16, BR-32); hoa hồng mặc định 5% (OQ-18). **Hủy / hoàn tiền không seed** (chưa có mức chốt — G2).

### Backend

- `policy/` — quyền `finance:configure` (PLATFORM_ADMIN): `GET /admin/policies/{type}?operatorId=` (lịch sử phiên bản + trạng thái suy ra Nháp / Đã lên lịch / Đang áp dụng / Hết hiệu lực / Đã hủy, số nhà xe đang hoạt động, nhà xe có chính sách riêng), `POST /admin/policies/{type}/versions` (nháp), `GET/PUT /admin/policy-versions/{id}` (sửa nháp), `POST …/publish` (lý do; xác nhận lại danh tính; hiệu lực phải ở tương lai — UC-25 A5; phạm vi đã có bản chờ hiệu lực → 409 — A2), `POST …/cancel` (hủy nháp / bản đã lên lịch; bản đã có hiệu lực → 409). Hủy / hoàn tiền: các mốc "còn ≥ N giờ trước giờ khởi hành → hoàn X%", phải có mốc 0 giờ, không trùng mốc, sát giờ không hoàn cao hơn.
- `GET/POST /admin/fare-bands`, `POST /admin/fare-bands/{id}/cancel` (xác nhận lại danh tính).
- `commission/` — `GET /admin/commission-rules`, `POST` (mức riêng: bắt đầu ở tương lai, không chồng mức riêng khác của nhà xe — khóa dòng nhà xe), `PUT /{id}` (chưa bắt đầu: sửa tự do; đã bắt đầu: chỉ đổi ngày kết thúc ≥ hiện tại), `POST /{id}/cancel` (chưa bắt đầu → hủy; đang áp dụng → kết thúc ngay). Mọi thay đổi cần xác nhận lại danh tính.
- Mọi ghi + audit trong một transaction (`policy.create/update/publish/cancel`, `commission_rule.*`, `fare_band.*`); audit lỗi → 503 không đổi gì.
- Bảng giá nhà xe (`fare/`): `GET/POST/PUT /operator/fares*` trả thêm `bandWarnings` (quy tắc nằm ngoài khung giá còn hiệu lực / sắp tới; quy tắc có khung giờ chỉ xét khi giao thời gian với khung); lưu giá ngoài khung → audit `fare.band_warning` (OQ-17 "ghi nhận dữ liệu phục vụ kiểm tra"), **không chặn lưu**.

### Giao diện

- Admin `/policies` (tab `?tab=`): Hủy và hoàn tiền (ADM-06a: lịch sử phiên bản, thẻ Đang áp dụng, danh sách nhà xe có chính sách riêng → xem phạm vi riêng), Giữ chỗ / Chi trả (thẻ ADM-06d + lịch sử), Hoa hồng (ADM-06c: 3 thẻ số, bảng mức riêng, thêm / sửa / ngừng), Khung giá vé (bảng + thiết lập + hủy). `/policies/new`, `/policies/versions/{id}`: soạn phiên bản (ADM-06b: mốc, phạm vi, hiệu lực, mô tả, tóm tắt ảnh hưởng, lý do + TOTP; "Lưu nháp" / "Kích hoạt phiên bản"), xem phiên bản đã kích hoạt + "Hủy lịch".
- Operator OS — màn sửa Bảng giá: dải cảnh báo Figma `1665:24475` + từng khung đang bị vượt (tên, thời gian, khoảng giá, số quy tắc, nội dung Admin đặt); dòng quy tắc ngoài khung có biểu tượng cảnh báo (chỉ khi không có sửa đổi chưa lưu).

## Chờ Khanh (G1–G12)

| #   | Điểm | Đã làm theo | Cần Khanh |
| --- | ---- | ----------- | --------- |
| G1  | Schema 3 bảng | Như trên | Duyệt |
| G2  | Hủy / hoàn tiền mặc định | Không seed — tài liệu chưa có mức; Figma minh họa 24 giờ 90% / 4 giờ 50% / dưới 4 giờ 0% chỉ là ví dụ. Mốc chọn trong danh sách 0/1/2/3/4/6/12/24/48/72/168 giờ | Chốt mức mặc định v1 (tạo bằng màn này hoặc seed) |
| G3  | Chồng lịch (UC-25 A2) | Mỗi phạm vi tối đa một bản "Đã lên lịch"; muốn đổi thì hủy lịch rồi kích hoạt bản mới | Duyệt / cho nhiều bản lên lịch nối tiếp |
| G4  | Quyền | Đọc + ghi đều `finance:configure` (chỉ PLATFORM_ADMIN). Hỗ trợ nền tảng không xem được (dùng `finance:read` thì chủ nhà xe cũng có quyền này ở phạm vi tenant) | Duyệt / thêm quyền đọc riêng cho Hỗ trợ |
| G5  | Hoa hồng mặc định | 5% từ dữ liệu nền, **chưa sửa được trên giao diện** (Figma không có); "Hoa hồng ghi nhận tháng này" hiện "—" tới khi có thanh toán | Có cần sửa mức mặc định không |
| G6  | Ngày hiệu lực hoa hồng | Theo ngày (00:00 giờ VN), bắt đầu từ ngày mai; "Đến" là ngày cuối còn áp dụng; mức đang áp dụng chỉ đổi được ngày kết thúc; "Ngừng" mức đang áp dụng = kết thúc ngay | Duyệt |
| G7  | Phạm vi khung giá | Áp dụng **mọi tuyến**, giá tuyệt đối mỗi chỗ; nhiều khung được chồng nhau; không sửa (hủy rồi tạo lại) | Có cần khung theo tuyến / tỉnh, hay trần theo % so với giá kê khai |
| G8  | Cảnh báo khung giá | Máy chủ tính khi xem / lưu bảng giá; lưu giá ngoài khung ghi audit; không gửi thông báo cho nhà xe / Admin | Có cần báo Admin (danh sách nhà xe vượt khung) |
| G9  | Giữ chỗ / chi trả chưa được dùng | Seat hold hiện đặt cứng 10 phút (ADR-015); luồng đặt vé / chi trả chưa xây nên chưa đọc chính sách này | Đọc chính sách khi làm `TASK-BTP-*` |
| G10 | Chi trả | Chỉ sửa được số ngày T+n (1–30); kênh chuyển khoản + xác nhận thủ công + không ngưỡng là cố định (UC-25 A6, BR-32) | Duyệt |
| G11 | `policy_snapshots` | Chưa tạo bảng — booking chưa có (BR-07 chụp chính sách lúc đặt) | Làm cùng booking |
| G12 | Ô chọn nhà xe | Tìm theo tên / mã, tối đa 50 kết quả | Duyệt |

## Kiểm tra (16/10/2026)

- `admin-policy.int.spec.ts` 7 ca (dữ liệu nền; nháp + mốc sai 400 + sửa nháp + audit; kích hoạt quá khứ 422 / tương lai → lên lịch / bản thứ hai 409 / hủy lịch rồi kích hoạt; bản có hiệu lực: Đang áp dụng / Hết hiệu lực, không hủy được; RLS tenant không ghi; khung giá tạo / hủy / hủy lại 409; audit lỗi 503). `admin-commission.int.spec.ts` 5 ca (mặc định 5%; thêm: quá khứ 422, chồng 409, nối tiếp được; sửa trước / sau khi bắt đầu; ngừng lên lịch → hủy, đang áp dụng → hết hiệu lực; RLS; audit lỗi 503). `fare.int.spec.ts` thêm ca cảnh báo khung giá. `admin-policy.http.spec.ts` 14 ca (guard thật 13 route: 401 / 403 chủ nhà xe + hỗ trợ nền tảng / 401 `AUTH_REAUTH_REQUIRED`; validate).
- Unit: `apps/admin/lib/policy/policy-format.test.ts` 6 ca; `apps/operator-os/lib/fare/fare-format.test.ts` thêm ca gom cảnh báo.
- E2E Admin `policies.e2e.ts` 4 ca (phiên bản riêng nhà xe: lỗi mốc → nháp → kích hoạt TOTP → hủy lịch; giữ chỗ / chi trả nền; hoa hồng riêng thêm → hủy; khung giá lỗi sàn > trần → tạo → hủy).
- Đối chiếu Figma ADM-06a…06d ở 1440 px; 390 px không tràn ngang.
- 17/10/2026: `minimumAmount` của chi trả khai kiểu số nguyên VND có thể `null` (v1 buộc `null`) thay vì kiểu chỉ-`null` — Dart client sinh lớp `ModelNull` không build được; JSON không đổi. Thêm ca: khác `null` → 400 ở DTO.

## Việc tiếp theo

1. Khanh review, chốt G1–G12.
2. Đọc chính sách giữ chỗ / hủy / chi trả + chụp `policy_snapshots` khi làm booking / payment / payout.
