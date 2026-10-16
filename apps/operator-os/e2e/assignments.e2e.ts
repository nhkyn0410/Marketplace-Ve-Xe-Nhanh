import { expect, test, type Page } from "@playwright/test";

import { accounts, signInWithEnrollment } from "./helpers";

// TASK-EMP-001 (màn Phân công chuyến, Figma "05 · Nhân viên / Phân công chuyến") — nhà xe riêng do global-setup seed: hai
// tài xế + một nhân viên vé, ba chuyến ngày `date` (06:00–11:30, 08:30–14:00 chồng chuyến đầu, 13:00–21:15) và một chuyến
// còn 1 giờ là khởi hành đã giao `nv.tai.hung`. Chạy tuần tự, dùng chung một phiên.
test.describe.configure({ mode: "serial" });

const FIRST_VISIT = { timeout: 30_000 };
let page: Page;
let routeName: string;
let date: string;
let soonDate: string;

test.beforeAll(async ({ browser }) => {
  const { assignOperatorSlug, assignOwner, assignmentFixtures } = accounts();
  if (!assignmentFixtures) {
    throw new Error("Thiếu dữ liệu nền cho màn Phân công chuyến.");
  }
  ({ routeName, date, soonDate } = assignmentFixtures);
  page = await browser.newPage();
  await signInWithEnrollment(page, `${assignOperatorSlug}/${assignOwner.username}`, assignOwner.password);
});

test.afterAll(async () => {
  await page.close();
});

const driverSelect = (time: string) => page.getByRole("combobox", { name: `Tài xế chuyến ${time} ${routeName}` });
const row = (time: string) => page.getByRole("row").filter({ has: driverSelect(time) });

async function chooseDriver(time: string, name: string) {
  await driverSelect(time).click();
  await page.getByRole("option", { name, exact: true }).click();
}

test("phân công tài xế: chọn là lưu; tài xế trùng giờ bị chặn kèm giờ chuyến kia; nhân viên vé không có trong danh sách", async () => {
  await page.getByRole("link", { name: "Nhân viên", exact: true }).click();
  await page.getByRole("link", { name: "Phân công chuyến" }).click();
  await expect(page.getByRole("heading", { name: "Phân công chuyến", level: 1 })).toBeVisible(FIRST_VISIT);
  await page.getByLabel("Ngày khởi hành").fill(date);
  await expect(page.getByRole("row")).toHaveCount(4, FIRST_VISIT);
  for (const time of ["06:00", "08:30", "13:00"]) {
    await expect(row(time)).toContainText("Chưa phân công");
  }
  await expect(row("06:00")).toContainText("Đến 11:30");

  await driverSelect("06:00").click();
  await expect(page.getByRole("option")).toHaveText(["Chưa phân công", "nv.tai.hung", "nv.tai.minh"]);
  await page.getByRole("option", { name: "nv.tai.minh", exact: true }).click();
  await expect(row("06:00")).toContainText("Đã phân công");

  await chooseDriver("08:30", "nv.tai.minh");
  await expect(row("08:30").getByRole("alert")).toContainText("Tài xế đã chạy chuyến 06:00");
  await expect(row("08:30")).toContainText("Trùng lịch");
  await chooseDriver("08:30", "nv.tai.hung");
  await expect(row("08:30").getByRole("alert")).toHaveCount(0);
  await expect(row("08:30")).toContainText("Đã phân công");
});

test("lọc chưa phân công; bỏ phân công", async () => {
  await page.getByLabel("Tình trạng").click();
  await page.getByRole("option", { name: "Chưa phân công" }).click();
  await expect(page.getByRole("row")).toHaveCount(2);
  await expect(row("13:00")).toBeVisible();

  await page.getByLabel("Tình trạng").click();
  await page.getByRole("option", { name: "Tất cả" }).click();
  await chooseDriver("08:30", "Chưa phân công");
  await expect(row("08:30")).toContainText("Chưa phân công");
});

test("chuyến còn 1 giờ là khởi hành: đổi tài xế phải nhập lý do", async () => {
  await page.getByLabel("Ngày khởi hành").fill(soonDate);
  await expect(driverSelect(await soonTime())).toHaveText("nv.tai.hung");
  const time = await soonTime();
  await chooseDriver(time, "nv.tai.minh");
  const dialog = page.getByRole("dialog");
  await expect(dialog.getByRole("heading", { name: "Đổi phân công chuyến sắp chạy?" })).toBeVisible();
  await dialog.getByRole("button", { name: "Lưu phân công" }).click();
  await expect(dialog.getByRole("alert")).toHaveText("Nhập lý do đổi phân công (ít nhất 3 ký tự).");
  await dialog.getByLabel("Lý do đổi phân công *").fill("Tài xế cũ báo ốm đột xuất.");
  await dialog.getByRole("button", { name: "Lưu phân công" }).click();
  await expect(dialog).toHaveCount(0);
  await expect(driverSelect(time)).toHaveText("nv.tai.minh");
});

/** Giờ khởi hành (HH:mm theo giờ VN) của chuyến sắp chạy — đọc từ nhãn ô tài xế duy nhất có tài xế trong ngày đó. */
async function soonTime(): Promise<string> {
  const label = await page
    .getByRole("combobox", { name: new RegExp(`^Tài xế chuyến \\d{2}:\\d{2} ${routeName}$`) })
    .filter({ hasText: /nv\.tai/ })
    .first()
    .getAttribute("aria-label");
  return label!.slice("Tài xế chuyến ".length, "Tài xế chuyến ".length + 5);
}
