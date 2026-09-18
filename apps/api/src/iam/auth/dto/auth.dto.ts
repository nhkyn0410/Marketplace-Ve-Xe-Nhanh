import { createZodDto } from "nestjs-zod";
import { z } from "zod";

// ── Request DTOs (Zod tại boundary, nestjs-zod) ──
export class RegisterDto extends createZodDto(
  z.object({ email: z.email() })
) {}

export class OtpRequestDto extends createZodDto(
  z.object({ email: z.email() })
) {}

export class OtpVerifyDto extends createZodDto(
  z.object({
    email: z.email(),
    otp: z.string().min(4).max(10)
  })
) {}

/** Login Operator/Employee + Platform: identifier = `{slug}/{username}` hoặc `platform/{username}`. */
export class CredentialLoginDto extends createZodDto(
  z.object({
    identifier: z.string().min(3).max(160),
    password: z.string().min(1).max(200)
  })
) {}

export class OAuthInitDto extends createZodDto(
  z.object({ callbackURL: z.url().optional() })
) {}

/** Refresh token opaque (43 ký tự base64url); trần 200 chỉ để chặn payload rác. */
export class RefreshTokenDto extends createZodDto(
  z.object({ refreshToken: z.string().min(1).max(200) })
) {}

/** Passenger gửi `otp` (xin mã qua `/auth/otp/request`); Operator/Employee/Platform gửi `password`. */
export class ReauthDto extends createZodDto(
  z
    .object({
      password: z.string().min(1).max(200).optional(),
      otp: z.string().min(4).max(10).optional()
    })
    .refine((body) => (body.password === undefined) !== (body.otp === undefined), {
      message: "Gửi đúng một trong hai: password hoặc otp."
    })
) {}

// ── Response schemas + DTOs ──
export const AuthTokenResponseSchema = z.object({
  accessToken: z.string(),
  tokenType: z.literal("Bearer"),
  expiresIn: z.number().int().positive(),
  scope: z.enum(["passenger", "operator", "platform"]),
  role: z.string(),
  // IAM-002 — thêm field, KHÔNG đổi tên field cũ (client Dart đang dùng).
  refreshToken: z.string(),
  refreshExpiresIn: z.number().int().positive()
});
export type AuthTokenResponse = z.infer<typeof AuthTokenResponseSchema>;
export class AuthTokenResponseDto extends createZodDto(AuthTokenResponseSchema) {}

export const MessageResponseSchema = z.object({ status: z.literal("ok") });
export type MessageResponse = z.infer<typeof MessageResponseSchema>;
export class MessageResponseDto extends createZodDto(MessageResponseSchema) {}

export const OAuthRedirectResponseSchema = z.object({ redirectUrl: z.url() });
export type OAuthRedirectResponse = z.infer<typeof OAuthRedirectResponseSchema>;
export class OAuthRedirectResponseDto extends createZodDto(OAuthRedirectResponseSchema) {}
