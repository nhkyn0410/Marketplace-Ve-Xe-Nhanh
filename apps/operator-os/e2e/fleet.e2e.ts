import { expect, test, type Page } from "@playwright/test";

import { accounts, signInWithEnrollment } from "./helpers";

// TASK-TRN-001 (màn Operator OS) — luồng chính của Owner: tạo sơ đồ ghế bằng trình soạn, tạo xe gắn sơ đồ
// đó, lỗi trùng biển số báo tại ô, rồi đăng xuất. Cần catalog đã seed (`db:seed:catalog`, RB-08) để có
// loại xe. Chạy tuần tự, dùng chung một phiên: mỗi ca dựa trên dữ liệu ca trước tạo ra.
test.describe.configure({ mode: "serial" });

const API = "http://localhost:3000/v1";
const SEAT_MAP = "E2E Cabin 3";
let page: Page;

test.beforeAll(async ({ browser }) => {
  page = await browser.newPage();
  const { operatorSlug, fleetOwner } = accounts();
  await signInWithEnrollment(page, `${operatorSlug}/${fleetOwner.username}`, fleetOwner.password);
});

test.afterAll(async () => {
  await page.close();
});

const cell = (deck: number, row: number, column: number) =>
  page.getByRole("button", { name: new RegExp(`tầng ${deck}, hàng ${row}, cột ${column}$`) });

async function choose(label: string, option: string) {
  await page.getByLabel(label, { exact: true }).click();
  await page.getByRole("option", { name: option, exact: true }).click();
}

test("tạo sơ đồ ghế: lưới theo tầng, chỗ đôi tính hai người, lối đi là ô trống → hiện ở danh sách", async () => {
  await page.getByRole("link", { name: "Sơ đồ ghế", exact: true }).click();
  await expect(page.getByText("Chưa có sơ đồ ghế")).toBeVisible();
  await page.getByRole("link", { name: "Tạo sơ đồ đầu tiên" }).click();

  // Chưa đủ cấu hình thì chưa tạo lưới / lưu được.
  await expect(page.getByRole("button", { name: "Tạo lưới" })).toBeDisabled();
  await expect(page.getByRole("button", { name: "Lưu sơ đồ" })).toBeDisabled();

  await page.getByLabel("Tên sơ đồ *").fill(SEAT_MAP);
  await choose("Số tầng", "1 tầng");
  await page.getByLabel("Số hàng").fill("2");
  await page.getByLabel("Số cột").fill("2");
  await choose("Loại chỗ ban đầu", "Cabin đơn");
  await page.getByRole("button", { name: "Tạo lưới" }).click();
  await expect(page.getByText("4 chỗ · Sức chứa tối đa 4 người")).toBeVisible();

  const cellTypes = page.getByRole("group", { name: "Loại ô" });
  await cell(1, 1, 2).click();
  await cellTypes.getByRole("button", { name: "Ô trống / Lối đi" }).click();
  await cell(1, 2, 1).click();
  await cellTypes.getByRole("button", { name: /Cabin đôi/ }).click();
  await expect(page.getByText("3 chỗ · Sức chứa tối đa 4 người")).toBeVisible();

  // Mã trùng báo ngay tại ô và chặn lưu.
  await page.getByLabel("Mã chỗ *").fill("a01");
  await expect(page.getByText("Mã A01 đã tồn tại. Hãy chọn mã khác.")).toBeVisible();
  await page.getByLabel("Mã chỗ *").fill("VIP1");

  await page.getByRole("button", { name: "Lưu sơ đồ" }).first().click();
  const row = page.getByRole("row", { name: new RegExp(SEAT_MAP) });
  await expect(row).toContainText("4 người");
  await expect(row).toContainText("Có thể chỉnh sửa");
});

test("tạo xe gắn sơ đồ vừa tạo → danh sách hiện biển số chuẩn, loại xe và tóm tắt sơ đồ", async () => {
  await page.getByRole("link", { name: "Phương tiện", exact: true }).click();
  await page.getByRole("link", { name: "Thêm phương tiện" }).first().click();

  // Bấm lưu khi còn trống: lỗi nằm tại từng ô, không có request ghi.
  await page.getByRole("button", { name: "Lưu phương tiện" }).click();
  await expect(page.getByText("Nhập biển số xe.")).toBeVisible();

  await page.getByLabel("Biển số xe *").fill("51b-630.28");
  await choose("Dạng chỗ · Hạng xe *", "Cabin · Limousine");
  await choose("Chọn sơ đồ", SEAT_MAP);
  await expect(page.getByText("4 người", { exact: true })).toBeVisible();
  await page.getByRole("button", { name: "Lưu phương tiện" }).click();

  await expect(page.getByRole("heading", { name: "Sửa phương tiện" })).toBeVisible();
  await expect(page.getByText("Đã lưu phương tiện")).toBeVisible();
  await expect(page.getByLabel("Biển số xe *")).toHaveValue("51B-630.28");

  await page.getByRole("link", { name: "Phương tiện", exact: true }).click();
  const row = page.getByRole("row", { name: /51B-630\.28/ });
  await expect(row).toContainText("Cabin · Limousine");
  await expect(row).toContainText(SEAT_MAP);
  await expect(row).toContainText("3 chỗ · 4 người · 1 tầng");
});

test("trùng biển số (khác cách gõ) → báo tại ô biển số, dữ liệu đã nhập còn nguyên", async () => {
  await page.getByRole("link", { name: "Thêm phương tiện" }).first().click();
  await page.getByLabel("Biển số xe *").fill("51B 630.28");
  await choose("Dạng chỗ · Hạng xe *", "Ghế ngồi · Thường");
  await page.getByRole("button", { name: "Lưu phương tiện" }).click();
  await expect(page.getByText("Biển số đã tồn tại trong nhà xe.")).toBeVisible();
  await expect(page.getByLabel("Biển số xe *")).toHaveValue("51B 630.28");
});

test("đăng xuất từ khung trang → về màn đăng nhập, cookie phiên bị xoá", async () => {
  // Form đang có dữ liệu chưa lưu: rời bằng nút Hủy phải hỏi lại trước.
  await page.getByRole("button", { name: "Hủy" }).click();
  await page.getByRole("alertdialog", { name: "Bỏ thay đổi chưa lưu?" }).getByRole("button", { name: "Rời trang" }).click();
  await expect(page.getByRole("heading", { name: "Danh sách phương tiện" })).toBeVisible();

  await page.getByRole("button", { name: "Đăng xuất" }).click();
  await expect(page.getByRole("heading", { name: "Đăng nhập nhà xe" })).toBeVisible();
  const cookies = await page.context().cookies(API);
  expect(cookies.some((cookie) => cookie.name === "vxn_access")).toBe(false);
  await page.reload();
  await expect(page.getByRole("heading", { name: "Đăng nhập nhà xe" })).toBeVisible();
});
