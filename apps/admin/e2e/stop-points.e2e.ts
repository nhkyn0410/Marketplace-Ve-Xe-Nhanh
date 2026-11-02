import { randomUUID } from "node:crypto";

import { expect, test, type Page } from "@playwright/test";

import { accounts, signInPlatform } from "./helpers";

// TASK-ADM-004 — màn Điểm dừng của Admin (Figma ADM-05a…05e): duyệt / từ chối đề xuất của nhà xe, thêm / sửa /
// ngừng dùng điểm dùng chung, khóa / mở khóa điểm riêng. Dữ liệu nền do seed E2E tạo (cần catalog đã seed).
test.describe.configure({ mode: "serial" });

const tag = randomUUID().slice(0, 6);
let page: Page;

test.beforeAll(async ({ browser }) => {
  page = await browser.newPage();
});

test.afterAll(async () => {
  await page.close();
});

function fixtures() {
  const seeded = accounts().adminStopPoints;
  test.skip(seeded === null, "Catalog chưa seed (pnpm --filter @vexenhanh/api db:seed:catalog).");
  return seeded!;
}

async function openTab(name: RegExp) {
  await page.getByRole("link", { name: "Điểm dừng", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Điểm dừng", exact: true })).toBeVisible({ timeout: 20_000 });
  await page.getByRole("tab", { name }).click();
}

async function selectOption(scope: Page | ReturnType<Page["getByRole"]>, label: string, option: string) {
  await scope.getByRole("combobox", { name: label }).click();
  await page.getByRole("option", { name: option, exact: true }).click();
}

test("duyệt đề xuất: chỉnh tên rồi duyệt → điểm dùng chung mới, có trong tab Dùng chung", async () => {
  const seeded = fixtures();
  await signInPlatform(page, accounts().platformCatalog);
  await openTab(/^Chờ duyệt/);
  const row = page.getByRole("row").filter({ hasText: seeded.proposalName });
  await expect(row).toContainText(seeded.operatorName);
  await expect(row).toContainText("Chờ duyệt");
  await row.getByRole("link", { name: `Xem xét ${seeded.proposalName}` }).click();

  await expect(page.getByRole("heading", { name: `Đề xuất · ${seeded.proposalName}` })).toBeVisible({ timeout: 20_000 });
  await expect(page.getByText("Không có điểm dùng chung cùng loại trong 200 m.")).toBeVisible();
  const approvedName = `E2E Điểm đón đã duyệt ${tag}`;
  await page.getByLabel("Tên điểm dừng *").fill(approvedName);
  await page.getByRole("button", { name: "Duyệt và thêm vào danh mục" }).click();
  await expect(page.getByText(`Đã duyệt và thêm “${approvedName}” vào danh mục dùng chung.`)).toBeVisible();
  await expect(page.getByText("Đã duyệt", { exact: true })).toBeVisible();
  await expect(page.getByRole("button", { name: "Từ chối" })).toHaveCount(0);

  await page.getByRole("link", { name: "Quay lại danh sách chờ duyệt" }).click();
  await page.getByRole("tab", { name: /^Dùng chung/ }).click();
  await page.getByRole("searchbox", { name: "Tìm điểm dừng" }).fill(approvedName);
  const shared = page.getByRole("row").filter({ hasText: approvedName });
  await expect(shared).toContainText("Điểm dừng đón trả khách");
  await expect(shared).toContainText("QĐ E2E/QĐ-SGTVT");
  await expect(shared).toContainText("Hoạt động");
});

test("từ chối đề xuất: thiếu lý do báo tại ô; có lý do → Bị từ chối", async () => {
  const seeded = fixtures();
  await openTab(/^Chờ duyệt/);
  await page.getByRole("link", { name: `Xem xét ${seeded.rejectProposalName}` }).click();
  await expect(page.getByRole("heading", { name: `Đề xuất · ${seeded.rejectProposalName}` })).toBeVisible({ timeout: 20_000 });
  await page.getByRole("button", { name: "Từ chối", exact: true }).click();
  const dialog = page.getByRole("dialog", { name: "Từ chối đề xuất" });
  await dialog.getByRole("button", { name: "Từ chối đề xuất" }).click();
  await expect(dialog.getByText("Nhập lý do.")).toBeVisible();
  await dialog.getByLabel("Lý do *").fill("Trùng điểm đón đã có ở danh mục.");
  await dialog.getByRole("button", { name: "Từ chối đề xuất" }).click();
  await expect(dialog).toBeHidden();
  await expect(page.getByText("Đã từ chối: Trùng điểm đón đã có ở danh mục.", { exact: false })).toBeVisible();
  await expect(page.getByText("Bị từ chối", { exact: true })).toBeVisible();
});

test("điểm dùng chung: bến xe thiếu căn cứ báo tại ô; trạm dừng nghỉ thêm được; ngừng dùng → Ngừng dùng", async () => {
  const seeded = fixtures();
  await openTab(/^Dùng chung/);
  await page.getByRole("button", { name: "Thêm điểm dừng" }).click();
  const dialog = page.getByRole("dialog", { name: "Thêm điểm dừng dùng chung" });
  const name = `E2E Trạm dừng nghỉ ${tag}`;
  await dialog.getByLabel("Tên điểm dừng *").fill(name);
  await selectOption(dialog, "Loại điểm *", "Bến xe khách");
  await dialog.getByLabel("Địa chỉ *").fill("Quốc lộ 20");
  await selectOption(dialog, "Tỉnh / thành *", seeded.provinceName);
  await selectOption(dialog, "Phường / xã *", seeded.wardName);
  await dialog.getByLabel("Vĩ độ *").fill(String(10.5 + Math.random() * 0.5));
  await dialog.getByLabel("Kinh độ *").fill(String(106.4 + Math.random() * 0.5));
  await dialog.getByRole("button", { name: "Lưu điểm dừng" }).click();
  await expect(dialog.getByText("Bến xe và điểm dừng đón trả bắt buộc căn cứ công bố.")).toBeVisible();

  await selectOption(dialog, "Loại điểm *", "Trạm dừng nghỉ");
  await dialog.getByRole("button", { name: "Lưu điểm dừng" }).click();
  await expect(dialog).toBeHidden();
  await expect(page.getByText(`Đã thêm điểm dừng “${name}”.`)).toBeVisible();

  await page.getByRole("searchbox", { name: "Tìm điểm dừng" }).fill(name);
  const row = page.getByRole("row").filter({ hasText: name });
  await expect(row).toContainText("Trạm dừng nghỉ");
  await row.getByRole("button", { name: `Ngừng dùng ${name}` }).click();
  const confirm = page.getByRole("dialog", { name: "Ngừng dùng điểm dừng" });
  await confirm.getByRole("button", { name: "Ngừng dùng" }).click();
  await expect(confirm).toBeHidden();
  await expect(row).toContainText("Ngừng dùng");
  await expect(row.getByRole("button", { name: `Dùng lại ${name}` })).toBeVisible();
});

test("điểm riêng của nhà xe: khóa thiếu lý do báo tại ô; khóa → Bị khóa kèm lý do; mở khóa → Hoạt động", async () => {
  const seeded = fixtures();
  await openTab(/^Của nhà xe/);
  await page.getByRole("searchbox", { name: "Tìm điểm dừng" }).fill(seeded.privatePointName);
  const row = page.getByRole("row").filter({ hasText: seeded.privatePointName });
  await expect(row).toContainText(seeded.operatorName);
  await expect(row).toContainText("Hoạt động");

  await row.getByRole("button", { name: `Khóa ${seeded.privatePointName}` }).click();
  const lock = page.getByRole("dialog", { name: "Khóa điểm dừng" });
  await lock.getByRole("button", { name: "Khóa điểm dừng" }).click();
  await expect(lock.getByText("Nhập lý do.")).toBeVisible();
  await lock.getByLabel("Lý do *").fill("Tọa độ sai lệch địa chỉ");
  await lock.getByRole("button", { name: "Khóa điểm dừng" }).click();
  await expect(lock).toBeHidden();
  await expect(row).toContainText("Bị khóa");
  await expect(row).toContainText("Tọa độ sai lệch địa chỉ");

  await row.getByRole("button", { name: `Mở khóa ${seeded.privatePointName}` }).click();
  const unlock = page.getByRole("dialog", { name: "Mở khóa điểm dừng" });
  await unlock.getByRole("button", { name: "Mở khóa" }).click();
  await expect(unlock).toBeHidden();
  await expect(row).toContainText("Hoạt động");
});
