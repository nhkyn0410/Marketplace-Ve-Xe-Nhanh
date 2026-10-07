import { expect, test, type Page } from "@playwright/test";

import { accounts, signInWithEnrollment } from "./helpers";

// TASK-TRN-013 (màn Điểm dừng + màn Tuyến đường) — luồng chính của Owner: tạo điểm riêng, tìm không dấu, lỗi
// trùng tên báo tại ô, sửa trạng thái, gửi đề xuất ở tab Dùng chung, rồi lập tuyến từ các điểm vừa tạo. Cần
// catalog đã seed (`db:seed:catalog`, RB-08) để có tỉnh / phường. Chạy tuần tự, dùng chung một phiên: mỗi ca
// dựa trên dữ liệu ca trước tạo ra.
test.describe.configure({ mode: "serial" });

const API = "http://localhost:3000/v1";
const OFFICE = "E2E Văn phòng Đà Lạt";
const PROPOSAL = "E2E Điểm đón trả Liên Khương";
const ORIGIN = "E2E Văn phòng Sài Gòn";
const REST = "E2E Trạm nghỉ Bảo Lộc";
const DESTINATION = "E2E Văn phòng Nha Trang";
const ROUTE = "E2E Sài Gòn – Nha Trang";
// Lần đầu mở một trang, máy chủ dev của Next phải biên dịch trang đó — có thể lâu hơn 5 giây mặc định.
const FIRST_VISIT = { timeout: 30_000 };
let page: Page;
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
  await expect(page.getByText("Tính khi lưu").first()).toBeVisible();

  await save.click();
  await expect(page.getByRole("heading", { name: "Chỉnh sửa tuyến", level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByText("Đã lưu tuyến")).toBeVisible();
  await expect(page.getByText("Tính khi lưu")).toHaveCount(0);
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
