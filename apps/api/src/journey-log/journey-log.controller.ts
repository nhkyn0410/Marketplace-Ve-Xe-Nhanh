import { Body, Controller, Get, Inject, Post, Query } from "@nestjs/common";
import { ApiTags } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import type { JourneyLog, JourneyLogPage } from "@vexenhanh/types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { JourneyLogDto, JourneyLogInputDto, JourneyLogPageDto, OperationsQueryDto } from "./journey-log.dto";
import { JourneyLogService } from "./journey-log.service";

/** API nhật trình trên chuyến được phân công cho tài xế. */
@ApiTags("journey-logs")
@Controller("employee/journey-logs")
export class EmployeeJourneyLogController {
  constructor(@Inject(JourneyLogService) private readonly logs: JourneyLogService) {}
  /** Tài xế ghi một mục nhật trình. */
  @Post()
  @Authorize("journey-log:create")
  @ZodResponse({ status: 201, type: JourneyLogDto })
  create(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Body() input: JourneyLogInputDto): Promise<JourneyLog> { return this.logs.create(authz, actor, input); }
  /** Xem nhật trình của các chuyến được giao. */
  @Get()
  @Authorize("journey-log:create")
  @ZodResponse({ status: 200, type: JourneyLogPageDto })
  list(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Query() query: OperationsQueryDto): Promise<JourneyLogPage> { return this.logs.list(authz, actor, query); }
}

/** API nhật trình cho chủ nhà xe. */
@ApiTags("journey-logs")
@Controller("operator/journey-logs")
export class OperatorJourneyLogController {
  constructor(@Inject(JourneyLogService) private readonly logs: JourneyLogService) {}
  /** Xem nhật trình trong nhà xe. */
  @Get()
  @Authorize("support:respond")
  @ZodResponse({ status: 200, type: JourneyLogPageDto })
  list(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Query() query: OperationsQueryDto): Promise<JourneyLogPage> { return this.logs.list(authz, actor, query); }
}

/** API giám sát nhật trình của nền tảng. */
@ApiTags("journey-logs")
@Controller("admin/journey-logs")
export class AdminJourneyLogController {
  constructor(@Inject(JourneyLogService) private readonly logs: JourneyLogService) {}
  /** Xem nhật trình toàn hệ thống. */
  @Get()
  @Authorize("payment:monitor")
  @ZodResponse({ status: 200, type: JourneyLogPageDto })
  list(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Query() query: OperationsQueryDto): Promise<JourneyLogPage> { return this.logs.list(authz, actor, query); }
}
