import { Body, Controller, Get, HttpCode, Inject, Post, Query } from "@nestjs/common";
import { ApiBody, ApiQuery, ApiTags } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { permissionDenied } from "../iam/role/authorization.errors";
import { CounterCommissionService } from "./counter-commission.service";
import { CounterCommissionOverviewDto, CounterCommissionQueryDto, CounterCommissionSettlementDto, CounterCommissionSettlementInputDto } from "./dto/counter-commission.dto";

/** API Platform đối soát và ghi nhận phí bán vé quầy đã thu từ nhà xe. */
@ApiTags("admin-counter-commissions")
@Controller("admin/counter-commissions")
export class CounterCommissionController {
  constructor(@Inject(CounterCommissionService) private readonly commission: CounterCommissionService) {}

  /** Xem số phí còn phải thu, khoản phát sinh và các lần thu phí. */
  @Get()
  @Authorize("finance:read")
  @ApiQuery({ name: "operatorId", type: String, format: "uuid" })
  @ApiQuery({ name: "from", required: false, type: String, format: "date-time" })
  @ApiQuery({ name: "to", required: false, type: String, format: "date-time" })
  @ZodResponse({ status: 200, type: CounterCommissionOverviewDto })
  overview(@Authz() authz: Authorization, @Query() query: CounterCommissionQueryDto) {
    if (authz.db?.kind !== "platform") throw permissionDenied();
    return this.commission.overview(authz, query);
  }

  /** Xác nhận Platform đã nhận một khoản phí bằng bằng chứng và khóa chống lặp. */
  @Post("settlements")
  @HttpCode(200)
  @Authorize("finance:configure", { requireReauth: true })
  @ApiBody({ type: CounterCommissionSettlementInputDto })
  @ZodResponse({ status: 200, type: CounterCommissionSettlementDto })
  settle(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Body() input: CounterCommissionSettlementInputDto) { return this.commission.settle(authz, actor, input); }
}
