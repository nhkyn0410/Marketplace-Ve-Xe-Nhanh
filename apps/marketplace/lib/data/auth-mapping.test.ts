import { describe, expect, it } from "vitest";
import { mapPreferences, mapProfile, mapSessions } from "./auth-mapping";

describe("marketplace account mappings", () => {
  it("hồ sơ thiếu dữ liệu không tự sinh điểm, hạng hoặc người liên hệ", () => {
    const profile = mapProfile({ userId: "p1", name: null, email: "customer@example.com", emailVerified: true, phone: null, dateOfBirth: null, image: null });
    expect(profile.fullName).toBe("");
    expect(profile.phone).toBe("");
    expect(profile).not.toHaveProperty("points");
    expect(profile).not.toHaveProperty("tierName");
    expect(profile).not.toHaveProperty("savedPassengers");
  });

  it("công tắc giữ nguyên kind và chính sách mandatory từ API", () => {
    const result = mapPreferences({ items: [{ kind: "BOOKING_CONFIRMED", email: true, push: true, mandatory: true }, { kind: "PROMOTION", email: false, push: true, mandatory: false }] });
    expect(result.mandatoryItems[0]).toMatchObject({ id: "BOOKING_CONFIRMED", isMandatory: true });
    expect(result.optionalItems[0]).toMatchObject({ id: "PROMOTION", emailEnabled: false, pushEnabled: true });
  });

  it("session dùng public family id và không tự suy đoán địa điểm", () => {
    const result = mapSessions({ items: [{ sessionId: "family-id", current: true, deviceLabel: "Browser", ipAddress: "1.2.***.***", createdAt: "2026-10-21T00:00:00Z", lastUsedAt: "2026-10-21T01:00:00Z", expiresAt: "2026-11-21T00:00:00Z" }], nextCursor: null });
    expect(result[0]).toMatchObject({ id: "family-id", isCurrent: true, locationText: "Không có dữ liệu vị trí", ipAddress: "1.2.***.***" });
  });
});
