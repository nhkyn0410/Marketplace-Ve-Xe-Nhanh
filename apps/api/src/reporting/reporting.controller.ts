import { Controller, Get, Inject, Query, Res } from "@nestjs/common";
import { ApiProduces, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import type { Response } from "express";
import { ZodResponse } from "nestjs-zod";
import { PaymentProvider, TripStatus } from "../database/prisma.types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  AdminOverviewDto,
  AdminReportDto,
  AdminReportQueryDto,
  OperatorOverviewDto,
  OperatorReportDto,
  OperatorReportQueryDto,
  type AdminOverview,
  type AdminReport,
  type OperatorOverview,
  type OperatorReport,
} from "./dto/reporting.dto";
import { ReportingService } from "./reporting.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const csvResponse = { status: 200, description: "Tệp CSV (UTF-8, có BOM).", content: { "text/csv": { schema: { type: "string" } } } };

function sendCsv(res: Response, file: { filename: string; csv: string }): void {
  res
    .status(200)
    .setHeader("content-type", "text/csv; charset=utf-8")
    .setHeader("content-disposition", `attachment; filename="${file.filename}"`)
    .setHeader("cache-control", "no-store")
    .send(file.csv);
}

// Báo cáo nhà xe (TASK-RPT-001, FR-NSR-12, UC-17) — Owner (`finance:read` phạm vi tenant; tenant lấy từ JWT).
@ApiTags("operator-reports")
@Controller("operator")
/** Báo cáo vận hành / doanh thu và tổng quan của nhà xe. */
export class OperatorReportingController {
  constructor(@Inject(ReportingService) private readonly reports: ReportingService) {}

  @Get("overview")
  @Authorize("finance:read")
  @ZodResponse({ status: 200, description: "Số liệu trang tổng quan Operator OS.", type: OperatorOverviewDto })
  overview(@Authz() authz: Authorization): Promise<OperatorOverview> {
    return this.reports.operatorOverview(authz);
  }

  @Get("reports/summary")
  @Authorize("finance:read")
  @ApiQuery({ name: "from", required: true, type: String, format: "date" })
  @ApiQuery({ name: "to", required: true, type: String, format: "date" })
  @ApiQuery({ name: "routeId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "vehicleId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "status", required: false, enum: TripStatus })
  @ZodResponse({ status: 200, description: "Báo cáo theo kỳ (chuyến khởi hành trong kỳ).", type: OperatorReportDto })
  @ApiResponse({ status: 400, description: "Query không hợp lệ (khoảng ngày tối đa 366 ngày).", content: problemContent })
  summary(@Authz() authz: Authorization, @Query() query: OperatorReportQueryDto): Promise<OperatorReport> {
    return this.reports.operatorReport(authz, query);
  }

  /** Xuất báo cáo theo tuyến (CSV) — mỗi lần ghi nhật ký audit (BR-56). */
  @Get("reports/export")
  @Authorize("finance:read")
  @ApiQuery({ name: "from", required: true, type: String, format: "date" })
  @ApiQuery({ name: "to", required: true, type: String, format: "date" })
  @ApiQuery({ name: "routeId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "vehicleId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "status", required: false, enum: TripStatus })
  @ApiProduces("text/csv")
  @ApiResponse(csvResponse)
  @ApiResponse({ status: 503, description: "Chưa ghi được nhật ký — không xuất.", content: problemContent })
  async export(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Query() query: OperatorReportQueryDto,
    @Res() res: Response,
  ): Promise<void> {
    sendCsv(res, await this.reports.operatorReportCsv(authz, actor, query));
  }
}

// Báo cáo nền tảng (TASK-RPT-002, FR-NSR-13, FR-ADM-17, UC-29) — PlatformAdmin + PlatformSupport (`payment:monitor` — chỉ
// role Platform; `finance:read` thì Owner cũng có nên không dùng cho route Admin).
@ApiTags("admin-reports")
@Controller("admin")
/** Báo cáo toàn hệ thống và số liệu trang Tổng quan Admin. */
export class AdminReportingController {
  constructor(@Inject(ReportingService) private readonly reports: ReportingService) {}

  @Get("overview")
  @Authorize("payment:monitor")
  @ApiQuery({ name: "from", required: true, type: String, format: "date" })
  @ApiQuery({ name: "to", required: true, type: String, format: "date" })
  @ApiQuery({ name: "operatorId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "provider", required: false, enum: PaymentProvider })
  @ZodResponse({ status: 200, description: "Số liệu trang Tổng quan nền tảng.", type: AdminOverviewDto })
  @ApiResponse({ status: 400, description: "Query không hợp lệ.", content: problemContent })
  overview(@Authz() authz: Authorization, @Query() query: AdminReportQueryDto): Promise<AdminOverview> {
    return this.reports.adminOverview(authz, query);
  }

  @Get("reports/summary")
  @Authorize("payment:monitor")
  @ApiQuery({ name: "from", required: true, type: String, format: "date" })
  @ApiQuery({ name: "to", required: true, type: String, format: "date" })
  @ApiQuery({ name: "operatorId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "provider", required: false, enum: PaymentProvider })
  @ZodResponse({ status: 200, description: "Báo cáo toàn hệ thống theo kỳ.", type: AdminReportDto })
  @ApiResponse({ status: 400, description: "Query không hợp lệ (khoảng ngày tối đa 366 ngày).", content: problemContent })
  summary(@Authz() authz: Authorization, @Query() query: AdminReportQueryDto): Promise<AdminReport> {
    return this.reports.adminReport(authz, query);
  }

  /** Xuất báo cáo theo nhà xe (CSV) — mỗi lần ghi nhật ký audit (BR-56). */
  @Get("reports/export")
  @Authorize("payment:monitor")
  @ApiQuery({ name: "from", required: true, type: String, format: "date" })
  @ApiQuery({ name: "to", required: true, type: String, format: "date" })
  @ApiQuery({ name: "operatorId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "provider", required: false, enum: PaymentProvider })
  @ApiProduces("text/csv")
  @ApiResponse(csvResponse)
  @ApiResponse({ status: 503, description: "Chưa ghi được nhật ký — không xuất.", content: problemContent })
  async export(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Query() query: AdminReportQueryDto,
    @Res() res: Response,
  ): Promise<void> {
    sendCsv(res, await this.reports.adminReportCsv(authz, actor, query));
  }
}
