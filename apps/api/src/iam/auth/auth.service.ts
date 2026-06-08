import { HttpStatus, Inject, Injectable } from "@nestjs/common";
import { PrismaService } from "../../database/prisma.service";
import { maskEmail } from "../../external/notification/email-notifier";
import { type Auth } from "./auth.config";
import { BETTER_AUTH, PASSENGER_ROLE } from "./auth.constants";
import { accountLocked, AuthException, invalidCredentials, wrongLoginChannel } from "./auth.errors";
import { CredentialService } from "./credential.service";
import { LoginHistoryService } from "./login-history.service";
import { resolveIdentifier } from "./namespace.resolver";
import { OtpRateLimiter } from "./otp-rate-limiter";
import { type AuthScope, type IssuedAccessToken, TokenService } from "./token.service";

const SUPPORTED_OAUTH = ["google", "facebook", "apple"] as const;
type OAuthProvider = (typeof SUPPORTED_OAUTH)[number];

/** Hash giả (đúng format) để verify khi account không tồn tại → cân bằng thời gian, chống enumeration. */
const DUMMY_PASSWORD_HASH = `scrypt$${Buffer.alloc(16).toString("base64")}$${Buffer.alloc(64).toString("base64")}`;

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
  constructor(
    @Inject(BETTER_AUTH) private readonly auth: Auth,
    private readonly prisma: PrismaService,
    private readonly tokens: TokenService,
    private readonly credentials: CredentialService,
    private readonly otpRateLimiter: OtpRateLimiter,
    private readonly loginHistory: LoginHistoryService
  ) {}

  // ── Passenger (Better Auth: email-OTP) ──
  async register(email: string, _name: string | undefined): Promise<void> {
    await this.sendSignInOtp(email);
  }

  async requestOtp(email: string): Promise<void> {
    await this.sendSignInOtp(email);
  }

  private async sendSignInOtp(email: string): Promise<void> {
    await this.otpRateLimiter.assertCanRequest(email);
    try {
      await this.auth.api.sendVerificationOTP({ body: { email, type: "sign-in" } });
    } catch {
      // KHÔNG leak gửi thành công/thất bại (account enumeration) — luôn trả 200.
    }
  }

  async verifyOtp(email: string, otp: string, ctx: RequestContext): Promise<LoginResult> {
    let userId: string;
    try {
      const result = await this.auth.api.signInEmailOTP({ body: { email, otp } });
      userId = result.user.id;
    } catch {
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
    const resolved = resolveIdentifier(identifier);
    if (!resolved || resolved.scope !== "operator") {
      throw wrongLoginChannel();
    }
    const { operatorSlug, username } = resolved;

    const operator = await this.prisma.operatorProfile.findUnique({ where: { operatorSlug } });
    const account = operator
      ? await this.findOperatorSideAccount(operator.id, operatorSlug, username)
      : null;

    if (!operator || !account) {
      await this.credentials.verify(password, DUMMY_PASSWORD_HASH);
      throw invalidCredentials();
    }

    await this.verifyOrThrow(password, account, "operator", operatorSlug, ctx, !isActive(operator.status));

    return this.issueCredentialToken("operator", account, operatorSlug, ctx);
  }

  // ── Platform (custom, `platform/{username}` + password) ──
  async platformLogin(identifier: string, password: string, ctx: RequestContext): Promise<LoginResult> {
    const resolved = resolveIdentifier(identifier);
    if (!resolved || resolved.scope !== "platform") {
      throw wrongLoginChannel();
    }

    const row = await this.prisma.platformAccount.findUnique({ where: { username: resolved.username } });
    const account: CredentialAccount | null = row
      ? { id: row.id, passwordHash: row.passwordHash, role: String(row.role), status: String(row.status) }
      : null;

    if (!account) {
      await this.credentials.verify(password, DUMMY_PASSWORD_HASH);
      throw invalidCredentials();
    }

    await this.verifyOrThrow(password, account, "platform", undefined, ctx, false);

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
    const result = await this.auth.api.signInSocial({
      body: { provider: provider as OAuthProvider, callbackURL }
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
    if (owner) {
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

  private async verifyOrThrow(
    password: string,
    account: CredentialAccount,
    scope: AuthScope,
    operatorSlug: string | undefined,
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
