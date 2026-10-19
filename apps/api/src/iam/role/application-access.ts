import { createHash, randomBytes } from "node:crypto";
import {
  applyDecorators,
  type CanActivate,
  createParamDecorator,
  type ExecutionContext,
  HttpStatus,
  Inject,
  Injectable,
  UseGuards,
} from "@nestjs/common";
import { ApiHeader, ApiResponse, getSchemaPath } from "@nestjs/swagger";
import { systemScope } from "../../database/db-scope";
import { PrismaService } from "../../database/prisma.service";
import { OperatorApplicationStatus } from "../../database/prisma.types";
import { ProblemDetailsDto } from "../../openapi/openapi.dto";
import { AuthException } from "../auth/auth.errors";
import type { Authorization, AuthorizedRequest } from "./authorization";

/**
 * Người nộp hồ sơ đăng ký nhà xe (BR-75, Security §4–§5, LLD §6.11): chưa có tài khoản, chỉ có link bảo mật gửi
 * email liên hệ. Token 32 byte ngẫu nhiên, DB chỉ giữ SHA-256. Hồ sơ là dữ liệu cấp Platform, RLS chỉ cho scope
 * `platform` / `system` → guard ở đây trao scope `system` cho đúng các route của hồ sơ; service tự lọc theo
 * `applicationId` lấy từ token, không bao giờ từ body / URL.
 */
export const APPLICATION_TOKEN_HEADER = "x-application-token";

/** Token mới cho link bảo mật: chuỗi gửi trong link + hash lưu DB. */
export function newApplicationToken(): { token: string; tokenHash: string } {
  const token = randomBytes(32).toString("base64url");
  return { token, tokenHash: hashApplicationToken(token) };
}

export function hashApplicationToken(token: string): string {
  return createHash("sha256").update(token).digest("hex");
}

/** 32 byte base64url = 43 ký tự; sai dạng thì khỏi tra DB. */
const TOKEN_PATTERN = /^[A-Za-z0-9_-]{43}$/;
/** Hồ sơ đã có kết quả thì link hết hiệu lực (BR-75). */
const CLOSED_STATUSES: ReadonlySet<OperatorApplicationStatus> = new Set([
  OperatorApplicationStatus.APPROVED,
  OperatorApplicationStatus.REJECTED,
]);

/**
 * Link sai, hết hạn, đã bị thay hoặc hồ sơ đã có kết quả — một mã chung, không lộ lý do (LLD §7).
 */
export function applicationLinkInvalid(): AuthException {
  return new AuthException(
    HttpStatus.UNAUTHORIZED,
    "OPERATOR_APPLICATION_LINK_INVALID",
    "Link không còn hiệu lực. Hãy yêu cầu gửi lại link bằng email liên hệ và mã hồ sơ.",
    "Operator application error",
  );
}

/** Hồ sơ mà token của request đang mở. */
export type Applicant = { applicationId: string; linkExpiresAt: Date };

type ApplicantRequest = AuthorizedRequest & { applicant?: Applicant };

// Không có tài khoản nên không có grant theo role; `kyc:submit` + `own` chỉ để kiểu `Authorization` đầy đủ.
function applicationAuthorization(): Authorization {
  return { permission: "kyc:submit", scope: "own", db: systemScope() };
}

/** Route công khai tạo hồ sơ / gửi lại link: chưa có token, chỉ cần ngữ cảnh DB của luồng đăng ký. */
@Injectable()
export class ApplicationPublicGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    context.switchToHttp().getRequest<ApplicantRequest>().authz = applicationAuthorization();
    return true;
  }
}

/**
 * Route của người nộp hồ sơ: header `X-Application-Token` phải khớp một link còn hạn, chưa bị thu hồi, của hồ sơ
 * chưa có kết quả. Lần mở link hợp lệ đầu tiên xác minh email liên hệ (UC-10 bước 3).
 */
@Injectable()
export class ApplicationTokenGuard implements CanActivate {
  constructor(@Inject(PrismaService) private readonly prisma: PrismaService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<ApplicantRequest>();
    const header = request.headers[APPLICATION_TOKEN_HEADER];
    const token = typeof header === "string" ? header : undefined;
    if (!token || !TOKEN_PATTERN.test(token)) {
      throw applicationLinkInvalid();
    }
    const now = new Date();
    const applicant = await this.prisma.withSystem(async (tx) => {
      const link = await tx.operatorApplicationAccessToken.findUnique({
        where: { tokenHash: hashApplicationToken(token) },
        select: {
          applicationId: true,
          expiresAt: true,
          revokedAt: true,
          application: { select: { status: true, contactEmailVerifiedAt: true } },
        },
      });
      if (!link || link.revokedAt || link.expiresAt <= now || CLOSED_STATUSES.has(link.application.status)) {
        return null;
      }
      if (!link.application.contactEmailVerifiedAt) {
        await tx.operatorApplication.updateMany({
          where: { id: link.applicationId, contactEmailVerifiedAt: null },
          data: { contactEmailVerifiedAt: now },
        });
      }
      return { applicationId: link.applicationId, linkExpiresAt: link.expiresAt };
    });
    if (!applicant) {
      throw applicationLinkInvalid();
    }
    request.applicant = applicant;
    request.authz = applicationAuthorization();
    return true;
  }
}

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};

/** Route công khai của luồng đăng ký nhà xe (tạo hồ sơ, gửi lại link). */
export function ApplicationPublicAccess(): MethodDecorator {
  return applyDecorators(UseGuards(ApplicationPublicGuard));
}

/** Route của người nộp hồ sơ, xác thực bằng link bảo mật. */
export function ApplicantAccess(): MethodDecorator {
  return applyDecorators(
    UseGuards(ApplicationTokenGuard),
    ApiHeader({ name: "X-Application-Token", required: true, description: "Token trong link bảo mật gửi email." }),
    ApiResponse({
      status: 401,
      description: "`OPERATOR_APPLICATION_LINK_INVALID` — link sai, hết hạn, đã bị thay hoặc hồ sơ đã có kết quả.",
      content: problemContent,
    }),
  );
}

/** Hồ sơ của link đang dùng; chỉ dùng trên route có `@ApplicantAccess()`. */
export const CurrentApplicant = createParamDecorator((_data: unknown, context: ExecutionContext): Applicant => {
  const applicant = context.switchToHttp().getRequest<ApplicantRequest>().applicant;
  if (!applicant) {
    throw new Error("@CurrentApplicant() dùng trên route thiếu @ApplicantAccess().");
  }
  return applicant;
});
