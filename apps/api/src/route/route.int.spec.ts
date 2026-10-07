import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { parseAppConfig } from "../config/env.config";
import { tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import {
  type Coordinates,
  type RouteLeg,
  type RoutingProvider,
  RoutingProviderError,
} from "../external/routing/routing-provider";
import type { Authorization } from "../iam/role/authorization";
import { StopPointInputSchema, StopPointProposalInputSchema } from "../stop-point/dto/stop-point.dto";
import { StopPointProposalService } from "../stop-point/stop-point-proposal.service";
import { StopPointService } from "../stop-point/stop-point.service";
import { RouteInputSchema } from "./dto/route.dto";
import { RouteService } from "./route.service";

/**
 * TASK-TRN-002 — Postgres THẬT bằng role APP (RLS chỉ có hiệu lực với role không superuser/BYPASSRLS).
 * Provider routing là fake đếm số lần gọi — không gọi Goong thật, không tốn quota.
 */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string; text: string }> {
  try {
    await promise;
    return { text: "" };
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string } }).getResponse?.();
    return {
      status: (error as { getStatus?: () => number }).getStatus?.(),
      code: response?.code,
      text: JSON.stringify(error, Object.getOwnPropertyNames(error)) + String(error),
    };
  }
}

/** Provider giả: chặng thứ i = 1000·(i+1) m, 60·(i+1) s; đếm lần gọi; bật lỗi được. */
class FakeRouting implements RoutingProvider {
  source: "GOONG" | "ESTIMATE" = "GOONG";
  calls = 0;
  fail = false;
  legsOverride: RouteLeg[] | null = null;
  async measureLegs(points: Coordinates[]): Promise<RouteLeg[]> {
    this.calls++;
    if (this.fail) {
      throw new RoutingProviderError("fake failure");
    }
    return this.legsOverride ?? points.slice(1).map((_point, index) => ({ distanceMeters: 1000 * (index + 1), durationSeconds: 60 * (index + 1) }));
  }
}

describe.skipIf(!url && !requireDb)("Route / StopPoint / Proposal — Postgres thật, role app", () => {
  let prisma: PrismaService;
  let stopPoints: StopPointService;
  let proposals: StopPointProposalService;
  let routes: RouteService;
  const routing = new FakeRouting();
  const tag = randomUUID().slice(0, 8);
  const tenantA = randomUUID();
  const tenantB = randomUUID();
  const province = randomUUID();
  const provinceOther = randomUUID();
  const ward = randomUUID();
  const wardInactive = randomUUID();
  const wardOther = randomUUID();
  const catalog1 = randomUUID();
  const catalog2 = randomUUID();
  const catalogInactive = randomUUID();
  const catalogInInactiveWard = randomUUID();
  const authzA = authz(tenantA);
  const authzB = authz(tenantB);

  function authz(operatorId: string): Authorization {
    return { permission: "route:manage", scope: "tenant", db: tenantScope(operatorId) };
  }

  function location(overrides: Record<string, unknown> = {}) {
    return {
      name: `Điểm ${randomUUID().slice(0, 6)}`,
      type: "OFFICE",
      address: "1 Trần Hưng Đạo",
      provinceId: province,
      wardId: ward,
      latitude: 10.75,
      longitude: 106.66,
      description: null,
      ...overrides,
    };
  }
  const stopPointInput = (overrides: Record<string, unknown> = {}) =>
    StopPointInputSchema.parse({ ...location(overrides), status: "ACTIVE", ...overrides });
  // Đề xuất chỉ nhận bến xe / điểm dừng đón trả và bắt buộc căn cứ công bố (BR-38).
  const proposalInput = (overrides: Record<string, unknown> = {}) =>
    StopPointProposalInputSchema.parse({
      ...location({ type: "BUS_STATION", ...overrides }),
      legalBasis: "QĐ 1234/QĐ-SGTVT ngày 01/01/2026",
      ...overrides,
    });
  type StopFlags = { allowPickup?: boolean; allowDropoff?: boolean };
  const catalogStop = (id: string, flags: StopFlags = {}) => ({ catalogStopPointId: id, stopPointId: null, note: null, ...flags });
  const privateStop = (id: string, flags: StopFlags = {}) => ({ catalogStopPointId: null, stopPointId: id, note: null, ...flags });
  /** Điểm không khai cờ thì nhận mặc định hợp lệ theo vị trí: đầu chỉ đón, cuối chỉ trả, giữa cả hai (BR-79). */
  const routeInput = (name: string, stops: (object & StopFlags)[], overrides: Record<string, unknown> = {}) =>
    RouteInputSchema.parse({
      name,
      status: "ACTIVE",
      note: null,
      stops: stops.map((stop, index) => ({
        allowPickup: index !== stops.length - 1,
        allowDropoff: index !== 0,
        ...stop,
      })),
      ...overrides,
    });

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    stopPoints = new StopPointService(prisma);
    proposals = new StopPointProposalService(prisma);
    routes = new RouteService(prisma, routing);
    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`
      SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user`;
    if (!role || role.rolsuper || role.rolbypassrls) {
      throw new Error("DATABASE_URL đang là superuser/BYPASSRLS — dùng role app (TRN-002-guide.md §0).");
    }
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({
        data: [
          { id: tenantA, operatorSlug: `rt-a-${tag}`, displayName: "RT A" },
          { id: tenantB, operatorSlug: `rt-b-${tag}`, displayName: "RT B" },
        ],
      });
      await tx.province.createMany({
        data: [
          { id: province, code: `rp-${tag}`, name: "Tỉnh route" },
          { id: provinceOther, code: `ro-${tag}`, name: "Tỉnh khác" },
        ],
      });
      await tx.ward.createMany({
        data: [
          { id: ward, provinceId: province, code: `rw-${tag}`, name: "Phường route" },
          { id: wardInactive, provinceId: province, code: `ri-${tag}`, name: "Phường ngừng", status: "INACTIVE" },
          { id: wardOther, provinceId: provinceOther, code: `rx-${tag}`, name: "Phường tỉnh khác" },
        ],
      });
      const point = (id: string, name: string, extra: Record<string, unknown> = {}) => ({
        id,
        name: `${name} ${tag}`,
        type: "BUS_STATION" as const,
        address: "x",
        provinceId: province,
        wardId: ward,
        latitude: 10.8,
        longitude: 106.7,
        ...extra,
      });
      await tx.stopPointCatalog.createMany({
        data: [
          point(catalog1, "Bến 1", { latitude: 10.74, longitude: 106.62 }),
          point(catalog2, "Bến 2", { latitude: 11.93, longitude: 108.44 }),
          point(catalogInactive, "Bến ngừng", { status: "INACTIVE" }),
          point(catalogInInactiveWard, "Bến phường ngừng", { wardId: wardInactive }),
        ],
      });
    });
  }, 30_000);

  beforeEach(() => {
    routing.calls = 0;
    routing.fail = false;
    routing.legsOverride = null;
    routing.source = "GOONG";
  });

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      const operatorId = { in: [tenantA, tenantB] };
      await tx.routeStop.deleteMany({ where: { operatorId } });
      await tx.route.deleteMany({ where: { operatorId } });
      await tx.stopPointProposal.deleteMany({ where: { operatorId } });
      await tx.stopPoint.deleteMany({ where: { operatorId } });
      await tx.stopPointCatalog.deleteMany({ where: { provinceId: { in: [province, provinceOther] } } });
      await tx.ward.deleteMany({ where: { provinceId: { in: [province, provinceOther] } } });
      await tx.province.deleteMany({ where: { id: { in: [province, provinceOther] } } });
      await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
    });
    await prisma.$disconnect();
  });

  describe("RLS", () => {
    it("4 bảng ENABLE + FORCE RLS; đề xuất có đủ 4 policy theo lệnh; rlsProblems() rỗng", async () => {
      const forced = await prisma.$queryRaw<{ relname: string }[]>`
        SELECT relname FROM pg_class
        WHERE relname IN ('stop_points','stop_point_proposals','routes','route_stops')
          AND relrowsecurity AND relforcerowsecurity`;
      expect(forced.map((row) => row.relname).sort()).toEqual(["route_stops", "routes", "stop_point_proposals", "stop_points"]);
      const policies = await prisma.$queryRaw<{ policyname: string; cmd: string }[]>`
        SELECT policyname, cmd FROM pg_policies WHERE tablename = 'stop_point_proposals'`;
      expect(policies.map((row) => `${row.cmd}:${row.policyname}`).sort()).toEqual([
        "DELETE:platform_delete",
        "INSERT:tenant_insert_pending",
        "SELECT:tenant_read",
        "UPDATE:tenant_resubmit_rejected",
      ]);
      // TRN-012: điểm riêng cũng tách policy theo lệnh để khoá `SUSPENDED` và chặn xoá cứng phía tenant.
      const stopPointPolicies = await prisma.$queryRaw<{ policyname: string; cmd: string }[]>`
        SELECT policyname, cmd FROM pg_policies WHERE tablename = 'stop_points'`;
      expect(stopPointPolicies.map((row) => `${row.cmd}:${row.policyname}`).sort()).toEqual([
        "DELETE:platform_delete",
        "INSERT:tenant_insert_not_suspended",
        "SELECT:tenant_read",
        "UPDATE:tenant_update_not_suspended",
      ]);
      expect(await prisma.rlsProblems()).toEqual([]);
    });

    it("điểm riêng bị khóa (BR-81, TC-TRN-018): ghi thẳng DB bằng scope tenant cũng không tự khóa, tự mở, sửa hay xoá được", async () => {
      const own = await stopPoints.create(authzA, stopPointInput({ name: `Khóa RLS ${tag}` }));
      const tenantOnly = (work: Parameters<PrismaService["withTenant"]>[1]) => prisma.withTenant(tenantA, work);

      // Nhà xe không tự đặt SUSPENDED: tạo mới hay sửa đều bị RLS chặn.
      const insertSuspended = await rejectionOf(
        tenantOnly((tx) =>
          tx.stopPoint.create({
            data: { ...stopPointInput(), operatorId: tenantA, status: "SUSPENDED", suspensionReason: "tự khóa" },
          }),
        ),
      );
      expect(insertSuspended.text).toMatch(/row-level security|42501/);
      const selfSuspend = await rejectionOf(
        tenantOnly((tx) =>
          tx.stopPoint.update({ where: { id: own.id }, data: { status: "SUSPENDED", suspensionReason: "tự khóa" } }),
        ),
      );
      expect(selfSuspend.text).toMatch(/row-level security|42501/);

      // Admin (scope platform) khóa → tenant vẫn ĐỌC được kèm lý do, nhưng không ghi được dòng đó.
      await prisma.withPlatform((tx) =>
        tx.stopPoint.update({ where: { id: own.id }, data: { status: "SUSPENDED", suspensionReason: "Sai toạ độ" } }),
      );
      expect(await stopPoints.get(authzA, own.id)).toMatchObject({ status: "SUSPENDED", suspensionReason: "Sai toạ độ" });
      expect(
        await tenantOnly((tx) =>
          tx.stopPoint.updateMany({ where: { id: own.id }, data: { status: "ACTIVE", suspensionReason: null } }),
        ),
      ).toEqual({ count: 0 });
      expect(await tenantOnly((tx) => tx.stopPoint.updateMany({ where: { id: own.id }, data: { name: "đổi lén" } }))).toEqual({
        count: 0,
      });
      // Không xoá cứng điểm dừng (BR-38): kể cả điểm chưa bị khóa.
      const other = await stopPoints.create(authzA, stopPointInput());
      expect(await tenantOnly((tx) => tx.stopPoint.deleteMany({ where: { id: { in: [own.id, other.id] } } }))).toEqual({
        count: 0,
      });
      expect(await stopPoints.get(authzA, own.id)).toMatchObject({ status: "SUSPENDED", name: `Khóa RLS ${tag}` });
    });

    it("query CỐ Ý quên lọc operator_id: tenant B không đọc/sửa/xoá được điểm, route, điểm dừng của A", async () => {
      const own = await stopPoints.create(authzA, stopPointInput({ name: `RLS ${tag}` }));
      const route = await routes.create(authzA, routeInput(`RLS ${tag}`, [catalogStop(catalog1), privateStop(own.id)]));
      await prisma.withTenant(tenantB, async (tx) => {
        expect(await tx.stopPoint.findMany({ where: { id: own.id } })).toEqual([]);
        expect(await tx.route.findMany({ where: { id: route.id } })).toEqual([]);
        expect(await tx.routeStop.findMany({ where: { routeId: route.id } })).toEqual([]);
        expect((await tx.route.updateMany({ where: { id: route.id }, data: { name: "hack" } })).count).toBe(0);
        expect((await tx.routeStop.deleteMany({ where: { routeId: route.id } })).count).toBe(0);
        expect((await tx.stopPoint.updateMany({ where: { id: own.id }, data: { status: "INACTIVE" } })).count).toBe(0);
      });
      expect(await prisma.route.findMany({ where: { id: route.id } })).toEqual([]);
      expect((await routes.get(authzA, route.id)).stops).toHaveLength(2);
    });

    it("đề xuất: DB khoá state machine phía tenant — không tự duyệt/từ chối, không sửa bản PENDING, không xoá", async () => {
      const created = await proposals.create(authzA, proposalInput());
      const tenantOnly = (work: Parameters<PrismaService["withTenant"]>[1]) => prisma.withTenant(tenantA, work);

      // Tạo sẵn ở trạng thái khác PENDING (dữ liệu hợp lệ theo CHECK) → RLS chặn.
      const insertRejected = await rejectionOf(
        tenantOnly((tx) =>
          tx.stopPointProposal.create({
            data: { ...proposalInput(), operatorId: tenantA, status: "REJECTED", rejectionReason: "tự từ chối" },
          }),
        ),
      );
      expect(insertRejected.text).toMatch(/row-level security|42501/);
      // Bản PENDING không sửa được ở scope tenant (USING chỉ thấy bản REJECTED).
      expect(
        await tenantOnly((tx) => tx.stopPointProposal.updateMany({ where: { id: created.id }, data: { name: "sửa lén" } })),
      ).toEqual({ count: 0 });
      expect(await tenantOnly((tx) => tx.stopPointProposal.deleteMany({ where: { id: created.id } }))).toEqual({ count: 0 });

      // Admin (scope platform) từ chối → tenant không tự chuyển sang APPROVED được, chỉ gửi lại thành PENDING.
      await prisma.withPlatform((tx) =>
        tx.stopPointProposal.update({ where: { id: created.id }, data: { status: "REJECTED", rejectionReason: "Sai toạ độ" } }),
      );
      const selfApprove = await rejectionOf(
        tenantOnly((tx) =>
          tx.stopPointProposal.update({
            where: { id: created.id },
            data: { status: "APPROVED", rejectionReason: null, catalogStopPointId: catalog1 },
          }),
        ),
      );
      expect(selfApprove.text).toMatch(/row-level security|42501/);
      const resubmitted = await proposals.resubmit(authzA, created.id, proposalInput({ name: "Đã sửa toạ độ" }));
      expect(resubmitted).toMatchObject({ status: "PENDING", rejectionReason: null, name: "Đã sửa toạ độ" });
    });

    it("đề xuất: tenant không tạo hay chuyển được đề xuất sang operator_id của tenant khác", async () => {
      const insertForeign = await rejectionOf(
        prisma.withTenant(tenantA, (tx) =>
          tx.stopPointProposal.create({ data: { ...proposalInput(), operatorId: tenantB, status: "PENDING" } }),
        ),
      );
      expect(insertForeign.text).toMatch(/row-level security|42501/);
      const created = await proposals.create(authzA, proposalInput());
      await prisma.withPlatform((tx) =>
        tx.stopPointProposal.update({ where: { id: created.id }, data: { status: "REJECTED", rejectionReason: "Thiếu mô tả" } }),
      );
      const moveForeign = await rejectionOf(
        prisma.withTenant(tenantA, (tx) =>
          tx.stopPointProposal.update({
            where: { id: created.id },
            data: { operatorId: tenantB, status: "PENDING", rejectionReason: null },
          }),
        ),
      );
      expect(moveForeign.text).toMatch(/row-level security|42501/);
    });
  });

  describe("Invariant DB (scope system — DB tự chặn, không nhờ service)", () => {
    const stopRow = (routeId: string, extra: Record<string, unknown>) => ({
      id: randomUUID(),
      operatorId: tenantA,
      routeId,
      sequence: 2,
      role: "DESTINATION" as const,
      allowPickup: false,
      allowDropoff: true,
      latitude: 10,
      longitude: 106,
      distanceMetersFromPrevious: 1,
      durationSecondsFromPrevious: 1,
      ...extra,
    });

    it.each([
      ["không có nguồn", { catalogStopPointId: null, stopPointId: null }, /route_stops_single_source|23514/],
      ["hai nguồn", { catalogStopPointId: "__catalog__", stopPointId: "__private__" }, /route_stops_single_source|23514/],
      [
        "điểm đầu có số liệu chặng",
        { sequence: 1, role: "ORIGIN", allowPickup: true, allowDropoff: false, catalogStopPointId: "__catalog2__" },
        /route_stops_sequence_consistent/,
      ],
      ["điểm riêng của tenant khác", { stopPointId: "__privateB__" }, /route_stops_stop_point_id_operator_id_fkey|23503|Foreign key/i],
      // BR-79: điểm cuối chỉ trả, điểm đầu chỉ đón — DB tự chặn dù service có bug.
      ["điểm cuối cho đón", { catalogStopPointId: "__catalog2__", allowPickup: true }, /route_stops_pickup_dropoff_by_role/],
      ["điểm cuối không cho trả", { catalogStopPointId: "__catalog2__", allowDropoff: false }, /route_stops_pickup_dropoff_by_role/],
    ])("route_stops: %s → DB từ chối", async (_case, extra, message) => {
      const route = await routes.create(authzA, routeInput(`INV ${randomUUID().slice(0, 6)}`, [catalogStop(catalog1), catalogStop(catalog2)]));
      const ownA = await stopPoints.create(authzA, stopPointInput());
      const ownB = await stopPoints.create(authzB, stopPointInput());
      const resolved = Object.fromEntries(
        Object.entries(extra).map(([key, value]) => [
          key,
          { __catalog__: catalog1, __catalog2__: catalogInactive, __private__: ownA.id, __privateB__: ownB.id }[value as string] ?? value,
        ]),
      );
      const failure = await rejectionOf(
        prisma.withSystem((tx) => tx.routeStop.create({ data: { ...stopRow(route.id, {}), sequence: 3, ...resolved } })),
      );
      expect(failure.text).toMatch(message);
    });

    it("đề xuất: CHECK trạng thái — REJECTED thiếu/rỗng lý do, APPROVED thiếu điểm catalog bị chặn cả với Admin", async () => {
      const created = await proposals.create(authzA, proposalInput());
      for (const data of [
        { status: "REJECTED" as const },
        { status: "REJECTED" as const, rejectionReason: "   " },
        { status: "APPROVED" as const },
      ]) {
        const failure = await rejectionOf(prisma.withPlatform((tx) => tx.stopPointProposal.update({ where: { id: created.id }, data })));
        expect(failure.text).toMatch(/stop_point_proposals_state_consistent|23514/);
      }
    });

    it.each(["BUS_STATION", "PICKUP_POINT"] as const)(
      "điểm riêng loại %s → CHECK chặn cả đường ghi bỏ qua service (BR-38, TC-TRN-015)",
      async (type) => {
        const failure = await rejectionOf(
          prisma.withSystem((tx) => tx.stopPoint.create({ data: { ...stopPointInput(), operatorId: tenantA, type } })),
        );
        expect(failure.text).toMatch(/stop_points_private_type/);
      },
    );

    it("điểm riêng: SUSPENDED phải có lý do, không khóa thì không được có lý do", async () => {
      const own = await stopPoints.create(authzA, stopPointInput());
      for (const data of [
        { status: "SUSPENDED" as const },
        { status: "SUSPENDED" as const, suspensionReason: "   " },
        { status: "ACTIVE" as const, suspensionReason: "lý do thừa" },
      ]) {
        const failure = await rejectionOf(prisma.withPlatform((tx) => tx.stopPoint.update({ where: { id: own.id }, data })));
        expect(failure.text).toMatch(/stop_points_suspension_consistent/);
      }
    });

    it("đề xuất: loại văn phòng / trạm nghỉ hoặc căn cứ công bố rỗng → CHECK chặn cả với scope system", async () => {
      for (const data of [{ type: "OFFICE" as const }, { type: "REST_STOP" as const }]) {
        const failure = await rejectionOf(
          prisma.withSystem((tx) => tx.stopPointProposal.create({ data: { ...proposalInput(), operatorId: tenantA, ...data } })),
        );
        expect(failure.text).toMatch(/stop_point_proposals_shared_type/);
      }
      const blank = await rejectionOf(
        prisma.withSystem((tx) =>
          tx.stopPointProposal.create({ data: { ...proposalInput(), operatorId: tenantA, legalBasis: "  " } }),
        ),
      );
      expect(blank.text).toMatch(/stop_point_proposals_legal_basis_present/);
    });

    it("điểm riêng: phường không thuộc tỉnh → FK ghép chặn", async () => {
      const failure = await rejectionOf(
        prisma.withSystem((tx) =>
          tx.stopPoint.create({ data: { ...stopPointInput(), operatorId: tenantA, wardId: wardOther } }),
        ),
      );
      expect(failure.text).toMatch(/stop_points_ward_id_province_id_fkey|23503|Foreign key/i);
    });
  });

  describe("StopPointService + StopPointProposalService", () => {
    it("CRUD điểm riêng; trùng tên 409; tenant khác 404; tỉnh/phường không hợp lệ 422", async () => {
      const created = await stopPoints.create(authzA, stopPointInput({ name: `VP ${tag}` }));
      expect(await stopPoints.get(authzA, created.id)).toEqual(created);
      const updated = await stopPoints.update(authzA, created.id, stopPointInput({ name: `VP ${tag}`, status: "INACTIVE" }));
      expect(updated.status).toBe("INACTIVE");
      expect((await rejectionOf(stopPoints.create(authzA, stopPointInput({ name: `VP ${tag}` })))).code).toBe("STOP_POINT_NAME_CONFLICT");
      expect((await stopPoints.create(authzB, stopPointInput({ name: `VP ${tag}` }))).name).toBe(`VP ${tag}`);
      expect((await rejectionOf(stopPoints.get(authzB, created.id))).code).toBe("STOP_POINT_NOT_FOUND");
      expect((await rejectionOf(stopPoints.update(authzB, created.id, stopPointInput()))).code).toBe("STOP_POINT_NOT_FOUND");
      for (const bad of [{ wardId: wardInactive }, { wardId: wardOther }, { wardId: randomUUID() }]) {
        expect(await rejectionOf(stopPoints.create(authzA, stopPointInput(bad)))).toMatchObject({
          code: "CATALOG_ITEM_UNAVAILABLE",
          status: 422,
        });
      }
    });

    it.each(["BUS_STATION", "PICKUP_POINT"])(
      "điểm riêng loại %s → 422 STOP_POINT_TYPE_NOT_ALLOWED khi tạo và khi sửa (BR-38, TC-TRN-015)",
      async (type) => {
        expect(await rejectionOf(stopPoints.create(authzA, stopPointInput({ type })))).toMatchObject({
          code: "STOP_POINT_TYPE_NOT_ALLOWED",
          status: 422,
        });
        const office = await stopPoints.create(authzA, stopPointInput());
        expect((await rejectionOf(stopPoints.update(authzA, office.id, stopPointInput({ name: office.name, type })))).code).toBe(
          "STOP_POINT_TYPE_NOT_ALLOWED",
        );
        expect((await stopPoints.get(authzA, office.id)).type).toBe("OFFICE");
      },
    );

    it("nhà xe chỉ đặt được ACTIVE / INACTIVE; body gửi SUSPENDED hoặc lý do khóa bị từ chối / bỏ qua ở biên", () => {
      expect(StopPointInputSchema.safeParse({ ...location(), status: "SUSPENDED" }).success).toBe(false);
      expect(StopPointInputSchema.parse({ ...location(), status: "ACTIVE", suspensionReason: "x" })).not.toHaveProperty(
        "suspensionReason",
      );
    });

    it("điểm bị Admin khóa (BR-81, TC-TRN-018): sửa / tự mở lại → 409; không gắn mới vào route; route cũ vẫn giữ", async () => {
      const own = await stopPoints.create(authzA, stopPointInput({ latitude: 11.4, longitude: 107.6 }));
      const stops = [catalogStop(catalog1), privateStop(own.id), catalogStop(catalog2)];
      const route = await routes.create(authzA, routeInput(`Khóa ${tag}`, stops));
      await prisma.withPlatform((tx) =>
        tx.stopPoint.update({ where: { id: own.id }, data: { status: "SUSPENDED", suspensionReason: "Vị trí sai lệch" } }),
      );

      for (const status of ["ACTIVE", "INACTIVE"]) {
        expect(await rejectionOf(stopPoints.update(authzA, own.id, stopPointInput({ name: own.name, status })))).toMatchObject({
          code: "STOP_POINT_SUSPENDED",
          status: 409,
        });
      }
      expect(await stopPoints.get(authzA, own.id)).toMatchObject({
        status: "SUSPENDED",
        suspensionReason: "Vị trí sai lệch",
        routeCount: 1,
      });
      expect((await stopPoints.list(authzA, { status: "SUSPENDED", limit: 100 })).items.map((item) => item.id)).toContain(own.id);

      // Gắn MỚI vào route khác → 422; route đã có điểm này vẫn đổi tên được (mẫu "điểm đã ngừng").
      expect(
        (await rejectionOf(routes.create(authzA, routeInput(`Khóa mới ${tag}`, [catalogStop(catalog1), privateStop(own.id)])))).code,
      ).toBe("STOP_POINT_UNAVAILABLE");
      expect((await routes.update(authzA, route.id, routeInput(`Khóa đổi tên ${tag}`, stops))).name).toBe(`Khóa đổi tên ${tag}`);
    });

    it("list điểm riêng: lọc loại / tỉnh, tìm KHÔNG DẤU theo tên hoặc địa chỉ, kèm số route đang dùng; không lộ điểm tenant khác", async () => {
      const office = await stopPoints.create(
        authzA,
        stopPointInput({ name: `Văn phòng Đà Lạt ${tag}`, address: "12 Trần Phú, Phường Xuân Hương" }),
      );
      const rest = await stopPoints.create(
        authzA,
        stopPointInput({ name: `Trạm nghỉ Bảo Lộc ${tag}`, type: "REST_STOP", address: "Quốc lộ 20, Đèo Bảo Lộc" }),
      );
      await stopPoints.create(authzB, stopPointInput({ name: `Văn phòng Đà Lạt ${tag}` }));
      await routes.create(
        authzA,
        routeInput(`Đếm route 1 ${tag}`, [catalogStop(catalog1), privateStop(rest.id, { allowPickup: false, allowDropoff: false }), privateStop(office.id)]),
      );
      await routes.create(authzA, routeInput(`Đếm route 2 ${tag}`, [privateStop(office.id), catalogStop(catalog2)]));

      const ids = async (query: Record<string, unknown>) =>
        (await stopPoints.list(authzA, { limit: 100, ...query } as never)).items.map((item) => item.id);
      // Gõ không dấu, khác hoa/thường, khớp tên hoặc địa chỉ.
      expect(await ids({ q: `van phong da lat ${tag}` })).toEqual([office.id]);
      expect(await ids({ q: "DEO BAO LOC" })).toEqual([rest.id]);
      expect(await ids({ q: `Trạm nghỉ Bảo Lộc ${tag}` })).toEqual([rest.id]);
      expect(await ids({ q: `khong-co-diem-nao-${tag}` })).toEqual([]);
      // Ký tự đại diện của LIKE trong từ khoá chỉ là chữ thường, không khớp mọi dòng.
      expect(await ids({ q: "%" })).toEqual([]);
      expect(await ids({ q: `van_phong da lat ${tag}` })).toEqual([]);
      // Ký hiệu in ấn (gạch ngang dài, ngoặc cong) database đổi sang ASCII: dán nguyên tên hay gõ tay đều ra.
      const dashed = await stopPoints.create(authzA, stopPointInput({ name: `Trạm “Madagui” – QL20 ${tag}`, type: "REST_STOP" }));
      expect(await ids({ q: `Trạm “Madagui” – QL20 ${tag}` })).toEqual([dashed.id]);
      expect(await ids({ q: `tram "madagui" - ql20 ${tag}` })).toEqual([dashed.id]);
      expect((await ids({ type: "REST_STOP", q: tag })).sort()).toEqual([rest.id, dashed.id].sort());
      expect(await ids({ type: "OFFICE", q: `bao loc ${tag}` })).toEqual([]);
      expect(await ids({ provinceId: provinceOther })).toEqual([]);
      expect((await ids({ provinceId: province })).sort()).toEqual(expect.arrayContaining([office.id, rest.id]));

      const listed = (await stopPoints.list(authzA, { q: tag, limit: 100 })).items;
      expect(listed.find((item) => item.id === office.id)?.routeCount).toBe(2);
      expect(listed.find((item) => item.id === rest.id)?.routeCount).toBe(1);
      expect((await stopPoints.create(authzA, stopPointInput())).routeCount).toBe(0);
    });

    it("đề xuất (BR-38, TC-TRN-015): chỉ bến xe / điểm dừng đón trả, bắt buộc căn cứ công bố; response trả lại căn cứ", async () => {
      for (const bad of [{ type: "OFFICE" }, { type: "REST_STOP" }, { legalBasis: "" }, { legalBasis: "   " }, { legalBasis: "x".repeat(301) }]) {
        expect(
          StopPointProposalInputSchema.safeParse({ ...location({ type: "BUS_STATION" }), legalBasis: "QĐ 1", ...bad }).success,
          JSON.stringify(bad),
        ).toBe(false);
      }
      const { legalBasis: _omitted, ...missing } = proposalInput();
      expect(StopPointProposalInputSchema.safeParse(missing).success).toBe(false);

      const created = await proposals.create(authzA, proposalInput({ type: "PICKUP_POINT", legalBasis: "  QĐ 77/QĐ-UBND  " }));
      expect(created).toMatchObject({ type: "PICKUP_POINT", legalBasis: "QĐ 77/QĐ-UBND", status: "PENDING" });
    });

    it("phường của điểm bị vô hiệu hoá sau đó: vẫn sửa tên/tạm ngưng được; đổi SANG phường ngừng thì 422", async () => {
      const lateWard = randomUUID();
      await prisma.withSystem((tx) => tx.ward.create({ data: { id: lateWard, provinceId: province, code: `rl-${tag}`, name: "Phường sắp ngừng" } }));
      const created = await stopPoints.create(authzA, stopPointInput({ wardId: lateWard }));
      await prisma.withSystem((tx) => tx.ward.update({ where: { id: lateWard }, data: { status: "INACTIVE" } }));
      const kept = await stopPoints.update(authzA, created.id, stopPointInput({ wardId: lateWard, name: `Đổi tên ${tag}`, status: "INACTIVE" }));
      expect(kept).toMatchObject({ wardId: lateWard, status: "INACTIVE" });
      expect((await rejectionOf(stopPoints.update(authzA, created.id, stopPointInput({ wardId: wardInactive })))).code).toBe(
        "CATALOG_ITEM_UNAVAILABLE",
      );
    });

    it("đề xuất: tạo PENDING; gửi lại bản PENDING → 409; tenant khác → 404; list lọc trạng thái", async () => {
      const created = await proposals.create(authzA, proposalInput());
      expect(created).toMatchObject({ status: "PENDING", rejectionReason: null, catalogStopPointId: null });
      expect((await rejectionOf(proposals.resubmit(authzA, created.id, proposalInput()))).code).toBe(
        "STOP_POINT_PROPOSAL_STATE_INVALID",
      );
      expect((await rejectionOf(proposals.resubmit(authzB, created.id, proposalInput()))).code).toBe(
        "STOP_POINT_PROPOSAL_NOT_FOUND",
      );
      const pending = await proposals.list(authzA, { status: "PENDING", limit: 100 });
      expect(pending.items.map((item) => item.id)).toContain(created.id);
      expect((await proposals.list(authzB, { limit: 100 })).items.map((item) => item.id)).not.toContain(created.id);
    });
  });

  describe("RouteService", () => {
    it("tạo route: vai trò theo vị trí, số liệu từng chặng + tổng, nguồn GOONG; gọi provider 1 lần, GET không gọi", async () => {
      const own = await stopPoints.create(authzA, stopPointInput({ latitude: 11.2, longitude: 107.1 }));
      const created = await routes.create(
        authzA,
        routeInput(`SG-ĐL ${tag}`, [catalogStop(catalog1), privateStop(own.id), catalogStop(catalog2)]),
      );
      expect(routing.calls).toBe(1);
      expect(created).toMatchObject({ totalDistanceMeters: 3000, totalDurationSeconds: 180, metricsSource: "GOONG" });
      expect(created.stops.map((stop) => [stop.sequence, stop.role, stop.distanceMetersFromPrevious])).toEqual([
        [1, "ORIGIN", null],
        [2, "INTERMEDIATE", 1000],
        [3, "DESTINATION", 2000],
      ]);
      expect(created.stops[1]).toMatchObject({ stopPointId: own.id, name: own.name, latitude: 11.2 });
      await routes.get(authzA, created.id);
      await routes.list(authzA, { limit: 100 });
      expect(routing.calls).toBe(1);
    });

    it("cho đón / cho trả (BR-79, TC-TRN-016): lưu đúng từng điểm, trả kèm loại điểm; đổi cờ không gọi lại provider", async () => {
      const office = await stopPoints.create(authzA, stopPointInput({ latitude: 11.2, longitude: 107.1 }));
      const rest = await stopPoints.create(authzA, stopPointInput({ type: "REST_STOP", latitude: 11.5, longitude: 107.8 }));
      const stops = (officeFlags: StopFlags) => [
        catalogStop(catalog1),
        privateStop(office.id, officeFlags),
        privateStop(rest.id, { allowPickup: false, allowDropoff: false }),
        catalogStop(catalog2),
      ];
      const created = await routes.create(authzA, routeInput(`Cờ ${tag}`, stops({ allowPickup: true, allowDropoff: false })));
      expect(created.stops.map((stop) => [stop.type, stop.allowPickup, stop.allowDropoff])).toEqual([
        ["BUS_STATION", true, false],
        ["OFFICE", true, false],
        ["REST_STOP", false, false],
        ["BUS_STATION", false, true],
      ]);
      expect(await routes.get(authzA, created.id)).toEqual(created);

      routing.calls = 0;
      const toggled = await routes.update(authzA, created.id, routeInput(`Cờ ${tag}`, stops({ allowPickup: false, allowDropoff: true })));
      expect(toggled.stops[1]).toMatchObject({ allowPickup: false, allowDropoff: true });
      expect(routing.calls).toBe(0);
    });

    it("cho đón / cho trả sai quy tắc → 422 ROUTE_STOP_PICKUP_DROPOFF_INVALID, không gọi provider, không lưu gì", async () => {
      const office = await stopPoints.create(authzA, stopPointInput());
      const rest = await stopPoints.create(authzA, stopPointInput({ type: "REST_STOP" }));
      const no = { allowPickup: false, allowDropoff: false };
      const invalid: [string, object[]][] = [
        ["điểm đầu cho trả", [catalogStop(catalog1, { allowDropoff: true }), catalogStop(catalog2)]],
        ["điểm đầu không cho đón", [catalogStop(catalog1, { allowPickup: false }), catalogStop(catalog2)]],
        ["điểm cuối cho đón", [catalogStop(catalog1), catalogStop(catalog2, { allowPickup: true })]],
        ["điểm cuối không cho trả", [catalogStop(catalog1), catalogStop(catalog2, { allowDropoff: false })]],
        ["điểm giữa tắt cả hai quyền", [catalogStop(catalog1), privateStop(office.id, no), catalogStop(catalog2)]],
        ["trạm dừng nghỉ cho đón", [catalogStop(catalog1), privateStop(rest.id, { ...no, allowPickup: true }), catalogStop(catalog2)]],
        ["trạm dừng nghỉ cho trả", [catalogStop(catalog1), privateStop(rest.id, { ...no, allowDropoff: true }), catalogStop(catalog2)]],
        ["trạm dừng nghỉ đứng đầu", [privateStop(rest.id), catalogStop(catalog2)]],
        ["trạm dừng nghỉ đứng cuối", [catalogStop(catalog1), privateStop(rest.id)]],
        ["trạm dừng nghỉ đứng đầu, tắt cả hai quyền", [privateStop(rest.id, no), catalogStop(catalog2)]],
      ];
      for (const [label, stops] of invalid) {
        const failure = await rejectionOf(routes.create(authzA, routeInput(`Sai cờ ${randomUUID().slice(0, 6)}`, stops)));
        expect(failure, label).toMatchObject({ code: "ROUTE_STOP_PICKUP_DROPOFF_INVALID", status: 422 });
      }
      expect(routing.calls).toBe(0);
      expect(
        await prisma.withTenant(tenantA, (tx) => tx.route.count({ where: { operatorId: tenantA, name: { startsWith: "Sai cờ" } } })),
      ).toBe(0);
      // Hai đầu không phải bến xe KHÔNG bị chặn ở v1 (OQ-24): văn phòng trung chuyển vẫn là điểm đầu hợp lệ.
      const fromOffice = await routes.create(authzA, routeInput(`VP đầu ${tag}`, [privateStop(office.id), catalogStop(catalog2)]));
      expect(fromOffice.stops[0]).toMatchObject({ type: "OFFICE", allowPickup: true, allowDropoff: false });
    });

    it("PUT: đổi tên/ghi chú không gọi provider; đổi thứ tự gọi lại; điểm riêng đổi toạ độ → tính lại", async () => {
      const own = await stopPoints.create(authzA, stopPointInput({ latitude: 11.2, longitude: 107.1 }));
      const stops = [catalogStop(catalog1), privateStop(own.id), catalogStop(catalog2)];
      const created = await routes.create(authzA, routeInput(`PUT ${tag}`, stops));
      routing.calls = 0;

      const renamed = await routes.update(authzA, created.id, routeInput(`PUT2 ${tag}`, stops, { note: "Ghi chú", status: "INACTIVE" }));
      expect(routing.calls).toBe(0);
      expect(renamed).toMatchObject({ name: `PUT2 ${tag}`, note: "Ghi chú", status: "INACTIVE", totalDistanceMeters: 3000 });

      await routes.update(authzA, created.id, routeInput(`PUT2 ${tag}`, [stops[0]!, stops[2]!, stops[1]!]));
      expect(routing.calls).toBe(1);

      await stopPoints.update(authzA, own.id, stopPointInput({ name: own.name, latitude: 11.3, longitude: 107.2 }));
      const recomputed = await routes.update(authzA, created.id, routeInput(`PUT2 ${tag}`, [stops[0]!, stops[2]!, stops[1]!]));
      expect(routing.calls).toBe(2);
      expect(recomputed.stops[2]).toMatchObject({ latitude: 11.3, longitude: 107.2 });
    });

    it("số liệu ước lượng (dev) được tính lại khi đã có Goong, kể cả không đổi toạ độ", async () => {
      routing.source = "ESTIMATE";
      const stops = [catalogStop(catalog1), catalogStop(catalog2)];
      const created = await routes.create(authzA, routeInput(`EST ${tag}`, stops));
      expect(created.metricsSource).toBe("ESTIMATE");
      routing.source = "GOONG";
      const upgraded = await routes.update(authzA, created.id, routeInput(`EST ${tag}`, stops));
      expect(upgraded.metricsSource).toBe("GOONG");
      expect(routing.calls).toBe(2);
    });

    it("provider lỗi hoặc trả sai số chặng → 503; không tạo route, route cũ giữ nguyên", async () => {
      const stops = [catalogStop(catalog1), catalogStop(catalog2)];
      routing.fail = true;
      expect(await rejectionOf(routes.create(authzA, routeInput(`FAIL ${tag}`, stops)))).toMatchObject({
        code: "ROUTING_PROVIDER_UNAVAILABLE",
        status: 503,
      });
      expect(await prisma.withTenant(tenantA, (tx) => tx.route.count({ where: { operatorId: tenantA, name: `FAIL ${tag}` } }))).toBe(0);

      routing.fail = false;
      const created = await routes.create(authzA, routeInput(`KEEP ${tag}`, stops));
      routing.legsOverride = [];
      expect((await rejectionOf(routes.update(authzA, created.id, routeInput(`KEEP ${tag}`, [...stops].reverse())))).code).toBe(
        "ROUTING_PROVIDER_UNAVAILABLE",
      );
      routing.legsOverride = [{ distanceMeters: -5, durationSeconds: 10 }];
      expect((await rejectionOf(routes.update(authzA, created.id, routeInput(`KEEP ${tag}`, [...stops].reverse())))).code).toBe(
        "ROUTING_PROVIDER_UNAVAILABLE",
      );
      expect((await routes.get(authzA, created.id)).stops.map((stop) => stop.catalogStopPointId)).toEqual([catalog1, catalog2]);
    });

    it("điểm không dùng được → 422 STOP_POINT_UNAVAILABLE, không gọi provider", async () => {
      const ownInactive = await stopPoints.create(authzA, stopPointInput({ status: "INACTIVE" }));
      const ownB = await stopPoints.create(authzB, stopPointInput());
      for (const bad of [
        catalogStop(catalogInactive),
        catalogStop(catalogInInactiveWard),
        catalogStop(randomUUID()),
        privateStop(ownInactive.id),
        privateStop(ownB.id),
      ]) {
        const failure = await rejectionOf(routes.create(authzA, routeInput(`BAD ${randomUUID().slice(0, 6)}`, [catalogStop(catalog1), bad])));
        expect(failure).toMatchObject({ code: "STOP_POINT_UNAVAILABLE", status: 422 });
      }
      expect(routing.calls).toBe(0);
    });

    it("điểm đã có trong route bị vô hiệu hoá sau đó: vẫn đổi tên/tạm ngưng route được; thêm MỚI điểm ngừng thì 422", async () => {
      const lateCatalog = randomUUID();
      await prisma.withSystem((tx) =>
        tx.stopPointCatalog.create({
          data: { id: lateCatalog, name: `Bến sắp ngừng ${tag}`, type: "BUS_STATION", address: "x", provinceId: province, wardId: ward, latitude: 12, longitude: 107 },
        }),
      );
      const own = await stopPoints.create(authzA, stopPointInput({ latitude: 11.1, longitude: 107.3 }));
      const stops = [catalogStop(catalog1), catalogStop(lateCatalog), privateStop(own.id)];
      const created = await routes.create(authzA, routeInput(`KEEP-OLD ${tag}`, stops));
      await prisma.withSystem((tx) => tx.stopPointCatalog.update({ where: { id: lateCatalog }, data: { status: "INACTIVE" } }));
      await stopPoints.update(authzA, own.id, stopPointInput({ name: own.name, latitude: 11.1, longitude: 107.3, status: "INACTIVE" }));
      routing.calls = 0;

      const paused = await routes.update(authzA, created.id, routeInput(`KEEP-OLD ${tag}`, stops, { status: "INACTIVE" }));
      expect(paused.status).toBe("INACTIVE");
      expect(routing.calls).toBe(0);
      expect((await rejectionOf(routes.update(authzA, created.id, routeInput(`KEEP-OLD ${tag}`, [...stops, catalogStop(catalogInactive)])))).code).toBe(
        "STOP_POINT_UNAVAILABLE",
      );
    });

    it("trùng tên bị chặn TRƯỚC khi gọi provider (không tốn quota); giá trị chặng phi lý → 503", async () => {
      const stops = [catalogStop(catalog1), catalogStop(catalog2)];
      await routes.create(authzA, routeInput(`QUOTA ${tag}`, stops));
      routing.calls = 0;
      expect((await rejectionOf(routes.create(authzA, routeInput(`QUOTA ${tag}`, stops)))).code).toBe("ROUTE_NAME_CONFLICT");
      expect(routing.calls).toBe(0);
      routing.legsOverride = [{ distanceMeters: 5_000_001, durationSeconds: 60 }];
      expect((await rejectionOf(routes.create(authzA, routeInput(`HUGE ${tag}`, stops)))).code).toBe("ROUTING_PROVIDER_UNAVAILABLE");
    });

    it("trùng tên trong tenant → 409, tenant khác được; tenant khác GET/PUT → 404", async () => {
      const stops = [catalogStop(catalog1), catalogStop(catalog2)];
      const created = await routes.create(authzA, routeInput(`NAME ${tag}`, stops));
      expect((await rejectionOf(routes.create(authzA, routeInput(`NAME ${tag}`, stops)))).code).toBe("ROUTE_NAME_CONFLICT");
      expect((await routes.create(authzB, routeInput(`NAME ${tag}`, stops))).name).toBe(`NAME ${tag}`);
      expect((await rejectionOf(routes.get(authzB, created.id))).code).toBe("ROUTE_NOT_FOUND");
      expect((await rejectionOf(routes.update(authzB, created.id, routeInput(`X ${tag}`, stops)))).code).toBe("ROUTE_NOT_FOUND");
    });

    it("hai PUT đồng thời: bản sau thắng trọn vẹn, không trộn điểm dừng", async () => {
      const own = await stopPoints.create(authzA, stopPointInput({ latitude: 11.5, longitude: 107.5 }));
      const created = await routes.create(authzA, routeInput(`RACE ${tag}`, [catalogStop(catalog1), catalogStop(catalog2)]));
      const variants = [
        [catalogStop(catalog1), privateStop(own.id), catalogStop(catalog2)],
        [catalogStop(catalog2), catalogStop(catalog1)],
      ];
      await Promise.all(variants.map((stops) => routes.update(authzA, created.id, routeInput(`RACE ${tag}`, stops))));
      const final = (await routes.get(authzA, created.id)).stops.map((stop) => stop.catalogStopPointId ?? stop.stopPointId);
      expect([
        [catalog1, own.id, catalog2],
        [catalog2, catalog1],
      ]).toContainEqual(final);
    });

    it("list: lọc trạng thái, cursor đi hết không lặp/sót, kèm số điểm", async () => {
      for (const index of [1, 2, 3]) {
        await routes.create(authzB, routeInput(`LIST ${index} ${tag}`, [catalogStop(catalog1), catalogStop(catalog2)], { status: "INACTIVE" }));
      }
      const seen: string[] = [];
      let cursor: string | undefined;
      do {
        const page = await routes.list(authzB, { status: "INACTIVE", cursor, limit: 2 });
        expect(page.items.every((item) => item.status === "INACTIVE" && item.stopCount === 2)).toBe(true);
        seen.push(...page.items.map((item) => item.id));
        cursor = page.nextCursor ?? undefined;
      } while (cursor);
      expect(new Set(seen).size).toBe(seen.length);
      expect(seen.length).toBe(3);
    });

    it("list trả tên điểm đầu / điểm cuối theo thứ tự hiện tại, cả điểm dùng chung lẫn điểm riêng (TRN-013)", async () => {
      const office = await stopPoints.create(authzB, stopPointInput({ name: `Văn phòng đầu tuyến ${tag}` }));
      const rest = await stopPoints.create(authzB, stopPointInput({ name: `Trạm giữa tuyến ${tag}`, type: "REST_STOP" }));
      const created = await routes.create(
        authzB,
        routeInput(`ENDS ${tag}`, [
          privateStop(office.id),
          privateStop(rest.id, { allowPickup: false, allowDropoff: false }),
          catalogStop(catalog1),
          catalogStop(catalog2),
        ]),
      );
      const find = async () => (await routes.list(authzB, { limit: 100 })).items.find((item) => item.id === created.id)!;
      expect(await find()).toMatchObject({
        stopCount: 4,
        originName: `Văn phòng đầu tuyến ${tag}`,
        destinationName: `Bến 2 ${tag}`,
      });

      // Đảo hai đầu: tên theo vị trí mới, không theo thứ tự cũ.
      await routes.update(authzB, created.id, routeInput(`ENDS ${tag}`, [catalogStop(catalog2), privateStop(office.id)]));
      expect(await find()).toMatchObject({
        stopCount: 2,
        originName: `Bến 2 ${tag}`,
        destinationName: `Văn phòng đầu tuyến ${tag}`,
      });
      // Tenant khác không thấy route này trong danh sách của mình.
      expect((await routes.list(authzA, { limit: 100 })).items.some((item) => item.id === created.id)).toBe(false);
    });
  });
});
