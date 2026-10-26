import {
  MyTicketsData,
  TicketDetailData,
  TicketLookupInitData,
  TicketLookupOtpState,
  TicketLookupResultData
} from "../../data/types";

/**
 * Fixture danh sách vé lý tưởng (SCR-PSG-24 - node 1445:14030).
 */
export const myTicketsIdealFixture: MyTicketsData = {
  counts: {
    upcoming: 2,
    completed: 5,
    cancelled: 1,
    all: 8
  },
  featuredTrip: {
    badgeText: "CHUYẾN GẦN NHẤT · CÒN 8 NGÀY",
    routeName: "TP. Hồ Chí Minh → Đà Lạt",
    departureTimeText: "22:30 · Thứ Sáu, 16/10/2026 · Phương Nam Travel",
    operatorName: "Phương Nam Travel",
    pickupPointName: "Bến xe Miền Đông mới",
    seatCodesText: "Chỗ A3, A4",
    ticketId: "ticket-vxn-8f3k2q",
    noticeText: "Có mặt trước giờ khởi hành 30 phút"
  },
  tickets: [
    {
      id: "ticket-vxn-8f3k2q",
      bookingCode: "VXN-8F3K2Q",
      routeName: "TP. Hồ Chí Minh → Đà Lạt",
      status: "valid",
      departureDayOfWeek: "Thứ 6",
      departureDay: "16",
      departureMonth: "Tháng 10",
      departureTimeText: "22:30",
      arrivalTimeText: "05:30 (+1 ngày)",
      operatorName: "Phương Nam Travel",
      vehicleType: "Giường nằm Limousine",
      ticketCount: 2,
      seatCodesText: "Chỗ A3, A4",
      pickupPointName: "Bến xe Miền Đông mới",
      totalAmountVnd: "460000"
    },
    {
      id: "booking-vxn-2m7t9a",
      bookingCode: "VXN-2M7T9A",
      routeName: "TP. Hồ Chí Minh → Vũng Tàu",
      status: "pending_payment",
      departureDayOfWeek: "CN",
      departureDay: "25",
      departureMonth: "Tháng 10",
      departureTimeText: "07:00",
      arrivalTimeText: "09:15",
      operatorName: "Hoàng Long Coach",
      vehicleType: "Ghế ngồi",
      ticketCount: 1,
      seatCodesText: "Chỗ 12",
      pickupPointName: "Bến xe Miền Tây",
      totalAmountVnd: "120000",
      holdCountdownSeconds: 372, // 06:12
      paymentUrl: "/bookings/book-hl-2m7t9a/payment"
    }
  ]
};

/**
 * Fixture danh sách vé rỗng (SCR-PSG-24 - node 1450:23264).
 */
export const myTicketsEmptyFixture: MyTicketsData = {
  counts: {
    upcoming: 0,
    completed: 0,
    cancelled: 0,
    all: 0
  },
  tickets: []
};

/**
 * Fixture chi tiết vé điện tử đầy đủ (SCR-PSG-25 - node 1445:14456 và SCR-PSG-26).
 */
export const ticketDetailFixture: TicketDetailData = {
  bookingCode: "VXN-8F3K2Q",
  bookingTimeText: "Đặt lúc 14:10 · 08/10/2026 · 2 vé",
  status: "confirmed",
  statusLabel: "Đã xác nhận",
  trip: {
    operatorName: "Phương Nam Travel",
    operatorCode: "PN",
    operatorHotline: "1900 8686",
    routeName: "TP. Hồ Chí Minh → Đà Lạt",
    departureDayOfWeek: "Thứ Sáu",
    departureDateText: "16/10/2026",
    departureTime: "22:30",
    departurePointName: "Bến xe Miền Đông mới",
    departureAddress: "501 Hoàng Hữu Nam, TP. Thủ Đức, TP. Hồ Chí Minh",
    arrivalTime: "05:30",
    arrivalNoticeText: "+1 ngày",
    arrivalPointName: "Bến xe liên tỉnh Đà Lạt",
    arrivalAddress: "1 Tô Hiến Thành, Phường 3, Đà Lạt",
    travelDurationText: "7 giờ · 1 điểm dừng nghỉ"
  },
  tickets: [
    {
      ticketId: "t-01",
      ticketCode: "VXN-8F3K2Q-01",
      passengerName: "Nguyễn Văn Khách",
      seatCode: "A3",
      seatType: "Giường đơn · Tầng dưới",
      pricePaidVnd: "230000",
      status: "valid"
    },
    {
      ticketId: "t-02",
      ticketCode: "VXN-8F3K2Q-02",
      passengerName: "Trần Thị Mai",
      seatCode: "A4",
      seatType: "Giường đơn · Tầng dưới",
      pricePaidVnd: "230000",
      status: "valid"
    }
  ],
  payment: {
    ticketCount: 2,
    ticketPriceTotalVnd: "560000",
    serviceFeeVnd: "0",
    discountVnd: "100000",
    paidTotalVnd: "460000",
    methodLabel: "VNPay",
    gatewayTxnId: "VNP14982231",
    statusLabel: "Thành công"
  },
  refundPolicy: {
    savedAtText: "Lưu tại thời điểm đặt · 08/10/2026",
    currentRefundNote: "Hiện tại: hủy vé được hoàn 90% số tiền đã trả.",
    milestones: [
      {
        timeframeText: "Trước 22:30 · 15/10",
        refundRateText: "Hoàn 90%",
        refundPercent: 90
      },
      {
        timeframeText: "Đến 18:30 · 16/10",
        refundRateText: "Hoàn 50%",
        refundPercent: 50
      },
      {
        timeframeText: "Sau 18:30 · 16/10",
        refundRateText: "Không hoàn",
        refundPercent: 0
      }
    ]
  },
  boardingRules: [
    "Có mặt tại điểm đón trước giờ khởi hành ít nhất 30 phút.",
    "Mang giấy tờ tùy thân trùng tên với vé và xuất trình mã QR khi lên xe.",
    "Mỗi hành khách được mang 20 kg hành lý ký gửi và 1 túi xách tay."
  ]
};

/**
 * Fixture dữ liệu form tra cứu vé B1 (SCR-PSG-27 - node 1446:14982).
 */
export const ticketLookupIdealFixture: TicketLookupInitData = {
  bookingCodeOrTicketCode: "VXN-4H9P6C",
  email: "hoa.le@gmail.com"
};

/**
 * Fixture dữ liệu xác minh OTP tra cứu vé B2 (SCR-PSG-28 - node 1446:15277).
 */
export const ticketLookupOtpFixture: TicketLookupOtpState = {
  bookingCode: "VXN-4H9P6C",
  email: "hoa.le@gmail.com",
  maskedEmail: "h***e@gmail.com",
  otpDigits: ["4", "8", "2", "9", "1", "7"],
  expiresInSeconds: 272,
  remainingAttempts: 5,
  resendCountdownSeconds: 28
};

/**
 * Fixture kết quả tra cứu vé của khách vãng lai (SCR-PSG-29 - node 1446:15578).
 */
export const ticketLookupResultFixture: TicketLookupResultData = {
  bookingCode: "VXN-4H9P6C",
  routeName: "TP. Hồ Chí Minh → Đà Lạt",
  departureTimeText: "22:30 · Thứ Sáu, 16/10/2026",
  operatorName: "Phương Nam Travel",
  statusLabel: "Đã xác nhận",
  session: {
    maskedEmail: "h***e@gmail.com",
    expiresInSeconds: 860 // 14:20
  },
  tickets: [
    {
      ticketId: "tk-01",
      ticketCode: "VXN-4H9P6C-01",
      passengerName: "Lê Thị Hoa",
      seatCode: "B5",
      seatType: "Giường đơn · Tầng trên",
      status: "valid",
      statusLabel: "Hợp lệ"
    },
    {
      ticketId: "tk-02",
      ticketCode: "VXN-4H9P6C-02",
      passengerName: "Lê Văn Nam",
      seatCode: "B7",
      seatType: "Giường đơn · Tầng trên",
      status: "valid",
      statusLabel: "Hợp lệ"
    }
  ],
  pickupPoint: {
    time: "22:50",
    name: "Văn phòng Phương Nam – Hàng Xanh",
    address: "12 Điện Biên Phủ, Q. Bình Thạnh",
    tagText: "Trung chuyển miễn phí"
  },
  dropoffPoint: {
    time: "05:30",
    name: "Bến xe liên tỉnh Đà Lạt",
    address: "1 Tô Hiến Thành, Phường 3, Đà Lạt",
    noticeText: "+1 NGÀY"
  },
  payment: {
    seatCount: 2,
    ticketPriceTotalVnd: "560000",
    serviceFeeVnd: "0",
    paidTotalVnd: "560000",
    methodLabel: "Ví MoMo",
    statusLabel: "Thành công"
  }
};


