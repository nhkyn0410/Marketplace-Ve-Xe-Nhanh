import { expect, test, type Page } from "@playwright/test";

import { accounts, signInWithEnrollment } from "./helpers";

// TASK-TRN-003 (màn Chuyến xe) — luồng chính của Owner: tạo chuyến nháp từ tuyến + xe dựng sẵn, xe trùng giờ
// báo tại ô Xe (BR-14), sửa chuyến với giờ tự nhập tại điểm dừng, lọc danh sách, và sơ đồ ghế của xe đang có
// chuyến bị khóa ở màn Sơ đồ ghế (UC-12 A3). Tuyến + xe do global-setup seed (`tripFixtures`), cần catalog đã
// seed (`db:seed:catalog`, RB-08). Chạy tuần tự, dùng chung một phiên: mỗi ca dựa trên dữ liệu ca trước tạo ra.
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
  await expect(deck.getByText("Còn trống")).toHaveCount(4);
  await expect(stopRows().nth(1)).toContainText("08:45");
  const info = page.getByRole("region", { name: "Thông tin chuyến" });
  await expect(info).toContainText("5 giờ 30 phút");
  await expect(info).toContainText("4 chỗ");
});

test("xe trùng giờ báo ngay tại ô Xe (BR-14); khởi hành đúng lúc chuyến trước đến thì lưu được", async () => {
  await page.getByRole("link", { name: "Danh sách chuyến" }).click();
  await page.getByRole("link", { name: "Tạo chuyến" }).first().click();
  await fillTrip("08:00");
  await expect(page.getByLabel("Giờ đến *")).toHaveValue("13:30");
  await page.getByRole("button", { name: "Lưu chuyến nháp" }).click();
  await expect(page.getByText("Xe đã có chuyến khác trùng khoảng giờ này. Chọn xe khác hoặc đổi giờ của chuyến.")).toBeVisible();
  // Dữ liệu đang nhập còn nguyên.
  await expect(page.getByLabel("Giờ khởi hành *")).toHaveValue("08:00");

  // Không có thời gian đệm quay đầu: chuyến sau khởi hành đúng 11:30 là hợp lệ; giờ đến gợi ý lại theo giờ đi mới.
  await page.getByLabel("Giờ khởi hành *").fill("11:30");
  await expect(page.getByLabel("Giờ đến *")).toHaveValue("17:00");
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

test("danh sách: sắp theo giờ khởi hành, lọc theo trạng thái, bấm dòng mở chi tiết", async () => {
  await page.getByRole("link", { name: "Danh sách chuyến" }).click();
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
