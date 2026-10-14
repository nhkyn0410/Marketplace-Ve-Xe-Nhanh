import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import {
  MAX_VEHICLE_IMAGE_BYTES,
  MAX_VEHICLE_IMAGE_CAPTION,
  VEHICLE_IMAGE_CONTENT_TYPES,
} from "../vehicle-image-format";

export const VehicleImageUploadInputSchema = z.object({
  contentType: z.enum(VEHICLE_IMAGE_CONTENT_TYPES),
  sizeBytes: z.int().min(1).max(MAX_VEHICLE_IMAGE_BYTES),
});
export type VehicleImageUploadInput = z.infer<typeof VehicleImageUploadInputSchema>;
/** Body xin URL tải một ảnh xe lên kho: loại file và dung lượng (BR-76). */
export class VehicleImageUploadInputDto extends createZodDto(VehicleImageUploadInputSchema) {}

export const VehicleImageUploadResponseSchema = z.object({
  /** URL để trình duyệt `PUT` thẳng file lên kho, kèm đúng header `Content-Type` đã khai. */
  uploadUrl: z.url(),
  /** Khóa object do server sinh — gửi lại ở `PUT …/images` để gắn ảnh vào xe. */
  objectKey: z.string(),
  expiresAt: z.iso.datetime(),
});
export type VehicleImageUploadResponse = z.infer<typeof VehicleImageUploadResponseSchema>;
export class VehicleImageUploadResponseDto extends createZodDto(VehicleImageUploadResponseSchema) {}

// Trần của schema cao hơn giới hạn 8 ảnh: vượt 8 là lỗi nghiệp vụ 422 `VEHICLE_IMAGE_LIMIT_EXCEEDED` do service
// trả (API §7.3), không phải lỗi dạng dữ liệu 400. 50 chỉ để chặn body quá lớn.
const MAX_IMAGES_IN_BODY = 50;

export const VehicleImagesInputSchema = z.object({
  /** Bộ ảnh mới theo thứ tự hiển thị — thay toàn bộ; phần tử đầu là ảnh đại diện; mảng rỗng = xóa hết. */
  images: z
    .array(
      z.object({
        objectKey: z.string().min(1).max(200),
        /** Chú thích ngắn hiển thị công khai cùng ảnh; `null` hoặc chuỗi rỗng = không có. */
        caption: z
          .string()
          .trim()
          .max(MAX_VEHICLE_IMAGE_CAPTION)
          .nullable()
          .transform((value) => value || null),
      }),
    )
    .max(MAX_IMAGES_IN_BODY)
    .refine((images) => new Set(images.map((image) => image.objectKey)).size === images.length, "Ảnh bị lặp."),
});
export type VehicleImagesInput = z.infer<typeof VehicleImagesInputSchema>;
/** Body thay toàn bộ bộ ảnh của một xe. */
export class VehicleImagesInputDto extends createZodDto(VehicleImagesInputSchema) {}

export const VehicleImageSchema = z.object({
  id: z.uuid(),
  /** Khóa object — client gửi lại khi sắp xếp / giữ ảnh ở `PUT …/images`. */
  objectKey: z.string(),
  /** Địa chỉ công khai của ảnh (CDN). */
  url: z.url(),
  /** Thứ tự hiển thị từ 0; 0 là ảnh đại diện. */
  position: z.int(),
  caption: z.string().nullable(),
});
export type VehicleImageResponse = z.infer<typeof VehicleImageSchema>;

export const VehicleImagesResponseSchema = z.object({ images: z.array(VehicleImageSchema) });
export type VehicleImagesResponse = z.infer<typeof VehicleImagesResponseSchema>;
/** Bộ ảnh của xe sau khi thay. */
export class VehicleImagesResponseDto extends createZodDto(VehicleImagesResponseSchema) {}
