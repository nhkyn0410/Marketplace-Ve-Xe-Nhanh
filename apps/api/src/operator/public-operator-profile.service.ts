import { Inject, Injectable } from "@nestjs/common";
import type { PassengerPageQuery, PublicOperatorProfile } from "@vexenhanh/types";
import { loadPublicOperatorProfile } from "../database/public-operator-profile";
import { PrismaService } from "../database/prisma.service";
import { AuthException } from "../iam/auth/auth.errors";

/** Hồ sơ công khai của nhà xe và scorecard chỉ dùng dữ liệu được phép hiển thị. */
@Injectable()
export class PublicOperatorProfileService {
  constructor(@Inject(PrismaService) private readonly prisma: PrismaService) {}

  /** Đọc hồ sơ và review công khai; nhà xe bị khóa không xuất hiện. */
  async get(operatorId: string, query: PassengerPageQuery): Promise<PublicOperatorProfile> {
    const profile = await loadPublicOperatorProfile(this.prisma, operatorId, query, new Date());
    if (!profile) throw new AuthException(404, "OPERATOR_NOT_FOUND", "Không tìm thấy nhà xe.");
    return profile;
  }
}
