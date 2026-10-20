"use client";

import {
  ArrowRightLeft,
  Calendar,
  ChevronDown,
  ChevronRight,
  Globe,
  MapPin,
  PhoneCall,
  Search,
  Star,
  Tag,
  Users
} from "lucide-react";
import Link from "next/link";
import { useState } from "react";
import { FeaturedOperatorItem, ProvinceItem } from "../../lib/data/types";

/**
 * Thuộc tính của khối SearchHero trên trang chủ.
 */
export interface SearchHeroProps {
  readonly provinces: readonly ProvinceItem[];
  readonly featuredOperators: readonly FeaturedOperatorItem[];
  readonly initialTab?: "trip" | "operator";
  readonly initialPickerOpen?: boolean;
}

/**
 * Khối Banner Hero & Form tìm kiếm chuyến xe 2 tab (Theo chuyến & Theo nhà xe).
 */
export function SearchHero({
  provinces,
  featuredOperators,
  initialTab = "trip",
  initialPickerOpen = false
}: SearchHeroProps) {
  const [activeTab, setActiveTab] = useState<"trip" | "operator">(initialTab);
  const [origin, setOrigin] = useState<string>("");
  const [destination, setDestination] = useState<string>("");
  const [departureDate, setDepartureDate] = useState<string>("");
  const [passengerCount] = useState<number>(1);

  const [selectedOperator, setSelectedOperator] = useState<FeaturedOperatorItem | null>(null);
  const [selectedRoute, setSelectedRoute] = useState<string>("");
  const [isPickerOpen, setIsPickerOpen] = useState<boolean>(initialPickerOpen);
  const [actionError, setActionError] = useState<string | null>(null);

  /**
   * Đảo chiều điểm đi và điểm đến.
   */
  const handleSwapLocations = (): void => {
    const temp = origin;
    setOrigin(destination);
    setDestination(temp);
  };

  /**
   * Xử lý tìm chuyến — hiện thông báo lỗi tại chỗ vì chưa có API tìm kiếm.
   */
  const handleSearch = (e: React.FormEvent): void => {
    e.preventDefault();
    console.warn("[Marketplace] Tìm kiếm chuyến xe: API tìm chuyến (GET /catalog/trips) chưa sẵn sàng.");
    setActionError("Dịch vụ tìm chuyến đang được đồng bộ dữ liệu. Vui lòng thử lại sau.");
  };

  return (
    <section className="relative overflow-hidden bg-[#00476b] text-white">
      {/* Background Ảnh phong cảnh Việt Nam và xe khách */}
      <div
        className="absolute inset-0 bg-cover bg-center opacity-40 mix-blend-overlay"
        style={{
          backgroundImage:
            "url('https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=2000&q=80')"
        }}
      />
      {/* Lớp phủ gradient mượt */}
      <div className="absolute inset-0 bg-gradient-to-b from-[#003b57]/90 via-[#00476b]/80 to-[#07364c]" />

      {/* Top action: CSKH & Ngôn ngữ (góc trên bên phải) */}
      <div className="relative mx-auto flex max-w-7xl items-center justify-end gap-3 px-4 pt-4 sm:px-6 lg:px-8">
        <a
          href="tel:19006067"
          className="inline-flex items-center gap-1.5 rounded-full bg-white/10 px-3.5 py-1 text-xs font-medium text-white backdrop-blur-xs transition hover:bg-white/20"
        >
          <PhoneCall className="h-3 w-3 text-[#f3b132]" />
          <span>CSKH 1900 6067</span>
        </a>
        <div className="inline-flex items-center gap-1.5 rounded-full bg-white/10 px-3 py-1 text-xs font-medium text-white backdrop-blur-xs">
          <Globe className="h-3 w-3" />
          <span>VI</span>
          <ChevronDown className="h-3 w-3 opacity-70" />
        </div>
      </div>

      <div className="relative mx-auto max-w-7xl px-4 pt-6 pb-16 sm:px-6 lg:px-8 lg:pt-8 lg:pb-20">
        {/* Tagline & Header */}
        <div className="text-center">
          <div className="inline-flex items-center gap-2 rounded-full border border-teal-300/30 bg-teal-500/20 px-3.5 py-1 text-xs font-medium text-teal-100 backdrop-blur-xs">
            <Tag className="h-3.5 w-3.5" />
            <span>ĐẶT VÉ XE KHÁCH TRỰC TUYẾN</span>
          </div>

          <h1 className="mt-4 text-3xl font-black tracking-tight sm:text-5xl lg:text-6xl">
            Đi Việt Nam.
            <span className="block text-[#f3b132]">Nhanh hơn, gọn hơn.</span>
          </h1>

          <p className="mx-auto mt-4 max-w-2xl text-sm text-teal-100/90 sm:text-base">
            Tìm chuyến phù hợp, đặt vé thuận tiện.
            <br className="hidden sm:inline" />
            Vé điện tử QR và chính sách rõ ràng trước khi đặt.
          </p>
        </div>

        {/* Khung Form Tìm kiếm */}
        <div className="relative mx-auto mt-10 max-w-5xl">
          {/* Tab switcher */}
          <div className="flex items-center gap-1 px-4">
            <button
              type="button"
              onClick={() => {
                setActiveTab("trip");
                setIsPickerOpen(false);
              }}
              className={`rounded-t-xl px-6 py-3 text-sm font-bold transition-colors ${
                activeTab === "trip"
                  ? "bg-white text-vxn-ink shadow-md"
                  : "bg-white/10 text-white/85 hover:bg-white/20 hover:text-white"
              }`}
            >
              Mua vé
            </button>
            <button
              type="button"
              onClick={() => {
                setActiveTab("operator");
              }}
              className={`rounded-t-xl px-6 py-3 text-sm font-bold transition-colors ${
                activeTab === "operator"
                  ? "bg-white text-vxn-ink shadow-md"
                  : "bg-white/10 text-white/85 hover:bg-white/20 hover:text-white"
              }`}
            >
              Theo nhà xe
            </button>
          </div>

          {/* Form nội dung */}
          <div className="rounded-2xl rounded-tl-none bg-white p-5 shadow-2xl text-vxn-ink sm:p-7">
            <form onSubmit={handleSearch}>
              {activeTab === "trip" ? (
                /* TAB 1: THEO CHUYẾN */
                <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-12 lg:items-center">
                  {/* Điểm đi */}
                  <div className="relative lg:col-span-3">
                    <label className="block text-xs font-semibold text-vxn-fg-4">Điểm đi</label>
                    <div className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-3 py-2.5 text-sm focus-within:border-vxn-teal-600 focus-within:bg-white">
                      <MapPin className="mr-2 h-4 w-4 shrink-0 text-vxn-teal-600" />
                      <select
                        value={origin}
                        onChange={(e) => setOrigin(e.target.value)}
                        className="w-full bg-transparent font-medium text-vxn-ink outline-none"
                      >
                        <option value="">Chọn điểm đi</option>
                        {provinces.map((p) => (
                          <option key={p.id} value={p.id}>
                            {p.name}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>

                  {/* Nút hoán đổi */}
                  <div className="flex items-center justify-center lg:col-span-1">
                    <button
                      type="button"
                      onClick={handleSwapLocations}
                      title="Đảo chiều điểm đi - điểm đến"
                      className="inline-flex h-10 w-10 items-center justify-center rounded-full border border-vxn-border bg-white text-vxn-fg-3 shadow-xs transition hover:border-vxn-teal-500 hover:text-vxn-teal-700"
                    >
                      <ArrowRightLeft className="h-4 w-4" />
                    </button>
                  </div>

                  {/* Điểm đến */}
                  <div className="relative lg:col-span-3">
                    <label className="block text-xs font-semibold text-vxn-fg-4">Điểm đến</label>
                    <div className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-3 py-2.5 text-sm focus-within:border-vxn-teal-600 focus-within:bg-white">
                      <MapPin className="mr-2 h-4 w-4 shrink-0 text-[#e89b26]" />
                      <select
                        value={destination}
                        onChange={(e) => setDestination(e.target.value)}
                        className="w-full bg-transparent font-medium text-vxn-ink outline-none"
                      >
                        <option value="">Chọn điểm đến</option>
                        {provinces.map((p) => (
                          <option key={p.id} value={p.id}>
                            {p.name}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>

                  {/* Ngày đi */}
                  <div className="relative lg:col-span-2">
                    <label className="block text-xs font-semibold text-vxn-fg-4">Ngày đi</label>
                    <div className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-3 py-2.5 text-sm focus-within:border-vxn-teal-600 focus-within:bg-white">
                      <Calendar className="mr-2 h-4 w-4 shrink-0 text-vxn-fg-3" />
                      <input
                        type="date"
                        value={departureDate}
                        onChange={(e) => setDepartureDate(e.target.value)}
                        className="w-full bg-transparent font-medium text-vxn-ink outline-none"
                      />
                    </div>
                  </div>

                  {/* Hành khách */}
                  <div className="relative lg:col-span-1">
                    <label className="block text-xs font-semibold text-vxn-fg-4">Hành khách</label>
                    <div className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-2.5 py-2.5 text-sm">
                      <Users className="mr-1.5 h-4 w-4 shrink-0 text-vxn-fg-3" />
                      <span className="font-semibold text-vxn-ink">{passengerCount}</span>
                    </div>
                  </div>

                  {/* Nút Tìm chuyến */}
                  <div className="mt-2 sm:mt-0 lg:col-span-2">
                    <label className="hidden text-xs font-semibold text-transparent lg:block">Tìm</label>
                    <button
                      type="submit"
                      className="mt-1 flex w-full items-center justify-center gap-2 rounded-xl bg-[#00506a] py-3 px-4 text-sm font-bold text-white shadow-sm transition hover:bg-[#00476b] active:scale-[0.99]"
                    >
                      <Search className="h-4 w-4" />
                      <span>Tìm chuyến</span>
                    </button>
                  </div>
                </div>
              ) : (
                /* TAB 2: THEO NHÀ XE (836:113) */
                <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-12 lg:items-center">
                  {/* Ô Chọn nhà xe */}
                  <div className="relative lg:col-span-4">
                    <label className="block text-xs font-semibold text-vxn-fg-4">Nhà xe</label>
                    <button
                      type="button"
                      onClick={() => setIsPickerOpen(!isPickerOpen)}
                      className="mt-1 flex w-full items-center justify-between rounded-xl border border-vxn-border bg-vxn-bg-soft px-3 py-2.5 text-left text-sm font-medium text-vxn-ink hover:border-vxn-teal-600 focus:bg-white"
                    >
                      <span className="truncate">
                        {selectedOperator ? selectedOperator.name : "Chọn nhà xe"}
                      </span>
                      <ChevronDown className="h-4 w-4 text-vxn-fg-4" />
                    </button>
                  </div>

                  {/* Tuyến đường */}
                  <div className="relative lg:col-span-3">
                    <label className="block text-xs font-semibold text-vxn-fg-4">Tuyến đường</label>
                    <select
                      value={selectedRoute}
                      onChange={(e) => setSelectedRoute(e.target.value)}
                      className="mt-1 flex w-full rounded-xl border border-vxn-border bg-vxn-bg-soft px-3 py-2.5 text-sm font-medium text-vxn-ink outline-none"
                    >
                      <option value="">Tất cả tuyến</option>
                      <option value="sg-dl">Sài Gòn ↔ Đà Lạt</option>
                      <option value="sg-nt">Sài Gòn ↔ Nha Trang</option>
                      <option value="hn-sp">Hà Nội ↔ Sapa</option>
                    </select>
                  </div>

                  {/* Ngày đi */}
                  <div className="relative lg:col-span-2">
                    <label className="block text-xs font-semibold text-vxn-fg-4">Ngày đi</label>
                    <div className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-3 py-2.5 text-sm">
                      <Calendar className="mr-2 h-4 w-4 shrink-0 text-vxn-fg-3" />
                      <input
                        type="date"
                        value={departureDate}
                        onChange={(e) => setDepartureDate(e.target.value)}
                        className="w-full bg-transparent font-medium text-vxn-ink outline-none"
                      />
                    </div>
                  </div>

                  {/* Hành khách */}
                  <div className="relative lg:col-span-1">
                    <label className="block text-xs font-semibold text-vxn-fg-4">Hành khách</label>
                    <div className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-2.5 py-2.5 text-sm">
                      <Users className="mr-1.5 h-4 w-4 shrink-0 text-vxn-fg-3" />
                      <span className="font-semibold text-vxn-ink">{passengerCount}</span>
                    </div>
                  </div>

                  {/* Nút Tìm chuyến */}
                  <div className="mt-2 sm:mt-0 lg:col-span-2">
                    <label className="hidden text-xs font-semibold text-transparent lg:block">Tìm</label>
                    <button
                      type="submit"
                      className="mt-1 flex w-full items-center justify-center gap-2 rounded-xl bg-[#00506a] py-3 px-4 text-sm font-bold text-white shadow-sm transition hover:bg-[#00476b] active:scale-[0.99]"
                    >
                      <Search className="h-4 w-4" />
                      <span>Tìm chuyến</span>
                    </button>
                  </div>
                </div>
              )}

              {/* Lỗi hành động tại chỗ nếu có */}
              {actionError && (
                <div className="mt-3 rounded-lg border border-amber-200 bg-amber-50 p-3 text-xs font-medium text-amber-800">
                  {actionError}
                </div>
              )}
            </form>

            {/* POPUP / POPOVER OPERATOR PICKER (837:131) */}
            {activeTab === "operator" && isPickerOpen && (
              <div className="relative z-20 mt-4 rounded-xl border border-vxn-border bg-white p-4 shadow-xl">
                <div className="flex items-center justify-between border-b border-vxn-border pb-3">
                  <h3 className="text-sm font-bold text-vxn-ink">Nhà xe nổi bật</h3>
                  <Link
                    href="/operators"
                    className="inline-flex items-center text-xs font-semibold text-vxn-teal-700 hover:underline"
                  >
                    <span>Xem tất cả nhà xe</span>
                    <ChevronRight className="h-3 w-3" />
                  </Link>
                </div>

                <div className="mt-2 divide-y divide-vxn-border/60">
                  {featuredOperators.map((operator) => (
                    <button
                      key={operator.id}
                      type="button"
                      onClick={() => {
                        setSelectedOperator(operator);
                        setIsPickerOpen(false);
                      }}
                      className="flex w-full items-center justify-between py-2.5 px-2 text-left transition hover:bg-vxn-bg-soft rounded-lg"
                    >
                      <div className="flex items-center gap-3">
                        <div
                          className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg text-xs font-bold text-white shadow-xs"
                          style={{ backgroundColor: operator.accentColor ?? "#00506a" }}
                        >
                          {operator.shortCode}
                        </div>
                        <div>
                          <div className="flex items-center gap-2">
                            <span className="text-sm font-semibold text-vxn-ink">
                              {operator.name}
                            </span>
                            <span className="flex items-center text-xs font-semibold text-amber-600">
                              <Star className="mr-0.5 h-3 w-3 fill-amber-400 text-amber-500" />
                              {operator.rating.toFixed(1)}
                            </span>
                          </div>
                          <div className="text-xs text-vxn-fg-4">
                            {operator.vehicleTypesText}
                          </div>
                        </div>
                      </div>

                      <div className="text-right text-xs text-vxn-fg-3">
                        <span className="rounded bg-vxn-bg-mist px-2.5 py-1 font-semibold text-vxn-teal-800">
                          {operator.dailyTripsText}
                        </span>
                      </div>
                    </button>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Scroll hint (icon mouse chuẩn Figma) */}
        <div className="mt-12 flex flex-col items-center justify-center gap-1.5 text-xs text-teal-100/80">
          <span>Lướt xuống để xem tuyến phổ biến</span>
          <div className="flex h-7 w-4.5 justify-center rounded-full border-2 border-teal-200/60 pt-1">
            <div className="h-1.5 w-1 rounded-full bg-teal-200 animate-pulse" />
          </div>
        </div>
      </div>
    </section>
  );
}
