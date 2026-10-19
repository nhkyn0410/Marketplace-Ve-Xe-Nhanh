import { expect, test, type Page } from "@playwright/test";

import { accounts, signInWithEnrollment } from "./helpers";

// TASK-TRN-003 (màn Chuyến xe) — luồng chính của Owner: tạo chuyến nháp từ tuyến + xe dựng sẵn, xe trùng giờ
// báo tại ô Xe (BR-14), sửa chuyến với giờ tự nhập tại điểm dừng, lọc danh sách, và sơ đồ ghế của xe đang có
// chuyến bị khóa ở màn Sơ đồ ghế (UC-12 A3). Tuyến + xe do global-setup seed (`tripFixtures`), cần catalog đã
// seed (`db:seed:catalog`, RB-08). Chạy tuần tự, dùng chung một phiên: mỗi ca dựa trên dữ liệu ca trước tạo ra.
// TASK-TRN-005 (màn Bảng giá) — hai ca cuối file, cùng phiên vì cần tuyến và chuyến ở trên: tạo bảng giá cho
// tuyến, quy tắc trùng bị chặn, giá hiện trên từng chỗ của chuyến, sửa giá ghi vào lịch sử (BR-40).
// TASK-TRN-006 (vòng đời bán + khóa chỗ) — ba ca cuối file: mở bán thiếu điều kiện bị chặn kèm lý do (BR-39), khóa
// / mở khóa chỗ (BR-42), tạm dừng bán, mở bán lại, thu hồi về nháp và hủy chuyến bắt buộc lý do.
test.describe.configure({ mode: "serial" });

// Lần đầu mở một trang, máy chủ dev của Next phải biên dịch trang đó — có thể lâu hơn 5 giây mặc định.
const FIRST_VISIT = { timeout: 30_000 };
// Ngày khởi hành cách hôm nay 30 ngày theo giờ Việt Nam: luôn ở tương lai và không rơi vào lúc đổi ngày.
const DAY = new Date(Date.now() + 7 * 3_600_000 + 30 * 24 * 3_600_000).toISOString().slice(0, 10);
const NEXT_DAY = new Date(Date.now() + 7 * 3_600_000 + 31 * 24 * 3_600_000).toISOString().slice(0, 10);
const DAY_LABEL = DAY.split("-").reverse().join("/");
let page: Page;
let routeName: string;
let plate: string;
let seatMapName: string;

test.beforeAll(async ({ browser }) => {
  const { tripOperatorSlug, tripOwner, tripFixtures } = accounts();
  if (!tripFixtures) {
    throw new Error("Thiếu dữ liệu nền cho màn Chuyến xe — chạy `db:seed:catalog` (RB-08) rồi chạy lại E2E.");
  }
  routeName = tripFixtures.routeName;
  // Giao diện hiện biển số theo cách viết quen thuộc: `51B28912` → `51B-289.12`.
  plate = tripFixtures.plateNumber.replace(/^(\d{2}[A-Z])(\d{3})(\d{2})$/, "$1-$2.$3");
  seatMapName = tripFixtures.seatMapName;
  page = await browser.newPage();
  await signInWithEnrollment(page, `${tripOperatorSlug}/${tripOwner.username}`, tripOwner.password);
});

test.afterAll(async () => {
  await page.close();
});

async function choose(label: string, option: string | RegExp) {
  await page.getByLabel(label, { exact: true }).click();
  await page.getByRole("option", { name: option }).click();
}

const stopRows = () => page.getByRole("list", { name: "Điểm dừng của chuyến" }).getByRole("listitem");

/** Điền tuyến, ngày giờ khởi hành và xe trên form chuyến đang mở. */
async function fillTrip(departureTime: string) {
  await choose("Tuyến *", routeName);
  await page.getByLabel("Ngày khởi hành *").fill(DAY);
  await page.getByLabel("Giờ khởi hành *").fill(departureTime);
  await choose("Xe", new RegExp(plate.replace(".", "\\.")));
}

test("tạo chuyến nháp: thiếu ô báo tại ô, giờ đến tự gợi ý, giờ từng điểm tự chia → trang chi tiết có ghế", async () => {
  await page.getByRole("link", { name: "Chuyến xe", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Chuyến xe", level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByText("Chưa có chuyến từ hôm nay")).toBeVisible();

  await page.getByRole("link", { name: "Tạo chuyến" }).first().click();
  await expect(page.getByRole("heading", { name: "Tạo chuyến", level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByText("Chọn tuyến để xem các điểm dừng của chuyến.")).toBeVisible();

  // Bấm lưu khi còn trống: lỗi nằm tại từng ô, không có request ghi.
  await page.getByRole("button", { name: "Lưu chuyến nháp" }).click();
  await expect(page.getByText("Chọn tuyến của chuyến.")).toBeVisible();
  await expect(page.getByText("Chọn ngày khởi hành.")).toBeVisible();
  await expect(page.getByText("Nhập giờ đến.")).toBeVisible();

  await fillTrip("06:00");
  await expect(page.getByText("3 điểm dừng · thời gian chạy 5 giờ 30 phút")).toBeVisible();
  // Giờ đến = giờ khởi hành + thời gian chạy của tuyến (5 giờ 30 phút).
  await expect(page.getByLabel("Ngày đến *")).toHaveValue(DAY);
  await expect(page.getByLabel("Giờ đến *")).toHaveValue("11:30");

  // Tự chia theo hai chặng bằng nhau: điểm giữa nằm chính giữa; trạm dừng nghỉ không đón trả khách (BR-79).
  await expect(page.getByRole("switch", { name: /Tự chia/ })).toBeChecked();
  await expect(stopRows()).toHaveCount(3);
  await expect(stopRows().nth(0)).toContainText("Văn phòng trung chuyển · Điểm đầu · Cho đón");
  await expect(stopRows().nth(0)).toContainText("06:00");
  await expect(stopRows().nth(1)).toContainText("Trạm dừng nghỉ · Không đón trả khách");
  await expect(stopRows().nth(1)).toContainText("08:45");
  await expect(stopRows().nth(2)).toContainText("Điểm cuối · Cho trả");
  await expect(stopRows().nth(2)).toContainText("11:30");

  const vehicleCard = page.getByRole("region", { name: "Xe và sơ đồ ghế" });
  await expect(vehicleCard).toContainText(plate);
  await expect(vehicleCard).toContainText(`${seatMapName} · 1 tầng`);
  await expect(vehicleCard).toContainText("4 chỗ");

  await page.getByRole("button", { name: "Lưu chuyến nháp" }).click();
  await expect(page).toHaveURL(/\/trips\/[0-9a-f-]{36}\?saved=1$/, FIRST_VISIT);
  await expect(page.getByText("Đã lưu chuyến nháp")).toBeVisible();
  await expect(page.getByRole("heading", { name: routeName, level: 1 })).toBeVisible();
  await expect(page.getByText(new RegExp(`Khởi hành 06:00 .*${DAY_LABEL} · đến 11:30 cùng ngày · xe ${plate}`))).toBeVisible();

  const deck = page.getByRole("region", { name: "Tầng 1: 4 chỗ" });
  await expect(deck).toContainText("A01");
  await expect(deck).toContainText("A04");
  // Chỗ còn trống ghi giá; tuyến chưa có bảng giá nên cả bốn chỗ đều "Chưa có giá" (TRN-005).
  // Chuyến nháp khóa chỗ được (TRN-006) nên chú giải có thêm "Đang chọn".
  await expect(page.getByRole("list", { name: "Chú giải tình trạng chỗ" }).getByRole("listitem")).toHaveText([
    "Còn trống",
    "Đang chọn"
  ]);
  await expect(deck.getByText("Chưa có giá")).toHaveCount(4);
  await expect(stopRows().nth(1)).toContainText("08:45");
  const info = page.getByRole("region", { name: "Thông tin chuyến" });
  await expect(info).toContainText("5 giờ 30 phút");
  await expect(info).toContainText("4 chỗ");
});

test("xe trùng giờ nằm ở nhóm Trùng giờ, không chọn được (BR-14, Lịch xe); khởi hành đúng lúc chuyến trước đến thì xe rảnh, lưu được", async () => {
  await page.getByRole("link", { name: "Danh sách chuyến" }).click();
  await page.getByRole("link", { name: "Tạo chuyến" }).first().click();
  await choose("Tuyến *", routeName);
  await page.getByLabel("Ngày khởi hành *").fill(DAY);
  await page.getByLabel("Giờ khởi hành *").fill("08:00");
  await expect(page.getByLabel("Giờ đến *")).toHaveValue("13:30");
  // TASK-TRN-015: ô Xe chia nhóm Rảnh / Trùng giờ theo giờ chuyến đang nhập; xe trùng giờ không chọn được.
  await page.getByLabel("Xe", { exact: true }).click();
  const busy = page.getByRole("option", { name: new RegExp(plate.replace(".", "\\.")) });
  await expect(page.getByText(/Trùng giờ — không chọn được · 1 xe/i)).toBeVisible();
  await expect(busy).toBeDisabled();
  await expect(busy).toContainText("Bận tới 11:30");
  await page.keyboard.press("Escape");

  // Không có thời gian đệm quay đầu: chuyến sau khởi hành đúng 11:30 là hợp lệ; giờ đến gợi ý lại theo giờ đi mới.
  await page.getByLabel("Giờ khởi hành *").fill("11:30");
  await expect(page.getByLabel("Giờ đến *")).toHaveValue("17:00");
  await page.getByLabel("Xe", { exact: true }).click();
  const free = page.getByRole("option", { name: new RegExp(plate.replace(".", "\\.")) });
  await expect(free).toContainText("Rảnh từ 11:30");
  await free.click();
  // Thẻ "Lịch xe trong ngày": chuyến trước, khoảng nghỉ 0 phút, rảnh lại lúc 17:00.
  const day = page.getByRole("region", { name: "Lịch xe trong ngày" });
  await expect(day).toContainText(`· đến 11:30`);
  await expect(day).toContainText("0 phút");
  await expect(day).toContainText("Rảnh từ 17:00");
  await page.getByRole("button", { name: "Lưu chuyến nháp" }).click();
  await expect(page).toHaveURL(/\/trips\/[0-9a-f-]{36}\?saved=1$/);
  await expect(page.getByText(new RegExp(`Khởi hành 11:30 .* đến 17:00 cùng ngày`))).toBeVisible();
});

test("sửa chuyến nháp: tắt Tự chia để nhập giờ điểm giữa; giờ vượt giờ đến bị chặn; lưu xong lịch trình đổi", async () => {
  await page.getByRole("link", { name: "Sửa chuyến" }).click();
  await expect(page.getByRole("heading", { name: "Sửa chuyến", level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByLabel("Giờ khởi hành *")).toHaveValue("11:30");

  const autoSplit = page.getByRole("switch", { name: /Tự chia/ });
  await expect(autoSplit).toBeChecked();
  await autoSplit.click();
  // Tắt "Tự chia": ô giờ điểm giữa mở ra và điền sẵn giờ đang xem.
  const middle = page.getByLabel("Giờ dự kiến tại E2E Trạm dừng nghỉ Madagui");
  await expect(middle).toHaveValue("14:15");

  await middle.fill("18:00");
  await page.getByRole("button", { name: "Lưu chuyến nháp" }).click();
  await expect(page.getByText("Giờ tại điểm dừng thứ 2 vượt quá giờ đến của chuyến.")).toBeVisible();

  await middle.fill("13:00");
  await page.getByRole("button", { name: "Lưu chuyến nháp" }).click();
  await expect(page).toHaveURL(/\/trips\/[0-9a-f-]{36}\?saved=1$/);
  await expect(stopRows().nth(1)).toContainText("13:00");

  // Mở lại form: chuyến đang dùng giờ tự nhập nên công tắc tắt và giữ đúng giờ đã lưu.
  await page.getByRole("link", { name: "Sửa chuyến" }).click();
  await expect(page.getByRole("switch", { name: /Tự chia/ })).not.toBeChecked();
  await expect(page.getByLabel("Giờ dự kiến tại E2E Trạm dừng nghỉ Madagui")).toHaveValue("13:00");
  await page.getByRole("button", { name: "Hủy" }).click();
  await expect(page.getByRole("link", { name: "Sửa chuyến" })).toBeVisible();
});

test("lịch xe: xe có hai chuyến nối sát giờ trong ngày, rảnh từ giờ đến chuyến cuối; bấm khoảng trống → tạo chuyến điền sẵn xe + giờ", async () => {
  await page.getByRole("link", { name: "Chuyến xe", exact: true }).click();
  await page.getByRole("tab", { name: "Lịch xe" }).click();
  await expect(page).toHaveURL(/view=schedule/);
  await page.getByLabel("Ngày", { exact: true }).fill(DAY);
  const row = page.getByRole("row").filter({ hasText: plate });
  await expect(row.getByRole("link", { name: /06:00 – 11:30/ })).toBeVisible(FIRST_VISIT);
  await expect(row.getByRole("link", { name: /11:30 – 17:00/ })).toBeVisible();
  await expect(row).toContainText("17:00");
  await row.getByRole("button", { name: `Tạo chuyến cho xe ${plate}` }).click({ position: { x: 5, y: 10 } });
  await expect(page).toHaveURL(new RegExp(`/trips/new\\?vehicleId=[0-9a-f-]{36}&date=${DAY}&time=00:00`), FIRST_VISIT);
  await expect(page.getByLabel("Ngày khởi hành *")).toHaveValue(DAY);
  await expect(page.getByLabel("Giờ khởi hành *")).toHaveValue("00:00");
  await expect(page.getByRole("region", { name: "Xe và sơ đồ ghế" })).toContainText(plate);
});

test("danh sách: sắp theo giờ khởi hành, lọc theo trạng thái, bấm dòng mở chi tiết", async () => {
  await page.getByRole("link", { name: "Chuyến xe", exact: true }).click();
  const rows = page.getByRole("row").filter({ hasText: routeName });
  await expect(rows).toHaveCount(2);
  await expect(rows.nth(0)).toContainText("06:00");
  await expect(rows.nth(0)).toContainText(plate);
  await expect(rows.nth(0)).toContainText("4 chỗ");
  await expect(rows.nth(0)).toContainText("Nháp");
  await expect(rows.nth(1)).toContainText("11:30");
  await expect(page.getByText("Đã hiển thị tất cả 2 chuyến")).toBeVisible();

  await choose("Trạng thái", "Đang mở bán");
  await expect(page.getByText("Không có chuyến khớp bộ lọc")).toBeVisible();
  await page.getByRole("button", { name: "Bỏ lọc" }).click();
  await expect(rows).toHaveCount(2);

  // "Đến ngày" tính hết ngày đó: lọc đúng ngày khởi hành vẫn đủ cả hai chuyến, lùi một ngày thì không còn.
  await page.getByLabel("Đến ngày").fill(DAY);
  await expect(rows).toHaveCount(2);
  await page.getByLabel("Khởi hành từ ngày").fill(DAY);
  await expect(rows).toHaveCount(2);
  await page.getByLabel("Khởi hành từ ngày").fill(NEXT_DAY);
  await page.getByLabel("Đến ngày").fill(NEXT_DAY);
  await expect(page.getByText("Không có chuyến khớp bộ lọc")).toBeVisible();
  await page.getByRole("button", { name: "Bỏ lọc" }).click();
  await expect(rows).toHaveCount(2);

  await rows.nth(0).getByText("06:00").click();
  await expect(page.getByRole("heading", { name: routeName, level: 1 })).toBeVisible();
  await expect(page.getByText(/Khởi hành 06:00/)).toBeVisible();
});

test("sơ đồ ghế của xe đang có chuyến chưa kết thúc bị khóa ở màn Sơ đồ ghế và form xe (UC-12 A3)", async () => {
  await page.getByRole("link", { name: "Sơ đồ ghế", exact: true }).click();
  const row = page.getByRole("row", { name: new RegExp(seatMapName) });
  await expect(row).toContainText("Đang dùng cho chuyến", FIRST_VISIT);
  await expect(page.getByText("Sơ đồ đang dùng cho chuyến chỉ có thể xem. Tạo bản sao để chỉnh sửa riêng.")).toBeVisible();

  await page.getByRole("link", { name: "Phương tiện", exact: true }).click();
  await page.getByRole("link", { name: new RegExp(`Sửa .*${plate.replace(".", "\\.")}`) }).click();
  await expect(page.getByText("Đang được chuyến chưa kết thúc sử dụng")).toBeVisible(FIRST_VISIT);
});

/** Khối nhập quy tắc giá đang mở ("Thêm quy tắc" / "Sửa quy tắc đang chọn"). */
const ruleForm = () => page.getByRole("group", { name: /quy tắc/ });
const ruleRow = (text: string | RegExp) => page.getByRole("row").filter({ hasText: text });

test("bảng giá: tạo cho tuyến chưa có giá, thiếu giá và quy tắc trùng bị chặn, lưu xong danh sách hiện khoảng giá", async () => {
  await page.getByRole("link", { name: "Bảng giá", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Bảng giá", level: 1 })).toBeVisible(FIRST_VISIT);
  const listRow = ruleRow(routeName);
  await expect(listRow).toContainText("Chưa có bảng giá");
  await expect(listRow).toContainText("E2E Văn phòng Sài Gòn → E2E Văn phòng Đà Lạt");

  // Gõ không dấu vẫn tìm ra tuyến; lọc "Đang áp dụng" thì tuyến chưa có bảng giá không hiện.
  await page.getByLabel("Tìm tuyến").fill("sai gon");
  await expect(listRow).toBeVisible();
  await choose("Trạng thái", "Đang áp dụng");
  await expect(page.getByText("Không có tuyến phù hợp")).toBeVisible();
  await page.getByRole("button", { name: "Bỏ lọc" }).click();

  await page.getByRole("link", { name: `Tạo bảng giá cho tuyến ${routeName}` }).click();
  await expect(page.getByRole("heading", { name: `Bảng giá · ${routeName}`, level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByText("0 / 200 quy tắc")).toBeVisible();

  // Quy tắc 1 — giá thường cho mọi loại xe, mọi loại chỗ. Thiếu giá thì báo ngay tại ô.
  await page.getByRole("button", { name: "Thêm quy tắc" }).click();
  await ruleForm().getByRole("button", { name: "Áp dụng quy tắc" }).click();
  await expect(ruleForm().getByRole("alert")).toHaveText("Giá là số nguyên từ 0 đến 100.000.000 ₫.");
  await ruleForm().getByLabel("Giá mỗi chỗ (₫) *").fill("300.000");
  await ruleForm().getByRole("button", { name: "Áp dụng quy tắc" }).click();
  await expect(ruleRow("Mọi loại xe").filter({ hasText: "Mọi ngày" })).toContainText("300.000 ₫");

  // Quy tắc 2 — trùng phạm vi với quy tắc 1 thì bị chặn; đổi sang loại chỗ riêng thì được.
  await page.getByRole("button", { name: "Thêm quy tắc" }).click();
  await ruleForm().getByLabel("Giá mỗi chỗ (₫) *").fill("310000");
  await ruleForm().getByRole("button", { name: "Áp dụng quy tắc" }).click();
  await expect(ruleForm().getByText(/Đã có quy tắc cùng loại xe, loại chỗ và trùng khung giờ/)).toBeVisible();
  await ruleForm().getByLabel("Loại chỗ", { exact: true }).click();
  await page.getByRole("option", { name: "Giường đơn" }).click();
  await ruleForm().getByRole("button", { name: "Áp dụng quy tắc" }).click();
  await expect(ruleRow("Giường đơn")).toContainText("310.000 ₫");

  // Quy tắc 3 — giá dịp Tết theo khung giờ khởi hành; mốc kết thúc trước mốc bắt đầu bị chặn.
  await page.getByRole("button", { name: "Thêm quy tắc" }).click();
  await ruleForm().getByLabel("Khởi hành từ").fill("2031-01-27T00:00");
  await ruleForm().getByLabel("Đến trước").fill("2031-01-20T00:00");
  await ruleForm().getByLabel("Giá mỗi chỗ (₫) *").fill("600000");
  await ruleForm().getByRole("button", { name: "Áp dụng quy tắc" }).click();
  await expect(ruleForm().getByText("Mốc kết thúc phải sau mốc bắt đầu.")).toBeVisible();
  await ruleForm().getByLabel("Khởi hành từ").fill("2031-01-20T00:00");
  await ruleForm().getByLabel("Đến trước").fill("2031-01-27T00:00");
  await ruleForm().getByRole("button", { name: "Áp dụng quy tắc" }).click();
  await expect(ruleRow("20/01/2031 00:00 – 27/01/2031 00:00")).toContainText("600.000 ₫");
  await expect(page.getByText("3 / 200 quy tắc")).toBeVisible();

  await page.getByRole("button", { name: "Lưu bảng giá" }).click();
  await expect(page).toHaveURL(/\/fares\/[0-9a-f-]{36}\?saved=1$/, FIRST_VISIT);
  await expect(page.getByText("Đã lưu bảng giá")).toBeVisible();
  const history = page.getByRole("region", { name: "Lịch sử thay đổi" });
  await expect(history).toContainText("Tạo bảng giá");
  await expect(history).toContainText("3 quy tắc · Chủ nhà xe");

  await page.getByRole("link", { name: "Quay lại danh sách bảng giá" }).click();
  await expect(listRow).toContainText("3 quy tắc");
  await expect(listRow).toContainText("300.000 ₫ – 600.000 ₫");
  await expect(listRow).toContainText("Đang áp dụng");
});

test("giá của bảng giá hiện trên từng chỗ của chuyến; sửa giá ghi vào lịch sử; ngừng áp dụng thì chỗ mất giá", async () => {
  /** Mở chi tiết chuyến khởi hành 06:00 và trả về khối tầng 1 của sơ đồ ghế. */
  async function openTripSeats() {
    await page.getByRole("link", { name: "Chuyến xe", exact: true }).click();
    await page.getByRole("row").filter({ hasText: routeName }).first().getByText("06:00").click();
    await expect(page.getByRole("heading", { name: routeName, level: 1 })).toBeVisible();
    return page.getByRole("region", { name: "Tầng 1: 4 chỗ" });
  }
  async function openFare() {
    await page.getByRole("link", { name: "Bảng giá", exact: true }).click();
    await page.getByRole("link", { name: `Sửa bảng giá tuyến ${routeName}` }).click();
    await expect(page.getByRole("heading", { name: `Bảng giá · ${routeName}`, level: 1 })).toBeVisible();
  }
  const history = page.getByRole("region", { name: "Lịch sử thay đổi" });

  // Cả bốn chỗ là giường đơn: quy tắc riêng cho giường đơn (310.000) thắng quy tắc chung (300.000).
  await expect((await openTripSeats()).getByText("310.000 ₫")).toHaveCount(4);

  await openFare();
  await page.getByRole("button", { name: /Sửa quy tắc Mọi loại xe, Giường đơn/ }).click();
  await ruleForm().getByLabel("Giá mỗi chỗ (₫) *").fill("320000");
  // Còn quy tắc đang nhập dở thì chưa cho lưu, để không lặng lẽ bỏ mất nó.
  await page.getByRole("button", { name: "Lưu bảng giá" }).click();
  await expect(page.getByText(/Bấm “Áp dụng quy tắc” hoặc “Bỏ”/)).toBeVisible();
  await ruleForm().getByRole("button", { name: "Áp dụng quy tắc" }).click();
  await page.getByRole("button", { name: "Lưu bảng giá" }).click();
  await expect(page.getByText("Đã lưu bảng giá")).toBeVisible();
  await expect(history).toContainText("Sửa giá giường đơn");
  await expect(history).toContainText("310.000 ₫ → 320.000 ₫ · Chủ nhà xe");
  await expect((await openTripSeats()).getByText("320.000 ₫")).toHaveCount(4);

  // Bảng giá ngừng áp dụng: chỗ của chuyến không còn giá và trang chuyến nhắc mở Bảng giá.
  await openFare();
  await choose("Trạng thái *", "Ngừng áp dụng");
  await page.getByRole("button", { name: "Lưu bảng giá" }).click();
  await expect(page.getByText("Đã lưu bảng giá")).toBeVisible();
  await expect(history).toContainText("Đang áp dụng → Ngừng áp dụng");
  await expect((await openTripSeats()).getByText("Chưa có giá")).toHaveCount(4);
  await expect(page.getByText(/Có chỗ chưa có giá/)).toBeVisible();
});

/** Mở chi tiết chuyến khởi hành 06:00 từ danh sách. */
async function openFirstTrip() {
  await page.getByRole("link", { name: "Chuyến xe", exact: true }).click();
  await page.getByRole("row").filter({ hasText: routeName }).first().getByText("06:00").click();
  await expect(page.getByRole("heading", { name: routeName, level: 1 })).toBeVisible();
}

const deck = () => page.getByRole("region", { name: "Tầng 1: 4 chỗ" });
const seatButton = (code: string) => deck().getByRole("button", { name: new RegExp(`^${code}`) });
const seatSummary = () => page.getByRole("region", { name: "Tình trạng chỗ" });

test("mở bán: thiếu bảng giá thì bị chặn kèm lý do, chuyến vẫn Nháp; bật lại bảng giá thì mở bán được (BR-39)", async () => {
  await openFirstTrip();
  const readiness = page.getByRole("region", { name: "Điều kiện mở bán" });
  // Chưa bấm: mục giao diện tự biết thì kết luận, còn lại chờ kiểm. Bảng giá đang ngừng áp dụng (ca trước).
  await expect(readiness).toContainText("Chưa bấm Mở bán");
  await expect(readiness).toContainText("Kiểm khi bấm Mở bán");
  await expect(page.getByRole("region", { name: "Thông tin chuyến" })).toContainText("60 phút trước giờ khởi hành");

  await page.getByRole("button", { name: "Mở bán", exact: true }).click();
  const blocked = page.getByRole("alert").filter({ hasText: "Chưa mở bán được" });
  await expect(blocked).toContainText("Còn 1 điều kiện chưa đạt. Chuyến vẫn ở trạng thái Nháp");
  await expect(readiness).toContainText("Kết quả lần bấm Mở bán gần nhất: 6 mục đạt, 1 mục chưa đạt, 1 mục chưa kiểm được.");
  await expect(readiness).toContainText("Tuyến chưa có bảng giá đang áp dụng. Tạo hoặc bật lại bảng giá ở mục Bảng giá.");
  await expect(page.getByRole("link", { name: "Sửa chuyến" })).toBeVisible();

  await page.getByRole("link", { name: "Bảng giá", exact: true }).click();
  await page.getByRole("link", { name: `Sửa bảng giá tuyến ${routeName}` }).click();
  await choose("Trạng thái *", "Đang áp dụng");
  await page.getByRole("button", { name: "Lưu bảng giá" }).click();
  await expect(page.getByText("Đã lưu bảng giá")).toBeVisible();

  await openFirstTrip();
  await expect(deck().getByText("320.000 ₫")).toHaveCount(4);
  await page.getByRole("button", { name: "Mở bán", exact: true }).click();
  await expect(page.getByRole("status").filter({ hasText: "Đã mở bán" })).toContainText(`Chuyến bán online tới 05:00 · ${DAY_LABEL}.`);
  await expect(page.getByText("Đang mở bán", { exact: true })).toBeVisible();
  // Đang bán thì không sửa thẳng được; khối Điều kiện mở bán nhường chỗ cho Tình trạng chỗ + Bán online.
  await expect(page.getByRole("link", { name: "Sửa chuyến" })).toHaveCount(0);
  await expect(readiness).toHaveCount(0);
  await expect(seatSummary()).toContainText("Còn trống4 chỗ");
  const online = page.getByRole("region", { name: "Bán online" });
  await expect(online).toContainText(`05:00 · ${DAY_LABEL}`);
  await expect(online).toContainText("60 phút trước giờ khởi hành");
});

test("khóa chỗ bán ngoài hệ thống rồi mở khóa (BR-42); tạm dừng bán, mở bán lại, thu hồi về nháp", async () => {
  // Chọn hai chỗ còn trống rồi khóa một lần, kèm ghi chú.
  await seatButton("A01").click();
  await seatButton("A02").click();
  const picked = page.getByRole("group", { name: "Chỗ đang chọn" });
  await expect(picked).toContainText("Đã chọn 2 chỗ: A01, A02");
  await picked.getByRole("button", { name: "Khóa chỗ đã chọn" }).click();
  const dialog = page.getByRole("dialog");
  await expect(dialog.getByRole("heading", { name: "Khóa 2 chỗ đã chọn?" })).toBeVisible();
  await expect(dialog.getByRole("list", { name: "Chỗ đã chọn" }).getByRole("listitem")).toHaveText(["A01", "A02"]);
  await dialog.getByLabel("Ghi chú").fill("Bán tại quầy bến xe.");
  await dialog.getByRole("button", { name: "Khóa chỗ" }).click();
  await expect(page.getByRole("status").filter({ hasText: "Đã khóa 2 chỗ: A01, A02" })).toBeVisible();
  await expect(deck().getByText("Đã khóa")).toHaveCount(2);
  await expect(seatSummary()).toContainText("Còn trống2 chỗ");
  await expect(seatSummary()).toContainText("Đã khóa2 chỗ");

  // Chọn chỗ đã khóa để mở: trong lúc đó chỗ còn trống tạm không bấm được (một lô một loại).
  await seatButton("A01").click();
  await expect(picked).toContainText("Đã chọn 1 chỗ đã khóa: A01");
  await expect(seatButton("A03")).toBeDisabled();
  await picked.getByRole("button", { name: "Mở khóa chỗ đã chọn" }).click();
  await expect(dialog.getByRole("heading", { name: "Mở khóa 1 chỗ đã chọn?" })).toBeVisible();
  await dialog.getByRole("button", { name: "Mở khóa chỗ" }).click();
  await expect(page.getByRole("status").filter({ hasText: "Đã mở khóa 1 chỗ: A01" })).toBeVisible();
  await expect(deck().getByText("Đã khóa")).toHaveCount(1);
  await expect(seatButton("A03")).toBeEnabled();

  await page.getByRole("button", { name: "Tạm dừng bán" }).click();
  await expect(page.getByRole("status").filter({ hasText: "Đã tạm dừng bán" })).toBeVisible();
  await expect(page.getByText("Tạm dừng bán", { exact: true })).toBeVisible();
  await page.getByRole("button", { name: "Mở bán lại" }).click();
  await expect(page.getByRole("status").filter({ hasText: "Đã mở bán lại" })).toBeVisible();
  await expect(page.getByText("Đang mở bán", { exact: true })).toBeVisible();

  // Danh sách lọc "Đang mở bán" thấy đúng chuyến này.
  await page.getByRole("link", { name: "Danh sách chuyến" }).click();
  await choose("Trạng thái", "Đang mở bán");
  const rows = page.getByRole("row").filter({ hasText: routeName });
  await expect(rows).toHaveCount(1);
  await rows.first().getByText("06:00").click();

  await page.getByRole("button", { name: "Thu hồi về nháp" }).click();
  await expect(page.getByRole("status").filter({ hasText: "Đã thu hồi về nháp" })).toBeVisible();
  await expect(page.getByRole("link", { name: "Sửa chuyến" })).toBeVisible();
  // Chỗ đã khóa giữ nguyên qua các lần đổi trạng thái.
  await expect(deck().getByText("Đã khóa")).toHaveCount(1);
});

test("hủy chuyến chưa có vé: bắt buộc lý do; hủy xong không còn nút thao tác và không khóa chỗ được nữa", async () => {
  await page.getByRole("button", { name: "Hủy chuyến" }).click();
  const dialog = page.getByRole("dialog");
  await expect(dialog.getByRole("heading", { name: `Hủy chuyến ${routeName}?` })).toBeVisible();
  await expect(dialog).toContainText("Hủy xong chuyến không mở bán lại được");

  await dialog.getByRole("button", { name: "Hủy chuyến" }).click();
  await expect(dialog.getByRole("alert")).toHaveText("Nhập lý do hủy chuyến.");
  await dialog.getByLabel("Lý do hủy *").fill("Xe vào xưởng bảo dưỡng đột xuất.");
  await dialog.getByRole("button", { name: "Hủy chuyến" }).click();

  await expect(page.getByRole("status").filter({ hasText: "Đã hủy chuyến" })).toBeVisible();
  await expect(page.getByText("Đã hủy", { exact: true })).toBeVisible();
  await expect(page.getByRole("region", { name: "Thông tin chuyến" })).toContainText("Xe vào xưởng bảo dưỡng đột xuất.");
  for (const name of ["Mở bán", "Hủy chuyến", "Thu hồi về nháp", "Tạm dừng bán"]) {
    await expect(page.getByRole("button", { name, exact: true })).toHaveCount(0);
  }
  await expect(page.getByRole("link", { name: "Sửa chuyến" })).toHaveCount(0);
  await expect(deck().getByRole("button")).toHaveCount(0);

  await page.getByRole("link", { name: "Danh sách chuyến" }).click();
  await choose("Trạng thái", "Đã hủy");
  await expect(page.getByRole("row").filter({ hasText: routeName })).toHaveCount(1);
});
