/** Bộ lọc tìm chuyến thật gửi lại query theo các tiêu chí API hỗ trợ. */
export function LiveTripFilters({ query }: { readonly query: string }) {
  const params = new URLSearchParams(query);
  const inputClass = "w-full rounded-lg border border-vxn-border p-2 text-sm";
  return <form action="/trips" method="get" className="w-full lg:w-64 shrink-0 space-y-4 rounded-2xl border border-vxn-border bg-white p-4">
    <h2 className="font-bold">Bộ lọc</h2>
    {["origin", "destination", "date", "passengers", "operatorId"].map((key) => params.has(key) ? <input key={key} type="hidden" name={key} value={params.get(key) ?? ""} /> : null)}
    <label className="block text-sm">Giờ đi<select name="timeRange" defaultValue={params.get("timeRange") ?? ""} className={inputClass}>
      <option value="">Tất cả</option>{["00-06", "06-12", "12-18", "18-24"].map((v) => <option key={v} value={v}>{v.replace("-", ":00 – ")}:00</option>)}
    </select></label>
    <label className="block text-sm">Dạng chỗ<select name="seatType" defaultValue={params.get("seatType") ?? ""} className={inputClass}>
      <option value="">Tất cả</option><option value="seat">Ghế ngồi</option><option value="sleeper">Giường nằm</option><option value="cabin">Cabin</option>
    </select></label>
    <label className="block text-sm">Hạng xe<select name="vehicleType" defaultValue={params.get("vehicleType") ?? ""} className={inputClass}>
      <option value="">Tất cả</option><option value="standard">Tiêu chuẩn</option><option value="limousine">Limousine</option>
    </select></label>
    <label className="block text-sm">Giá từ (VND)<input name="minPriceVnd" inputMode="numeric" pattern="[0-9]*" defaultValue={params.get("minPriceVnd") ?? ""} className={inputClass} /></label>
    <label className="block text-sm">Giá đến (VND)<input name="maxPriceVnd" inputMode="numeric" pattern="[0-9]*" defaultValue={params.get("maxPriceVnd") ?? ""} className={inputClass} /></label>
    <label className="block text-sm">Sắp xếp<select name="sortBy" defaultValue={params.get("sortBy") ?? "earliest"} className={inputClass}>
      <option value="earliest">Giờ đi sớm</option><option value="price_asc">Giá thấp</option><option value="fastest">Đi nhanh nhất</option>
    </select></label>
    <button className="w-full rounded-xl bg-vxn-teal-800 p-2 font-bold text-white">Áp dụng</button>
  </form>;
}
