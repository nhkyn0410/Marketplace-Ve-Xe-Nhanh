import type { Queue } from "bullmq";
import { describe, expect, it, vi } from "vitest";
import type { PrismaService } from "../database/prisma.service";
import { PayosGateway, signPayosData } from "../external/payment/payos/payos-gateway";
import { PaymentWebhookService } from "./payment-webhook.service";

const checksumKey = "payos-webhook-test-key";

function webhook(orderCode = 123) {
  const data = { orderCode, amount: 320000, currency: "VND", code: "00", reference: "TF-test-reference", paymentLinkId: "link-123", description: "VQR123" };
  return { code: "00", success: true, data, signature: signPayosData(data, checksumKey) };
}

function setup(found: boolean) {
  const findUnique = vi.fn(async () => found ? {
    paymentCode: "PAYABCDEFGH2345",
    providerOrderCode: 123n,
    provider: "PAYOS",
    status: "PROCESSING",
    amount: 320_000n,
    checkout: { paymentLinkId: "link-123" },
  } : null);
  const prisma = { withSystem: async (work: (tx: unknown) => Promise<unknown>) => work({ payment: { findUnique } }) } as unknown as PrismaService;
  const add = vi.fn(async () => undefined);
  const queue = { add } as unknown as Queue;
  const gateway = new PayosGateway({ clientId: "client", apiKey: "api", checksumKey, apiUrl: "https://api-merchant.payos.vn" });
  const service = new PaymentWebhookService(prisma, new Map([["PAYOS", gateway]]), queue);
  return { service, findUnique, add };
}

describe("payOS webhook — xác thực trước khi truy vấn và xác nhận hàng đợi", () => {
  it("probe có chữ ký hợp lệ nhưng không có đơn không tạo job thanh toán", async () => {
    const { service, findUnique, add } = setup(false);
    expect(await service.receive("PAYOS", webhook())).toBe("NOT_FOUND");
    expect(findUnique).toHaveBeenCalledWith(expect.objectContaining({ where: { providerOrderCode: 123n } }));
    expect(add).not.toHaveBeenCalled();
  });

  it("chữ ký sai bị từ chối trước cả truy vấn DB", async () => {
    const { service, findUnique, add } = setup(true);
    expect(await service.receive("PAYOS", { ...webhook(), signature: "00".repeat(32) })).toBe("INVALID_SIGNATURE");
    expect(findUnique).not.toHaveBeenCalled();
    expect(add).not.toHaveBeenCalled();
  });

  it("mã số của payOS được đổi sang mã nội bộ trước khi xếp hàng; tiền trong job là chuỗi", async () => {
    const { service, add } = setup(true);
    expect(await service.receive("PAYOS", webhook())).toBe("ACCEPTED");
    expect(add).toHaveBeenCalledWith("payment-callback", expect.objectContaining({ provider: "PAYOS", paymentCode: "PAYABCDEFGH2345", amount: "320000", providerTxnId: "TF-test-reference" }), expect.objectContaining({ jobId: expect.stringContaining("PAYABCDEFGH2345") }));
  });

  it("hàng đợi hỏng không được xác nhận đã nhận webhook", async () => {
    const { service, add } = setup(true);
    add.mockRejectedValueOnce(new Error("Redis unavailable"));
    await expect(service.receive("PAYOS", webhook())).rejects.toMatchObject({ status: 503 });
  });
});
