import { randomUUID } from "node:crypto";

import { expect, test, type Page } from "@playwright/test";

import { accounts, API, signInPlatform } from "./helpers";

// TASK-CNT-001 (Figma ADM-13a…13c, UC-40, BR-74): chuyên mục thêm / ngừng dùng / dùng lại; bài mới báo lỗi tại ô,
// slug tự sinh, xem trước Markdown, ảnh bìa, lưu nháp → xuất bản (hiện ở API công khai) → gỡ (ẩn); trùng slug.
test.describe.configure({ mode: "serial" });

const tag = randomUUID().replace(/-/g, "").slice(0, 6);
const CATEGORY = `E2E Chuyên mục ${tag}`;
const TITLE = `E2E Đà Lạt mùa dã quỳ ${tag}`;
const SLUG = `e2e-da-lat-mua-da-quy-${tag}`;
// PNG 1×1 hợp lệ — trình duyệt nén lại thành JPEG trước khi tải lên.
const PIXEL = Buffer.from(
  "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==",
  "base64"
);
let page: Page;

test.beforeAll(async ({ browser }) => {
  page = await browser.newPage();
});

test.afterAll(async () => {
  await page.close();
});

async function openArticles() {
  await page.getByRole("link", { name: "Bài viết", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Bài viết", level: 1 })).toBeVisible({ timeout: 20_000 });
}

test("chuyên mục: thêm (slug tự sinh), ngừng dùng có xác nhận, dùng lại", async () => {
  await signInPlatform(page, accounts().platformContent);
  await openArticles();
  await page.getByRole("tab", { name: "Chuyên mục" }).click();
  await page.getByRole("button", { name: "Thêm chuyên mục" }).click();
  const dialog = page.getByRole("dialog", { name: "Thêm chuyên mục" });
  await dialog.getByLabel("Tên chuyên mục *").fill(CATEGORY);
  await expect(dialog.getByLabel("Slug *")).toHaveValue(`e2e-chuyen-muc-${tag}`);
  await dialog.getByRole("button", { name: "Lưu" }).click();
  await expect(dialog).toBeHidden();
  const row = page.getByRole("row").filter({ hasText: CATEGORY });
  await expect(row).toContainText("Đang dùng");

  await row.getByRole("button", { name: `Ngừng dùng chuyên mục ${CATEGORY}` }).click();
  await page.getByRole("alertdialog").getByRole("button", { name: "Ngừng dùng" }).click();
  await expect(row).toContainText("Ngừng dùng");
  await row.getByRole("button", { name: `Dùng lại chuyên mục ${CATEGORY}` }).click();
  await page.getByRole("alertdialog").getByRole("button", { name: "Dùng lại" }).click();
  await expect(row).toContainText("Đang dùng");
});

test("bài mới: thiếu ô báo tại ô; slug tự sinh; xem trước; ảnh bìa; lưu nháp → xuất bản (API công khai thấy) → gỡ (ẩn)", async () => {
  await page.getByRole("tab", { name: "Bài viết" }).click();
  await page.getByRole("link", { name: "Viết bài mới" }).click();
  await expect(page.getByRole("heading", { name: "Viết bài mới" })).toBeVisible({ timeout: 20_000 });
  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page.getByText("Nhập tiêu đề.")).toBeVisible();
  await expect(page.getByText("Nhập tóm tắt.")).toBeVisible();
  await expect(page.getByText("Chọn chuyên mục.")).toBeVisible();

  await page.getByLabel("Tiêu đề *").fill(TITLE);
  await expect(page.getByLabel("Slug *")).toHaveValue(SLUG);
  await page.getByLabel("Tóm tắt *").fill("Lịch trình 2 ngày 1 đêm ngắm hoa dã quỳ.");
  await page.getByRole("combobox", { name: "Chuyên mục *" }).click();
  await page.getByRole("option", { name: CATEGORY, exact: true }).click();
  await page.getByLabel("Markdown").fill("## Ngày đầu tiên\n\nĐi xe giường nằm **đêm** tới Đà Lạt.");
  await expect(page.getByLabel("Xem trước nội dung").getByRole("heading", { name: "Ngày đầu tiên" })).toBeVisible();
  await page.getByLabel("Chọn ảnh bìa").setInputFiles({ name: "bia.png", mimeType: "image/png", buffer: PIXEL });
  await expect(page.getByRole("img", { name: "Ảnh bìa" })).toBeVisible({ timeout: 15_000 });

  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page.getByRole("status").filter({ hasText: "Đã lưu bài nháp." })).toBeVisible({ timeout: 20_000 });
  await expect(page.getByRole("heading", { name: "Sửa bài viết" })).toBeVisible();
  expect((await fetch(`${API}/articles/${SLUG}`)).status).toBe(404);

  await page.getByRole("button", { name: "Xuất bản" }).click();
  await expect(page.getByRole("status").filter({ hasText: "Đã xuất bản bài viết." })).toBeVisible({ timeout: 20_000 });
  await expect(page.getByRole("button", { name: "Gỡ bài" })).toBeVisible();
  const published = await fetch(`${API}/articles/${SLUG}`);
  expect(published.status).toBe(200);
  expect(await published.json()).toMatchObject({ title: TITLE, category: { name: CATEGORY } });

  await page.getByRole("button", { name: "Gỡ bài" }).click();
  await page.getByRole("alertdialog").getByRole("button", { name: "Gỡ bài" }).click();
  await expect(page.getByRole("status").filter({ hasText: "Đã gỡ bài viết" })).toBeVisible({ timeout: 20_000 });
  await expect(page.getByRole("button", { name: "Xuất bản lại" })).toBeVisible();
  expect((await fetch(`${API}/articles/${SLUG}`)).status).toBe(404);

  await page.getByRole("link", { name: "Quay lại danh sách bài viết" }).click();
  await page.getByRole("searchbox", { name: "Tìm bài viết" }).fill(SLUG);
  const row = page.getByRole("row").filter({ hasText: TITLE });
  await expect(row).toContainText("Đã gỡ");
  await expect(row).toContainText(CATEGORY);
});

test("trùng slug báo tại ô Slug", async () => {
  await page.getByRole("link", { name: "Viết bài mới" }).click();
  await page.getByLabel("Tiêu đề *").fill(`Bài trùng ${tag}`);
  await page.getByLabel("Slug *").fill(SLUG);
  await page.getByLabel("Tóm tắt *").fill("Tóm tắt");
  await page.getByRole("combobox", { name: "Chuyên mục *" }).click();
  await page.getByRole("option", { name: CATEGORY, exact: true }).click();
  await page.getByRole("button", { name: "Lưu nháp" }).click();
  await expect(page.getByText("Slug này đã được dùng cho bài khác.")).toBeVisible({ timeout: 20_000 });
});
