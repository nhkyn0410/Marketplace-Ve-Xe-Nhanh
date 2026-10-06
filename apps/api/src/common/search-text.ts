import { z } from "zod";
import type { DbTransaction } from "../database/prisma.service";

/** Tham số `q` của các danh sách: từ khoá tìm theo tên / địa chỉ, tối đa 100 ký tự; `?q=` trống coi như không tìm. */
export const SearchQueryField = z
  .string()
  .trim()
  .max(100)
  .transform((value) => value || undefined)
  .optional();

/**
 * Giá trị cho điều kiện `contains` trên cột `search_text` (chữ thường, bỏ dấu): gõ "ben xe mien dong" vẫn
 * tìm ra "Bến xe Miền Đông". Từ khoá được chuẩn hoá bằng CHÍNH hàm database đã sinh cột (`vxn_search_text`)
 * nên hai phía không thể lệch nhau; ký tự đại diện của LIKE (`%`, `_`, `\`) bị vô hiệu vì Prisma không tự làm.
 */
export async function searchTextContains(
  db: Pick<DbTransaction, "$queryRaw">,
  query: string,
): Promise<string> {
  const [row] = await db.$queryRaw<
    { value: string }[]
  >`SELECT vxn_search_text(${query}) AS value`;
  return (row?.value ?? "").replace(/[\\%_]/g, "\\$&");
}
