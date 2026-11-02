import { describe, expect, it, vi } from "vitest";

import { ApiError } from "../auth/api-client";
import {
  countLabel,
  describeImageSaveError,
  fileProblem,
  fitWithin,
  FULL_MESSAGE,
  imageCountLine,
  imagesChanged,
  type ImageItem,
  moveItem,
  pickFiles,
  type SavedImage,
  syncVehicleImages,
  toImageItems,
  toImagesInput
} from "./vehicle-images";

const saved = (n: number, caption: string | null = null): SavedImage => ({
  id: `id-${n}`,
  objectKey: `vehicles/o/v/${n}.jpg`,
  url: `https://cdn.test/${n}.jpg`,
  position: n,
  caption
});

const fresh = (id: string, overrides: Partial<Extract<ImageItem, { kind: "new" }>> = {}): ImageItem => ({
  kind: "new",
  id,
  file: new Blob(["x"], { type: "image/jpeg" }),
  previewUrl: `blob:${id}`,
  caption: "",
  objectKey: null,
  failed: false,
  ...overrides
});

describe("ảnh xe ở form", () => {
  it("ảnh đã lưu → ô ảnh theo đúng vị trí, chú thích null thành chuỗi rỗng", () => {
    expect(toImageItems([saved(1, "Nội thất"), saved(0)])).toEqual([
      { kind: "saved", id: "id-0", objectKey: "vehicles/o/v/0.jpg", url: "https://cdn.test/0.jpg", caption: "" },
      { kind: "saved", id: "id-1", objectKey: "vehicles/o/v/1.jpg", url: "https://cdn.test/1.jpg", caption: "Nội thất" }
    ]);
  });

  it("chỉ nhận JPEG / PNG / WebP", () => {
    expect(fileProblem({ type: "image/jpeg" })).toBeNull();
    expect(fileProblem({ type: "image/png" })).toBeNull();
    expect(fileProblem({ type: "image/webp" })).toBeNull();
    for (const type of ["image/gif", "image/svg+xml", "image/heic", "text/html", ""]) {
      expect(fileProblem({ type }), type).toBe("Định dạng không được hỗ trợ. Chọn JPEG, PNG hoặc WebP.");
    }
  });

  it("chọn nhiều tệp: nhận tới khi đủ 8 ảnh, mỗi loại lỗi báo một lần", () => {
    const files = [
      { type: "image/jpeg", name: "a" },
      { type: "image/gif", name: "b" },
      { type: "image/png", name: "c" },
      { type: "text/html", name: "d" },
      { type: "image/webp", name: "e" }
    ];
    const picked = pickFiles(files, 6);
    expect(picked.accepted.map((file) => file.name)).toEqual(["a", "c"]);
    expect(picked.problems).toEqual(["Định dạng không được hỗ trợ. Chọn JPEG, PNG hoặc WebP.", FULL_MESSAGE]);
    expect(pickFiles(files, 8).accepted).toEqual([]);
    expect(pickFiles([{ type: "image/jpeg" }], 0)).toEqual({ accepted: [{ type: "image/jpeg" }], problems: [] });
  });

  it("thu nhỏ để cạnh dài tối đa 1600 px, giữ tỉ lệ; ảnh nhỏ giữ nguyên", () => {
    expect(fitWithin(4000, 3000)).toEqual({ width: 1600, height: 1200 });
    expect(fitWithin(3000, 4000)).toEqual({ width: 1200, height: 1600 });
    expect(fitWithin(800, 600)).toEqual({ width: 800, height: 600 });
    expect(fitWithin(10000, 3)).toEqual({ width: 1600, height: 1 });
  });

  it("đổi vị trí: các ô khác giữ thứ tự; vị trí sai không đổi gì", () => {
    expect(moveItem(["a", "b", "c", "d"], 3, 0)).toEqual(["d", "a", "b", "c"]);
    expect(moveItem(["a", "b", "c", "d"], 0, 2)).toEqual(["b", "c", "a", "d"]);
    expect(moveItem(["a", "b"], 0, 5)).toEqual(["a", "b"]);
    expect(moveItem(["a", "b"], -1, 0)).toEqual(["a", "b"]);
  });

  it("body gửi API: chỉ ô đã có khóa object, đúng thứ tự, chú thích trống thành null", () => {
    const items = [
      fresh("n1", { objectKey: "vehicles/o/v/n1.jpg", caption: "  Ngoại thất " }),
      ...toImageItems([saved(0, "Cũ")]),
      fresh("n2", { failed: true, caption: "Lỗi" })
    ];
    expect(toImagesInput(items)).toEqual({
      images: [
        { objectKey: "vehicles/o/v/n1.jpg", caption: "Ngoại thất" },
        { objectKey: "vehicles/o/v/0.jpg", caption: "Cũ" }
      ]
    });
  });

  it("nhận ra bộ ảnh đã đổi: thêm, xóa, đổi thứ tự, sửa chú thích; chỉ thêm khoảng trắng thì không", () => {
    const before = [saved(0, "A"), saved(1)];
    const items = toImageItems(before);
    expect(imagesChanged(before, items)).toBe(false);
    expect(imagesChanged(before, [...items, fresh("n")])).toBe(true);
    expect(imagesChanged(before, items.slice(1))).toBe(true);
    expect(imagesChanged(before, moveItem(items, 1, 0))).toBe(true);
    expect(imagesChanged(before, [{ ...items[0]!, caption: "B" }, items[1]!])).toBe(true);
    expect(imagesChanged(before, [{ ...items[0]!, caption: " A " }, items[1]!])).toBe(false);
  });

  it("nhãn đếm: có ảnh chưa lưu được thì chỉ đếm ảnh đã lưu (Figma 08); dòng phụ ở danh sách xe", () => {
    expect(countLabel([...toImageItems([saved(0)]), fresh("n")])).toBe("2 / 8 ảnh");
    expect(countLabel([...toImageItems([saved(0)]), fresh("n", { failed: true })])).toBe("1 / 8 ảnh đã lưu");
    expect(countLabel([])).toBe("0 / 8 ảnh");
    expect(imageCountLine(2)).toBe("2 ảnh");
    expect(imageCountLine(0)).toBe("Chưa có ảnh");
  });

  it("thông báo lỗi khi gắn ảnh theo mã lỗi API", () => {
    expect(describeImageSaveError(new ApiError(422, "VEHICLE_IMAGE_INVALID", "Có ảnh vượt quá 5 MB."))).toBe(
      "Chưa lưu được ảnh: Có ảnh vượt quá 5 MB."
    );
    expect(describeImageSaveError(new ApiError(422, "VEHICLE_IMAGE_LIMIT_EXCEEDED", "x"))).toBe(FULL_MESSAGE);
    expect(describeImageSaveError(new ApiError(429, "VEHICLE_IMAGE_UPLOAD_RATE_LIMITED", "x"))).toContain("quá nhanh");
    expect(describeImageSaveError(new ApiError(503, "SERVICE_UNAVAILABLE", "x"))).toContain("Kho lưu ảnh");
    expect(describeImageSaveError(new TypeError("Failed to fetch"))).toContain("kiểm tra kết nối");
  });
});

describe("syncVehicleImages", () => {
  function deps(options: { failUpload?: string[]; replaceError?: unknown } = {}) {
    let next = 0;
    const requestUpload = vi.fn(async () => {
      next += 1;
      return { uploadUrl: `https://upload.test/${next}`, objectKey: `vehicles/o/v/up-${next}.jpg` };
    });
    const uploadFile = vi.fn(async (uploadUrl: string) => {
      if (options.failUpload?.includes(uploadUrl)) {
        throw new TypeError("Failed to fetch");
      }
    });
    const replaceImages = vi.fn(async (input: { images: { objectKey: string; caption: string | null }[] }) => {
      if (options.replaceError) {
        throw options.replaceError;
      }
      return {
        images: input.images.map((image, position) => ({
          id: `srv-${image.objectKey}`,
          objectKey: image.objectKey,
          url: `https://cdn.test/${image.objectKey}`,
          position,
          caption: image.caption
        }))
      };
    });
    return { requestUpload, uploadFile, replaceImages };
  }

  it("tải ảnh mới lên rồi thay bộ ảnh theo đúng thứ tự ở form; ảnh đã lưu không tải lại", async () => {
    const d = deps();
    const items = [fresh("n1", { caption: "Ngoại thất" }), ...toImageItems([saved(0)])];
    const result = await syncVehicleImages(items, d);
    expect(d.requestUpload).toHaveBeenCalledOnce();
    expect(d.requestUpload).toHaveBeenCalledWith({ contentType: "image/jpeg", sizeBytes: 1 });
    expect(d.replaceImages).toHaveBeenCalledWith({
      images: [
        { objectKey: "vehicles/o/v/up-1.jpg", caption: "Ngoại thất" },
        { objectKey: "vehicles/o/v/0.jpg", caption: null }
      ]
    });
    expect(result.failed).toBe(0);
    expect(result.error).toBeNull();
    expect(result.saved?.map((image) => image.position)).toEqual([0, 1]);
    expect(result.items.map((item) => [item.kind, item.objectKey])).toEqual([
      ["saved", "vehicles/o/v/up-1.jpg"],
      ["saved", "vehicles/o/v/0.jpg"]
    ]);
  });

  it("một ảnh tải lỗi: ảnh khác vẫn được gắn, ảnh lỗi giữ đúng chỗ để thử lại", async () => {
    const d = deps({ failUpload: ["https://upload.test/2"] });
    const result = await syncVehicleImages([fresh("a"), fresh("b"), fresh("c")], d);
    expect(result.failed).toBe(1);
    expect(result.error).toBeNull();
    expect(d.replaceImages).toHaveBeenCalledWith({
      images: [
        { objectKey: "vehicles/o/v/up-1.jpg", caption: null },
        { objectKey: "vehicles/o/v/up-3.jpg", caption: null }
      ]
    });
    expect(result.items.map((item) => (item.kind === "new" ? `lỗi:${item.id}` : item.objectKey))).toEqual([
      "vehicles/o/v/up-1.jpg",
      "lỗi:b",
      "vehicles/o/v/up-3.jpg"
    ]);

    // Thử lại: chỉ tải đúng ảnh lỗi, ảnh đã gắn không tải lại.
    const retry = deps();
    const second = await syncVehicleImages(result.items, retry);
    expect(retry.requestUpload).toHaveBeenCalledOnce();
    expect(second.failed).toBe(0);
    expect(second.items.every((item) => item.kind === "saved")).toBe(true);
    expect(second.items).toHaveLength(3);
  });

  it("gắn bộ ảnh lỗi: trả lỗi, ảnh đã tải lên giữ khóa object để lần sau không tải lại", async () => {
    const error = new ApiError(503, "SERVICE_UNAVAILABLE", "x");
    const d = deps({ replaceError: error });
    const result = await syncVehicleImages([fresh("a")], d);
    expect(result.error).toBe(error);
    expect(result.saved).toBeNull();
    expect(result.items).toEqual([expect.objectContaining({ kind: "new", objectKey: "vehicles/o/v/up-1.jpg", failed: false })]);

    const again = deps();
    await syncVehicleImages(result.items, again);
    expect(again.requestUpload).not.toHaveBeenCalled();
  });

  it("xóa hết ảnh: gửi mảng rỗng", async () => {
    const d = deps();
    const result = await syncVehicleImages([], d);
    expect(d.replaceImages).toHaveBeenCalledWith({ images: [] });
    expect(result.items).toEqual([]);
  });
});
