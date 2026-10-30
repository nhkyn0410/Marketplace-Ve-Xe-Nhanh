import { ArrowRight, Building2, Search } from "lucide-react";
import type { Metadata } from "next";
import { cookies } from "next/headers";
import Link from "next/link";

import { PassengerTopBar } from "../../../components/passenger-topbar";
import { EmptyState, FeatureUnavailable } from "../../../components/states";
import { OperatorExploreCard } from "../../../components/trips/operator-explore-card";
import { TripCard } from "../../../components/trips/trip-card";
import { TripDateStrip } from "../../../components/trips/trip-date-strip";
import { TripSearchBar } from "../../../components/trips/trip-search-bar";
import { getProvinces } from "../../../lib/data/catalog";
import { getOperatorMinFare } from "../../../lib/data/explore";
import { exploreAreas, exploreRoutes, rankOperators, resolveExploreJourney, servedRoute } from "../../../lib/data/explore-mappers";
import { getFeaturedOperators } from "../../../lib/data/home";
import { addDays, LAST_SEARCH_COOKIE, placeSearchParams, stripDates, vnToday } from "../../../lib/data/trip-mappers";
import { searchTrips } from "../../../lib/data/trips";
import { formatTripDateVi } from "../../../lib/format";

export const metadata: Metadata = { title: "Khám phá chuyến đi" };

/** Số chuyến hiện ở tab "Chuyến xe"; xem hết (lọc, sắp xếp, phân trang) ở trang kết quả. */
const LIST_SIZE = 10;

type SearchParams = { readonly [key: string]: string | string[] | undefined };

/** Điều kiện tìm gần nhất trong cookie (do trang kết quả ghi); cookie hỏng thì bỏ qua. */
function savedSearch(raw: string | undefined): URLSearchParams | null {
  if (!raw) return null;
  try {
    // Trình đọc cookie có thể đã giải mã sẵn (còn dấu "=") hoặc chưa.
    return new URLSearchParams(raw.includes("=") ? raw : decodeURIComponent(raw));
  } catch {
    return null;
  }
}

/**
 * Trang "Mua vé" = Khám phá chuyến đi, giống tab Mua vé của app: tab **Chuyến xe** hiện chuyến đang mở bán của lần tìm gần
 * nhất (chưa tìm lần nào thì tuyến phổ biến đầu tiên); tab **Nhà xe** liệt kê nhà xe đang phục vụ kèm giá vé từ theo ngày.
 * Tìm chuyến (trang chủ / thanh tìm) dẫn tới trang kết quả `/trips?…`.
 */
export default async function ExplorePage({ searchParams }: { readonly searchParams?: Promise<SearchParams> }) {
  const params = searchParams ? await searchParams : {};
  const value = (key: string) => (typeof params[key] === "string" ? (params[key] as string) : undefined);
  const tab = value("tab") === "operators" ? "operators" : "trips";
  const today = vnToday();

  return (
    <div className="min-h-viewport bg-[#f9f9ff]">
      <PassengerTopBar breadcrumbs={[{ label: "Trang chủ", href: "/" }, { label: "Mua vé" }]} />
      <div className="mx-auto w-full max-w-[1200px] px-4 py-6 sm:px-6 lg:px-14">
        <header className="flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
          <div>
            <h1 className="text-2xl font-extrabold text-[#0f172a]">Khám phá chuyến đi</h1>
            <p className="mt-1 text-sm text-slate-500">Chuyến xe và nhà xe cho mọi hành trình</p>
          </div>
          <nav aria-label="Chế độ khám phá" className="flex w-full rounded-xl bg-[#f1f3fc] p-1 text-sm font-medium sm:w-auto">
            {[{ id: "trips", label: "Chuyến xe", href: "/trips/explore" }, { id: "operators", label: "Nhà xe", href: "/trips/explore?tab=operators" }].map((item) => (
              <Link
                key={item.id}
                href={item.href}
                aria-current={tab === item.id ? "page" : undefined}
                className={`flex-1 rounded-lg px-5 py-2 text-center transition sm:flex-none ${
                  tab === item.id ? "bg-white font-bold text-[#00506a] shadow-xs" : "text-slate-600 hover:text-slate-900"
                }`}
              >
                {item.label}
              </Link>
            ))}
          </nav>
        </header>
        <div className="mt-6">
          {tab === "operators" ? <OperatorsTab value={value} today={today} /> : <TripsTab value={value} today={today} />}
        </div>
      </div>
    </div>
  );
}

async function TripsTab({ value, today }: { readonly value: (key: string) => string | undefined; readonly today: string }) {
  const saved = savedSearch((await cookies()).get(LAST_SEARCH_COOKIE)?.value);
  const fromUrl = value("origin") && value("destination") ? value : null;
  // `?all=1` hoặc chưa tìm lần nào: xem mọi chuyến sắp chạy, không cần nhập điểm đi / đến hay ngày (chờ duyệt 30/10/2026).
  const browseAll = value("all") === "1" && !fromUrl;
  const provincesResult = await getProvinces();
  // Ngày trên URL (đổi bằng dải ngày) được ưu tiên dù hành trình lấy từ lần tìm trước.
  const dateFromUrl = (key: string) => (key === "date" ? value("date") : undefined);
  const journey = browseAll ? null : resolveExploreJourney([fromUrl, dateFromUrl, saved ? (key) => saved.get(key) : null], today);
  const provinces = provincesResult.status === "ok" ? provincesResult.data : [];

  if (!journey) {
    return <UpcomingTrips provinces={provinces} today={today} />;
  }

  const journeyQuery = new URLSearchParams({
    ...placeSearchParams("origin", { type: journey.originType, id: journey.origin, label: journey.originLabel }),
    ...placeSearchParams("destination", { type: journey.destinationType, id: journey.destination, label: journey.destinationLabel }),
    date: journey.date,
    passengers: String(journey.passengers)
  }).toString();
  const tripsResult = await searchTrips({
    origin: journey.origin, originType: journey.originType, destination: journey.destination, destinationType: journey.destinationType,
    date: journey.date, passengers: journey.passengers, sortBy: "earliest"
  });

  return (
    <>
      <TripSearchBar
        key={journeyQuery}
        initialOrigin={journey.origin} initialOriginType={journey.originType} initialOriginLabel={journey.originLabel}
        initialDestination={journey.destination} initialDestinationType={journey.destinationType} initialDestinationLabel={journey.destinationLabel}
        initialDate={journey.date} initialPassengers={journey.passengers} provinces={provinces}
      />
      <section className="mt-6 space-y-4" aria-labelledby="explore-trips-heading">
        <TripDateStrip basePath="/trips/explore" query={journeyQuery} selected={journey.date} dates={stripDates(journey.date, today)} />
        <div className="flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between">
          <div>
            <h2 id="explore-trips-heading" className="text-lg font-semibold text-vxn-ink">Chuyến đang mở bán</h2>
            <p className="mt-0.5 text-xs text-slate-500">
              {journey.originLabel} → {journey.destinationLabel} • {formatTripDateVi(journey.date)} • {journey.passengers} hành khách • Giờ đi sớm nhất
            </p>
          </div>
          <div className="flex flex-wrap gap-x-4 gap-y-1">
            <Link href="/trips/explore?all=1" className="inline-flex items-center gap-1 text-xs font-bold text-[#00506a] hover:underline">
              Mọi chuyến sắp chạy <ArrowRight className="h-3.5 w-3.5" />
            </Link>
            <Link href={`/trips?${journeyQuery}`} className="inline-flex items-center gap-1 text-xs font-bold text-[#00506a] hover:underline">
              Xem tất cả, lọc và sắp xếp <ArrowRight className="h-3.5 w-3.5" />
            </Link>
          </div>
        </div>
        {tripsResult.status !== "ok" ? (
          <FeatureUnavailable
            title="Không thể tải chuyến xe"
            description={tripsResult.status === "error" && tripsResult.httpStatus !== 400 ? tripsResult.message : "Hãy chọn lại điểm đi, điểm đến rồi tìm lại."}
          />
        ) : tripsResult.data.trips.length === 0 ? (
          <EmptyState
            icon={Search}
            title="Chưa có chuyến đang mở bán"
            description="Thử đổi ngày ở dải ngày phía trên hoặc tìm tuyến khác."
            className="bg-white"
          />
        ) : (
          <div className="space-y-4">
            {tripsResult.data.trips.slice(0, LIST_SIZE).map((trip) => <TripCard key={trip.id} trip={trip} passengers={journey.passengers} />)}
          </div>
        )}
      </section>
    </>
  );
}

/** Chuyến sắp chạy của mọi tuyến trong vài ngày tới — xem vé không cần nhập điểm đi / đến hay ngày. */
async function UpcomingTrips({ provinces, today }: { readonly provinces: Parameters<typeof TripSearchBar>[0]["provinces"]; readonly today: string }) {
  const result = await searchTrips({ anyDate: true, sortBy: "earliest" });
  return (
    <>
      <TripSearchBar provinces={provinces} initialDate={addDays(today, 1)} />
      <section className="mt-6 space-y-4" aria-labelledby="explore-trips-heading">
        <div>
          <h2 id="explore-trips-heading" className="text-lg font-semibold text-vxn-ink">Chuyến sắp chạy</h2>
          <p className="mt-0.5 text-xs text-slate-500">Mọi tuyến trong 7 ngày tới • Giờ đi sớm nhất. Chọn điểm đi, điểm đến và ngày để tìm đúng chuyến.</p>
        </div>
        {result.status !== "ok" ? (
          <FeatureUnavailable title="Không thể tải chuyến xe" description="Vui lòng tải lại trang sau ít phút." />
        ) : result.data.trips.length === 0 ? (
          <EmptyState icon={Search} title="Chưa có chuyến sắp chạy" description="Hiện chưa có chuyến mở bán trong 7 ngày tới." className="bg-white" />
        ) : (
          <div className="space-y-4">
            {result.data.trips.slice(0, LIST_SIZE * 2).map((trip) => <TripCard key={trip.id} trip={trip} showDate />)}
          </div>
        )}
      </section>
    </>
  );
}

async function OperatorsTab({ value, today }: { readonly value: (key: string) => string | undefined; readonly today: string }) {
  const requestedDate = value("date");
  const date = requestedDate && /^\d{4}-\d{2}-\d{2}$/.test(requestedDate) && requestedDate >= today ? requestedDate : addDays(today, 1);
  const area = value("area") || undefined;
  const route = value("route") || undefined;
  const result = await getFeaturedOperators(20);
  if (result.status !== "ok") {
    return <FeatureUnavailable title="Không tải được danh sách nhà xe" description="Vui lòng tải lại trang sau ít phút." />;
  }

  const filtering = Boolean(area || route);
  const cards = rankOperators(result.data)
    .map((operator) => ({ operator, served: servedRoute(operator, area, route) }))
    .filter((card) => !filtering || card.served);
  const fares = await Promise.all(cards.map(({ operator, served }) =>
    served ? getOperatorMinFare(operator.id, served.originProvinceId, served.destinationProvinceId, date) : Promise.resolve(null)));
  const areas = exploreAreas(result.data);
  const routes = exploreRoutes(result.data, area);
  const filterQuery = new URLSearchParams({ tab: "operators", ...(area ? { area } : {}), ...(route ? { route } : {}) }).toString();
  const selectClass = "mt-1 w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm text-vxn-ink outline-none focus:border-[#00506a]";

  return (
    <section className="space-y-4" aria-labelledby="explore-operators-heading">
      <TripDateStrip basePath="/trips/explore" query={filterQuery} selected={date} dates={stripDates(date, today)} />
      <form action="/trips/explore" method="get" className="grid gap-3 rounded-2xl border border-slate-200 bg-white p-4 shadow-2xs sm:grid-cols-[1fr_1fr_auto] sm:items-end">
        <input type="hidden" name="tab" value="operators" />
        <input type="hidden" name="date" value={date} />
        <label className="text-xs font-medium text-slate-500">
          Khu vực
          <select name="area" defaultValue={area ?? ""} className={selectClass}>
            <option value="">Tất cả khu vực</option>
            {areas.map((item) => <option key={item.id} value={item.id}>{item.name}</option>)}
          </select>
        </label>
        <label className="text-xs font-medium text-slate-500">
          Tuyến phục vụ
          <select name="route" defaultValue={route ?? ""} className={selectClass}>
            <option value="">Tất cả tuyến</option>
            {routes.map((item) => <option key={item.key} value={item.key}>{item.label}</option>)}
          </select>
        </label>
        <div className="flex items-center gap-3">
          <button className="rounded-xl bg-[#00506a] px-5 py-2.5 text-sm font-bold text-white transition hover:bg-[#00476b]">Áp dụng</button>
          {filtering && <Link href={`/trips/explore?tab=operators&date=${date}`} className="text-xs font-semibold text-[#006481] hover:underline">Bỏ lọc</Link>}
        </div>
      </form>
      <div className="flex items-end justify-between">
        <h2 id="explore-operators-heading" className="text-lg font-semibold text-vxn-ink">Nhà xe đang phục vụ</h2>
        <span className="text-xs text-slate-500">Đánh giá cao • giá vé ngày {formatTripDateVi(date)}</span>
      </div>
      {cards.length === 0 ? (
        <EmptyState
          icon={Building2}
          title={filtering ? "Chưa có nhà xe phục vụ khu vực, tuyến đã chọn" : "Chưa có nhà xe đang mở bán"}
          description={filtering ? "Bỏ bớt bộ lọc để xem thêm nhà xe." : "Vui lòng quay lại sau."}
          className="bg-white"
        />
      ) : (
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {cards.map(({ operator, served }, index) => (
            <OperatorExploreCard key={operator.id} operator={operator} route={served} fareVnd={fares[index] ?? null} date={date} />
          ))}
        </div>
      )}
    </section>
  );
}
