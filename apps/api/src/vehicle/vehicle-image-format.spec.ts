import { randomUUID } from "node:crypto";
import { describe, expect, it } from "vitest";
import { contentTypeOfKey, detectImageType, vehicleImageKey, vehicleImagePrefix } from "./vehicle-image-format";

const JPEG = [0xff, 0xd8, 0xff, 0xe0, 0, 0x10, 0x4a, 0x46, 0x49, 0x46, 0, 1];
const PNG = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0, 0, 0, 0x0d];
const WEBP = [0x52, 0x49, 0x46, 0x46, 0x24, 0, 0, 0, 0x57, 0x45, 0x42, 0x50];

describe("detectImageType", () => {
  it("nhận đúng JPEG / PNG / WebP theo chữ ký ở các byte đầu", () => {
    expect(detectImageType(Uint8Array.from(JPEG))).toBe("image/jpeg");
    expect(detectImageType(Uint8Array.from(PNG))).toBe("image/png");
    expect(detectImageType(Uint8Array.from(WEBP))).toBe("image/webp");
  });

  it("file không phải ảnh (HTML, SVG, GIF, RIFF khác WebP, rỗng, cụt) → null", () => {
    const text = (value: string) => new TextEncoder().encode(value);
    expect(detectImageType(text("<!doctype html><script>alert(1)</script>"))).toBeNull();
    expect(detectImageType(text('<svg xmlns="http://www.w3.org/2000/svg">'))).toBeNull();
    expect(detectImageType(text("GIF89a......"))).toBeNull();
    // RIFF nhưng là WAV: bốn byte đầu giống WebP, phải xét cả byte 8–11.
    expect(detectImageType(Uint8Array.from([0x52, 0x49, 0x46, 0x46, 0, 0, 0, 0, 0x57, 0x41, 0x56, 0x45]))).toBeNull();
    expect(detectImageType(new Uint8Array())).toBeNull();
    expect(detectImageType(Uint8Array.from(PNG.slice(0, 4)))).toBeNull();
  });
});

describe("khóa object của ảnh xe", () => {
  const operatorId = randomUUID();
  const vehicleId = randomUUID();
  const imageId = randomUUID();

  it("khóa do server sinh nằm dưới tiền tố của đúng xe, đuôi theo loại file", () => {
    expect(vehicleImageKey(operatorId, vehicleId, imageId, "image/jpeg")).toBe(
      `vehicles/${operatorId}/${vehicleId}/${imageId}.jpg`,
    );
    expect(vehicleImageKey(operatorId, vehicleId, imageId, "image/webp")).toBe(
      `${vehicleImagePrefix(operatorId, vehicleId)}${imageId}.webp`,
    );
  });

  it.each([
    ["image/jpeg", "jpg"],
    ["image/png", "png"],
    ["image/webp", "webp"],
  ] as const)("đọc lại được loại %s từ khóa", (type, extension) => {
    const key = vehicleImageKey(operatorId, vehicleId, imageId, type);
    expect(key.endsWith(`.${extension}`)).toBe(true);
    expect(contentTypeOfKey(operatorId, vehicleId, key)).toBe(type);
  });

  it("khóa của xe khác, nhà xe khác, đi ngược thư mục hoặc sai dạng → null", () => {
    const own = vehicleImageKey(operatorId, vehicleId, imageId, "image/png");
    expect(contentTypeOfKey(operatorId, randomUUID(), own)).toBeNull();
    expect(contentTypeOfKey(randomUUID(), vehicleId, own)).toBeNull();
    const prefix = vehicleImagePrefix(operatorId, vehicleId);
    for (const key of [
      `${prefix}../${randomUUID()}/${imageId}.png`,
      `${prefix}${imageId}.svg`,
      `${prefix}${imageId}.png.exe`,
      `${prefix}sub/${imageId}.png`,
      `${prefix}anh-xe.png`,
      `${prefix}${imageId.toUpperCase()}.png`,
      `${prefix}${imageId}`,
      prefix,
      "",
    ]) {
      expect(contentTypeOfKey(operatorId, vehicleId, key), key).toBeNull();
    }
  });
});
