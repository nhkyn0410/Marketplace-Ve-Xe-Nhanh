/// Phương thức thanh toán online được mở trong ứng dụng hành khách.
enum PassengerPaymentMethod {
  payos('PAYOS', 'Chuyển khoản VietQR qua payOS'),
  momo('MOMO', 'Ví MoMo'),
  vnpay('VNPAY', 'VNPay'),
  demo('DEMO', 'Cổng thanh toán thử (demo)');

  const PassengerPaymentMethod(this.apiValue, this.label);

  final String apiValue;
  final String label;

  /// Nội dung giải thích ngắn cho phương thức khách có thể chọn.
  String get description => switch (this) {
    payos => 'Quét mã VietQR hoặc chuyển khoản bằng ứng dụng ngân hàng.',
    momo => 'Thanh toán qua ứng dụng hoặc trang thanh toán MoMo.',
    vnpay => 'Thanh toán qua VNPay-QR, tài khoản hoặc thẻ được cổng hỗ trợ.',
    demo => 'Mô phỏng thanh toán, không chuyển tiền thật.',
  };

  /// Tên nút mở lại đúng cổng khi khách quay về ứng dụng.
  String get openLabel => switch (this) {
    payos => 'Mở trang payOS',
    momo => 'Mở MoMo',
    vnpay => 'Mở VNPay',
    demo => 'Mở cổng thanh toán thử',
  };

  /// Logo cổng đã có trong bộ tài nguyên của ứng dụng.
  String? get logoAsset => switch (this) {
    momo => 'assets/ticket/payment/payment_momo_figma.png',
    vnpay => 'assets/ticket/payment/payment_vnpay_figma.png',
    _ => null,
  };
}

/// Thông tin chuyển khoản đã được backend xác minh từ payOS.
class PaymentTransfer {
  const PaymentTransfer({
    required this.qrCode,
    required this.bin,
    required this.accountNumber,
    required this.accountName,
    required this.amount,
    required this.description,
  });

  final String qrCode;
  final String bin;
  final String accountNumber;
  final String accountName;
  final String amount;
  final String description;
}

/// Link thanh toán của một lần thanh toán; hạn dùng không vượt quá hạn booking.
class BookingPaymentSession {
  const BookingPaymentSession({
    required this.paymentId,
    required this.paymentUrl,
    required this.expiresAt,
    this.transfer,
  });

  final String paymentId;
  final Uri paymentUrl;
  final DateTime expiresAt;
  final PaymentTransfer? transfer;
}

/// Vé do máy chủ phát hành sau khi xác nhận đã nhận tiền.
class IssuedBookingTicket {
  const IssuedBookingTicket({
    required this.ticketCode,
    required this.seatCode,
    required this.passengerName,
    required this.qrToken,
    this.companionName,
  });

  final String ticketCode;
  final String seatCode;
  final String passengerName;
  final String qrToken;
  final String? companionName;
}

/// Trạng thái thanh toán và vé mới nhất, chỉ lấy từ API booking.
class BookingPaymentState {
  const BookingPaymentState({
    required this.bookingStatus,
    this.paymentStatus,
    this.tickets = const [],
  });

  final String bookingStatus;
  final String? paymentStatus;
  final List<IssuedBookingTicket> tickets;

  /// Chỉ mở màn hoàn tất khi backend đã nhận tiền và phát hành vé.
  bool get isConfirmed =>
      bookingStatus == 'CONFIRMED' &&
      paymentStatus == 'SUCCESS' &&
      tickets.isNotEmpty;

  /// Thanh toán cần nhân viên đối soát, không được hướng dẫn khách trả lần nữa.
  bool get needsReconciliation => paymentStatus == 'RECONCILING';

  /// Đơn không còn nhận thanh toán online.
  bool get isClosed => const {
    'EXPIRED',
    'CANCELLED',
    'REFUND_PENDING',
    'REFUNDED',
    'REFUND_FAILED',
  }.contains(bookingStatus);
}
