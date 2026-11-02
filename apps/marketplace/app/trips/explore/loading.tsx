import { PassengerTopBar } from "../../../components/passenger-topbar";
import { TripLoadingSkeleton } from "../../../components/trips/trip-loading-skeleton";

/** Hiện ngay khi bấm "Mua vé" (trang khám phá còn gọi API tìm chuyến) — không để khách chờ màn trắng. */
export default function ExploreLoading() {
  return (
    <div className="min-h-viewport bg-[#f9f9ff]">
      <PassengerTopBar breadcrumbs={[{ label: "Trang chủ", href: "/" }, { label: "Mua vé" }]} />
      <div className="mx-auto w-full max-w-[1200px] px-4 py-6 sm:px-6 lg:px-14">
        <h1 className="text-2xl font-extrabold text-[#0f172a]">Khám phá chuyến đi</h1>
        <p className="mt-1 text-sm text-slate-500">Đang tải chuyến xe…</p>
        <div className="mt-6">
          <TripLoadingSkeleton />
        </div>
      </div>
    </div>
  );
}
