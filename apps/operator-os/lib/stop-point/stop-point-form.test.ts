import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import type { StopPoint, StopPointProposal } from "./stop-point-api";
import {
  describeSaveError,
  EMPTY_PROPOSAL_FORM,
  EMPTY_STOP_POINT_FORM,
  parseCoordinate,
  proposalFormSchema,
  stopPointFormSchema,
  toProposalFormValues,
  toProposalInput,
  toStopPointFormValues,
  toStopPointInput
} from "./stop-point-form";

const PROVINCE = "11111111-1111-4111-8111-111111111111";
const WARD = "22222222-2222-4222-8222-222222222222";
const location = {
  name: " Văn phòng Đà Lạt ",
  address: " 12 Trần Phú ",
  provinceId: PROVINCE,
  wardId: WARD,
  latitude: "11.9404",
  longitude: "108,4583",
  description: "  "
};
const validPoint = { ...location, type: "OFFICE", status: "ACTIVE" };
const validProposal = { ...location, type: "PICKUP_POINT", legalBasis: " QĐ 1234/QĐ-SXD " };

function messages(schema: typeof stopPointFormSchema | typeof proposalFormSchema, values: unknown): Record<string, string> {
  const result = schema.safeParse(values);
  return result.success
    ? {}
    : Object.fromEntries(result.error.issues.map((issue) => [issue.path.join("."), issue.message]));
}

describe("parseCoordinate", () => {
  it.each([
    ["10.75", 10.75],
    [" 106,66 ", 106.66],
    ["-12", -12],
    ["0", 0]
  ])("%j → %j", (text, expected) => {
    expect(parseCoordinate(text)).toBe(expected);
  });

  it.each(["", "abc", "10.", "1e3", "10.5.2", "10 5", "--1"])("%j không phải số", (text) => {
    expect(parseCoordinate(text)).toBeNull();
  });
});

describe("stopPointFormSchema — điểm riêng của nhà xe", () => {
  it("form hợp lệ không có lỗi; điểm mới mặc định 'Hoạt động'", () => {
    expect(messages(stopPointFormSchema, validPoint)).toEqual({});
    expect(EMPTY_STOP_POINT_FORM.status).toBe("ACTIVE");
  });

  it("bỏ trống mọi ô bắt buộc → mỗi ô một thông báo riêng", () => {
    expect(messages(stopPointFormSchema, EMPTY_STOP_POINT_FORM)).toEqual({
      name: "Nhập tên điểm dừng.",
      type: "Chọn loại điểm.",
      address: "Nhập địa chỉ.",
      provinceId: "Chọn tỉnh / thành.",
      wardId: "Chọn phường / xã.",
      latitude: "Nhập vĩ độ.",
      longitude: "Nhập kinh độ."
    });
  });

  it.each(["BUS_STATION", "PICKUP_POINT"])("loại %s không tạo riêng được (BR-38)", (type) => {
    expect(messages(stopPointFormSchema, { ...validPoint, type })).toEqual({ type: "Chọn loại điểm." });
  });

  it("nhà xe không tự đặt được trạng thái Bị khóa", () => {
    expect(stopPointFormSchema.safeParse({ ...validPoint, status: "SUSPENDED" }).success).toBe(false);
  });

  it.each([
    [{ latitude: "91" }, { latitude: "Vĩ độ là số từ -90 đến 90." }],
    [{ latitude: "abc" }, { latitude: "Vĩ độ là số từ -90 đến 90." }],
    [{ longitude: "-180.5" }, { longitude: "Kinh độ là số từ -180 đến 180." }],
    [{ name: "x".repeat(151) }, { name: "Tên tối đa 150 ký tự." }],
    [{ address: "x".repeat(301) }, { address: "Địa chỉ tối đa 300 ký tự." }],
    [{ description: "x".repeat(501) }, { description: "Ghi chú tối đa 500 ký tự." }]
  ])("%j → %j", (override, expected) => {
    expect(messages(stopPointFormSchema, { ...validPoint, ...override })).toEqual(expected);
  });
});

describe("proposalFormSchema — đề xuất điểm dừng", () => {
  it("form hợp lệ không có lỗi", () => {
    expect(messages(proposalFormSchema, validProposal)).toEqual({});
  });

  it("thiếu loại điểm và căn cứ công bố → báo tại hai ô đó", () => {
    expect(messages(proposalFormSchema, { ...EMPTY_PROPOSAL_FORM, ...location })).toEqual({
      type: "Chọn loại điểm.",
      legalBasis: "Nhập căn cứ công bố."
    });
  });

  it.each(["OFFICE", "REST_STOP"])("loại %s không đề xuất được (BR-38)", (type) => {
    expect(messages(proposalFormSchema, { ...validProposal, type })).toEqual({ type: "Chọn loại điểm." });
  });

  it("căn cứ công bố quá 300 ký tự bị từ chối", () => {
    expect(messages(proposalFormSchema, { ...validProposal, legalBasis: "x".repeat(301) })).toEqual({
      legalBasis: "Căn cứ công bố tối đa 300 ký tự."
    });
  });
});

describe("đổi giữa form và DTO", () => {
  it("điểm riêng: cắt khoảng trắng, đổi tọa độ thành số, ghi chú trống gửi null", () => {
    expect(toStopPointInput(stopPointFormSchema.parse(validPoint))).toEqual({
      name: "Văn phòng Đà Lạt",
      address: "12 Trần Phú",
      provinceId: PROVINCE,
      wardId: WARD,
      latitude: 11.9404,
      longitude: 108.4583,
      description: null,
      type: "OFFICE",
      status: "ACTIVE"
    });
  });

  it("đề xuất: gửi kèm căn cứ công bố, không gửi trạng thái", () => {
    const input = toProposalInput(proposalFormSchema.parse({ ...validProposal, description: "Trước cổng sân bay" }));
    expect(input).toMatchObject({ type: "PICKUP_POINT", legalBasis: "QĐ 1234/QĐ-SXD", description: "Trước cổng sân bay" });
    expect(input).not.toHaveProperty("status");
  });

  it("đưa dữ liệu đã lưu vào form: tọa độ thành chữ, ghi chú null thành rỗng", () => {
    const stored = {
      id: "33333333-3333-4333-8333-333333333333",
      name: "Trạm dừng nghỉ Madagui",
      type: "REST_STOP",
      address: "Quốc lộ 20",
      provinceId: PROVINCE,
      wardId: WARD,
      latitude: 11.38,
      longitude: 107.53,
      description: null,
      status: "INACTIVE",
      suspensionReason: null,
      routeCount: 2,
      createdAt: "2026-10-01T00:00:00.000Z",
      updatedAt: "2026-10-01T00:00:00.000Z"
    } satisfies StopPoint;
    const values = toStopPointFormValues(stored);
    expect(values).toMatchObject({ type: "REST_STOP", status: "INACTIVE", latitude: "11.38", longitude: "107.53", description: "" });
    expect(messages(stopPointFormSchema, values)).toEqual({});

    const proposal = {
      ...stored,
      type: "BUS_STATION",
      legalBasis: "QĐ 587",
      status: "REJECTED",
      rejectionReason: "Thiếu văn bản",
      catalogStopPointId: null
    } as unknown as StopPointProposal;
    expect(toProposalFormValues(proposal)).toMatchObject({ type: "BUS_STATION", legalBasis: "QĐ 587" });
  });
});

describe("describeSaveError", () => {
  it.each([
    ["STOP_POINT_NAME_CONFLICT", 409, "name"],
    ["STOP_POINT_TYPE_NOT_ALLOWED", 422, "type"],
    ["CATALOG_ITEM_UNAVAILABLE", 422, "wardId"],
    ["STOP_POINT_SUSPENDED", 409, null],
    ["STOP_POINT_NOT_FOUND", 404, null],
    ["STOP_POINT_PROPOSAL_STATE_INVALID", 409, null],
    ["STOP_POINT_PROPOSAL_NOT_FOUND", 404, null]
  ])("%s → ô %j, có thông báo riêng", (code, status, field) => {
    const described = describeSaveError(new ApiError(status, code, "x"), "stopPoint");
    expect(described.field).toBe(field);
    expect(described.message).not.toMatch(/kiểm tra kết nối/);
  });

  it("400 không rõ mã → nhắc kiểm tra các ô; lỗi mạng → thông báo theo loại thao tác", () => {
    expect(describeSaveError(new ApiError(400, "VALIDATION_FAILED", "x"), "stopPoint").message).toMatch(/chưa hợp lệ/);
    expect(describeSaveError(new TypeError("Failed to fetch"), "stopPoint").message).toMatch(/Chưa lưu được điểm dừng/);
    expect(describeSaveError(new TypeError("Failed to fetch"), "proposal").message).toMatch(/Chưa gửi được đề xuất/);
  });
});
