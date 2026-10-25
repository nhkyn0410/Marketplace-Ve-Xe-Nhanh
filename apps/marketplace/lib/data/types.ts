// Tạm — chưa có hợp đồng API (05 API §7.2)

/**
 * Thông tin tỉnh/thành phố trong danh mục điểm đón/trả.
 */
export interface ProvinceItem {
  readonly id: string;
  readonly name: string;
  readonly code: string;
}

/**
 * Điểm dừng/đón trả của chuyến xe.
 */
export interface StopPointItem {
  readonly id: string;
  readonly name: string;
  readonly address: string;
  readonly provinceId: string;
}

/**
 * Trạng thái hồ sơ người dùng tóm tắt trên thanh điều hướng.
 */
export interface UserProfileSummary {
  readonly fullName: string;
  readonly initials: string;
  readonly tierName: string;
}

/**
 * Tuyến xe phổ biến được đề xuất trên trang chủ.
 */
export interface PopularRouteItem {
  readonly id: string;
  readonly fromCity: string;
  readonly toCity: string;
  readonly distanceKm: number;
  readonly durationText: string;
  readonly vehicleTypeText: string;
  readonly minPriceVnd: string;
  readonly rating: number;
  readonly isFeatured?: boolean;
}

/**
 * Nhà xe đối tác tiêu biểu hiển thị trên trang chủ và danh sách chọn.
 */
export interface FeaturedOperatorItem {
  readonly id: string;
  readonly name: string;
  readonly shortCode: string;
  readonly rating: number;
  readonly ratingCountText: string;
  readonly dailyTripsText: string;
  readonly vehicleTypesText: string;
  readonly popularRoutesText: string;
  readonly slug: string;
  readonly accentColor?: string;
}

/**
 * Bài viết cẩm nang xe khách trên trang chủ.
 */
export interface HandbookArticleItem {
  readonly id: string;
  readonly title: string;
  readonly category: string;
  readonly readTimeText: string;
  readonly slug: string;
}

/**
 * Dữ liệu tổng hợp cho trang chủ.
 */
export interface HomeCatalogData {
  readonly provinces: readonly ProvinceItem[];
  readonly popularRoutes: readonly PopularRouteItem[];
  readonly featuredOperators: readonly FeaturedOperatorItem[];
  readonly articles: readonly HandbookArticleItem[];
}

/**
 * Mục chuyến xe trong kết quả tìm kiếm (SCR-PSG-15).
 */
export interface TripSearchResultItem {
  readonly id: string;
  readonly operatorId: string;
  readonly operatorName: string;
  readonly operatorCode: string;
  readonly operatorAccentColor?: string;
  readonly operatorRating: number;
  readonly operatorRatingCountText: string;
  readonly vehicleType: string;
  readonly seatType: string;
  readonly departureTime: string;
  readonly departureCity: string;
  readonly departureStation: string;
  readonly arrivalTime: string;
  readonly arrivalCity: string;
  readonly arrivalStation: string;
  readonly durationText: string;
  readonly stopCountText: string;
  readonly isNextDay?: boolean;
  readonly priceVnd: string;
  readonly availableSeats: number;
  readonly isUrgent?: boolean;
  readonly amenities: readonly string[];
  /** Số tiện ích còn lại chưa hiển thị (chip "+1"); không có thì ẩn chip. */
  readonly moreAmenitiesCount?: number;
  /** Ảnh xe — chưa có nguồn ảnh thật, view hiện khối bg-muted khi thiếu (A5). */
  readonly imageUrl?: string;
}

/**
 * Tùy chọn mục lọc kèm số lượng chuyến.
 */
export interface TripFilterOptionItem {
  readonly id: string;
  readonly label: string;
  readonly count?: number;
}

/**
 * Dữ liệu tóm tắt tìm kiếm chuyến xe.
 */
export interface TripSearchSummary {
  readonly originCity: string;
  readonly destinationCity: string;
  readonly departureDateText: string;
  /** Ngày đi dạng ngắn hiển thị trong ô tìm kiếm, ví dụ "T6, 16/10/2026". */
  readonly departureDateShortText: string;
  readonly passengerCount: number;
  readonly totalTrips: number;
}

/**
 * Các nhóm lọc (kèm số chuyến) trả về cùng kết quả tìm chuyến (SCR-PSG-15, node 1440:11297).
 */
export interface TripSearchFacets {
  /** Giá thấp nhất của thanh trượt — chuỗi số nguyên VND. */
  readonly priceMinVnd: string;
  /** Giá cao nhất của thanh trượt — chuỗi số nguyên VND. */
  readonly priceMaxVnd: string;
  readonly seatTypes: readonly TripFilterOptionItem[];
  readonly vehicleClasses: readonly TripFilterOptionItem[];
  readonly operators: readonly TripFilterOptionItem[];
  readonly pickupPoints: readonly TripFilterOptionItem[];
  readonly dropoffPoints: readonly TripFilterOptionItem[];
}

/**
 * Điểm dừng trên dòng thời gian lịch trình chi tiết chuyến.
 */
export interface TripTimelineStop {
  readonly time: string;
  readonly stationName: string;
  readonly address: string;
  readonly stationType: "bus_station" | "office" | "rest_stop";
  readonly stationTypeLabel: string;
  readonly isRestStop?: boolean;
  readonly restStopDurationText?: string;
  readonly badges?: readonly string[];
  readonly lat?: number;
  readonly lng?: number;
}

/**
 * Ghế trong sơ đồ xem trước tình trạng chỗ.
 */
export interface TripSeatPreviewItem {
  readonly id: string;
  readonly label: string;
  readonly floor: 1 | 2;
  readonly row: number;
  readonly col: number;
  readonly status: "available" | "holding" | "booked" | "unavailable";
  readonly isDouble?: boolean;
}

/**
 * Mức trong chính sách hủy / hoàn tiền.
 */
export interface TripCancellationTier {
  readonly condition: string;
  readonly refundPercentText: string;
}

/**
 * Đánh giá của hành khách cho chuyến xe.
 */
export interface TripReviewItem {
  readonly id: string;
  readonly authorName: string;
  readonly authorInitial: string;
  readonly rating: number;
  readonly travelDateText: string;
  readonly content: string;
}

/**
 * Chi tiết chuyến xe đầy đủ theo SCR-PSG-16 (node 1443:11643).
 */
export interface TripDetailData {
  readonly id: string;
  readonly operatorId: string;
  readonly operatorName: string;
  readonly operatorCode: string;
  readonly operatorRating: number;
  readonly operatorRatingCountText: string;
  readonly operatorPhone: string;
  readonly operatorEmail: string;
  readonly operatorDescription: string;
  readonly vehicleTypeName: string;
  readonly seatTypeName: string;
  readonly vehicleClass: string;
  readonly statusBadge: string;
  readonly routeName: string;
  readonly routeMeta: string;
  readonly departureTime: string;
  readonly departureStation: string;
  readonly durationText: string;
  readonly stopsSummaryText: string;
  readonly arrivalTime: string;
  readonly arrivalStation: string;
  readonly isNextDay: boolean;
  readonly photos: readonly { readonly url: string; readonly caption: string }[];
  readonly photosCaption: string;
  readonly remainingPhotosCount: number;
  readonly amenities: readonly string[];
  readonly timeline: readonly TripTimelineStop[];
  readonly seatMap: readonly TripSeatPreviewItem[];
  readonly totalSeats: number;
  readonly availableSeats: number;
  readonly priceSingleVnd: string;
  readonly priceDoubleVnd: string;
  readonly stopSalesTimeText: string;
  readonly cancellationPolicies: readonly TripCancellationTier[];
  readonly cancellationNote: string;
  readonly reviewsAverage: number;
  readonly reviewsCountText: string;
  readonly reviews: readonly TripReviewItem[];
}

/**
 * Chỉ số chất lượng vận hành của nhà xe (SCR-PSG-17).
 */
export interface OperatorQualityMetrics {
  readonly ratingAverageText: string;
  readonly ratingTotalText: string;
  readonly cancellationRateText: string;
  readonly cancellationRatePeriod: string;
  readonly refundDisputeRateText: string;
  readonly refundDisputePeriod: string;
  readonly checkinRateText: string;
  readonly checkinRateNote: string;
}

/**
 * Tuyến xe tiêu biểu của nhà xe.
 */
export interface OperatorFeaturedRoute {
  readonly id: string;
  readonly routeName: string;
  readonly metaText: string;
  readonly minPriceVnd?: string;
  readonly imageUrl: string;
  readonly searchUrl: string;
}

/**
 * Đánh giá chi tiết của hành khách về nhà xe.
 */
export interface OperatorReviewItem {
  readonly id: string;
  readonly authorName: string;
  readonly authorInitial: string;
  readonly routeAndDateText: string;
  readonly rating: number;
  readonly content: string;
}

/**
 * Hồ sơ nhà xe chi tiết theo SCR-PSG-17 (node 1443:12312).
 */
export interface OperatorProfileData {
  readonly nextReviewCursor?: string | null;
  readonly id: string;
  readonly name: string;
  readonly code: string;
  readonly isVerified: boolean;
  readonly description: string;
  readonly hotline: string;
  readonly email: string;
  readonly headquarters: string;
  readonly metrics: OperatorQualityMetrics;
  readonly featuredRoutes: readonly OperatorFeaturedRoute[];
  readonly reviews: readonly OperatorReviewItem[];
  readonly terms: readonly string[];
}

/**
 * Điểm đón hoặc trả khách trong màn chọn chỗ.
 */
export interface SeatLocationPoint {
  readonly id: string;
  readonly name: string;
  readonly address: string;
  readonly time: string;
  readonly hasFreeShuttle: boolean;
  /** Thời điểm dự kiến (ISO) — dùng tính "+N ngày" của điểm trả so với điểm đón. */
  readonly plannedAt?: string;
}

/**
 * Trạng thái của một ghế trong sơ đồ chọn chỗ SCR-PSG-18.
 */
export type SeatSelectionStatus = "available" | "selected" | "holding" | "booked" | "disabled";

/**
 * Ghế chi tiết trong sơ đồ chọn chỗ SCR-PSG-18.
 */
export interface SeatSelectionItem {
  readonly row?: number;
  readonly column?: number;
  readonly id: string;
  readonly code: string;
  readonly label: string;
  readonly floor: 1 | 2;
  readonly status: SeatSelectionStatus;
  readonly type: "single" | "double";
  readonly priceVnd: string;
  readonly capacityText?: string;
}

/**
 * Ghế đã chọn hiển thị ở thanh tóm tắt bên phải.
 */
export interface SelectedSeatDetail {
  readonly id: string;
  readonly code: string;
  readonly seatTypeLabel: string;
  readonly floorLabel: string;
  readonly priceVnd: string;
}

/**
 * Thông báo lỗi xung đột giữ chỗ (node 1450:22717).
 */
export interface SeatHoldConflictError {
  readonly conflictedSeatCode: string;
  readonly attemptedSeatsText: string;
  readonly message: string;
}

/**
 * Dữ liệu màn hình Chọn điểm và chọn chỗ theo SCR-PSG-18 (node 1443:12719).
 */
export interface TripSeatSelectionData {
  readonly tripId: string;
  readonly routeName: string;
  readonly departureTimeText: string;
  readonly operatorName: string;
  readonly pickupPoints: readonly SeatLocationPoint[];
  readonly dropoffPoints: readonly SeatLocationPoint[];
  readonly selectedPickupPointId: string;
  readonly selectedDropoffPointId: string;
  readonly seats: readonly SeatSelectionItem[];
  readonly selectedSeatCodes: readonly string[];
  readonly maxSeats: number;
  readonly holdCountdownSeconds: number;
  readonly selectedSeatsSummary: readonly SelectedSeatDetail[];
  readonly subtotalVnd: string;
  readonly conflictError?: SeatHoldConflictError;
}

/**
 * Thông tin liên hệ người đặt vé.
 */
export interface CheckoutContactInfo {
  readonly fullName: string;
  readonly phoneNumber: string;
  readonly email: string;
}

/**
 * Hành khách đã lưu trong sổ địa chỉ / tài khoản.
 */
export interface SavedPassenger {
  readonly id: string;
  readonly fullName: string;
  readonly phoneNumber: string;
  readonly idNumber: string;
  readonly isPrimaryUser?: boolean;
}

/**
 * Thông tin một hành khách tương ứng với một ghế đặt.
 */
export interface CheckoutPassengerItem {
  readonly seatCode: string;
  readonly seatTypeLabel: string;
  readonly floorLabel: string;
  readonly priceVnd: string;
  readonly fullName: string;
  readonly phoneNumber: string;
  readonly idNumber: string;
  readonly shouldSaveForLater: boolean;
}

/**
 * Voucher ưu đãi áp dụng trong bước thanh toán.
 */
export interface CheckoutVoucherItem {
  readonly id: string;
  readonly code: string;
  readonly title: string;
  readonly description: string;
  readonly discountVnd: string;
  readonly discountLabel: string;
  readonly tagText: string;
  readonly isApplicable: boolean;
  readonly unapplicableReason?: string;
  readonly isSelected?: boolean;
}

/**
 * Bảng giá tổng hợp theo quy tắc A3 #8 (không tự tính, lấy từ dữ liệu).
 */
export interface CheckoutPriceSummary {
  readonly isEstimate?: boolean;
  readonly ticketPriceTotalVnd: string;
  readonly ticketCount: number;
  readonly serviceFeeVnd: string;
  readonly discountVnd: string;
  readonly discountLabel: string;
  readonly finalTotalVnd: string;
}

/** Báo giá mã khuyến mãi công khai do API tính từ tiền giữ chỗ. */
export interface CheckoutPromotionQuote {
  readonly code: string;
  readonly name: string;
  readonly discountVnd: string;
  readonly totalVnd: string;
}

/**
 * Dữ liệu cảnh báo giá vé vừa thay đổi (node 1450:22911).
 */
export interface CheckoutStalePriceData {
  readonly oldPriceVnd: string;
  readonly newPriceVnd: string;
  readonly discountVnd: string;
  readonly newTotalVnd: string;
}

/**
 * Dữ liệu màn hình B2 Thông tin hành khách (SCR-PSG-19 - node 1444:12531).
 */
export interface CheckoutHoldData {
  readonly holdId: string;
  readonly tripId: string;
  readonly routeName: string;
  readonly departureTimeText: string;
  readonly operatorName: string;
  readonly holdCountdownSeconds: number;
  readonly pickupPoint: SeatLocationPoint;
  readonly dropoffPoint: SeatLocationPoint;
  readonly contactInfo: CheckoutContactInfo;
  readonly savedPassengers: readonly SavedPassenger[];
  readonly maxSavedPassengers: number;
  readonly currentSavedPassengersCount: number;
  readonly passengers: readonly CheckoutPassengerItem[];
  readonly noteForOperator?: string;
  readonly vouchers: readonly CheckoutVoucherItem[];
  readonly selectedVoucherId?: string;
  readonly priceSummary: CheckoutPriceSummary;
  readonly stalePrice?: CheckoutStalePriceData;
}

/**
 * Phương thức thanh toán được hỗ trợ theo ADR-011 / A3 #2.
 */
export type SupportedPaymentMethod = "vnpay" | "momo";

/**
 * Lựa chọn ngân hàng / loại thẻ con của VNPay.
 */
export type VNPayBankOption =
  | "vnpay_qr"
  | "vietcombank"
  | "vietinbank"
  | "bidv"
  | "techcombank"
  | "mbbank"
  | "acb"
  | "international_card";

/**
 * Dữ liệu màn hình B3 Thanh toán (SCR-PSG-20 - node 1444:13055).
 */
export interface BookingPaymentData {
  readonly bookingStatus?: string;
  readonly bookingId: string;
  readonly bookingCode: string;
  readonly status: "pending_payment" | "expired";
  readonly tripId: string;
  readonly routeName: string;
  readonly departureTimeText: string;
  readonly operatorName: string;
  readonly holdCountdownSeconds: number;
  readonly pickupPoint: SeatLocationPoint;
  readonly dropoffPoint: SeatLocationPoint;
  readonly contactInfo: CheckoutContactInfo;
  readonly passengers: readonly CheckoutPassengerItem[];
  readonly selectedPaymentMethod: SupportedPaymentMethod;
  readonly selectedBankOption: VNPayBankOption;
  readonly priceSummary: CheckoutPriceSummary;
  readonly isExpired?: boolean;
}

/**
 * Vé điện tử đã phát hành sau khi thanh toán thành công (SCR-PSG-22).
 */
export interface IssuedTicketItem {
  readonly ticketId: string;
  readonly ticketCode: string;
  readonly passengerName: string;
  readonly seatCode: string;
  readonly seatType: string;
  readonly status: "valid" | "used" | "checked_in" | "no_show" | "cancelled";
  readonly qrCodeDataUrl?: string;
}

/**
 * Chi tiết kết quả giao dịch thanh toán (SCR-PSG-21, 22, 23).
 */
export interface BookingPaymentResultData {
  readonly canRetryPayment?: boolean;
  readonly processingMessage?: string;
  readonly bookingId: string;
  readonly bookingCode: string;
  readonly status: "processing" | "success" | "failed";
  readonly paymentMethodLabel: string;
  readonly amountVnd: string;
  readonly customerEmail?: string;
  readonly failureReason?: string;
  readonly holdCountdownSeconds?: number;
  readonly tickets?: readonly IssuedTicketItem[];
  readonly trip?: {
    readonly operatorName: string;
    readonly operatorCode: string;
    readonly routeName: string;
    readonly vehicleType: string;
    readonly departureTimeText: string;
    readonly pickupPointName: string;
    readonly dropoffPointName: string;
    readonly dropoffTimeText: string;
    readonly noticeText?: string;
  };
  readonly paymentDetails?: {
    readonly ticketCount: number;
    readonly ticketPriceTotalVnd: string;
    readonly serviceFeeVnd: string;
    readonly discountVnd: string;
    readonly finalTotalVnd: string;
    readonly gatewayTxnId: string;
    readonly paidAtText: string;
  };
}

/**
 * Mục vé / đơn đặt vé trong danh sách Hành trình của tôi (SCR-PSG-24).
 */
export interface MyTicketItem {
  readonly hasIssuedTickets?: boolean;
  readonly id: string;
  readonly bookingCode: string;
  readonly routeName: string;
  readonly status: "valid" | "pending_payment" | "completed" | "cancelled";
  readonly departureDayOfWeek: string;
  readonly departureDay: string;
  readonly departureMonth: string;
  readonly departureTimeText: string;
  readonly arrivalTimeText: string;
  readonly operatorName: string;
  readonly vehicleType: string;
  readonly ticketCount: number;
  readonly seatCodesText: string;
  readonly pickupPointName: string;
  readonly totalAmountVnd: string;
  readonly holdCountdownSeconds?: number;
  readonly paymentUrl?: string;
}

/**
 * Dữ liệu màn hình Hành trình của tôi (SCR-PSG-24 - node 1445:14030).
 */
export interface MyTicketsData {
  readonly counts: {
    readonly upcoming: number;
    readonly completed: number;
    readonly cancelled: number;
    readonly all: number;
  };
  readonly featuredTrip?: {
    readonly badgeText: string;
    readonly routeName: string;
    readonly departureTimeText: string;
    readonly operatorName: string;
    readonly pickupPointName: string;
    readonly seatCodesText: string;
    readonly ticketId: string;
    readonly noticeText: string;
  };
  readonly tickets: readonly MyTicketItem[];
}

/**
 * Mốc hoàn tiền trong chính sách hủy vé (SCR-PSG-25).
 */
export interface TicketRefundPolicyMilestone {
  readonly timeframeText: string;
  readonly refundRateText: string;
  readonly refundPercent: number;
}

/**
 * Chi tiết hành khách và vé trong đơn (SCR-PSG-25 & 26).
 */
export interface TicketPassengerDetail {
  readonly statusLabel?: string;
  readonly qrCodeDataUrl?: string;
  readonly ticketId: string;
  readonly ticketCode: string;
  readonly passengerName: string;
  readonly seatCode: string;
  readonly seatType: string;
  readonly pricePaidVnd: string;
  readonly status: "valid" | "used" | "checked_in" | "no_show" | "cancelled";
}

/**
 * Thông tin chuyến xe trong chi tiết vé.
 */
export type TicketTripInfo = TicketDetailData["trip"];

/**
 * Thông tin thanh toán trong chi tiết vé.
 */
export type TicketPaymentDetail = TicketDetailData["payment"];

/**
 * Thông tin chính sách hoàn tiền trong chi tiết vé.
 */
export type TicketRefundPolicy = TicketDetailData["refundPolicy"];

/**
 * Dữ liệu chi tiết vé xe điện tử (SCR-PSG-25 & SCR-PSG-26).
 */
export interface TicketDetailData {
  readonly supportHref?: string;
  readonly bookingId?: string;
  readonly bookingCode: string;
  readonly bookingTimeText: string;
  readonly status: "confirmed" | "completed" | "cancelled";
  readonly statusLabel: string;
  readonly trip: {
    readonly operatorName: string;
    readonly operatorCode: string;
    readonly operatorHotline: string;
    readonly routeName: string;
    readonly departureDayOfWeek: string;
    readonly departureDateText: string;
    readonly departureTime: string;
    readonly departurePointName: string;
    readonly departureAddress: string;
    readonly arrivalTime: string;
    readonly arrivalNoticeText: string;
    readonly arrivalPointName: string;
    readonly arrivalAddress: string;
    readonly travelDurationText: string;
  };
  readonly tickets: readonly TicketPassengerDetail[];
  readonly payment: {
    readonly ticketCount: number;
    readonly ticketPriceTotalVnd: string;
    readonly serviceFeeVnd: string;
    readonly discountVnd: string;
    readonly paidTotalVnd: string;
    readonly methodLabel: string;
    readonly gatewayTxnId: string;
    readonly statusLabel: string;
  };
  readonly refundPolicy: {
    readonly savedAtText: string;
    readonly currentRefundNote: string;
    readonly milestones: readonly TicketRefundPolicyMilestone[];
  };
  readonly boardingRules: readonly string[];
}

/**
 * Dữ liệu form tra cứu vé B1 (SCR-PSG-27).
 */
export interface TicketLookupInitData {
  readonly bookingCodeOrTicketCode: string;
  readonly email: string;
}

/**
 * Trạng thái xác thực OTP tra cứu vé B2 (SCR-PSG-28).
 */
export interface TicketLookupOtpState {
  readonly bookingCode: string;
  readonly maskedEmail: string;
  readonly otpDigits: readonly string[];
  readonly expiresInSeconds: number;
  readonly remainingAttempts: number;
  readonly resendCountdownSeconds: number;
}

/**
 * Vé đơn lẻ trong kết quả tra cứu (SCR-PSG-29).
 */
export interface TicketLookupResultItem {
  readonly qrCodeDataUrl?: string;
  readonly ticketId: string;
  readonly ticketCode: string;
  readonly passengerName: string;
  readonly seatCode: string;
  readonly seatType: string;
  readonly status: "valid" | "used" | "checked_in" | "no_show" | "cancelled";
  readonly statusLabel: string;
}

/**
 * Toàn bộ dữ liệu kết quả tra cứu vé cho khách vãng lai (SCR-PSG-29 - node 1446:15578).
 */
export interface TicketLookupResultData {
  readonly canManageBooking?: boolean;
  readonly bookingId?: string;
  readonly bookingCode: string;
  readonly routeName: string;
  readonly departureTimeText: string;
  readonly operatorName: string;
  readonly statusLabel: string;
  readonly session: {
    readonly maskedEmail: string;
    readonly expiresInSeconds: number;
  };
  readonly tickets: readonly TicketLookupResultItem[];
  readonly pickupPoint: {
    readonly time: string;
    readonly name: string;
    readonly address: string;
    readonly tagText?: string;
  };
  readonly dropoffPoint: {
    readonly time: string;
    readonly name: string;
    readonly address: string;
    readonly noticeText: string;
  };
  readonly payment: {
    readonly seatCount: number;
    readonly ticketPriceTotalVnd: string;
    readonly serviceFeeVnd: string;
    readonly paidTotalVnd: string;
    readonly methodLabel: string;
    readonly statusLabel: string;
  };
}

/**
 * Trạng thái khiếu nại của hành khách (SCR-PSG-30).
 */
export type ComplaintStatus = "needs_info" | "processing" | "resolved" | "closed";

/**
 * Item khiếu nại trong danh sách (SCR-PSG-30).
 */
export interface ComplaintListItem {
  readonly id: string;
  readonly code: string;
  readonly title: string;
  readonly bookingCode: string;
  readonly updatedAtText: string;
  readonly status: ComplaintStatus;
  readonly statusLabel: string;
  readonly statusTone: "warning" | "neutral" | "success" | "danger";
}

/**
 * Tin nhắn trao đổi trong khiếu nại (SCR-PSG-30).
 */
export interface ComplaintMessage {
  readonly id: string;
  readonly senderName: string;
  readonly senderRole: "passenger" | "platform" | "operator";
  readonly createdAtText: string;
  readonly content: string;
  readonly attachments?: readonly {
    readonly fileName: string;
    readonly fileSizeText: string;
    readonly fileUrl?: string;
  }[];
}

/**
 * Bước tiến trình xử lý khiếu nại.
 */
export interface ComplaintProgressStep {
  readonly label: string;
  readonly state: "completed" | "current" | "upcoming";
}

/**
 * Chi tiết một khiếu nại (SCR-PSG-30).
 */
export interface ComplaintDetailData {
  readonly id: string;
  readonly code: string;
  readonly title: string;
  readonly createdAtText: string;
  readonly statusLabel: string;
  readonly statusTone: "warning" | "neutral" | "success" | "danger";
  readonly steps: readonly ComplaintProgressStep[];
  readonly bookingCode: string;
  readonly routeText: string;
  readonly category: string;
  readonly noticeWarningText?: string;
  readonly messages: readonly ComplaintMessage[];
}

/**
 * Dữ liệu trang Khiếu nại của tôi (SCR-PSG-30).
 */
export interface MyComplaintsData {
  readonly activeComplaints: readonly ComplaintListItem[];
  readonly closedComplaints: readonly ComplaintListItem[];
  readonly selectedComplaint: ComplaintDetailData;
}

/**
 * Dữ liệu gửi khiếu nại mới (SCR-PSG-31).
 */
export interface NewComplaintPayload {
  readonly bookingCode: string;
  readonly category: string;
  readonly suggestedSeverity?: string;
  readonly title: string;
  readonly content: string;
  readonly attachmentFileNames?: readonly string[];
}

/**
 * Dữ liệu form khiếu nại cho khách vãng lai (SCR-PSG-32).
 */
/**
 * Dữ liệu form khiếu nại cho khách vãng lai (SCR-PSG-32).
 */
export interface GuestComplaintFormData {
  readonly bookingCode: string;
  readonly email: string;
  readonly category: string;
  readonly title: string;
  readonly content: string;
  readonly attachmentFileNames?: readonly string[];
}

/**
 * Dữ liệu trang khiếu nại của khách vãng lai (SCR-PSG-32).
 */
export interface GuestSupportData {
  readonly session: {
    readonly maskedEmail: string;
    readonly bookingCode: string;
    readonly expiresInSeconds: number;
  };
  readonly complaints: MyComplaintsData;
}

/**
 * Thông tin hồ sơ người dùng (SCR-PSG-11).
 */
export interface UserProfileData {
  readonly id: string;
  readonly fullName: string;
  readonly email: string;
  readonly emailVerified?: boolean;
  readonly phone: string;
  readonly dateOfBirth?: string;
  readonly gender?: string;
  readonly idNumber?: string;
  readonly avatarUrl?: string;
  readonly tierName?: string;
  readonly points?: number;
  readonly periodPoints?: number;
  readonly pointsNeededNextTier?: number;
  readonly nextTierName?: string;
  readonly voucherCount?: number;
  readonly ticketsCount?: number;
  readonly savedPassengers?: readonly {
    readonly id: string;
    readonly name: string;
    readonly phone: string;
    readonly idNumber: string;
    readonly isSelf: boolean;
  }[];
  readonly securityMethods?: {
    readonly email: string;
    readonly googleLinked: boolean;
    readonly googleLinkedDate?: string;
    readonly facebookLinked: boolean;
    readonly appleLinked: boolean;
    readonly activeSessionsCount: number;
  };
}

/**
 * Cấu hình một mục thông báo (SCR-PSG-12).
 */
export interface NotificationSettingItem {
  readonly id: string;
  readonly title: string;
  readonly description: string;
  readonly isMandatory: boolean;
  readonly emailEnabled: boolean;
  readonly pushEnabled: boolean;
}

/**
 * Toàn bộ cấu hình cài đặt thông báo của người dùng (SCR-PSG-12).
 */
export interface NotificationSettingsData {
  readonly mandatoryItems: readonly NotificationSettingItem[];
  readonly optionalItems: readonly NotificationSettingItem[];
}

/**
 * Mục thông báo người dùng (SCR-PSG-12).
 */
export interface UserNotificationItem {
  readonly id: string;
  readonly title: string;
  readonly content: string;
  readonly createdAtText: string;
  readonly isRead: boolean;
  readonly category: "booking" | "promo" | "system";
}

/**
 * Phiên đăng nhập của tài khoản (SCR-PSG-13).
 */
export interface UserSessionItem {
  readonly id: string;
  readonly deviceName: string;
  readonly deviceType?: "desktop" | "mobile";
  readonly ipAddress: string;
  readonly locationText: string;
  readonly loginDateText?: string;
  readonly lastActiveText: string;
  readonly isCurrent: boolean;
}

/**
 * Đánh giá chuyến xe của người dùng (SCR-PSG-14).
 */
export interface UserReviewItem {
  readonly id: string;
  readonly operatorName: string;
  readonly routeName: string;
  readonly reviewedDateText: string;
  readonly rating: number;
  readonly content: string;
  readonly statusLabel: "Đang hiển thị" | "Đang kiểm duyệt" | "Đã duyệt" | "Đã ẩn";
}

/**
 * Mục chuyến xe đang chờ đánh giá (SCR-PSG-14).
 */
export interface PendingReviewTrip {
  readonly bookingId?: string;
  readonly tripId: string;
  readonly operatorName: string;
  readonly routeName: string;
  readonly completedDateText: string;
  readonly bookingCode: string;
  readonly initialRating?: number;
  readonly initialComment?: string;
}

/**
 * Dữ liệu trang đánh giá chuyến xe của tôi (SCR-PSG-14).
 */
export interface UserReviewsData {
  readonly pendingTrips: readonly PendingReviewTrip[];
  readonly completedReviews: readonly UserReviewItem[];
}

/**
 * Mã phân hạng thành viên VXN Plus.
 */
export type LoyaltyTierCode = "bronze" | "silver" | "gold" | "platinum";

/**
 * Hàng thông tin hạng trong bảng hạng thành viên (SCR-PSG-33).
 */
export interface LoyaltyTierInfo {
  readonly code: LoyaltyTierCode;
  readonly name: string;
  readonly minPoints12mText: string;
  readonly multiplierText: string;
  readonly isCurrent: boolean;
}

/**
 * Dữ liệu hồ sơ thành viên VXN Plus (SCR-PSG-33 - node 1448:19617).
 */
export interface LoyaltyProfile {
  readonly currentTier: LoyaltyTierCode;
  readonly currentTierName: string;
  readonly multiplierText: string;
  readonly pointsIn12Months: number;
  readonly targetPointsForNextTier: number;
  readonly pointsRequiredForNextTier: number;
  readonly nextTierName: string;
  readonly nextTierMultiplierText: string;
  readonly availablePoints: number;
  readonly estimatedVoucherVnd: string;
  readonly tiers: readonly LoyaltyTierInfo[];
}

/**
 * Báo giá / thông tin quy đổi điểm lấy voucher (SCR-PSG-35 - node 1448:20406).
 */
export interface LoyaltyRedemptionQuote {
  readonly pointsToRedeem: number;
  readonly voucherValueVnd: string;
  readonly remainingPoints: number;
  readonly expiryDaysText: string;
  readonly expiryDateText: string;
}

/**
 * Loại biến động điểm thưởng (SCR-PSG-34).
 */
export type LoyaltyTransactionType = "earn" | "redeem" | "expire" | "revoke" | "adjust";

/**
 * Một giao dịch biến động điểm trong lịch sử (SCR-PSG-34 - node 1448:19985).
 */
export interface LoyaltyTransaction {
  readonly id: string;
  readonly dateText: string;
  readonly type: LoyaltyTransactionType;
  readonly typeLabel: string;
  readonly sourceText: string;
  readonly pointsChange: number;
}

/**
 * Dữ liệu trang Lịch sử điểm (SCR-PSG-34).
 */
export interface LoyaltyHistoryData {
  readonly availablePoints: number;
  readonly totalEarnedPoints: number;
  readonly totalRedeemedPoints: number;
  readonly totalExpiredPoints: number;
  readonly transactions: readonly LoyaltyTransaction[];
  readonly totalCount: number;
  readonly pageIndex: number;
  readonly pageSize: number;
}

/**
 * Loại voucher trong ví (SCR-PSG-36).
 */
export type UserVoucherType = "loyalty_redemption" | "public_code";

/**
 * Trạng thái voucher (SCR-PSG-36).
 */
export type UserVoucherStatus = "available" | "holding" | "used" | "expired";

/**
 * Một voucher trong ví (SCR-PSG-36 - node 1448:20565).
 */
export interface UserVoucherItem {
  readonly discountLabel?: string;
  readonly id: string;
  readonly code: string;
  readonly title: string;
  readonly type: UserVoucherType;
  readonly typeLabel: "Đổi điểm" | "Mã đã lưu";
  readonly status: UserVoucherStatus;
  readonly statusLabel: "Khả dụng" | "Sắp hết hạn" | "Đang giữ" | "Đã dùng" | "Hết hạn";
  readonly scopeText: string;
  readonly expiryDateText: string;
  readonly discountValueVnd?: string;
  readonly holdingNote?: string;
}

/**
 * Dữ liệu trang Ví voucher (SCR-PSG-36).
 */
export interface UserVouchersData {
  readonly holdingCount?: number;
  readonly availableCount: number;
  readonly usedCount: number;
  readonly expiredCount: number;
  readonly vouchers: readonly UserVoucherItem[];
}

/**
 * Chuyên mục bài viết cẩm nang (SCR-PSG-02).
 */
export interface ArticleCategory {
  readonly id: string;
  readonly slug: string;
  readonly name: string;
  readonly count: number;
}

/**
 * Tóm tắt một bài viết cẩm nang / khám phá (SCR-PSG-02 - node 1449:20595).
 */
export interface ArticleSummary {
  readonly id: string;
  readonly slug: string;
  readonly title: string;
  readonly excerpt: string;
  readonly category: string;
  readonly categorySlug: string;
  readonly publishedDateText: string;
  readonly readingTimeMinutes?: number;
  readonly viewsCountText: string;
  readonly coverImageUrl: string;
  readonly isFeatured?: boolean;
}

/**
 * Một phần nội dung của bài viết (SCR-PSG-37).
 */
export interface ArticleSection {
  readonly heading: string;
  readonly content: string;
  readonly tips?: readonly string[];
}

/**
 * Chi tiết bài viết cẩm nang (SCR-PSG-37 - node 1449:20924).
 */
export interface ArticleDetail extends ArticleSummary {
  readonly authorName: string;
  readonly leadParagraph: string;
  readonly sections: readonly ArticleSection[];
  readonly relatedRoute?: {
    readonly name: string;
    readonly frequencyText: string;
    readonly fromPriceVnd: string;
    readonly searchHref: string;
  };
  readonly relatedArticles: readonly {
    readonly id: string;
    readonly title: string;
    readonly slug: string;
    readonly publishedDateText: string;
    readonly coverImageUrl?: string;
  }[];
}

/**
 * Một câu hỏi trong trang FAQ (SCR-PSG-03 - node 1449:21249).
 */
export interface FaqQuestionItem {
  readonly id: string;
  readonly question: string;
  readonly answer: string;
}

/**
 * Nhóm chuyên mục câu hỏi thường gặp FAQ.
 */
export interface FaqGroup {
  readonly id: string;
  readonly title: string;
  readonly count: number;
  readonly questions: readonly FaqQuestionItem[];
}

/**
 * Mục trong bảng mục lục trang pháp lý (SCR-PSG-06 - node 1449:22136).
 */
export interface LegalTocItem {
  readonly id: string;
  readonly title: string;
}

/**
 * Một điều khoản / mục trong văn bản pháp lý.
 */
export interface LegalSectionItem {
  readonly id: string;
  readonly title: string;
  readonly paragraphs: readonly string[];
}

/**
 * Tài liệu pháp lý hoàn chỉnh (Điều khoản sử dụng / Chính sách bảo mật / Hoàn tiền).
 */
export interface LegalDocumentData {
  readonly slug: string;
  readonly title: string;
  readonly effectiveDateText: string;
  readonly lastUpdatedText: string;
  readonly noteText: string;
  readonly tableOfContents: readonly LegalTocItem[];
  readonly sections: readonly LegalSectionItem[];
}



