import { randomUUID } from "node:crypto";
import { describe, expect, it } from "vitest";
import { StopPointInputSchema, StopPointListQuerySchema, StopPointProposalInputSchema } from "../stop-point/dto/stop-point.dto";
import { MAX_ROUTE_STOPS, RouteInputSchema } from "./dto/route.dto";

const flags = { allowPickup: true, allowDropoff: true };
const catalogStop = (id = randomUUID()) => ({ catalogStopPointId: id, stopPointId: null, note: null, ...flags });
const privateStop = (id = randomUUID()) => ({ catalogStopPointId: null, stopPointId: id, note: " ", ...flags });

describe("RouteInputSchema (Q3)", () => {
  const base = { name: " Sài Gòn - Đà Lạt ", status: "ACTIVE", note: null, stops: [catalogStop(), privateStop()] };

  it("chấp nhận catalog + điểm riêng, trim tên, ghi chú rỗng → null", () => {
    const parsed = RouteInputSchema.parse(base);
    expect(parsed.name).toBe("Sài Gòn - Đà Lạt");
    expect(parsed.stops[1]!.note).toBeNull();
  });

  it("giữ hai cờ cho đón / cho trả của từng điểm; quy tắc theo vị trí và loại điểm để service kiểm (BR-79)", () => {
    const stops = [
      { ...catalogStop(), allowPickup: true, allowDropoff: false },
      { ...privateStop(), allowPickup: false, allowDropoff: true },
    ];
    expect(RouteInputSchema.parse({ ...base, stops }).stops.map((stop) => [stop.allowPickup, stop.allowDropoff])).toEqual([
      [true, false],
      [false, true],
    ]);
  });

  it.each([
    ["dưới 2 điểm", { stops: [catalogStop()] }],
    ["quá số điểm tối đa", { stops: Array.from({ length: MAX_ROUTE_STOPS + 1 }, () => catalogStop()) }],
    ["điểm không có nguồn", { stops: [catalogStop(), { catalogStopPointId: null, stopPointId: null, note: null, ...flags }] }],
    ["điểm hai nguồn", { stops: [catalogStop(), { catalogStopPointId: randomUUID(), stopPointId: randomUUID(), note: null, ...flags }] }],
    ["lặp điểm catalog (đầu = cuối)", (() => { const id = randomUUID(); return { stops: [catalogStop(id), privateStop(), catalogStop(id)] }; })()],
    ["lặp điểm riêng", (() => { const id = randomUUID(); return { stops: [privateStop(id), privateStop(id)] }; })()],
    ["trạng thái lạ", { status: "DRAFT" }],
    ["thiếu note (PUT thay toàn bộ)", { note: undefined }],
    ["client tự gửi role nhưng thiếu nguồn", { stops: [{ role: "ORIGIN", note: null, ...flags }, catalogStop()] }],
    // PUT thay toàn bộ: thiếu cờ là 400, không lặng lẽ coi như "cho cả hai".
    ["thiếu allowPickup", { stops: [catalogStop(), { catalogStopPointId: randomUUID(), stopPointId: null, note: null, allowDropoff: true }] }],
    ["thiếu allowDropoff", { stops: [catalogStop(), { catalogStopPointId: randomUUID(), stopPointId: null, note: null, allowPickup: true }] }],
    ["cờ không phải boolean", { stops: [catalogStop(), { ...catalogStop(), allowPickup: "true" }] }],
  ])("từ chối %s", (_case, override) => {
    expect(RouteInputSchema.safeParse({ ...base, ...override }).success).toBe(false);
  });
});

describe("StopPoint / Proposal input", () => {
  const location = {
    name: "Văn phòng Quận 5",
    type: "OFFICE",
    address: "1 Trần Hưng Đạo",
    provinceId: randomUUID(),
    wardId: randomUUID(),
    latitude: 10.75,
    longitude: 106.66,
    description: null,
  };
  const proposal = { ...location, type: "BUS_STATION", legalBasis: "QĐ 1234/QĐ-SGTVT" };

  it("điểm riêng bắt buộc status; đề xuất KHÔNG nhận status/catalogStopPointId từ client", () => {
    expect(StopPointInputSchema.safeParse(location).success).toBe(false);
    expect(StopPointInputSchema.parse({ ...location, status: "ACTIVE" }).status).toBe("ACTIVE");
    const parsed = StopPointProposalInputSchema.parse({
      ...proposal,
      status: "APPROVED",
      catalogStopPointId: randomUUID(),
      rejectionReason: "x",
    });
    expect(parsed).not.toHaveProperty("status");
    expect(parsed).not.toHaveProperty("catalogStopPointId");
    expect(parsed).not.toHaveProperty("rejectionReason");
  });

  it("điểm riêng: biên nhận đủ loại (service trả 422 có mã riêng), nhưng không cho nhà xe tự đặt SUSPENDED", () => {
    expect(StopPointInputSchema.safeParse({ ...location, type: "BUS_STATION", status: "ACTIVE" }).success).toBe(true);
    expect(StopPointInputSchema.safeParse({ ...location, status: "SUSPENDED" }).success).toBe(false);
    expect(StopPointInputSchema.safeParse({ ...location, status: "INACTIVE" }).success).toBe(true);
  });

  it.each([
    ["vĩ độ ngoài phạm vi", { latitude: 91 }],
    ["kinh độ ngoài phạm vi", { longitude: -181 }],
    ["loại điểm lạ", { type: "AIRPORT" }],
    ["tên rỗng", { name: "  " }],
    ["phường không phải uuid", { wardId: "x" }],
    // BR-38: chỉ bến xe / điểm dừng đón trả mới đề xuất được, và phải kèm căn cứ công bố.
    ["loại văn phòng", { type: "OFFICE" }],
    ["loại trạm dừng nghỉ", { type: "REST_STOP" }],
    ["thiếu căn cứ công bố", { legalBasis: undefined }],
    ["căn cứ công bố rỗng", { legalBasis: "   " }],
    ["căn cứ công bố quá 300 ký tự", { legalBasis: "x".repeat(301) }],
  ])("đề xuất: từ chối %s", (_case, override) => {
    expect(StopPointProposalInputSchema.safeParse({ ...proposal, ...override }).success).toBe(false);
  });

  it("đề xuất hợp lệ: cả hai loại dùng chung, căn cứ công bố được cắt khoảng trắng", () => {
    expect(StopPointProposalInputSchema.parse({ ...proposal, type: "PICKUP_POINT", legalBasis: "  QĐ 77  " })).toMatchObject({
      type: "PICKUP_POINT",
      legalBasis: "QĐ 77",
    });
  });
});

describe("StopPointListQuerySchema — lọc và tìm điểm riêng", () => {
  it("nhận lọc trạng thái (kể cả SUSPENDED), loại, tỉnh và từ khoá; `q` trống coi như không tìm", () => {
    const provinceId = randomUUID();
    expect(StopPointListQuerySchema.parse({ status: "SUSPENDED", type: "REST_STOP", provinceId, q: "  bến xe " })).toEqual({
      status: "SUSPENDED",
      type: "REST_STOP",
      provinceId,
      q: "bến xe",
      limit: 20,
    });
    expect(StopPointListQuerySchema.parse({ q: "   " })).toEqual({ q: undefined, limit: 20 });
    expect(StopPointListQuerySchema.parse({})).toEqual({ limit: 20 });
  });

  it.each([{ q: "x".repeat(101) }, { type: "AIRPORT" }, { provinceId: "x" }, { status: "DELETED" }])("từ chối %j", (query) => {
    expect(StopPointListQuerySchema.safeParse(query).success).toBe(false);
  });
});
