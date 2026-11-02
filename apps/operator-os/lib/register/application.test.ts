import { afterEach, describe, expect, it, vi } from "vitest";

import { ApiError } from "../auth/api-client";
import {
  type Application,
  applicationFormSchema,
  describeApplicationError,
  documentFileProblem,
  formatShortDateTime,
  formatTimeDate,
  type FormDocument,
  isLinkInvalid,
  missingFromForm,
  progressOf,
  registerSchema,
  resendSchema,
  toFormValues,
  toUpdateInput
} from "./application";
import { forgetApplicationToken, takeApplicationToken } from "./application-token";

const application: Application = {
  applicationCode: "OA-2026-043152",
  status: "DRAFT",
  operatorName: "Sao Việt Express",
  contactName: "Nguyễn Thanh Sao",
  contactEmail: "lienhe@saoviet.vn",
  contactEmailVerifiedAt: "2026-10-13T02:52:00.000Z",
  legalName: "Công ty TNHH Sao Việt",
  taxCode: "0312345678",
  hotline: "19006868",
  address: "266 Đồng Đen",
  displayName: "Sao Việt Express",
  description: null,
  bankName: "Vietcombank",
  bankAccountNumberMasked: "•••• 4521",
  bankAccountHolder: "CTY TNHH SAO VIET",
  documents: [
    {
      type: "BUSINESS_REGISTRATION",
      objectKey: "operator-applications/a/1.pdf",
      fileName: "dkkd.pdf",
      contentType: "application/pdf",
      sizeBytes: 10,
      uploadedAt: "2026-10-13T02:58:00.000Z"
    }
  ],
  missing: [],
  reviewNote: null,
  createdAt: "2026-10-13T02:48:00.000Z",
  submittedAt: null,
  updatedAt: "2026-10-13T02:58:00.000Z",
  linkExpiresAt: "2026-10-16T03:15:00.000Z"
};

const allDocuments: FormDocument[] = [
  { type: "BUSINESS_REGISTRATION", objectKey: "k1", fileName: "a.pdf", uploadedAt: null },
  { type: "TRANSPORT_LICENSE", objectKey: "k2", fileName: "b.pdf", uploadedAt: null },
  { type: "REPRESENTATIVE_AUTHORIZATION", objectKey: "k3", fileName: "c.png", uploadedAt: null }
];

describe("form đăng ký nhà xe", () => {
  it("bước 1: bắt buộc đủ ba ô và đồng ý điều khoản", () => {
    const result = registerSchema.safeParse({ operatorName: " ", contactName: "", contactEmail: "x", acceptTerms: false });
    expect(result.success).toBe(false);
    const messages = result.error!.issues.map((issue) => issue.message);
    expect(messages).toEqual(
      expect.arrayContaining([
        "Nhập tên nhà xe.",
        "Nhập họ tên người liên hệ.",
        "Email liên hệ không hợp lệ.",
        "Cần đồng ý điều khoản để gửi đăng ký."
      ])
    );
    expect(
      registerSchema.parse({ operatorName: "A", contactName: "B", contactEmail: " a@b.vn ", acceptTerms: true }).contactEmail
    ).toBe("a@b.vn");
  });

  it("gửi lại link: mã hồ sơ chuẩn hóa chữ hoa, sai dạng báo lỗi", () => {
    expect(resendSchema.parse({ contactEmail: "a@b.vn", applicationCode: " oa-2026-043152 " }).applicationCode).toBe(
      "OA-2026-043152"
    );
    expect(resendSchema.safeParse({ contactEmail: "a@b.vn", applicationCode: "2026" }).error?.issues[0]?.message).toBe(
      "Mã hồ sơ có dạng OA-2026-043152."
    );
  });

  it("hồ sơ → form: số tài khoản để trống (API chỉ trả số đã che); null thành chuỗi rỗng", () => {
    expect(toFormValues(application)).toEqual({
      legalName: "Công ty TNHH Sao Việt",
      taxCode: "0312345678",
      hotline: "19006868",
      address: "266 Đồng Đen",
      displayName: "Sao Việt Express",
      description: "",
      bankName: "Vietcombank",
      bankAccountNumber: "",
      bankAccountHolder: "CTY TNHH SAO VIET"
    });
  });

  it("form → body: ô trống thành null; số tài khoản trống thì không gửi (giữ số cũ), có thì bỏ dấu cách", () => {
    const values = { ...toFormValues(application), description: "  ", bankAccountNumber: "" };
    const body = toUpdateInput(values, allDocuments);
    expect(body.description).toBeNull();
    expect(body).not.toHaveProperty("bankAccountNumber");
    expect(body.documents).toEqual([
      { type: "BUSINESS_REGISTRATION", objectKey: "k1", fileName: "a.pdf" },
      { type: "TRANSPORT_LICENSE", objectKey: "k2", fileName: "b.pdf" },
      { type: "REPRESENTATIVE_AUTHORIZATION", objectKey: "k3", fileName: "c.png" }
    ]);
    expect(toUpdateInput({ ...values, bankAccountNumber: "0071 0045 21" }, []).bankAccountNumber).toBe("0071004521");
  });

  it("kiểm định dạng mã số thuế / hotline / số tài khoản; ô trống vẫn lưu nháp được", () => {
    const empty = { ...toFormValues(application), taxCode: "", hotline: "", bankAccountNumber: "" };
    expect(applicationFormSchema.safeParse(empty).success).toBe(true);
    const bad = applicationFormSchema.safeParse({ ...empty, taxCode: "123", hotline: "abc", bankAccountNumber: "12" });
    expect(bad.error?.issues.map((issue) => issue.message)).toEqual([
      "Mã số thuế gồm 10 hoặc 13 chữ số.",
      "Hotline gồm 8–15 chữ số.",
      "Số tài khoản gồm 6–20 chữ số."
    ]);
    expect(applicationFormSchema.safeParse({ ...empty, taxCode: "0312 345 678", hotline: "1900.6868" }).success).toBe(true);
  });

  it("mục còn thiếu tính trên form; số tài khoản đã lưu thì không coi là thiếu", () => {
    const values = toFormValues(application);
    expect(missingFromForm(values, allDocuments, true)).toEqual([]);
    expect(missingFromForm(values, allDocuments, false)).toEqual(["bankAccountNumber"]);
    expect(missingFromForm({ ...values, hotline: " " }, allDocuments.slice(0, 2), true)).toEqual([
      "hotline",
      "document:REPRESENTATIVE_AUTHORIZATION"
    ]);
  });

  it("tiến độ hồ sơ: bốn nhóm + câu cảnh báo liệt kê mục còn thiếu (Figma 03)", () => {
    const { groups, warning } = progressOf(["document:REPRESENTATIVE_AUTHORIZATION"]);
    expect(groups).toEqual([
      { label: "Thông tin doanh nghiệp", done: true },
      { label: "Thông tin công khai", done: true },
      { label: "Giấy tờ KYC · thiếu 1 giấy tờ", done: false },
      { label: "Tài khoản nhận tiền", done: true }
    ]);
    expect(warning).toBe("Chưa gửi duyệt được: còn thiếu giấy tờ người đại diện.");
    expect(progressOf([]).warning).toBeNull();
  });

  it("giấy tờ: chỉ PDF / JPEG / PNG, tối đa 10 MB", () => {
    expect(documentFileProblem({ type: "application/pdf", size: 1024 })).toBeNull();
    expect(documentFileProblem({ type: "image/png", size: 10 * 1024 * 1024 })).toBeNull();
    expect(documentFileProblem({ type: "image/gif", size: 10 })).toBe("Định dạng không được hỗ trợ. Chọn PDF, JPEG hoặc PNG.");
    expect(documentFileProblem({ type: "application/pdf", size: 10 * 1024 * 1024 + 1 })).toBe(
      "Tệp vượt quá 10 MB. Hãy chọn tệp nhỏ hơn."
    );
    expect(documentFileProblem({ type: "application/pdf", size: 0 })).not.toBeNull();
  });

  it("định dạng thời gian theo giờ Việt Nam", () => {
    expect(formatShortDateTime("2026-10-13T02:58:00.000Z")).toBe("13/10 · 09:58");
    expect(formatTimeDate("2026-10-16T03:15:00.000Z")).toBe("10:15 · 16/10/2026");
  });

  it("lỗi API → thông báo; link hết hiệu lực nhận ra riêng", () => {
    expect(isLinkInvalid(new ApiError(401, "OPERATOR_APPLICATION_LINK_INVALID", "x"))).toBe(true);
    expect(isLinkInvalid(new ApiError(401, "AUTH_INVALID", "x"))).toBe(false);
    expect(
      describeApplicationError(
        new ApiError(422, "OPERATOR_APPLICATION_INCOMPLETE", "x", ["taxCode", "document:TRANSPORT_LICENSE"])
      )
    ).toBe("Chưa gửi duyệt được: còn thiếu mã số thuế, giấy phép kinh doanh vận tải.");
    expect(describeApplicationError(new ApiError(409, "OPERATOR_APPLICATION_INVALID_STATE", "x"))).toContain("đã gửi duyệt");
    expect(describeApplicationError(new ApiError(429, "OPERATOR_APPLICATION_RATE_LIMITED", "x"))).toContain("quá nhanh");
    expect(describeApplicationError(new ApiError(503, "SERVICE_UNAVAILABLE", "x"))).toContain("thử lại sau");
    expect(describeApplicationError(new TypeError("Failed to fetch"))).toContain("kết nối");
  });
});

describe("token của link bảo mật", () => {
  const store = new Map<string, string>();
  vi.stubGlobal("sessionStorage", {
    getItem: (key: string) => store.get(key) ?? null,
    setItem: (key: string, value: string) => void store.set(key, value),
    removeItem: (key: string) => void store.delete(key)
  });

  afterEach(() => {
    store.clear();
  });

  it("đọc token trong #token=, cất cho tab, xóa khỏi thanh địa chỉ; lần sau đọc từ chỗ đã cất", () => {
    const replaceState = vi.fn();
    expect(takeApplicationToken({ hash: "#token=abc_DEF-123" }, { replaceState })).toBe("abc_DEF-123");
    expect(replaceState).toHaveBeenCalledWith(null, "", "/register/application");
    expect(takeApplicationToken({ hash: "" }, { replaceState })).toBe("abc_DEF-123");
    expect(replaceState).toHaveBeenCalledOnce();
  });

  it("không có token → null; quên token khi link hết hiệu lực", () => {
    const replaceState = vi.fn();
    expect(takeApplicationToken({ hash: "#khac=1" }, { replaceState })).toBeNull();
    takeApplicationToken({ hash: "#token=abc" }, { replaceState });
    forgetApplicationToken();
    expect(takeApplicationToken({ hash: "" }, { replaceState })).toBeNull();
  });
});
