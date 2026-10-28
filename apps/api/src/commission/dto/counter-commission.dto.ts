import { CounterCommissionOverviewSchema, CounterCommissionQuerySchema, CounterCommissionSettlementInputSchema, CounterCommissionSettlementSchema } from "@vexenhanh/types";
import { createZodDto } from "nestjs-zod";

/** Bộ lọc nhà xe và khoảng ngày của báo cáo hoa hồng quầy. */
export class CounterCommissionQueryDto extends createZodDto(CounterCommissionQuerySchema) {}
/** Khoản phí quầy phải thu và các lần thu phí thủ công. */
export class CounterCommissionOverviewDto extends createZodDto(CounterCommissionOverviewSchema) {}
/** Dữ liệu xác nhận Platform đã nhận phí từ nhà xe. */
export class CounterCommissionSettlementInputDto extends createZodDto(CounterCommissionSettlementInputSchema) {}
/** Khoản thu phí thủ công đã ghi nhận. */
export class CounterCommissionSettlementDto extends createZodDto(CounterCommissionSettlementSchema) {}
