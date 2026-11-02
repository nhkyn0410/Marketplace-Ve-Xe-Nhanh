// Nén ảnh ở trình duyệt trước khi tải lên (LLD §6.12 bước 1, `LLD-OQ-08` mặc định v1): ảnh xe thu nhỏ cạnh dài về
// 1600 px và xuất lại JPEG; logo nhà xe thu nhỏ hơn và xuất PNG để giữ nền trong suốt. Vẽ lại qua canvas cũng bỏ hết
// EXIF (vị trí GPS, thông tin máy chụp) của ảnh điện thoại trước khi ảnh thành công khai.
import { fitWithin } from "./vehicle-images";

const JPEG_QUALITY = 0.85;

/** Ảnh đã nén theo `type` (mặc định JPEG như ảnh xe). Ném lỗi nếu trình duyệt không đọc được tệp như một ảnh. */
export async function compressImage(
  file: Blob,
  options: { maxEdge?: number; type?: "image/jpeg" | "image/png" } = {}
): Promise<Blob> {
  const type = options.type ?? "image/jpeg";
  // `createImageBitmap` xoay ảnh theo EXIF orientation trước khi vẽ, nên ảnh chụp dọc không bị nằm ngang.
  const bitmap = await createImageBitmap(file);
  try {
    const { width, height } = fitWithin(bitmap.width, bitmap.height, options.maxEdge);
    const canvas = document.createElement("canvas");
    canvas.width = width;
    canvas.height = height;
    const context = canvas.getContext("2d");
    if (!context) {
      throw new Error("Trình duyệt không hỗ trợ xử lý ảnh.");
    }
    if (type === "image/jpeg") {
      // Nền trắng: phần trong suốt của PNG / WebP không thành nền đen khi xuất JPEG.
      context.fillStyle = "#ffffff";
      context.fillRect(0, 0, width, height);
    }
    context.drawImage(bitmap, 0, 0, width, height);
    const blob = await new Promise<Blob | null>((resolve) => canvas.toBlob(resolve, type, JPEG_QUALITY));
    if (!blob) {
      throw new Error("Không nén được ảnh.");
    }
    return blob;
  } finally {
    bitmap.close();
  }
}
