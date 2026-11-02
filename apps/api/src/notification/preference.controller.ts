import { Body, Controller, Delete, Get, HttpCode, Inject, Param, Post, Put, Query } from "@nestjs/common";
import { ApiTags } from "@nestjs/swagger";
import { createZodDto, ZodResponse } from "nestjs-zod";
import { NotificationLogQuerySchema, NotificationLogSchema, NotificationPreferenceInputSchema, NotificationPreferencesSchema, PushDeviceInputSchema } from "@vexenhanh/types";
import { z } from "zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { PreferenceService } from "./preference.service";

class PreferenceInputDto extends createZodDto(NotificationPreferenceInputSchema) {}
class PreferencesDto extends createZodDto(NotificationPreferencesSchema) {}
class DeviceInputDto extends createZodDto(PushDeviceInputSchema) {}
class DeviceDto extends createZodDto(z.object({ id: z.uuid(), provider: z.string(), active: z.boolean() })) {}
class DeviceIdDto extends createZodDto(z.object({ id: z.uuid() })) {}
class HistoryQueryDto extends createZodDto(NotificationLogQuerySchema) {}
/** Nhật ký gửi đã che thông tin người nhận. */
export class NotificationLogDto extends createZodDto(NotificationLogSchema) {}

/** API thông báo cá nhân của hành khách, nhà xe, nhân viên và tài khoản nền tảng. */
@ApiTags("notification")
@Controller("me")
export class PreferenceController {
  constructor(@Inject(PreferenceService) private readonly service: PreferenceService) {}

  /** Lấy tùy chọn nhận theo loại và kênh. */
  @Get("notification-preferences") @Authorize("notification:manage") @ZodResponse({ status: 200, type: PreferencesDto, description: "Tùy chọn nhận thông báo." })
  preferences(@CurrentUser() user: VerifiedAccessToken) { return this.service.preferences(user); }

  /** Cập nhật tùy chọn nhận một loại thông báo. */
  @Put("notification-preferences") @Authorize("notification:manage") @ZodResponse({ status: 200, type: PreferencesDto, description: "Tùy chọn đã lưu." })
  save(@CurrentUser() user: VerifiedAccessToken, @Body() input: PreferenceInputDto) { return this.service.save(user, input); }

  /** Đăng ký thiết bị nhận push của phiên hiện tại. */
  @Post("push-devices") @Authorize("notification:manage") @ZodResponse({ status: 201, type: DeviceDto, description: "Thiết bị nhận push." })
  device(@CurrentUser() user: VerifiedAccessToken, @Body() input: DeviceInputDto) { return this.service.registerDevice(user, input); }

  /** Hủy đăng ký một thiết bị của chính tài khoản. */
  @Delete("push-devices/:id") @HttpCode(204) @Authorize("notification:manage")
  remove(@CurrentUser() user: VerifiedAccessToken, @Param() params: DeviceIdDto) { return this.service.removeDevice(user, params.id); }

  /** Tra cứu nhật ký gửi không chứa địa chỉ hoặc token nguyên bản. */
  @Get("notifications") @Authorize("notification:manage") @ZodResponse({ status: 200, type: NotificationLogDto, description: "Nhật ký thông báo của tôi." })
  history(@CurrentUser() user: VerifiedAccessToken, @Query() query: HistoryQueryDto) { return this.service.history(user, query); }
}

/** Nhật ký giao nhận cho Admin vận hành, không trả token thiết bị hoặc email đầy đủ. */
@ApiTags("admin-notification")
@Controller("admin/system")
export class AdminNotificationController {
  constructor(@Inject(PreferenceService) private readonly service: PreferenceService) {}

  /** Tra cứu các bản gửi để theo dõi hàng đợi và lỗi giao nhận. */
  @Get("notifications") @Authorize("system:read") @ZodResponse({ status: 200, type: NotificationLogDto, description: "Nhật ký gửi thông báo." })
  history(@Authz() authz: Authorization, @Query() query: HistoryQueryDto) { return this.service.adminHistory(authz, query); }
}
