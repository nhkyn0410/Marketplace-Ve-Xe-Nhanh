import { ChevronDown } from "lucide-react";
import Link from "next/link";

import { PassengerTopBar } from "../../components/passenger-topbar";
import { FeatureUnavailable } from "../../components/states";
import { TripCard } from "../../components/trips/trip-card";
import { TripEmptyState } from "../../components/trips/trip-empty-state";
import { TripFilters } from "../../components/trips/trip-filters";
import { TripListHeader } from "../../components/trips/trip-list-header";
import { TripLoadingSkeleton } from "../../components/trips/trip-loading-skeleton";
import { TripSearchBar } from "../../components/trips/trip-search-bar";
import { searchTrips } from "../../lib/data/trips";
import { getProvinces } from "../../lib/data/catalog";
import { LiveTripFilters } from "../../components/trips/live-trip-filters";
import { getPreview } from "../../lib/preview";
import {
  alternativeRoutesFixture,
  nearestDateSuggestionsFixture,
  searchTripsFixture,
  tripSearchSummaryFixture
} from "../../lib/preview/fixtures/trips";

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
        { label: "Mua vé", href: "/trips" },
        { label: "Tìm chuyến xe" }
      ]}
    />
  );

  // PREVIEW: EMPTY STATE (1450:22017)
  if (preview === "empty") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
          <TripSearchBar />
          <div className="mt-6">
            <TripEmptyState
              nearestDateSuggestions={nearestDateSuggestionsFixture}
              alternativeRoutes={alternativeRoutesFixture}
            />
          </div>
        </main>
      </div>
    );
  }

  // PREVIEW: LOADING SKELETON (1450:22373)
  if (preview === "loading") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
          <TripSearchBar />
          <div className="mt-6 flex flex-col gap-6 lg:flex-row items-start">
            <div className="w-full lg:w-[280px] shrink-0">
              <TripFilters />
            </div>
            <div className="flex-1 min-w-0 w-full">
              <TripLoadingSkeleton />
            </div>
          </div>
        </main>
      </div>
    );
  }

  // PREVIEW: IDEAL (1440:11297)
  if (preview === "ideal") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
          {/* Thanh tìm kiếm tóm tắt */}
          <TripSearchBar />

          {/* Bố cục 2 phần: Bộ lọc bên trái (280px) + Danh sách chuyến rộng rãi bên phải */}
          <div className="mt-6 flex flex-col gap-6 lg:flex-row items-start">
            {/* Cột lọc */}
            <div className="w-full lg:w-[280px] shrink-0">
              <TripFilters />
            </div>

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
        </main>
      </div>
    );
  }

  // NHÁNH DỮ LIỆU THẬT (không có ?preview)
  const value = (key: string) => typeof resolvedParams?.[key] === "string" ? resolvedParams[key] as string : undefined;
  const params = { origin: value("origin"), destination: value("destination"), date: value("date"),
    passengers: Math.min(10, Math.max(1, Math.trunc(Number(value("passengers")) || 1))),
    operatorId: value("operatorId"), seatType: value("seatType"), vehicleType: value("vehicleType"),
    minPriceVnd: value("minPriceVnd"), maxPriceVnd: value("maxPriceVnd"), timeRange: value("timeRange"),
    sortBy: value("sortBy") as "earliest" | "price_asc" | "fastest" | undefined, page: value("page") };
  const [tripsResult, provincesResult] = await Promise.all([searchTrips(params), getProvinces()]);
  const provinces = provincesResult.status === "ok" ? provincesResult.data : [];
  const query = new URLSearchParams(Object.entries(params).filter(([, v]) => v !== undefined).map(([k, v]) => [k, String(v)]));

  if (tripsResult.status !== "ok") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
          <TripSearchBar key={query.toString()} initialOrigin={params.origin} initialDestination={params.destination}
            initialDate={params.date} initialPassengers={params.passengers} provinces={provinces} />
          <div className="mt-8">
            <FeatureUnavailable
              title="Không thể tải chuyến xe"
              description={tripsResult.status === "error" ? tripsResult.message : "Dịch vụ tìm chuyến chưa sẵn sàng."}
            />
          </div>
        </main>
      </div>
    );
  }

  return (
    <div className="min-h-viewport bg-[#f9f9ff]">
      {topBarHeader}
      <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
        <TripSearchBar key={query.toString()} initialOrigin={params.origin} initialDestination={params.destination}
          initialDate={params.date ?? tripsResult.data.summary.departureDateText} initialPassengers={params.passengers} provinces={provinces} />
        <div className="mt-6 flex flex-col gap-6 lg:flex-row items-start">
          <LiveTripFilters query={query.toString()} />
          <div className="flex-1 w-full space-y-4">
            <h1 className="text-xl font-bold">{tripsResult.data.summary.totalTrips} chuyến xe phù hợp</h1>
            <p className="text-xs text-vxn-fg-4">Ngày {tripsResult.data.summary.departureDateText} · {params.passengers} hành khách · Trang {tripsResult.data.pagination.page}</p>
            {params.operatorId && <Link className="inline-block text-xs text-vxn-teal-800 underline" href={`/trips?${new URLSearchParams(Object.entries(Object.fromEntries(query)).filter(([key]) => key !== "operatorId" && key !== "page"))}`}>Bỏ lọc nhà xe</Link>}
            {tripsResult.data.trips.length ? tripsResult.data.trips.map((trip) => <TripCard key={trip.id} trip={trip} />) :
              <p className="rounded-xl bg-white p-6">Chưa có chuyến phù hợp. Bạn có thể đổi ngày hoặc bộ lọc.</p>}
            <div className="flex gap-6">
              {tripsResult.data.pagination.page > 1 && <Link href={`/trips?${new URLSearchParams({ ...Object.fromEntries(query), page: String(tripsResult.data.pagination.page - 1) })}`}>Trang trước</Link>}
              {tripsResult.data.pagination.page * tripsResult.data.pagination.limit < tripsResult.data.summary.totalTrips && <Link href={`/trips?${new URLSearchParams({ ...Object.fromEntries(query), page: String(tripsResult.data.pagination.page + 1) })}`}>Trang tiếp theo</Link>}
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
