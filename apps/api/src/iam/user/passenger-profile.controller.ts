import { Body, Controller, Delete, Get, HttpCode, Inject, Param, ParseUUIDPipe, Post, Put, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiQuery, ApiTags } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../auth/current-user.decorator";
import type { VerifiedAccessToken } from "../auth/token.service";
import { Authorize } from "../role/authorize.decorator";
import { PassengerProfileService } from "./passenger-profile.service";
import { PassengerBookingPageDto, PassengerDisputePageDto, PassengerPageQueryDto, PassengerProfileDto, PassengerProfileUpdateDto, PassengerSupportPageDto, PassengerTicketPageDto, SavedPassengerDto, SavedPassengerInputDto, SavedPassengerListDto } from "./dto/passenger-profile.dto";

/** Hồ sơ và danh sách tài nguyên riêng của hành khách đăng nhập (MKT-002). */
@ApiTags("passenger-profile")
@Controller("me")
export class PassengerProfileController {
  constructor(@Inject(PassengerProfileService) private readonly profiles: PassengerProfileService) {}

  /** Đọc hồ sơ của tài khoản hiện tại. */
  @Get("profile") @Authorize("profile:manage")
  @ZodResponse({ status: 200, type: PassengerProfileDto })
  get(@CurrentUser() actor: VerifiedAccessToken) { return this.profiles.get(actor); }

  /** Cập nhật hồ sơ của tài khoản hiện tại. */
  @Put("profile") @Authorize("profile:manage") @ApiBody({ type: PassengerProfileUpdateDto })
  @ZodResponse({ status: 200, type: PassengerProfileDto })
  update(@CurrentUser() actor: VerifiedAccessToken, @Body() input: PassengerProfileUpdateDto) { return this.profiles.update(actor, input); }

  /** Liệt kê hành khách thường dùng. */
  @Get("saved-passengers") @Authorize("profile:manage")
  @ZodResponse({ status: 200, type: SavedPassengerListDto })
  saved(@CurrentUser() actor: VerifiedAccessToken) { return this.profiles.saved(actor); }

  /** Tạo hành khách thường dùng. */
  @Post("saved-passengers") @Authorize("profile:manage") @ApiBody({ type: SavedPassengerInputDto })
  @ZodResponse({ status: 201, type: SavedPassengerDto })
  createSaved(@CurrentUser() actor: VerifiedAccessToken, @Body() input: SavedPassengerInputDto) { return this.profiles.createSaved(actor, input); }

  /** Sửa hành khách đã lưu thuộc tài khoản hiện tại. */
  @Put("saved-passengers/:passengerId") @Authorize("profile:manage") @ApiBody({ type: SavedPassengerInputDto })
  @ApiParam({ name: "passengerId", type: String, format: "uuid" })
  @ZodResponse({ status: 200, type: SavedPassengerDto })
  updateSaved(@CurrentUser() actor: VerifiedAccessToken, @Param("passengerId", new ParseUUIDPipe()) id: string, @Body() input: SavedPassengerInputDto) { return this.profiles.updateSaved(actor, id, input); }

  /** Xóa hành khách đã lưu thuộc tài khoản hiện tại. */
  @Delete("saved-passengers/:passengerId") @HttpCode(204) @Authorize("profile:manage")
  @ApiParam({ name: "passengerId", type: String, format: "uuid" })
  deleteSaved(@CurrentUser() actor: VerifiedAccessToken, @Param("passengerId", new ParseUUIDPipe()) id: string) { return this.profiles.deleteSaved(actor, id); }

  /** Liệt kê các đơn của tài khoản hiện tại. */
  @Get("bookings") @Authorize("profile:manage")
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" }) @ApiQuery({ name: "limit", required: false, type: Number })
  @ZodResponse({ status: 200, type: PassengerBookingPageDto })
  bookings(@CurrentUser() actor: VerifiedAccessToken, @Query() query: PassengerPageQueryDto) { return this.profiles.bookings(actor, query); }

  /** Liệt kê vé của tài khoản hiện tại. */
  @Get("tickets") @Authorize("profile:manage")
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" }) @ApiQuery({ name: "limit", required: false, type: Number })
  @ZodResponse({ status: 200, type: PassengerTicketPageDto })
  tickets(@CurrentUser() actor: VerifiedAccessToken, @Query() query: PassengerPageQueryDto) { return this.profiles.tickets(actor, query); }

  /** Liệt kê khiếu nại của tài khoản hiện tại. */
  @Get("support-tickets") @Authorize("profile:manage")
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" }) @ApiQuery({ name: "limit", required: false, type: Number })
  @ZodResponse({ status: 200, type: PassengerSupportPageDto })
  supportTickets(@CurrentUser() actor: VerifiedAccessToken, @Query() query: PassengerPageQueryDto) { return this.profiles.supportTickets(actor, query); }

  /** Liệt kê tranh chấp của tài khoản hiện tại. */
  @Get("disputes") @Authorize("profile:manage")
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" }) @ApiQuery({ name: "limit", required: false, type: Number })
  @ZodResponse({ status: 200, type: PassengerDisputePageDto })
  disputes(@CurrentUser() actor: VerifiedAccessToken, @Query() query: PassengerPageQueryDto) { return this.profiles.disputes(actor, query); }
}
