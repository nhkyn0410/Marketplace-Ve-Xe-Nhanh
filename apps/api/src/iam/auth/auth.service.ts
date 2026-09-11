import { HttpStatus, Inject, Injectable, Logger } from "@nestjs/common";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";
import { PrismaService } from "../../database/prisma.service";
import { maskEmail } from "../../external/notification/email-notifier";
import { type Auth } from "./auth.config";
import { BETTER_AUTH, PASSENGER_ROLE } from "./auth.constants";
import { accountLocked, AuthException, invalidCredentials, wrongLoginChannel } from "./auth.errors";
import { CredentialService, DUMMY_PASSWORD_HASH } from "./credential.service";
import { LoginHistoryService } from "./login-history.service";
import { resolveIdentifier } from "./namespace.resolver";
import { OtpRateLimiter } from "./otp-rate-limiter";
import { type AuthScope, type IssuedAccessToken, TokenService } from "./token.service";

/** v1 chỉ Google (ADR-020 + quyết định 09/09/2026); Facebook/Apple defer v1.x. */
export const SUPPORTED_OAUTH = ["google"] as const;
type OAuthProvider = (typeof SUPPORTED_OAUTH)[number];

export type RequestContext = { ip?: string; userAgent?: string };

export type LoginResult = IssuedAccessToken & { scope: AuthScope; role: string };

type CredentialAccount = {
  id: string;
  passwordHash: string;
  role: string;
  status: string;
  operatorId?: string;
  operatorSlug?: string;
};

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    @Inject(BETTER_AUTH) private readonly auth: Auth,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
    private readonly prisma: PrismaService,
    private readonly tokens: TokenService,
    private readonly credentials: CredentialService,
    private readonly otpRateLimiter: OtpRateLimiter,
    private readonly loginHistory: LoginHistoryService
  ) {}

  // ── Passenger (Better Auth: email-OTP) ──
  // Đăng ký = gửi OTP; Better Auth tạo user khi verify. Hồ sơ (name...) cập nhật sau (FR-IAM-11).
  async register(email: string): Promise<void> {
    await this.sendSignInOtp(email);
  }

  async requestOtp(email: string): Promise<void> {
    await this.sendSignInOtp(email);
  }

  private async sendSignInOtp(email: string): Promise<void> {
    await this.otpRateLimiter.assertCanRequest(email);
    try {
      await this.auth.api.sendVerificationOTP({ body: { email, type: "sign-in" } });
    } catch (error) {
      // Response luôn 200 để KHÔNG leak account tồn tại hay không — nhưng phải LOG, nếu không
      // Resend hỏng / config sai sẽ vô hình: user không bao giờ nhận OTP mà ops không có tín hiệu.
      // Chống enumeration là về response, không phải về log.
      this.logger.error(`Gửi OTP thất bại cho ${maskEmail(email)}: ${String(error)}`);
    }
  }

  async verifyOtp(email: string, otp: string, ctx: RequestContext): Promise<LoginResult> {
    let userId: string;
    try {
      const result = await this.auth.api.signInEmailOTP({ body: { email, otp } });
      userId = result.user.id;
    } catch (error) {
      // Chỉ OTP sai mới là 401. Lỗi hạ tầng (Postgres/Redis) mà map thành 401 sẽ ghi audit sai
      // sự thật ("otp_invalid") — làm hỏng chính bằng chứng dùng để điều tra sau này.
      if (!isClientAuthError(error)) {
        throw error;
      }
      await this.loginHistory.record({
        scope: "passenger",
        result: "failure",
        targetId: maskEmail(email),
        reason: "otp_invalid",
        ...ctx
      });
      throw invalidCredentials();
    }

    return this.issuePassengerToken(userId, ctx);
  }

  // ── Operator / Employee (custom, `{slug}/{username}` + password) ──
  async operatorLogin(identifier: string, password: string, ctx: RequestContext): Promise<LoginResult> {
    await this.otpRateLimiter.assertCanAttemptLogin(identifier, ctx.ip);

    const resolved = resolveIdentifier(identifier);
    if (!resolved || resolved.scope !== "operator") {
      await this.recordUnknownAttempt("operator", identifier, "wrong_channel", ctx);
      throw wrongLoginChannel();
    }
    const { operatorSlug, username } = resolved;

    const operator = await this.prisma.operatorProfile.findUnique({ where: { operatorSlug } });
    const account = operator
      ? await this.findOperatorSideAccount(operator.id, operatorSlug, username)
      : null;

    if (!operator || !account) {
      await this.credentials.verify(password, DUMMY_PASSWORD_HASH);
      await this.recordUnknownAttempt("operator", identifier, "unknown_account", ctx);
      throw invalidCredentials();
    }

    await this.verifyOrThrow(password, account, "operator", ctx, !isActive(operator.status));

    // Slug lấy từ DB, KHÔNG từ input người dùng: claim `operatorSlug` và `operatorId` phải cùng
    // một nguồn, nếu không TenantGuard (khớp slug URL) và RLS (dùng operatorId) sẽ bất đồng ở IAM-003.
    return this.issueCredentialToken("operator", account, operator.operatorSlug, ctx);
  }

  // ── Platform (custom, `platform/{username}` + password) ──
  async platformLogin(identifier: string, password: string, ctx: RequestContext): Promise<LoginResult> {
    await this.otpRateLimiter.assertCanAttemptLogin(identifier, ctx.ip);

    const resolved = resolveIdentifier(identifier);
    if (!resolved || resolved.scope !== "platform") {
      await this.recordUnknownAttempt("platform", identifier, "wrong_channel", ctx);
      throw wrongLoginChannel();
    }

    const row = await this.prisma.platformAccount.findUnique({ where: { username: resolved.username } });
    const account: CredentialAccount | null = row
      ? { id: row.id, passwordHash: row.passwordHash, role: String(row.role), status: String(row.status) }
      : null;

    if (!account) {
      await this.credentials.verify(password, DUMMY_PASSWORD_HASH);
      await this.recordUnknownAttempt("platform", identifier, "unknown_account", ctx);
      throw invalidCredentials();
    }

    await this.verifyOrThrow(password, account, "platform", ctx, false);

    return this.issueCredentialToken("platform", account, undefined, ctx);
  }

  // ── OAuth (Passenger — Better Auth, ADR-020) ──
  async oauthInit(provider: string, callbackURL: string | undefined): Promise<string> {
    if (!SUPPORTED_OAUTH.includes(provider as OAuthProvider)) {
      throw new AuthException(
        HttpStatus.BAD_REQUEST,
        "AUTH_OAUTH_PROVIDER_UNSUPPORTED",
        `OAuth provider không hỗ trợ: ${provider}`
      );
    }
    this.assertAllowedCallback(callbackURL);
    const result = await this.auth.api.signInSocial({
      body: { provider: provider as OAuthProvider, callbackURL, disableRedirect: true }
    });
    if (!result.url) {
      throw new AuthException(
        HttpStatus.BAD_GATEWAY,
        "AUTH_OAUTH_INIT_FAILED",
        "Không khởi tạo được luồng OAuth."
      );
    }
    return result.url;
  }

  /** Đổi Better Auth session (sau OAuth callback) → JWT của ta (headless bridge). */
  async exchangeSession(headers: Headers, ctx: RequestContext): Promise<LoginResult> {
    const session = await this.auth.api.getSession({ headers });
    if (!session?.user) {
      throw invalidCredentials();
    }
    return this.issuePassengerToken(session.user.id, ctx);
  }

  // ── helpers ──
  /**
   * `callbackURL` do client gửi lên là đầu vào KHÔNG tin được. Better Auth lưu nguyên nó vào
   * bản ghi state rồi redirect tới đó **sau khi đã set session cookie** → attacker dụ nạn nhân
   * mở luồng với callbackURL của mình, nạn nhân đăng nhập Google thật rồi bị đẩy sang trang giả
   * ở trạng thái đã đăng nhập. Middleware origin-check của Better Auth KHÔNG cứu được vì nó
   * thoát sớm khi không có `ctx.request` (ta gọi server-side qua `auth.api.signInSocial`).
   */
  private assertAllowedCallback(callbackURL: string | undefined): void {
    if (!callbackURL) {
      return;
    }
    const allowed = this.config.AUTH_ALLOWED_CALLBACK_ORIGINS.some((origin) =>
      origin.endsWith("://")
        ? callbackURL.startsWith(origin) // deep-link scheme mobile: vexenhanh://...
        : callbackURL === origin || callbackURL.startsWith(`${origin}/`)
    );
    if (!allowed) {
      throw new AuthException(
        HttpStatus.BAD_REQUEST,
        "AUTH_OAUTH_CALLBACK_NOT_ALLOWED",
        "callbackURL không nằm trong danh sách cho phép."
      );
    }
  }

  private async issuePassengerToken(userId: string, ctx: RequestContext): Promise<LoginResult> {
    const token = await this.tokens.mintAccessToken({
      sub: userId,
      scope: "passenger",
      role: PASSENGER_ROLE
    });
    await this.loginHistory.record({
      scope: "passenger",
      result: "success",
      targetId: userId,
      accountId: userId,
      role: PASSENGER_ROLE,
      ...ctx
    });
    return { ...token, scope: "passenger", role: PASSENGER_ROLE };
  }

  private async findOperatorSideAccount(
    operatorId: string,
    operatorSlug: string,
    username: string
  ): Promise<CredentialAccount | null> {
    const owner = await this.prisma.operatorAccount.findUnique({
      where: { operatorSlug_username: { operatorSlug, username } }
    });
    // `operator_slug` trên operator_accounts là bản sao denormalized: nếu nó lệch với
    // operator_profiles (slug đổi tên ở IAM-005, sửa tay, tenant xoá rồi tạo lại) thì tra theo slug
    // sẽ trả account của TENANT KHÁC — qua được cả check SUSPENDED lẫn claim tenant. Bắt buộc
    // đối chiếu operatorId đã resolve, giống nhánh employee bên dưới.
    if (owner && owner.operatorId === operatorId) {
      return {
        id: owner.id,
        passwordHash: owner.passwordHash,
        role: String(owner.role),
        status: String(owner.status),
        operatorId: owner.operatorId,
        operatorSlug: owner.operatorSlug
      };
    }

    const employee = await this.prisma.employeeAccount.findUnique({
      where: { operatorId_username: { operatorId, username } }
    });
    if (employee) {
      return {
        id: employee.id,
        passwordHash: employee.passwordHash,
        role: String(employee.role),
        status: String(employee.status),
        operatorId: employee.operatorId,
        operatorSlug
      };
    }
    return null;
  }

  /**
   * Ghi audit cho lần thử vào account KHÔNG tồn tại / sai cổng. Không ghi thì password spraying
   * và dò namespace không để lại dấu vết nào (FR-IAM-09, Security §11 "brute force → monitoring").
   * Response trả về vẫn y hệt nhánh sai mật khẩu — audit không phải kênh leak.
   */
  private async recordUnknownAttempt(
    scope: AuthScope,
    identifier: string,
    reason: string,
    ctx: RequestContext
  ): Promise<void> {
    await this.loginHistory.record({
      scope,
      result: "failure",
      targetId: maskIdentifier(identifier),
      reason,
      ...ctx
    });
  }

  private async verifyOrThrow(
    password: string,
    account: CredentialAccount,
    scope: AuthScope,
    ctx: RequestContext,
    tenantInactive: boolean
  ): Promise<void> {
    const ok = await this.credentials.verify(password, account.passwordHash);
    if (!ok) {
      await this.loginHistory.record({
        scope,
        result: "failure",
        targetId: account.id,
        operatorId: account.operatorId,
        reason: "bad_password",
        ...ctx
      });
      throw invalidCredentials();
    }
    if (!isActive(account.status) || tenantInactive) {
      await this.loginHistory.record({
        scope,
        result: "failure",
        targetId: account.id,
        accountId: account.id,
        role: account.role,
        operatorId: account.operatorId,
        reason: tenantInactive ? "tenant_inactive" : "account_inactive",
        ...ctx
      });
      throw accountLocked();
    }
  }

  private async issueCredentialToken(
    scope: AuthScope,
    account: CredentialAccount,
    operatorSlug: string | undefined,
    ctx: RequestContext
  ): Promise<LoginResult> {
    const token = await this.tokens.mintAccessToken({
      sub: account.id,
      scope,
      role: account.role,
      operatorId: account.operatorId,
      operatorSlug
    });
    await this.loginHistory.record({
      scope,
      result: "success",
      targetId: account.id,
      accountId: account.id,
      role: account.role,
      operatorId: account.operatorId,
      ...ctx
    });
    return { ...token, scope, role: account.role };
  }
}

function isActive(status: string): boolean {
  return status === "ACTIVE";
}

/** Better Auth ném `APIError` có `status` cho lỗi phía client; lỗi hạ tầng thì không. */
function isClientAuthError(error: unknown): boolean {
  const status = (error as { status?: unknown } | null)?.status;
  if (typeof status === "number") {
    return status >= 400 && status < 500;
  }
  // better-auth dùng chuỗi cho một số mã (vd "BAD_REQUEST", "UNAUTHORIZED").
  return typeof status === "string";
}

/** Che identifier trước khi ghi audit: `phuongtrang/ow***`, `platform/kh***`, email → maskEmail. */
function maskIdentifier(identifier: string): string {
  const value = identifier.trim();
  if (value.includes("@")) {
    return maskEmail(value);
  }
  const slash = value.lastIndexOf("/");
  const prefix = slash >= 0 ? value.slice(0, slash + 1) : "";
  const username = slash >= 0 ? value.slice(slash + 1) : value;
  return `${prefix}${username.slice(0, 2)}***`;
}
