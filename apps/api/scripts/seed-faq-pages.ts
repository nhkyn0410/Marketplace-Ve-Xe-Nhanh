import { existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient, ContentPageType, ContentPlacement, ContentPageStatus } from "../src/generated/prisma/client";

/**
 * Định nghĩa cấu trúc bản ghi FAQ từ file dữ liệu crawl hoặc datasheet.
 */
interface RawFaqItem {
  readonly order?: number;
  readonly type: string;
  readonly placement: string;
  readonly slug?: string | null;
  readonly title: string;
  readonly displayOrder: number;
  readonly status: string;
  readonly bodyMarkdown: string;
}

/**
 * Cấu trúc file JSON articles-and-pages.json.
 */
interface CrawledContentData {
  readonly contentPages?: readonly RawFaqItem[];
}

/**
 * Cấu trúc đầu ra thống kê quá trình seed FAQ.
 */
interface SeedFaqResult {
  readonly total: number;
  readonly inserted: number;
  readonly updated: number;
}

/**
 * Nạp biến môi trường theo môi trường chỉ định (.env và .env.{NODE_ENV}).
 */
function loadEnv(): void {
  const nodeEnv = process.env.NODE_ENV?.trim() || "development";
  const envFiles = [".env", `.env.${nodeEnv}`];
  for (const file of envFiles) {
    const filePath = resolve(process.cwd(), file);
    if (existsSync(filePath)) {
      process.loadEnvFile(filePath);
    }
  }
}

/**
 * Đọc danh sách 18 câu hỏi thường gặp từ file crawled JSON chuẩn hóa.
 *
 * @returns Danh sách các câu hỏi thường gặp hợp lệ theo chuẩn schema.
 */
function loadFaqData(): readonly RawFaqItem[] {
  const jsonPath = resolve(process.cwd(), "prisma/seed-data/crawled/articles-and-pages.json");
  if (!existsSync(jsonPath)) {
    throw new Error(`Không tìm thấy file dữ liệu: ${jsonPath}`);
  }

  const rawContent = readFileSync(jsonPath, "utf8");
  const parsedData = JSON.parse(rawContent) as CrawledContentData;
  const contentPages = parsedData.contentPages ?? [];

  const faqs = contentPages.filter(
    (item): item is RawFaqItem => item.type === "FAQ" && typeof item.title === "string" && typeof item.bodyMarkdown === "string",
  );

  if (faqs.length === 0) {
    throw new Error("Không tìm thấy dữ liệu FAQ nào trong file articles-and-pages.json");
  }

  return faqs;
}

/**
 * Chuyển đổi chuỗi vị trí sang ContentPlacement enum hợp lệ.
 *
 * @param placement - Chuỗi vị trí từ file dữ liệu.
 * @returns Enum ContentPlacement tương ứng.
 */
function parsePlacement(placement: string): ContentPlacement {
  switch (placement) {
    case "BOOKING":
      return ContentPlacement.BOOKING;
    case "TICKET":
      return ContentPlacement.TICKET;
    case "ACCOUNT":
      return ContentPlacement.ACCOUNT;
    default:
      throw new Error(`Vị trí FAQ không hợp lệ: ${placement}`);
  }
}

/**
 * Script nạp dữ liệu câu hỏi thường gặp (FAQ) vào cơ sở dữ liệu.
 * Hoạt động an toàn và idempotent (upsert theo type, placement và displayOrder).
 */
async function main(): Promise<void> {
  // Cho phép chỉ định cờ --production khi chạy dòng lệnh
  if (process.argv.includes("--production")) {
    process.env.NODE_ENV = "production";
  }

  loadEnv();

  const connectionString = process.env.MIGRATION_DATABASE_URL ?? process.env.DATABASE_URL;
  if (!connectionString) {
    throw new Error("MIGRATION_DATABASE_URL hoặc DATABASE_URL là bắt buộc để thực thi seed.");
  }

  const dbUrl = new URL(connectionString);
  console.log(`Bắt đầu seed FAQ vào cơ sở dữ liệu: ${dbUrl.host}${dbUrl.pathname} (Môi trường: ${process.env.NODE_ENV ?? "development"})`);

  const faqItems = loadFaqData();
  console.log(`Đã đọc ${faqItems.length} câu hỏi thường gặp từ file dữ liệu chuẩn.`);

  const prisma = new PrismaClient({
    adapter: new PrismaPg({ connectionString }),
  });

  try {
    const result: SeedFaqResult = await prisma.$transaction(async (tx) => {
      // Thiết lập scope hệ thống để vượt qua Row-Level Security (RLS) của bảng content_pages
      await tx.$executeRaw`SELECT set_config('app.scope', 'system', true)`;

      // Tìm tài khoản Platform Admin làm người tạo / cập nhật bản ghi
      const adminAccount = await tx.platformAccount.findFirst({
        where: { role: "PLATFORM_ADMIN", status: "ACTIVE" },
        orderBy: { createdAt: "asc" },
        select: { id: true, username: true },
      });

      if (!adminAccount) {
        throw new Error("Không tìm thấy tài khoản PLATFORM_ADMIN nào trong cơ sở dữ liệu để gán quyền tác giả.");
      }

      console.log(`Gán tác giả nội dung cho Platform Admin: ${adminAccount.username} (${adminAccount.id})`);

      let insertedCount = 0;
      let updatedCount = 0;
      const now = new Date();

      for (const item of faqItems) {
        const placement = parsePlacement(item.placement);
        const displayOrder = item.displayOrder;

        // Tìm bản ghi hiện có theo cặp (type, placement, displayOrder) hoặc tiêu đề
        const existing = await tx.contentPage.findFirst({
          where: {
            type: ContentPageType.FAQ,
            placement,
            displayOrder,
          },
          select: { id: true },
        });

        if (existing) {
          await tx.contentPage.update({
            where: { id: existing.id },
            data: {
              title: item.title,
              bodyMarkdown: item.bodyMarkdown,
              slug: null,
              imageKey: null,
              linkUrl: null,
              status: ContentPageStatus.PUBLISHED,
              publishedAt: now,
              updatedBy: adminAccount.id,
            },
          });
          updatedCount += 1;
        } else {
          await tx.contentPage.create({
            data: {
              type: ContentPageType.FAQ,
              placement,
              title: item.title,
              slug: null,
              bodyMarkdown: item.bodyMarkdown,
              imageKey: null,
              linkUrl: null,
              displayOrder,
              status: ContentPageStatus.PUBLISHED,
              publishedAt: now,
              createdBy: adminAccount.id,
              updatedBy: adminAccount.id,
            },
          });
          insertedCount += 1;
        }
      }

      return {
        total: faqItems.length,
        inserted: insertedCount,
        updated: updatedCount,
      };
    });

    console.log(`Seed FAQ thành công! Tổng số: ${result.total} câu. Tạo mới: ${result.inserted}, Cập nhật: ${result.updated}.`);
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((error: unknown) => {
  console.error("Lỗi khi thực thi seed FAQ:", error);
  process.exit(1);
});
