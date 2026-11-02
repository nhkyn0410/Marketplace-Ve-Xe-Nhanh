import { Controller, Get, HttpCode, Inject, Param, ParseUUIDPipe, Post, Query, Res } from "@nestjs/common";
import { ApiParam, ApiProduces, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import type { Response } from "express";
import { ZodResponse } from "nestjs-zod";
import { BookingStatus, TicketStatus } from "../database/prisma.types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  BookingContactDto,
  OperatorBookingDetailDto,
  OperatorBookingListQueryDto,
  OperatorBookingPageDto,
  TripPassengerListDto,
  TripPassengerQueryDto,
  type BookingContact,
  type OperatorBookingDetail,
  type OperatorBookingPage,
  type TripPassengerList,
} from "./dto/operator-booking.dto";
import { OperatorBookingService } from "./operator-booking.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};

// API §7.3 `/operator/bookings` — chỉ Owner (`booking:read`, tenant lấy từ JWT; FR-OPS-14/15, UC-15).
@ApiTags("operator-bookings")
@Controller("operator")
/** Đơn đặt vé, vé và hành khách thuộc chuyến của nhà xe (TASK-OPR-003). */
export class OperatorBookingController {
  constructor(@Inject(OperatorBookingService) private readonly bookings: OperatorBookingService) {}

  /** Đơn của các chuyến khởi hành trong một ngày, mới đặt trước. */
  @Get("bookings")
  @Authorize("booking:read")
  @ApiQuery({ name: "date", required: true, type: String, format: "date" })
  @ApiQuery({ name: "tripId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "status", required: false, enum: BookingStatus })
  @ApiQuery({ name: "q", required: false, type: String })
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, description: "Một trang đơn (liên hệ đã che).", type: OperatorBookingPageDto })
  @ApiResponse({ status: 400, description: "Query không hợp lệ.", content: problemContent })
  list(@Authz() authz: Authorization, @Query() query: OperatorBookingListQueryDto): Promise<OperatorBookingPage> {
    return this.bookings.list(authz, query);
  }

  @Get("bookings/:bookingId")
  @Authorize("booking:read")
  @ApiParam({ name: "bookingId", type: String, format: "uuid" })
  @ZodResponse({ status: 200, description: "Chi tiết đơn (liên hệ đã che).", type: OperatorBookingDetailDto })
  @ApiResponse({ status: 404, description: "`BOOKING_NOT_FOUND` (kể cả của nhà xe khác).", content: problemContent })
  get(@Authz() authz: Authorization, @Param("bookingId", new ParseUUIDPipe()) bookingId: string): Promise<OperatorBookingDetail> {
    return this.bookings.get(authz, bookingId);
  }

  /** Xem đầy đủ số điện thoại / email của đơn — mỗi lần ghi nhật ký audit. */
  @Post("bookings/:bookingId/contact-reveal")
  @HttpCode(200)
  @Authorize("booking:read")
  @ApiParam({ name: "bookingId", type: String, format: "uuid" })
  @ZodResponse({ status: 200, description: "Liên hệ đầy đủ.", type: BookingContactDto })
  @ApiResponse({ status: 404, description: "`BOOKING_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được nhật ký — không trả dữ liệu.", content: problemContent })
  revealContact(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("bookingId", new ParseUUIDPipe()) bookingId: string,
  ): Promise<BookingContact> {
    return this.bookings.revealContact(actor, authz, bookingId);
  }

  /** Hành khách đã có vé của một chuyến (theo chỗ) kèm số liệu lên xe. */
  @Get("trips/:tripId/passengers")
  @Authorize("booking:read")
  @ApiParam({ name: "tripId", type: String, format: "uuid" })
  @ApiQuery({ name: "pickupSequence", required: false, type: Number, minimum: 1 })
  @ApiQuery({ name: "ticketStatus", required: false, enum: TicketStatus })
  @ApiQuery({ name: "q", required: false, type: String })
  @ZodResponse({ status: 200, description: "Danh sách hành khách (số điện thoại đã che).", type: TripPassengerListDto })
  @ApiResponse({ status: 404, description: "`TRIP_NOT_FOUND` (kể cả của nhà xe khác).", content: problemContent })
  passengers(
    @Authz() authz: Authorization,
    @Param("tripId", new ParseUUIDPipe()) tripId: string,
    @Query() query: TripPassengerQueryDto,
  ): Promise<TripPassengerList> {
    return this.bookings.passengers(authz, tripId, query);
  }

  /** Xuất danh sách hành khách (CSV, số điện thoại đầy đủ) — mỗi lần ghi nhật ký audit. */
  @Get("trips/:tripId/passengers/export")
  @Authorize("booking:read")
  @ApiParam({ name: "tripId", type: String, format: "uuid" })
  @ApiProduces("text/csv")
  @ApiResponse({ status: 200, description: "Tệp CSV (UTF-8, có BOM).", content: { "text/csv": { schema: { type: "string" } } } })
  @ApiResponse({ status: 404, description: "`TRIP_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được nhật ký — không xuất.", content: problemContent })
  async exportPassengers(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("tripId", new ParseUUIDPipe()) tripId: string,
    @Res() res: Response,
  ): Promise<void> {
    const { filename, csv } = await this.bookings.exportPassengers(actor, authz, tripId);
    res
      .status(200)
      .setHeader("content-type", "text/csv; charset=utf-8")
      .setHeader("content-disposition", `attachment; filename="${filename}"`)
      .setHeader("cache-control", "no-store")
      .send(csv);
  }
}
