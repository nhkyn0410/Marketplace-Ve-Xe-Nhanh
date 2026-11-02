import { Body, Controller, Delete, Get, HttpCode, Inject, Param, ParseUUIDPipe, Post, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { CounterSalesService } from "./counter-sales.service";
import { CounterBookingDto, CounterBookingInputDto, CounterBookingListDto, CounterBookingListQueryDto, CounterHoldDto, CounterHoldInputDto, CounterReceiptInputDto, CounterReceiptResultDto, CounterReportDto, CounterTripListDto, CounterTripsQueryDto } from "./dto/counter-sales.dto";

const problemContent = { "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } } };
const bookingParam = { name: "bookingId", type: String, format: "uuid" };
const holdParam = { name: "holdId", type: String, format: "uuid" };

/** API bán vé quầy cho chủ nhà xe và nhân viên bán vé, lấy tenant và người bán từ phiên đăng nhập. */
@ApiTags("counter-sales")
@Controller("operator/counter")
export class CounterSalesController {
  constructor(@Inject(CounterSalesService) private readonly sales: CounterSalesService) {}

  /** Danh sách chuyến còn bán quầy, độc lập cutoff online. */
  @Get("trips")
  @Authorize("counter:sell")
  @ApiQuery({ name: "officeId", type: String, format: "uuid" })
  @ApiQuery({ name: "date", type: String, format: "date" })
  @ZodResponse({ status: 200, type: CounterTripListDto })
  trips(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Query() query: CounterTripsQueryDto) { return this.sales.trips(actor, authz, query); }

  /** Đối soát khoản thu trong ngày của văn phòng được cấp. */
  @Get("report")
  @Authorize("counter:read")
  @ApiQuery({ name: "officeId", type: String, format: "uuid" })
  @ApiQuery({ name: "date", type: String, format: "date" })
  @ZodResponse({ status: 200, type: CounterReportDto })
  report(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Query() query: CounterTripsQueryDto) { return this.sales.report(actor, authz, query); }

  /** Giữ chỗ tại văn phòng được cấp cho người bán. */
  @Post("holds")
  @Authorize("counter:sell")
  @ApiBody({ type: CounterHoldInputDto })
  @ZodResponse({ status: 201, type: CounterHoldDto })
  hold(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Body() input: CounterHoldInputDto) { return this.sales.hold(actor, authz, input); }

  /** Xem phiên giữ chỗ của chính người bán. */
  @Get("holds/:holdId")
  @Authorize("counter:sell")
  @ApiParam(holdParam)
  @ZodResponse({ status: 200, type: CounterHoldDto })
  getHold(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("holdId", new ParseUUIDPipe()) holdId: string) { return this.sales.getHold(actor, authz, holdId); }

  /** Nhả chỗ khi quay lại chọn chuyến hoặc ghế khác. */
  @Delete("holds/:holdId")
  @HttpCode(204)
  @Authorize("counter:sell")
  @ApiParam(holdParam)
  @ApiResponse({ status: 204, description: "Đã nhả phiên giữ chỗ." })
  release(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("holdId", new ParseUUIDPipe()) holdId: string) { return this.sales.release(actor, authz, holdId); }

  /** Tạo đơn quầy, máy chủ lưu văn phòng và người bán của phiên giữ chỗ. */
  @Post("bookings")
  @Authorize("counter:sell")
  @ApiBody({ type: CounterBookingInputDto })
  @ZodResponse({ status: 201, type: CounterBookingDto })
  create(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Body() input: CounterBookingInputDto) { return this.sales.create(actor, authz, input); }

  /** Danh sách đơn và khoản thu theo văn phòng được cấp. */
  @Get("bookings")
  @Authorize("counter:read")
  @ApiQuery({ name: "officeId", type: String, format: "uuid" })
  @ApiQuery({ name: "cursor", type: String, format: "uuid", required: false })
  @ApiQuery({ name: "limit", type: Number, required: false, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, type: CounterBookingListDto })
  list(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Query() query: CounterBookingListQueryDto) { return this.sales.list(actor, authz, query); }

  /** Đọc đơn hoặc in lại QR đã phát; không phát sinh khoản thu mới. */
  @Get("bookings/:bookingId")
  @Authorize("counter:read")
  @ApiParam(bookingParam)
  @ZodResponse({ status: 200, type: CounterBookingDto })
  get(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("bookingId", new ParseUUIDPipe()) bookingId: string) { return this.sales.get(actor, authz, bookingId); }

  /** Ghi nhận tiền đã thực thu, phản hồi ngoại lệ khi chưa đủ điều kiện phát vé. */
  @Post("bookings/:bookingId/receipts")
  @HttpCode(200)
  @Authorize("counter:collect")
  @ApiParam(bookingParam)
  @ApiBody({ type: CounterReceiptInputDto })
  @ZodResponse({ status: 200, type: CounterReceiptResultDto })
  @ApiResponse({ status: 409, description: "Mã thao tác hoặc tham chiếu chuyển khoản đã được sử dụng.", content: problemContent })
  collect(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("bookingId", new ParseUUIDPipe()) bookingId: string, @Body() input: CounterReceiptInputDto) { return this.sales.collect(actor, authz, bookingId, input); }
}
