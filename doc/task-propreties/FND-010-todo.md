# TASK-FND-010 — Todo: Nền FE web (Tailwind 4 + token VXN + Shadcn/ui + khung layout)

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` §7.1 (thêm 17/09/2026, v0.6).
> **Nguồn thiết kế:** **ADR-013** (Next.js 16 + monorepo; component lib chốt **Shadcn/ui + Tailwind CSS 4** ngày 17/09/2026) · 06 UI/UX §4–§5 (kênh + information architecture) · OQ-20 (marketplace trung lập).
> **Dependency:** `TASK-FND-001` ✓ Done (scaffold 3 app Next).
> **Tham chiếu giao diện:** FE cũ `Ve_Xe_Nhanh_testing/frontend` (Vite + React 18 + antd) — chỉ lấy **token, font, logo, bố cục**; KHÔNG copy code.
> **Làm ở:** worktree `C:\Code\Ve_Xe_Nhanh-fe`, branch `TASK-FND-010` (tạo từ `develop`, không upstream). Chưa commit.

## Trạng thái (17/09/2026)

- 🟡 **Code xong, chờ Khanh review** — chưa commit.
- **Đo được 17/09/2026**: `pnpm turbo run lint typecheck test build --filter=<3 app web + ui>` **15/15** · `packages/ui` Vitest **3/3** · kiểm bằng trình duyệt: 3 app đều render đúng font, màu, logo trên desktop 1280px và mobile 375px, menu trượt mobile mở được, highlight đúng route con, không có thanh cuộn ngang.

## Phạm vi & ranh giới

| Thuộc FND-010                                                        | Để task sau                                                           |
| -------------------------------------------------------------------- | --------------------------------------------------------------------- |
| Tailwind 4 + token VXN + token ngữ nghĩa Shadcn (`packages/ui`)      | Màn hình nghiệp vụ (search, booking, KYC, payout…) → TRN/BTP/OPR/ADM |
| Component Shadcn **chỉ những cái khung đang dùng**: `button`, `sheet` | Component khác: thêm bằng `shadcn add` khi màn hình cần              |
| Font Be Vietnam Pro, logo dùng chung                                 | Đăng nhập, guard route, token web → IAM (cần chốt lưu token web)     |
| Sidebar + footer Marketplace (theo `CustomerShell` FE cũ); sidebar Operator OS + Admin; mục điều hướng theo 06 §5 | API client, mock data, Zod form                                       |
| —                                                                    | **Phần Employee** (Khanh loại khỏi phạm vi)                            |

## Quyết định (Khanh chốt 17/09/2026)

1. **Shadcn/ui cho cả 3 app web**, không dùng antd (kể cả Operator OS/Admin).
2. **Không làm phần của Employee.** Operator OS vẫn có mục "Nhân viên" vì đó là màn hình **Operator quản lý** nhân viên (UC-16), không phải cổng của Employee.
3. Nhánh làm trên **worktree riêng** để không đụng việc dở của `TASK-IAM-002`.
4. **Marketplace dùng sidebar teal** như `CustomerShell` của FE cũ, không dùng header ngang. Bỏ các mục ngoài SRS: "Khám phá" (blog), "Dịch vụ bổ trợ", "Thành viên" (loyalty).

## Giả định AI tự đặt (cần Khanh xác nhận khi review)

- **URL tiếng Anh**, bám tên resource của 05 API (`/vehicles`, `/payouts`, `/tickets/lookup`…). Nhóm sidebar Admin ("Đối tác & người dùng", "Cấu hình", "Tài chính", "Giám sát") là AI đặt tên — doc 06 §5 chỉ liệt kê mục.
- **Font lấy qua `next/font/google`**: build cần mạng để tải font (CI có mạng).
- Trang Operator OS/Admin đặt `robots: noindex`.
- **Không port thông tin liên hệ** (hotline, email, địa chỉ) của FE cũ vì là dữ liệu giả.

## Cạm bẫy đã gặp (đừng mất thời gian lại)

- **FE cũ có code chết.** `CustomerHeader.jsx` không trang nào import; layout khách thật là `CustomerShell` (24 trang dùng). Lần đầu port nhầm header, phải làm lại. **Trước khi port component nào, grep xem nó có thực sự được import không.**
- **Turbo trong worktree mặc định dùng chung cache** với thư mục repo chính. Muốn tách hẳn thì chạy `pnpm turbo run ... --cache-dir=.turbo/cache`.
- **`@source` trong `globals.css` là đường dẫn tính từ chính file CSS** (`packages/ui/src/styles/`). Gốc repo là `../../../../`, không phải `../../../`. Tailwind 4 chỉ tự quét thư mục app đang build nên phải khai thêm source của `packages/ui`.
- **Phải có `@custom-variant dark (&:is(.dark *))`**: nếu thiếu, các class `dark:` trong component Shadcn sẽ bật theo chế độ tối của hệ điều hành, trong khi token dark chưa có.
- **Không truyền icon component từ Server Component sang Client Component.** Hàm không serialize được, nên cấu hình nav (có icon) phải nằm trong file `"use client"` (`components/app-shell.tsx`).
- `packages/ui` xuất **source TSX** (không build `dist`), nên mỗi app cần `transpilePackages: ["@vexenhanh/ui"]`.
- **Link sidebar trỏ tới route chưa có trang nên trả 404**, và console thấy 404 do Next prefetch. Đây là hành vi đúng cho tới khi các task nghiệp vụ tạo trang.
- **Registry Shadcn mới** dùng placeholder `import { cn } from "cn"` (CLI tự viết lại). Khi lấy file tay phải đổi thành `../lib/utils`.

---

## Todo

### ✅ #1 — Ghi quyết định + task vào tài liệu

ADR-013 (chốt Shadcn/ui + Tailwind 4), 06 UI §3, 11 Task (thêm FND-010, v0.6), `AGENTS.md`, `CLAUDE.md`.

### ✅ #2 — `packages/ui`: token + Shadcn

- `src/styles/globals.css`: Tailwind 4, `tw-animate-css`, bảng màu `vxn-teal-*`, `vxn-saffron-*`, `vxn-fg-*`, `vxn-bg-*`, `success/warning/error-*`, `shadow-vxn/card`, `bg-gradient-primary`, breakpoint `xs`, `max-w-8xl`; token ngữ nghĩa Shadcn (`primary` = `#006481`…).
- `package.json` xuất source (`./globals.css`, `./lib/*`, `./components/*`), bỏ `build`/`dist`, thêm `components.json` để chạy `shadcn add`.
- Component: `button`, `sheet` (Shadcn new-york v4), `logo` (`LogoMark` + `LogoWordmark`, một SVG dùng `currentColor` thay cho 2 bản màu của FE cũ), `dashboard-shell`.
- `lib/nav.ts` `isNavItemActive` + test (tránh active nhầm `/trips-archive` ↔ `/trips`).

**Success:** `packages/ui` typecheck + lint + Vitest pass. ✅

### ✅ #3 — Gắn vào 3 app

`postcss.config.mjs`, `next.config.ts` (`transpilePackages`), layout (font + globals).
- Marketplace: `SiteShell` (sidebar teal: nhóm mục chính + nhóm hỗ trợ + nút Đăng ký/Đăng nhập; mobile: thanh trên + menu trượt) + `SiteFooter` + hero trang chủ.
- Operator OS/Admin: `AppShell` với nav theo 06 §5.

**Success:** lint + typecheck + build 3 app pass; kiểm bằng trình duyệt ở desktop và mobile. ✅

### ⬜ #4 — Review + đóng task

- [ ] Khanh review giao diện (`pnpm --filter @vexenhanh/<app> dev`: marketplace :3001, operator-os :3002, admin :3003) và các giả định ở trên.
- [ ] `code-reviewer` trước khi đóng (CLAUDE.md §6.3).
- [ ] Commit (khi Khanh yêu cầu), cập nhật `PROJECT-STATE §7` lúc đóng task. **Chưa sửa PROJECT-STATE** vì branch `TASK-IAM-002` cũng đang sửa file này, sửa song song dễ conflict khi gộp.
- [ ] Chạy CI thật khi mở PR vào `develop`.
