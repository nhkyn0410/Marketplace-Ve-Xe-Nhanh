import { randomUUID } from "node:crypto";
import { describe, expect, it } from "vitest";
import { contentTypeOfLogoKey, OPERATOR_LOGO_ROOT, operatorLogoKey } from "./operator-logo-format";

describe("khóa object của logo nhà xe", () => {
  const operatorId = randomUUID();
  const logoId = randomUUID();

  it.each([
    ["image/jpeg", "jpg"],
    ["image/png", "png"],
    ["image/webp", "webp"],
  ] as const)("khóa %s nằm dưới tiền tố của đúng nhà xe và đọc lại được loại file", (type, extension) => {
    const key = operatorLogoKey(operatorId, logoId, type);
    expect(key).toBe(`${OPERATOR_LOGO_ROOT}${operatorId}/${logoId}.${extension}`);
    expect(contentTypeOfLogoKey(operatorId, key)).toBe(type);
  });

  it("khóa của nhà xe khác, ảnh xe, đi ngược thư mục hoặc sai dạng → null", () => {
    const own = operatorLogoKey(operatorId, logoId, "image/png");
    expect(contentTypeOfLogoKey(randomUUID(), own)).toBeNull();
    const prefix = `${OPERATOR_LOGO_ROOT}${operatorId}/`;
    for (const key of [
      `vehicles/${operatorId}/${randomUUID()}/${logoId}.png`,
      `${prefix}../${randomUUID()}/${logoId}.png`,
      `${prefix}${logoId}.svg`,
      `${prefix}${logoId}.png.exe`,
      `${prefix}logo.png`,
      `${prefix}${logoId.toUpperCase()}.png`,
      `${prefix}sub/${logoId}.png`,
    ]) {
      expect(contentTypeOfLogoKey(operatorId, key), key).toBeNull();
    }
  });
});
