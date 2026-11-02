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
import { placeSearchParams, samePlace } from "../../lib/data/trip-mappers";
import type { FeaturedOperatorItem } from "../../lib/data/types";
import { PlaceInput, type PlaceValue } from "../trips/place-input";
import {
  ChoiceField,
  DateField,
  PASSENGER_OPTIONS,
  PLACE_INPUT,
  PLACE_PLACEHOLDER,
  SEARCH_FIELD,
  SEARCH_LABEL,
  SEARCH_VALUE,
  SEARCH_VALUE_EMPTY
} from "../trips/search-fields";

/** Thuộc tính của form tìm chuyến trên trang chủ. */
export interface SearchHeroProps {
  readonly featuredOperators?: readonly FeaturedOperatorItem[];
  readonly initialTab?: "trip" | "operator";
  readonly initialPickerOpen?: boolean;
  /** Bản xem trước: dữ liệu mẫu, không điều hướng tìm chuyến. */
  readonly isPreview?: boolean;
}

/** Chữ thường, bỏ dấu tiếng Việt — lọc tên nhà xe khi gõ không dấu. */
function foldVi(value: string): string {
  return value.normalize("NFD").replace(/\p{Diacritic}/gu, "").replace(/đ/gi, "d").toLowerCase();
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
  const [passengerCount, setPassengerCount] = useState<number>(1);

  const [selectedOperator, setSelectedOperator] = useState<FeaturedOperatorItem | null>(null);
  const [selectedRoute, setSelectedRoute] = useState<string>("");
  const [isPickerOpen, setIsPickerOpen] = useState<boolean>(initialPickerOpen);
  const [operatorQuery, setOperatorQuery] = useState<string>("");
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
      if (!departureDate || !origin || !destination || samePlace(origin, destination)) {
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

  // Ô chọn nhà xe: mọi nhà xe đang mở bán (tối đa 20, như app), gõ để lọc theo tên không dấu.
  const pickerOperators = featuredOperators.filter((operator) => foldVi(operator.name).includes(foldVi(operatorQuery.trim())));

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
              <span>Theo chuyến</span>
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
                  placeholder={PLACE_PLACEHOLDER}
                  value={origin}
                  onChange={setOrigin}
                  fieldClassName={`${SEARCH_FIELD} flex-1`}
                  labelClassName={SEARCH_LABEL}
                  inputClassName={PLACE_INPUT}
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
                  placeholder={PLACE_PLACEHOLDER}
                  value={destination}
                  onChange={setDestination}
                  fieldClassName={`${SEARCH_FIELD} flex-1`}
                  labelClassName={SEARCH_LABEL}
                  inputClassName={PLACE_INPUT}
                />

                <DateField value={departureDate} onChange={setDepartureDate} className="lg:w-[170px] lg:shrink-0" />

                <ChoiceField
                  label="Hành khách"
                  options={PASSENGER_OPTIONS}
                  value={String(passengerCount)}
                  onChange={(value) => setPassengerCount(Number(value))}
                  className="lg:w-[150px] lg:shrink-0"
                />

                {/* Nút Tìm chuyến */}
                <Button
                  type="submit"
                  className="h-[54px] w-full rounded-xl bg-[#00506a] px-6 text-sm font-bold text-white shadow-xs transition hover:bg-[#003f54] lg:w-[140px] lg:shrink-0"
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
                      <input
                        autoFocus
                        value={operatorQuery}
                        onChange={(event) => setOperatorQuery(event.target.value)}
                        onKeyDown={(event) => {
                          if (event.key === "Escape") setIsPickerOpen(false);
                        }}
                        placeholder="Nhập tên nhà xe..."
                        aria-label="Tìm nhà xe"
                        className="mb-2 w-full rounded-xl border border-slate-200 px-3 py-2 text-sm text-[#0f172a] outline-none focus:border-[#00506a]"
                      />
                      <div className="max-h-72 space-y-1 overflow-y-auto">
                        {pickerOperators.length === 0 && (
                          <p className="px-2.5 py-2 text-xs text-slate-500">
                            {featuredOperators.length === 0 ? "Chưa có nhà xe đang mở bán." : "Không tìm thấy nhà xe phù hợp."}
                          </p>
                        )}
                        {pickerOperators.map((operator) => (
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
                              operator.id === selectedOperator?.id ? "bg-[#eef6f9]" : "hover:bg-[#eef6f9]"
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
                          href="/trips/explore?tab=operators"
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
                    <span className={selectedOperator ? SEARCH_VALUE : SEARCH_VALUE_EMPTY}>
                      {selectedOperator ? selectedOperator.name : "Chọn nhà xe"}
                    </span>
                  </button>
                </div>

                <ChoiceField
                  label="Tuyến đường"
                  options={[{ value: "", label: "Tất cả tuyến" }, ...routeOptions]}
                  value={selectedRoute}
                  onChange={setSelectedRoute}
                  onOpen={() => setIsPickerOpen(false)}
                  className="flex-[1.15]"
                />

                <DateField onOpen={() => setIsPickerOpen(false)} value={departureDate} onChange={setDepartureDate} className="lg:w-[175px] lg:shrink-0" />

                <ChoiceField
                  label="Hành khách"
                  options={PASSENGER_OPTIONS}
                  value={String(passengerCount)}
                  onChange={(value) => setPassengerCount(Number(value))}
                  onOpen={() => setIsPickerOpen(false)}
                  className="lg:w-[175px] lg:shrink-0"
                />

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

