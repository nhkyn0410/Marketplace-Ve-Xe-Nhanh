import { HttpException, HttpStatus } from "@nestjs/common";

/** Lỗi nghiệp vụ bán quầy theo định dạng RFC7807 chung của hệ thống. */
export function counterError(code: string, detail: string, status: HttpStatus = HttpStatus.CONFLICT): HttpException {
  return new HttpException({ code, detail, title: "Counter sales error" }, status);
}
