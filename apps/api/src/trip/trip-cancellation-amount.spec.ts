import { describe, expect, it } from "vitest";
import { tripCancellationRefund } from "./trip-cancellation-amount";

describe("Hủy chuyến — hoàn theo phần khách thực trả", () => {
  it("tổng hoàn bao gồm ưu đãi đã phân bổ cho từng vé", () => {
    expect(tripCancellationRefund([300_000n, 300_000n], 600_000n, 50_000n, 550_000n, 0n)).toBe(550_000n);
    // Một vé đã tự hủy và chỉ được hoàn 50%: vé còn lại vẫn hoàn theo phần đã trả, không nhận phần giảm / phí hủy của vé trước.
    expect(tripCancellationRefund([300_000n], 600_000n, 50_000n, 550_000n, 137_500n)).toBe(275_000n);
  });

  it("không vượt tiền còn lại sau các lần hoàn / yêu cầu hoàn trước và không âm", () => {
    expect(tripCancellationRefund([300_000n], 600_000n, 50_000n, 550_000n, 400_000n)).toBe(150_000n);
    expect(tripCancellationRefund([300_000n], 300_000n, 0n, 300_000n, 400_000n)).toBe(0n);
    expect(tripCancellationRefund([], 300_000n, 0n, 300_000n, 0n)).toBe(0n);
  });
});
