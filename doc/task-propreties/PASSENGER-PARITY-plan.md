# Kế hoạch sửa lỗi và đồng bộ Web – App hành khách

> Ngày lập: **14/11/2026**. Trạng thái: **chờ Khanh duyệt**.
> Đầu vào: [so-sanh-web-va-app-hanh-khach.md](../report/so-sanh-web-va-app-hanh-khach.md), mục 4 (34 điểm 4.1–4.34) và mục 2 (tính năng chỉ một bên có).
> Căn cứ để chốt: đặc tả màn SCR-PSG (`06-ui-ux-flow-specification.md` §6.3), SRS (`UC-35`, `FR-MKT-03/04/08/11`, `AS-14`, `AS-16`), `GLOSSARY`.
> Phạm vi: web `apps/marketplace`, app `apps/passenger_mobile`, API `apps/api` (chỉ phần phục vụ hai bên). Không thêm module, vendor hay quy tắc nghiệp vụ mới.

## 0. Nguyên tắc dùng để chốt

1. **Đặc tả màn là chuẩn chung.** Nội dung chức năng ghi trong SCR-PSG áp cho cả web và app. Bố cục được phép khác (cột lọc bên trái so với bảng trượt, form trên trang so với bảng chọn…). Bên nào lệch đặc tả thì bên đó sửa.
2. **Đặc tả không nói thì chọn cách đã có ở một bên**: ưu tiên cách an toàn hơn cho khách, ít việc hơn. Không làm tính năng mới để "cho giống".
3. **Đặc tả ghi rõ chỉ app** (hộp thư SCR-PSG-38, một công tắc mỗi loại thông báo SCR-PSG-12) thì giữ nguyên.
4. **v1 chỉ tiếng Việt, VND, giờ Việt Nam** (`AS-14`).

## 1. Quyết định

AI chốt theo yêu cầu của Khanh ngày 14/11/2026. Khanh đổi được bất kỳ dòng nào.

| # | Điểm lệch | Quyết định | Căn cứ | Bên sửa |
| --- | --- | --- | --- | --- |
| Q1 | Ba số tổng đài (4.2) | Mỗi nền tảng đọc số tổng đài từ **một cấu hình duy nhất**: web `NEXT_PUBLIC_SUPPORT_HOTLINE`, app `--dart-define=SUPPORT_HOTLINE`. **Bỏ ngay 1900 6067** vì đó là số tổng đài của nhà xe Phương Trang. Khi chưa có số thật: ẩn nút gọi, hiện email `support@vexenhanh.vn` | `AS-16` cho phép email hoặc ticket thay hotline | Web, App |
| Q2 | Ô đồng ý điều khoản (4.4) | Mặc định **chưa tick**, nút thanh toán khóa tới khi khách tự tick (như app) | SCR-PSG-20 trạng thái Empty: "Chưa đồng ý điều khoản → CTA vô hiệu"; NĐ 13/2023: im lặng không phải là đồng ý | Web |
| Q3 | Tra cứu vé (4.5, 4.22, 4.25) | Theo `UC-35`: email bắt buộc, **mã đặt vé tùy chọn** ở cả hai. Có mã thì mở thẳng đơn đó; không có mã thì liệt kê đơn 12 tháng. Đơn đặt bằng tài khoản: hỏi "Bạn có muốn đăng nhập không?", **vẫn cho xem chi tiết chỉ đọc**, chặn hủy vé và khiếu nại | `UC-35` bước 1, 5, 6, A1b; SCR-PSG-27, SCR-PSG-29 | App (chính), Web (khối mời đăng nhập) |
| Q4 | Tên hành khách từng chỗ (4.6) | **Mỗi chỗ phải có họ tên.** Chỗ 1 điền sẵn tên người liên hệ, sửa được. App bỏ việc tự lấy tên người liên hệ cho mọi chỗ để trống | `UC-04` bước 5 (thông tin hành khách đủ tối thiểu); danh sách hành khách cho nhà xe (`UC` manifest); web đã ghi "Họ tên cần khớp giấy tờ tùy thân khi lên xe" | App |
| Q5 | Danh sách cổng thanh toán (4.12) | Cả hai lấy **danh sách cổng đang bật từ API**. Thứ tự payOS, MoMo, VNPay, DEMO. Cổng chưa bật hiện mờ "Sắp hỗ trợ". Mặc định chọn cổng đầu tiên đang bật | SCR-PSG-20 Ideal (bốn thẻ, ADR-029 Proposed) và Partial/Edge ("Phương thức tạm không khả dụng") | API, Web, App |
| Q6 | Vé của tôi (S51–S53) | App làm theo SCR-PSG-24: **tab Sắp tới / Đã đi / Đã hủy / Tất cả có đếm + ô tìm mã hoặc tuyến** | SCR-PSG-24 Ideal | App |
| Q7 | Trạng thái hoàn tiền (4.15, 4.17) | Web hiện trạng thái hoàn tiền ở danh sách và khối "Thanh toán / hoàn tiền" ở vé đã hủy (số tiền hoàn, phương thức, mã hoàn, trạng thái). Một nhãn cho `REFUND_FAILED`: **"Hoàn tiền chưa thành công"**, kèm dòng phụ "Bộ phận hỗ trợ đang xử lý" ở chi tiết | `FR-MKT-11` (xem trạng thái hoàn tiền) | Web, App |
| Q8 | Tên loại chỗ (4.16) | Nhãn loại chỗ trên vé theo `GLOSSARY`: Ghế ngồi, **Giường đơn**, Giường đôi, **Cabin đơn**, Cabin đôi. Bộ lọc "Dạng chỗ" của xe (`BR-77`) giữ Ghế ngồi / Giường nằm / Cabin | `GLOSSARY` Seat type: `BED` = single berth, `CABIN` = single cabin | Web |
| Q9 | Ngày đi mặc định (4.19) | Cả hai **mặc định ngày mai** (app đang làm) | Đặc tả không nói; giữ cách đã có, bớt một bước chọn | Web |
| Q10 | Tìm theo nhà xe (4.18) | Cho chọn **"Tất cả tuyến"** ở cả hai (web đang làm) | Đặc tả không nói; ít ràng buộc hơn cho khách | App |
| Q11 | Ký hiệu tiền (4.29) | Màn của hành khách viết **"290.000đ"** (liền, chữ đ) như web và Figma marketplace. "₫" chỉ dùng ở Operator OS | `06 UI` dòng 697 chỉ quy định `₫` cho màn Bảng giá của nhà xe | App, API |
| Q12 | Cách hủy vé (4.32) | **Giữ khác biệt**: lý do đều tùy chọn (web tự nhập, app chọn sẵn). App hủy từng vé là đủ cho hủy một phần. Chỉ sửa chữ "Hoàn về DEMO" | SCR-PSG-26: "Lý do để trống vẫn cho hủy", hủy một phần `PARTIALLY_CANCELLED` | App (chữ) |
| Q13 | Nút "VI" trên web (4.33) | **Ẩn** | `AS-14`: v1 chỉ tiếng Việt | Web |
| Q14 | In vé / PDF trên app (4.34) | **Ẩn "Tải vé này (PDF)"**; app dùng "Chia sẻ vé" (Q17). In vé chỉ có trên web | Mã QR trong app là vé lên xe; không thêm thư viện PDF ở v1 | App |
| Q15 | Đăng nhập mạng xã hội | App **ẩn nút Facebook, Apple** khi chưa tích hợp. Web thêm nút Google ở giai đoạn 3, khi có cấu hình | ADR-020; SCR-PSG-07 | App, Web |
| Q16 | Khiếu nại trên app (4.14) | **Làm màn khiếu nại trên app** bằng API đã có: danh sách, gửi, trao đổi. Đính kèm tệp làm đợt sau | `06 UI` §4: app có "support trên mobile"; SCR-PSG-30/31/32 | App |
| Q17 | Bản đồ, chia sẻ ở chi tiết vé | App thêm **"Mở chỉ đường Goong"** (cùng link với web) và **"Chia sẻ vé"**. Bản đồ nhúng làm ở giai đoạn 3 | SCR-PSG-25 ("bản đồ điểm đón; in / chia sẻ / hủy"); ADR-027 | App |
| Q18 | Lọc và sắp xếp chuyến | Web thêm lọc **Nhà xe, Tiện ích** và sắp xếp **"Đánh giá cao nhất"** (app đã có). Lọc theo điểm đón/trả và theo đánh giá: cả hai chưa có, để sau | `FR-MKT-03`, `FR-MKT-04` | Web |
| Q19 | Ghi chú cho nhà xe | App thêm ô ghi chú, tối đa 300 ký tự (như web) | `FR-MKT-08` ("ghi chú hợp lệ cho booking") | App |
| Q20 | Đánh giá trong chi tiết vé | Web thêm khối đánh giá dưới thẻ vé (như app) | SCR-PSG-25 Partial/Edge (chờ duyệt) | Web |
| Q21 | Hộp thư, cài đặt thông báo | **Giữ khác biệt**: hộp thư chỉ app; app một công tắc mỗi loại | SCR-PSG-38, SCR-PSG-12 (bản 02/11) | — |
| Q22 | "Đánh giá của tôi" dữ liệu mẫu (4.1) | Lấy lại phần sửa **chưa commit** ở worktree `.claude/worktrees/my-reviews-real-data-042393` (thêm `GET /me/reviews`), đọc lại toàn bộ trước khi dùng, áp lên nhánh mới. Nếu không dùng được thì làm như web | Code đã viết sẵn, có test | API, App |
| Q23 | Ảnh báo cáo ~177 MB | Chuyển ảnh trong `doc/report/screenshots/` sang JPEG chất lượng 80 (ước 20–30 MB), sửa liên kết trong tài liệu. Không commit PNG gốc | Giữ repo nhẹ | Tài liệu |
| Q24 | Nhánh làm việc | Nhánh mới `fix/passenger-parity` từ `master` (CLAUDE.md §4.7). 13 sửa web ngày 12/11 (đang chưa commit trên `feat/new-notification`) commit trước thành một commit riêng | Tách khỏi nhánh thông báo chưa merge | — |

**Còn chờ Khanh:**

- Số tổng đài thật của sàn (Q1). Chưa có thì giữ trống, giao diện tự ẩn nút gọi.
- Có bật cổng DEMO trên production không (Q5). ADR-029 vẫn Proposed; cổng DEMO cho thanh toán không mất tiền.
- Duyệt các đoạn đặc tả đang "chờ duyệt" mà quyết định dựa vào: `UC-35` bản 27/10, SCR-PSG-12 bản 02/11, khối đánh giá ở SCR-PSG-25.

## 2. Việc cần làm theo giai đoạn

Ước lượng: **S** ≤ 2 giờ, **M** ≤ 1 ngày, **L** > 1 ngày. Đường dẫn web tính từ `apps/marketplace/`, app từ `apps/passenger_mobile/lib/`, API từ `apps/api/src/`.

### Giai đoạn 1 — Sửa nhanh, rủi ro thấp (~1–1,5 ngày)

**Web**

| Mã | Việc | Vị trí | Kiểm chứng | Ước lượng |
| --- | --- | --- | --- | --- |
| W1 | Ô đồng ý điều khoản mặc định chưa tick (Q2) | `components/payment/payment-page-view.tsx:36` (`useState(true)` → `false`) | Test: chưa tick thì nút thanh toán khóa | S |
| W2 | Thêm dòng "Ưu đãi" vào kết quả tra cứu (4.9) | `components/tickets/lookup-result/lookup-actions-sidebar.tsx` (khối Thanh toán), làm theo `components/ticket-detail/ticket-payment-sidebar.tsx:52` | Test mapper: đơn có mã giảm hiện −43.500đ; tổng khớp | S |
| W3 | Bỏ câu "Áp dụng voucher khi đặt vé trên web hiện chưa khả dụng" (4.10) | `components/vouchers/vouchers-view.tsx:125`, `components/loyalty/loyalty-view.tsx:162`, `components/loyalty/loyalty-redeem-modal.tsx:261` | Không còn chuỗi này trong code | S |
| W4 | "Lên xe quét mã" chỉ hiện với vé còn hiệu lực (4.24) | `components/ticket-detail/boarding-pass-card.tsx:151` | Vé đã dùng / đã hủy không có dòng này | S |
| W5 | Kết quả tra cứu: đơn hoặc email đã có tài khoản thì mời "Đăng nhập", không mời "Tạo tài khoản" (4.25, Q3) | `components/tickets/lookup-result/lookup-actions-sidebar.tsx:159` | Test hai trường hợp có / không có tài khoản | S |
| W6 | Trang Hành trình khi chưa đăng nhập ghi đúng ngữ cảnh (4.31) | `components/account/account-sign-in-required.tsx` (thêm prop mô tả); `app/my-tickets/page.tsx` | Xem trang `/my-tickets` khi chưa đăng nhập | S |
| W7 | Ẩn nút "VI" (Q13) | Thanh trên của trang hành khách (`components/passenger-topbar.tsx`, `components/home/search-hero.tsx`) | Không còn nút ngôn ngữ | S |
| W8 | Sửa "Vé xe nhanh" → "Vé Xe Nhanh" (4.28) | `components/home/plus-and-guide.tsx:40` | — | S |
| W9 | Nhãn loại chỗ theo GLOSSARY (Q8) | `lib/data/booking-mappers.ts:45` (`BED` → "Giường đơn", `CABIN` → "Cabin đơn"); sửa `lib/data/booking.test.ts` | Vitest | S |
| W10 | Tổng đài một nguồn (Q1) | Module mới đọc `NEXT_PUBLIC_SUPPORT_HOTLINE`; thay 6 chỗ: `app/error.tsx:67`, `components/home/search-hero.tsx:149`, `components/passenger-topbar.tsx:61`, `components/site-footer.tsx:41`, `components/tickets/lookup/lookup-form-step.tsx:156`, `lib/preview/fixtures/content.ts:380` | Không còn "1900 6067"; biến trống thì ẩn số, hiện email | S–M |
| W11 | Nhãn thiết bị ở trang phiên đăng nhập bằng tiếng Việt (4.23) | Trang `app/account/sessions`; dịch như app `features/account/login_sessions_screen.dart:29` ("on" → "trên", "Mobile app" → "Ứng dụng di động") | Test hàm dịch | S |

**App**

| Mã | Việc | Vị trí | Kiểm chứng | Ước lượng |
| --- | --- | --- | --- | --- |
| A1 | Bộ chọn ngày tiếng Việt (4.11) | Thêm `flutter_localizations` (gói có sẵn trong SDK) vào `pubspec.yaml`; `MaterialApp`: `locale: Locale('vi')`, `supportedLocales`, `localizationsDelegates`. Ảnh hưởng `features/search/trip_search_form.dart:178`, `features/account/edit_profile_screen.dart:168` | Widget test: lịch hiện "Tháng 11" | S |
| A2 | Snackbar "Đơn … đặt bằng tài khoản" tự tắt và không bám sang màn khác (4.8) | `features/journey/guest_journey_flow.dart:122`: thời lượng ngắn + `hideCurrentSnackBar()` khi rời màn, đổi tab, mở đăng nhập | Widget test; OTP sai hiện được lỗi | S |
| A3 | Bỏ chữ "Support Station" (4.26) | `features/home/home_screen.dart:2237` | — | S |
| A4 | Nhãn trợ năng cho nút đảo chiều (4.27) | `features/home/home_screen.dart:772` (`Semantics` hoặc `Tooltip` "Đảo chiều điểm đi - điểm đến") | Widget test tìm theo nhãn | S |
| A5 | Danh sách Khu vực, Tuyến phục vụ theo ABC tiếng Việt (4.20) | `features/ticket/ticket_screen.dart`; hàm so sánh dùng chung đặt ở `packages/mobile_shared` | Unit test thứ tự: Đắk Lắk, Điện Biên đứng sau Cà Mau | S |
| A6 | Tìm bài có kết quả thì không hiện "Chưa có bài viết trong chuyên mục này" (4.21) | `features/explore/explore_screen.dart:968` | Widget test | S |
| A7 | "Hoàn về DEMO" → tên cổng (4.30) | `journeyProviderLabel` (`features/journey/guest_ticket_detail_screen.dart:2707`): DEMO → "cổng thử nghiệm" | Unit test | S |
| A8 | Ẩn nút Facebook, Apple chưa tích hợp (Q15) | `features/auth/auth_screen.dart:2379` | Widget test | S |
| A9 | Ẩn "Tải vé này (PDF)" (Q14) | `features/ticket/payment_completion_screen.dart:268` | — | S |
| A10 | Tổng đài một nguồn (Q1) | Đọc `SUPPORT_HOTLINE` một chỗ; thay `features/account/guest_account_screen.dart:5`, `features/home/home_screen.dart:102` và `:2379`, `features/journey/guest_ticket_detail_screen.dart:367`, `main.dart:1310`, `features/auth/auth_screen.dart:1327` và `:1349` | Không còn số cứng; trống thì ẩn nút gọi | S–M |
| A11 | Nhãn hoàn tiền lỗi "Hoàn tiền chưa thành công" (Q7) | Chỗ đặt nhãn `REFUND_FAILED` trong `features/journey/` | Unit test | S |
| A12 | Ký hiệu tiền "đ" (Q11) | `packages/mobile_shared/lib/src/money/vnd.dart:9`, `:18`; hàm đọc ngược nhận cả "₫" và "đ". App nhân viên không dùng hàm này | Test của `mobile_shared` | S |

**API**

| Mã | Việc | Vị trí | Kiểm chứng | Ước lượng |
| --- | --- | --- | --- | --- |
| P1 | Thông báo voucher dùng "đ" (Q11) | `promotion/promotion-apply.ts:76` | Vitest `promotion-apply.spec.ts` | S |
| P2 | Chẩn đoán VNPay trả 99 cho tra cứu giao dịch và hoàn tiền (4.3) | `external/payment/vnpay/vnpay-gateway.ts:182` (querydr) và nhánh refund: khi phản hồi thiếu chữ ký vẫn đọc `vnp_ResponseCode` / `vnp_Message` để ghi log và ném lỗi có mã (không dùng để đổi trạng thái). Gọi thử sandbox với một đơn vừa trả; đối chiếu tham số với tài liệu VNPay; xem log production **chỉ đọc** | Test bắt buộc thanh toán (ADR-025); ghi kết quả vào tài liệu so sánh mục 5 | M |

**Tài liệu**

| Mã | Việc | Ước lượng |
| --- | --- | --- |
| R1 | Nén ảnh báo cáo sang JPEG (Q23), sửa liên kết trong `so-sanh-web-va-app-hanh-khach.md` | S |

### Giai đoạn 2 — Đồng bộ hành vi theo đặc tả (~4 ngày)

**API** (làm trước, web và app cần P3)

| Mã | Việc | Vị trí | Kiểm chứng | Ước lượng |
| --- | --- | --- | --- | --- |
| P3 | `GET /v1/payment-providers` công khai: trả cổng đã cấu hình và trạng thái bật (Q5) | Đọc map cổng ở `external/payment/payment-gateway.ts:131`; OpenAPI; sinh lại `packages/api-client` và `packages/api_client_dart`; cập nhật `05-api-specification.md` (chờ duyệt) | HTTP spec: cổng chưa cấu hình trả `enabled: false` | S–M |

**Web**

| Mã | Việc | Vị trí | Kiểm chứng | Ước lượng |
| --- | --- | --- | --- | --- |
| W12 | Ngày đi mặc định là ngày mai (Q9) | Form tìm chuyến trang chủ (`components/home/search-hero.tsx`) | Test form | S |
| W13 | Trạng thái hoàn tiền ở danh sách và chi tiết vé đã hủy (Q7) | Nhãn ở `lib/data/booking-mappers.ts:75` và thẻ đơn; khối "Thanh toán / hoàn tiền" ở `components/ticket-detail/ticket-payment-sidebar.tsx` | Vitest mapper; xem lại S53, S56 | M |
| W14 | Lọc Nhà xe, Tiện ích; sắp xếp "Đánh giá cao nhất" (Q18) | `components/trips/live-trip-filters.tsx`, `components/trips/trip-list-header.tsx:56`; dữ liệu `amenities`, điểm đánh giá đã có trong kết quả tìm | Vitest lọc; so S10, S11 | M |
| W15 | Khối đánh giá dưới thẻ vé (Q20) | Chi tiết vé; dùng lại form ở "Đánh giá của tôi"; chỉ khi chuyến `COMPLETED` và vé `USED` / `CHECKED_IN` | Vitest; xem lại S55 | M |
| W16 | Đếm ngược hiệu lực OTP khi đăng nhập | `components/auth/verify-email-view.tsx:212` (SCR-PSG-09) | Test | S |
| W17 | Danh sách cổng lấy từ API (Q5) | Trang thanh toán; dùng P3 | Vitest; xem lại S62 | M |

**App**

| Mã | Việc | Vị trí | Kiểm chứng | Ước lượng |
| --- | --- | --- | --- | --- |
| A13 | Tra cứu vé theo `UC-35` (Q3): ô mã đặt vé tùy chọn; có mã mở thẳng đơn; đơn tài khoản hỏi đăng nhập một lần rồi mở chi tiết chỉ đọc (ẩn hủy và khiếu nại); nhãn "Đặt bằng tài khoản" trong danh sách; dòng "Không còn dùng email đặt vé? Gọi CSKH" | `features/journey/guest_journey_flow.dart`, `features/journey/journey_api.dart:316`, `features/journey/guest_ticket_results_screen.dart`, `features/journey/guest_ticket_detail_screen.dart`, `features/account/guest_account_screen.dart:117` | Widget test các nhánh; xem lại S30–S33 | M–L |
| A14 | Họ tên bắt buộc từng chỗ, chỗ 1 điền sẵn (Q4) | `features/ticket/passenger_information_screen.dart:159` và `:260–275` | Widget test 2 chỗ: chỗ 2 trống thì khóa "Tiếp tục" | S–M |
| A15 | Tìm theo nhà xe cho "Tất cả tuyến" (Q10) | `features/search/trip_search_form.dart:276` | Widget test | S |
| A16 | Ô ghi chú cho nhà xe, tối đa 300 ký tự (Q19) | `features/ticket/passenger_information_screen.dart`; gửi kèm khi tạo đơn | Widget test; kiểm đơn có ghi chú | S |
| A17 | Vé của tôi: tab có đếm + ô tìm (Q6) | `MyJourneyFlow` (`main.dart`) và `features/journey/` | Widget test lọc tab; xem lại S51–S53 | M |
| A18 | "Đánh giá của tôi" dữ liệu thật (Q22) | Worktree `my-reviews-real-data-042393`: `review/review.controller.ts`, `review/review.service.ts`, `features/account/my_reviews_screen.dart`, `main.dart` `_loadMyReviews` + test; sinh lại hai client | Vitest API + `flutter test`; xem lại S47 | M |
| A19 | Chuyên mục Khám phá lấy từ API, có đếm số bài (4.7) | `features/explore/explore_screen.dart` (bỏ 3 chip cố định); `GET /v1/article-categories` | Widget test; xem lại S23 | M |
| A20 | Voucher không đủ điều kiện ở bước đặt vé: khóa và ghi lý do (S59) | Bảng "Chọn từ ví voucher" ở bước Thông tin | Widget test với đơn 290.000đ và mã tối thiểu 300.000đ | S–M |
| A21 | OTP: hiện lỗi sai mã và "Còn N lần thử" (SCR-PSG-09, SCR-PSG-28) | `features/auth/auth_screen.dart` và màn OTP tra cứu | Widget test | S |
| A22 | Chi tiết vé: "Chia sẻ vé" và "Mở chỉ đường Goong" (Q17) | `features/journey/guest_ticket_detail_screen.dart` | Widget test có hai nút | S–M |
| A23 | Danh sách cổng lấy từ API (Q5) | `features/ticket/payment_screen.dart:249` (thay `PassengerPaymentMethod.values`); dùng P3 | Widget test: chỉ VNPay bật thì mặc định VNPay | S–M |

### Giai đoạn 3 — Tính năng app còn thiếu theo đặc tả (~1,5–2 tuần)

| Mã | Việc | Căn cứ | Ước lượng |
| --- | --- | --- | --- |
| A24 | Khiếu nại trên app (Q16): danh sách `GET /me/support-tickets`, gửi `POST /bookings/{id}/support-tickets`, chi tiết + trao đổi (`GET …/{ticketId}`, `POST …/messages`). Mở từ chi tiết vé (thay nút "Gửi yêu cầu" đang chỉ gọi tổng đài) và từ Tài khoản. Đính kèm (`support-attachments/upload-url`) làm đợt sau | SCR-PSG-30/31/32 | L |
| A25 + P4 | Quay về app sau cổng mở bằng trình duyệt (4.13): API nhận loại client khi tạo thanh toán và trả `returnUrl` mà app bắt được (App Links qua `app_links`, cần `assetlinks.json` trên web); app tự kiểm tra trạng thái khi được mở lại | ADR-028 (`app_links`), SCR-PSG-21 | M–L |
| A26 | FAQ: ô tìm, gợi ý nhanh, khối liên hệ CSKH | SCR-PSG-03 | S–M |
| A27 | Ví voucher: tab Khả dụng / Đang giữ / Đã dùng / Hết hạn | SCR-PSG-36 | S–M |
| A28 | Lịch sử điểm: 4 thẻ tổng, tab theo loại, lọc thời gian | SCR-PSG-34 | M |
| A29 | Bài viết liên quan cùng chuyên mục | SCR-PSG-37 | S |
| A30 | Chi tiết chuyến: đánh giá nhà xe và bản đồ điểm dừng (`maplibre_gl` + nền Goong) | SCR-PSG-16, ADR-027 | L |
| W18 | Web: nút đăng nhập Google khi có cấu hình (`/auth/callback` đã có) | ADR-020, SCR-PSG-07 | M |

### Không làm hoặc để sau (theo quyết định)

| Nội dung | Lý do |
| --- | --- |
| Hộp thư thông báo trên web | SCR-PSG-38 chỉ cho app (Q21) |
| Đổi cài đặt thông báo cho giống nhau | SCR-PSG-12 bản 02/11: app một công tắc mỗi loại (Q21) |
| Cách nhập lý do hủy, hủy nhiều vé trên app | Đều đúng đặc tả (Q12) |
| In vé, tải PDF trên app | Q14 |
| Lọc theo điểm đón/trả và theo đánh giá | `FR-MKT-03` có, nhưng cả hai đều chưa làm → backlog chung |
| Gửi lại email vé ở màn thành công | SCR-PSG-22 có, cả hai đều chưa làm → backlog chung |
| Đổi bố cục cho giống nhau (bộ lọc, form, bảng chọn) | Khác nền tảng, không sai (nguyên tắc 1) |

## 3. Thứ tự làm, nhánh và cách kiểm chứng

1. **Chuẩn bị (Q24):** tạo `fix/passenger-parity` từ `master`; commit riêng 13 sửa web ngày 12/11. Nếu chuyển nhánh bị xung đột với `feat/new-notification` thì dừng lại hỏi Khanh.
2. **Giai đoạn 1** chia ba luồng độc lập (web, app, API), không đụng chung file, làm song song được. P2 (VNPay) làm sớm vì mức Cao.
3. **Giai đoạn 2:** P3 trước, rồi W17 và A23. Các việc còn lại độc lập.
4. **Giai đoạn 3** sau khi Khanh duyệt giai đoạn 2.
5. Mỗi việc một commit, message ghi mã việc (vd `fix(marketplace): W1 ô đồng ý điều khoản mặc định chưa tick`). Commit và push khi Khanh yêu cầu (CLAUDE.md §4.7).

**Kiểm chứng sau mỗi giai đoạn:**

- Web: `pnpm --filter @vexenhanh/marketplace lint`, `typecheck`, `test`.
- App: `flutter analyze`, `flutter test`; build lại APK debug.
- API: Vitest; test bắt buộc với phần thanh toán (P2, P3, P4 — ADR-025); sinh lại client khi đổi OpenAPI.
- Chụp lại các màn S liên quan trên DB nhân bản `vxn_web_shots` (API cô lập cổng 3100) và cập nhật tài liệu so sánh.
- Review code chỉ chạy khi Khanh yêu cầu (CLAUDE.md §4.8); báo cáo ghi rõ phần chưa review.

**Tài liệu SDLC cần cập nhật khi làm** (ghi "chờ duyệt", không tự promote): `05-api-specification.md` (P3, P4, `GET /me/reviews`), `06-ui-ux-flow-specification.md` (Q2, Q5, Q6, Q8, Q17).

## 4. Truy vết 34 điểm → việc

| Điểm | Việc | Điểm | Việc |
| --- | --- | --- | --- |
| 4.1 | A18 | 4.18 | A15 |
| 4.2 | W10, A10 | 4.19 | W12 |
| 4.3 | P2 | 4.20 | A5 |
| 4.4 | W1 | 4.21 | A6 |
| 4.5 | A13, W5 | 4.22 | A13 |
| 4.6 | A14 | 4.23 | W11 |
| 4.7 | A19 | 4.24 | W4 |
| 4.8 | A2, A21 | 4.25 | W5 |
| 4.9 | W2 | 4.26 | A3 |
| 4.10 | W3 | 4.27 | A4 |
| 4.11 | A1 | 4.28 | W8 |
| 4.12 | P3, W17, A23 | 4.29 | A12, P1 |
| 4.13 | A25, P4 | 4.30 | A7 |
| 4.14 | A24 | 4.31 | W6 |
| 4.15 | W13 | 4.32 | Không làm (Q12) |
| 4.16 | W9 | 4.33 | W7 |
| 4.17 | A11 | 4.34 | A9 |

Tổng: giai đoạn 1 có 25 việc (11 web, 12 app, 2 API) + R1; giai đoạn 2 có 18 việc; giai đoạn 3 có 8 việc.
