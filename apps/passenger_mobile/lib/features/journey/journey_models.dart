/// Một đơn trong danh sách "Vé của tôi" / kết quả tra cứu vé.
class JourneyBookingSummary {
  const JourneyBookingSummary({
    required this.bookingId,
    required this.bookingCode,
    required this.status,
    required this.routeName,
    required this.operatorName,
    required this.departureAt,
    required this.total,
    this.ticketCount,
    this.bookedWithAccount = false,
  });

  final String bookingId;
  final String bookingCode;

  /// Trạng thái booking như API (`CONFIRMED`, `PENDING_PAYMENT`, `CANCELLED`, …).
  final String status;
  final String routeName;
  final String operatorName;
  final DateTime departureAt;

  /// VND.
  final int total;

  /// `null` khi API không trả (danh sách của tài khoản).
  final int? ticketCount;

  /// Đơn đặt bằng tài khoản: khách vãng lai phải đăng nhập mới xem / hủy được.
  final bool bookedWithAccount;
}

/// Điểm đón / trả của đơn.
class JourneyStop {
  const JourneyStop({
    required this.name,
    required this.address,
    required this.plannedAt,
  });

  final String name;
  final String address;
  final DateTime plannedAt;
}

/// Vé điện tử của một chỗ.
class JourneyTicket {
  const JourneyTicket({
    required this.ticketId,
    required this.ticketCode,
    required this.seatCode,
    required this.passengerName,
    required this.status,
    required this.qrToken,
    this.companionName,
    this.seatType,
    this.price,
  });

  final String ticketId;
  final String ticketCode;
  final String seatCode;
  final String passengerName;
  final String? companionName;

  /// `VALID`, `CHECKED_IN`, `CANCELLED`, …
  final String status;

  /// Nội dung mã QR (nhân viên soát vé xác thực ở máy chủ).
  final String qrToken;

  /// Loại chỗ như API (`SEAT`, `BED`, …); `null` nếu không khớp hành khách.
  final String? seatType;

  /// VND — giá chỗ lúc đặt.
  final int? price;

  bool get isCancelled => status == 'CANCELLED' || status == 'REFUNDED';
}

/// Mốc hủy / hoàn đã chụp lúc đặt.
class JourneyRefundTier {
  const JourneyRefundTier({
    required this.minHoursBefore,
    required this.refundPercent,
  });

  final int minHoursBefore;
  final int refundPercent;
}

/// Lần hoàn tiền của đơn.
class JourneyRefund {
  const JourneyRefund({
    required this.refundCode,
    required this.amount,
    required this.status,
  });

  final String refundCode;
  final int amount;
  final String status;
}

/// Chi tiết một đơn (`GET /bookings/{id}`).
class JourneyBooking {
  const JourneyBooking({
    required this.bookingId,
    required this.bookingCode,
    required this.status,
    required this.routeName,
    required this.operatorName,
    required this.vehicleTypeName,
    required this.departureAt,
    required this.pickup,
    required this.dropoff,
    required this.contactEmail,
    required this.subtotal,
    required this.serviceFee,
    required this.discount,
    required this.total,
    required this.tiers,
    required this.tickets,
    required this.refunds,
    this.operatorHotline,
    this.paymentProvider,
    this.paymentCode,
    this.paymentStatus,
  });

  final String bookingId;
  final String bookingCode;
  final String status;
  final String routeName;
  final String operatorName;
  final String? operatorHotline;
  final String vehicleTypeName;
  final DateTime departureAt;
  final JourneyStop pickup;
  final JourneyStop dropoff;
  final String contactEmail;

  /// VND.
  final int subtotal;
  final int serviceFee;
  final int discount;
  final int total;
  final List<JourneyRefundTier> tiers;
  final List<JourneyTicket> tickets;
  final List<JourneyRefund> refunds;

  /// `VNPAY`, `MOMO`, …; `null` = chưa thanh toán.
  final String? paymentProvider;
  final String? paymentCode;
  final String? paymentStatus;

  bool get hasActiveTickets => tickets.any((ticket) => !ticket.isCancelled);
}

/// Điều kiện hủy các vé đã chọn (`GET /bookings/{id}/cancellation-quote`).
class JourneyCancellationQuote {
  const JourneyCancellationQuote({
    required this.refundPercent,
    required this.selectedTotal,
    required this.refundAmount,
    required this.nonRefundable,
    required this.blockedReason,
  });

  final int refundPercent;
  final int selectedTotal;
  final int refundAmount;
  final int nonRefundable;

  /// Lý do không hủy được (vé đầu tiên bị chặn); `null` = hủy được.
  final String? blockedReason;
}

/// Kết quả hủy vé.
class JourneyCancellation {
  const JourneyCancellation({required this.refundAmount, this.refundCode});

  /// VND; 0 khi đã qua mọi mốc hoàn.
  final int refundAmount;
  final String? refundCode;
}

/// Phản hồi bước gửi mã tra cứu.
class JourneyLookupOtp {
  const JourneyLookupOtp({
    required this.maskedEmail,
    required this.expiresInSeconds,
    required this.resendAfterSeconds,
  });

  final String maskedEmail;
  final int expiresInSeconds;
  final int resendAfterSeconds;
}

/// Đơn tìm được của phiên tra cứu khách vãng lai.
class JourneyLookupResult {
  const JourneyLookupResult({
    required this.maskedEmail,
    required this.hasAccount,
    required this.bookings,
  });

  final String maskedEmail;

  /// Email đã có tài khoản hành khách — gợi ý đăng nhập.
  final bool hasAccount;
  final List<JourneyBookingSummary> bookings;
}

/// "Thứ Sáu · 16/10/2026" theo giờ máy.
String journeyLongDate(DateTime value) {
  const weekdays = [
    'Thứ Hai',
    'Thứ Ba',
    'Thứ Tư',
    'Thứ Năm',
    'Thứ Sáu',
    'Thứ Bảy',
    'Chủ Nhật',
  ];
  final local = value.toLocal();
  return '${weekdays[local.weekday - 1]} · ${journeyDate(local)}';
}

/// "16/10/2026".
String journeyDate(DateTime value) {
  final local = value.toLocal();
  return '${local.day.toString().padLeft(2, '0')}/'
      '${local.month.toString().padLeft(2, '0')}/${local.year}';
}

/// "22:30".
String journeyTime(DateTime value) {
  final local = value.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}

/// "560.000đ"; số âm có dấu "-".
String journeyVnd(int value) {
  final digits = value.abs().toString();
  final chunks = <String>[];
  for (var end = digits.length; end > 0; end -= 3) {
    chunks.add(digits.substring(end - 3 < 0 ? 0 : end - 3, end));
  }
  return '${value < 0 ? '-' : ''}${chunks.reversed.join('.')}đ';
}

/// Nhãn trạng thái đơn cho hành khách.
String journeyBookingStatusLabel(String status) => switch (status) {
  'CONFIRMED' || 'PAID' => 'Hợp lệ',
  'PENDING_PAYMENT' => 'Chờ thanh toán',
  'PENDING_CONFIRMATION' => 'Chờ xác nhận',
  'PARTIALLY_CANCELLED' => 'Hủy một phần',
  'CANCELLED' => 'Đã hủy',
  'EXPIRED' => 'Hết hạn thanh toán',
  'REFUND_PENDING' => 'Đang hoàn tiền',
  'REFUNDED' => 'Đã hoàn tiền',
  'REFUND_FAILED' => 'Hoàn tiền lỗi',
  _ => status,
};

/// Nhãn loại chỗ.
String journeySeatTypeLabel(String? seatType) => switch (seatType) {
  'SEAT' => 'Ghế ngồi',
  'BED' => 'Giường đơn',
  'BED_DOUBLE' => 'Giường đôi',
  'CABIN' => 'Cabin đơn',
  'CABIN_DOUBLE' => 'Cabin đôi',
  _ => 'Chỗ',
};

/// Tên cổng thanh toán.
String journeyProviderLabel(String? provider) => switch (provider) {
  'VNPAY' => 'VNPay',
  'MOMO' => 'MoMo',
  null => 'Chưa thanh toán',
  _ => provider,
};

/// Nhãn trạng thái hoàn tiền.
String journeyRefundStatusLabel(String status) => switch (status) {
  'REQUESTED' || 'APPROVED' || 'PROCESSING' => 'Đang xử lý',
  'SUCCESS' => 'Đã hoàn',
  'FAILED' => 'Hoàn tiền lỗi — đang hỗ trợ',
  'REJECTED' => 'Từ chối hoàn',
  _ => status,
};
