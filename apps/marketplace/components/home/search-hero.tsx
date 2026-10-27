"use client";

import { Button } from "@vexenhanh/ui/components/button";
import {
  ArrowLeftRight,
  BusFront,
  ChevronDown,
  FileText,
  Phone,
  Star,
  Tag
} from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState } from "react";
import { placeSearchParams } from "../../lib/data/trip-mappers";
import type { FeaturedOperatorItem } from "../../lib/data/types";
import { formatTripDateVi } from "../../lib/format";
import { PlaceInput, type PlaceValue } from "../trips/place-input";

/** Thuộc tính của form tìm chuyến trên trang chủ. */
export interface SearchHeroProps {
  readonly featuredOperators?: readonly FeaturedOperatorItem[];
  readonly initialTab?: "trip" | "operator";
  readonly initialPickerOpen?: boolean;
  /** Bản xem trước: dữ liệu mẫu, không điều hướng tìm chuyến. */
  readonly isPreview?: boolean;
}

/** Tuyến mẫu của tab Theo nhà xe khi xem trước (nhà xe mẫu không kèm tuyến). */
const PREVIEW_ROUTE_OPTIONS = [
  { value: "sg-dl", label: "TP. Hồ Chí Minh ↔ Đà Lạt" },
  { value: "sg-nt", label: "TP. Hồ Chí Minh ↔ Nha Trang" },
  { value: "hn-sp", label: "Hà Nội ↔ Sapa" }
];

/**
 * Khối Banner Hero & Form tìm kiếm chuyến xe 2 tab (Mua vé & Theo nhà xe) chuẩn Figma 776:791, 830:592, 836:113, 837:131.
 */
export function SearchHero({
  featuredOperators = [],
  initialTab = "trip",
  initialPickerOpen = false,
  isPreview = false
}: SearchHeroProps) {
  const router = useRouter();
  const [activeTab, setActiveTab] = useState<"trip" | "operator">(initialTab);
  const [origin, setOrigin] = useState<PlaceValue | null>(null);
  const [destination, setDestination] = useState<PlaceValue | null>(null);
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

  const routeOptions = selectedOperator?.routes?.map((route) => ({ value: `${route.originProvinceId}>${route.destinationProvinceId}`, label: route.label }))
    ?? (isPreview ? PREVIEW_ROUTE_OPTIONS : []);

  /**
   * Tìm chuyến theo tuyến (tab Mua vé) hoặc theo tuyến của nhà xe; nhà xe không chọn tuyến thì mở trang nhà xe.
   */
  const handleSearch = (e: React.FormEvent): void => {
    e.preventDefault();
    if (isPreview) {
      setActionError("Đây là giao diện xem trước; tìm chuyến đã được tắt.");
      return;
    }
    const passengers = String(passengerCount);
    if (activeTab === "trip") {
      if (!departureDate || !origin || !destination || origin.id === destination.id) {
        setActionError("Chọn ngày đi và hai điểm khác nhau từ danh sách gợi ý.");
        return;
      }
      router.push(`/trips?${new URLSearchParams({
        ...placeSearchParams("origin", origin),
        ...placeSearchParams("destination", destination),
        date: departureDate,
        passengers
      })}`);
      return;
    }
    if (!selectedOperator) {
      setActionError("Chọn nhà xe trước khi tìm chuyến.");
      return;
    }
    if (!selectedRoute) {
      router.push(`/operators/${selectedOperator.id}`);
      return;
    }
    if (!departureDate) {
      setActionError("Chọn ngày đi.");
      return;
    }
    const [routeOrigin = "", routeDestination = ""] = selectedRoute.split(">");
    router.push(`/trips?${new URLSearchParams({ origin: routeOrigin, destination: routeDestination, date: departureDate, passengers, operatorId: selectedOperator.id })}`);
  };

  const pickerOperators = featuredOperators.slice(0, 3);

  return (
    <section className="relative flex min-h-[750px] lg:min-h-[max(750px,var(--vxn-vh))] flex-col justify-between overflow-hidden bg-[#0b3b49] text-white">
      {/* Ảnh nền phong cảnh Việt Nam và xe khách chuẩn Figma */}
      <div
        className="absolute inset-0 bg-cover bg-center bg-no-repeat"
        style={{
          backgroundImage: "url('/images/hero-bg.jpg')"
        }}
      />
      {/* Lớp phủ gradient tinh tế để nổi bật chữ bên trái và đáy trang như Figma */}
      <div className="absolute inset-0 bg-gradient-to-r from-[#023347]/70 via-[#023347]/25 to-transparent" />
      <div className="absolute inset-0 bg-gradient-to-b from-[#04354a]/35 via-transparent to-[#13251b]/75" />

      {/* Top action: CSKH & Ngôn ngữ (góc trên bên phải) */}
      <div className="relative z-10 mx-auto flex w-full max-w-[1120px] items-center justify-end gap-2.5 px-4 pt-5 sm:px-6 lg:px-8">
        <a
          href="tel:19006067"
          className="inline-flex items-center gap-2 rounded-full bg-white px-4 py-2 text-xs font-bold text-[#0f172a] shadow-sm transition hover:bg-slate-50"
        >
          <Phone className="h-3.5 w-3.5 text-[#00506a]" />
          <span>CSKH 1900 6067</span>
        </a>
        <button
          type="button"
          className="inline-flex items-center gap-2 rounded-full border border-white/15 bg-[#0c2636]/75 px-3.5 py-2 text-xs font-semibold text-white backdrop-blur-xs"
        >
          <span
            aria-hidden="true"
            className="inline-flex h-3.5 w-5 items-center justify-center rounded-[2px] bg-[#da251d] text-[8px] leading-none text-[#ffff00]"
          >
            ★
          </span>
          <span>VI</span>
          <ChevronDown className="h-3.5 w-3.5 opacity-80" />
        </button>
      </div>

      {/* Nội dung trung tâm: Tiêu đề căn trái & Khung tìm kiếm */}
      <div className="relative z-10 mx-auto w-full max-w-[1120px] px-4 pt-8 pb-6 sm:px-6 lg:px-8">
        {/* Khối tiêu đề căn trái chuẩn Figma */}
        <div className="max-w-2xl text-left">
          <div className="inline-flex items-center gap-2 rounded-full bg-[#005975]/90 px-4 py-1.5 text-xs font-bold tracking-wider text-white uppercase shadow-xs backdrop-blur-xs">
            <Tag className="h-3.5 w-3.5 text-teal-200" />
            <span>ĐẶT VÉ XE KHÁCH TRỰC TUYẾN</span>
          </div>

          <h1 className="mt-4 text-4xl font-extrabold tracking-tight text-white drop-shadow-xs sm:text-5xl lg:text-[56px] lg:leading-[1.12]">
            Đi Việt Nam.
            <span className="mt-1 block text-[#f3a826]">Nhanh hơn, gọn hơn.</span>
          </h1>

          <p className="mt-4 text-sm leading-relaxed text-white/95 drop-shadow-xs sm:text-[15px]">
            Tìm chuyến phù hợp, đặt vé thuận tiện.
            <br />
            Vé điện tử QR và chính sách rõ ràng trước khi đặt.
          </p>
        </div>

        {/* Khung Form Tìm kiếm trắng bo góc */}
        <div className="relative mt-12 rounded-2xl bg-white px-5 pt-4 pb-6 text-vxn-ink shadow-2xl sm:px-7">
          {/* Thanh chuyển Tab nằm trong khung trắng */}
          <div className="flex items-center gap-6 border-b border-transparent">
            <button
              type="button"
              onClick={() => {
                setActiveTab("trip");
                setIsPickerOpen(false);
              }}
              className={`inline-flex items-center gap-2 border-b-2 px-2 pb-2.5 text-sm transition-colors ${
                activeTab === "trip"
                  ? "border-[#00506a] font-bold text-[#00506a]"
                  : "border-transparent font-medium text-slate-500 hover:text-vxn-ink"
              }`}
            >
              <FileText className="h-4 w-4" />
              <span>Mua vé</span>
            </button>
            <button
              type="button"
              onClick={() => {
                setActiveTab("operator");
              }}
              className={`inline-flex items-center gap-2 border-b-2 px-2 pb-2.5 text-sm transition-colors ${
                activeTab === "operator"
                  ? "border-[#00506a] font-bold text-[#00506a]"
                  : "border-transparent font-medium text-slate-500 hover:text-vxn-ink"
              }`}
            >
              <BusFront className="h-4 w-4" />
              <span>Theo nhà xe</span>
            </button>
          </div>

          {/* Form nhập liệu */}
          <form onSubmit={handleSearch} className="mt-4">
            {activeTab === "trip" ? (
              /* TAB 1: MUA VÉ / THEO CHUYẾN (830:592) */
              <div className="flex flex-col gap-3 lg:flex-row lg:items-center">
                {/* Điểm đi */}
                <PlaceInput
                  id="trip-origin"
                  label="Điểm đi"
                  placeholder="Tỉnh, phường / xã, bến xe…"
                  value={origin}
                  onChange={setOrigin}
                  fieldClassName="flex-1 rounded-xl border border-slate-200 bg-white px-4 py-2.5 transition focus-within:border-[#00506a]"
                  labelClassName="block text-xs font-medium text-slate-500"
                  inputClassName="mt-0.5 w-full appearance-none bg-transparent text-[15px] font-bold text-[#0f172a] outline-none placeholder:font-medium placeholder:text-slate-400"
                />

                {/* Nút hoán đổi */}
                <div className="flex items-center justify-center">
                  <button
                    type="button"
                    onClick={handleSwapLocations}
                    title="Đảo chiều điểm đi - điểm đến"
                    aria-label="Đảo chiều điểm đi - điểm đến"
                    className="inline-flex h-9 w-9 shrink-0 items-center justify-center rounded-full border border-slate-200 bg-white text-slate-500 transition hover:border-[#00506a] hover:text-[#00506a]"
                  >
                    <ArrowLeftRight className="h-3.5 w-3.5" />
                  </button>
                </div>

                {/* Điểm đến */}
                <PlaceInput
                  id="trip-dest"
                  label="Điểm đến"
                  placeholder="Tỉnh, phường / xã, bến xe…"
                  value={destination}
                  onChange={setDestination}
                  fieldClassName="flex-1 rounded-xl border border-slate-200 bg-white px-4 py-2.5 transition focus-within:border-[#00506a]"
                  labelClassName="block text-xs font-medium text-slate-500"
                  inputClassName="mt-0.5 w-full appearance-none bg-transparent text-[15px] font-bold text-[#0f172a] outline-none placeholder:font-medium placeholder:text-slate-400"
                />

                {/* Ngày đi */}
                <div className="relative rounded-xl border border-slate-200 bg-white px-4 py-2.5 transition focus-within:border-[#00506a] lg:w-[155px] lg:shrink-0">
                  <label htmlFor="trip-date" className="block text-xs font-medium text-slate-500">
                    Ngày đi
                  </label>
                  <div className="mt-0.5 text-[15px] font-bold text-[#0f172a]">
                    {departureDate ? formatTripDateVi(departureDate) : "Chọn ngày"}
                  </div>
                  <input
                    id="trip-date"
                    type="date"
                    value={departureDate}
                    onChange={(e) => setDepartureDate(e.target.value)}
                    aria-label="Ngày đi"
                    className="absolute inset-0 cursor-pointer opacity-0"
                  />
                </div>

                {/* Hành khách */}
                <div className="rounded-xl border border-slate-200 bg-white px-4 py-2.5 lg:w-[155px] lg:shrink-0">
                  <span className="block text-xs font-medium text-slate-500">Hành khách</span>
                  <div className="mt-0.5 text-[15px] font-bold text-[#0f172a]">
                    {passengerCount} hành khách
                  </div>
                </div>

                {/* Nút Tìm chuyến */}
                <Button
                  type="submit"
                  className="h-[54px] w-full rounded-xl bg-[#00506a] px-6 text-sm font-bold text-white shadow-xs transition hover:bg-[#003f54] lg:w-[165px] lg:shrink-0"
                >
                  Tìm chuyến
                </Button>
              </div>
            ) : (
              /* TAB 2: THEO NHÀ XE (836:113 & 837:131) */
              <div className="flex flex-col gap-3.5 lg:flex-row lg:items-center">
                {/* Ô Chọn nhà xe + Popover nổi phía trên */}
                <div className="relative flex-[1.15]">
                  {/* POPOVER NHÀ XE NỔI BẬT (837:131) */}
                  {isPickerOpen && (
                    <div className="absolute bottom-[calc(100%+10px)] left-0 z-30 w-full rounded-2xl border border-slate-200 bg-white p-3 shadow-2xl sm:w-[350px]">
                      <div className="px-2.5 pt-1 pb-2 text-[11px] font-bold tracking-wider text-slate-400 uppercase">
                        NHÀ XE NỔI BẬT
                      </div>
                      <div className="space-y-1">
                        {pickerOperators.map((operator, idx) => (
                          <button
                            key={operator.id}
                            type="button"
                            onClick={() => {
                              setSelectedOperator(operator);
                              setSelectedRoute("");
                              setActionError(null);
                              setIsPickerOpen(false);
                            }}
                            className={`flex w-full items-center gap-3 rounded-xl px-2.5 py-2 text-left transition ${
                              idx === 0 ? "bg-[#eef6f9]" : "hover:bg-[#eef6f9]"
                            }`}
                          >
                            <div
                              className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg text-xs font-bold text-white"
                              style={{ backgroundColor: operator.accentColor ?? "#00506a" }}
                            >
                              {operator.shortCode}
                            </div>
                            <div className="min-w-0 flex-1">
                              <div className="truncate text-sm font-bold text-[#0f172a]">
                                {operator.name}
                              </div>
                              <div className="mt-0.5 flex items-center gap-1 text-xs text-slate-500">
                                {operator.rating !== null && (
                                  <>
                                    <Star className="h-3 w-3 fill-amber-400 text-amber-400" />
                                    <span className="font-semibold text-slate-700">
                                      {operator.rating.toFixed(1)}
                                    </span>
                                    <span>·</span>
                                  </>
                                )}
                                <span>{operator.ratingCountText}</span>
                              </div>
                            </div>
                          </button>
                        ))}
                      </div>
                      <div className="mt-2 border-t border-slate-100 pt-2">
                        <Link
                          href="/operators/opr-phuongnam"
                          className="block px-2.5 py-1 text-xs font-bold text-[#00506a] hover:underline"
                        >
                          Xem tất cả nhà xe
                        </Link>
                      </div>
                    </div>
                  )}

                  <button
                    type="button"
                    onClick={() => setIsPickerOpen(!isPickerOpen)}
                    className={`w-full rounded-xl bg-white px-4 py-2.5 text-left transition ${
                      isPickerOpen
                        ? "border-[1.5px] border-[#00506a]"
                        : "border border-slate-200 hover:border-[#00506a]"
                    }`}
                  >
                    <span
                      className={`block text-xs ${
                        isPickerOpen ? "font-semibold text-[#00506a]" : "font-medium text-slate-500"
                      }`}
                    >
                      Nhà xe
                    </span>
                    <span
                      className={`mt-0.5 block truncate text-[15px] ${
                        isPickerOpen && !selectedOperator
                          ? "font-medium text-slate-400"
                          : "font-bold text-[#0f172a]"
                      }`}
                    >
                      {selectedOperator
                        ? selectedOperator.name
                        : isPickerOpen
                          ? "Nhập tên nhà xe..."
                          : "Chọn nhà xe"}
                    </span>
                  </button>
                </div>

                {/* Tuyến đường */}
                <div className="flex-[1.15] rounded-xl border border-slate-200 bg-white px-4 py-2.5 transition focus-within:border-[#00506a]">
                  <label htmlFor="operator-route" className="block text-xs font-medium text-slate-500">
                    Tuyến đường
                  </label>
                  <select
                    id="operator-route"
                    value={selectedRoute}
                    onChange={(e) => setSelectedRoute(e.target.value)}
                    className="mt-0.5 w-full appearance-none bg-transparent text-[15px] font-bold text-[#0f172a] outline-none"
                  >
                    <option value="">Tất cả tuyến</option>
                    {routeOptions.map((route) => (
                      <option key={route.value} value={route.value}>
                        {route.label}
                      </option>
                    ))}
                  </select>
                </div>

                {/* Ngày đi */}
                <div className="relative rounded-xl border border-slate-200 bg-white px-4 py-2.5 transition focus-within:border-[#00506a] lg:w-[175px] lg:shrink-0">
                  <label htmlFor="operator-date" className="block text-xs font-medium text-slate-500">
                    Ngày đi
                  </label>
                  <div className="mt-0.5 text-[15px] font-bold text-[#0f172a]">
                    {departureDate ? formatTripDateVi(departureDate) : "Chọn ngày"}
                  </div>
                  <input
                    id="operator-date"
                    type="date"
                    value={departureDate}
                    onChange={(e) => setDepartureDate(e.target.value)}
                    aria-label="Ngày đi"
                    className="absolute inset-0 cursor-pointer opacity-0"
                  />
                </div>

                {/* Hành khách */}
                <div className="rounded-xl border border-slate-200 bg-white px-4 py-2.5 lg:w-[175px] lg:shrink-0">
                  <span className="block text-xs font-medium text-slate-500">Hành khách</span>
                  <div className="mt-0.5 text-[15px] font-bold text-[#0f172a]">
                    {passengerCount} hành khách
                  </div>
                </div>

                {/* Nút Tìm chuyến */}
                <Button
                  type="submit"
                  className="h-[54px] w-full rounded-xl bg-[#00506a] px-6 text-sm font-bold text-white shadow-xs transition hover:bg-[#003f54] lg:w-[175px] lg:shrink-0"
                >
                  Tìm chuyến
                </Button>
              </div>
            )}

            {/* Lỗi hành động tại chỗ nếu có */}
            {actionError && (
              <div
                role="alert"
                className="mt-3 rounded-lg border border-amber-200 bg-amber-50 p-3 text-xs font-medium text-amber-800"
              >
                {actionError}
              </div>
            )}
          </form>
        </div>
      </div>

      {/* Scroll hint (icon mouse chuẩn Figma) */}
      <div className="relative z-10 flex flex-col items-center justify-center gap-2 pb-5 text-xs font-medium text-white/90">
        <span>Lướt xuống để xem tuyến phổ biến</span>
        <div className="flex h-7 w-4.5 justify-center rounded-full border-[1.5px] border-white/80 pt-1">
          <div className="h-1.5 w-0.5 rounded-full bg-white" />
        </div>
      </div>
    </section>
  );
}
