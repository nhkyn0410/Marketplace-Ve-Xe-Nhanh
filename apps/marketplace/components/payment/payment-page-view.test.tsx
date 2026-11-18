import { renderToStaticMarkup } from "react-dom/server";
import { describe, expect, it, vi } from "vitest";

import { mapPaymentProviders, paymentMethodOf, paymentProviderLabel, paymentProviderOf } from "../../lib/data/booking-mappers";
import type { PaymentProviderOption } from "../../lib/data/types";
import { bookingPaymentIdealFixture } from "../../lib/preview/fixtures/booking";
import { defaultPaymentMethod, visiblePaymentProviders } from "./payment-method-selector";
import { PaymentPageView } from "./payment-page-view";

vi.mock("../../lib/data/booking", () => ({ createPayment: vi.fn() }));

const radios = (html: string) => [...html.matchAll(/<div[^>]*data-method="([a-z]+)"[^>]*>/g)].map((match) => ({
  method: match[1],
  checked: match[0].includes('aria-checked="true"'),
  disabled: match[0].includes('aria-disabled="true"')
}));

describe("trang thanh toán B3 — đồng ý điều khoản (SCR-PSG-20)", () => {
  it("mặc định chưa tick và nút thanh toán bị khóa", () => {
    const html = renderToStaticMarkup(<PaymentPageView paymentData={bookingPaymentIdealFixture} />);
    const checkbox = html.match(/<input[^>]*type="checkbox"[^>]*>/)?.[0] ?? "";
    const payButton = html.match(/<button[^>]*>Thanh toán [^<]*<\/button>/)?.[0] ?? "";

    expect(checkbox).not.toBe("");
    expect(checkbox).not.toContain("checked");
    expect(payButton).toContain("disabled");
  });
});

describe("trang thanh toán B3 — cổng lấy từ máy chủ (PASSENGER-PARITY Q5)", () => {
  const all: PaymentProviderOption[] = [
    { method: "payos", enabled: false },
    { method: "momo", enabled: true },
    { method: "vnpay", enabled: true },
    { method: "demo", enabled: false }
  ];

  it("giữ thứ tự máy chủ; cổng thật chưa bật hiện mờ 'Sắp hỗ trợ'; cổng thử chưa bật thì ẩn; chọn sẵn cổng đang bật đầu tiên", () => {
    const html = renderToStaticMarkup(<PaymentPageView paymentData={{ ...bookingPaymentIdealFixture, selectedPaymentMethod: undefined }} providers={all} />);
    expect(radios(html)).toEqual([
      { method: "payos", checked: false, disabled: true },
      { method: "momo", checked: true, disabled: false },
      { method: "vnpay", checked: false, disabled: false }
    ]);
    expect(html).toContain("Sắp hỗ trợ");
    expect(html).not.toContain("Cổng thanh toán thử");
  });

  it("cổng của lần trước còn bật thì chọn lại; đã tắt thì chọn cổng đang bật đầu tiên", () => {
    expect(defaultPaymentMethod(all, "vnpay")).toBe("vnpay");
    expect(defaultPaymentMethod(all, "payos")).toBe("momo");
    expect(defaultPaymentMethod([{ method: "demo", enabled: true }])).toBe("demo");
    expect(defaultPaymentMethod([{ method: "vnpay", enabled: false }])).toBeUndefined();
    expect(visiblePaymentProviders([{ method: "demo", enabled: true }])).toHaveLength(1);
  });

  it("không có cổng nào bật: báo rõ và khóa nút thanh toán", () => {
    const html = renderToStaticMarkup(<PaymentPageView paymentData={{ ...bookingPaymentIdealFixture, selectedPaymentMethod: undefined }} providers={[{ method: "vnpay", enabled: false }]} />);
    expect(html).toContain("Hiện chưa có cổng thanh toán nào hoạt động");
    expect(html.match(/<button[^>]*>Thanh toán [^<]*<\/button>/)?.[0]).toContain("disabled");
  });

  it("đổi qua lại mã cổng của API, bỏ mã lạ, tên cổng cho khách đọc", () => {
    expect(mapPaymentProviders({ items: [{ provider: "PAYOS", enabled: true }, { provider: "DEMO", enabled: false }] })).toEqual([
      { method: "payos", enabled: true },
      { method: "demo", enabled: false }
    ]);
    expect(paymentProviderOf("momo")).toBe("MOMO");
    expect(paymentProviderOf("tienmat")).toBeUndefined();
    expect(paymentMethodOf("VNPAY")).toBe("vnpay");
    expect(paymentMethodOf(null)).toBeUndefined();
    expect(["VNPAY", "MOMO", "PAYOS", "DEMO"].map(paymentProviderLabel)).toEqual(["VNPay", "MoMo", "payOS", "Cổng thanh toán thử"]);
    expect(paymentProviderLabel(undefined)).toBe("Chưa thanh toán");
  });
});
