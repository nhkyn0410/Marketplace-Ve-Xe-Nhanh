import {
  BookingPaymentData,
  BookingPaymentResultData,
  CheckoutHoldData,
  TripSeatSelectionData
} from "../../data/types";

/**
 * Fixture dữ liệu mẫu cho màn hình Chọn điểm và chọn chỗ SCR-PSG-18 (node 1443:12719).
 */
export const tripSeatSelectionIdealFixture: TripSeatSelectionData = {
  tripId: "trip-pn-01",
  routeName: "TP. Hồ Chí Minh → Đà Lạt",
  departureTimeText: "22:30 • T6, 16/10/2026",
  operatorName: "Phương Nam Travel",
  holdCountdownSeconds: 582, // 09:42
  maxSeats: 10,
  pickupPoints: [
    {
      id: "pickup-bxmd",
      name: "Bến xe Miền Đông mới",
      time: "22:30",
      address: "501 Hoàng Hữu Nam, TP. Thủ Đức",
      hasFreeShuttle: false
    },
    {
      id: "pickup-hangxanh",
      name: "Văn phòng Phương Nam – Hàng Xanh",
      time: "22:50",
      address: "12 Điện Biên Phủ, Q. Bình Thạnh",
      hasFreeShuttle: true
    }
  ],
  dropoffPoints: [
    {
      id: "dropoff-dalat-office",
      name: "Văn phòng Phương Nam – Đà Lạt",
      time: "05:10",
      address: "5 Lữ Gia, Phường 9, Đà Lạt",
      hasFreeShuttle: true
    },
    {
      id: "dropoff-bxdalat",
      name: "Bến xe liên tỉnh Đà Lạt",
      time: "05:30",
      address: "1 Tô Hiến Thành, Phường 3, Đà Lạt",
      hasFreeShuttle: false
    }
  ],
  selectedPickupPointId: "pickup-bxmd",
  selectedDropoffPointId: "dropoff-bxdalat",
  seats: [
    // Tầng dưới (Floor 1)
    { id: "s-a1", code: "A1", label: "A1", floor: 1, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-a2", code: "A2", label: "A2", floor: 1, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-a3", code: "A3", label: "A3", floor: 1, status: "selected", type: "single", priceVnd: "280000" },
    { id: "s-a4", code: "A4", label: "A4", floor: 1, status: "selected", type: "single", priceVnd: "280000" },
    { id: "s-a5", code: "A5", label: "A5", floor: 1, status: "holding", type: "single", priceVnd: "280000" },
    { id: "s-a6", code: "A6", label: "A6", floor: 1, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-a7", code: "A7", label: "A7", floor: 1, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-a8", code: "A8", label: "A8", floor: 1, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-a9", code: "A9", label: "A9", floor: 1, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-a10", code: "A10", label: "A10", floor: 1, status: "holding", type: "single", priceVnd: "280000" },
    { id: "s-a11", code: "A11", label: "A11", floor: 1, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-a12", code: "A12", label: "A12", floor: 1, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-a13", code: "A13", label: "A13", floor: 1, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-a14", code: "A14", label: "A14", floor: 1, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-a15", code: "A15", label: "A15", floor: 1, status: "disabled", type: "single", priceVnd: "280000" },
    { id: "s-a16", code: "A16", label: "A16", floor: 1, status: "available", type: "double", priceVnd: "520000", capacityText: "2 người" },

    // Tầng trên (Floor 2)
    { id: "s-b1", code: "B1", label: "B1", floor: 2, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-b2", code: "B2", label: "B2", floor: 2, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-b3", code: "B3", label: "B3", floor: 2, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-b4", code: "B4", label: "B4", floor: 2, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-b5", code: "B5", label: "B5", floor: 2, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-b6", code: "B6", label: "B6", floor: 2, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-b7", code: "B7", label: "B7", floor: 2, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-b8", code: "B8", label: "B8", floor: 2, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-b9", code: "B9", label: "B9", floor: 2, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-b10", code: "B10", label: "B10", floor: 2, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-b11", code: "B11", label: "B11", floor: 2, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-b12", code: "B12", label: "B12", floor: 2, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-b13", code: "B13", label: "B13", floor: 2, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-b14", code: "B14", label: "B14", floor: 2, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-b15", code: "B15", label: "B15", floor: 2, status: "available", type: "single", priceVnd: "280000" },
    { id: "s-b16", code: "B16", label: "B16", floor: 2, status: "available", type: "double", priceVnd: "520000", capacityText: "2 người" }
  ],
  selectedSeatCodes: ["A3", "A4"],
  selectedSeatsSummary: [
    {
      id: "s-a3",
      code: "A3",
      seatTypeLabel: "Giường đơn",
      floorLabel: "Tầng dưới",
      priceVnd: "280000"
    },
    {
      id: "s-a4",
      code: "A4",
      seatTypeLabel: "Giường đơn",
      floorLabel: "Tầng dưới",
      priceVnd: "280000"
    }
  ],
  subtotalVnd: "560000"
};

/**
 * Fixture trạng thái Lỗi: Chỗ vừa bị người khác giữ (node 1450:22717).
 */
export const tripSeatSelectionErrorFixture: TripSeatSelectionData = {
  ...tripSeatSelectionIdealFixture,
  conflictError: {
    conflictedSeatCode: "A4",
    attemptedSeatsText: "A3, A4",
    message:
      "Hệ thống không giữ được đủ nhóm chỗ bạn chọn (A3, A4) nên chưa có chỗ nào được giữ. Sơ đồ đã được cập nhật, vui lòng chọn lại."
  }
};

/**
 * Fixture B2 Thông tin hành khách chuẩn Figma 1444:12531 (ideal).
 */
export const checkoutHoldIdealFixture: CheckoutHoldData = {
  holdId: "hold-pn-789",
  tripId: "trip-pn-01",
  routeName: "TP. Hồ Chí Minh → Đà Lạt",
  departureTimeText: "22:30 • T6, 16/10/2026",
  operatorName: "Phương Nam Travel",
  holdCountdownSeconds: 438, // 07:18
  pickupPoint: {
    id: "pickup-bxmd",
    name: "Bến xe Miền Đông mới",
    time: "22:30",
    address: "501 Hoàng Hữu Nam, TP. Thủ Đức",
    hasFreeShuttle: false
  },
  dropoffPoint: {
    id: "dropoff-bxdalat",
    name: "Bến xe liên tỉnh Đà Lạt",
    time: "05:30 (+1 ngày)",
    address: "1 Tô Hiến Thành, Phường 3, Đà Lạt",
    hasFreeShuttle: false
  },
  contactInfo: {
    fullName: "Nguyễn Văn Khách",
    phoneNumber: "0901 234 567",
    email: "khach.nguyen@gmail.com"
  },
  savedPassengers: [
    {
      id: "p-me",
      fullName: "Nguyễn Văn Khách (tôi)",
      phoneNumber: "0901 234 567",
      idNumber: "079 090 001 234",
      isPrimaryUser: true
    }
  ],
  maxSavedPassengers: 5,
  currentSavedPassengersCount: 3,
  passengers: [
    {
      seatCode: "A3",
      seatTypeLabel: "Giường đơn",
      floorLabel: "Tầng dưới",
      priceVnd: "280000",
      fullName: "Nguyễn Văn Khách",
      phoneNumber: "0901 234 567",
      idNumber: "079 090 001 234",
      shouldSaveForLater: false
    },
    {
      seatCode: "A4",
      seatTypeLabel: "Giường đơn",
      floorLabel: "Tầng dưới",
      priceVnd: "280000",
      fullName: "Trần Thị Mai",
      phoneNumber: "0912 555 678",
      idNumber: "",
      shouldSaveForLater: true
    }
  ],
  noteForOperator: "",
  vouchers: [
    {
      id: "v-points",
      code: "POINTS100",
      title: "Voucher đổi điểm • Giảm 100.000đ",
      description: "Áp dụng mọi tuyến, mọi nhà xe • Hạn dùng 05/11/2026",
      discountVnd: "100000",
      discountLabel: "-100.000đ",
      tagText: "Đổi từ điểm",
      isApplicable: true,
      isSelected: true
    },
    {
      id: "v-thu10",
      code: "THU10",
      title: "THU10 • Giảm 10%, tối đa 50.000đ",
      description: "Phương Nam Travel • Đơn từ 300.000đ • Hạn dùng 31/10/2026",
      discountVnd: "50000",
      discountLabel: "-50.000đ",
      tagText: "Mã đã lưu",
      isApplicable: true,
      isSelected: false
    },
    {
      id: "v-taybac30",
      code: "TAYBAC30",
      title: "TAYBAC30 • Giảm 30.000đ",
      description: "Không áp dụng cho chuyến này (chỉ tuyến Hà Nội – Sapa)",
      discountVnd: "30000",
      discountLabel: "-30.000đ",
      tagText: "Không phù hợp",
      isApplicable: false,
      unapplicableReason: "Không áp dụng cho chuyến này",
      isSelected: false
    }
  ],
  selectedVoucherId: "v-points",
  priceSummary: {
    ticketPriceTotalVnd: "560000",
    ticketCount: 2,
    serviceFeeVnd: "0",
    discountVnd: "100000",
    discountLabel: "-100.000đ",
    finalTotalVnd: "460000"
  }
};

/**
 * Fixture B2 Trạng thái giá vé vừa thay đổi (node 1450:22911).
 */
export const checkoutHoldStaleFixture: CheckoutHoldData = {
  ...checkoutHoldIdealFixture,
  stalePrice: {
    oldPriceVnd: "560000",
    newPriceVnd: "600000",
    discountVnd: "100000",
    newTotalVnd: "500000"
  }
};

/**
 * Fixture B3 Thanh toán chuẩn Figma 1444:13055 (ideal).
 */
export const bookingPaymentIdealFixture: BookingPaymentData = {
  bookingId: "book-pn-8f3k2q",
  bookingCode: "VXN-8F3K2Q",
  status: "pending_payment",
  tripId: "trip-pn-01",
  routeName: "TP. Hồ Chí Minh → Đà Lạt",
  departureTimeText: "22:30 • T6, 16/10/2026",
  operatorName: "Phương Nam Travel",
  holdCountdownSeconds: 336, // 05:36
  pickupPoint: {
    id: "pickup-bxmd",
    name: "Bến xe Miền Đông mới",
    time: "22:30",
    address: "501 Hoàng Hữu Nam, TP. Thủ Đức",
    hasFreeShuttle: false
  },
  dropoffPoint: {
    id: "dropoff-bxdalat",
    name: "Bến xe liên tỉnh Đà Lạt",
    time: "05:30 (+1 ngày)",
    address: "1 Tô Hiến Thành, Phường 3, Đà Lạt",
    hasFreeShuttle: false
  },
  contactInfo: {
    fullName: "Nguyễn Văn Khách",
    phoneNumber: "0901 234 567",
    email: "khach.nguyen@gmail.com"
  },
  passengers: [
    {
      seatCode: "A3",
      seatTypeLabel: "Giường đơn",
      floorLabel: "Tầng dưới",
      priceVnd: "280000",
      fullName: "Nguyễn Văn Khách",
      phoneNumber: "0901 234 567",
      idNumber: "079 090 001 234",
      shouldSaveForLater: false
    },
    {
      seatCode: "A4",
      seatTypeLabel: "Giường đơn",
      floorLabel: "Tầng dưới",
      priceVnd: "280000",
      fullName: "Trần Thị Mai",
      phoneNumber: "0912 555 678",
      idNumber: "",
      shouldSaveForLater: true
    }
  ],
  selectedPaymentMethod: "vnpay",
  selectedBankOption: "vnpay_qr",
  priceSummary: {
    ticketPriceTotalVnd: "560000",
    ticketCount: 2,
    serviceFeeVnd: "0",
    discountVnd: "100000",
    discountLabel: "-100.000đ",
    finalTotalVnd: "460000"
  },
  isExpired: false
};

/**
 * Fixture B3 Trạng thái hết thời gian giữ chỗ (node 1450:23099).
 */
export const bookingPaymentExpiredFixture: BookingPaymentData = {
  ...bookingPaymentIdealFixture,
  status: "expired",
  isExpired: true,
  holdCountdownSeconds: 0
};

/**
 * Fixture kết quả thanh toán Chờ xác nhận (SCR-PSG-21 - node 1444:13464).
 */
export const paymentResultProcessingFixture: BookingPaymentResultData = {
  bookingId: "book-pn-8f3k2q",
  bookingCode: "VXN-8F3K2Q",
  status: "processing",
  paymentMethodLabel: "VNPay",
  amountVnd: "460000"
};

/**
 * Fixture kết quả thanh toán Thành công (SCR-PSG-22 - node 1444:13772).
 */
export const paymentResultSuccessFixture: BookingPaymentResultData = {
  bookingId: "book-pn-8f3k2q",
  bookingCode: "VXN-8F3K2Q",
  status: "success",
  paymentMethodLabel: "VNPay",
  amountVnd: "460000",
  customerEmail: "khach.nguyen@gmail.com",
  tickets: [
    {
      ticketId: "t-01",
      ticketCode: "VXN-8F3K2Q-01",
      passengerName: "Nguyễn Văn Khách",
      seatCode: "A3",
      seatType: "Giường đơn · Tầng dưới",
      status: "valid"
    },
    {
      ticketId: "t-02",
      ticketCode: "VXN-8F3K2Q-02",
      passengerName: "Trần Thị Mai",
      seatCode: "A4",
      seatType: "Giường đơn · Tầng dưới",
      status: "valid"
    }
  ],
  trip: {
    operatorName: "Phương Nam Travel",
    operatorCode: "PN",
    routeName: "TP. Hồ Chí Minh → Đà Lạt",
    vehicleType: "Giường nằm Limousine",
    departureTimeText: "22:30 · Thứ Sáu, 16/10/2026",
    pickupPointName: "Bến xe Miền Đông mới",
    dropoffPointName: "Bến xe liên tỉnh Đà Lạt",
    dropoffTimeText: "05:30 (+1 ngày)",
    noticeText: "Vui lòng có mặt tại điểm đón trước giờ khởi hành ít nhất 30 phút."
  },
  paymentDetails: {
    ticketCount: 2,
    ticketPriceTotalVnd: "560000",
    serviceFeeVnd: "0",
    discountVnd: "100000",
    finalTotalVnd: "460000",
    gatewayTxnId: "VNP14982231",
    paidAtText: "14:12 · 08/10/2026"
  }
};

/**
 * Fixture kết quả thanh toán Thất bại (SCR-PSG-23 - node 1444:14189).
 */
export const paymentResultFailedFixture: BookingPaymentResultData = {
  bookingId: "book-pn-8f3k2q",
  bookingCode: "VXN-8F3K2Q",
  status: "failed",
  paymentMethodLabel: "VNPay",
  amountVnd: "460000",
  failureReason: "Giao dịch bị hủy trên cổng thanh toán",
  holdCountdownSeconds: 255
};



