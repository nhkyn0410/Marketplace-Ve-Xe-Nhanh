import { Body, Controller, Get, HttpCode, Param, Post, Req } from "@nestjs/common";
import { ApiExtraModels, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import type { Request } from "express";
import { ZodResponse } from "nestjs-zod";
import { ProblemDetailsDto } from "../../openapi/openapi.dto";
import { AuthService, type LoginResult, type RequestContext } from "./auth.service";
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

@ApiTags("auth")
@ApiExtraModels(ProblemDetailsDto)
@Controller("auth")
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post("register")
  @HttpCode(200)
  @ZodResponse({ status: 200, description: "Gửi OTP đăng ký Passenger (Email).", type: MessageResponseDto })
  async register(@Body() dto: RegisterDto): Promise<MessageResponse> {
    await this.authService.register(dto.email, dto.name);
    return { status: "ok" };
  }

  @Post("otp/request")
  @HttpCode(200)
  @ZodResponse({ status: 200, description: "Gửi Email OTP (Resend/console).", type: MessageResponseDto })
  @ApiResponse({ status: 429, description: "Vượt giới hạn OTP.", content: problemContent })
  async requestOtp(@Body() dto: OtpRequestDto): Promise<MessageResponse> {
    await this.authService.requestOtp(dto.email);
    return { status: "ok" };
  }

  @Post("otp/verify")
  @HttpCode(200)
  @ZodResponse({ status: 200, description: "Xác thực OTP → cấp access token.", type: AuthTokenResponseDto })
  @ApiResponse({ status: 401, description: "OTP không hợp lệ.", content: problemContent })
  async verifyOtp(@Body() dto: OtpVerifyDto, @Req() req: Request): Promise<AuthTokenResponse> {
    return toTokenResponse(await this.authService.verifyOtp(dto.email, dto.otp, context(req)));
  }

  @Post("operator/login")
  @HttpCode(200)
  @ZodResponse({ status: 200, description: "Login Operator/Employee `{slug}/{username}`.", type: AuthTokenResponseDto })
  @ApiResponse({ status: 401, description: "Sai thông tin đăng nhập.", content: problemContent })
  @ApiResponse({ status: 403, description: "Tài khoản bị khóa.", content: problemContent })
  async operatorLogin(@Body() dto: CredentialLoginDto, @Req() req: Request): Promise<AuthTokenResponse> {
    return toTokenResponse(await this.authService.operatorLogin(dto.identifier, dto.password, context(req)));
  }

  @Post("platform/login")
  @HttpCode(200)
  @ZodResponse({ status: 200, description: "Login Platform `platform/{username}`.", type: AuthTokenResponseDto })
  @ApiResponse({ status: 401, description: "Sai thông tin đăng nhập.", content: problemContent })
  @ApiResponse({ status: 403, description: "Tài khoản bị khóa.", content: problemContent })
  async platformLogin(@Body() dto: CredentialLoginDto, @Req() req: Request): Promise<AuthTokenResponse> {
    return toTokenResponse(await this.authService.platformLogin(dto.identifier, dto.password, context(req)));
  }

  @Post("oauth/:provider")
  @HttpCode(200)
  @ZodResponse({ status: 200, description: "Khởi tạo OAuth (Google/Facebook/Apple).", type: OAuthRedirectResponseDto })
  async oauth(
    @Param("provider") provider: string,
    @Body() dto: OAuthInitDto
  ): Promise<OAuthRedirectResponse> {
    return { redirectUrl: await this.authService.oauthInit(provider, dto.callbackURL) };
  }

  @Get("session")
  @ZodResponse({ status: 200, description: "Đổi Better Auth session (sau OAuth) → access token.", type: AuthTokenResponseDto })
  async session(@Req() req: Request): Promise<AuthTokenResponse> {
    return toTokenResponse(await this.authService.exchangeSession(toHeaders(req), context(req)));
  }
}

function context(req: Request): RequestContext {
  const userAgent = req.headers["user-agent"];
  return {
    ip: req.ip,
    userAgent: typeof userAgent === "string" ? userAgent : undefined
  };
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
