import {
  FeaturedOperatorItem,
  HandbookArticleItem,
  PopularRouteItem,
  ProvinceItem
} from "../../data/types";

/**
 * Danh sách tỉnh/thành phố mẫu chuẩn cho tìm kiếm chuyến xe.
 */
export const provincesFixture: readonly ProvinceItem[] = [
  { id: "p-sg", name: "TP. Hồ Chí Minh", code: "SGN" },
  { id: "p-hn", name: "Hà Nội", code: "HAN" },
  { id: "p-dl", name: "Đà Lạt (Lâm Đồng)", code: "DLI" },
  { id: "p-dn", name: "Đà Nẵng", code: "DAD" },
  { id: "p-nt", name: "Nha Trang (Khánh Hòa)", code: "NHA" },
  { id: "p-vt", name: "Vũng Tàu (Bà Rịa - Vũng Tàu)", code: "VTU" },
  { id: "p-sp", name: "Sapa (Lào Cai)", code: "SPA" },
  { id: "p-h", name: "Huế (Thừa Thiên Huế)", code: "HUE" },
  { id: "p-ct", name: "Cần Thơ", code: "VCA" },
  { id: "p-hp", name: "Hải Phòng", code: "HPH" },
  { id: "p-pt", name: "Phan Thiết (Bình Thuận)", code: "PTH" },
  { id: "p-qn", name: "Quy Nhơn (Bình Định)", code: "UIH" },
  { id: "p-bmt", name: "Buôn Ma Thuột (Đắk Lắk)", code: "BMV" }
];

/**
 * Danh sách tuyến xe phổ biến chép đúng từng chữ và số từ Figma 776:791.
 */
export const popularRoutesFixture: readonly PopularRouteItem[] = [
  {
    id: "route-sg-dalat",
    fromCity: "TP. Hồ Chí Minh",
    toCity: "Đà Lạt",
    distanceKm: 308,
    durationText: "7 tiếng",
    vehicleTypeText: "Giường nằm & limousine",
    minPriceVnd: "280000",
    rating: 4.8,
    isFeatured: true
  },
  {
    id: "route-hn-sapa",
    fromCity: "Hà Nội",
    toCity: "Sapa",
    distanceKm: 315,
    durationText: "6 tiếng",
    vehicleTypeText: "Giường nằm",
    minPriceVnd: "350000",
    rating: 4.8
  },
  {
    id: "route-sg-vungtau",
    fromCity: "TP. Hồ Chí Minh",
    toCity: "Vũng Tàu",
    distanceKm: 95,
    durationText: "2 tiếng",
    vehicleTypeText: "Limousine",
    minPriceVnd: "120000",
    rating: 4.7
  },
  {
    id: "route-hn-halong",
    fromCity: "Hà Nội",
    toCity: "Hạ Long",
    distanceKm: 160,
    durationText: "2.5 tiếng",
    vehicleTypeText: "Limousine",
    minPriceVnd: "180000",
    rating: 4.6
  },
  {
    id: "route-dn-hue",
    fromCity: "Đà Nẵng",
    toCity: "Huế",
    distanceKm: 100,
    durationText: "2 tiếng",
    vehicleTypeText: "Ghế ngồi cao cấp",
    minPriceVnd: "110000",
    rating: 4.5
  },
  {
    id: "route-sg-nhatrang",
    fromCity: "TP. Hồ Chí Minh",
    toCity: "Nha Trang",
    distanceKm: 430,
    durationText: "8.5 tiếng",
    vehicleTypeText: "Limousine & Giường nằm",
    minPriceVnd: "420000",
    rating: 4.7
  },
  {
    id: "route-hn-ninhbinh",
    fromCity: "Hà Nội",
    toCity: "Ninh Bình",
    distanceKm: 95,
    durationText: "1.5 tiếng",
    vehicleTypeText: "Limousine",
    minPriceVnd: "130000",
    rating: 4.6
  }
];

/**
 * Danh sách nhà xe đối tác tiêu biểu chép đúng từng chữ và số từ Figma 776:791, 836:113, 837:131.
 */
export const featuredOperatorsFixture: readonly FeaturedOperatorItem[] = [
  {
    id: "opr-halinh",
    name: "Hà Linh Express",
    shortCode: "HL",
    rating: 4.8,
    ratingCountText: "12.840 đánh giá",
    dailyTripsText: "32 chuyến/ngày",
    vehicleTypesText: "Giường nằm & Limousine",
    popularRoutesText: "Sài Gòn ↔ Đà Lạt, Nha Trang",
    slug: "ha-linh-express",
    accentColor: "#E07A5F"
  },
  {
    id: "opr-phuongnam",
    name: "Phương Nam Travel",
    shortCode: "PN",
    rating: 4.6,
    ratingCountText: "8.930 đánh giá",
    dailyTripsText: "18 chuyến/ngày",
    vehicleTypesText: "Limousine VIP 34 phòng",
    popularRoutesText: "Sài Gòn ↔ Mũi Né, Phan Thiết",
    slug: "phuong-nam-travel",
    accentColor: "#2563EB"
  },
  {
    id: "opr-tamhanh",
    name: "Tâm Hạnh Limousine",
    shortCode: "TH",
    rating: 4.7,
    ratingCountText: "5.210 đánh giá",
    dailyTripsText: "24 chuyến/ngày",
    vehicleTypesText: "Limousine 22 cabin",
    popularRoutesText: "Sài Gòn ↔ Nha Trang, Cam Ranh",
    slug: "tam-hanh-limousine",
    accentColor: "#4338CA"
  },
  {
    id: "opr-hoanglong",
    name: "Hoàng Long Coach",
    shortCode: "HL",
    rating: 4.5,
    ratingCountText: "21.405 đánh giá",
    dailyTripsText: "40 chuyến/ngày",
    vehicleTypesText: "Giường nằm cao cấp",
    popularRoutesText: "Hà Nội ↔ Hải Phòng, Quảng Ninh",
    slug: "hoang-long-coach",
    accentColor: "#15803D"
  },
  {
    id: "opr-maihuong",
    name: "Mai Hương Sleeper",
    shortCode: "MH",
    rating: 4.4,
    ratingCountText: "3.204 đánh giá",
    dailyTripsText: "12 chuyến/ngày",
    vehicleTypesText: "Giường nằm tiêu chuẩn",
    popularRoutesText: "Hà Nội ↔ Sapa, Lào Cai",
    slug: "mai-huong-sleeper",
    accentColor: "#D97706"
  }
];

/**
 * Danh sách bài viết cẩm nang xe khách chép đúng từ Figma 776:791.
 */
export const handbookArticlesFixture: readonly HandbookArticleItem[] = [
  {
    id: "art-1",
    title: "Mẹo chọn ghế trên xe giường nằm",
    category: "Hành trình",
    readTimeText: "5 phút đọc",
    slug: "meo-chon-ghe-xe-giuong-nam"
  },
  {
    id: "art-2",
    title: "Top 8 quán phở bò trứ danh dọc QL1 Bắc — Trung",
    category: "Du lịch",
    readTimeText: "4 phút đọc",
    slug: "top-8-quan-pho-bo-doc-ql1"
  },
  {
    id: "art-3",
    title: "Quy định mới về hành lý xe khách 2026",
    category: "Chính sách",
    readTimeText: "3 phút đọc",
    slug: "quy-dinh-hanh-ly-xe-khach-2026"
  }
];
