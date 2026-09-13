import { Inject, Injectable, Logger, type OnModuleInit } from "@nestjs/common";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";

const ALG = "RS256";

/**
 * jose là ESM-only → dynamic import (module=Node16 giữ import động ở runtime).
 * Bọc `import()` ở value-position để khỏi cần attribute 'resolution-mode' (TS1542).
 */
const loadJose = () => import("jose");
type Jose = Awaited<ReturnType<typeof loadJose>>;
type SignKey = Parameters<InstanceType<Jose["SignJWT"]>["sign"]>[0];

export type AuthScope = "passenger" | "operator" | "platform";

export type AccessTokenClaims = {
  /** subject = id account (passenger user / operator-account / platform-account). */
  sub: string;
  scope: AuthScope;
  role: string;
  operatorId?: string;
  operatorSlug?: string;
};

export type IssuedAccessToken = {
  accessToken: string;
  tokenType: "Bearer";
  expiresInSeconds: number;
};

/**
 * Mint JWT access RS256 (Security §5.1, ADR-017). IAM-001 chỉ phát access ngắn hạn;
 * opaque refresh + rotation + family = IAM-002.
 * Key load từ env (PEM raw/base64); thiếu ở dev → sinh ephemeral (cảnh báo). Production bắt buộc.
 */
@Injectable()
export class TokenService implements OnModuleInit {
  private readonly logger = new Logger(TokenService.name);
  private jose!: Jose;
  private privateKey!: SignKey;

  constructor(@Inject(APP_CONFIG) private readonly config: AppConfig) {}

  async onModuleInit(): Promise<void> {
    this.jose = await loadJose();

    const privatePem = decodePem(this.config.JWT_ACCESS_PRIVATE_KEY);
    if (privatePem) {
      this.privateKey = await this.jose.importPKCS8(privatePem, ALG);
      return;
    }

    if (this.config.NODE_ENV === "production") {
      throw new Error("JWT_ACCESS_PRIVATE_KEY is required in production.");
    }

    this.logger.warn(
      "JWT_ACCESS_PRIVATE_KEY chưa set - sinh keypair ephemeral cho dev (token mất hiệu lực sau restart).",
    );
    const pair = await this.jose.generateKeyPair(ALG, { extractable: true });
    this.privateKey = pair.privateKey;
  }

  async mintAccessToken(claims: AccessTokenClaims): Promise<IssuedAccessToken> {
    const ttl = this.config.JWT_ACCESS_TTL_SECONDS;
    const payload: Record<string, string> = {
      scope: claims.scope,
      role: claims.role,
    };
    if (claims.operatorId) {
      payload.operatorId = claims.operatorId;
    }
    if (claims.operatorSlug) {
      payload.operatorSlug = claims.operatorSlug;
    }

    const accessToken = await new this.jose.SignJWT(payload)
      .setProtectedHeader({ alg: ALG, typ: "JWT" })
      .setSubject(claims.sub)
      .setIssuer(this.config.JWT_ISSUER)
      .setIssuedAt()
      .setExpirationTime(`${ttl}s`)
      .sign(this.privateKey);

    return { accessToken, tokenType: "Bearer", expiresInSeconds: ttl };
  }
}

/** Nhận PEM raw (chứa "BEGIN") hoặc base64-encoded PEM. */
function decodePem(value: string | undefined): string | undefined {
  if (!value) {
    return undefined;
  }
  const trimmed = value.trim();
  return trimmed.includes("BEGIN")
    ? trimmed
    : Buffer.from(trimmed, "base64").toString("utf8");
}
