import { initialsOf } from "../../lib/profile/profile-format";

/**
 * Logo nhà xe; chưa có logo → hai chữ viết tắt (Figma "SV"). Logo ở kho công khai: `<img>` thường, không qua bộ tối ưu
 * ảnh của Next; `object-contain` để logo không vuông vẫn hiện đủ. `className` đặt kích thước, bo góc, cỡ chữ.
 */
export function OperatorLogo({ name, logoUrl, className }: { name: string; logoUrl: string | null; className: string }) {
  if (logoUrl) {
    return <img src={logoUrl} alt={`Logo ${name}`} className={`${className} shrink-0 border bg-white object-contain`} />;
  }
  return (
    <span aria-hidden className={`${className} flex shrink-0 items-center justify-center bg-accent font-semibold text-vxn-teal-700`}>
      {initialsOf(name)}
    </span>
  );
}
