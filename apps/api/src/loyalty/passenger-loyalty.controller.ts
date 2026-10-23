import { Body, Controller, Get, Headers, HttpCode, Inject, Post, Query } from "@nestjs/common";
import { ApiBody, ApiHeader, ApiTags } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize } from "../iam/role/authorize.decorator";
import { LoyaltyRedemptionInputDto, PassengerLoyaltyDto, PassengerLoyaltyTransactionsDto, PassengerLoyaltyTransactionsQueryDto, SaveVoucherInputDto, UserVoucherDto, UserVoucherPageDto, VoucherListQueryDto } from "./dto/passenger-loyalty.dto";
import { idempotencyKeyInvalid } from "./loyalty.errors";
import { PassengerLoyaltyService } from "./passenger-loyalty.service";

/** API thành viên và ví voucher của hành khách đang đăng nhập. */
@ApiTags("passenger-loyalty")
@Controller("me")
export class PassengerLoyaltyController {
  constructor(@Inject(PassengerLoyaltyService) private readonly loyalty: PassengerLoyaltyService) {}

  /** Xem điểm, hạng và điều kiện chương trình. */
  @Get("loyalty")
  @Authorize("loyalty:use")
  @ZodResponse({ status: 200, type: PassengerLoyaltyDto })
  member(@CurrentUser() user: VerifiedAccessToken) { return this.loyalty.member(user.sub); }

  /** Xem sổ điểm có phân trang và bộ lọc. */
  @Get("loyalty/transactions")
  @Authorize("loyalty:use")
  @ZodResponse({ status: 200, type: PassengerLoyaltyTransactionsDto })
  transactions(@CurrentUser() user: VerifiedAccessToken, @Query() query: PassengerLoyaltyTransactionsQueryDto) { return this.loyalty.transactions(user.sub, query); }

  /** Đổi điểm một lần theo khóa yêu cầu. */
  @Post("loyalty/redemptions")
  @HttpCode(201)
  @Authorize("loyalty:use")
  @ApiHeader({ name: "Idempotency-Key", required: true, description: "8–128 ký tự chữ, số, gạch ngang hoặc gạch dưới." })
  @ApiBody({ type: LoyaltyRedemptionInputDto })
  @ZodResponse({ status: 201, type: UserVoucherDto })
  redeem(@CurrentUser() user: VerifiedAccessToken, @Headers("idempotency-key") key: string | undefined, @Body() input: LoyaltyRedemptionInputDto) {
    if (!key || !/^[A-Za-z0-9_-]{8,128}$/.test(key)) throw idempotencyKeyInvalid();
    return this.loyalty.redeem(user.sub, input.points, key);
  }

  /** Liệt kê ví voucher thuộc hành khách hiện tại. */
  @Get("vouchers")
  @Authorize("loyalty:use")
  @ZodResponse({ status: 200, type: UserVoucherPageDto })
  vouchers(@CurrentUser() user: VerifiedAccessToken, @Query() query: VoucherListQueryDto) { return this.loyalty.vouchers(user.sub, query); }

  /** Lưu mã đang hiệu lực vào ví. */
  @Post("vouchers")
  @HttpCode(201)
  @Authorize("loyalty:use")
  @ApiBody({ type: SaveVoucherInputDto })
  @ZodResponse({ status: 201, type: UserVoucherDto })
  save(@CurrentUser() user: VerifiedAccessToken, @Body() input: SaveVoucherInputDto) { return this.loyalty.save(user.sub, input.promotionCode); }
}
