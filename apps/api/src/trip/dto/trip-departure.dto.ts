import { TripDepartureInputSchema, TripDepartureSchema } from "@vexenhanh/types";
import { createZodDto } from "nestjs-zod";

/** Dữ liệu điều phối xác nhận xe khởi hành thực tế. */
export class TripDepartureInputDto extends createZodDto(TripDepartureInputSchema) {}

/** Mốc khởi hành thực tế do máy chủ ghi nhận. */
export class TripDepartureDto extends createZodDto(TripDepartureSchema) {}
