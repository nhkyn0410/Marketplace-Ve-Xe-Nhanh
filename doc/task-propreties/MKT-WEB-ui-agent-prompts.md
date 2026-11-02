# Bộ prompt dựng giao diện Marketplace web (cho agent khác)

> Soạn 14/10/2026 theo yêu cầu của Khanh: agent khác dựng giao diện `apps/marketplace` bám Figma, kiểm bằng ảnh chụp sau từng phần, chỗ chưa có API thì hiện trạng thái lỗi / ghi log, **không đụng API**.
>
> Phần A là tài liệu tham chiếu agent phải đọc. Phần B là các prompt Khanh dán vào agent.

## Cách dùng (cho Khanh)

1. **Trước khi giao:** commit hoặc cất phần đang dở trên nhánh hiện tại. Agent sẽ dừng nếu thấy file thay đổi không phải của nó. **Không commit file này cùng phần đang dở:** để nguyên chưa commit để file đi theo khi agent tạo nhánh mới từ `develop`. Commit nó lên nhánh khác thì file sẽ biến mất khỏi thư mục làm việc khi agent đổi nhánh.
2. **Không cần dán Phần A vào agent.** Prompt 0 bảo agent tự đọc file này trong repo; chỉ dán các prompt ở Phần B. Chỉ dán Phần A khi agent không đọc được file trong `C:\Code\Ve_Xe_Nhanh`.
3. **Agent cần ba khả năng:** đọc Figma (MCP Figma: lấy ảnh một khung + thông tin thiết kế), chạy lệnh shell, chụp màn hình trang web. Không đọc được Figma thì Khanh xuất sẵn PNG từng khung (rộng 1440) vào `tmp/marketplace-ui/<SCR>/<trạng thái>/figma.png` — so được bố cục nhưng kém chính xác hơn.
4. **Không cần chạy API.** Muốn form tìm chuyến có danh sách tỉnh thật thì chạy API ở cổng 3000.
5. **Thứ tự dán:** Prompt 0 đầu mỗi phiên → Prompt 1 một lần (lô 0) → Prompt 2 cho từng lô 1…8 → Prompt 3 cuối mỗi lô. Agent lạc hướng thì dán câu tương ứng ở Prompt 4.
6. **Điểm Khanh có thể đổi trước khi giao:** bảng route (A2), các dòng ở A3, danh sách gói được thêm (A4).

---

## Phần A — Tham chiếu

### A1. Nguồn thiết kế

- File Figma `UI-UX`, fileKey `6c81q3DdHVS0anfDw2sVVj`. Link một khung: `https://www.figma.com/design/6c81q3DdHVS0anfDw2sVVj/UI-UX?node-id=<id, đổi ":" thành "-">`.
- **Chỉ dùng** trang `Web_Bản mới` (`653:238`), mục `Giao diện khách hàng` (`674:290`). Khung rộng 1440, chỉ có bản máy tính.
- **Không dùng** bộ cũ ở trang `Web_Bản cũ` (mục `381:2`, khung rộng 1920, mã node `385:xxxx`), kể cả khi `doc/SDLC/06-ui-ux-flow-specification.md` §6 còn trỏ tới đó.
- Bộ thành phần của khách hàng: mục `VXN / Passenger · Components` (`1434:11275`) — thanh bên `1436:12785` (biến thể `Active=<mục>`, `Auth=Guest|User`), footer `1434:11609`, thanh trên `1434:11610`, các bước đặt vé `1436:12882`, ô chỗ `1436:12918` (`Loại=Đơn|Đôi`), đồng hồ giữ chỗ `1436:12943`, vé `1456:23922`.
- Mã màn `SCR-PSG-NN` khớp 06 UI §6.1 (mô tả trạng thái từng màn ở §6.3).

### A2. Danh sách khung theo lô

"API" = endpoint ở 05 API §7.2. **Chỉ năm GET `/catalog/*` đã có thật**; mọi endpoint khác chưa được code. Route là đề xuất, đổi được khi có API.

| Lô | Mã | Khung Figma (node) | Route | Tên preview | API |
| --- | --- | --- | --- | --- | --- |
| 0 | Khung trang | Thanh bên + footer trong `776:791`; kit `1436:12785`, `1434:11609` | `app/layout.tsx` | `?as=user` (biến thể đã đăng nhập) | — |
| 0 | SCR-PSG-05 | Lỗi 404 `1449:21608` | `app/not-found.tsx` | — | — |
| 0 | SCR-PSG-05 | Lỗi 500 `1449:21863` | `app/error.tsx` | — | — |
| 0 | SCR-PSG-05 | Lỗi 403 `1449:21736`, 503 `1449:21999` | component `ForbiddenState`, `ServiceUnavailableState` | — | — |
| 1 | SCR-PSG-01 | Trang chủ đủ trang `776:791`; tab Theo chuyến `830:592`; tab Theo nhà xe `836:113`; Theo nhà xe đang mở chọn nhà xe `837:131` | `/` | `ideal`, `operator-tab`, `operator-picker` | Tỉnh: `GET /catalog/provinces` ✅. Địa danh: `GET /catalog/stop-points?q=` ✅. Danh sách nhà xe, tuyến phổ biến, nhà xe đối tác, cẩm nang: ❌ |
| 2 | SCR-PSG-15 | Danh sách chuyến `1440:11297`; Empty `1450:22017`; Loading `1450:22373` | `/trips` | `ideal`, `empty`, `loading` | `GET /trips/search` ❌ |
| 2 | SCR-PSG-16 | Chi tiết chuyến `1443:11643` | `/trips/[tripId]` | `ideal` | `GET /trips/{tripId}` ❌ |
| 2 | SCR-PSG-17 | Trang nhà xe `1443:12312` | `/operators/[operatorId]` | `ideal` | `GET /operators/{operatorId}/public-profile` ❌ |
| 3 | SCR-PSG-18 | B1 chọn điểm + chỗ `1443:12719`; Error chỗ vừa bị giữ `1450:22717` | `/trips/[tripId]/seats` | `ideal`, `error` | `POST /seat-holds` ❌ |
| 3 | SCR-PSG-19 | B2 thông tin hành khách `1444:12531`; Stale giá đổi `1450:22911` | `/checkout/[holdId]` | `ideal`, `stale` | `POST /bookings` ❌ |
| 3 | SCR-PSG-20 | B3 thanh toán `1444:13055`; Error hết giờ giữ `1450:23099` | `/bookings/[bookingId]/payment` | `ideal`, `expired` | `GET /bookings/{bookingId}`, `POST /bookings/{bookingId}/payments` ❌ |
| 4 | SCR-PSG-21/22/23 | Chờ xác nhận `1444:13464`; thành công `1444:13772`; thất bại `1444:14189` | `/bookings/[bookingId]/payment/result` | `processing`, `success`, `failed` | ❌ |
| 4 | SCR-PSG-24 | Vé của tôi `1445:14030`; Empty `1450:23264` | `/my-tickets` | `ideal`, `empty` | ❌ (05 API chưa có endpoint danh sách vé) |
| 4 | SCR-PSG-25 | Chi tiết vé `1445:14456` | `/my-tickets/[ticketId]` | `ideal` | `GET /tickets/{ticketId}` ❌ |
| 4 | SCR-PSG-26 | Hủy vé (hộp thoại) `1456:23988` | trên trang SCR-PSG-25 | `cancel` | ❌ |
| 5 | SCR-PSG-27/28 | Tra cứu B1 `1446:14982`; B2 OTP `1446:15277` | `/tickets/lookup` | `ideal`, `otp` | `POST /guest/ticket-lookup` ❌ |
| 5 | SCR-PSG-29 | Kết quả tra cứu `1446:15578` | `/tickets/lookup/result` | `ideal` | ❌ |
| 5 | SCR-PSG-30/31 | Khiếu nại của tôi `1446:16033`; gửi khiếu nại (hộp thoại) `1446:16390` | `/support` | `ideal`, `complaint` | ❌ |
| 5 | SCR-PSG-32 | Khiếu nại của Guest `1446:16579` | `/support/guest` | `ideal` | ❌ |
| 6 | SCR-PSG-07/08/09/10 | Đăng nhập `1447:16634`; tạo tài khoản `1447:17057`; nhập OTP `1447:17487`; OAuth callback `1447:17897` | `/login`, `/register`, `/verify-email`, `/auth/callback` | `ideal` | ❌ (`/auth/otp/*` có nhưng chỉ chế độ Bearer, trình duyệt bị CORS chặn → coi như chưa có) |
| 6 | SCR-PSG-11/12/13/14 | Tài khoản `1447:18295`; thông báo `1447:18811`; phiên đăng nhập `1448:18809`; đánh giá `1448:19193` | `/account`, `/account/notifications`, `/account/sessions`, `/account/reviews` | `ideal` | ❌ |
| 7 | SCR-PSG-33/35 | VXN Plus `1448:19617`; đổi điểm (hộp thoại) `1448:20406` | `/plus` | `ideal`, `redeem` | `GET /me/loyalty`, `POST /me/loyalty/redemptions` ❌ |
| 7 | SCR-PSG-34 | Lịch sử điểm `1448:19985` | `/plus/history` | `ideal` | `GET /me/loyalty/transactions` ❌ |
| 7 | SCR-PSG-36 | Ví voucher `1448:20565` | `/account/vouchers` | `ideal` | `GET`/`POST /me/vouchers` ❌ |
| 8 | SCR-PSG-02/37 | Khám phá `1449:20595`; chi tiết bài `1449:20924` | `/explore`, `/explore/[slug]` | `ideal` | `GET /articles`, `/articles/{slug}`, `/article-categories` ❌ |
| 8 | SCR-PSG-03 | Câu hỏi thường gặp `1449:21249` | `/faq` | `ideal` | ❌ (nội dung do Admin quản lý) |
| 8 | SCR-PSG-06 | Trang pháp lý `1449:22136` | `/legal/[slug]` | `ideal` | ❌ (nội dung do Admin quản lý) |

Khung `830:1321` (hộp thoại đăng nhập trên trang chủ) **không dựng** — đăng nhập theo SCR-PSG-07 (xem A3 #1).

### A3. Quyết định đã chốt thắng Figma

Gặp chỗ Figma khác các dòng dưới → làm theo dòng dưới **và** ghi vào sổ lệch (A8). Ngoài các dòng này, Figma là chuẩn.

| # | Quy tắc | Đã thấy trong bộ mới |
| --- | --- | --- |
| 1 | Hành khách đăng nhập bằng mã OTP qua **email** hoặc Google / Facebook / Apple. Không mật khẩu, không số điện thoại | Ô "Nhập Email hoặc Số điện thoại" trong `830:1321` |
| 2 | Thanh toán trước, chỉ **VNPay** (QR / ATM / thẻ quốc tế là lựa chọn con của VNPay) và **MoMo**. Không tiền mặt, không ZaloPay | — |
| 3 | Giữ chỗ **10 phút**. Đồng hồ đếm theo thời điểm hết hạn trong dữ liệu, không viết cứng | — |
| 4 | Bản đồ **chỉ** dùng `MapView`, `MapMarker`, `MapLine`, `MapPopup` của `@vexenhanh/ui` (bản đồ Goong, hiện đúng Hoàng Sa / Trường Sa). Thiếu khóa bản đồ thì ẩn. Cấm Leaflet, OpenStreetMap, Google Maps, ảnh chụp bản đồ | — |
| 5 | Không có SMS. Chữ trên giao diện chỉ nói email | — |
| 6 | Chính sách hoàn / hủy lấy từ dữ liệu của từng chuyến, không viết cứng vào chữ giao diện. Chưa có đổi vé tự phục vụ: link "Đổi và hủy vé" ở footer giữ như Figma nhưng trỏ `/legal/refund-policy` | Link "Đổi và hủy vé" ở footer trang chủ |
| 7 | **Không dựng** mục "Dịch vụ bổ trợ" (SRS không có, `UX-OQ-07` còn mở) | Mục này có trên thanh bên mọi khung |
| 8 | Giao diện **không tự tính tiền**. Giá, phí, giảm, tổng đều lấy từ dữ liệu. Dòng "Phí dịch vụ" chỉ hiện khi dữ liệu có (SRS chưa có quy tắc phí) | Dòng "Phí dịch vụ" ở B2, B3, B4, chi tiết vé, tra cứu, hủy vé |
| 9 | Hạng VXN Plus chỉ là hệ số tích điểm: không giảm giá theo hạng, không ưu tiên hỗ trợ | — |

### A4. Vùng được sửa

**Được sửa**
- `apps/marketplace/**` (trừ `.next/`, `node_modules/`).
- Thêm file **mới** trong `packages/ui/src/components/`. Không sửa file có sẵn trong `packages/ui` (Operator OS dùng chung).
- `apps/marketplace/package.json` và `pnpm-lock.yaml`, chỉ để thêm gói trong danh sách dưới.
- `doc/task-propreties/MKT-WEB-ui-todo.md` (file theo dõi của agent, A8).

**Gói được thêm vào `apps/marketplace`** (cùng phiên bản với `apps/operator-os/package.json`): `zod`, `react-hook-form`, `@hookform/resolvers`, `@vexenhanh/api-client` (`workspace:*`, chỉ dùng kiểu catalog: `import type { components } from "@vexenhanh/api-client"`). Lệnh (máy này bắt buộc `--store-dir`):

```bash
pnpm --filter @vexenhanh/marketplace add zod@^4.4.3 react-hook-form@^7.89.0 @hookform/resolvers@^5.9.1 --store-dir "C:/Code/Ve_Xe_Nhanh/.pnpm-store-iam005"
```

Cần gói khác (vd lịch chọn ngày `react-day-picker`, `cmdk`) → **dừng, hỏi Khanh**. Popover, Checkbox, RadioGroup, Accordion… đã có sẵn trong gói `radix-ui` của `packages/ui`.

**Cấm**
- `apps/api/**`, `packages/api-client/**`, `packages/api_client_dart/**`, `packages/types/**`, mọi file Prisma / migration / seed.
- `apps/operator-os/**`, `apps/admin/**`, `apps/passenger_mobile/**`, `apps/employee_mobile/**`.
- `doc/SDLC/**`, `doc/context/**`, `CLAUDE.md`, `AGENTS.md`, `.github/**`, `.claude/**`.
- Chạy `pnpm gen:api-client`, migration, seed; khởi động, tắt hay sửa cấu hình API.
- `git commit`, `push`, `stash`, `reset`, `checkout` đè file; chạy agent review (`code-reviewer`, `security-auditor`).

### A5. Kiến trúc dữ liệu — tách phần dựng khỏi phần dữ liệu

```text
apps/marketplace/
  app/<route>/page.tsx        Server Component: nhánh preview → nhánh dữ liệu thật
  components/<feature>/       view thuần: chỉ nhận props; không fetch, không đọc env
  components/states/          FeatureUnavailable (bản đầy đủ + bản gọn), ErrorState, EmptyState, skeleton dùng chung
  lib/data/result.ts          kiểu DataResult + unavailable() / failed()
  lib/data/types.ts           kiểu dữ liệu tạm (chưa có hợp đồng API)
  lib/data/<feature>.ts       mỗi nhu cầu dữ liệu một hàm
  lib/preview/                getPreview() + fixtures/<feature>.ts
  lib/format/                 tiền, ngày giờ
```

```ts
// lib/data/result.ts — hợp đồng, agent tự viết phần thân
export type DataResult<T> =
  | { status: "ok"; data: T }
  | { status: "unavailable"; endpoint: string } // endpoint chưa được code
  | { status: "error"; endpoint: string };      // endpoint có nhưng lỗi / API không chạy
```

**Quy tắc**
1. **Endpoint chưa có** → hàm trả `unavailable("GET /trips/search")`, không gọi mạng, ghi `console.warn("[marketplace] chưa có API: GET /trips/search")`.
2. **Endpoint có thật** (chỉ năm GET `/catalog/*`) → gọi **từ server** (Server Component, Server Action). Base URL: `process.env.API_BASE_URL ?? "http://localhost:3000/v1"`. Lỗi mạng hoặc không 2xx → `failed(...)` + `console.error` (không in dữ liệu cá nhân). **Không gọi API từ trình duyệt:** CORS của API không cho origin Marketplace, và không được sửa API.
3. **Thao tác của người dùng** (giữ chỗ, đặt vé, thanh toán, gửi OTP, đăng nhập, hủy vé, gửi khiếu nại, đổi điểm, lưu mã) → không gọi mạng; hiện lỗi tại chỗ "Chưa thực hiện được — chức năng chưa sẵn sàng" theo kiểu khung lỗi tương ứng trong Figma nếu có; `console.warn` tên endpoint. **Không giả thành công, không chuyển trang như đã thành công.** Kiểm form bằng Zod vẫn làm đủ, lỗi hiện tại ô như Figma.
4. **Nội dung chính** của trang thiếu dữ liệu → `FeatureUnavailable` bản đầy đủ. **Khối phụ** (tuyến phổ biến, nhà xe đối tác, cẩm nang…) → bản gọn. Không ẩn khối âm thầm.
5. **Chữ cố định** trong Figma (tiêu đề, nhãn, hero, footer, chữ của trạng thái rỗng / lỗi) → viết thẳng. **Dữ liệu** (chuyến, giá, nhà xe, vé, bài viết, câu hỏi thường gặp, nội dung pháp lý, thông tin người dùng) → qua `lib/data`.
6. **Kiểu dữ liệu** tự định nghĩa trong `lib/data/types.ts` từ những gì Figma hiển thị; tên tiếng Anh theo `doc/context/GLOSSARY.md`; đầu file ghi `// Tạm — chưa có hợp đồng API (05 API §7.2)`.
7. **Tiền** = chuỗi số nguyên VND (`amountVnd: "280000"`), định dạng bằng `BigInt` trong `lib/format`, hiển thị như Figma (`280.000đ`). Cấm `number`, `parseFloat`, `Number()` cho tiền. Thời gian = chuỗi ISO 8601.

**Preview — dữ liệu mẫu chỉ để so với Figma**
- `getPreview(searchParams)` trả tên trạng thái từ `?preview=` khi `process.env.NODE_ENV !== "production"`; ngược lại trả `null`.
- `page.tsx`: có preview → render view với `fixtures[<tên>]`; không có → nhánh dữ liệu thật (quy tắc 1–4). Chỉ `page.tsx` được import fixture.
- Fixture chép đúng chữ và số trong khung Figma. Ảnh thuộc dữ liệu (xe, tuyến, bài viết) → khối `bg-muted` cùng kích thước và tỉ lệ. Ảnh trang trí cố định (ảnh nền hero) → xuất từ Figma vào `apps/marketplace/public/images/`, ghi nguồn vào todo để Khanh kiểm bản quyền.
- Trạng thái tương tác (tab đang chọn, danh sách đang mở, hộp thoại đang mở) → component nhận prop trạng thái ban đầu; preview truyền vào.
- `?as=user` (chỉ ở dev) bật biến thể thanh bên đã đăng nhập.

### A6. Kích thước màn hình và cách chụp

| Tên | Viewport | Dùng để |
| --- | --- | --- |
| `1440` | 1440×900 | So trực tiếp với Figma — mọi vòng |
| `1920` | 1920×1080 | Nội dung không giãn quá khung tối đa, không lệch |
| `1280` | 1280×800 | Laptop |
| `1024` | 1024×768 | Ranh giới `lg`: thanh bên cố định còn hiện |
| `768` | 768×1024 | Máy tính bảng: thanh trên + menu trượt |
| `390` | 390×844 | Điện thoại |
| `360` | 360×800 | Điện thoại nhỏ: không cuộn ngang, chữ không bị cắt |

**Quy tắc thu hẹp** (Figma không có bản hẹp)
- Giữ thứ tự nội dung như Figma: trên xuống dưới, trái sang phải.
- Các cột cạnh nhau xếp chồng dưới `lg` (hoặc `md` nếu cột hẹp).
- Cột phụ (tóm tắt đơn, thông tin bên) xuống dưới nội dung chính. Bộ lọc danh sách chuyến → nút "Lọc" mở `Sheet`.
- Bảng → thẻ.
- Vùng bấm ≥ 44px; chữ trong ô nhập ≥ 16px.
- Thanh bên giữ hành vi sẵn có của `SiteShell` (từ `lg` cố định; dưới `lg` thanh trên + `Sheet`).

**Chụp**
- Chạy web ở nền: `pnpm --filter @vexenhanh/marketplace dev` (cổng 3001).
- Ảnh Figma: lấy ảnh khung, rộng 1440 → lưu `tmp/marketplace-ui/<SCR>/<trạng thái>/figma.png` (`tmp/` đã gitignore).
- Ảnh app: dùng công cụ trình duyệt của bạn (đặt đúng viewport, chụp cả trang). Không có thì dùng lệnh dưới. **Phải có `--channel=chrome`**: máy này chưa tải Chromium của Playwright.

```bash
pnpm --filter @vexenhanh/operator-os exec playwright screenshot --channel=chrome --full-page --viewport-size=1440,900 --wait-for-timeout=1500 "http://localhost:3001/trips?preview=ideal" "C:/Code/Ve_Xe_Nhanh/tmp/marketplace-ui/SCR-PSG-15/ideal/1440-r1.png"
```

- Tên ảnh: `tmp/marketplace-ui/<SCR>/<trạng thái>/<viewport>-r<vòng>.png`.
- Cuộn ngang: ảnh chụp cả trang rộng hơn viewport, hoặc `document.documentElement.scrollWidth > window.innerWidth` trong trình duyệt → lỗi.
- Bỏ qua nút tròn "N" ở góc dưới trái: chỉ báo của Next ở chế độ dev.

### A7. Bảng so khớp (ảnh `1440` với `figma.png`)

| # | Kiểm | Đạt khi |
| --- | --- | --- |
| 1 | Khối và thứ tự | Đủ khối, đúng thứ tự, đúng cột |
| 2 | Kích thước, khoảng cách | Lệch ≤ 4px; bội số 4px |
| 3 | Màu | Dùng token có sẵn (`vxn-teal-*`, `vxn-saffron-*`, `primary`, `muted`…); không có token khớp thì ghi sổ lệch, không tự thêm token |
| 4 | Chữ | Đúng nội dung, đúng dấu tiếng Việt, đúng cỡ và độ đậm, font Be Vietnam Pro |
| 5 | Biểu tượng | `lucide-react`, đúng hình, đúng cỡ |
| 6 | Thành phần | Dùng lại `@vexenhanh/ui` (`Button`, `Input`, `Select`, `Tabs`, `Badge`, `Dialog`, `Sheet`, `Skeleton`, `Switch`…) thay vì tự vẽ |
| 7 | Tràn | Không chữ bị cắt, không phần tử chồng lên nhau |
| 8 | Trạng thái | Hover, focus nhìn thấy được; phần tử bị khóa trông bị khóa |

Mỗi khối **tối đa 3 vòng sửa**. Còn lệch thì ghi sổ lệch kèm lý do, sang khối sau.

### A8. File theo dõi `doc/task-propreties/MKT-WEB-ui-todo.md`

Agent tạo ở lô 0 và cập nhật sau mỗi khung. Bốn mục:
1. **Bảng màn:** mã | route | trạng thái đã dựng | ảnh `1440` khớp (✅ / còn lệch) | đủ 7 viewport (✅ / ❌) | ghi chú.
2. **Sổ lệch Figma:** # | khung (node) | Figma | đã làm | lý do (dòng A3 nào, hoặc vì sao không làm được).
3. **API còn thiếu:** endpoint | màn dùng | hành vi hiện tại (khối chưa sẵn sàng / lỗi tại chỗ).
4. **Chưa qua review:** luôn ghi "chưa qua `code-reviewer` / `security-auditor` — chỉ chạy khi Khanh yêu cầu".
5. **File đã tạo / sửa:** danh sách đường dẫn, cập nhật sau mỗi khung. Phiên sau dựa vào danh sách này để biết thay đổi nào là của mình.

---

## Phần B — Prompt

### Prompt 0 — Khởi động phiên (dán đầu mỗi phiên)

```text
Bạn dựng giao diện web cho apps/marketplace (Next.js 16 App Router, Tailwind CSS 4, Shadcn/ui trong packages/ui) trong repo C:\Code\Ve_Xe_Nhanh. Việc của bạn chỉ là giao diện. KHÔNG đụng API.

Làm theo thứ tự, chưa viết code:
1. Đọc hết Phần A của doc/task-propreties/MKT-WEB-ui-agent-prompts.md và file AGENTS.md. Nếu đã có doc/task-propreties/MKT-WEB-ui-todo.md, đọc để biết đã làm tới đâu.
2. Kiểm công cụ, trả lời có / không từng mục: (a) đọc Figma — lấy ảnh khung 776:791 trong file 6c81q3DdHVS0anfDw2sVVj; (b) chạy lệnh shell; (c) chụp màn hình trang web ở viewport tùy chọn. Thiếu (a) hoặc (c) thì dừng, báo Khanh.
3. Chạy git status và git branch --show-current. Bỏ qua file prompt này (doc/task-propreties/MKT-WEB-ui-agent-prompts.md) và các file có trong mục "File đã tạo / sửa" của MKT-WEB-ui-todo.md (do bạn làm ở phiên trước). Còn file thay đổi nào khác thì dừng, liệt kê, chờ Khanh. Không stash, không reset, không checkout đè.
4. Trả lời bằng báo cáo ngắn: công cụ, nhánh, trạng thái thư mục làm việc, lô tiếp theo. Rồi DỪNG, chờ lệnh.

Luật suốt phiên:
- Chỉ sửa trong vùng "Được sửa" ở A4. Không sửa, chạy, sinh lại gì thuộc API.
- Bám Figma bộ mới (mục 674:290). Figma trái với A3 thì làm theo A3 và ghi sổ lệch.
- Không gọi endpoint chưa có, không giả thành công. Thiếu API thì hiện khối "chưa sẵn sàng" hoặc lỗi tại chỗ, kèm console.warn (A5).
- Chỉ gọi năm GET /catalog/*, và chỉ từ server.
- Dữ liệu mẫu chỉ đi qua ?preview= ở next dev.
- Tiền là chuỗi số nguyên VND, không dùng number.
- Mỗi khối: dựng → chụp → so với Figma → sửa, tối đa 3 vòng.
- Không thêm gói ngoài A4. Không sửa file có sẵn của packages/ui.
- Không commit, push, stash, reset. Không chạy agent review.
- Mơ hồ thì dừng, hỏi Khanh. Không đoán.
- Cuối mỗi lô ghi nhật ký AI:
  node .claude/hooks/ai-journal.mjs add "Frontend / Marketplace" "<tên công cụ + model của bạn>" "<mục đích>" "<đường dẫn + phạm vi, không dán mã>" "" "<nhận xét>"
```

### Prompt 1 — Lô 0: nền (dán một lần)

```text
Làm lô 0. Từng bước; bước nào hỏng thì sửa trước khi sang bước sau.

1. Nhánh: thư mục làm việc phải sạch, trừ đúng một file chưa commit là doc/task-propreties/MKT-WEB-ui-agent-prompts.md. Sạch thì chạy git switch -c MKT-WEB-ui develop; còn file khác thì dừng.
2. Thêm gói theo đúng lệnh ở A4.
3. Tạo cấu trúc A5: lib/data/result.ts (DataResult, unavailable, failed — có console.warn / console.error), lib/data/types.ts, lib/preview/ (getPreview), lib/format/ (formatVnd nhận chuỗi số nguyên và dùng BigInt; định dạng ngày giờ kiểu Việt Nam), components/states/ (FeatureUnavailable bản đầy đủ + bản gọn, ErrorState, EmptyState).
4. Test Vitest cho lib: formatVnd (0, số lớn hơn 2^53, chuỗi không hợp lệ ném lỗi); getPreview trả null khi NODE_ENV=production; unavailable() gọi console.warn đúng một lần với tên endpoint.
5. Khung trang theo Figma: sửa components/site-shell.tsx và components/site-footer.tsx theo thanh bên + footer trong 776:791 (kit 1436:12785, 1434:11609). Mục điều hướng lấy đúng chữ và thứ tự Figma, BỎ "Dịch vụ bổ trợ" (A3 #7). Hai biến thể: khách (mặc định) và đã đăng nhập (chỉ hiện khi ?as=user ở dev).
6. Bốn trang lỗi theo khung 404 / 500 / 403 / 503 ở A2.
7. Với khung trang và từng trang lỗi: chạy vòng so khớp như Prompt 2 bước 4–7.
8. Tạo doc/task-propreties/MKT-WEB-ui-todo.md theo A8.
9. Chạy pnpm --filter @vexenhanh/marketplace lint, typecheck, test, build. Tất cả phải đạt.
10. Ghi nhật ký AI. Báo cáo theo mẫu ở Prompt 3. DỪNG.
```

### Prompt 2 — Dựng một lô (thay `<N>`)

```text
Làm lô <N> trong bảng A2. Làm từng khung một, theo thứ tự trong bảng. Với MỖI khung:

Bước 1 — Đọc thiết kế. Lấy ảnh khung (rộng 1440) và thông tin thiết kế từ Figma; lưu ảnh vào tmp/marketplace-ui/<SCR>/<trạng thái>/figma.png. Viết ra trong câu trả lời (không ghi vào code): các khối từ trên xuống; thành phần @vexenhanh/ui dùng lại; dữ liệu cần; chỗ nào chạm A3.
Bước 2 — Dữ liệu. Thêm kiểu vào lib/data/types.ts. Thêm hàm lib/data/<feature>.ts: endpoint ❌ ở A2 thì trả unavailable(...); ✅ thì gọi từ server. Thêm fixture lib/preview/fixtures/<feature>.ts, chép đúng chữ và số trong khung.
Bước 3 — Dựng MỘT khối chưa xong, trong components/<feature>/; nối vào page.tsx (nhánh preview + nhánh thật).
Bước 4 — Chụp viewport 1440, cả trang, URL có ?preview=<trạng thái> → <viewport>-r<vòng>.png.
Bước 5 — So ảnh với figma.png theo bảng A7. Ghi bảng: mục | đạt / lệch | sẽ sửa gì.
Bước 6 — Sửa chỗ lệch, quay lại bước 4. Tối đa 3 vòng cho một khối; còn lệch thì ghi sổ lệch, sang khối sau. Hết khối thì sang bước 7.
Bước 7 — Chụp sáu viewport còn lại ở A6 (1920, 1280, 1024, 768, 390, 360). Kiểm quy tắc thu hẹp và cuộn ngang. Sửa, chụp lại viewport vừa sửa.
Bước 8 — Trạng thái. Chụp 1440 cho từng trạng thái còn lại của khung trong A2. Mở route thật KHÔNG có ?preview: phải thấy khối "chưa sẵn sàng" hoặc lỗi, và log trong terminal hoặc console. Bấm thử các nút hành động: phải thấy lỗi tại chỗ, không chuyển trang.
Bước 9 — Chạy pnpm --filter @vexenhanh/marketplace lint, typecheck, test. Đỏ thì sửa trước khi sang khung sau.
Bước 10 — Cập nhật MKT-WEB-ui-todo.md: bảng màn, sổ lệch, API còn thiếu.

Hết lô thì làm Prompt 3. Không tự mở lô mới.

Dừng ngay và hỏi Khanh khi:
- cần sửa file ngoài vùng A4, hoặc cần gói ngoài A4;
- Figma trái tài liệu mà A3 không nói tới;
- khung thiếu trạng thái và bạn phải tự nghĩ ra bố cục mới;
- một lệnh lỗi hai lần liên tiếp vì cùng một nguyên nhân.
```

### Prompt 3 — Kiểm cuối lô

```text
Kiểm cuối lô <N>, chưa sang lô mới:

1. Chụp lại mọi khung của lô ở 1440 và 390 với code hiện tại; liệt kê đường dẫn ảnh.
2. Chạy pnpm --filter @vexenhanh/marketplace lint, typecheck, test, build. Dán dòng kết quả cuối của từng lệnh.
3. Kiểm ranh giới, dán kết quả:
   - git status --porcelain: mọi file phải nằm trong vùng "Được sửa" ở A4;
   - tìm "fetch(" trong apps/marketplace/components: phải không có;
   - tìm "preview/fixtures" trong apps/marketplace: chỉ xuất hiện ở page.tsx và trong lib/preview;
   - tìm kiểu number cho tiền (amount, price, total, fee): phải không có.
4. Ghi nhật ký AI.
5. Báo cáo theo mẫu, rồi DỪNG chờ Khanh:

## Lô <N> — <tên lô>
- Khung đã dựng: <mã · route · các trạng thái>
- Ảnh: <thư mục trong tmp/marketplace-ui/>
- Lệch còn lại: <bảng, hoặc "không">
- API còn thiếu: <bảng>
- Lệnh kiểm: lint / typecheck / test / build — <đạt / không đạt>
- Ranh giới: <kết quả bước 3>
- File đã sửa: <danh sách>
- Chưa qua review (code-reviewer / security-auditor).
- Câu hỏi cho Khanh: <nếu có>
```

### Prompt 4 — Nắn lại khi lạc hướng (dán câu phù hợp)

```text
[Sửa ngoài vùng] Bạn vừa sửa <file>, nằm ngoài vùng "Được sửa" ở A4. Hoàn tác đúng thay đổi đó của bạn, không đụng thay đổi của người khác, rồi báo lại.

[Bỏ qua chụp] Bạn báo xong <SCR> nhưng chưa có ảnh so. Làm lại Prompt 2 bước 4–8 cho <SCR>; gửi đường dẫn ảnh và bảng so A7.

[Giả dữ liệu / giả API] Không gọi endpoint chưa có, không giả thành công. Ngoài nhánh ?preview, nhánh thật phải trả unavailable(...) và hiện khối "chưa sẵn sàng" như A5.

[Tự ý khác Figma] So lại khung <node>: chỗ <mô tả> khác Figma. Sửa theo Figma, hoặc ghi sổ lệch kèm dòng A3 làm lý do.

[Sửa mãi một khối] Dừng sửa khối này. Ghi sổ lệch, sang khối sau.

[Muốn thêm gói / sửa packages/ui] Không làm. Ghi nhu cầu vào mục "Câu hỏi cho Khanh" rồi dùng cách có sẵn.

[Tự quyết thay Khanh] Bạn vừa chọn <x> mà tài liệu không nói. Hoàn tác, đưa phương án vào mục "Câu hỏi cho Khanh", chờ trả lời.
```
