import { describe, expect, it } from "vitest";
import { NotificationCampaignType, NotificationKind } from "../../database/prisma.types";
import { campaignDelivery, inQuietHours, pushCarriesMessage } from "./campaign-rules";

const { SERVICE, PROMOTION, NEWS } = NotificationCampaignType;
const on = { email: true, push: true };
const off = { email: false, push: false };
const inboxOnly = { email: true, push: false };

describe("Quy tắc gửi chiến dịch", () => {
  it("dịch vụ luôn vào hộp thư, tắt push thì không đẩy (BR-52)", () => {
    expect(campaignDelivery(SERVICE, null, true)).toEqual({ inbox: true, push: true });
    expect(campaignDelivery(SERVICE, off, true)).toEqual({ inbox: true, push: false });
    expect(campaignDelivery(SERVICE, null, false)).toEqual({ inbox: true, push: false });
  });

  it("khuyến mãi mặc định nhận, tắt cả hai kênh là không nhận", () => {
    expect(campaignDelivery(PROMOTION, null, true)).toEqual({ inbox: true, push: true });
    expect(campaignDelivery(PROMOTION, inboxOnly, true)).toEqual({ inbox: true, push: false });
    expect(campaignDelivery(PROMOTION, off, true)).toEqual({ inbox: false, push: false });
    expect(campaignDelivery(PROMOTION, on, false)).toEqual({ inbox: true, push: false });
  });

  it("tin tức mặc định không nhận, phải chủ động bật", () => {
    expect(campaignDelivery(NEWS, null, true)).toEqual({ inbox: false, push: false });
    expect(campaignDelivery(NEWS, off, true)).toEqual({ inbox: false, push: false });
    expect(campaignDelivery(NEWS, on, true)).toEqual({ inbox: true, push: true });
    expect(campaignDelivery(NEWS, inboxOnly, true)).toEqual({ inbox: true, push: false });
  });

  it("giờ yên tĩnh 21h–8h giờ Việt Nam, trừ thông báo dịch vụ", () => {
    // 14:00Z = 21:00 VN; 00:59Z = 07:59 VN; 01:00Z = 08:00 VN; 13:59Z = 20:59 VN.
    expect(inQuietHours(PROMOTION, new Date("2026-11-02T14:00:00Z"))).toBe(true);
    expect(inQuietHours(NEWS, new Date("2026-11-02T00:59:00Z"))).toBe(true);
    expect(inQuietHours(PROMOTION, new Date("2026-11-02T01:00:00Z"))).toBe(false);
    expect(inQuietHours(NEWS, new Date("2026-11-02T13:59:00Z"))).toBe(false);
    expect(inQuietHours(SERVICE, new Date("2026-11-02T20:00:00Z"))).toBe(false);
  });

  it("chỉ tin Admin soạn mới được đưa nguyên nội dung lên push (BR-53)", () => {
    expect(pushCarriesMessage(NotificationKind.PROMOTION)).toBe(true);
    expect(pushCarriesMessage(NotificationKind.NEWS)).toBe(true);
    expect(pushCarriesMessage(NotificationKind.SERVICE_NOTICE)).toBe(true);
    expect(pushCarriesMessage(NotificationKind.BOOKING_CONFIRMED)).toBe(false);
    expect(pushCarriesMessage(NotificationKind.REFUND_SUCCEEDED)).toBe(false);
  });
});
