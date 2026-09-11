import "reflect-metadata";
import { Injectable } from "@nestjs/common";

/** Class mồi: có decorator + tham số constructor **suy theo kiểu** — đúng điều kiện để TypeScript phát `design:paramtypes`. */
@Injectable()
class MetadataProbe {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars, no-unused-vars
  constructor(private readonly probe: Date) {}
}

/**
 * NestJS DI và `@nestjs/swagger` đọc `design:paramtypes` — metadata do TypeScript phát khi bật
 * `emitDecoratorMetadata`. **esbuild không hỗ trợ tuỳ chọn này**, mà `tsx` chạy trên esbuild.
 *
 * Phạm vi ảnh hưởng (đã đo 09/09/2026, đừng nói rộng hơn thực tế):
 * - Tham số **suy theo kiểu** (`private readonly x: Foo`) → nhận **`undefined`**.
 * - Tham số có **`@Inject(TOKEN)`** tường minh và provider `useFactory` + `inject: [...]` → **vẫn đúng**,
 *   vì hai cơ chế đó tự ghi metadata riêng, không phụ thuộc `emitDecoratorMetadata`.
 *
 * Vì thế Nest **không ném lỗi** và app **boot bình thường** — nó chỉ dựng class với ít tham số hơn.
 * Lỗi chỉ lộ ra khi handler chạm tới một dependency suy theo kiểu (`TypeError: Cannot read
 * properties of undefined`). Codebase này trộn cả hai kiểu trong cùng constructor (ví dụ
 * `AuthService`), nên biểu hiện là **hỏng một nửa** — khó truy hơn hỏng hẳn.
 *
 * Với `@nestjs/swagger` thì còn kín hơn: thiếu metadata ⇒ không suy được kiểu của `@Body()` ⇒
 * spec sinh ra mất `requestBody`, client gen ra thiếu payload, mà CI vẫn xanh.
 *
 * Hàm này biến lỗi im lặng đó thành lỗi to ngay lúc khởi động.
 *
 * Runtime đã kiểm chứng: `tsc` → OK · `vitest` 4 (rolldown/oxc) → OK · `tsx` (esbuild) → HỎNG.
 */
export function assertDecoratorMetadata(entrypoint: string): void {
  const paramTypes = Reflect.getMetadata("design:paramtypes", MetadataProbe) as unknown[] | undefined;

  if (Array.isArray(paramTypes) && paramTypes.length === 1) {
    return;
  }

  throw new Error(
    [
      `[${entrypoint}] Runtime hiện tại KHÔNG phát decorator metadata (design:paramtypes).`,
      "Hệ quả: dependency inject theo KIỂU sẽ nhận undefined mà Nest không báo lỗi —",
      "app vẫn boot rồi vỡ khi handler chạm tới nó. (@Inject tường minh thì vẫn đúng.)",
      "Nguyên nhân thường gặp: chạy bằng `tsx`/esbuild. Hãy dùng bản biên dịch",
      "(`pnpm build` rồi `node dist/...`) hoặc `pnpm dev` (tsc --watch).",
      "Chi tiết: src/common/assert-decorator-metadata.ts"
    ].join(" ")
  );
}
