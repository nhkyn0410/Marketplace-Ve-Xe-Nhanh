import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { LoyaltyRedemptionInputSchema, PassengerLoyaltyTransactionsQuerySchema, SaveVoucherInputSchema, UserVoucherPageSchema, UserVoucherSchema, VoucherListQuerySchema } from "@vexenhanh/types";
import { LoyaltyMemberSchema, LoyaltyTransactionSchema } from "./loyalty.dto";
import { LoyaltyRulesSchema } from "../../policy/dto/policy.dto";

/** Thẻ thành viên kèm bảng hạng và điều kiện đổi điểm hiện hành. */
export class PassengerLoyaltyDto extends createZodDto(LoyaltyMemberSchema.extend({ rules: LoyaltyRulesSchema.nullable() })) {}
/** Lọc lịch sử điểm của hành khách. */
export class PassengerLoyaltyTransactionsQueryDto extends createZodDto(PassengerLoyaltyTransactionsQuerySchema) {}
/** Lịch sử và tổng số điểm theo bộ lọc. */
export class PassengerLoyaltyTransactionsDto extends createZodDto(z.object({ items: z.array(LoyaltyTransactionSchema), total: z.int(), totals: z.object({ earned: z.int(), redeemed: z.int(), expired: z.int() }) })) {}
/** Số điểm muốn đổi thành voucher. */
export class LoyaltyRedemptionInputDto extends createZodDto(LoyaltyRedemptionInputSchema) {}
/** Mã công khai muốn lưu vào ví. */
export class SaveVoucherInputDto extends createZodDto(SaveVoucherInputSchema) {}
/** Bộ lọc ví voucher. */
export class VoucherListQueryDto extends createZodDto(VoucherListQuerySchema) {}
/** Một voucher của hành khách. */
export class UserVoucherDto extends createZodDto(UserVoucherSchema) {}
/** Trang ví voucher của hành khách. */
export class UserVoucherPageDto extends createZodDto(UserVoucherPageSchema) {}
