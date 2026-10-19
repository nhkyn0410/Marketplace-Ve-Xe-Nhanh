import { readFile } from "node:fs/promises";

import { expect, test, type Page } from "@playwright/test";

import { accounts, signInWithEnrollment } from "./helpers";

// TASK-OPR-003 (màn Đặt vé, Figma "Nhà xe · Đặt vé" 01–03) — nhà xe riêng do global-setup seed: chuyến 22:30 ngày `date`,
// đơn đã xác nhận (A01, A02 có vé) + đơn chờ thanh toán của khách vãng lai (A03). TASK-OPR-002 (màn Tài chính, Figma "Nhà xe ·
// Tài chính" 01–03) trên cùng nhà xe: thêm đơn của chuyến đã chạy 10 ngày trước đã vào kỳ chi trả hôm nay (chờ rà soát).
// Chạy tuần tự, dùng chung một phiên (chủ nhà xe chỉ bật 2FA lần đầu một lần).
test.describe.configure({ mode: "serial" });

const FIRST_VISIT = { timeout: 30_000 };
let page: Page;
let fixtures: NonNullable<ReturnType<typeof accounts>["bookingFixtures"]>;
const display = (code: string) => code.replace(/^VXN/, "VXN-");

test.beforeAll(async ({ browser }) => {
  const { bookingOperatorSlug, bookingOwner, bookingFixtures } = accounts();
  if (!bookingFixtures) {
    throw new Error("Thiếu dữ liệu nền cho màn Đặt vé (chạy db:seed:catalog).");
  }
  fixtures = bookingFixtures;
  page = await browser.newPage();
  await signInWithEnrollment(page, `${bookingOperatorSlug}/${bookingOwner.username}`, bookingOwner.password);
});

test.afterAll(async () => {
  await page.close();
});

const row = (code: string) => page.getByRole("row").filter({ hasText: display(code) });

test("danh sách đơn theo ngày đi: số điện thoại che, trạng thái đơn + thanh toán; lọc trạng thái; tìm theo SĐT", async () => {
  await page.getByRole("link", { name: "Đặt vé", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Đặt vé", level: 1 })).toBeVisible(FIRST_VISIT);
  await page.getByLabel("Ngày đi").fill(fixtures.date);
  await expect(page.getByRole("row")).toHaveCount(3, FIRST_VISIT);
  await expect(row(fixtures.confirmedCode)).toContainText("0*** *** 567");
  await expect(row(fixtures.confirmedCode)).toContainText("Thành công");
  await expect(row(fixtures.confirmedCode)).toContainText("Đã xác nhận");
  await expect(row(fixtures.confirmedCode)).toContainText("A01, A02");
  await expect(row(fixtures.pendingCode)).toContainText("Khách vãng lai");
  await expect(row(fixtures.pendingCode)).toContainText("Chưa thanh toán");
  await expect(row(fixtures.pendingCode)).toContainText("Chờ thanh toán");
  await expect(page.getByText("0901234567")).toHaveCount(0);

  await page.getByLabel("Trạng thái đơn").click();
  await page.getByRole("option", { name: "Đã xác nhận" }).click();
  await expect(page.getByRole("row")).toHaveCount(2);
  await page.getByLabel("Trạng thái đơn").click();
  await page.getByRole("option", { name: "Tất cả trạng thái" }).click();
  await page.getByLabel("Tìm kiếm").fill("654 112");
  await expect(page.getByRole("row")).toHaveCount(2);
  await expect(row(fixtures.pendingCode)).toBeVisible();
  await page.getByLabel("Tìm kiếm").fill("");
  await expect(page.getByRole("row")).toHaveCount(3);
});

test("chi tiết đơn: vé đã phát hành, lịch sử; hiện đầy đủ liên hệ", async () => {
  await row(fixtures.confirmedCode).getByRole("link", { name: "Xem" }).click();
  await expect(page.getByRole("heading", { name: `Đơn ${display(fixtures.confirmedCode)}` })).toBeVisible(FIRST_VISIT);
  const tickets = page.getByRole("region", { name: "Vé trong đơn" });
  await expect(tickets).toContainText(`${display(fixtures.confirmedCode)}-01`);
  await expect(tickets).toContainText(`${display(fixtures.confirmedCode)}-02`);
  await expect(tickets.getByText("Hợp lệ")).toHaveCount(2);
  const history = page.getByRole("region", { name: "Lịch sử trạng thái" });
  await expect(history).toContainText("Phát hành 2 vé");
  await expect(history).toContainText("Thanh toán thành công");
  await expect(history).toContainText("Tạo đơn");
  const contact = page.getByRole("region", { name: "Người liên hệ" });
  await expect(contact).toContainText("0*** *** 567");
  await contact.getByRole("button", { name: "Hiện đầy đủ" }).click();
  await expect(contact).toContainText("0901234567");
  await expect(page.getByRole("region", { name: "Chính sách hủy / hoàn tiền" })).toContainText("Hoàn 90%");
});

test("danh sách hành khách theo chuyến: số liệu, lọc; xuất CSV có số điện thoại đầy đủ", async () => {
  await page.getByRole("link", { name: "Quay lại danh sách đơn" }).click();
  await page.getByLabel("Ngày đi").fill(fixtures.date);
  await page.getByLabel("Chuyến").click();
  await page.getByRole("option", { name: `22:30 · ${fixtures.routeName}` }).click();
  await page.getByRole("link", { name: "Danh sách hành khách theo chuyến" }).click();
  await expect(page.getByRole("heading", { name: "Danh sách hành khách", level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByText("2 / 4")).toBeVisible();
  await expect(page.getByRole("row")).toHaveCount(3);
  await expect(page.getByRole("row").filter({ hasText: "A01" })).toContainText("0*** *** 567");

  await page.getByLabel("Trạng thái vé").click();
  await page.getByRole("option", { name: "Đã lên xe" }).click();
  await expect(page.getByText("Không có hành khách phù hợp")).toBeVisible();
  await page.getByLabel("Trạng thái vé").click();
  await page.getByRole("option", { name: "Tất cả trạng thái" }).click();
  await expect(page.getByRole("row")).toHaveCount(3);

  const download = page.waitForEvent("download");
  await page.getByRole("button", { name: "Xuất danh sách" }).click();
  const file = await download;
  expect(file.suggestedFilename()).toMatch(/^hanh-khach-\d{4}-\d{2}-\d{2}-22h30\.csv$/);
  const csv = await readFile((await file.path())!, "utf8");
  expect(csv).toContain('"0901234567"');
  expect(csv).toContain(`"${fixtures.confirmedCode}-01"`);
});

test("tổng quan: số dư giữ hộ, chờ đủ điều kiện; giao dịch theo đơn có hoa hồng + tình trạng; lọc tình trạng", async () => {
  await page.getByRole("link", { name: "Tài chính", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Tài chính", level: 1 })).toBeVisible(FIRST_VISIT);
  // Đơn chuyến tương lai 600.000 − 30.000 đang giữ; đơn chuyến đã chạy 450.000 − 22.500 đã vào kỳ (chưa chi).
  await expect(page.getByText("Số dư đang giữ").locator("..")).toContainText("997.500");
  await expect(page.getByText("Chờ đủ điều kiện", { exact: true }).locator("..")).toContainText("570.000");
  await page.getByLabel("Khởi hành từ").fill("2020-01-01");
  await page.getByLabel("Đến ngày").fill("2035-12-31");
  const row = (code: string) => page.getByRole("row").filter({ hasText: display(code) });
  await expect(row(fixtures.confirmedCode)).toContainText("Chờ chuyến hoàn thành", FIRST_VISIT);
  await expect(row(fixtures.confirmedCode)).toContainText("-30.000");
  await expect(row(fixtures.pastCode)).toContainText("Trong kỳ chi trả");
  await expect(row(fixtures.pastCode)).toContainText("427.500");
  await page.getByLabel("Tình trạng").click();
  await page.getByRole("option", { name: "Trong kỳ chi trả" }).click();
  await expect(page.getByRole("row")).toHaveCount(2);
});

test("chi trả: kỳ hôm nay chờ rà soát; chi tiết có chuyến, cách tính, tài khoản đã che, tiến trình", async () => {
  await page.getByRole("link", { name: "Chi trả", exact: true }).click();
  const row = page.getByRole("row").filter({ hasText: "Chờ rà soát" });
  await expect(row).toContainText("427.500", FIRST_VISIT);
  await row.getByRole("link", { name: "Xem" }).click();
  await expect(page.getByRole("heading", { name: /Kỳ chi trả/, level: 1 })).toBeVisible(FIRST_VISIT);
  await expect(page.getByText(fixtures.payoutCode)).toBeVisible();
  const calc = page.getByRole("region", { name: "Cách tính" });
  await expect(calc).toContainText("Hoa hồng 5%");
  await expect(calc).toContainText("-22.500");
  await expect(calc).toContainText("427.500");
  const bank = page.getByRole("region", { name: "Tài khoản nhận tiền" });
  await expect(bank).toContainText("•••• 4521");
  await expect(bank).not.toContainText("0071000124521");
  await expect(page.getByRole("region", { name: "Chuyến trong kỳ" })).toContainText("1 chuyến · 1 đơn");
  await expect(page.getByRole("region", { name: "Tiến trình" })).toContainText("Tạo kỳ chi trả");
});
