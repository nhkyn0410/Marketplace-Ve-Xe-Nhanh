import { createZodDto } from "nestjs-zod";
import {
  PassengerProfileSchema, PassengerProfileUpdateSchema, SavedPassengerInputSchema, SavedPassengerSchema,
  SavedPassengerListSchema, PassengerPageQuerySchema, PassengerBookingPageSchema,
  PassengerTicketPageSchema, PassengerSupportPageSchema, PassengerDisputePageSchema,
} from "@vexenhanh/types";

/** Hồ sơ của hành khách đang đăng nhập. */
export class PassengerProfileDto extends createZodDto(PassengerProfileSchema) {}
/** Thay đổi thông tin cá nhân; email và quyền không sửa qua hồ sơ. */
export class PassengerProfileUpdateDto extends createZodDto(PassengerProfileUpdateSchema) {}
/** Thông tin một hành khách thường dùng. */
export class SavedPassengerInputDto extends createZodDto(SavedPassengerInputSchema) {}
/** Hành khách đã lưu. */
export class SavedPassengerDto extends createZodDto(SavedPassengerSchema) {}
/** Danh sách hành khách thường dùng. */
export class SavedPassengerListDto extends createZodDto(SavedPassengerListSchema) {}
/** Phân trang tài nguyên của hành khách. */
export class PassengerPageQueryDto extends createZodDto(PassengerPageQuerySchema) {}
/** Các đơn của tài khoản hành khách. */
export class PassengerBookingPageDto extends createZodDto(PassengerBookingPageSchema) {}
/** Các vé của tài khoản hành khách. */
export class PassengerTicketPageDto extends createZodDto(PassengerTicketPageSchema) {}
/** Các khiếu nại của tài khoản hành khách. */
export class PassengerSupportPageDto extends createZodDto(PassengerSupportPageSchema) {}
/** Các tranh chấp của tài khoản hành khách. */
export class PassengerDisputePageDto extends createZodDto(PassengerDisputePageSchema) {}
