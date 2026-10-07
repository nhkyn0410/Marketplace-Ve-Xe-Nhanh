import { expect, test, type Page } from "@playwright/test";

import { accounts, signInWithEnrollment, stubMapTiles } from "./helpers";

// TASK-TRN-013 (màn Điểm dừng + màn Tuyến đường) — luồng chính của Owner: tạo điểm riêng, tìm không dấu, lỗi
// trùng tên báo tại ô, sửa trạng thái, gửi đề xuất ở tab Dùng chung, rồi lập tuyến từ các điểm vừa tạo. Cần
// catalog đã seed (`db:seed:catalog`, RB-08) để có tỉnh / phường. Chạy tuần tự, dùng chung một phiên: mỗi ca
// dựa trên dữ liệu ca trước tạo ra.
// TASK-TRN-014 (ba bản đồ) — các ca cuối file; bản đồ nền được thay bằng nền trống nên chỉ kiểm ghim, đường
// nối và thao tác.
test.describe.configure({ mode: "serial" });

const API = "http://localhost:3000/v1";
const OFFICE = "E2E Văn phòng Đà Lạt";
const PROPOSAL = "E2E Điểm đón trả Liên Khương";
const ORIGIN = "E2E Văn phòng Sài Gòn";
const REST = "E2E Trạm nghỉ Bảo Lộc";
const DESTINATION = "E2E Văn phòng Nha Trang";
const ROUTE = "E2E Sài Gòn – Nha Trang";
const PICKED = "E2E Trạm nghỉ chọn trên bản đồ";
// Lần đầu mở một trang, máy chủ dev của Next phải biên dịch trang đó — có thể lâu hơn 5 giây mặc định.
const FIRST_VISIT = { timeout: 30_000 };
const NO_MAP_KEY = "Máy chủ dev đang chạy không có NEXT_PUBLIC_GOONG_MAPTILES_KEY nên không có khối bản đồ.";
let page: Page;
let mapEnabled = false;
let province: { id: string; name: string };
let ward: { name: string };

test.beforeAll(async ({ browser, request }) => {
  const provinces = (await (await request.get(`${API}/catalog/provinces`)).json()) as { items: { id: string; name: string }[] };
  province = provinces.items[0]!;
  const wards = (await (await request.get(`${API}/catalog/wards?provinceId=${province.id}`)).json()) as {
    items: { name: string }[];
  };
  ward = wards.items[0]!;

  page = await browser.newPage();
  await stubMapTiles(page);
  const { operatorSlug, routeOwner } = accounts();
  await signInWithEnrollment(page, `${operatorSlug}/${routeOwner.username}`, routeOwner.password);
});

test.afterAll(async () => {
  await page.close();
});

/** Nút hành động ở đầu trang (đứng trước nút cùng tên ở trạng thái rỗng của bảng). */
const headerButton = (name: string) => page.getByRole("button", { name, exact: true }).first();

/** Chọn một mục trong ô chọn của hộp thoại đang mở. */
async function choose(label: string, option: string) {
  const dialog = page.getByRole("dialog");
  await dialog.getByLabel(label, { exact: true }).click();
  await page.getByRole("option", { name: option, exact: true }).click();
}

async function fillLocation(name: string, latitude = "11,9404", longitude = "108.4583") {
  const dialog = page.getByRole("dialog");
  await dialog.getByLabel("Tên điểm dừng *").fill(name);
  await dialog.getByLabel("Địa chỉ *").fill("12 Trần Phú");
  await choose("Tỉnh / thành *", province.name);
  await choose("Phường / xã *", ward.name);
  await dialog.getByLabel("Vĩ độ *").fill(latitude);
  await dialog.getByLabel("Kinh độ *").fill(longitude);
}

/** Tạo một điểm riêng đang hoạt động qua hộp thoại (đang ở tab Của nhà xe). */
async function createOwnPoint(name: string, type: string, latitude: string, longitude: string) {
  await headerButton("Thêm điểm dừng").click();
  const dialog = page.getByRole("dialog", { name: "Thêm điểm dừng" });
  await choose("Loại điểm *", type);
  await fillLocation(name, latitude, longitude);
  await dialog.getByRole("button", { name: "Lưu điểm dừng" }).click();
  await expect(page.getByRole("row", { name: new RegExp(name) })).toBeVisible();
}

test("thêm điểm dừng riêng: thiếu ô bắt buộc báo tại ô, lưu xong hiện ở bảng, gõ không dấu vẫn tìm ra", async () => {
  await page.getByRole("link", { name: "Điểm dừng", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Điểm dừng", level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByText("Thêm điểm dừng đầu tiên")).toBeVisible();

  await headerButton("Thêm điểm dừng").click();
  const dialog = page.getByRole("dialog", { name: "Thêm điểm dừng" });
  await dialog.getByRole("button", { name: "Lưu điểm dừng" }).click();
  await expect(dialog.getByText("Nhập tên điểm dừng.")).toBeVisible();
  await expect(dialog.getByText("Chọn loại điểm.")).toBeVisible();
  await expect(dialog.getByText("Chọn phường / xã.")).toBeVisible();

  // Nhà xe chỉ tự tạo được văn phòng trung chuyển và trạm dừng nghỉ (BR-38).
  await dialog.getByLabel("Loại điểm *", { exact: true }).click();
  await expect(page.getByRole("option")).toHaveText(["Văn phòng trung chuyển", "Trạm dừng nghỉ"]);
  await page.getByRole("option", { name: "Văn phòng trung chuyển" }).click();
  await fillLocation(OFFICE);
  await dialog.getByRole("button", { name: "Lưu điểm dừng" }).click();

  await expect(page.getByRole("status").filter({ hasText: `Đã thêm điểm dừng “${OFFICE}”.` })).toBeVisible();
  const row = page.getByRole("row", { name: new RegExp(OFFICE) });
  await expect(row).toContainText("Văn phòng trung chuyển");
  await expect(row).toContainText(province.name);
  await expect(row).toContainText("Chưa dùng");
  await expect(row).toContainText("Hoạt động");

  const search = page.getByLabel("Tìm kiếm");
  await search.fill("e2e van phong da lat");
  await expect(row).toBeVisible();
  await search.fill("khong co diem nay");
  await expect(page.getByText("Không có điểm dừng phù hợp")).toBeVisible();
  await page.getByRole("button", { name: "Bỏ lọc" }).click();
  await expect(row).toBeVisible();
});

test("trùng tên báo ngay tại ô tên; sửa điểm sang Ngừng dùng", async () => {
  await headerButton("Thêm điểm dừng").click();
  const create = page.getByRole("dialog", { name: "Thêm điểm dừng" });
  await choose("Loại điểm *", "Trạm dừng nghỉ");
  await fillLocation(OFFICE);
  await create.getByRole("button", { name: "Lưu điểm dừng" }).click();
  await expect(create.getByText("Tên điểm dừng đã tồn tại trong nhà xe.")).toBeVisible();
  await create.getByRole("button", { name: "Hủy" }).click();
  await expect(create).toBeHidden();

  await page.getByRole("button", { name: `Sửa điểm dừng ${OFFICE}` }).click();
  const edit = page.getByRole("dialog", { name: "Sửa điểm dừng" });
  await expect(edit.getByLabel("Tên điểm dừng *")).toHaveValue(OFFICE);
  await expect(edit.getByLabel("Vĩ độ *")).toHaveValue("11.9404");
  await choose("Trạng thái *", "Ngừng dùng");
  await edit.getByRole("button", { name: "Lưu điểm dừng" }).click();
  await expect(page.getByRole("row", { name: new RegExp(OFFICE) })).toContainText("Ngừng dùng");
});

test("tab Dùng chung: danh mục chỉ xem, đề xuất bắt buộc căn cứ công bố và hiện Chờ duyệt", async () => {
  await page.getByRole("tab", { name: "Dùng chung" }).click();
  await expect(page).toHaveURL(/\/stop-points\?tab=shared$/);
  const catalogue = page.getByRole("region", { name: "Danh mục dùng chung" });
  await expect(catalogue).toBeVisible();
  await expect(catalogue.getByRole("button", { name: /^Sửa/ })).toHaveCount(0);
  await expect(page.getByText("Chưa có đề xuất nào")).toBeVisible();

  await headerButton("Đề xuất điểm dừng").click();
  const dialog = page.getByRole("dialog", { name: "Đề xuất điểm dừng" });
  // Chỉ đề xuất được bến xe và điểm dừng đón trả khách (BR-38).
  await dialog.getByLabel("Loại điểm *", { exact: true }).click();
  await expect(page.getByRole("option")).toHaveText(["Bến xe", "Điểm dừng đón trả khách"]);
  await page.getByRole("option", { name: "Điểm dừng đón trả khách" }).click();
  await fillLocation(PROPOSAL);
  await dialog.getByRole("button", { name: "Gửi đề xuất" }).click();
  await expect(dialog.getByText("Nhập căn cứ công bố.")).toBeVisible();
  await dialog.getByLabel("Căn cứ công bố *").fill("QĐ 1234/QĐ-SXD ngày 12/08/2026");
  await dialog.getByRole("button", { name: "Gửi đề xuất" }).click();

  const row = page.getByRole("row", { name: new RegExp(PROPOSAL) });
  await expect(row).toContainText("Điểm dừng đón trả khách");
  await expect(row).toContainText("QĐ 1234/QĐ-SXD ngày 12/08/2026");
  await expect(row).toContainText("Chờ duyệt");
  // Đề xuất đang chờ duyệt không sửa được.
  await expect(row.getByRole("button")).toHaveCount(0);

  // Tải lại trang vẫn ở tab Dùng chung.
  await page.reload();
  await expect(page.getByRole("tab", { name: "Dùng chung" })).toHaveAttribute("aria-selected", "true");
});

test("lập tuyến: bảng chọn mở ngay trong form, công tắc đón / trả khóa theo vị trí, lưu xong có số liệu từng chặng", async () => {
  await page.getByRole("tab", { name: "Của nhà xe" }).click();
  await createOwnPoint(ORIGIN, "Văn phòng trung chuyển", "10.7553", "106.6822");
  await createOwnPoint(REST, "Trạm dừng nghỉ", "11.5480", "107.8070");
  await createOwnPoint(DESTINATION, "Văn phòng trung chuyển", "12.2451", "109.1943");

  await page.getByRole("link", { name: "Tuyến đường", exact: true }).click();
  await expect(page.getByText("Lập tuyến đầu tiên")).toBeVisible(FIRST_VISIT);
  await page.getByRole("link", { name: "Thêm tuyến" }).first().click();
  await expect(page.getByRole("heading", { name: "Thêm tuyến", level: 1 })).toBeVisible(FIRST_VISIT);

  // Bấm lưu khi còn trống: lỗi ở ô tên và ở danh sách điểm dừng cùng lúc.
  const save = page.getByRole("button", { name: "Lưu tuyến" });
  await save.click();
  await expect(page.getByRole("alert").filter({ hasText: "Nhập tên tuyến." })).toBeVisible();
  await expect(page.getByRole("alert").filter({ hasText: "Tuyến cần ít nhất 2 điểm dừng." })).toBeVisible();
  await page.getByLabel("Tên tuyến *").fill(ROUTE);

  await page.getByRole("button", { name: "Thêm điểm dừng", exact: true }).click();
  const picker = page.getByRole("region", { name: "Thêm điểm dừng vào tuyến" });
  await expect(picker).toBeVisible();
  // Khanh chốt 07/10/2026: bảng chọn không phải hộp thoại che nền — form vẫn dùng được.
  await expect(page.getByRole("dialog")).toHaveCount(0);
  await picker.getByRole("tab", { name: "Của nhà xe" }).click();
  await expect(picker.getByRole("button", { name: `Thêm ${ORIGIN} vào tuyến` })).toBeVisible();
  // Điểm đã ngừng dùng không chọn được cho tuyến.
  await expect(picker.getByText(OFFICE)).toHaveCount(0);
  for (const name of [ORIGIN, DESTINATION, REST]) {
    await picker.getByRole("button", { name: `Thêm ${name} vào tuyến` }).click();
  }
  await expect(picker.getByText("Đã thêm")).toHaveCount(3);
  await expect(picker.getByText("Tuyến đang có 3 / 25 điểm")).toBeVisible();

  // Trạm dừng nghỉ đang đứng cuối: chưa lưu được, đổi thứ tự thì hết lỗi.
  await save.click();
  await expect(page.getByRole("alert").filter({ hasText: "Trạm dừng nghỉ không được đứng đầu hoặc cuối tuyến" })).toBeVisible();
  await page.getByRole("button", { name: `Chuyển ${REST} lên trước` }).click();
  const stops = page.getByRole("list", { name: "Điểm dừng của tuyến" });
  await expect(stops.getByRole("listitem")).toHaveText([new RegExp(ORIGIN), new RegExp(REST), new RegExp(DESTINATION)]);

  const toggle = (action: "Cho đón" | "Cho trả", name: string) => page.getByRole("switch", { name: `${action} tại ${name}` });
  for (const [name, pickup, dropoff] of [
    [ORIGIN, true, false],
    [REST, false, false],
    [DESTINATION, false, true]
  ] as const) {
    await expect(toggle("Cho đón", name)).toBeChecked({ checked: pickup });
    await expect(toggle("Cho trả", name)).toBeChecked({ checked: dropoff });
    await expect(toggle("Cho đón", name)).toBeDisabled();
    await expect(toggle("Cho trả", name)).toBeDisabled();
  }
  await expect(page.getByRole("note").filter({ hasText: "Điểm đầu và điểm cuối không phải bến xe" })).toBeVisible();
  // `exact`: chú thích của bản đồ lộ trình cũng có cụm "tính khi lưu".
  await expect(page.getByText("Tính khi lưu", { exact: true }).first()).toBeVisible();

  await save.click();
  await expect(page.getByRole("heading", { name: "Chỉnh sửa tuyến", level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByText("Đã lưu tuyến")).toBeVisible();
  await expect(page.getByText("Tính khi lưu", { exact: true })).toHaveCount(0);
  await expect(stops.getByText(/ km · /)).toHaveCount(2);
});

test("danh sách tuyến hiện điểm đầu → điểm cuối; điểm dừng báo số tuyến đang dùng", async () => {
  await page.getByRole("link", { name: "Tuyến đường", exact: true }).click();
  const row = page.getByRole("row", { name: new RegExp(ROUTE) });
  await expect(row).toContainText(ORIGIN);
  await expect(row).toContainText(DESTINATION);
  await expect(row).toContainText("3 điểm");
  await expect(row).toContainText("Hoạt động");

  await page.getByRole("link", { name: "Điểm dừng", exact: true }).click();
  await expect(page.getByRole("row", { name: new RegExp(ORIGIN) })).toContainText("1 tuyến");
  await expect(page.getByRole("row", { name: new RegExp(OFFICE) })).toContainText("Chưa dùng");
});

test("bản đồ tổng quan: mặc định thu gọn, mỗi dòng một ghim, bấm ghim / dòng hiện thẻ xem nhanh, nhớ lựa chọn", async () => {
  // Đang ở tab Của nhà xe với 4 điểm: OFFICE (ngừng dùng), ORIGIN, REST, DESTINATION.
  const show = page.getByRole("button", { name: "Hiện bản đồ" });
  mapEnabled = await show.isVisible();
  test.skip(!mapEnabled, NO_MAP_KEY);
  await expect(show).toHaveAttribute("aria-expanded", "false");
  await expect(page.getByRole("button", { name: /^Xem .+ trên bản đồ$/ })).toHaveCount(0);

  await show.click();
  const pins = page.getByRole("button", { name: /^Xem nhanh / });
  await expect(pins).toHaveCount(4, FIRST_VISIT);
  await expect(page.getByText("Đang hiện 4 điểm trong danh sách bên dưới.")).toBeVisible();

  // Bấm ghim của điểm ngừng dùng: thẻ ghi rõ trạng thái.
  await page.getByRole("button", { name: `Xem nhanh ${OFFICE}` }).click();
  const officeCard = page.getByRole("group", { name: `Thông tin ${OFFICE}` });
  await expect(officeCard).toContainText("Văn phòng trung chuyển · Ngừng dùng");
  await officeCard.getByRole("button", { name: "Đóng thẻ xem nhanh" }).click();
  await expect(officeCard).toHaveCount(0);

  // Bấm một dòng của bảng: bản đồ chuyển tới điểm đó, dòng được tô.
  await page.getByRole("row", { name: new RegExp(ORIGIN) }).getByText("Văn phòng trung chuyển").click();
  await expect(page.getByRole("group", { name: `Thông tin ${ORIGIN}` })).toContainText("1 tuyến đang dùng");
  // Dùng bàn phím: tên điểm là một nút.
  await page.getByRole("button", { name: `Xem ${REST} trên bản đồ` }).press("Enter");
  await expect(page.getByRole("group", { name: `Thông tin ${REST}` })).toContainText("Trạm dừng nghỉ");
  // Bấm nút Sửa trong dòng không đổi điểm đang chọn trên bản đồ.
  await page.getByRole("button", { name: `Sửa điểm dừng ${DESTINATION}` }).click();
  await page.getByRole("dialog", { name: "Sửa điểm dừng" }).getByRole("button", { name: "Hủy" }).click();
  await expect(page.getByRole("group", { name: `Thông tin ${REST}` })).toBeVisible();

  // Bản đồ theo đúng bộ lọc của bảng.
  await page.getByLabel("Tìm kiếm").fill("e2e tram nghi");
  await expect(pins).toHaveCount(1);
  await page.getByLabel("Tìm kiếm").fill("");
  await expect(pins).toHaveCount(4);

  // Nhớ lựa chọn: tải lại trang vẫn mở; thu gọn lại cho các ca sau.
  await page.reload();
  const hide = page.getByRole("button", { name: "Ẩn bản đồ" });
  await expect(hide).toBeVisible(FIRST_VISIT);
  await hide.click();
  await expect(show).toHaveAttribute("aria-expanded", "false");
  await expect(pins).toHaveCount(0);
});

test("hộp thoại điểm dừng: bấm bản đồ để lấy tọa độ, lưu được điểm với tọa độ đó", async () => {
  test.skip(!mapEnabled, NO_MAP_KEY);
  await headerButton("Thêm điểm dừng").click();
  const dialog = page.getByRole("dialog", { name: "Thêm điểm dừng" });
  const map = dialog.getByRole("region", { name: "Bản đồ chọn vị trí điểm dừng" });
  await expect(map).toBeVisible(FIRST_VISIT);
  await expect(dialog.getByRole("status", { name: "Đang tải bản đồ" })).toHaveCount(0);
  await expect(dialog.getByText("Bấm vào bản đồ để đặt ghim")).toBeVisible();

  await choose("Loại điểm *", "Trạm dừng nghỉ");
  await dialog.getByLabel("Tên điểm dừng *").fill(PICKED);
  await dialog.getByLabel("Địa chỉ *").fill("Quốc lộ 20");
  await choose("Tỉnh / thành *", province.name);
  await choose("Phường / xã *", ward.name);

  const coordinate = /^-?\d+(\.\d{1,6})?$/;
  await map.click({ position: { x: 150, y: 110 } });
  await expect(dialog.getByLabel("Vĩ độ *")).toHaveValue(coordinate);
  await expect(dialog.getByLabel("Kinh độ *")).toHaveValue(coordinate);
  await expect(dialog.getByText("Bấm hoặc kéo ghim để chọn vị trí")).toBeVisible();
  const latitude = await dialog.getByLabel("Vĩ độ *").inputValue();

  // Bấm chỗ khác thì ghim và tọa độ đổi theo.
  await map.click({ position: { x: 230, y: 170 } });
  await expect(dialog.getByLabel("Vĩ độ *")).not.toHaveValue(latitude);
  const picked = await dialog.getByLabel("Vĩ độ *").inputValue();

  await dialog.getByRole("button", { name: "Lưu điểm dừng" }).click();
  await expect(page.getByRole("row", { name: new RegExp(PICKED) })).toBeVisible();

  // Mở lại để sửa: tọa độ đã lưu đúng như đã chọn trên bản đồ, ghim đã có sẵn.
  await page.getByRole("button", { name: `Sửa điểm dừng ${PICKED}` }).click();
  const edit = page.getByRole("dialog", { name: "Sửa điểm dừng" });
  await expect(edit.getByLabel("Vĩ độ *")).toHaveValue(picked);
  await expect(edit.getByText("Bấm hoặc kéo ghim để chọn vị trí")).toBeVisible();
  await edit.getByRole("button", { name: "Hủy" }).click();
});

test("bản đồ lộ trình: ghim đánh số theo thứ tự, đổi theo khi thêm / đổi chỗ, bảng chọn hiện chấm của điểm chưa thêm", async () => {
  test.skip(!mapEnabled, NO_MAP_KEY);
  await page.getByRole("link", { name: "Tuyến đường", exact: true }).click();
  await page.getByRole("link", { name: `Sửa tuyến ${ROUTE}` }).click();
  await expect(page.getByRole("heading", { name: "Chỉnh sửa tuyến", level: 1 })).toBeVisible(FIRST_VISIT);

  const routeMap = page.getByRole("region", { name: "Lộ trình trên bản đồ" });
  const numbered = routeMap.getByRole("img");
  await expect(numbered).toHaveText(["1", "2", "3"], FIRST_VISIT);
  await expect(numbered.nth(0)).toHaveAccessibleName(`Điểm 1: ${ORIGIN}`);
  await expect(numbered.nth(1)).toHaveAccessibleName(`Điểm 2: ${REST}`);
  await expect(numbered.nth(2)).toHaveAccessibleName(`Điểm 3: ${DESTINATION}`);
  await expect(routeMap.getByText("Điểm trong bảng chọn")).toHaveCount(0);

  // Mở bảng chọn: điểm chưa có trong tuyến hiện trên bản đồ; rê vào dòng thì có nhãn.
  await page.getByRole("button", { name: "Thêm điểm dừng", exact: true }).click();
  const picker = page.getByRole("region", { name: "Thêm điểm dừng vào tuyến" });
  await picker.getByRole("tab", { name: "Của nhà xe" }).click();
  const add = picker.getByRole("button", { name: `Thêm ${PICKED} vào tuyến` });
  await expect(add).toBeVisible();
  await expect(routeMap.getByText("Điểm trong bảng chọn")).toBeVisible();
  await add.hover();
  await expect(routeMap.getByText("Chưa có trong tuyến")).toBeVisible();
  await expect(routeMap.getByText(PICKED)).toBeVisible();

  // Thêm vào tuyến: thành ghim số 4, hết nhãn "chưa có trong tuyến".
  await add.click();
  await expect(numbered).toHaveText(["1", "2", "3", "4"]);
  await expect(routeMap.getByRole("img", { name: `Điểm 4: ${PICKED}` })).toBeVisible();
  await expect(routeMap.getByText("Chưa có trong tuyến")).toHaveCount(0);

  // Đổi chỗ trong danh sách: số trên bản đồ đổi theo.
  await page.getByRole("button", { name: `Chuyển ${PICKED} lên trước` }).click();
  await expect(routeMap.getByRole("img", { name: `Điểm 3: ${PICKED}` })).toBeVisible();
  await expect(routeMap.getByRole("img", { name: `Điểm 4: ${DESTINATION}` })).toBeVisible();
  // Bỏ khỏi tuyến: ghim mất.
  await page.getByRole("button", { name: `Bỏ ${PICKED} khỏi tuyến` }).click();
  await expect(numbered).toHaveText(["1", "2", "3"]);

  // Ẩn / hiện bản đồ lộ trình.
  await routeMap.getByRole("button", { name: "Ẩn bản đồ" }).click();
  await expect(numbered).toHaveCount(0);
  await routeMap.getByRole("button", { name: "Hiện bản đồ" }).click();
  await expect(numbered).toHaveText(["1", "2", "3"]);
});
