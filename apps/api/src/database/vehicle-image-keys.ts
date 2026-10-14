import type { PrismaService } from "./prisma.service";

/**
 * Trong các khóa đưa vào, khóa nào đang được một dòng `vehicle_images` tham chiếu — xuyên mọi tenant. Chỉ job dọn
 * object mồ côi (TASK-TRN-009) dùng; đặt ở `database/` vì bảng có RLS nên phải đọc ở ngữ cảnh `system`.
 */
export async function findReferencedVehicleImageKeys(
  prisma: Pick<PrismaService, "withSystem">,
  keys: readonly string[],
): Promise<Set<string>> {
  if (keys.length === 0) {
    return new Set();
  }
  const rows = await prisma.withSystem((tx) =>
    tx.vehicleImage.findMany({ where: { objectKey: { in: [...keys] } }, select: { objectKey: true } }),
  );
  return new Set(rows.map((row) => row.objectKey));
}
