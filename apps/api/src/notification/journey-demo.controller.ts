import { Body, Controller, Delete, Get, HttpCode, Inject, Param, ParseUUIDPipe, Post, Query } from "@nestjs/common";
import { ApiTags } from "@nestjs/swagger";
import { createZodDto, ZodResponse } from "nestjs-zod";
import { JourneyDemoCurrentSchema, JourneyDemoQuerySchema, JourneyDemoSnapshotSchema, JourneyDemoStartSchema } from "@vexenhanh/types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize } from "../iam/role/authorize.decorator";
import { JourneyDemoService } from "./journey-demo.service";

class JourneyDemoStartDto extends createZodDto(JourneyDemoStartSchema) {}
class JourneyDemoQueryDto extends createZodDto(JourneyDemoQuerySchema) {}
class JourneyDemoSnapshotDto extends createZodDto(JourneyDemoSnapshotSchema) {}
const JourneyDemoCurrentDto = createZodDto(JourneyDemoCurrentSchema);
Object.defineProperty(JourneyDemoCurrentDto, "name", { value: "JourneyDemoCurrentDto" });

/** Demo Android chủ động bật trong sandbox; production/cờ tắt luôn trả 404. */
@ApiTags("journey-demo")
@Controller("me/journey-demo")
export class JourneyDemoController {
  constructor(@Inject(JourneyDemoService) private readonly demo: JourneyDemoService) {}

  @Post() @Authorize("notification:manage")
  @ZodResponse({ status: 201, type: JourneyDemoSnapshotDto, description: "Phiên mô phỏng hành trình Android." })
  start(@CurrentUser() actor: VerifiedAccessToken, @Body() input: JourneyDemoStartDto) { return this.demo.start(actor, input); }

  @Get() @Authorize("notification:manage")
  @ZodResponse({ status: 200, type: JourneyDemoCurrentDto, description: "Snapshot hiện tại hoặc null." })
  current(@CurrentUser() actor: VerifiedAccessToken, @Query() query: JourneyDemoQueryDto) { return this.demo.current(actor, query.deviceId); }

  @Delete(":sessionId") @HttpCode(204) @Authorize("notification:manage")
  stop(@CurrentUser() actor: VerifiedAccessToken, @Param("sessionId", new ParseUUIDPipe()) sessionId: string) { return this.demo.stop(actor, sessionId); }
}
