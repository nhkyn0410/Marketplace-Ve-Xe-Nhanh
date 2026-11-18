/// Mã đơn trong App Link mà cổng thanh toán đưa khách quay về app
/// (`https://{web}/app/bookings/{bookingId}/payment/result`, PASSENGER-PARITY A25/P4).
///
/// Chỉ lấy mã đơn để mở lại đơn; không đọc kết quả cổng gửi kèm trên URL — trạng thái luôn hỏi lại máy chủ.
/// Link khác dạng → `null`.
String? paymentReturnBookingId(Uri link) {
  if (link.scheme != 'https' || link.host.isEmpty || link.userInfo.isNotEmpty) {
    return null;
  }
  final segments = link.pathSegments;
  if (segments.length != 5 ||
      segments[0] != 'app' ||
      segments[1] != 'bookings' ||
      segments[3] != 'payment' ||
      segments[4] != 'result') {
    return null;
  }
  final bookingId = segments[2];
  return RegExp(r'^[0-9a-fA-F-]{36}$').hasMatch(bookingId) ? bookingId : null;
}
