import { describe, expect, it } from "vitest";
import { parseAppConfig, webAllowedOrigins, webOriginScopes } from "./env.config";

/** Cấu hình R2 đầy đủ — production bắt buộc (TASK-TRN-009). */
const R2 = {
  R2_ACCOUNT_ID: "account",
  R2_ACCESS_KEY_ID: "key-id",
  R2_SECRET_ACCESS_KEY: "secret",
  R2_PUBLIC_BUCKET: "vexenhanh-public",
  R2_PUBLIC_BASE_URL: "https://cdn.example.com",
};

describe("parseAppConfig", () => {
  it("applies defaults when env is empty", () => {
    const config = parseAppConfig({});

    expect(config.NODE_ENV).toBe("development");
    expect(config.PORT).toBe(3000);
    expect(config.TRUST_PROXY_HOPS).toBe(0);
    expect(config.DATABASE_URL).toBeUndefined();
    expect(config.LOG_LEVEL).toBe("info");
    expect(config.SENTRY_TRACES_SAMPLE_RATE).toBe(0.1);
    expect(config.OTEL_SERVICE_NAME).toBe("vexenhanh-api");
  });

  it("coerces PORT to a number", () => {
    expect(parseAppConfig({ PORT: "8080" }).PORT).toBe(8080);
  });

  it("coerces TRUST_PROXY_HOPS to a non-negative integer", () => {
    expect(parseAppConfig({ TRUST_PROXY_HOPS: "3" }).TRUST_PROXY_HOPS).toBe(3);
    expect(() => parseAppConfig({ TRUST_PROXY_HOPS: "-1" })).toThrow(/Invalid environment/);
    expect(() => parseAppConfig({ TRUST_PROXY_HOPS: "1.5" })).toThrow(/Invalid environment/);
  });

  it("rejects an invalid PORT", () => {
    expect(() => parseAppConfig({ PORT: "not-a-number" })).toThrow(/Invalid environment/);
  });

  it("rejects an unknown NODE_ENV", () => {
    expect(() => parseAppConfig({ NODE_ENV: "staging" })).toThrow(/Invalid environment/);
  });

  it("rejects an invalid LOG_LEVEL", () => {
    expect(() => parseAppConfig({ LOG_LEVEL: "loud" })).toThrow(/Invalid environment/);
  });

  it("rejects an invalid SENTRY_TRACES_SAMPLE_RATE", () => {
    expect(() => parseAppConfig({ SENTRY_TRACES_SAMPLE_RATE: "2" })).toThrow(
      /Invalid environment/
    );
  });

  it("keeps optional connection strings when provided", () => {
    const config = parseAppConfig({
      DATABASE_URL: "postgresql://u:p@localhost:5432/db?schema=public",
      REDIS_URL: "redis://localhost:6379"
    });

    expect(config.DATABASE_URL).toBe("postgresql://u:p@localhost:5432/db?schema=public");
    expect(config.REDIS_URL).toBe("redis://localhost:6379");
  });

  it("accepts only a 32-byte base64 MFA encryption key", () => {
    const key = Buffer.alloc(32, 7).toString("base64");
    expect(parseAppConfig({ MFA_ENCRYPTION_KEY: key }).MFA_ENCRYPTION_KEY).toBe(key);
    expect(() => parseAppConfig({ MFA_ENCRYPTION_KEY: "not-base64" })).toThrow(
      /MFA_ENCRYPTION_KEY/,
    );
    expect(() =>
      parseAppConfig({ MFA_ENCRYPTION_KEY: Buffer.alloc(31).toString("base64") }),
    ).toThrow(/MFA_ENCRYPTION_KEY/);
    // Bit đệm khác 0: vẫn decode ra 32 byte nhưng không phải dạng chuẩn → từ chối.
    expect(() => parseAppConfig({ MFA_ENCRYPTION_KEY: `${key.slice(0, 42)}B=` })).toThrow(
      /MFA_ENCRYPTION_KEY/,
    );
  });

  it("requires the dedicated MFA encryption key in production", () => {
    expect(() =>
      parseAppConfig({
        NODE_ENV: "production",
        BETTER_AUTH_SECRET: "test-secret",
        BETTER_AUTH_URL: "https://api.example.com",
        JWT_ACCESS_PRIVATE_KEY: "test-key",
        RESEND_API_KEY: "test-resend-key",
      }),
    ).toThrow(/MFA_ENCRYPTION_KEY/);
  });

  it("requires GOONG_API_KEY in production but not in development (TASK-TRN-002 Q8)", () => {
    const production = {
      NODE_ENV: "production",
      BETTER_AUTH_SECRET: "test-secret",
      BETTER_AUTH_URL: "https://api.example.com",
      JWT_ACCESS_PRIVATE_KEY: "test-key",
      MFA_ENCRYPTION_KEY: Buffer.alloc(32, 1).toString("base64"),
      RESEND_API_KEY: "test-resend-key",
      WEB_CSRF_SECRET: Buffer.alloc(32, 2).toString("base64"),
      TICKET_QR_SECRET: Buffer.alloc(32, 3).toString("base64"),
      OPERATOR_WEB_ORIGINS: "https://operator.example.com",
      ADMIN_WEB_ORIGINS: "https://admin.example.com",
      ...R2,
    };
    expect(() => parseAppConfig(production)).toThrow(/GOONG_API_KEY/);
    expect(parseAppConfig({ ...production, GOONG_API_KEY: "k" }).GOONG_API_KEY).toBe("k");
    expect(parseAppConfig({}).GOONG_API_KEY).toBeUndefined();
  });

  describe("web auth cookie mode (TASK-IAM-006)", () => {
    const production = {
      NODE_ENV: "production",
      BETTER_AUTH_SECRET: "test-secret",
      BETTER_AUTH_URL: "https://api.example.com",
      JWT_ACCESS_PRIVATE_KEY: "test-key",
      MFA_ENCRYPTION_KEY: Buffer.alloc(32, 1).toString("base64"),
      RESEND_API_KEY: "test-resend-key",
      GOONG_API_KEY: "k",
      WEB_CSRF_SECRET: Buffer.alloc(32, 2).toString("base64"),
      TICKET_QR_SECRET: Buffer.alloc(32, 3).toString("base64"),
      OPERATOR_WEB_ORIGINS: "https://operator.vexenhanh.vn",
      ADMIN_WEB_ORIGINS: "https://admin.vexenhanh.vn, https://admin2.vexenhanh.vn",
      ...R2,
    };

    it("hồ sơ đăng ký nhà xe (TASK-OPR-001): link mặc định 72 giờ, tối đa 30 ngày; bucket private tùy chọn", () => {
      expect(parseAppConfig({}).OPERATOR_APPLICATION_LINK_TTL_HOURS).toBe(72);
      expect(parseAppConfig({ OPERATOR_APPLICATION_LINK_TTL_HOURS: "24" }).OPERATOR_APPLICATION_LINK_TTL_HOURS).toBe(24);
      expect(() => parseAppConfig({ OPERATOR_APPLICATION_LINK_TTL_HOURS: "721" })).toThrow(/OPERATOR_APPLICATION_LINK_TTL_HOURS/);
      expect(() => parseAppConfig({ OPERATOR_APPLICATION_LINK_TTL_HOURS: "0" })).toThrow(/OPERATOR_APPLICATION_LINK_TTL_HOURS/);
      // Production không bắt buộc bucket private: chưa chốt nơi lưu KYC (OQ-21) thì API giấy tờ trả 503.
      expect(parseAppConfig(production).R2_PRIVATE_BUCKET).toBeUndefined();
      expect(parseAppConfig({ ...production, R2_PRIVATE_BUCKET: "vexenhanh-private" }).R2_PRIVATE_BUCKET).toBe("vexenhanh-private");
    });

    it("kho object (TASK-TRN-009): production bắt buộc R2; dev bỏ trống thì dùng ổ đĩa; khai dở bị từ chối", () => {
      const withoutR2 = Object.fromEntries(Object.entries(production).filter(([key]) => !key.startsWith("R2_")));
      expect(() => parseAppConfig(withoutR2)).toThrow(/R2_ACCOUNT_ID/);
      expect(parseAppConfig(production).R2_PUBLIC_BUCKET).toBe("vexenhanh-public");
      expect(parseAppConfig({}).R2_ACCOUNT_ID).toBeUndefined();
      // Chỉ khai một phần ở dev: không được lặng lẽ rơi về ổ đĩa local.
      expect(() => parseAppConfig({ R2_ACCOUNT_ID: "account" })).toThrow(/R2_PUBLIC_BUCKET/);
      expect(() => parseAppConfig({ ...R2, R2_PUBLIC_BASE_URL: "khong-phai-url" })).toThrow(/Invalid environment/);
    });

    it("ràng từng origin với scope của app (M1): operator ↔ Operator OS, platform ↔ Admin", () => {
      expect([...webOriginScopes(parseAppConfig(production))]).toEqual([
        ["https://operator.vexenhanh.vn", "operator"],
        ["https://admin.vexenhanh.vn", "platform"],
        ["https://admin2.vexenhanh.vn", "platform"],
      ]);
    });

    it("cổng thanh toán (TASK-BTP-003): mặc định sandbox, production không bắt buộc khóa (OQ-22), khai dở khóa bị từ chối", () => {
      expect(parseAppConfig({}).VNPAY_PAYMENT_URL).toBe("https://sandbox.vnpayment.vn/paymentv2/vpcpay.html");
      expect(parseAppConfig({}).MOMO_ENDPOINT).toBe("https://test-payment.momo.vn");
      expect(parseAppConfig(production).VNPAY_TMN_CODE).toBeUndefined();
      expect(() => parseAppConfig({ VNPAY_TMN_CODE: "TMN" })).toThrow(/VNPAY_HASH_SECRET/);
      expect(() => parseAppConfig({ MOMO_PARTNER_CODE: "P", MOMO_ACCESS_KEY: "A" })).toThrow(/MOMO_SECRET_KEY/);
      expect(parseAppConfig({ VNPAY_TMN_CODE: "TMN", VNPAY_HASH_SECRET: "s" }).VNPAY_TMN_CODE).toBe("TMN");
    });

    it("defaults to local Operator/Admin origins outside production", () => {
      const config = parseAppConfig({});
      expect(config.OPERATOR_WEB_ORIGINS).toBeUndefined();
      expect(webAllowedOrigins(config)).toEqual(["http://localhost:3002", "http://localhost:3003"]);
      expect(webOriginScopes(config).get("http://localhost:3003")).toBe("platform");
    });

    it.each([
      ["WEB_CSRF_SECRET", { WEB_CSRF_SECRET: undefined }],
      ["OPERATOR_WEB_ORIGINS", { OPERATOR_WEB_ORIGINS: undefined }],
      ["ADMIN_WEB_ORIGINS", { ADMIN_WEB_ORIGINS: undefined }],
      ["OPERATOR_WEB_ORIGINS", { OPERATOR_WEB_ORIGINS: "http://operator.vexenhanh.vn" }],
      ["ADMIN_WEB_ORIGINS", { ADMIN_WEB_ORIGINS: "https://localhost:3003" }],
      ["WEB_CSRF_SECRET", { WEB_CSRF_SECRET: Buffer.alloc(32, 1).toString("base64") }],
      ["TICKET_QR_SECRET", { TICKET_QR_SECRET: undefined }],
    ])("production fails fast on %s %o", (key, override) => {
      expect(() => parseAppConfig({ ...production, ...override })).toThrow(new RegExp(key));
    });

    it.each(["*", "https://operator.vexenhanh.vn/", "https://operator.vexenhanh.vn/app", "operator.vexenhanh.vn"])(
      "rejects non-exact origin %s in any environment",
      (origin) => {
        expect(() => parseAppConfig({ OPERATOR_WEB_ORIGINS: origin })).toThrow(/OPERATOR_WEB_ORIGINS/);
      },
    );

    it("một origin không được thuộc cả hai app", () => {
      expect(() =>
        parseAppConfig({ OPERATOR_WEB_ORIGINS: "http://localhost:3002", ADMIN_WEB_ORIGINS: "http://localhost:3002" }),
      ).toThrow(/must not share an origin/);
    });

    it("rejects a CSRF secret that is not 32 bytes of base64", () => {
      expect(() => parseAppConfig({ WEB_CSRF_SECRET: Buffer.alloc(16).toString("base64") })).toThrow(
        /WEB_CSRF_SECRET/,
      );
    });
  });

  it("treats empty / whitespace strings as unset", () => {
    const config = parseAppConfig({ DATABASE_URL: "   ", PORT: "", SENTRY_DSN: "" });

    expect(config.SENTRY_DSN).toBeUndefined();
    expect(config.DATABASE_URL).toBeUndefined();
    expect(config.PORT).toBe(3000);
  });
});
