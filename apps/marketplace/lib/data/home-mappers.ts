import type { components } from "@vexenhanh/api-client";
import { apiMoney } from "./trip-mappers";
import type { FeaturedOperatorItem, PopularRouteItem } from "./types";

type PopularRouteDto = components["schemas"]["PopularRouteListResponseDto_Output"]["items"][number];
type FeaturedOperatorDto = components["schemas"]["FeaturedOperatorListResponseDto_Output"]["items"][number];

/** Ảnh có sẵn theo tỉnh đến (tên bỏ dấu); tỉnh khác lần lượt dùng các ảnh còn lại. */
const ROUTE_IMAGES: readonly (readonly [string, string])[] = [
  ["lam dong", "/images/route-sg-dalat.jpg"],
  ["lao cai", "/images/route-hn-sapa.jpg"],
  ["vung tau", "/images/route-sg-vungtau.jpg"],
  ["quang ninh", "/images/route-hn-halong.jpg"],
  ["hue", "/images/route-dn-hue.jpg"],
  ["khanh hoa", "/images/route-sg-nhatrang.jpg"],
  ["ninh binh", "/images/route-hn-ninhbinh.jpg"]
];

/** Màu ô chữ viết tắt của nhà xe khi chưa có logo (cùng bảng màu bản xem trước). */
const OPERATOR_COLORS = ["#E89B26", "#00506A", "#1D4ED8", "#047857", "#D97706"] as const;

const plain = (value: string) => value.normalize("NFD").replace(/\p{Diacritic}/gu, "").replace(/đ/g, "d").replace(/Đ/g, "D").toLowerCase();

const vnDate = (value: Date) => new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Ho_Chi_Minh" }).format(value);

/** 25.200 giây → "7 tiếng"; 27.000 → "7 tiếng 30 phút"; 2.700 → "45 phút". */
export function formatDurationVi(seconds: number): string {
  const minutes = Math.round(seconds / 60);
  const hours = Math.floor(minutes / 60);
  const rest = minutes % 60;
  if (hours === 0) return `${rest} phút`;
  return rest === 0 ? `${hours} tiếng` : `${hours} tiếng ${rest} phút`;
}

/** "Phương Trang" → "PT", "Nhà xe Hà Linh" → "HL", "Futa" → "FU". */
export function operatorInitials(name: string): string {
  const words = name.replace(/^nhà xe\s+/i, "").trim().split(/\s+/).filter(Boolean);
  const initials = words.length >= 2 ? `${words[0]![0]}${words[1]![0]}` : (words[0] ?? "").slice(0, 2);
  return initials.toUpperCase();
}

/** Thẻ tuyến phổ biến: mục đầu là thẻ nổi bật; link mở tìm chuyến đúng ngày có chuyến sớm nhất. */
export function mapPopularRoute(route: PopularRouteDto, index: number, now = new Date()): PopularRouteItem {
  const destination = plain(route.destinationName);
  const image = ROUTE_IMAGES.find(([key]) => destination.includes(key))?.[1] ?? ROUTE_IMAGES[index % ROUTE_IMAGES.length]![1];
  const date = vnDate(route.nextDepartureAt ? new Date(route.nextDepartureAt) : now);
  return {
    id: `${route.originProvinceId}>${route.destinationProvinceId}`,
    fromCity: route.originName,
    toCity: route.destinationName,
    distanceKm: Math.round(route.distanceMeters / 1000),
    durationText: formatDurationVi(route.durationSeconds),
    vehicleTypeText: route.vehicleTypeNames.join(" & "),
    minPriceVnd: route.minPrice === null ? null : apiMoney(route.minPrice),
    rating: route.averageRating,
    isFeatured: index === 0,
    imageUrl: image,
    href: `/trips?${new URLSearchParams({ origin: route.originProvinceId, destination: route.destinationProvinceId, date, passengers: "1" })}`
  };
}

/** Thẻ nhà xe tiêu biểu kèm tuyến (cặp tỉnh) cho tab "Theo nhà xe". */
export function mapFeaturedOperator(operator: FeaturedOperatorDto, index: number): FeaturedOperatorItem {
  const routes = operator.routes.map((route) => ({
    originProvinceId: route.originProvinceId,
    destinationProvinceId: route.destinationProvinceId,
    label: `${route.originName} → ${route.destinationName}`
  }));
  return {
    id: operator.operatorId,
    name: operator.displayName,
    shortCode: operatorInitials(operator.displayName),
    logoUrl: operator.logoUrl,
    rating: operator.averageRating,
    ratingCountText: operator.reviewCount > 0 ? `${operator.reviewCount.toLocaleString("vi-VN")} đánh giá` : "Chưa có đánh giá",
    popularRoutesText: routes.map((route) => route.label).join(", "),
    accentColor: OPERATOR_COLORS[index % OPERATOR_COLORS.length],
    routes
  };
}
