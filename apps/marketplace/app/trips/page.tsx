import { ChevronDown, ChevronLeft, ChevronRight, Search } from "lucide-react";
import Link from "next/link";
import { redirect } from "next/navigation";

import { PassengerTopBar } from "../../components/passenger-topbar";
import { EmptyState, FeatureUnavailable } from "../../components/states";
import { TripCard } from "../../components/trips/trip-card";
import { TripEmptyState } from "../../components/trips/trip-empty-state";
import { TripFilters } from "../../components/trips/trip-filters";
import { TripListHeader } from "../../components/trips/trip-list-header";
import { TripLoadingSkeleton } from "../../components/trips/trip-loading-skeleton";
import { TripSearchBar } from "../../components/trips/trip-search-bar";
import { searchTrips } from "../../lib/data/trips";
import { JOURNEY_KEYS, placeType, priceRange, stripDates, vnToday } from "../../lib/data/trip-mappers";
import { RememberLastSearch } from "../../components/trips/remember-last-search";
import { TripDateStrip } from "../../components/trips/trip-date-strip";
import { getProvinces } from "../../lib/data/catalog";
import { LiveTripFilters } from "../../components/trips/live-trip-filters";
import { CollapsibleFilters } from "../../components/trips/collapsible-filters";
import { getPreview } from "../../lib/preview";
import {
  alternativeRoutesFixture,
  nearestDateSuggestionsFixture,
  searchTripsFixture,
  tripSearchSummaryFixture
} from "../../lib/preview/fixtures/trips";
import type { Metadata } from "next";

export const metadata: Metadata = { title: "Tìm chuyến xe" };

/**
 * Thuộc tính của trang Danh sách chuyến xe.
 */
export interface TripsPageProps {
  readonly searchParams?: Promise<{ readonly [key: string]: string | string[] | undefined }>;
}

/**
 * Trang Danh sách chuyến xe (SCR-PSG-15) — hỗ trợ preview các trạng thái:
 * - ideal: Danh sách chuyến xe đầy đủ theo Figma 1440:11297
 * - empty: Trạng thái không có chuyến phù hợp (1450:22017)
 * - loading: Trạng thái đang tải / skeleton (1450:22373)
 * - Không có preview: Nhánh dữ liệu thật gọi searchTrips() (hiện FeatureUnavailable vì chưa có API)
 */
export default async function TripsPage(props: TripsPageProps) {
  const resolvedParams = props.searchParams ? await props.searchParams : undefined;
  const preview = getPreview(resolvedParams);

  // TOP BAR HEADER
  const topBarHeader = (
    <PassengerTopBar
      breadcrumbs={[
        { label: "Trang chủ", href: "/" },
        { label: "Mua vé", href: "/trips/explore" },
        { label: "Tìm chuyến xe" }
      ]}
    />
  );

  // PREVIEW: EMPTY STATE (1450:22017)
  if (preview === "empty") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <div className="mx-auto w-full max-w-[1200px] px-4 py-6 sm:px-6 lg:px-14">
          <TripSearchBar />
          <h1 className="sr-only">Chưa có chuyến phù hợp</h1>
          <div className="mt-6">
            <TripEmptyState
              nearestDateSuggestions={nearestDateSuggestionsFixture}
              alternativeRoutes={alternativeRoutesFixture}
            />
          </div>
        </div>
      </div>
    );
  }

  // PREVIEW: LOADING SKELETON (1450:22373)
  if (preview === "loading") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <div className="mx-auto w-full max-w-[1200px] px-4 py-6 sm:px-6 lg:px-14">
          <TripSearchBar />
          <h1 className="sr-only">Đang tìm chuyến xe</h1>
          <div className="mt-6 flex flex-col gap-6 lg:flex-row items-start">
            <CollapsibleFilters>
              <TripFilters />
            </CollapsibleFilters>
            <div className="flex-1 min-w-0 w-full">
              <TripLoadingSkeleton />
            </div>
          </div>
        </div>
      </div>
    );
  }

  // PREVIEW: IDEAL (1440:11297)
  if (preview === "ideal") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <div className="mx-auto w-full max-w-[1200px] px-4 py-6 sm:px-6 lg:px-14">
          {/* Thanh tìm kiếm tóm tắt */}
          <TripSearchBar />

          {/* Bố cục 2 phần: Bộ lọc bên trái (280px) + Danh sách chuyến rộng rãi bên phải */}
          <div className="mt-6 flex flex-col gap-6 lg:flex-row items-start">
            {/* Cột lọc */}
            <CollapsibleFilters>
              <TripFilters />
            </CollapsibleFilters>

            {/* Cột kết quả */}
            <div className="flex-1 min-w-0 w-full space-y-4">
              <TripListHeader
                totalTrips={tripSearchSummaryFixture.totalTrips}
                dateText={tripSearchSummaryFixture.departureDateText}
                passengerCount={tripSearchSummaryFixture.passengerCount}
              />

              {/* Danh sách 4 chuyến xe */}
              <div className="space-y-4">
                {searchTripsFixture.map((trip) => (
                  <TripCard key={trip.id} trip={trip} />
                ))}
              </div>


              {/* Nút Xem thêm */}
              <div className="pt-4 text-center">
                <button
                  type="button"
                  className="inline-flex items-center gap-1.5 rounded-xl border border-vxn-border bg-white px-6 py-2.5 text-xs font-bold text-vxn-ink shadow-2xs transition hover:bg-vxn-bg-soft"
                >
                  <ChevronDown className="h-4 w-4" />
                  <span>Xem thêm 8 chuyến</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  // NHÁNH DỮ LIỆU THẬT (không có ?preview)
  const value = (key: string) => typeof resolvedParams?.[key] === "string" ? resolvedParams[key] as string : undefined;
  const price = priceRange(value("minPriceVnd"), value("maxPriceVnd"));
  const params = { origin: value("origin"), originType: placeType(value("originType")), originLabel: value("originLabel"),
    destination: value("destination"), destinationType: placeType(value("destinationType")), destinationLabel: value("destinationLabel"),
    date: value("date"),
    passengers: Math.min(10, Math.max(1, Math.trunc(Number(value("passengers")) || 1))),
    operatorId: value("operatorId"), seatType: value("seatType"), vehicleType: value("vehicleType"),
    minPriceVnd: price.min, maxPriceVnd: price.max, timeRange: value("timeRange"),
    sortBy: value("sortBy") as "earliest" | "price_asc" | "fastest" | undefined, page: value("page") };
  // Loại "province" là mặc định nên không ghi lên URL (giữ link cũ y nguyên).
  const query = new URLSearchParams(Object.entries(params)
    .filter(([k, v]) => v !== undefined && !(k.endsWith("Type") && v === "province"))
    .map(([k, v]) => [k, String(v)]));
  const searchBarPlaces = { initialOrigin: params.origin, initialOriginType: params.originType, initialOriginLabel: params.originLabel,
    initialDestination: params.destination, initialDestinationType: params.destinationType, initialDestinationLabel: params.destinationLabel,
    operatorId: params.operatorId };
  const clearOperatorHref = `/trips?${new URLSearchParams([...query].filter(([key]) => key !== "operatorId" && key !== "page"))}`;
  const clearOperatorLink = params.operatorId && (
    <Link className="inline-block text-xs font-semibold text-vxn-teal-700 hover:underline" href={clearOperatorHref}>Bỏ lọc nhà xe</Link>
  );

  // Menu "Mua vé" chưa mang điều kiện nào → trang Khám phá (như tab Mua vé của app); `/trips?…` là trang kết quả.
  if (!params.origin && !params.destination && !params.date && !params.operatorId) {
    redirect("/trips/explore");
  }

  // Chỉ cần ngày đi; điểm đi / đến bỏ trống thì xem chuyến trên mọi tuyến.
  if (!params.date) {
    const provincesResult = await getProvinces();
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <div className="mx-auto w-full max-w-[1200px] px-4 py-6 sm:px-6 lg:px-14">
          <TripSearchBar key={query.toString()} {...searchBarPlaces}
            initialDate={params.date} initialPassengers={params.passengers} provinces={provincesResult.status === "ok" ? provincesResult.data : []} />
          <h1 className="sr-only">Tìm chuyến xe</h1>
          <EmptyState
            icon={Search}
            title="Chọn ngày để xem chuyến"
            description={params.operatorId
              ? "Đang lọc chuyến của một nhà xe. Chọn ngày đi ở thanh tìm kiếm phía trên rồi bấm Tìm chuyến."
              : "Chọn ngày đi ở thanh tìm kiếm phía trên rồi bấm Tìm chuyến. Điểm đi và điểm đến không bắt buộc."}
            className="mt-6 bg-white"
          />
          {clearOperatorLink && <div className="mt-3 text-center">{clearOperatorLink}</div>}
        </div>
      </div>
    );
  }

  const [tripsResult, provincesResult] = await Promise.all([searchTrips(params), getProvinces()]);
  const provinces = provincesResult.status === "ok" ? provincesResult.data : [];

  if (tripsResult.status !== "ok") {
    // Lỗi 400 = điều kiện trên URL không hợp lệ: vẫn để cột lọc để người dùng sửa, không hiện câu kỹ thuật của API.
    const invalidQuery = tripsResult.status === "error" && tripsResult.httpStatus === 400;
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <div className="mx-auto w-full max-w-[1200px] px-4 py-6 sm:px-6 lg:px-14">
          <TripSearchBar key={query.toString()} {...searchBarPlaces}
            initialDate={params.date} initialPassengers={params.passengers} provinces={provinces} />
          <div className="mt-6 flex flex-col gap-6 lg:flex-row items-start">
            <CollapsibleFilters>
              <LiveTripFilters query={query.toString()} />
            </CollapsibleFilters>
            <div className="flex-1 min-w-0 w-full">
              <FeatureUnavailable
                title="Không thể tải chuyến xe"
                description={invalidQuery
                  ? "Điều kiện tìm chuyến không hợp lệ. Hãy chọn lại điểm đi, điểm đến hoặc bỏ bớt bộ lọc."
                  : tripsResult.status === "error" ? tripsResult.message : "Dịch vụ tìm chuyến chưa sẵn sàng."}
              />
            </div>
          </div>
        </div>
      </div>
    );
  }

  const { summary, trips, pagination, widenedToProvince } = tripsResult.data;
  const widenedSides = [widenedToProvince.from && "đón", widenedToProvince.to && "trả"].filter(Boolean).join(" / ");
  const pageHref = (page: number) => `/trips?${new URLSearchParams({ ...Object.fromEntries(query), page: String(page) })}`;
  const pagerClass = "inline-flex items-center gap-1.5 rounded-xl border border-vxn-border bg-white px-5 py-2.5 text-xs font-bold text-vxn-ink shadow-2xs transition hover:bg-vxn-bg-soft";

  return (
    <div className="min-h-viewport bg-[#f9f9ff]">
      {topBarHeader}
      <div className="mx-auto w-full max-w-[1200px] px-4 py-6 sm:px-6 lg:px-14">
        <TripSearchBar key={query.toString()} {...searchBarPlaces}
          initialDate={params.date ?? summary.departureDateText} initialPassengers={params.passengers} provinces={provinces} />
        <div className="mt-6 flex flex-col gap-6 lg:flex-row items-start">
          <CollapsibleFilters>
            <LiveTripFilters query={query.toString()} />
          </CollapsibleFilters>
          <div className="flex-1 min-w-0 w-full space-y-4">
            <RememberLastSearch query={new URLSearchParams([...query].filter(([key]) => (JOURNEY_KEYS as readonly string[]).includes(key))).toString()} />
            <TripDateStrip basePath="/trips" query={query.toString()} selected={params.date} dates={stripDates(params.date, vnToday())} />
            <TripListHeader
              totalTrips={summary.totalTrips}
              dateText={summary.departureDateShortText}
              passengerCount={params.passengers}
              query={query.toString()}
              sort={params.sortBy ?? "earliest"}
            />
            {widenedSides && (
              <p role="status" className="rounded-xl bg-amber-50 px-4 py-3 text-xs text-amber-800">
                Không có chuyến {widenedSides} khách tại phường / xã hoặc khu vực đã chọn — đang hiện các chuyến trong cùng tỉnh / thành.
                Xem điểm {widenedSides} của từng chuyến trước khi đặt.
              </p>
            )}
            {price.invalid && (
              <p role="status" className="rounded-xl bg-amber-50 px-4 py-3 text-xs text-amber-800">
                Khoảng giá chưa đúng (giá từ lớn hơn giá đến) nên chưa lọc theo giá. Nhập lại ở bộ lọc.
              </p>
            )}
            {clearOperatorLink}
            {trips.length ? (
              <div className="space-y-4">{trips.map((trip) => <TripCard key={trip.id} trip={trip} passengers={params.passengers} />)}</div>
            ) : (
              <EmptyState
                icon={Search}
                title="Chưa có chuyến phù hợp"
                description="Bạn có thể đổi ngày đi, điểm đón hoặc bỏ bớt bộ lọc để xem thêm chuyến."
                className="bg-white"
              />
            )}
            {(pagination.page > 1 || pagination.page * pagination.limit < summary.totalTrips) && (
              <nav aria-label="Phân trang" className="flex items-center justify-center gap-3 pt-4">
                {pagination.page > 1 && <Link href={pageHref(pagination.page - 1)} className={pagerClass}><ChevronLeft className="h-4 w-4" />Trang trước</Link>}
                <span className="text-xs text-vxn-fg-5">Trang {pagination.page}</span>
                {pagination.page * pagination.limit < summary.totalTrips && <Link href={pageHref(pagination.page + 1)} className={pagerClass}>Trang tiếp theo<ChevronRight className="h-4 w-4" /></Link>}
              </nav>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
