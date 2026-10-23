import { TripSearchResultItem, TripSearchSummary } from "../../data/types";

/**
 * Tóm tắt kết quả tìm kiếm mẫu theo Figma 1440:11297.
 */
export const tripSearchSummaryFixture: TripSearchSummary = {
  originCity: "TP. Hồ Chí Minh",
  destinationCity: "Đà Lạt",
  departureDateText: "Thứ Sáu, 16/10/2026",
  passengerCount: 2,
  totalTrips: 12
};

/**
 * Danh sách chuyến xe mẫu chép đúng từng chữ và số từ Figma 1440:11297.
 */
export const searchTripsFixture: readonly TripSearchResultItem[] = [
  {
    id: "trip-pn-01",
    operatorId: "opr-phuongnam",
    operatorName: "Phương Nam Travel",
    operatorCode: "PN",
    operatorAccentColor: "#2563EB",
    operatorRating: 4.6,
    operatorRatingCountText: "8.930 đánh giá",
    vehicleType: "Limousine",
    seatType: "Giường nằm",
    departureTime: "22:30",
    departureCity: "TP. Hồ Chí Minh",
    departureStation: "Bến xe Miền Đông mới",
    arrivalTime: "05:30",
    arrivalCity: "Đà Lạt",
    arrivalStation: "Bến xe liên tỉnh Đà Lạt",
    durationText: "7 giờ",
    stopCountText: "1 điểm dừng nghỉ",
    isNextDay: true,
    priceVnd: "280000",
    availableSeats: 12,
    isUrgent: false,
    amenities: ["WiFi", "Điều hòa", "Nước uống", "+1"],
    imageUrl: "https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=600&q=80"
  },
  {
    id: "trip-hl-02",
    operatorId: "opr-halinh",
    operatorName: "Hà Linh Express",
    operatorCode: "HL",
    operatorAccentColor: "#E07A5F",
    operatorRating: 4.8,
    operatorRatingCountText: "12.840 đánh giá",
    vehicleType: "Tiêu chuẩn",
    seatType: "Giường nằm",
    departureTime: "20:00",
    departureCity: "TP. Hồ Chí Minh",
    departureStation: "Bến xe Miền Đông mới",
    arrivalTime: "03:10",
    arrivalCity: "Đà Lạt",
    arrivalStation: "Bến xe liên tỉnh Đà Lạt",
    durationText: "7 giờ 10 phút",
    stopCountText: "1 điểm dừng nghỉ",
    isNextDay: true,
    priceVnd: "250000",
    availableSeats: 2,
    isUrgent: true,
    amenities: ["WiFi", "Điều hòa", "Nước uống"],
    imageUrl: "https://images.unsplash.com/photo-1570125909232-eb263c188f7e?auto=format&fit=crop&w=600&q=80"
  },
  {
    id: "trip-th-03",
    operatorId: "opr-tamhanh",
    operatorName: "Tâm Hạnh Limousine",
    operatorCode: "TH",
    operatorAccentColor: "#4338CA",
    operatorRating: 4.7,
    operatorRatingCountText: "5.210 đánh giá",
    vehicleType: "Limousine",
    seatType: "Cabin",
    departureTime: "23:00",
    departureCity: "TP. Hồ Chí Minh",
    departureStation: "Văn phòng Tâm Hạnh – Quận 1 (trung chuyển)",
    arrivalTime: "06:15",
    arrivalCity: "Đà Lạt",
    arrivalStation: "Văn phòng Tâm Hạnh – Đà Lạt",
    durationText: "7 giờ 15 phút",
    stopCountText: "Không dừng nghỉ",
    isNextDay: true,
    priceVnd: "420000",
    availableSeats: 6,
    isUrgent: false,
    amenities: ["WiFi", "Điều hòa", "Nước uống", "+1"],
    imageUrl: "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=80"
  },
  {
    id: "trip-mh-04",
    operatorId: "opr-maihuong",
    operatorName: "Mai Hương Sleeper",
    operatorCode: "MH",
    operatorAccentColor: "#D97706",
    operatorRating: 4.4,
    operatorRatingCountText: "3.204 đánh giá",
    vehicleType: "Tiêu chuẩn",
    seatType: "Ghế ngồi",
    departureTime: "07:30",
    departureCity: "TP. Hồ Chí Minh",
    departureStation: "Bến xe Miền Đông mới",
    arrivalTime: "14:45",
    arrivalCity: "Đà Lạt",
    arrivalStation: "Bến xe liên tỉnh Đà Lạt",
    durationText: "7 giờ 15 phút",
    stopCountText: "2 điểm dừng nghỉ",
    isNextDay: false,
    priceVnd: "190000",
    availableSeats: 21,
    isUrgent: false,
    amenities: ["Điều hòa", "Nước uống"],
    imageUrl: "https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=600&q=80"
  }
];

/**
 * Gợi ý ngày đi gần nhất khi không có chuyến (Figma 1450:22017).
 */
export const nearestDateSuggestionsFixture = [
  { dateText: "T7, 17/10", tripCount: 9 },
  { dateText: "CN, 18/10", tripCount: 11 }
] as const;

/**
 * Tuyến thay thế phổ biến khi empty (Figma 1450:22017).
 */
export const alternativeRoutesFixture = [
  {
    id: "alt-sg-nt",
    fromCity: "TP. Hồ Chí Minh",
    toCity: "Nha Trang",
    durationText: "8 giờ 30 phút",
    frequencyText: "14 chuyến mỗi ngày",
    minPriceVnd: "320000",
    imageUrl: "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80"
  },
  {
    id: "alt-sg-vt",
    fromCity: "TP. Hồ Chí Minh",
    toCity: "Vũng Tàu",
    durationText: "2 giờ 15 phút",
    frequencyText: "30 chuyến mỗi ngày",
    minPriceVnd: "120000",
    imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=80"
  },
  {
    id: "alt-sg-pt",
    fromCity: "TP. Hồ Chí Minh",
    toCity: "Phan Thiết",
    durationText: "4 giờ",
    frequencyText: "18 chuyến mỗi ngày",
    minPriceVnd: "160000",
    imageUrl: "https://images.unsplash.com/photo-1528181304800-259b08848526?auto=format&fit=crop&w=400&q=80"
  }
] as const;

/**
 * Dữ liệu chi tiết chuyến xe mẫu chuẩn Figma 1443:11643.
 */
export const tripDetailFixture = {
  id: "trip-pn-01",
  operatorId: "opr-phuongnam",
  operatorName: "Phương Nam Travel",
  operatorCode: "PN",
  operatorRating: 4.6,
  operatorRatingCountText: "8.930 đánh giá",
  operatorPhone: "1900 8686",
  operatorEmail: "cskh@phuongnamtravel.vn",
  operatorDescription: "Nhà xe tuyến TP. Hồ Chí Minh – Tây Nguyên. Hotline 1900 8686 • cskh@phuongnamtravel.vn",
  vehicleTypeName: "Xe giường nằm Limousine • 34 chỗ • 2 tầng",
  seatTypeName: "Giường nằm",
  vehicleClass: "Limousine",
  statusBadge: "Đang mở bán",
  routeName: "TP. Hồ Chí Minh → Đà Lạt",
  routeMeta: "Thứ Sáu, 16/10/2026 • 308 km • 7 giờ",
  departureTime: "22:30",
  departureStation: "Bến xe Miền Đông mới",
  durationText: "7 giờ",
  stopsSummaryText: "1 điểm dừng nghỉ",
  arrivalTime: "05:30",
  arrivalStation: "Bến xe liên tỉnh Đà Lạt",
  isNextDay: true,
  photos: [
    {
      url: "https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=800&q=80",
      caption: "Ngoại thất xe • chụp tại bến"
    },
    {
      url: "https://images.unsplash.com/photo-1570125909232-eb263c188f7e?auto=format&fit=crop&w=400&q=80",
      caption: "Khoang ghế hành khách"
    },
    {
      url: "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80",
      caption: "Ngoại cảnh xe trên cung đường đèo"
    },
    {
      url: "https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=400&q=80",
      caption: "Hoàng hôn trên xe"
    },
    {
      url: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=80",
      caption: "Nội thất khoang nằm"
    }
  ],
  photosCaption: "Ngoại thất xe • chụp tại bến (chú thích của nhà xe)",
  remainingPhotosCount: 4,
  amenities: ["WiFi", "Điều hòa", "Nước uống", "Cổng sạc", "Chăn gối", "Rèm che"],
  timeline: [
    {
      time: "22:30",
      stationName: "Bến xe Miền Đông mới",
      address: "501 Hoàng Hữu Nam, TP. Thủ Đức, TP. Hồ Chí Minh",
      stationType: "bus_station" as const,
      stationTypeLabel: "Bến xe",
      badges: ["Đón khách"],
      lat: 10.866,
      lng: 106.815
    },
    {
      time: "22:50",
      stationName: "Văn phòng Phương Nam – Hàng Xanh",
      address: "12 Điện Biên Phủ, Q. Bình Thạnh, TP. Hồ Chí Minh",
      stationType: "office" as const,
      stationTypeLabel: "Văn phòng",
      badges: ["Trung chuyển miễn phí", "Đón khách"],
      lat: 10.801,
      lng: 106.711
    },
    {
      time: "01:40",
      stationName: "Trạm dừng nghỉ Madagui",
      address: "Quốc lộ 20, Đạ Huoai, Lâm Đồng",
      stationType: "rest_stop" as const,
      stationTypeLabel: "Dừng nghỉ",
      isRestStop: true,
      restStopDurationText: "Dừng nghỉ • 20 phút",
      lat: 11.417,
      lng: 107.545
    },
    {
      time: "05:10",
      stationName: "Văn phòng Phương Nam – Đà Lạt",
      address: "5 Lữ Gia, Phường 9, Đà Lạt",
      stationType: "office" as const,
      stationTypeLabel: "Văn phòng",
      badges: ["Trung chuyển miễn phí", "Trả khách"],
      lat: 11.948,
      lng: 108.455
    },
    {
      time: "05:30",
      stationName: "Bến xe liên tỉnh Đà Lạt",
      address: "1 Tô Hiến Thành, Phường 3, Đà Lạt",
      stationType: "bus_station" as const,
      stationTypeLabel: "Bến xe",
      badges: ["Trả khách"],
      lat: 11.930,
      lng: 108.445
    }
  ],
  seatMap: [
    // Tầng dưới (Floor 1)
    { id: "A01", label: "A01", floor: 1 as const, row: 1, col: 1, status: "available" as const },
    { id: "A02", label: "A02", floor: 1 as const, row: 1, col: 2, status: "available" as const },
    { id: "A03", label: "A03", floor: 1 as const, row: 1, col: 3, status: "available" as const },
    { id: "A04", label: "A04", floor: 1 as const, row: 2, col: 1, status: "available" as const },
    { id: "A05", label: "A05", floor: 1 as const, row: 2, col: 2, status: "holding" as const },
    { id: "A06", label: "A06", floor: 1 as const, row: 2, col: 3, status: "available" as const },
    { id: "A07", label: "A07", floor: 1 as const, row: 3, col: 1, status: "available" as const },
    { id: "A08", label: "A08", floor: 1 as const, row: 3, col: 2, status: "available" as const },
    { id: "A09", label: "A09", floor: 1 as const, row: 3, col: 3, status: "available" as const },
    { id: "A10", label: "A10", floor: 1 as const, row: 4, col: 1, status: "holding" as const },
    { id: "A11", label: "A11", floor: 1 as const, row: 4, col: 2, status: "available" as const },
    { id: "A12", label: "A12", floor: 1 as const, row: 4, col: 3, status: "available" as const },
    { id: "A13", label: "A13", floor: 1 as const, row: 5, col: 1, status: "available" as const },
    { id: "A14", label: "A14", floor: 1 as const, row: 5, col: 2, status: "available" as const },
    { id: "A15", label: "A15", floor: 1 as const, row: 5, col: 3, status: "available" as const },
    { id: "A16-17", label: "A16", floor: 1 as const, row: 6, col: 1, status: "available" as const, isDouble: true },
    // Tầng trên (Floor 2)
    { id: "B01", label: "B01", floor: 2 as const, row: 1, col: 1, status: "available" as const },
    { id: "B02", label: "B02", floor: 2 as const, row: 1, col: 2, status: "available" as const },
    { id: "B03", label: "B03", floor: 2 as const, row: 1, col: 3, status: "available" as const },
    { id: "B04", label: "B04", floor: 2 as const, row: 2, col: 1, status: "available" as const },
    { id: "B05", label: "B05", floor: 2 as const, row: 2, col: 2, status: "booked" as const },
    { id: "B06", label: "B06", floor: 2 as const, row: 2, col: 3, status: "available" as const },
    { id: "B07", label: "B07", floor: 2 as const, row: 3, col: 1, status: "available" as const },
    { id: "B08", label: "B08", floor: 2 as const, row: 3, col: 2, status: "available" as const },
    { id: "B09", label: "B09", floor: 2 as const, row: 3, col: 3, status: "available" as const },
    { id: "B10", label: "B10", floor: 2 as const, row: 4, col: 1, status: "available" as const },
    { id: "B11", label: "B11", floor: 2 as const, row: 4, col: 2, status: "available" as const },
    { id: "B12", label: "B12", floor: 2 as const, row: 4, col: 3, status: "available" as const },
    { id: "B13", label: "B13", floor: 2 as const, row: 5, col: 1, status: "available" as const },
    { id: "B14", label: "B14", floor: 2 as const, row: 5, col: 2, status: "available" as const },
    { id: "B15", label: "B15", floor: 2 as const, row: 5, col: 3, status: "available" as const },
    { id: "B16-17", label: "B16", floor: 2 as const, row: 6, col: 1, status: "available" as const, isDouble: true }
  ],
  totalSeats: 34,
  availableSeats: 12,
  priceSingleVnd: "280000",
  priceDoubleVnd: "520000",
  stopSalesTimeText: "22:00 • 16/10/2026 (trước giờ khởi hành 30 phút)",
  cancellationPolicies: [
    { condition: "Hủy trước giờ khởi hành từ 24 giờ", refundPercentText: "Hoàn 90% giá vé" },
    { condition: "Hủy trong khoảng 24 giờ – 4 giờ", refundPercentText: "Hoàn 50% giá vé" },
    { condition: "Hủy trong vòng 4 giờ trước giờ khởi hành", refundPercentText: "Không hoàn tiền" }
  ],
  cancellationNote: "Chính sách được lưu cùng đơn tại thời điểm đặt; thay đổi sau này của nhà xe không áp dụng cho đơn đã đặt.",
  reviewsAverage: 4.6,
  reviewsCountText: "8.930 đánh giá hợp lệ",
  reviews: [
    {
      id: "rev-01",
      authorName: "Trần Thu Hà",
      authorInitial: "T",
      rating: 5.0,
      travelDateText: "Đã đi ngày 02/10/2026",
      content: "Xe sạch, khởi hành đúng giờ. Nhân viên hỗ trợ trung chuyển từ văn phòng ra bến rất nhanh."
    },
    {
      id: "rev-02",
      authorName: "Lê Minh Quân",
      authorInitial: "L",
      rating: 4.0,
      travelDateText: "Đã đi ngày 27/09/2026",
      content: "Giường rộng, có cổng sạc. Trạm dừng nghỉ hơi đông vào cuối tuần."
    }
  ]
};

