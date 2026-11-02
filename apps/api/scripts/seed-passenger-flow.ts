import { randomUUID } from "node:crypto";
import { mkdir, writeFile } from "node:fs/promises";
import { resolve } from "node:path";
import { parseAppConfig } from "../src/config/env.config";
import { tenantScope } from "../src/database/db-scope";
import { PrismaService } from "../src/database/prisma.service";
import type { RoutingProvider } from "../src/external/routing/routing-provider";
import { CredentialService } from "../src/iam/auth/credential.service";
import type { Authorization } from "../src/iam/role/authorization";
import { RouteInputSchema } from "../src/route/dto/route.dto";
import { RouteService } from "../src/route/route.service";
import { TripInputSchema } from "../src/trip/dto/trip.dto";
import { TripService } from "../src/trip/trip.service";
import { SeatMapInputSchema } from "../src/vehicle/dto/seat-map.dto";
import { VehicleInputSchema } from "../src/vehicle/dto/vehicle.dto";
import { SeatMapService } from "../src/vehicle/seat-map.service";
import { VehicleService } from "../src/vehicle/vehicle.service";

/** Dựng chuyến ngày mai và tài khoản tài xế riêng cho kiểm thử Android trên DB local. */
async function main() {
  const url = process.env.DATABASE_URL;
  if (process.env.NODE_ENV !== "test" || !url || !["localhost", "127.0.0.1"].includes(new URL(url).hostname)) {
    throw new Error("Chỉ seed luồng hành khách với NODE_ENV=test và DB local.");
  }
  const prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
  const tag = randomUUID().slice(0, 8);
  const operatorId = randomUUID();
  const employeeId = randomUUID();
  const operatorSlug = `flow-${tag}`;
  const password = `Flow!${randomUUID()}`;
  const passwordHash = await new CredentialService().hash(password);
  const authz: Authorization = { permission: "trip:manage", scope: "tenant", db: tenantScope(operatorId) };
  try {
    const { typeId, points } = await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug, displayName: `Nhà xe E2E ${tag}`, status: "ACTIVE" } });
      await tx.employeeAccount.create({ data: { id: employeeId, operatorId, username: "nv.driver", passwordHash, role: "DRIVER" } });
      const points: string[] = [];
      for (const [index, name] of ["Hồ Chí Minh", "Lâm Đồng"].entries()) {
        const province = await tx.province.findFirst({ where: { name } })
          ?? await tx.province.create({ data: { code: `flow-p-${tag}-${index}`, name } });
        const ward = await tx.ward.create({ data: { provinceId: province.id, code: `flow-w-${tag}-${index}`, name: `Phường E2E ${index}` } });
        const stop = await tx.stopPointCatalog.create({ data: {
          name: `Bến E2E ${name}`, type: "BUS_STATION", legalBasis: "Dữ liệu thử local", address: `Địa chỉ E2E ${name}`,
          provinceId: province.id, wardId: ward.id, latitude: 10 + index, longitude: 106,
        } });
        points.push(stop.id);
      }
      const type = await tx.vehicleType.create({ data: { code: `FLOW-${tag}`, name: "Giường E2E", form: "SLEEPER", class: "STANDARD" } });
      return { typeId: type.id, points };
    });
    const routing: RoutingProvider = { source: "GOONG", measureLegs: async (points) => points.slice(1).map(() => ({ distanceMeters: 200_000, durationSeconds: 6 * 3600 })) };
    const route = await new RouteService(prisma, routing).create(authz, RouteInputSchema.parse({
      name: `Hồ Chí Minh - Lâm Đồng E2E ${tag}`, status: "ACTIVE", note: null,
      stops: points.map((id, index) => ({ catalogStopPointId: id, stopPointId: null, note: null, allowPickup: index === 0, allowDropoff: index === 1 })),
    }));
    const map = await new SeatMapService(prisma).create(authz, SeatMapInputSchema.parse({
      name: `Sơ đồ E2E ${tag}`, layout: { decks: [{ deck: 1, rows: 4, columns: 2 }] },
      seats: Array.from({ length: 8 }, (_, i) => ({ code: `A${i + 1}`, deck: 1, row: Math.floor(i / 2) + 1, column: i % 2 + 1, type: "BED" })),
    }));
    const vehicle = await new VehicleService(prisma, {} as never).create(authz, VehicleInputSchema.parse({
      plateNumber: `51E${10000 + Math.floor(Math.random() * 89999)}`, vehicleTypeId: typeId, seatMapId: map.id, amenityIds: [], status: "ACTIVE", description: null,
    }));
    await prisma.withSystem(async (tx) => {
      const fare = await tx.fare.create({ data: { operatorId, routeId: route.id, status: "ACTIVE" } });
      await tx.fareRule.create({ data: { operatorId, fareId: fare.id, price: 300_000n } });
    });
    const tomorrow = new Date(Date.now() + 86_400_000 + 7 * 3_600_000).toISOString().slice(0, 10);
    const trip = await new TripService(prisma, {} as never).create(authz, TripInputSchema.parse({
      routeId: route.id, vehicleId: vehicle.id, departureAt: new Date(`${tomorrow}T10:00:00+07:00`).toISOString(), onlineSaleCutoffMinutes: 60, stopTimes: null, note: null,
    }));
    await prisma.withSystem(async (tx) => {
      await tx.trip.update({ where: { id: trip.id }, data: { status: "OPEN_FOR_SALE" } });
      await tx.employeeAssignment.create({ data: { operatorId, tripId: trip.id, employeeId, role: "DRIVER" } });
    });
    await mkdir(resolve(".cache"), { recursive: true });
    await writeFile(resolve(".cache/passenger-flow.json"), JSON.stringify({
      API_BASE_URL: "http://10.0.2.2:3100", E2E_DRIVER_IDENTIFIER: `${operatorSlug}/nv.driver`, E2E_DRIVER_PASSWORD: password, E2E_TRIP_ID: trip.id,
    }, null, 2));
    console.log("Đã tạo chuyến E2E ngày mai; cấu hình Android nằm ở apps/api/.cache/passenger-flow.json (không commit).");
  } finally {
    await prisma.$disconnect();
  }
}

void main();
