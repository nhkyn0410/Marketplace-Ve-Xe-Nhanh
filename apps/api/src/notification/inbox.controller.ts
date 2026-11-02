import { Controller, Get, HttpCode, Inject, Param, ParseUUIDPipe, Post, Query } from "@nestjs/common";
import { ApiParam, ApiTags } from "@nestjs/swagger";
import { NotificationInboxPageSchema, NotificationInboxQuerySchema, NotificationUnreadCountSchema } from "@vexenhanh/types";
import { createZodDto, ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize } from "../iam/role/authorize.decorator";
import { InboxService } from "./inbox.service";

class InboxPageDto extends createZodDto(NotificationInboxPageSchema) {}
class InboxQueryDto extends createZodDto(NotificationInboxQuerySchema) {}
class UnreadCountDto extends createZodDto(NotificationUnreadCountSchema) {}

/** Hộp thư thông báo trong app của tài khoản đang đăng nhập (TASK-NSR-003). */
@ApiTags("notification")
@Controller("me/inbox")
export class InboxController {
  constructor(@Inject(InboxService) private readonly inbox: InboxService) {}

  /** Tin mới nhất trước, kèm số tin chưa đọc. */
  @Get() @Authorize("notification:manage") @ZodResponse({ status: 200, type: InboxPageDto, description: "Hộp thư của tôi." })
  list(@CurrentUser() user: VerifiedAccessToken, @Query() query: InboxQueryDto) { return this.inbox.list(user, query); }

  /** Số tin chưa đọc. */
  @Get("unread-count") @Authorize("notification:manage") @ZodResponse({ status: 200, type: UnreadCountDto, description: "Số tin chưa đọc." })
  unreadCount(@CurrentUser() user: VerifiedAccessToken) { return this.inbox.unreadCount(user); }

  /** Đánh dấu tất cả đã đọc. */
  @Post("read-all") @HttpCode(204) @Authorize("notification:manage")
  markAllRead(@CurrentUser() user: VerifiedAccessToken) { return this.inbox.markAllRead(user); }

  /** Đánh dấu một tin đã đọc. */
  @Post(":messageId/read") @HttpCode(204) @Authorize("notification:manage")
  @ApiParam({ name: "messageId", type: String, format: "uuid" })
  markRead(@CurrentUser() user: VerifiedAccessToken, @Param("messageId", new ParseUUIDPipe()) messageId: string) { return this.inbox.markRead(user, messageId); }
}
