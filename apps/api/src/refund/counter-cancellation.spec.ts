import { describe, expect, it, vi } from "vitest";
import { hashBookingToken } from "../booking/booking-access";
import type { BookingService } from "../booking/booking.service";
import type { PrismaService } from "../database/prisma.service";
import type { NotificationDispatcher } from "../notification/notification-dispatcher";
import { CancellationService } from "./cancellation.service";

function setup() {
  const tx = {
    $queryRaw: vi.fn().mockResolvedValue([]),
    booking: { findFirst: vi.fn().mockResolvedValue({ channel: "COUNTER", userId: null, accessTokenHash: hashBookingToken("guest-proof") }) },
    ticket: { updateMany: vi.fn() },
    refund: { create: vi.fn() },
  };
  const prisma = {
    withSystem: vi.fn(async (work: (value: unknown) => Promise<unknown>) => work({ booking: { findUnique: vi.fn().mockResolvedValue({ operatorId: "op-1" }) } })),
    withTenant: vi.fn(async (_tenant: string, work: (value: typeof tx) => Promise<unknown>) => work(tx)),
  };
  const queue = { add: vi.fn() };
  const notifications = { dispatch: vi.fn() };
  const service = new CancellationService(prisma as unknown as PrismaService, {} as BookingService, queue as never, notifications as unknown as NotificationDispatcher);
  return { service, tx, queue, notifications };
}

describe("Vé quầy không đi qua hoàn tiền online", () => {
  it("xem điều kiện và xác nhận hủy đều trả mã xử lý riêng, không hủy vé hay tạo gatewayrefund", async () => {
    const ctx = setup();
    for (const request of [() => ctx.service.quote(null, "booking-1", "guest-proof", ["ticket-1"]), () => ctx.service.cancel(null, "booking-1", "guest-proof", { ticketIds: ["ticket-1"], expectedRefund: 0, reason: null })]) {
      await expect(request()).rejects.toMatchObject({ status: 409, response: expect.objectContaining({ code: "COUNTER_REFUND_MANUAL_REQUIRED" }) });
    }
    expect(ctx.tx.ticket.updateMany).not.toHaveBeenCalled();
    expect(ctx.tx.refund.create).not.toHaveBeenCalled();
    expect(ctx.queue.add).not.toHaveBeenCalled();
    expect(ctx.notifications.dispatch).not.toHaveBeenCalled();
  });

  it("không lộ kênh hoặc quy trình hoàn cho người không có quyền booking", async () => {
    const ctx = setup();
    await expect(ctx.service.quote(null, "booking-1", "wrong-proof", ["ticket-1"])).rejects.toMatchObject({ status: 404 });
  });
});
