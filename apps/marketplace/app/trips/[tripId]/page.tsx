import { Metadata } from "next";
import { getPreview, SearchParamsInput } from "../../../lib/preview";
import { tripDetailFixture } from "../../../lib/preview/fixtures/trips";
import { getTripDetails } from "../../../lib/data/trips";
import { FeatureUnavailable } from "../../../components/states/feature-unavailable";
import { TripDetailHeader } from "../../../components/trips/detail/trip-detail-header";
import { TripVehicleInfo } from "../../../components/trips/detail/trip-vehicle-info";
import { TripItinerary } from "../../../components/trips/detail/trip-itinerary";
import { TripRouteMap } from "../../../components/trips/detail/trip-route-map";
import { TripSeatPreview } from "../../../components/trips/detail/trip-seat-preview";
import { TripPricingPolicy } from "../../../components/trips/detail/trip-pricing-policy";
import { TripReviews } from "../../../components/trips/detail/trip-reviews";
import { TripBookingSidebar } from "../../../components/trips/detail/trip-booking-sidebar";

export const metadata: Metadata = {
  title: "Chi tiết chuyến xe | Vé Xe Nhanh",
  description: "Xem chi tiết chuyến xe, lịch trình, giá vé và tiện ích trên Vé Xe Nhanh."
};

interface PageProps {
  readonly params: Promise<{ readonly tripId: string }>;
  readonly searchParams: Promise<SearchParamsInput>;
}

/**
 * Trang chi tiết chuyến xe SCR-PSG-16 (`/trips/[tripId]`).
 */
export default async function TripDetailPage(props: PageProps) {
  const [params, searchParams] = await Promise.all([
    props.params,
    props.searchParams
  ]);

  const preview = getPreview(searchParams);

  // Nhánh Preview phục vụ kiểm thử giao diện theo Figma
  if (preview === "ideal") {
    const trip = tripDetailFixture;
    return (
      <div className="w-full max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 space-y-4">
        {/* Lưới 2 cột: Cột nội dung chi tiết & Cột tóm tắt đặt vé */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
          {/* Cột trái (8 cột) */}
          <div className="lg:col-span-8 space-y-6">
            <TripDetailHeader trip={trip} />
            <TripVehicleInfo trip={trip} />
            <TripItinerary timeline={trip.timeline} />
            <TripRouteMap timeline={trip.timeline} />
            <TripSeatPreview
              seatMap={trip.seatMap}
              totalSeats={trip.totalSeats}
              availableSeats={trip.availableSeats}
            />
            <TripPricingPolicy
              priceSingleVnd={trip.priceSingleVnd}
              priceDoubleVnd={trip.priceDoubleVnd}
              stopSalesTimeText={trip.stopSalesTimeText}
              cancellationPolicies={trip.cancellationPolicies}
              cancellationNote={trip.cancellationNote}
            />
            <TripReviews trip={trip} />
          </div>

          {/* Cột phải (4 cột) */}
          <div className="lg:col-span-4 pt-10">
            <TripBookingSidebar trip={trip} />
          </div>
        </div>
      </div>
    );
  }


  // Nhánh dữ liệu thật (Gọi API qua lib/data/trips.ts)
  const result = await getTripDetails(params.tripId);

  if (result.status !== "ok") {
    return (
      <div className="w-full max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <FeatureUnavailable
          title="Chi tiết chuyến xe"
          endpoint={result.endpoint}
        />
      </div>
    );
  }

  // Dự phòng khi có dữ liệu thật trong tương lai
  const trip = result.data;

  return (
    <div className="w-full max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 space-y-4">
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
        <div className="lg:col-span-8 space-y-6">
          <TripDetailHeader trip={trip} />
          <TripVehicleInfo trip={trip} />
          <TripItinerary timeline={trip.timeline} />
          <TripRouteMap timeline={trip.timeline} />
          <TripSeatPreview
            seatMap={trip.seatMap}
            totalSeats={trip.totalSeats}
            availableSeats={trip.availableSeats}
          />
          <TripPricingPolicy
            priceSingleVnd={trip.priceSingleVnd}
            priceDoubleVnd={trip.priceDoubleVnd}
            stopSalesTimeText={trip.stopSalesTimeText}
            cancellationPolicies={trip.cancellationPolicies}
            cancellationNote={trip.cancellationNote}
          />
          <TripReviews trip={trip} />
        </div>
        <div className="lg:col-span-4 pt-10">
          <TripBookingSidebar trip={trip} />
        </div>
      </div>
    </div>
  );

}
