// Tham số URL của trình soạn sơ đồ ghế. Chỉ nhận đúng dạng mong đợi — giá trị lạ bị bỏ qua, để đường dẫn
// "quay lại" luôn là một trang trong app.
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

type Param = string | string[] | undefined;

/** `copyFrom`: id sơ đồ nguồn khi tạo bản sao. */
export function parseSeatMapId(value: Param): string | undefined {
  return typeof value === "string" && UUID.test(value) ? value : undefined;
}

/** `vehicle`: form phương tiện đã mở trình soạn — `new` (đang thêm xe) hoặc id của xe đang sửa. */
export function parseVehicleReturn(value: Param): string | undefined {
  return typeof value === "string" && (value === "new" || UUID.test(value)) ? value : undefined;
}
