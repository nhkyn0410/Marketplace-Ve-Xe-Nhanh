import type { PrismaService } from "./prisma.service";

/**
 * Trong các khóa đưa vào, khóa nào đang được một giấy tờ của hồ sơ đăng ký tham chiếu. Chỉ job dọn giấy tờ mồ côi
 * (TASK-OPR-001) dùng; đặt ở `database/` vì bảng chỉ đọc được ở ngữ cảnh `platform` / `system`.
 */
export async function findReferencedApplicationDocumentKeys(
  prisma: Pick<PrismaService, "withSystem">,
  keys: readonly string[],
): Promise<Set<string>> {
  if (keys.length === 0) {
    return new Set();
  }
  const rows = await prisma.withSystem((tx) =>
    tx.operatorApplicationDocument.findMany({ where: { objectKey: { in: [...keys] } }, select: { objectKey: true } }),
  );
  return new Set(rows.map((row) => row.objectKey));
}
