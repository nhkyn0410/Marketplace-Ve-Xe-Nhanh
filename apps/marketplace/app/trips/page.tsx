import { ChevronDown } from "lucide-react";

import { PassengerTopBar } from "../../components/passenger-topbar";
import { FeatureUnavailable } from "../../components/states";
import { TripCard } from "../../components/trips/trip-card";
import { TripEmptyState } from "../../components/trips/trip-empty-state";
import { TripFilters } from "../../components/trips/trip-filters";
import { TripListHeader } from "../../components/trips/trip-list-header";
import { TripLoadingSkeleton } from "../../components/trips/trip-loading-skeleton";
import { TripSearchBar } from "../../components/trips/trip-search-bar";
import { searchTrips } from "../../lib/data/trips";
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
    <div className="border-b border-vxn-border/60 bg-white">
      <div className="mx-auto max-w-7xl px-4 py-2.5 sm:px-6 lg:px-8">
        <PassengerTopBar
          breadcrumbs={[
            { label: "Trang chủ", href: "/" },
            { label: "Mua vé", href: "/trips" },
            { label: "TP. Hồ Chí Minh → Đà Lạt" }
          ]}
        />
      </div>
    </div>
  );

  // PREVIEW: EMPTY STATE (1450:22017)
  if (preview === "empty") {
    return (
      <div className="min-h-screen bg-[#f9f9ff]">
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
      <div className="min-h-screen bg-[#f9f9ff]">
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
      <div className="min-h-screen bg-[#f9f9ff]">
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
  const tripsResult = await searchTrips();

  if (tripsResult.status === "unavailable") {
    return (
      <div className="min-h-screen bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
          <TripSearchBar />
          <div className="mt-8">
            <FeatureUnavailable
              title="Dịch vụ tìm chuyến đang được kết nối"
              endpoint="GET /trips/search"
              description="Hệ thống tìm kiếm lịch trình chuyến xe theo thời gian thực đang trong giai đoạn tích hợp với các nhà xe đối tác."
            />
          </div>
        </main>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#f9f9ff]">
      {topBarHeader}
      <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
        <TripSearchBar />
        <div className="mt-6">
          <TripEmptyState />
        </div>
      </main>
    </div>
  );
}
