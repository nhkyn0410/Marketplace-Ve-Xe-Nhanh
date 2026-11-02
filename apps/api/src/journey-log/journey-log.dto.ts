import { createZodDto } from "nestjs-zod";
import { JourneyLogInputSchema, JourneyLogPageSchema, JourneyLogSchema, OperationsQuerySchema } from "@vexenhanh/types";

/** Bộ lọc nhật trình / sự cố. */
export class OperationsQueryDto extends createZodDto(OperationsQuerySchema) {}
/** Nhật trình do tài xế gửi. */
export class JourneyLogInputDto extends createZodDto(JourneyLogInputSchema) {}
/** Nhật trình đã ghi nhận. */
export class JourneyLogDto extends createZodDto(JourneyLogSchema) {}
/** Danh sách nhật trình có phân trang. */
export class JourneyLogPageDto extends createZodDto(JourneyLogPageSchema) {}
