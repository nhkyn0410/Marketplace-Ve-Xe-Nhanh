import { expect, test, type Page } from "@playwright/test";

import { accounts, API, signInPlatform } from "./helpers";

// TASK-ADM-003 phần ảnh xe (Figma ADM-10b/10c, FR-ADM-20) + Nhật ký audit (Figma ADM-15a/15b, UC-30): gỡ một ảnh
// phương tiện kèm lý do rồi tìm đúng bản ghi audit của thao tác đó, mở chi tiết, thấy lượt xem được ghi lại.
test.describe.configure({ mode: "serial" });

let page: Page;
const REASON = "Ảnh có giấy tờ xe — vi phạm quy định hiển thị";

test.beforeAll(async ({ browser }) => {
  page = await browser.newPage();
});

test.afterAll(async () => {
  await page.close();
});

function plateText(plate: string): string {
  const match = /^(\d{2}[A-Z]{1,2})(\d{3})(\d{2})$/.exec(plate);
  return match ? `${match[1]}-${match[2]}.${match[3]}` : plate;
}

test("kiểm duyệt: lọc theo nhà xe, gỡ ảnh thiếu lý do báo tại ô, có lý do → ảnh biến mất, ảnh còn lại thành ảnh đại diện", async () => {
  const fixtures = accounts().moderation;
  test.skip(fixtures === null, "Catalog chưa seed loại xe (pnpm --filter @vexenhanh/api db:seed:catalog).");
  const { operatorName, plateNumber, captions } = fixtures!;
  await signInPlatform(page, accounts().platformModeration);
  await page.getByRole("link", { name: "Kiểm duyệt", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Kiểm duyệt" })).toBeVisible({ timeout: 20_000 });
  await expect(page.getByRole("tab", { name: "Ảnh phương tiện" })).toHaveAttribute("aria-selected", "true");
  await expect(page.getByRole("tab", { name: "Đánh giá" })).toBeDisabled();

  await page.getByRole("combobox", { name: "Nhà xe" }).click();
  await page.getByRole("option", { name: operatorName, exact: true }).click();
  const grid = page.getByRole("list", { name: "Ảnh phương tiện" });
  await expect(grid.getByRole("listitem")).toHaveCount(2);
  const cover = grid.getByRole("listitem").filter({ hasText: captions[0]! });
  await expect(cover).toContainText("Ảnh đại diện");
  await expect(cover).toContainText(plateText(plateNumber));

  const plate = plateText(plateNumber);
  await cover.getByRole("button", { name: `Gỡ ảnh xe ${plate} của ${operatorName}` }).click();
  const dialog = page.getByRole("dialog", { name: "Gỡ ảnh phương tiện" });
  await expect(dialog).toContainText(`${operatorName} · xe ${plate} · “${captions[0]}”`);
  await expect(dialog).toContainText("không khôi phục được");
  await dialog.getByRole("button", { name: "Gỡ ảnh" }).click();
  await expect(dialog.getByText("Nhập lý do (ít nhất 3 ký tự).")).toBeVisible();
  await dialog.getByLabel("Lý do gỡ ảnh *").fill(REASON);
  await dialog.getByRole("button", { name: "Gỡ ảnh" }).click();
  await expect(dialog).toBeHidden();
  await expect(page.getByRole("status").filter({ hasText: `Đã gỡ ảnh của xe ${plate} (${operatorName}).` })).toBeVisible();
  await expect(grid.getByRole("listitem")).toHaveCount(1);
  await expect(grid.getByRole("listitem").first()).toContainText(captions[1]!);
  await expect(grid.getByRole("listitem").first()).toContainText("Ảnh đại diện");
});

test("nhật ký audit: tìm theo tài khoản + phân hệ ra đúng thao tác gỡ ảnh; chi tiết có lý do, trước / sau, chuỗi bản ghi; lượt xem được ghi", async () => {
  test.skip(accounts().moderation === null, "Không có dữ liệu kiểm duyệt.");
  const username = `platform/${accounts().platformModeration.username}`;
  await page.getByRole("link", { name: "Nhật ký audit", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Nhật ký audit" })).toBeVisible({ timeout: 20_000 });
  await page.getByRole("combobox", { name: "Phân hệ" }).click();
  await page.getByRole("option", { name: "Phương tiện", exact: true }).click();
  await page.getByRole("searchbox", { name: "Tìm kiếm" }).fill(username);
  const row = page.getByRole("row").filter({ hasText: "Gỡ ảnh phương tiện" });
  await expect(row).toHaveCount(1);
  await expect(row).toContainText(username);
  await expect(row).toContainText("Quản trị viên");
  await expect(row).toContainText(accounts().moderation!.operatorName);
  await expect(row).toContainText("Thành công");

  await row.getByRole("link", { name: /^Xem bản ghi Gỡ ảnh phương tiện/ }).click();
  await expect(page.getByRole("heading", { name: "Gỡ ảnh phương tiện", level: 1 })).toBeVisible({ timeout: 20_000 });
  await expect(page.getByRole("region", { name: "Lý do và ghi chú" })).toContainText(REASON);
  const diff = page.getByRole("region", { name: "Trước và sau" });
  await expect(diff.getByRole("row").filter({ hasText: "plateNumber" })).toContainText(accounts().moderation!.plateNumber);
  await expect(diff.getByRole("row").filter({ hasText: "caption" })).toContainText(accounts().moderation!.captions[0]!);
  await expect(page.getByRole("region", { name: "Chuỗi bản ghi liên quan" })).toContainText("bản ghi đang xem");
  await expect(page.getByText("Lượt xem chi tiết này đã được ghi vào nhật ký audit.")).toBeVisible();

  await page.getByRole("link", { name: "Quay lại nhật ký audit" }).click();
  await page.getByRole("combobox", { name: "Phân hệ" }).click();
  await page.getByRole("option", { name: "Nhật ký audit", exact: true }).click();
  await page.getByRole("searchbox", { name: "Tìm kiếm" }).fill(username);
  await expect(page.getByRole("row").filter({ hasText: "Xem chi tiết nhật ký" }).first()).toBeVisible();
});

// TASK-ADM-003 phần nội dung công khai (Figma ADM-10d): tạo câu hỏi thường gặp → hiển thị → API công khai trả về; banner bắt
// buộc ảnh, liên kết sang miền khác bị chặn; trang tĩnh tự sinh đường dẫn, trùng đường dẫn báo tại ô. Nội dung là dữ liệu
// dùng chung giữa các lần chạy nên tiêu đề kèm mã riêng của lần chạy.
const RUN = Date.now().toString(36);
/** PNG 1×1 hợp lệ — trình duyệt nén lại thành JPEG trước khi tải lên. */
const PIXEL_PNG = Buffer.from("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==", "base64");

async function openNewContent() {
  await page.getByRole("link", { name: "Kiểm duyệt", exact: true }).click();
  await page.getByRole("tab", { name: "Nội dung công khai" }).click();
  await page.getByRole("link", { name: "Thêm nội dung" }).click();
  await expect(page.getByRole("heading", { name: "Thêm nội dung", level: 1 })).toBeVisible({ timeout: 20_000 });
}

test("nội dung công khai: câu hỏi thường gặp thiếu ô báo tại ô → lưu nháp → hiển thị → API công khai trả về; danh sách + xem trước", async () => {
  if (page.url() === "about:blank") {
    await signInPlatform(page, accounts().platformModeration);
  }
  const question = `Tôi có cần tài khoản để đặt vé không? ${RUN}`;
  await openNewContent();
  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page.getByText("Nhập tiêu đề.")).toBeVisible();
  await expect(page.getByText("Nhập nội dung.")).toBeVisible();

  await page.getByLabel("Câu hỏi *").fill(question);
  await page.getByLabel("Câu trả lời *").fill("Không. Bạn đặt vé được **không cần tài khoản**.");
  await expect(page.getByRole("region", { name: "Xem trước" }).locator("strong")).toHaveText("không cần tài khoản");
  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page.getByText("Đã tạo nội dung (bản nháp).")).toBeVisible({ timeout: 20_000 });
  await expect(page).toHaveURL(/\/moderation\/content\/[0-9a-f-]{36}/);

  await page.getByRole("button", { name: "Hiển thị" }).click();
  await expect(page.getByText("Nội dung đang hiển thị công khai.")).toBeVisible();
  await expect(page.getByText("Đang hiển thị", { exact: true })).toBeVisible();
  const published = await (await page.request.get(`${API}/content-pages?type=FAQ&placement=BOOKING`)).json();
  expect((published as { items: { title: string }[] }).items.map((item) => item.title)).toContain(question);

  await page.getByRole("link", { name: "Về Kiểm duyệt" }).click();
  await expect(page.getByRole("tab", { name: "Nội dung công khai" })).toHaveAttribute("aria-selected", "true");
  await page.getByLabel("Tìm kiếm").fill(RUN);
  const row = page.getByRole("row").filter({ hasText: question });
  await expect(row).toContainText("Câu hỏi thường gặp");
  await expect(row).toContainText("Đặt vé và thanh toán");
  await expect(row).toContainText("Đang hiển thị");
  await row.getByRole("button", { name: `Xem trước ${question}` }).click();
  await expect(page.getByRole("dialog").locator("strong")).toHaveText("không cần tài khoản");
  await page.keyboard.press("Escape");
});

test("banner bắt buộc ảnh, liên kết sang miền khác bị chặn; tải ảnh lên rồi lưu nháp", async () => {
  await openNewContent();
  await page.getByLabel("Loại nội dung *").click();
  await page.getByRole("option", { name: "Banner" }).click();
  await page.getByLabel("Tiêu đề *").fill(`Banner trang chủ · Đi Việt Nam. Nhanh ${RUN}`);
  await page.getByLabel("Liên kết khi bấm").fill("//evil.example");
  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page.getByText("Tải ảnh banner lên.")).toBeVisible();
  await expect(page.getByText("Liên kết bắt đầu bằng / (trang trong Vé Xe Nhanh) hoặc https://.")).toBeVisible();
  await page.getByLabel("Chọn ảnh banner").setInputFiles({ name: "banner.png", mimeType: "image/png", buffer: PIXEL_PNG });
  await expect(page.getByRole("button", { name: "Đổi ảnh" })).toBeVisible({ timeout: 20_000 });
  await page.getByLabel("Liên kết khi bấm").fill("/tim-chuyen");
  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page.getByText("Đã tạo nội dung (bản nháp).")).toBeVisible({ timeout: 20_000 });
});

test("trang tĩnh tự sinh đường dẫn, hiển thị ngay; trùng đường dẫn báo tại ô", async () => {
  const title = `Điều khoản sử dụng ${RUN}`;
  await openNewContent();
  await page.getByLabel("Loại nội dung *").click();
  await page.getByRole("option", { name: "Trang tĩnh" }).click();
  await page.getByLabel("Tiêu đề *").fill(title);
  await expect(page.getByLabel("Đường dẫn *")).toHaveValue(`dieu-khoan-su-dung-${RUN}`);
  await page.getByLabel("Nội dung trang *").fill("## Điều 1\n\nNội dung điều khoản.");
  await page.getByRole("button", { name: "Hiển thị" }).click();
  await expect(page.getByText("Nội dung đang hiển thị công khai.")).toBeVisible({ timeout: 20_000 });
  expect((await page.request.get(`${API}/content-pages/dieu-khoan-su-dung-${RUN}`)).status()).toBe(200);

  await openNewContent();
  await page.getByLabel("Loại nội dung *").click();
  await page.getByRole("option", { name: "Trang tĩnh" }).click();
  await page.getByLabel("Tiêu đề *").fill(title);
  await page.getByLabel("Nội dung trang *").fill("Bản trùng.");
  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page.getByText("Đường dẫn này đã có trang khác dùng.")).toBeVisible();
});
