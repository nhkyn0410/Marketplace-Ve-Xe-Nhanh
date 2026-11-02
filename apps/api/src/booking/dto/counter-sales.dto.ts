import { CounterBookingInputSchema, CounterBookingListQuerySchema, CounterBookingListSchema, CounterBookingSchema, CounterHoldInputSchema, CounterHoldSchema, CounterReceiptInputSchema, CounterReceiptResultSchema, CounterTripListSchema, CounterTripsQuerySchema } from "@vexenhanh/types";
import { createZodDto } from "nestjs-zod";
import { CounterReportSchema } from "@vexenhanh/types";

/** Tổng thu tiền mặt, chuyển khoản, ngoại lệ và phí theo người xác nhận thu. */
export class CounterReportDto extends createZodDto(CounterReportSchema) {}

/** Bộ lọc ngày và văn phòng khi bán vé quầy. */
export class CounterTripsQueryDto extends createZodDto(CounterTripsQuerySchema) {}
/** Danh sách chuyến đang bán quầy với giá và chỗ dùng chung. */
export class CounterTripListDto extends createZodDto(CounterTripListSchema) {}
/** Yêu cầu giữ chỗ của người bán tại văn phòng. */
export class CounterHoldInputDto extends createZodDto(CounterHoldInputSchema) {}
/** Phiên giữ chỗ còn hiệu lực tại quầy. */
export class CounterHoldDto extends createZodDto(CounterHoldSchema) {}
/** Thông tin liên hệ và hành khách để tạo đơn quầy. */
export class CounterBookingInputDto extends createZodDto(CounterBookingInputSchema) {}
/** Đơn bán quầy và vé được phép in lại. */
export class CounterBookingDto extends createZodDto(CounterBookingSchema) {}
/** Bộ lọc danh sách đơn của văn phòng. */
export class CounterBookingListQueryDto extends createZodDto(CounterBookingListQuerySchema) {}
/** Một trang đơn quầy trong văn phòng được cấp quyền. */
export class CounterBookingListDto extends createZodDto(CounterBookingListSchema) {}
/** Xác nhận khoản nhà xe đã nhận trực tiếp. */
export class CounterReceiptInputDto extends createZodDto(CounterReceiptInputSchema) {}
/** Kết quả ghi khoản thu và phát hành vé hoặc ghi ngoại lệ. */
export class CounterReceiptResultDto extends createZodDto(CounterReceiptResultSchema) {}
