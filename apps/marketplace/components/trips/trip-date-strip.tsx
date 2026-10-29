import Link from "next/link";
import { formatTripDateVi } from "../../lib/format";

/**
 * Dải 5 ngày để đổi nhanh ngày đi (giống dải ngày của app): mỗi ô là link giữ nguyên điều kiện đang xem, chỉ đổi `date`
 * và về trang 1.
 */
export function TripDateStrip({ basePath, query, selected, dates }: {
  readonly basePath: string;
  readonly query: string;
  readonly selected: string;
  readonly dates: readonly string[];
}) {
  const hrefFor = (date: string) => {
    const params = new URLSearchParams(query);
    params.set("date", date);
    params.delete("page");
    return `${basePath}?${params}`;
  };

  return (
    <nav aria-label="Đổi ngày đi" className="grid grid-cols-5 gap-2">
      {dates.map((date) => {
        // "T6, 30/10/2026" → thứ + ngày/tháng.
        const [weekday = "", dayMonthYear = ""] = formatTripDateVi(date).split(", ");
        const active = date === selected;
        return (
          <Link
            key={date}
            href={hrefFor(date)}
            aria-current={active ? "date" : undefined}
            aria-label={formatTripDateVi(date)}
            className={`rounded-xl border px-1 py-2 text-center text-xs transition ${
              active ? "border-[#00506a] bg-[#00506a] text-white" : "border-slate-200 bg-white text-slate-600 hover:border-[#00506a]"
            }`}
          >
            <span className="block font-semibold">{weekday}</span>
            <span className="block">{dayMonthYear.slice(0, 5)}</span>
          </Link>
        );
      })}
    </nav>
  );
}
