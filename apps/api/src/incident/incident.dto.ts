import { createZodDto } from "nestjs-zod";
import { IncidentInputSchema, IncidentPageSchema, IncidentSchema } from "@vexenhanh/types";
import { z } from "zod";

/** Sự cố nhân viên báo cáo. */
export class IncidentInputDto extends createZodDto(IncidentInputSchema) {}
/** Chi tiết một sự cố. */
export class IncidentDto extends createZodDto(IncidentSchema) {}
/** Danh sách sự cố có phân trang. */
export class IncidentPageDto extends createZodDto(IncidentPageSchema) {}
/** Ghi kết quả nhà xe xử lý sự cố. */
export class IncidentResolutionDto extends createZodDto(z.object({ resolution: z.string().trim().min(3).max(3000) })) {}
