import { SlidersHorizontal } from "lucide-react";
import Link from "next/link";

const TIME_RANGES = [
  { value: "00-06", label: "00:00 – 06:00" },
  { value: "06-12", label: "06:00 – 12:00" },
  { value: "12-18", label: "12:00 – 18:00" },
  { value: "18-24", label: "18:00 – 24:00" }
];
const SEAT_TYPES = [
  { value: "seat", label: "Ghế ngồi" },
  { value: "sleeper", label: "Giường nằm" },
  { value: "cabin", label: "Cabin" }
];
const VEHICLE_TYPES = [
  { value: "standard", label: "Tiêu chuẩn" },
  { value: "limousine", label: "Limousine" }
];
/** Tham số tìm kiếm giữ nguyên khi áp dụng lọc (sắp xếp đổi ở thanh tiêu đề danh sách). */
const KEPT_KEYS = ["origin", "destination", "date", "passengers", "operatorId", "sortBy"];

/** Bộ lọc tìm chuyến thật (form GET) theo giao diện Figma 1440:11297, chỉ gồm tiêu chí API hỗ trợ. */
export function LiveTripFilters({ query }: { readonly query: string }) {
  const params = new URLSearchParams(query);
  const resetHref = `/trips?${new URLSearchParams([...params].filter(([key]) => KEPT_KEYS.includes(key)))}`;
  const inputClass = "w-full rounded-lg border border-slate-200 px-3 py-2 text-sm text-vxn-ink outline-none focus:border-[#00506a]";

  return (
    <form action="/trips" method="get" className="w-full rounded-2xl border border-slate-200 bg-white p-4 shadow-2xs">
      {KEPT_KEYS.map((key) => (params.has(key) ? <input key={key} type="hidden" name={key} value={params.get(key) ?? ""} /> : null))}

      <div className="flex items-center justify-between border-b border-slate-100 pb-3">
        <div className="flex items-center gap-2">
          <SlidersHorizontal className="h-4 w-4 text-[#00506a]" />
          <h2 className="text-sm font-bold text-slate-900">Bộ lọc</h2>
        </div>
        <Link href={resetHref} className="text-xs font-semibold text-[#006481] hover:underline">
          Xóa lọc
        </Link>
      </div>

      <div className="mt-4 space-y-5 text-sm">
        <fieldset>
          <legend className="text-[13px] font-semibold text-vxn-ink">Giờ khởi hành</legend>
          <div className="mt-2.5 grid grid-cols-2 gap-2">
            {TIME_RANGES.map((range) => (
              <label key={range.value} className="cursor-pointer">
                <input type="radio" name="timeRange" value={range.value} defaultChecked={params.get("timeRange") === range.value} className="peer sr-only" />
                <span className="block rounded-lg border border-slate-200 py-1.5 text-center text-xs font-medium text-slate-600 transition peer-checked:border-[#00506a] peer-checked:bg-[#e6f3f7] peer-checked:text-[#00506a] peer-focus-visible:ring-2 peer-focus-visible:ring-[#00506a]/30">
                  {range.label}
                </span>
              </label>
            ))}
          </div>
        </fieldset>

        <RadioGroup title="Dạng chỗ" name="seatType" options={SEAT_TYPES} current={params.get("seatType")} />
        <RadioGroup title="Hạng xe" name="vehicleType" options={VEHICLE_TYPES} current={params.get("vehicleType")} />

        <fieldset>
          <legend className="text-[13px] font-semibold text-vxn-ink">Khoảng giá (VND)</legend>
          <div className="mt-2.5 grid grid-cols-2 gap-2">
            <input name="minPriceVnd" aria-label="Giá từ" placeholder="Từ" inputMode="numeric" pattern="[0-9]*" defaultValue={params.get("minPriceVnd") ?? ""} className={inputClass} />
            <input name="maxPriceVnd" aria-label="Giá đến" placeholder="Đến" inputMode="numeric" pattern="[0-9]*" defaultValue={params.get("maxPriceVnd") ?? ""} className={inputClass} />
          </div>
        </fieldset>
      </div>

      <button className="mt-5 w-full rounded-xl bg-[#00506a] py-2.5 text-sm font-bold text-white transition hover:bg-[#00476b]">
        Áp dụng
      </button>
    </form>
  );
}

function RadioGroup({
  title,
  name,
  options,
  current
}: {
  readonly title: string;
  readonly name: string;
  readonly options: readonly { readonly value: string; readonly label: string }[];
  readonly current: string | null;
}) {
  return (
    <fieldset>
      <legend className="text-[13px] font-semibold text-vxn-ink">{title}</legend>
      <div className="mt-2.5 space-y-2">
        {[{ value: "", label: "Tất cả" }, ...options].map((option) => (
          <label key={option.value} className="flex cursor-pointer items-center gap-2.5 text-[13px] text-slate-700">
            <input type="radio" name={name} value={option.value} defaultChecked={(current ?? "") === option.value} className="size-4 accent-[#00506a]" />
            {option.label}
          </label>
        ))}
      </div>
    </fieldset>
  );
}
