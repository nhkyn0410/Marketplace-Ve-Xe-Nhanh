import { describe, expect, it } from "vitest";
import { PaymentInputSchema } from "./dto/payment.dto";
import { paymentReturnUrl } from "./payment.service";

// PASSENGER-PARITY P4: app nhận địa chỉ quay về App Link, web giữ trang kết quả của Marketplace.
describe("địa chỉ cổng đưa khách quay về", () => {
  it("web (mặc định) về trang kết quả; app về đường dẫn App Link cùng origin", () => {
    expect(paymentReturnUrl("https://vexenhanh.example/", "b1", undefined)).toBe("https://vexenhanh.example/bookings/b1/payment/result");
    expect(paymentReturnUrl("https://vexenhanh.example", "b1", "WEB")).toBe("https://vexenhanh.example/bookings/b1/payment/result");
    expect(paymentReturnUrl("https://vexenhanh.example//", "b1", "APP")).toBe("https://vexenhanh.example/app/bookings/b1/payment/result");
  });

  it("client chỉ nhận WEB / APP, bỏ trống vẫn hợp lệ", () => {
    expect(PaymentInputSchema.parse({ provider: "MOMO" })).toEqual({ provider: "MOMO" });
    expect(PaymentInputSchema.parse({ provider: "MOMO", client: "APP" })).toEqual({ provider: "MOMO", client: "APP" });
    expect(PaymentInputSchema.safeParse({ provider: "MOMO", client: "IOS" }).success).toBe(false);
  });
});
