"use client";

import { ArrowRightLeft, Calendar, MapPin, Search, Tag, Users } from "lucide-react";
import { useRouter } from "next/navigation";
import { useState } from "react";
import type { ProvinceItem } from "../../lib/data/types";

/** Thuộc tính của form tìm chuyến trên trang chủ. */
export interface SearchHeroProps {
  readonly provinces: readonly ProvinceItem[];
  readonly catalogError?: string;
}

/** Banner và form tìm chuyến theo tỉnh thành, ngày đi, số hành khách. */
export function SearchHero({ provinces, catalogError }: SearchHeroProps) {
  const router = useRouter();
  const [origin, setOrigin] = useState("");
  const [destination, setDestination] = useState("");
  const [departureDate, setDepartureDate] = useState("");
  const [passengerCount, setPassengerCount] = useState(1);
  const [actionError, setActionError] = useState<string | null>(null);

  const handleSearch = (event: React.FormEvent): void => {
    event.preventDefault();
    if (!departureDate || !origin || !destination || origin === destination) {
      setActionError("Vui lòng chọn ngày đi và hai điểm đi, đến khác nhau.");
      return;
    }
    router.push(`/trips?${new URLSearchParams({ origin, destination, date: departureDate, passengers: String(passengerCount) })}`);
  };

  return (
    <section className="relative overflow-hidden bg-[#00476b] text-white">
      <div className="absolute inset-0 bg-cover bg-center opacity-40 mix-blend-overlay" style={{ backgroundImage: "url('https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=2000&q=80')" }} />
      <div className="absolute inset-0 bg-gradient-to-b from-[#003b57]/90 via-[#00476b]/80 to-[#07364c]" />
      <div className="relative mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8 lg:py-16">
        <div className="text-center">
          <div className="inline-flex items-center gap-2 rounded-full border border-teal-300/30 bg-teal-500/20 px-3.5 py-1 text-xs font-medium text-teal-100">
            <Tag className="h-3.5 w-3.5" /><span>ĐẶT VÉ XE KHÁCH TRỰC TUYẾN</span>
          </div>
          <h1 className="mt-4 text-3xl font-black tracking-tight sm:text-5xl lg:text-6xl">Đi Việt Nam.<span className="block text-[#f3b132]">Nhanh hơn, gọn hơn.</span></h1>
          <p className="mx-auto mt-4 max-w-2xl text-sm text-teal-100/90 sm:text-base">Tìm chuyến phù hợp, đặt vé thuận tiện.<br />Vé điện tử QR và chính sách rõ ràng trước khi đặt.</p>
        </div>
        <div className="relative mx-auto mt-10 max-w-5xl">
          <div className="inline-block rounded-t-xl bg-white px-6 py-3 text-sm font-bold text-vxn-ink">Tìm chuyến xe</div>
          <div className="rounded-2xl rounded-tl-none bg-white p-5 text-vxn-ink shadow-2xl sm:p-7">
            <form onSubmit={handleSearch} className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-12 lg:items-end">
              <label className="block text-xs font-semibold text-vxn-fg-4 lg:col-span-3">Điểm đi
                <span className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-3 py-2.5 text-sm">
                  <MapPin className="mr-2 h-4 w-4 shrink-0 text-vxn-teal-600" />
                  <select aria-label="Điểm đi" required value={origin} onChange={(event) => setOrigin(event.target.value)} disabled={!provinces.length} className="w-full bg-transparent font-medium text-vxn-ink outline-none">
                    <option value="">Chọn điểm đi</option>{provinces.map((province) => <option key={province.id} value={province.id}>{province.name}</option>)}
                  </select>
                </span>
              </label>
              <div className="flex justify-center lg:col-span-1"><button type="button" aria-label="Đảo chiều điểm đi và điểm đến" onClick={() => { setOrigin(destination); setDestination(origin); }} className="flex h-10 w-10 items-center justify-center rounded-full border border-vxn-border text-vxn-fg-3 hover:text-vxn-teal-700"><ArrowRightLeft className="h-4 w-4" /></button></div>
              <label className="block text-xs font-semibold text-vxn-fg-4 lg:col-span-3">Điểm đến
                <span className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-3 py-2.5 text-sm">
                  <MapPin className="mr-2 h-4 w-4 shrink-0 text-[#e89b26]" />
                  <select aria-label="Điểm đến" required value={destination} onChange={(event) => setDestination(event.target.value)} disabled={!provinces.length} className="w-full bg-transparent font-medium text-vxn-ink outline-none">
                    <option value="">Chọn điểm đến</option>{provinces.map((province) => <option key={province.id} value={province.id}>{province.name}</option>)}
                  </select>
                </span>
              </label>
              <label className="block text-xs font-semibold text-vxn-fg-4 lg:col-span-2">Ngày đi
                <span className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-3 py-2.5 text-sm">
                  <Calendar className="mr-2 h-4 w-4 shrink-0 text-vxn-fg-3" /><input aria-label="Ngày đi" type="date" required value={departureDate} onChange={(event) => setDepartureDate(event.target.value)} className="w-full bg-transparent font-medium text-vxn-ink outline-none" />
                </span>
              </label>
              <label className="block text-xs font-semibold text-vxn-fg-4 lg:col-span-1">Hành khách
                <span className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-2.5 py-2.5 text-sm"><Users className="mr-1.5 h-4 w-4 shrink-0 text-vxn-fg-3" /><input aria-label="Số hành khách" required type="number" min={1} max={10} step={1} value={passengerCount} onChange={(event) => setPassengerCount(Number(event.target.value))} className="w-10 bg-transparent font-semibold text-vxn-ink" /></span>
              </label>
              <button type="submit" disabled={!provinces.length} className="flex items-center justify-center gap-2 rounded-xl bg-[#00506a] px-4 py-3 text-sm font-bold text-white transition hover:bg-[#00476b] disabled:opacity-50 lg:col-span-2"><Search className="h-4 w-4" /><span>Tìm chuyến</span></button>
            </form>
            {(catalogError || actionError) && <p role="alert" className="mt-3 rounded-lg border border-amber-200 bg-amber-50 p-3 text-xs text-amber-800">{catalogError || actionError}</p>}
          </div>
        </div>
      </div>
    </section>
  );
}
