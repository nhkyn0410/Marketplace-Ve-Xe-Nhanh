/// Người liên hệ của đơn (nhận email vé, nhà xe gọi khi cần).
class BookingContact {
  const BookingContact({
    required this.fullName,
    required this.phone,
    required this.email,
  });

  final String fullName;
  final String phone;
  final String email;
}

/// Hành khách ngồi ở một chỗ đã giữ.
class BookingPassenger {
  const BookingPassenger({
    required this.seatCode,
    required this.fullName,
    this.phone,
  });

  final String seatCode;
  final String fullName;
  final String? phone;
}

/// Hành khách đã lưu trong tài khoản, chọn nhanh khi điền form.
class SavedTraveller {
  const SavedTraveller({required this.fullName, this.phone});

  final String fullName;
  final String? phone;
}

/// Dữ liệu điền sẵn cho khách đã đăng nhập: hồ sơ + hành khách đã lưu.
class BookingPrefill {
  const BookingPrefill({required this.contact, required this.travellers});

  final BookingContact contact;
  final List<SavedTraveller> travellers;
}

/// Kết quả kiểm tra mã khuyến mãi cho chuyến + tiền vé (`POST /promotions/check`).
class PromotionQuote {
  const PromotionQuote({
    required this.code,
    required this.name,
    required this.discount,
    required this.total,
  });

  final String code;
  final String name;

  /// VND được giảm.
  final int discount;

  /// VND phải trả sau giảm.
  final int total;
}

/// Thông tin khách nhập ở bước 2, mang sang bước xác nhận.
class BookingDraft {
  const BookingDraft({
    required this.contact,
    required this.passengers,
    this.promotion,
  });

  final BookingContact contact;
  final List<BookingPassenger> passengers;
  final PromotionQuote? promotion;
}

/// Hành khách trên đơn đã tạo, kèm giá chỗ.
class BookedPassenger {
  const BookedPassenger({
    required this.seatCode,
    required this.fullName,
    required this.price,
  });

  final String seatCode;
  final String fullName;
  final int price;
}

/// Đơn vừa tạo (`POST /bookings`), đang chờ thanh toán tới [expiresAt].
class CreatedBooking {
  const CreatedBooking({
    required this.bookingId,
    required this.bookingCode,
    required this.status,
    required this.routeName,
    required this.operatorName,
    required this.vehicleTypeName,
    required this.pickupName,
    required this.pickupAt,
    required this.dropoffName,
    required this.dropoffAt,
    required this.contact,
    required this.passengers,
    required this.subtotal,
    required this.serviceFee,
    required this.discount,
    required this.total,
    required this.expiresAt,
    required this.accessToken,
  });

  final String bookingId;

  /// Mã đơn khách dùng để tra cứu.
  final String bookingCode;
  final String status;
  final String routeName;
  final String operatorName;
  final String vehicleTypeName;
  final String pickupName;
  final DateTime pickupAt;
  final String dropoffName;
  final DateTime dropoffAt;
  final BookingContact contact;
  final List<BookedPassenger> passengers;
  final int subtotal;
  final int serviceFee;
  final int discount;
  final int total;

  /// Hạn thanh toán; quá hạn đơn thành `EXPIRED` và chỗ được trả lại.
  final DateTime expiresAt;

  /// Mã truy cập đơn cho khách vãng lai (header `X-Booking-Token`); chỉ trả một lần.
  final String accessToken;
}
