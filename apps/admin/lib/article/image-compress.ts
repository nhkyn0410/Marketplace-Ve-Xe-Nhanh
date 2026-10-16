// Nén ảnh bài viết ở trình duyệt trước khi tải lên (cùng cách ảnh xe của Operator OS — LLD §6.12 bước 1): thu nhỏ
// cạnh dài về 1600 px, xuất lại JPEG; vẽ lại qua canvas bỏ luôn EXIF (vị trí GPS) trước khi ảnh thành công khai.

const MAX_EDGE = 1600;
const JPEG_QUALITY = 0.85;
export const ACCEPTED_IMAGE_TYPES = ["image/jpeg", "image/png", "image/webp"] as const;
export const MAX_IMAGE_BYTES = 5 * 1024 * 1024;

/** Lỗi tại tệp khi chọn ảnh; `null` = nhận được. */
export function imageFileProblem(file: { type: string }): string | null {
  if (!(ACCEPTED_IMAGE_TYPES as readonly string[]).includes(file.type)) {
    return "Định dạng không được hỗ trợ. Chọn JPEG, PNG hoặc WebP.";
  }
  return null;
}

export function fitWithin(width: number, height: number, maxEdge = MAX_EDGE): { width: number; height: number } {
  const scale = Math.min(1, maxEdge / Math.max(width, height));
  return { width: Math.round(width * scale), height: Math.round(height * scale) };
}

/** Ảnh đã nén, luôn `image/jpeg`. Ném lỗi nếu trình duyệt không đọc được tệp như một ảnh. */
export async function compressImage(file: Blob): Promise<Blob> {
  const bitmap = await createImageBitmap(file);
  try {
    const { width, height } = fitWithin(bitmap.width, bitmap.height);
    const canvas = document.createElement("canvas");
    canvas.width = width;
    canvas.height = height;
    const context = canvas.getContext("2d");
    if (!context) {
      throw new Error("Trình duyệt không hỗ trợ xử lý ảnh.");
    }
    context.fillStyle = "#ffffff";
    context.fillRect(0, 0, width, height);
    context.drawImage(bitmap, 0, 0, width, height);
    const blob = await new Promise<Blob | null>((resolve) => canvas.toBlob(resolve, "image/jpeg", JPEG_QUALITY));
    if (!blob) {
      throw new Error("Không nén được ảnh.");
    }
    if (blob.size > MAX_IMAGE_BYTES) {
      throw new Error("Ảnh sau khi nén vẫn vượt quá 5 MB.");
    }
    return blob;
  } finally {
    bitmap.close();
  }
}
