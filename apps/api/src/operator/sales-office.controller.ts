import { Body, Controller, Get, HttpCode, Inject, Param, ParseUUIDPipe, Patch, Post, Put } from "@nestjs/common";
import { ApiBody, ApiParam, ApiTags } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { SalesOfficeAssignmentsDto, SalesOfficeAssignmentsInputDto, SalesOfficeDto, SalesOfficeInputDto, SalesOfficeListDto, SalesOfficeUpdateDto } from "./dto/sales-office.dto";
import { SalesOfficeService } from "./sales-office.service";

/** API quản lý văn phòng và phân công tài khoản cho nhà xe. */
@ApiTags("operator-offices")
@Controller("operator/offices")
export class SalesOfficeController {
  constructor(@Inject(SalesOfficeService) private readonly offices: SalesOfficeService) {}

  /** Danh sách văn phòng được phép xem của tài khoản hiện tại. */
  @Get()
  @Authorize("office:read")
  @ZodResponse({ status: 200, type: SalesOfficeListDto })
  list(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization) {
    return this.offices.list(actor, authz);
  }

  /** Chi tiết văn phòng thuộc phạm vi của tài khoản. */
  @Get(":officeId")
  @ApiParam({ name: "officeId", type: String, format: "uuid" })
  @Authorize("office:read")
  @ZodResponse({ status: 200, type: SalesOfficeDto })
  get(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("officeId", new ParseUUIDPipe()) officeId: string) {
    return this.offices.get(actor, authz, officeId);
  }

  /** Chủ nhà xe tạo văn phòng bán vé. */
  @Post()
  @ApiBody({ type: SalesOfficeInputDto })
  @Authorize("office:manage")
  @ZodResponse({ status: 201, type: SalesOfficeDto })
  create(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Body() input: SalesOfficeInputDto) {
    return this.offices.create(actor, authz, input);
  }

  /** Chủ nhà xe sửa hoặc ngừng hoạt động văn phòng. */
  @Patch(":officeId")
  @ApiParam({ name: "officeId", type: String, format: "uuid" })
  @ApiBody({ type: SalesOfficeUpdateDto })
  @Authorize("office:manage")
  @ZodResponse({ status: 200, type: SalesOfficeDto })
  update(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("officeId", new ParseUUIDPipe()) officeId: string, @Body() input: SalesOfficeUpdateDto) {
    return this.offices.update(actor, authz, officeId, input);
  }

  /** Chủ nhà xe xem tài khoản được phân công cho văn phòng. */
  @Get(":officeId/assignments")
  @ApiParam({ name: "officeId", type: String, format: "uuid" })
  @Authorize("office:manage")
  @ZodResponse({ status: 200, type: SalesOfficeAssignmentsDto })
  assignments(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("officeId", new ParseUUIDPipe()) officeId: string) {
    return this.offices.assignments(actor, authz, officeId);
  }

  /** Chủ nhà xe thay danh sách nhân viên bán vé được phân công. */
  @Put(":officeId/assignments")
  @ApiParam({ name: "officeId", type: String, format: "uuid" })
  @ApiBody({ type: SalesOfficeAssignmentsInputDto })
  @HttpCode(200)
  @Authorize("office:manage")
  @ZodResponse({ status: 200, type: SalesOfficeDto })
  replaceAssignments(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("officeId", new ParseUUIDPipe()) officeId: string, @Body() input: SalesOfficeAssignmentsInputDto) {
    return this.offices.replaceAssignments(actor, authz, officeId, input);
  }
}
