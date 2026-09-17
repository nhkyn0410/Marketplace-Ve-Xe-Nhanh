import { randomUUID } from "node:crypto";
import {
  afterAll,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  vi,
} from "vitest";
import type { AuditService } from "../../audit/audit.service";
import { parseAppConfig } from "../../config/env.config";
import { PrismaService } from "../../database/prisma.service";
import { SubjectType } from "../../database/prisma.types";
import { RefreshTokenService } from "./refresh-token.service";
import { SessionService } from "./session.service";
import { HttpException } from "@nestjs/common";

const url = process.env.DATABASE_URL;

async function errorCode(
  promise: Promise<unknown>,
): Promise<string | undefined> {
  try {
    await promise;
    return undefined;
  } catch (error) {
    return ((error as HttpException).getResponse() as { code?: string }).code;
  }
}

// Tự bỏ qua khi không có DB — `pnpm test` trong CI không có Postgres.
describe.skipIf(!url)("SessionService — Postgres thật", () => {
  let prisma: PrismaService;
  let sessions: SessionService;
  const subjectId = `int_${randomUUID()}`;
  const audit = { recordAuditEvent: vi.fn() };
  let reachable = false;

  beforeAll(async () => {
    const config = parseAppConfig({ DATABASE_URL: url });

    prisma = new PrismaService(config);
    // Prisma 7 + driver adapter kết nối LƯỜI: `$connect()` qua trót lọt dù Postgres tắt,
    // lỗi chỉ nổ ở truy vấn đầu tiên với thông báo RỖNG (`PrismaClientKnownRequestError:`)
    // ngay trong `create()` — nhìn vào không ai đoán ra là DB chưa bật. Hỏi thử một câu.
    try {
      await prisma.$queryRaw`SELECT 1`;
      reachable = true;
    } catch (error) {
      throw new Error(
        "Không kết nối được Postgres — chạy `docker compose up -d` rồi thử lại.",
        { cause: error },
      );
    }
    sessions = new SessionService(
      config,
      prisma,
      new RefreshTokenService(),
      audit as unknown as AuditService,
    );
  });

  // `audit` dùng chung cho cả file. Không xoá lịch sử gọi giữa các test thì lượt
  // handleReuse của test race bị cộng dồn sang test reuse → `toHaveBeenCalledOnce` đỏ oan.
  beforeEach(() => audit.recordAuditEvent.mockClear());

  afterAll(async () => {
    // DB không lên thì dọn dẹp cũng chỉ ném thêm một ECONNREFUSED che mất lỗi thật.
    if (reachable) {
      await prisma.authSession.deleteMany({ where: { subjectId } });
    }
    await prisma.$disconnect();
  });

  it("hai rotate song song cùng một token: đúng một thắng, không sinh row mồ côi", async () => {
    const first = await sessions.create(
      { type: SubjectType.PASSENGER, id: subjectId },
      {},
    );

    const results = await Promise.allSettled([
      sessions.rotate(first.refreshToken, {}),
      sessions.rotate(first.refreshToken, {}),
    ]);

    expect(results.filter((r) => r.status === "fulfilled")).toHaveLength(1);

    // Đúng 2 row trong family: gốc + đúng 1 row con. Row con của bên thua đã rollback.
    const family = await prisma.authSession.findMany({
      where: { familyId: first.session.familyId },
    });
    expect(family).toHaveLength(2);
    // Cả hai kiểu xen kẽ đều đi qua handleReuse → cả family phải chết (Q5 strict).
    expect(family.every((s) => s.revokedAt !== null)).toBe(true);
  });

  it("dùng lại token đã rotate: revoke cả family, ghi audit, audit không chứa token", async () => {
    const first = await sessions.create(
      { type: SubjectType.PASSENGER, id: subjectId },
      {},
    );
    const second = await sessions.rotate(first.refreshToken, {});

    expect(await errorCode(sessions.rotate(first.refreshToken, {}))).toBe(
      "AUTH_SESSION_EXPIRED",
    );

    const family = await prisma.authSession.findMany({
      where: { familyId: first.session.familyId },
    });
    expect(family.every((s) => s.revokedReason === "REUSE_DETECTED")).toBe(
      true,
    );

    // Token mới cũng chết theo — đó là ý nghĩa của family invalidation.
    expect(await errorCode(sessions.rotate(second.refreshToken, {}))).toBe(
      "AUTH_SESSION_EXPIRED",
    );

    expect(audit.recordAuditEvent).toHaveBeenCalledOnce();
    expect(JSON.stringify(audit.recordAuditEvent.mock.calls)).not.toContain(
      first.refreshToken,
    );
  });

  it("rotate hợp lệ: token mới khác token cữ, cùng family, row cũ trở sang row mới", async () => {
    const first = await sessions.create(
      { type: SubjectType.PASSENGER, id: subjectId },
      {},
    );
    const second = await sessions.rotate(first.refreshToken, {});

    expect(second.refreshToken).not.toBe(first.refreshToken);
    expect(second.session.familyId).toBe(first.session.familyId);
    const parent = await prisma.authSession.findUniqueOrThrow({
      where: { id: first.session.id },
    });
    expect(parent.rotatedAt).not.toBeNull();
    expect(parent.replacedById).toBe(second.session.id);

    expect(JSON.stringify(parent)).not.toContain(first.refreshToken);
  });

  it("token không tồn tại / hết hạn / đã revoke: cùng AUTH_SESSION_EXPIRED, KHÔNG coi là reuse", async () => {
    expect(await errorCode(sessions.rotate("khong-ton-tai", {}))).toBe(
      "AUTH_SESSION_EXPIRED",
    );

    const expired = await sessions.create(
      { type: SubjectType.PASSENGER, id: subjectId },
      {},
    );
    await prisma.authSession.update({
      where: { id: expired.session.id },
      data: { expiresAt: new Date(Date.now() - 1000) },
    });
    expect(await errorCode(sessions.rotate(expired.refreshToken, {}))).toBe(
      "AUTH_SESSION_EXPIRED",
    );
    const revoked = await sessions.create(
      { type: SubjectType.PASSENGER, id: subjectId },
      {},
    );

    await sessions.revokeSession(revoked.session.id, "LOGOUT");
    expect(await errorCode(sessions.rotate(revoked.refreshToken, {}))).toBe(
      "AUTH_SESSION_EXPIRED",
    );
    // Ba ca trên đều là "phiên đã hết", không phải tấn không audit, không đổi lý do revoke.
    expect(audit.recordAuditEvent).not.toHaveBeenCalled();
    const row = await prisma.authSession.findUniqueOrThrow({
      where: { id: revoked.session.id },
    });
    expect(row.revokedReason).toBe("LOGOUT");
  });
  it("revokeAllForSubject(OPERATOR, id) không đụng EMPLOYEE trùng id (Q2)", async () => {
    const shareId = `share_${randomUUID}`;
    const operator = await sessions.create(
      { type: SubjectType.OPERATOR, id: shareId },
      {},
    );
    const employee = await sessions.create(
      { type: SubjectType.EMPLOYEE, id: shareId },
      {},
    );

    expect(
      await sessions.revokeAllForSubject(
        SubjectType.OPERATOR,
        shareId,
        "ACCOUNT_LOCKED",
      ),
    ).toBe(1);
    expect(await errorCode(sessions.rotate(operator.refreshToken, {}))).toBe(
      "AUTH_SESSION_EXPIRED",
    );
    const next = await sessions.rotate(employee.refreshToken, {});

    expect(next.session.subjectType).toBe("EMPLOYEE");
    await prisma.authSession.deleteMany({ where: { subjectId: shareId } });
  });
});
