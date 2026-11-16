import { describe, expect, it, vi } from "vitest";
import type { DbTransaction } from "../database/prisma.service";
import { queueTicketEmail, ticketEmailKey, TICKET_EMAIL_DAILY_LIMIT } from "./ticket-email.service";

// PASSENGER-PARITY giai đoạn 4: gửi lại email vé điện tử (SCR-PSG-22) — quyền đơn, chống gửi dồn.
const now = new Date("2026-11-16T03:00:30Z");
const user = { sub: "user-1" } as never;

function tx(options: { booking?: Record<string, unknown> | null; sentToday?: number; inserted?: boolean } = {}) {
  const booking = options.booking === undefined
    ? { userId: "user-1", accessTokenHash: "h", accessGrants: [], status: "PAID", contactEmail: "khach@example.com", tickets: [{ id: "t1" }] }
    : options.booking;
  return {
    booking: { findFirst: vi.fn(async () => booking) },
    notification: { count: vi.fn(async () => options.sentToday ?? 0) },
    $queryRaw: vi.fn(async () => (options.inserted === false ? [] : [{ id: "n1" }])),
    notificationDelivery: { create: vi.fn(async () => ({})) },
  };
}

async function problemOf(promise: Promise<unknown>) {
  try {
    await promise;
    return null;
  } catch (error) {
    const exception = error as { getStatus(): number; getResponse(): { code: string } };
    return { status: exception.getStatus(), code: exception.getResponse().code };
  }
}

describe("gửi lại email vé", () => {
  it("chủ đơn: xếp lại thông báo vé điện tử tới email liên hệ, trả email đã che", async () => {
    const db = tx();
    const queued = await queueTicketEmail(db as unknown as DbTransaction, "op-1", "b-1", user, undefined, now);
    expect(queued).toEqual({ result: { sentTo: expect.stringContaining("@example.com"), resendAfterSeconds: 60 }, dedupKey: ticketEmailKey("b-1", now) });
    expect(queued!.result.sentTo).not.toBe("khach@example.com");
    expect(db.notificationDelivery.create).toHaveBeenCalledOnce();
  });

  it("không phải chủ đơn → null (404); đơn chưa có vé → 409", async () => {
    expect(await queueTicketEmail(tx() as unknown as DbTransaction, "op-1", "b-1", { sub: "khac" } as never, undefined, now)).toBeNull();
    const pending = tx({ booking: { userId: "user-1", accessTokenHash: "h", accessGrants: [], status: "PENDING_PAYMENT", contactEmail: "k@example.com", tickets: [] } });
    expect(await problemOf(queueTicketEmail(pending as unknown as DbTransaction, "op-1", "b-1", user, undefined, now))).toEqual({ status: 409, code: "TICKET_EMAIL_NOT_AVAILABLE" });
  });

  it("đã gửi trong phút này hoặc đủ 5 lần trong ngày → 429, không ghi thêm", async () => {
    expect(await problemOf(queueTicketEmail(tx({ inserted: false }) as unknown as DbTransaction, "op-1", "b-1", user, undefined, now))).toEqual({ status: 429, code: "TICKET_EMAIL_RATE_LIMITED" });
    const full = tx({ sentToday: TICKET_EMAIL_DAILY_LIMIT });
    expect(await problemOf(queueTicketEmail(full as unknown as DbTransaction, "op-1", "b-1", user, undefined, now))).toEqual({ status: 429, code: "TICKET_EMAIL_RATE_LIMITED" });
    expect(full.$queryRaw).not.toHaveBeenCalled();
  });

  it("khoá chống trùng đổi theo phút", () => {
    expect(ticketEmailKey("b-1", now)).toBe(ticketEmailKey("b-1", new Date("2026-11-16T03:00:59Z")));
    expect(ticketEmailKey("b-1", now)).not.toBe(ticketEmailKey("b-1", new Date("2026-11-16T03:01:00Z")));
  });
});
