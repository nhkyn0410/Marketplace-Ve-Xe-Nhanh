import { Body, Controller, Get, Inject, Param, ParseIntPipe, ParseUUIDPipe, Post, Put, Query } from "@nestjs/common";
import { ApiTags } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import type { Incident, IncidentPage } from "@vexenhanh/types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { OperationsQueryDto } from "../journey-log/journey-log.dto";
import { AttachmentUploadInputDto, AttachmentUploadResponseDto, DownloadUrlResponseDto } from "../support/dto/support.dto";
import { IncidentDto, IncidentInputDto, IncidentPageDto, IncidentResolutionDto } from "./incident.dto";
import { IncidentService } from "./incident.service";

/** API báo cáo sự cố của tài xế và nhân viên hỗ trợ được phân công. */
@ApiTags("incidents")
@Controller("employee")
export class EmployeeIncidentController {
  constructor(@Inject(IncidentService) private readonly incidents: IncidentService) {}
  /** Báo sự cố và gửi cảnh báo về nhà xe. */
  @Post("incidents")
  @Authorize("incident:create")
  @ZodResponse({ status: 201, type: IncidentDto })
  create(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Body() input: IncidentInputDto): Promise<Incident> { return this.incidents.create(authz, actor, input); }
  /** Xem sự cố trên chuyến được giao. */
  @Get("incidents")
  @Authorize("incident:create")
  @ZodResponse({ status: 200, type: IncidentPageDto })
  list(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Query() query: OperationsQueryDto): Promise<IncidentPage> { return this.incidents.list(authz, actor, query); }
  /** Xin URL tải minh chứng sự cố lên kho riêng tư. */
  @Post("trips/:tripId/incident-attachments")
  @Authorize("incident:create")
  @ZodResponse({ status: 201, type: AttachmentUploadResponseDto })
  upload(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Param("tripId", new ParseUUIDPipe()) tripId: string, @Body() input: AttachmentUploadInputDto) { return this.incidents.upload(authz, actor, tripId, input); }
}

/** API sự cố và minh chứng trong nhà xe. */
@ApiTags("incidents")
@Controller("operator/incidents")
export class OperatorIncidentController {
  constructor(@Inject(IncidentService) private readonly incidents: IncidentService) {}
  /** Xem các sự cố nhân viên gửi về. */
  @Get()
  @Authorize("support:respond")
  @ZodResponse({ status: 200, type: IncidentPageDto })
  list(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Query() query: OperationsQueryDto): Promise<IncidentPage> { return this.incidents.list(authz, actor, query); }
  /** Ghi kết quả xử lý sự cố. */
  @Put(":incidentId/resolution")
  @Authorize("support:respond")
  @ZodResponse({ status: 200, type: IncidentDto })
  resolve(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Param("incidentId", new ParseUUIDPipe()) id: string, @Body() input: IncidentResolutionDto): Promise<Incident> { return this.incidents.resolve(authz, actor, id, input.resolution); }
  /** Xem minh chứng có URL hết hạn sau năm phút. */
  @Get(":incidentId/evidence/:index")
  @Authorize("support:respond")
  @ZodResponse({ status: 200, type: DownloadUrlResponseDto })
  download(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Param("incidentId", new ParseUUIDPipe()) id: string, @Param("index", ParseIntPipe) index: number) { return this.incidents.download(authz, actor, id, index); }
}

/** API giám sát sự cố cho Admin và hỗ trợ nền tảng. */
@ApiTags("incidents")
@Controller("admin/incidents")
export class AdminIncidentController {
  constructor(@Inject(IncidentService) private readonly incidents: IncidentService) {}
  /** Xem sự cố, gồm mức nghiêm trọng tự động báo Admin. */
  @Get()
  @Authorize("support:manage")
  @ZodResponse({ status: 200, type: IncidentPageDto })
  list(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Query() query: OperationsQueryDto): Promise<IncidentPage> { return this.incidents.list(authz, actor, query); }
  /** Xem minh chứng sự cố phục vụ giám sát. */
  @Get(":incidentId/evidence/:index")
  @Authorize("support:manage")
  @ZodResponse({ status: 200, type: DownloadUrlResponseDto })
  download(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Param("incidentId", new ParseUUIDPipe()) id: string, @Param("index", ParseIntPipe) index: number) { return this.incidents.download(authz, actor, id, index); }
}
