import { Controller, Get, Inject } from "@nestjs/common";
import { ApiTags } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { Authorize } from "../iam/role/authorize.decorator";
import { BackgroundJobsDto, type BackgroundJobs, SystemIntegrationsDto, type SystemIntegrations } from "./dto/system-status.dto";
import { SystemStatusService } from "./system-status.service";

// API §7.5 — Tích hợp & hệ thống, chỉ đọc (Figma ADM-16a / 16b). Quyền `system:read` (PLATFORM_ADMIN).
@ApiTags("admin-system")
@Controller("admin/system")
/** Trạng thái vận hành: dịch vụ nền / bên ngoài và tác vụ nền. */
export class SystemStatusController {
  constructor(@Inject(SystemStatusService) private readonly status: SystemStatusService) {}

  /** Kiểm tra kết nối thật (Postgres, Redis, Mongo, hàng đợi, kho lưu trữ) + cấu hình dịch vụ gửi đi; không trả bí mật. */
  @Get("integrations")
  @Authorize("system:read")
  @ZodResponse({ status: 200, description: "Trạng thái từng tích hợp.", type: SystemIntegrationsDto })
  integrations(): Promise<SystemIntegrations> {
    return this.status.integrations();
  }

  /** Lần chạy gần nhất + lịch kế tiếp của từng tác vụ nền (BullMQ). */
  @Get("jobs")
  @Authorize("system:read")
  @ZodResponse({ status: 200, description: "Tác vụ nền.", type: BackgroundJobsDto })
  jobs(): Promise<BackgroundJobs> {
    return this.status.backgroundJobs();
  }
}
