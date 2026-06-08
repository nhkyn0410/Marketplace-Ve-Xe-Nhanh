import { createZodDto } from "nestjs-zod";
import { z } from "zod";

// ── Request DTOs (Zod tại boundary, nestjs-zod) ──
export class RegisterDto extends createZodDto(
  z.object({
    email: z.email(),
    name: z.string().min(1).max(120).optional()
  })
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

// ── Response schemas + DTOs ──
export const AuthTokenResponseSchema = z.object({
  accessToken: z.string(),
  tokenType: z.literal("Bearer"),
  expiresIn: z.number().int().positive(),
  scope: z.enum(["passenger", "operator", "platform"]),
  role: z.string()
});
export type AuthTokenResponse = z.infer<typeof AuthTokenResponseSchema>;
export class AuthTokenResponseDto extends createZodDto(AuthTokenResponseSchema) {}

export const MessageResponseSchema = z.object({ status: z.literal("ok") });
export type MessageResponse = z.infer<typeof MessageResponseSchema>;
export class MessageResponseDto extends createZodDto(MessageResponseSchema) {}

export const OAuthRedirectResponseSchema = z.object({ redirectUrl: z.url() });
export type OAuthRedirectResponse = z.infer<typeof OAuthRedirectResponseSchema>;
export class OAuthRedirectResponseDto extends createZodDto(OAuthRedirectResponseSchema) {}
