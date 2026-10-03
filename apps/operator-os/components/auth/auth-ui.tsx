"use client";

import { Button } from "@vexenhanh/ui/components/button";
import { LogoWordmark } from "@vexenhanh/ui/components/logo";
import { cn } from "@vexenhanh/ui/lib/utils";
import { EyeOff } from "lucide-react";
import { useEffect, useId, useState, type ComponentProps, type ReactNode } from "react";

// Khối dựng giao diện luồng đăng nhập nhà xe theo Figma "Giao diện nhà xe" (section 830:1977).
// Figma chỉ có khung 1440×890 → co giãn cho desktop từ 1280px: nội dung tối đa 1440px ở giữa (màn
// 1920/2560 không dạt ra hai mép), lề ngang 48px khi hẹp hơn 1440, và khung nhìn thấp hơn 890px
// (laptop 1366×768, 1920×1080 phóng 125%) thu khoảng đệm dọc qua biến thể `[@media(max-height:889px)]`.
// Bản màn hình hẹp (<1280px) chưa có thiết kế.
// Biểu tượng là asset xuất từ Figma (public/auth/*.svg) → <img> thường, không qua next/image.

const MONO = "font-[family-name:var(--font-jetbrains-mono),ui-monospace,monospace]";

/** Nền gradient + logo + chân trang dùng chung cho mọi màn xác thực. */
export function AuthPage({ languageChip = true, children }: { languageChip?: boolean; children: ReactNode }) {
  // globals.css chừa sẵn chỗ thanh cuộn (scrollbar-gutter: stable) → lộ dải nền trắng cạnh gradient tràn viền.
  useEffect(() => {
    const root = document.documentElement;
    const previous = root.style.scrollbarGutter;
    root.style.scrollbarGutter = "auto";
    return () => {
      root.style.scrollbarGutter = previous;
    };
  }, []);

  return (
    <div className="flex min-h-screen flex-col bg-vxn-bg-soft">
      <div className="flex flex-1 flex-col bg-[linear-gradient(58.28deg,rgb(10,40,64)_15.109%,rgba(53,113,141,0.7)_70.074%,rgb(0,80,106)_87.469%)]">
        <header className="mx-auto flex w-full max-w-[1440px] items-center justify-between px-12 pt-16 pb-6 min-[1440px]:px-[94px] [@media(max-height:889px)]:pt-5 [@media(max-height:889px)]:pb-3">
          <LogoWordmark className="h-[60px] w-[235px] text-white [@media(max-height:889px)]:h-12 [@media(max-height:889px)]:w-[188px]" />
          {languageChip && (
            // v1 chỉ có tiếng Việt (OQ-12): nhãn trang trí, không phải nút chọn ngôn ngữ.
            <div
              aria-hidden
              className="flex h-8 items-center gap-2 rounded-full border border-white/20 bg-white/15 px-3 backdrop-blur-[8px]"
            >
              <span className="grid h-3.5 w-[22px] place-items-center rounded-[2px] bg-[#da251d] text-[9px] leading-[9px] font-medium text-[#ffcd00]">
                ★
              </span>
              <span className="text-[13px] font-medium text-white">VI</span>
            </div>
          )}
        </header>
        {children}
        <footer className="flex items-end justify-center py-[35px] [@media(max-height:889px)]:py-3">
          <p className="text-sm leading-5 text-white/[0.72]">Cổng quản lý dành cho chủ nhà xe</p>
        </footer>
      </div>
    </div>
  );
}

/** Vùng hai cột: hero bên trái, thẻ form bên phải. */
export function AuthMain({ children }: { children: ReactNode }) {
  return (
    <main className="mx-auto flex w-full max-w-[1440px] flex-1 items-center justify-between gap-10 px-12 py-2 min-[1440px]:px-[94px]">
      {children}
    </main>
  );
}

function HeroChip({ children }: { children: ReactNode }) {
  return (
    <div className="flex w-fit items-center gap-2 rounded-full bg-white/15 px-7 py-3">
      <span className="size-1.5 rounded-full bg-white opacity-90" />
      <span className="text-xs font-semibold tracking-[0.96px] text-white uppercase">{children}</span>
    </div>
  );
}

/** Hero màn đăng nhập (chữ 56px); co lại nhường chỗ cho thẻ form, thẻ luôn giữ đủ bề rộng. */
export function LoginHero() {
  return (
    <div className="flex w-[648px] min-w-0 flex-col">
      <HeroChip>Cổng nhà xe</HeroChip>
      <p className="pt-5 text-[56px] leading-[58.8px] font-bold tracking-[-1.12px] text-[#e2e8f0]">
        Mỗi chuyến xe
        <br />
        là một <span className="text-vxn-saffron-500">hành trình</span>
        <br />
        đáng được quản lý tốt.
      </p>
      <p className="max-w-[460px] pt-5 text-[17px] leading-[25.5px] text-[#e2e8f0]">
        Đăng nhập để theo dõi lịch trình, lấp đầy ghế trống và đối soát doanh thu trong một bảng điều khiển duy
        nhất.
      </p>
    </div>
  );
}

/** Hero các bước bảo mật (đổi mật khẩu, xác thực hai lớp, mã dự phòng). */
export function StepHero({ accent, title, description }: { accent: string; title: string; description: [string, string] }) {
  return (
    <div className="flex w-[600px] min-w-0 flex-col gap-6">
      <HeroChip>Bảo mật tài khoản</HeroChip>
      <p className="text-[44px] leading-[56px] font-bold text-white">
        <span className="text-vxn-saffron-500">{accent}</span>
        <br />
        {title}
      </p>
      <p className="max-w-[580px] text-base leading-6 text-white">
        {description[0]}
        <br />
        {description[1]}
      </p>
    </div>
  );
}

/** Thẻ form màn đăng nhập. */
export function LoginCard({ children }: { children: ReactNode }) {
  return (
    <div className="flex w-[470px] shrink-0 flex-col gap-4 rounded-[10px] border border-white/20 bg-white/[0.97] p-9 shadow-[0_25px_50px_rgba(0,0,0,0.45)] backdrop-blur-[12px] [@media(max-height:889px)]:p-7">
      {children}
    </div>
  );
}

/** Thẻ form các bước bảo mật; tiêu đề h1 để trình đọc màn hình và E2E định vị bước hiện tại. */
export function StepCard({
  title,
  description,
  className,
  children
}: {
  title: string;
  description: ReactNode;
  className?: string;
  children: ReactNode;
}) {
  return (
    <div
      className={cn(
        "flex w-[470px] shrink-0 flex-col gap-4 rounded-xl bg-white p-8 shadow-[0_24px_48px_-12px_rgba(16,24,40,0.18)] [@media(max-height:889px)]:p-6",
        className
      )}
    >
      <div className="flex flex-col gap-2">
        <h1 className="text-[26px] leading-[34px] font-semibold text-[#0a2840]">{title}</h1>
        <p className="text-sm leading-5 text-vxn-fg-4">{description}</p>
      </div>
      {children}
    </div>
  );
}

type InputProps = Omit<ComponentProps<"input">, "className">;

function PasswordToggle({ shown, onToggle, className }: { shown: boolean; onToggle: () => void; className?: string }) {
  return (
    <button
      type="button"
      onClick={onToggle}
      aria-label={shown ? "Ẩn mật khẩu" : "Hiện mật khẩu"}
      aria-pressed={shown}
      className={cn("grid shrink-0 place-items-center rounded outline-none focus-visible:ring-2 focus-visible:ring-ring", className)}
    >
      {shown ? (
        // Figma chỉ có biểu tượng "hiện"; trạng thái đang hiện dùng EyeOff cùng màu/độ mờ.
        <EyeOff className="size-4 text-[#64748b] opacity-70" />
      ) : (
        <img src="/auth/eye.svg" alt="" width={16} height={16} className="opacity-70" />
      )}
    </button>
  );
}

/** Ô nhập màn đăng nhập: biểu tượng đầu dòng, cao 42px, có thể là ô mật khẩu với nút hiện/ẩn. */
export function LoginField({
  label,
  icon,
  password = false,
  invalid = false,
  ...input
}: InputProps & { label: string; icon: "user" | "lock"; password?: boolean; invalid?: boolean }) {
  const id = useId();
  const [shown, setShown] = useState(false);
  return (
    <div className="flex flex-col gap-1.5">
      <label htmlFor={id} className="flex items-center gap-1 text-[13px] font-medium text-[#334155]">
        {label}
        <span aria-hidden className="text-[#f87171]">
          *
        </span>
      </label>
      <div
        className={cn(
          "flex h-[42px] items-center gap-2 rounded-lg border bg-white px-3 focus-within:ring-[3px] focus-within:ring-ring/40",
          invalid ? "border-[#d32f24]" : "border-vxn-border-strong"
        )}
      >
        <img src={`/auth/${icon}.svg`} alt="" width={16} height={16} className={icon === "lock" ? "opacity-70" : undefined} />
        <input
          id={id}
          type={password && !shown ? "password" : "text"}
          aria-invalid={invalid}
          required
          className="min-w-0 flex-1 bg-transparent text-base leading-6 text-vxn-ink outline-none placeholder:text-[#74777b]"
          {...input}
        />
        {password && <PasswordToggle shown={shown} onToggle={() => setShown((value) => !value)} className="size-6" />}
      </div>
    </div>
  );
}

/** Ô nhập các bước bảo mật: cao 52px, gợi ý bên dưới, dòng lỗi giữ chỗ 20px để form không nhảy. */
export function StepField({
  label,
  helper,
  error,
  password = false,
  mono = false,
  monoPlaceholder = false,
  ...input
}: InputProps & {
  label: string;
  helper?: ReactNode;
  error?: string;
  password?: boolean;
  mono?: boolean;
  monoPlaceholder?: boolean;
}) {
  const id = useId();
  const [shown, setShown] = useState(false);
  return (
    <div className="flex flex-col gap-1.5">
      <label htmlFor={id} className="text-sm leading-5 font-medium text-[#0a2840]">
        {label}
      </label>
      <div
        className={cn(
          "flex h-[52px] items-center gap-2 rounded-lg border bg-white px-3 focus-within:ring-[3px] focus-within:ring-ring/40",
          error ? "border-[#d32f24]" : "border-[#93969a]"
        )}
      >
        <input
          id={id}
          type={password && !shown ? "password" : "text"}
          aria-invalid={Boolean(error)}
          aria-describedby={`${id}-note`}
          required
          className={cn(
            "min-w-0 flex-1 bg-transparent text-[#0a2840] outline-none placeholder:text-vxn-fg-4",
            mono ? `${MONO} text-sm leading-[22px]` : "text-base leading-6",
            mono && !monoPlaceholder && "placeholder:font-sans placeholder:text-base"
          )}
          {...input}
        />
        {password && <PasswordToggle shown={shown} onToggle={() => setShown((value) => !value)} className="size-10" />}
      </div>
      <div id={`${id}-note`} className="flex flex-col gap-1.5">
        {helper && <p className="text-sm leading-5 text-vxn-fg-4">{helper}</p>}
        <FieldError>{error}</FieldError>
      </div>
    </div>
  );
}

/** Dòng lỗi dưới ô nhập; không có lỗi vẫn giữ chiều cao như thiết kế. */
export function FieldError({ children }: { children?: string }) {
  return (
    <p role={children ? "alert" : undefined} className="min-h-5 text-xs font-medium text-[#d32f24]">
      {children}
    </p>
  );
}

function ButtonSpinner() {
  return <img src="/auth/spinner-button.svg" alt="" width={16} height={16} className="animate-spin" />;
}

type ActionProps = Omit<ComponentProps<typeof Button>, "variant" | "size"> & { loading?: boolean; loadingLabel?: string };

/** Nút chính màn đăng nhập và đổi mật khẩu (cao 46px, góc 4px). */
export function LoginButton({ loading = false, loadingLabel, children, className, ...props }: ActionProps) {
  return (
    <Button
      className={cn(
        "h-[46px] w-full rounded bg-vxn-teal-800 font-[Arial,sans-serif] text-[15px] font-bold text-white drop-shadow-[0_10px_7.5px_rgba(0,100,129,0.2)] hover:bg-vxn-teal-800/90 disabled:opacity-100",
        loading && "font-sans text-sm font-medium tracking-[0.14px]",
        className
      )}
      disabled={loading || props.disabled}
      {...props}
    >
      {loading && <ButtonSpinner />}
      {loading ? loadingLabel : children}
    </Button>
  );
}

/**
 * Nút "VXN / Auth button" (cao 52px, góc 12px): chính, phụ (viền), vô hiệu hóa (xám) và đang xử lý
 * (spinner + nhãn, giữ nguyên kích thước, khóa gửi lặp).
 */
export function AuthButton({
  secondary = false,
  loading = false,
  loadingLabel,
  children,
  className,
  ...props
}: ActionProps & { secondary?: boolean }) {
  return (
    <Button
      className={cn(
        "h-[52px] w-full rounded-xl px-3 text-sm font-medium tracking-[0.14px] disabled:opacity-100",
        secondary
          ? "border border-vxn-teal-700 bg-white text-vxn-teal-700 hover:bg-vxn-teal-50"
          : "bg-vxn-teal-700 text-white hover:bg-vxn-teal-700/90",
        !loading && "disabled:bg-[#e4e5e7] disabled:text-vxn-fg-4",
        className
      )}
      disabled={loading || props.disabled}
      {...props}
    >
      {loading && <ButtonSpinner />}
      {loading ? loadingLabel : children}
    </Button>
  );
}

/** "VXN / Auth back link": quay về màn đăng nhập. */
export function BackLink({ onClick }: { onClick: () => void }) {
  return (
    <button
      type="button"
      onClick={onClick}
      className="h-10 w-full rounded text-sm leading-5 font-medium text-vxn-teal-700 outline-none hover:underline focus-visible:ring-2 focus-visible:ring-ring"
    >
      Quay lại đăng nhập
    </button>
  );
}

export type NoticeTone = "success" | "warning" | "danger";

const NOTICE_BADGE: Record<NoticeTone, string> = {
  success: "bg-[#edfbf3]",
  warning: "bg-[#fef8ec]",
  danger: "bg-[#fef0ef]"
};

/**
 * "VXN / Auth notice dialog": hộp thoại thông báo giữa màn hình. Overlay là lớp tuyệt đối, không chiếm
 * chỗ trong form; đóng hộp thoại chỉ ẩn lớp thông báo và giữ nguyên dữ liệu bên dưới.
 */
export function NoticeDialog({
  tone,
  title,
  description,
  actionLabel,
  onAction
}: {
  tone: NoticeTone;
  title: string;
  description: string[];
  actionLabel: string;
  onAction: () => void;
}) {
  const titleId = useId();
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-[rgba(10,40,64,0.5)] p-4">
      <div
        role="alertdialog"
        aria-modal="true"
        aria-labelledby={titleId}
        className="flex w-[480px] max-w-full flex-col items-center gap-6 rounded-xl bg-white p-8 shadow-[0_24px_48px_-12px_rgba(16,24,40,0.18)]"
      >
        <div className={cn("grid size-14 place-items-center rounded-full", NOTICE_BADGE[tone])}>
          <img src={`/auth/notice-${tone}.svg`} alt="" width={28} height={28} />
        </div>
        <div className="flex w-full flex-col gap-2 text-center">
          <h2 id={titleId} className="text-[26px] leading-[34px] font-semibold text-[#0a2840]">
            {title}
          </h2>
          <p className="text-sm leading-5 text-vxn-fg-4">
            {description.map((line) => (
              <span key={line} className="block">
                {line}
              </span>
            ))}
          </p>
        </div>
        <AuthButton type="button" autoFocus onClick={onAction}>
          {actionLabel}
        </AuthButton>
      </div>
    </div>
  );
}

/** Trạng thái chờ toàn trang (kiểm tra phiên, chuyển tiếp): chưa hiện sidebar hay dữ liệu bảo vệ. */
export function AuthLoading({ label }: { label: string }) {
  return (
    <AuthPage languageChip={false}>
      <main className="flex flex-1 flex-col items-center justify-center gap-4" role="status" aria-live="polite">
        <div className="relative size-8">
          <img src="/auth/spinner-track.svg" alt="" width={32} height={32} />
          <div className="absolute inset-0 animate-spin">
            <img src="/auth/spinner-arc.svg" alt="" width={16} height={16} className="absolute top-0 right-0" />
          </div>
        </div>
        <p className="text-base leading-6 text-white">{label}</p>
      </main>
    </AuthPage>
  );
}

/** Chữ đơn cách (khóa thiết lập, mã dự phòng) — "VXN / Auth / Code". */
export const AUTH_MONO = `${MONO} text-sm leading-[22px] text-[#0a2840]`;
