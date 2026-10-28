import { createZodDto } from "nestjs-zod";
import {
  SalesOfficeAssignmentsInputSchema,
  SalesOfficeAssignmentsSchema,
  SalesOfficeInputSchema,
  SalesOfficeListSchema,
  SalesOfficeSchema,
  SalesOfficeUpdateSchema,
} from "@vexenhanh/types";

/** Dữ liệu tạo văn phòng nhà xe. */
export class SalesOfficeInputDto extends createZodDto(SalesOfficeInputSchema) {}
/** Dữ liệu cập nhật văn phòng cùng phiên bản. */
export class SalesOfficeUpdateDto extends createZodDto(SalesOfficeUpdateSchema) {}
/** Văn phòng bán vé trong phạm vi tài khoản. */
export class SalesOfficeDto extends createZodDto(SalesOfficeSchema) {}
/** Danh sách văn phòng được phép xem. */
export class SalesOfficeListDto extends createZodDto(SalesOfficeListSchema) {}
/** Danh sách tài khoản phân công cho văn phòng. */
export class SalesOfficeAssignmentsDto extends createZodDto(SalesOfficeAssignmentsSchema) {}
/** Dữ liệu thay danh sách tài khoản được phân công. */
export class SalesOfficeAssignmentsInputDto extends createZodDto(SalesOfficeAssignmentsInputSchema) {}
