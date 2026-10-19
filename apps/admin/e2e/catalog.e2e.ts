import { randomUUID } from "node:crypto";

import { expect, test, type Locator, type Page } from "@playwright/test";

import { accounts, signInPlatform } from "./helpers";

// TASK-ADM-001 phần catalog — màn Danh mục chuẩn (Figma ADM-04a…04c, UC-24): thêm / sửa / ngừng dùng / dùng lại
// loại xe, tiện ích, phường / xã. Không thêm hay ngừng tỉnh / thành thật (mã tỉnh chỉ 2 chữ số, dùng chung với các
// spec khác) — chỉ xem danh sách và mức ảnh hưởng. Mục E2E tạo ra được ngừng dùng ở cuối để không lẫn vào form của
// Operator OS.
test.describe.configure({ mode: "serial" });

const tag = randomUUID().replace(/-/g, "").slice(0, 6).toUpperCase();
let page: Page;

test.beforeAll(async ({ browser }) => {
  page = await browser.newPage();
});

test.afterAll(async () => {
  await page.close();
});

async function openTab(name: string) {
  await page.getByRole("link", { name: "Danh mục", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Danh mục chuẩn" })).toBeVisible({ timeout: 20_000 });
  await page.getByRole("tab", { name, exact: true }).click();
}

async function choose(scope: Page | Locator, label: string, option: string) {
  await scope.getByRole("combobox", { name: label }).click();
  await page.getByRole("option", { name: option, exact: true }).click();
}

test("loại xe: mã sai báo tại ô; thêm; trùng mã báo tại ô; đổi tên; ngừng dùng kèm lý do + mức ảnh hưởng; dùng lại", async () => {
  await signInPlatform(page, accounts().platformData);
  await openTab("Loại xe");
  await page.getByRole("button", { name: "Thêm loại xe" }).click();
  const add = page.getByRole("dialog", { name: "Thêm loại xe" });
  await add.getByLabel("Mã *").fill("có dấu");
  await add.getByLabel("Tên hiển thị *").fill(`Giường nằm E2E ${tag}`);
  await choose(add, "Dạng chỗ *", "Giường nằm");
  await choose(add, "Hạng xe *", "Limousine");
  await add.getByRole("button", { name: "Lưu" }).click();
  await expect(add.getByText("Mã gồm 2–40 ký tự chữ không dấu, số, gạch dưới.")).toBeVisible();
  await add.getByLabel("Mã *").fill(`e2e_${tag}`);
  await add.getByRole("button", { name: "Lưu" }).click();
  await expect(add).toBeHidden();
  await expect(page.getByText(`Đã thêm loại xe “Giường nằm E2E ${tag}”.`)).toBeVisible();
  const row = page.getByRole("row").filter({ hasText: `E2E_${tag}` });
  await expect(row).toContainText("Limousine");
  await expect(row).toContainText("Đang dùng");

  // Trùng mã.
  await page.getByRole("button", { name: "Thêm loại xe" }).click();
  const again = page.getByRole("dialog", { name: "Thêm loại xe" });
  await again.getByLabel("Mã *").fill(`E2E_${tag}`);
  await again.getByLabel("Tên hiển thị *").fill("Trùng");
  await choose(again, "Dạng chỗ *", "Ghế ngồi");
  await choose(again, "Hạng xe *", "Tiêu chuẩn");
  await again.getByRole("button", { name: "Lưu" }).click();
  await expect(again.getByText("Mã này đã có trong danh mục.")).toBeVisible();
  await again.getByRole("button", { name: "Hủy" }).click();

  await row.getByRole("button", { name: `Sửa loại xe Giường nằm E2E ${tag}` }).click();
  const edit = page.getByRole("dialog", { name: "Sửa loại xe" });
  await expect(edit.getByText("Mã gồm", { exact: false })).toHaveCount(0);
  await edit.getByLabel("Tên hiển thị *").fill(`Giường đôi E2E ${tag}`);
  await edit.getByRole("button", { name: "Lưu" }).click();
  await expect(edit).toBeHidden();
  await expect(row).toContainText(`Giường đôi E2E ${tag}`);

  await row.getByRole("button", { name: `Ngừng dùng loại xe Giường đôi E2E ${tag}` }).click();
  const stop = page.getByRole("dialog", { name: `Ngừng dùng loại xe “Giường đôi E2E ${tag}”` });
  await expect(stop).toContainText("0 xe của 0 nhà xe");
  await expect(stop).toContainText("0 quy tắc");
  await stop.getByRole("button", { name: "Ngừng dùng" }).click();
  await expect(stop.getByText("Nhập lý do (ít nhất 3 ký tự).")).toBeVisible();
  await stop.getByLabel("Lý do *").fill("Gộp vào loại xe chuẩn");
  await stop.getByRole("button", { name: "Ngừng dùng" }).click();
  await expect(stop).toBeHidden();
  await expect(row).toContainText("Ngừng dùng");

  await row.getByRole("button", { name: `Dùng lại loại xe Giường đôi E2E ${tag}` }).click();
  await page.getByRole("dialog", { name: `Dùng lại loại xe “Giường đôi E2E ${tag}”` }).getByRole("button", { name: "Dùng lại" }).click();
  await expect(row).toContainText("Đang dùng");
  // Dọn: ngừng dùng để loại xe thử không hiện trong form xe của Operator OS.
  await row.getByRole("button", { name: `Ngừng dùng loại xe Giường đôi E2E ${tag}` }).click();
  const cleanup = page.getByRole("dialog", { name: `Ngừng dùng loại xe “Giường đôi E2E ${tag}”` });
  await cleanup.getByLabel("Lý do *").fill("Dọn dữ liệu E2E");
  await cleanup.getByRole("button", { name: "Ngừng dùng" }).click();
  await expect(row).toContainText("Ngừng dùng");
});

test("tiện ích + phường / xã: thêm, có trong danh sách, ngừng dùng", async () => {
  await openTab("Tiện ích");
  await page.getByRole("button", { name: "Thêm tiện ích" }).click();
  const amenity = page.getByRole("dialog", { name: "Thêm tiện ích" });
  await amenity.getByLabel("Mã *").fill(`e2e_${tag}`);
  await amenity.getByLabel("Tên *").fill(`Gối E2E ${tag}`);
  await amenity.getByRole("button", { name: "Lưu" }).click();
  await expect(amenity).toBeHidden();
  const amenityRow = page.getByRole("row").filter({ hasText: `E2E_${tag}` });
  await expect(amenityRow).toContainText(`Gối E2E ${tag}`);
  await amenityRow.getByRole("button", { name: `Ngừng dùng tiện ích Gối E2E ${tag}` }).click();
  const stopAmenity = page.getByRole("dialog", { name: `Ngừng dùng tiện ích “Gối E2E ${tag}”` });
  await stopAmenity.getByLabel("Lý do *").fill("Dọn dữ liệu E2E");
  await stopAmenity.getByRole("button", { name: "Ngừng dùng" }).click();
  await expect(amenityRow).toContainText("Ngừng dùng");

  const seeded = accounts().adminStopPoints;
  test.skip(seeded === null, "Catalog chưa seed (pnpm --filter @vexenhanh/api db:seed:catalog).");
  await openTab("Phường / xã");
  await page.getByRole("button", { name: "Thêm phường / xã" }).click();
  const ward = page.getByRole("dialog", { name: "Thêm phường / xã" });
  await choose(ward, "Tỉnh / thành *", seeded!.provinceName);
  const wardCode = String(10_000 + Math.floor(Math.random() * 90_000));
  await ward.getByLabel("Mã *").fill(wardCode);
  await ward.getByLabel("Tên *").fill(`Phường E2E ${tag}`);
  await ward.getByRole("button", { name: "Lưu" }).click();
  await expect(ward).toBeHidden();
  await page.getByRole("searchbox", { name: "Tìm phường / xã" }).fill(wardCode);
  const wardRow = page.getByRole("row").filter({ hasText: `Phường E2E ${tag}` });
  await expect(wardRow).toContainText(seeded!.provinceName);
  await wardRow.getByRole("button", { name: `Ngừng dùng phường / xã Phường E2E ${tag}` }).click();
  const stopWard = page.getByRole("dialog", { name: `Ngừng dùng phường / xã “Phường E2E ${tag}”` });
  await expect(stopWard).toContainText("0 điểm");
  await stopWard.getByLabel("Lý do *").fill("Dọn dữ liệu E2E");
  await stopWard.getByRole("button", { name: "Ngừng dùng" }).click();
  await expect(wardRow).toContainText("Ngừng dùng");
});

test("tỉnh / thành: tìm theo tên; hộp thoại ngừng dùng hiện mức ảnh hưởng (đóng lại, không đổi gì)", async () => {
  const seeded = accounts().adminStopPoints;
  test.skip(seeded === null, "Catalog chưa seed.");
  await openTab("Tỉnh / thành");
  await page.getByRole("searchbox", { name: "Tìm tỉnh / thành" }).fill(seeded!.provinceName);
  const row = page.getByRole("row").filter({ hasText: seeded!.provinceName });
  await expect(row.first()).toContainText("Đang dùng");
  await row.first().getByRole("button", { name: `Ngừng dùng tỉnh / thành ${seeded!.provinceName}` }).click();
  const dialog = page.getByRole("dialog", { name: `Ngừng dùng tỉnh / thành “${seeded!.provinceName}”` });
  await expect(dialog).toContainText("Phường / xã thuộc tỉnh");
  await expect(dialog).toContainText("Điểm dừng dùng chung trong tỉnh");
  await dialog.getByRole("button", { name: "Hủy" }).click();
  await expect(row.first()).toContainText("Đang dùng");
});
