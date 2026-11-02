import { describe, expect, it } from "vitest";
import { z } from "zod";
import { JourneyDemoSnapshotSchema } from "./journey-demo";

describe("Journey demo schema version wire format", () => {
  it("chỉ chấp nhận số nguyên 1, không chấp nhận chuỗi do Dart enum chuyển đổi", () => {
    const version = JourneyDemoSnapshotSchema.shape.schemaVersion;
    expect(version.parse(1)).toBe(1);
    for (const value of ["1", 0, 2, 1.5, null]) expect(version.safeParse(value).success).toBe(false);
  });

  it("sinh schema số nguyên có giới hạn, không sinh const/enum gây lỗi Dart generator", () => {
    const schema = z.toJSONSchema(JourneyDemoSnapshotSchema.shape.schemaVersion);
    expect(schema).toMatchObject({ type: "integer", minimum: 1, maximum: 1 });
    expect(schema).not.toHaveProperty("enum");
    expect(schema).not.toHaveProperty("const");
  });
});
