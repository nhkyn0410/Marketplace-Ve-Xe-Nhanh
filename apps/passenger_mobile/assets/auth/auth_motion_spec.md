# Auth motion specification

## Nguồn dữ liệu và mức độ đầy đủ

- Figma Motion Context đã truy cập được cho `Đăng nhập · Motion` (`1253:174`) với `recursive: true`.
- Cohort gốc: `2043:24837`.
- Duration: **4,000 ms**.
- Loop mode: **loop / infinite**.
- Số node animation: **35**.
- Motion Context của `Splash · Tĩnh` (`1272:226`) trả về `{"nodes":[]}`; frame này không có track animation.
- Delay không được trả dưới dạng thuộc tính riêng. MCP biểu diễn delay chính xác bằng đoạn HOLD đầu timeline (hai keyframe đầu cùng giá trị); cột “Hold/delay” dưới đây ghi lại đoạn này.
- MCP không phát trường `transformOrigin` riêng và các snippet không override `transform-origin`. Vì vậy hiệu lực của snippet nguồn là origin mặc định **center / 50% 50%** cho scale/rotate; translate/opacity không phụ thuộc origin. Đây là hành vi của snippet được trả về, không phải một custom origin suy đoán thêm.

## Đơn vị và easing

- `x`, `y`: logical px theo artboard 412 × 915.
- `scaleX`, `scaleY`: hệ số.
- `rotate`: độ trong Motion snippet; bánh xe đồng thời được CSS snippet biểu diễn là `-30rad → 0rad`.
- Mọi track có duration 4,000 ms và lặp vô hạn.
- Ký hiệu easing:
  - `L`: linear
  - `EO`: ease-out
  - `EIO`: ease-in-out
  - `EXPO`: `cubic-bezier(0.16, 1, 0.3, 1)`
  - `MOVE`: `cubic-bezier(0.2, 0.7, 0.2, 1)`
  - `LOGO`: `cubic-bezier(0.65, 0, 0.35, 1)`
  - `SPRING_A`: `1 - exp(-t × 7.6657) × (cos(t × 6.7605) + 1.1339 × sin(t × 6.7605))`
  - `SPRING_B`: `1 - exp(-t × 7.1866) × (cos(t × 22.3441) + 0.3216 × sin(t × 22.3441))`
- Trong mỗi danh sách easing, giá trị thứ n áp dụng cho đoạn từ keyframe n tới n+1.

## Timeline chính xác

### Cảnh quan

| Node | Hold/delay | Tracks: keyframe `giá trị@ms` | Easing theo đoạn | Origin |
|---|---:|---|---|---|
| `1255:215` Sun | 600 ms | opacity `0@0, 0@600, 1@1000, 1@4000`; y `70@0, 70@600, 0@1500, 0@4000` | opacity `L, EO, L`; y `L, SPRING_A, L` | — |
| `1255:216` Halo ngoài | 1,600 ms | scale X/Y `1@0, 1@1600, 1.14@2600, 1@3600, 1@4000` | `L, EIO, EIO, L` | center |
| `1255:217` Halo trong | 1,750 ms | scale X/Y `1@0, 1@1750, 1.1@2750, 1@3750, 1@4000` | `L, EIO, EIO, L` | center |
| `1255:219` Núi · lớp xa | 500 ms | opacity `0@0, 0@500, 0.38@950, 0.38@4000`; y `36@0, 36@500, 0@1100, 0@4000` | opacity `L, EO, L`; y `L, EXPO, L` | — |
| `1255:221` Mây C | 800 ms | opacity `0@0, 0@800, 0.6@1300, 0.6@4000`; x `-18@0, -18@800, 8@4000` | opacity `L, EO, L`; x `L` | — |
| `1255:223` Núi · lớp gần | 560 ms | opacity `0@0, 0@560, 0.9@1000, 0.9@4000`; y `52@0, 52@560, 0@1200, 0@4000` | opacity `L, EO, L`; y `L, EXPO, L` | — |
| `1255:225` Mây A | 600 ms | opacity `0@0, 0@600, 0.95@1100, 0.95@4000`; x `-34@0, -34@600, 12@4000` | opacity `L, EO, L`; x `L` | — |
| `1255:227` Mây B | 700 ms | opacity `0@0, 0@700, 0.88@1200, 0.88@4000`; x `38@0, 38@700, -10@4000` | opacity `L, EO, L`; x `L` | — |
| `1255:229` Đồi | 620 ms | y `76@0, 76@620, 0@1300, 0@4000` | `L, EXPO, L` | — |
| `1255:231` Cây thông 1 | 1,040 ms | opacity `0@0, 0@1040, 1@1160, 1@4000`; scale X/Y `0.2@0, 0.2@1040, 1@1490, 1@4000`; y `10@0, 10@1040, 0@1440, 0@4000` | opacity `L, EO, L`; scale `L, SPRING_B, L`; y `L, EO, L` | center |
| `1255:233` Cây thông 2 | 1,100 ms | opacity `0@0, 0@1100, 1@1220, 1@4000`; scale X/Y `0.2@0, 0.2@1100, 1@1550, 1@4000`; y `10@0, 10@1100, 0@1500, 0@4000` | opacity `L, EO, L`; scale `L, SPRING_B, L`; y `L, EO, L` | center |
| `1255:235` Cây thông 3 | 1,160 ms | opacity `0@0, 0@1160, 1@1280, 1@4000`; scale X/Y `0.2@0, 0.2@1160, 1@1610, 1@4000`; y `10@0, 10@1160, 0@1560, 0@4000` | opacity `L, EO, L`; scale `L, SPRING_B, L`; y `L, EO, L` | center |
| `1255:237` Cây thông 4 | 1,220 ms | opacity `0@0, 0@1220, 1@1340, 1@4000`; scale X/Y `0.2@0, 0.2@1220, 1@1670, 1@4000`; y `10@0, 10@1220, 0@1620, 0@4000` | opacity `L, EO, L`; scale `L, SPRING_B, L`; y `L, EO, L` | center |
| `1255:239` Cây thông 5 | 1,280 ms | opacity `0@0, 0@1280, 1@1400, 1@4000`; scale X/Y `0.2@0, 0.2@1280, 1@1730, 1@4000`; y `10@0, 10@1280, 0@1680, 0@4000` | opacity `L, EO, L`; scale `L, SPRING_B, L`; y `L, EO, L` | center |

### Xe khách

| Node | Hold/delay | Tracks: keyframe `giá trị@ms` | Easing theo đoạn | Origin |
|---|---:|---|---|---|
| `1256:214` Xe khách | 850 ms | x `-330@0, -330@850, 0@2050, 0@4000` | `L, MOVE, L` | — |
| `1256:217` Vệt tốc độ | 850 ms | opacity `0@0, 0@850, 0.85@1000, 0.85@1350, 0@1650, 0@4000` | `L, EO, L, EO, L` | — |
| `1256:221` Thân xe | 1,700 ms | rotate `0@0, 0@1700, 1.1@1980, 0@2400, 0@4000`; y `0@0, 0@1700, 1.2@1980, 0@2350, -0.7@2800, 0@3200, -0.7@3600, 0@4000` | rotate `L, EO, SPRING_A, L`; y `L, EO, SPRING_A, EIO, EIO, EIO, EIO` | center |
| `1256:237` Bánh sau | 850 ms | rotate `-30rad@0, -30rad@850, 0rad@2050, 0rad@4000` | `L, MOVE, L` | center |
| `1256:242` Bánh trước | 850 ms | giống hệt node `1256:237` | `L, MOVE, L` | center |

### Waves và nội dung form

| Node | Hold/delay | Tracks: keyframe `giá trị@ms` | Easing theo đoạn | Origin |
|---|---:|---|---|---|
| `1259:235` Sóng · lớp sau | 1,050 ms | x `-44@0, -44@1050, 0@3600, 0@4000`; y `640@0, 640@1050, 0@1750, 0@4000` | x `L, EO, L`; y `L, EXPO, L` | — |
| `1259:237` Sóng · nền biểu mẫu | 1,120 ms | y `640@0, 640@1120, 0@1850, 0@4000` | `L, EXPO, L` | — |
| `1257:221` Heading | 1,450 ms | opacity `0@0, 0@1450, 1@1770, 1@4000`; y `20@0, 20@1450, 0@1950, 0@4000` | opacity `L, EO, L`; y `L, EXPO, L` | — |
| `1257:222` Subtitle | 1,580 ms | opacity `0@0, 0@1580, 1@1900, 1@4000`; y `20@0, 20@1580, 0@2080, 0@4000` | opacity `L, EO, L`; y `L, EXPO, L` | — |
| `1257:223` Email | 1,620 ms | opacity `0@0, 0@1620, 1@1940, 1@4000`; y `20@0, 20@1620, 0@2120, 0@4000` | opacity `L, EO, L`; y `L, EXPO, L` | — |
| `1259:238` CTA | 1,690 ms | opacity `0@0, 0@1690, 1@2010, 1@4000`; y `20@0, 20@1690, 0@2190, 0@4000` | opacity `L, EO, L`; y `L, EXPO, L` | — |
| `1259:240` Shine | 2,500 ms | x `0@0, 0@2500, 500@3200, 500@4000` | `L, EIO, L` | — |
| `1257:229` Divider · hoặc | 1,760 ms | opacity `0@0, 0@1760, 1@2080, 1@4000`; y `20@0, 20@1760, 0@2260, 0@4000` | opacity `L, EO, L`; y `L, EXPO, L` | — |
| `1257:234` Google | 1,830 ms | opacity `0@0, 0@1830, 1@2150, 1@4000`; y `20@0, 20@1830, 0@2330, 0@4000` | opacity `L, EO, L`; y `L, EXPO, L` | — |
| `1257:242` Apple | 1,900 ms | opacity `0@0, 0@1900, 1@2220, 1@4000`; y `20@0, 20@1900, 0@2400, 0@4000` | opacity `L, EO, L`; y `L, EXPO, L` | — |
| `1257:245` Facebook | 1,950 ms | opacity `0@0, 0@1950, 1@2270, 1@4000`; y `20@0, 20@1950, 0@2450, 0@4000` | opacity `L, EO, L`; y `L, EXPO, L` | — |
| `1257:251` Khách · Khám phá trước | 2,020 ms | opacity `0@0, 0@2020, 1@2340, 1@4000`; y `20@0, 20@2020, 0@2520, 0@4000` | opacity `L, EO, L`; y `L, EXPO, L` | — |
| `1257:253` Legal | 2,080 ms | opacity `0@0, 0@2080, 1@2400, 1@4000`; y `20@0, 20@2080, 0@2580, 0@4000` | opacity `L, EO, L`; y `L, EXPO, L` | — |
| `1259:253` Logo pill | 980 ms | opacity `0@0, 0@980, 1@1160, 1@4000` | `L, EO, L` | — |

### Splash-to-login overlay

| Node | Hold/delay | Tracks: keyframe `giá trị@ms` | Easing theo đoạn | Origin |
|---|---:|---|---|---|
| `1259:260` Splash · nền | 450 ms | opacity `1@0, 1@450, 0@950, 0@4000` | `L, EIO, L` | — |
| `1259:261` Splash · logo | transform 450 ms; opacity 1,020 ms | opacity `1@0, 1@1020, 0@1160, 0@4000`; scale X/Y `1@0, 1@450, 0.489@1000, 0.489@4000`; x `0@0, 0@450, -109.289@1000, -109.289@4000`; y `0@0, 0@450, -353.659@1000, -353.659@4000` | opacity `L, EO, L`; transform `L, LOGO, L` | center |

## Node inventory của cohort

`1255:215`, `1255:216`, `1255:217`, `1255:219`, `1255:221`, `1255:223`, `1255:225`, `1255:227`, `1255:229`, `1255:231`, `1255:233`, `1255:235`, `1255:237`, `1255:239`, `1256:214`, `1256:217`, `1256:221`, `1256:237`, `1256:242`, `1259:235`, `1259:237`, `1257:221`, `1257:222`, `1257:223`, `1259:238`, `1259:240`, `1257:229`, `1257:234`, `1257:242`, `1257:245`, `1257:251`, `1257:253`, `1259:253`, `1259:260`, `1259:261`.

## Lưu ý triển khai Flutter cho giai đoạn sau

- Dùng **một** `AnimationController(duration: 4000 ms)..forward()` làm clock chung cho toàn cohort; Figma loop vô hạn nhưng ứng dụng chỉ chạy intro một lần rồi giữ trạng thái cuối, không tạo controller riêng cho từng layer.
- Map trực tiếp các mốc ms ở trên sang `Interval`/`TweenSequence`; giữ nguyên custom cubic và hai hàm spring.
- Scale/rotate dùng origin center theo hiệu lực snippet MCP; nếu product yêu cầu một origin khác thì phải xác nhận lại từ Figma, không tự đổi.
- `waves/back.svg` cần giữ đồng thời x/y track khác duration active; `waves/form_background.svg` chỉ có y.
- Hai bánh xe dùng chung track, nhưng là hai asset riêng.
- `Vệt tốc độ` là group `1256:217` (64 × 30, opacity nghỉ 0) chứa ba vector nguyên gốc `1256:218`–`1256:220`; compose ba SVG theo tọa độ trong manifest rồi animate opacity ở group.
- Cần giữ source slot khác intrinsic size cho cloud, road, speed streak, logo và form wave; không ép mọi SVG thành `width: 100%, height: 100%` ngoài đúng slot Figma.
- Chưa có SVG renderer trong dependencies hiện tại. Việc chọn/duyệt `flutter_svg` hoặc pipeline vector khác thuộc giai đoạn triển khai sau; giai đoạn này không thêm dependency.
- Khi triển khai, thêm golden/widget tests tại các mốc đại diện: 0, 450, 1,000, 1,850, 2,580 và 4,000 ms; thêm nhánh reduced motion trước khi bàn giao.
