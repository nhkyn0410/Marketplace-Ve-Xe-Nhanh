import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { AuditWriteError, type AuditEventInput, type AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { platformScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { EmailNotifier, StopPointDecisionEmailMessage } from "../external/notification/email-notifier";
import type { Authorization } from "../iam/role/authorization";
import { AdminStopPointService, distanceMeters } from "./admin-stop-point.service";
import {
  ProposalApprovalInputSchema,
  SharedStopPointInputSchema,
  SharedStopPointListQuerySchema,
  OperatorPointListQuerySchema,
  ProposalListQuerySchema,
} from "./dto/admin-stop-point.dto";
import { StopPointInputSchema, StopPointProposalInputSchema } from "./dto/stop-point.dto";
import { StopPointProposalService } from "./stop-point-proposal.service";
import { StopPointService } from "./stop-point.service";

/**
 * TASK-ADM-004 — Admin quản lý điểm dừng trên Postgres THẬT bằng role APP (TC-TRN-017, TC-TRN-018 phần Admin,
 * CHECK danh mục dùng chung của BR-38). Nhà xe đi qua service thật trong scope tenant; audit là bản giả.
 */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string; text?: string }> {
  try {
    await promise;
    return {};
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string } }).getResponse?.();
    return {
      status: (error as { getStatus?: () => number }).getStatus?.(),
      code: response?.code,
      text: String(error),
    };
  }
}

describe.skipIf(!url && !requireDb)("Admin quản lý điểm dừng — Postgres thật, role app", () => {
  let prisma: PrismaService;
  let admin: AdminStopPointService;
  let ownPoints: StopPointService;
  let proposals: StopPointProposalService;
  const tag = randomUUID().slice(0, 8);
  const province = randomUUID();
  const ward = randomUUID();
  const tenantA = randomUUID();
  const tenantB = randomUUID();
  const actor = { sub: randomUUID(), role: "PLATFORM_ADMIN" };
  const platformAuthz = { db: platformScope() } as Authorization;
  const tenantAuthz = (operatorId: string): Authorization => ({
    permission: "route:manage",
    scope: "tenant",
    db: tenantScope(operatorId),
  });
  const sendStopPointDecision = vi.fn(async (_message: StopPointDecisionEmailMessage) => undefined);
  const notifier = { sendOtp: async () => undefined, sendStopPointDecision } as EmailNotifier;
  const ownerEmail = `owner-a@${tag}.test`;
  const events: AuditEventInput[] = [];
  const recordAuditEvent = vi.fn(async (event: AuditEventInput) => {
    events.push(event);
  });

  const location = (overrides: Record<string, unknown> = {}) => ({
    name: `Điểm ${randomUUID().slice(0, 6)} ${tag}`,
    address: "Xa lộ Hà Nội",
    provinceId: province,
    wardId: ward,
    latitude: 10.8,
    longitude: 106.75,
    description: null,
    ...overrides,
  });
  const sharedInput = (overrides: Record<string, unknown> = {}) =>
    SharedStopPointInputSchema.parse({
      ...location(),
      type: "BUS_STATION",
      legalBasis: "QĐ 2816/QĐ-SGTVT",
      status: "ACTIVE",
      ...overrides,
    });
  const approval = (proposal: { name: string; latitude: number; longitude: number }, overrides: Record<string, unknown> = {}) =>
    ProposalApprovalInputSchema.parse({
      ...location({ name: proposal.name, latitude: proposal.latitude, longitude: proposal.longitude }),
      type: "PICKUP_POINT",
      legalBasis: "QĐ 4127/QĐ-SGTVT",
      ...overrides,
    });
  async function propose(operatorId = tenantA, overrides: Record<string, unknown> = {}) {
    return proposals.create(
      tenantAuthz(operatorId),
      StopPointProposalInputSchema.parse({
        ...location(),
        type: "PICKUP_POINT",
        legalBasis: "QĐ 4127/QĐ-SGTVT",
        ...overrides,
      }),
    );
  }
  const sharedCount = () =>
    prisma.withSystem((tx) => tx.stopPointCatalog.count({ where: { name: { endsWith: tag } } }));

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`
      SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user`;
    if (!role || role.rolsuper || role.rolbypassrls) {
      throw new Error("DATABASE_URL đang là superuser/BYPASSRLS — dùng role app (TRN-001-guide.md §0).");
    }
    admin = new AdminStopPointService(prisma, { recordAuditEvent } as unknown as AuditService, notifier);
    ownPoints = new StopPointService(prisma);
    proposals = new StopPointProposalService(prisma);
    await prisma.withSystem(async (tx) => {
      await tx.province.create({ data: { id: province, code: `ap-${tag}`, name: `Tỉnh ${tag}` } });
      await tx.ward.create({ data: { id: ward, provinceId: province, code: `aw-${tag}`, name: "Phường A" } });
      await tx.operatorProfile.createMany({
        data: [
          { id: tenantA, operatorSlug: `adm004-a-${tag}`, displayName: "Nhà xe A" },
          { id: tenantB, operatorSlug: `adm004-b-${tag}`, displayName: "Nhà xe B" },
        ],
      });
      // Chủ nhà xe A có email liên hệ (nhận email báo quyết định); B chưa có email nên không ai nhận.
      await tx.operatorAccount.createMany({
        data: [
          { operatorId: tenantA, operatorSlug: `adm004-a-${tag}`, username: "owner01", passwordHash: "x", contactEmail: ownerEmail },
          { operatorId: tenantB, operatorSlug: `adm004-b-${tag}`, username: "owner01", passwordHash: "x" },
        ],
      });
    });
  }, 30_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      const operators = { operatorId: { in: [tenantA, tenantB] } };
      await tx.stopPointProposal.deleteMany({ where: operators });
      await tx.stopPoint.deleteMany({ where: operators });
      await tx.operatorAccount.deleteMany({ where: operators });
      await tx.stopPointCatalog.deleteMany({ where: { provinceId: province } });
      await tx.operatorProfile.deleteMany({ where: { id: { in: [tenantA, tenantB] } } });
      await tx.ward.deleteMany({ where: { id: ward } });
      await tx.province.deleteMany({ where: { id: province } });
    });
    await prisma.$disconnect();
  });

  beforeEach(() => {
    sendStopPointDecision.mockReset();
    sendStopPointDecision.mockResolvedValue(undefined);
    recordAuditEvent.mockClear();
    recordAuditEvent.mockImplementation(async (event: AuditEventInput) => {
      events.push(event);
    });
  });

  describe("Danh mục dùng chung (BR-38)", () => {
    it("CHECK của DB: không có văn phòng; bến xe / điểm dừng đón trả bắt buộc căn cứ; trạm dừng nghỉ không bắt buộc", async () => {
      const insert = (data: Record<string, unknown>) =>
        rejectionOf(
          prisma.withSystem((tx) =>
            tx.stopPointCatalog.create({ data: { ...location(), ...data } as never, select: { id: true } }),
          ),
        );
      expect((await insert({ type: "OFFICE", legalBasis: "x" })).text).toContain("stop_points_catalog_shared_type");
      expect((await insert({ type: "BUS_STATION" })).text).toContain("stop_points_catalog_legal_basis_present");
      expect((await insert({ type: "PICKUP_POINT", legalBasis: "   " })).text).toContain(
        "stop_points_catalog_legal_basis_present",
      );
      expect(await insert({ type: "REST_STOP" })).toEqual({});
    });

    it("scope tenant không ghi được danh mục dùng chung (RLS)", async () => {
      const result = await rejectionOf(
        prisma.withScope(tenantScope(tenantA), (tx) =>
          tx.stopPointCatalog.create({ data: { ...location(), type: "REST_STOP" }, select: { id: true } }),
        ),
      );
      expect(result.text).toMatch(/row-level security|42501/);
    });

    it("DTO: bến xe thiếu căn cứ → lỗi tại `legalBasis`; trạm dừng nghỉ không cần; văn phòng không nhận", () => {
      const missing = SharedStopPointInputSchema.safeParse({ ...location(), type: "BUS_STATION", legalBasis: null, status: "ACTIVE" });
      expect(missing.success).toBe(false);
      expect(missing.error?.issues[0]?.path).toEqual(["legalBasis"]);
      expect(SharedStopPointInputSchema.safeParse({ ...location(), type: "REST_STOP", legalBasis: "", status: "ACTIVE" }).success).toBe(true);
      expect(SharedStopPointInputSchema.safeParse({ ...location(), type: "OFFICE", legalBasis: "x", status: "ACTIVE" }).success).toBe(false);
    });

    it("thêm / sửa / ngừng dùng: audit trước–sau; danh sách lọc + tìm không dấu + cursor + tổng", async () => {
      const created = await admin.createShared(platformAuthz, actor, sharedInput({ name: `Bến xe Miền Đông ${tag}` }));
      expect(created).toMatchObject({ status: "ACTIVE", legalBasis: "QĐ 2816/QĐ-SGTVT", routeCount: 0, provinceName: `Tỉnh ${tag}` });
      expect(recordAuditEvent).toHaveBeenCalledWith(
        expect.objectContaining({ action: "stop_point_catalog.create", actorId: actor.sub, targetId: created.id }),
        expect.objectContaining({ timeoutMs: 2_000 }),
      );
      const second = await admin.createShared(platformAuthz, actor, sharedInput({ type: "REST_STOP", legalBasis: null }));

      const updated = await admin.updateShared(
        platformAuthz,
        actor,
        created.id,
        sharedInput({ name: created.name, status: "INACTIVE" }),
      );
      expect(updated.status).toBe("INACTIVE");
      expect(recordAuditEvent).toHaveBeenLastCalledWith(
        expect.objectContaining({
          action: "stop_point_catalog.update",
          before: expect.objectContaining({ status: "ACTIVE" }),
          after: expect.objectContaining({ status: "INACTIVE" }),
        }),
        expect.anything(),
      );

      const list = (query: object) =>
        admin.listShared(platformAuthz, SharedStopPointListQuerySchema.parse({ provinceId: province, ...query }));
      expect((await list({ q: "ben xe mien dong" })).items.map((item) => item.id)).toEqual([created.id]);
      expect((await list({ status: "INACTIVE" })).items.map((item) => item.id)).toEqual([created.id]);
      expect((await list({ type: "REST_STOP" })).items.map((item) => item.id)).toContain(second.id);
      const first = await list({ limit: 1 });
      expect(first.total).toBeGreaterThanOrEqual(2);
      const next = await list({ limit: 1, cursor: first.nextCursor });
      expect(next.items[0]!.id).not.toBe(first.items[0]!.id);

      expect(await rejectionOf(admin.getShared(platformAuthz, randomUUID()))).toMatchObject({
        status: 404,
        code: "STOP_POINT_NOT_FOUND",
      });
    });
  });

  describe("Duyệt đề xuất (TC-TRN-017)", () => {
    it("cảnh báo điểm dùng chung cùng loại trong 200 m; khác loại hoặc xa hơn thì không", async () => {
      const proposal = await propose(tenantA, { latitude: 10.82, longitude: 106.7 });
      // ~120 m về phía bắc, cùng loại.
      const near = await admin.createShared(
        platformAuthz,
        actor,
        sharedInput({ type: "PICKUP_POINT", latitude: 10.82108, longitude: 106.7 }),
      );
      await admin.createShared(platformAuthz, actor, sharedInput({ type: "BUS_STATION", latitude: 10.8201, longitude: 106.7 }));
      await admin.createShared(platformAuthz, actor, sharedInput({ type: "PICKUP_POINT", latitude: 10.825, longitude: 106.7 }));

      const detail = await admin.getProposal(platformAuthz, proposal.id);
      expect(detail.nearby.map((item) => item.id)).toEqual([near.id]);
      expect(detail.nearby[0]!.distanceMeters).toBeGreaterThan(100);
      expect(detail.nearby[0]!.distanceMeters).toBeLessThan(140);
      expect(detail.operatorName).toBe("Nhà xe A");

      const listed = await admin.listProposals(platformAuthz, ProposalListQuerySchema.parse({ operatorId: tenantA, status: "PENDING" }));
      expect(listed.items.find((item) => item.id === proposal.id)?.nearby).toHaveLength(1);
      expect(distanceMeters({ latitude: 10.82, longitude: 106.7 }, { latitude: 10.82108, longitude: 106.7 })).toBeCloseTo(120, -1);
    });

    it("duyệt theo thông tin Admin chỉnh → đúng một điểm dùng chung, nhà xe khác gắn được; hai Admin cùng lúc → một 409", async () => {
      const proposal = await propose(tenantA);
      const before = await sharedCount();
      const edited = approval(proposal, { name: `Điểm đón trả Hàng Xanh ${tag}` });
      const results = await Promise.allSettled([
        admin.approveProposal(platformAuthz, actor, proposal.id, edited),
        admin.approveProposal(platformAuthz, actor, proposal.id, edited),
      ]);
      expect(results.filter((result) => result.status === "fulfilled")).toHaveLength(1);
      const failed = results.find((result) => result.status === "rejected") as PromiseRejectedResult;
      expect(await rejectionOf(Promise.reject(failed.reason))).toMatchObject({
        status: 409,
        code: "STOP_POINT_PROPOSAL_STATE_INVALID",
      });
      expect(await sharedCount()).toBe(before + 1);

      const approved = (results.find((result) => result.status === "fulfilled") as PromiseFulfilledResult<{ catalogStopPointId: string | null }>).value;
      const shared = await admin.getShared(platformAuthz, approved.catalogStopPointId!);
      expect(shared).toMatchObject({ name: `Điểm đón trả Hàng Xanh ${tag}`, type: "PICKUP_POINT", status: "ACTIVE" });
      expect(recordAuditEvent).toHaveBeenCalledWith(
        expect.objectContaining({ action: "stop_point_proposal.approve", operatorId: tenantA, targetId: proposal.id }),
        expect.anything(),
      );
      // Email báo chủ nhà xe gửi một lần (lần duyệt thắng), sau commit, kèm tên điểm Admin đặt.
      expect(sendStopPointDecision).toHaveBeenCalledTimes(1);
      expect(sendStopPointDecision).toHaveBeenCalledWith({
        email: ownerEmail,
        operatorName: "Nhà xe A",
        stopPointName: proposal.name,
        decision: "PROPOSAL_APPROVED",
        sharedName: `Điểm đón trả Hàng Xanh ${tag}`,
      });
      // Nhà xe đề xuất thấy kết quả; nhà xe khác không thấy đề xuất nhưng thấy điểm dùng chung mới.
      const own = await proposals.list(tenantAuthz(tenantA), { status: "APPROVED", limit: 100 });
      expect(own.items.map((item) => item.id)).toContain(proposal.id);
      const foreign = await proposals.list(tenantAuthz(tenantB), { limit: 100 });
      expect(foreign.items.map((item) => item.id)).not.toContain(proposal.id);
    });

    it("từ chối: lý do lưu lại, nhà xe sửa rồi gửi lại được; từ chối / duyệt đề xuất đã có kết quả → 409", async () => {
      const proposal = await propose(tenantB);
      const rejected = await admin.rejectProposal(platformAuthz, actor, proposal.id, "Thiếu số quyết định công bố");
      expect(rejected).toMatchObject({ status: "REJECTED", rejectionReason: "Thiếu số quyết định công bố" });
      // Nhà xe B chưa có chủ nhà xe nào có email → không gửi.
      expect(sendStopPointDecision).not.toHaveBeenCalled();
      expect(await rejectionOf(admin.rejectProposal(platformAuthz, actor, proposal.id, "x"))).toMatchObject({ status: 409 });
      expect(await rejectionOf(admin.approveProposal(platformAuthz, actor, proposal.id, approval(proposal)))).toMatchObject({
        status: 409,
      });
      const resubmitted = await proposals.resubmit(
        tenantAuthz(tenantB),
        proposal.id,
        StopPointProposalInputSchema.parse({ ...location(), type: "PICKUP_POINT", legalBasis: "QĐ 99/QĐ-SGTVT" }),
      );
      expect(resubmitted.status).toBe("PENDING");
      expect(await rejectionOf(admin.getProposal(platformAuthz, randomUUID()))).toMatchObject({ status: 404 });
    });

    it("audit lỗi khi duyệt → 503, không tạo điểm dùng chung, đề xuất vẫn Chờ duyệt", async () => {
      const proposal = await propose(tenantA);
      const before = await sharedCount();
      recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo down")));
      expect(await rejectionOf(admin.approveProposal(platformAuthz, actor, proposal.id, approval(proposal)))).toMatchObject({
        status: 503,
      });
      expect(await sharedCount()).toBe(before);
      expect((await admin.getProposal(platformAuthz, proposal.id)).status).toBe("PENDING");
    });
  });

  describe("Khóa điểm riêng (TC-TRN-018, BR-81)", () => {
    it("khóa kèm lý do → nhà xe không sửa được; khóa lại → 409; mở khóa → ACTIVE, xóa lý do; mở khóa lần nữa → 409", async () => {
      const point = await ownPoints.create(
        tenantAuthz(tenantA),
        StopPointInputSchema.parse({ ...location(), type: "OFFICE", status: "ACTIVE" }),
      );
      // Gửi email lỗi (chưa cấu hình Resend…) không làm hỏng thao tác khóa.
      sendStopPointDecision.mockRejectedValueOnce(new Error("domain not verified"));
      const suspended = await admin.suspend(platformAuthz, actor, point.id, "Tọa độ sai lệch địa chỉ");
      expect(sendStopPointDecision).toHaveBeenCalledWith(
        expect.objectContaining({ email: ownerEmail, decision: "SUSPENDED", reason: "Tọa độ sai lệch địa chỉ", stopPointName: point.name }),
      );
      expect(suspended).toMatchObject({ status: "SUSPENDED", suspensionReason: "Tọa độ sai lệch địa chỉ", operatorName: "Nhà xe A" });
      expect(recordAuditEvent).toHaveBeenCalledWith(
        expect.objectContaining({ action: "stop_point.suspend", operatorId: tenantA, reason: "Tọa độ sai lệch địa chỉ" }),
        expect.anything(),
      );
      expect(
        await rejectionOf(
          ownPoints.update(tenantAuthz(tenantA), point.id, StopPointInputSchema.parse({ ...location(), type: "OFFICE", status: "ACTIVE" })),
        ),
      ).toMatchObject({ status: 409, code: "STOP_POINT_SUSPENDED" });
      expect(await rejectionOf(admin.suspend(platformAuthz, actor, point.id, "lần nữa"))).toMatchObject({
        status: 409,
        code: "STOP_POINT_STATE_INVALID",
      });

      const listed = await admin.listOperatorPoints(
        platformAuthz,
        OperatorPointListQuerySchema.parse({ operatorId: tenantA, status: "SUSPENDED" }),
      );
      expect(listed.items.map((item) => item.id)).toEqual([point.id]);

      const reopened = await admin.unsuspend(platformAuthz, actor, point.id);
      expect(reopened).toMatchObject({ status: "ACTIVE", suspensionReason: null });
      expect(sendStopPointDecision).toHaveBeenLastCalledWith(expect.objectContaining({ decision: "UNSUSPENDED" }));
      expect(await rejectionOf(admin.unsuspend(platformAuthz, actor, point.id))).toMatchObject({ status: 409 });
      expect(await rejectionOf(admin.suspend(platformAuthz, actor, randomUUID(), "x"))).toMatchObject({
        status: 404,
        code: "STOP_POINT_NOT_FOUND",
      });
    });
  });
});
