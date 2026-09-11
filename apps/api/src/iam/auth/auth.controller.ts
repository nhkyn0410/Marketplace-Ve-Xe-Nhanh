import { Body, Controller, HttpCode, Inject, Logger, Param, Post, Req } from "@nestjs/common";
import { ApiBody, ApiExtraModels, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import type { Request } from "express";
import { ZodResponse } from "nestjs-zod";
import { resolveTrustedClientIp } from "../../common/trusted-client-ip";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";
import { ProblemDetailsDto } from "../../openapi/openapi.dto";
import { AuthService, type LoginResult, type RequestContext, SUPPORTED_OAUTH } from "./auth.service";
import {
  AuthTokenResponseDto,
  type AuthTokenResponse,
  CredentialLoginDto,
  type MessageResponse,
  MessageResponseDto,
  OAuthInitDto,
  type OAuthRedirectResponse,
  OAuthRedirectResponseDto,
  OtpRequestDto,
  OtpVerifyDto,
  RegisterDto
} from "./dto/auth.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } }
};

/**
 * `@ApiBody` / `@ApiParam` phải khai TƯỜNG MINH, không dựa vào suy luận từ `@Body()`/`@Param()`:
 * script `openapi:generate` chạy bằng **tsx** (nền esbuild) — esbuild KHÔNG emit
 * `design:paramtypes`, nên `@nestjs/swagger` không suy ra được kiểu tham số. Thiếu các decorator
 * này thì spec sinh ra không có `requestBody`, client gen (TS lẫn Dart) mất sạch payload mà CI
 * vẫn xanh. Đã có test hồi quy ở `openapi.spec.ts`.
 */
@ApiTags("auth")
@ApiExtraModels(ProblemDetailsDto)
@Controller("auth")
export class AuthController {
  private readonly logger = new Logger(AuthController.name);

  constructor(
    private readonly authService: AuthService,
    @Inject(APP_CONFIG) private readonly config: AppConfig
  ) {}

  @Post("register")
  @HttpCode(200)
  @ApiBody({ type: RegisterDto })
  @ZodResponse({ status: 200, description: "Gửi OTP đăng ký Passenger (Email).", type: MessageResponseDto })
  async register(@Body() dto: RegisterDto): Promise<MessageResponse> {
    await this.authService.register(dto.email);
    return { status: "ok" };
  }

  @Post("otp/request")
  @HttpCode(200)
  @ApiBody({ type: OtpRequestDto })
  @ZodResponse({ status: 200, description: "Gửi Email OTP (Resend/console).", type: MessageResponseDto })
  @ApiResponse({ status: 429, description: "Vượt giới hạn OTP.", content: problemContent })
  async requestOtp(@Body() dto: OtpRequestDto): Promise<MessageResponse> {
    await this.authService.requestOtp(dto.email);
    return { status: "ok" };
  }

  @Post("otp/verify")
  @HttpCode(200)
  @ApiBody({ type: OtpVerifyDto })
  @ZodResponse({ status: 200, description: "Xác thực OTP → cấp access token.", type: AuthTokenResponseDto })
  @ApiResponse({ status: 401, description: "OTP không hợp lệ.", content: problemContent })
  async verifyOtp(@Body() dto: OtpVerifyDto, @Req() req: Request): Promise<AuthTokenResponse> {
    return toTokenResponse(
      await this.authService.verifyOtp(dto.email, dto.otp, this.context(req))
    );
  }

  @Post("operator/login")
  @HttpCode(200)
  @ApiBody({ type: CredentialLoginDto })
  @ZodResponse({ status: 200, description: "Login Operator/Employee `{slug}/{username}`.", type: AuthTokenResponseDto })
  @ApiResponse({ status: 401, description: "Sai thông tin đăng nhập.", content: problemContent })
  @ApiResponse({ status: 403, description: "Tài khoản bị khóa.", content: problemContent })
  async operatorLogin(@Body() dto: CredentialLoginDto, @Req() req: Request): Promise<AuthTokenResponse> {
    return toTokenResponse(
      await this.authService.operatorLogin(
        dto.identifier,
        dto.password,
        this.context(req)
      )
    );
  }

  @Post("platform/login")
  @HttpCode(200)
  @ApiBody({ type: CredentialLoginDto })
  @ZodResponse({ status: 200, description: "Login Platform `platform/{username}`.", type: AuthTokenResponseDto })
  @ApiResponse({ status: 401, description: "Sai thông tin đăng nhập.", content: problemContent })
  @ApiResponse({ status: 403, description: "Tài khoản bị khóa.", content: problemContent })
  async platformLogin(@Body() dto: CredentialLoginDto, @Req() req: Request): Promise<AuthTokenResponse> {
    return toTokenResponse(
      await this.authService.platformLogin(
        dto.identifier,
        dto.password,
        this.context(req)
      )
    );
  }

  @Post("oauth/:provider")
  @HttpCode(200)
  @ApiParam({ name: "provider", enum: SUPPORTED_OAUTH, description: "OAuth provider (v1: google)." })
  @ApiBody({ type: OAuthInitDto })
  @ZodResponse({ status: 200, description: "Khởi tạo OAuth (v1: Google).", type: OAuthRedirectResponseDto })
  async oauth(
    @Param("provider") provider: string,
    @Body() dto: OAuthInitDto
  ): Promise<OAuthRedirectResponse> {
    return { redirectUrl: await this.authService.oauthInit(provider, dto.callbackURL) };
  }

  /**
   * POST chứ không phải GET: mỗi lần gọi đều mint token mới + ghi 1 bản ghi audit vào collection
   * append-only (không xoá được). GET phải idempotent — prefetch/retry của trình duyệt sẽ bơm rác.
   */
  @Post("oauth/session")
  @HttpCode(200)
  @ZodResponse({ status: 200, description: "Đổi Better Auth session (sau OAuth callback) → access token.", type: AuthTokenResponseDto })
  async oauthSession(@Req() req: Request): Promise<AuthTokenResponse> {
    return toTokenResponse(
      await this.authService.exchangeSession(
        toHeaders(req),
        this.context(req)
      )
    );
  }

  private context(req: Request): RequestContext {
    const ip = resolveTrustedClientIp(req, this.config.NODE_ENV);
    if (this.config.NODE_ENV === "production" && !ip) {
      const cfRay = req.headers["cf-ray"];
      this.logger.warn(
        `Auth request không có client IP đáng tin cậy (cfRay=${typeof cfRay === "string" ? cfRay : "missing"}).`
      );
    }

    const userAgent = req.headers["user-agent"];
    return {
      ip,
      userAgent: typeof userAgent === "string" ? userAgent : undefined
    };
  }
}

function toHeaders(req: Request): Headers {
  const headers = new Headers();
  for (const [key, value] of Object.entries(req.headers)) {
    if (typeof value === "string") {
      headers.set(key, value);
    } else if (Array.isArray(value)) {
      headers.set(key, value.join(", "));
    }
  }
  return headers;
}

function toTokenResponse(result: LoginResult): AuthTokenResponse {
  return {
    accessToken: result.accessToken,
    tokenType: result.tokenType,
    expiresIn: result.expiresInSeconds,
    scope: result.scope,
    role: result.role
  };
}
