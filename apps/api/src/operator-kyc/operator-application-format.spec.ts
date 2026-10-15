import { randomUUID } from "node:crypto";
import { describe, expect, it } from "vitest";
import { hashApplicationToken, newApplicationToken } from "../iam/role/application-access";
import {
  APPLICATION_CODE_PATTERN,
  contentTypeOfDocumentKey,
  detectDocumentType,
  documentKey,
  documentPrefix,
  maskAccountNumber,
  missingItems,
  newApplicationCode,
} from "./operator-application-format";

describe("định dạng hồ sơ đăng ký nhà xe", () => {
  it("mã hồ sơ OA-năm-6 số", () => {
    expect(newApplicationCode(new Date("2026-10-14T00:00:00Z"), () => 0.043152)).toBe("OA-2026-043152");
    expect(newApplicationCode(new Date("2026-10-14T00:00:00Z"), () => 0)).toBe("OA-2026-000000");
    expect(newApplicationCode(new Date(), () => 0.999999)).toMatch(APPLICATION_CODE_PATTERN);
  });

  it("token link: 32 byte base64url, DB chỉ giữ SHA-256", () => {
    const { token, tokenHash } = newApplicationToken();
    expect(token).toMatch(/^[A-Za-z0-9_-]{43}$/);
    expect(tokenHash).toMatch(/^[0-9a-f]{64}$/);
    expect(hashApplicationToken(token)).toBe(tokenHash);
    expect(newApplicationToken().token).not.toBe(token);
  });

  it("nhận PDF / JPEG / PNG theo chữ ký; HTML, SVG, ZIP, rỗng → null", () => {
    expect(detectDocumentType(Uint8Array.from([0x25, 0x50, 0x44, 0x46, 0x2d, 0x31]))).toBe("application/pdf");
    expect(detectDocumentType(Uint8Array.from([0xff, 0xd8, 0xff, 0xe0]))).toBe("image/jpeg");
    expect(detectDocumentType(Uint8Array.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]))).toBe("image/png");
    const text = (value: string) => new TextEncoder().encode(value);
    expect(detectDocumentType(text("<!doctype html>"))).toBeNull();
    expect(detectDocumentType(text("<svg"))).toBeNull();
    expect(detectDocumentType(Uint8Array.from([0x50, 0x4b, 0x03, 0x04]))).toBeNull();
    expect(detectDocumentType(new Uint8Array())).toBeNull();
  });

  it("khóa giấy tờ nằm dưới tiền tố của đúng hồ sơ; khóa hồ sơ khác / lạ / đi ngược thư mục → null", () => {
    const applicationId = randomUUID();
    const id = randomUUID();
    const key = documentKey(applicationId, id, "application/pdf");
    expect(key).toBe(`operator-applications/${applicationId}/${id}.pdf`);
    expect(contentTypeOfDocumentKey(applicationId, key)).toBe("application/pdf");
    expect(contentTypeOfDocumentKey(applicationId, documentKey(applicationId, id, "image/png"))).toBe("image/png");
    expect(contentTypeOfDocumentKey(randomUUID(), key)).toBeNull();
    const prefix = documentPrefix(applicationId);
    for (const bad of [`${prefix}../x/${id}.pdf`, `${prefix}${id}.exe`, `${prefix}${id}.pdf.html`, `${prefix}giay-to.pdf`, `vehicles/${id}.pdf`]) {
      expect(contentTypeOfDocumentKey(applicationId, bad), bad).toBeNull();
    }
  });

  it("số tài khoản chỉ hiện 4 số cuối", () => {
    expect(maskAccountNumber("0071004521")).toBe("•••• 4521");
    expect(maskAccountNumber(null)).toBeNull();
  });

  it("mục còn thiếu theo thứ tự các khối trên màn hình; đủ → rỗng; mô tả không bắt buộc", () => {
    const complete = {
      legalName: "A",
      taxCode: "0312345678",
      hotline: "19006868",
      address: "B",
      displayName: "C",
      bankName: "D",
      bankAccountNumber: "123456",
      bankAccountHolder: "E",
      documents: [
        { type: "BUSINESS_REGISTRATION" as const },
        { type: "TRANSPORT_LICENSE" as const },
        { type: "REPRESENTATIVE_AUTHORIZATION" as const },
      ],
    };
    expect(missingItems(complete)).toEqual([]);
    expect(
      missingItems({ ...complete, taxCode: null, bankAccountHolder: null, documents: complete.documents.slice(0, 1) }),
    ).toEqual(["taxCode", "document:TRANSPORT_LICENSE", "document:REPRESENTATIVE_AUTHORIZATION", "bankAccountHolder"]);
  });
});
