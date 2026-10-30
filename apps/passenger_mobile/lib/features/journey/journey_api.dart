import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/journey/journey_models.dart';

/// Lời gọi API của tab Hành trình: tra cứu vé khách vãng lai, "Vé của tôi", chi tiết đơn và hủy vé.
///
/// Khách vãng lai gửi [accessToken] (header `X-Booking-Token`) cấp sau khi xác minh OTP; hành khách
/// đăng nhập không cần. Lỗi API ném ra dạng [ApiFailure].
class JourneyApi {
  JourneyApi(this._client);

  final ApiClientDart _client;

  /// Gửi mã xác minh tới email liên hệ (phản hồi như nhau dù email có đơn hay không).
  Future<JourneyLookupOtp> requestLookupOtp(String email) async {
    final response = await _call(
      () => _client.getTicketsApi().ticketControllerRequestOtp(
        ticketLookupOtpInputDto: TicketLookupOtpInputDto(
          (b) => b..email = email,
        ),
      ),
    );
    final data = response.data!;
    return JourneyLookupOtp(
      maskedEmail: data.maskedEmail,
      expiresInSeconds: data.expiresInSeconds,
      resendAfterSeconds: data.resendAfterSeconds,
    );
  }

  /// Xác minh mã; trả bí mật của phiên tra cứu (chỉ giữ trong bộ nhớ).
  Future<String> verifyLookupOtp(String email, String otp) async {
    final response = await _call(
      () => _client.getTicketsApi().ticketControllerVerifyOtp(
        ticketLookupVerifyInputDto: TicketLookupVerifyInputDto(
          (b) => b
            ..email = email
            ..otp = otp,
        ),
      ),
    );
    return response.data!.lookupToken;
  }

  /// Các đơn của email đã xác minh, mới nhất trước.
  Future<JourneyLookupResult> listLookupBookings(String lookupToken) async {
    final response = await _call(
      () => _client.getTicketsApi().ticketControllerListBookings(
        ticketLookupSessionInputDto: TicketLookupSessionInputDto(
          (b) => b..lookupToken = lookupToken,
        ),
      ),
    );
    final data = response.data!;
    return JourneyLookupResult(
      maskedEmail: data.maskedEmail,
      hasAccount: data.hasAccount,
      bookings: [
        for (final item in data.items)
          JourneyBookingSummary(
            bookingId: item.bookingId,
            bookingCode: item.bookingCode,
            status: item.status.name,
            routeName: item.routeName,
            operatorName: item.operatorName,
            departureAt: item.departureAt,
            total: item.total,
            ticketCount: item.ticketCount,
            bookedWithAccount: item.bookedWithAccount,
          ),
      ],
    );
  }

  /// Mã truy cập một đơn trong phiên tra cứu (xem / hủy vé).
  Future<String> grantLookupAccess(String lookupToken, String bookingId) async {
    final response = await _call(
      () => _client.getTicketsApi().ticketControllerGrantBookingAccess(
        ticketLookupInputDto: TicketLookupInputDto(
          (b) => b
            ..lookupToken = lookupToken
            ..bookingId = bookingId,
        ),
      ),
    );
    return response.data!.accessToken;
  }

  /// Các đơn của tài khoản đang đăng nhập, mới nhất trước.
  Future<List<JourneyBookingSummary>> listMyBookings() async {
    final response = await _call(
      () => _client.getPassengerProfileApi().passengerProfileControllerBookings(
        limit: 50,
      ),
    );
    return [
      for (final item in response.data!.items)
        JourneyBookingSummary(
          bookingId: item.bookingId,
          bookingCode: item.bookingCode,
          status: item.status,
          routeName: item.routeName,
          operatorName: item.operatorName,
          departureAt: item.departureAt,
          total: int.parse(item.total),
          bookedWithAccount: true,
        ),
    ];
  }

  /// Chi tiết đơn kèm vé điện tử.
  Future<JourneyBooking> loadBooking(
    String bookingId, {
    String? accessToken,
  }) async {
    final response = await _call(
      () => _client.getBookingsApi().bookingControllerGet(
        bookingId: bookingId,
        xBookingToken: accessToken,
      ),
    );
    final data = response.data!;
    final seatTypes = {
      for (final passenger in data.passengers)
        passenger.seatCode: passenger.seatType.name,
    };
    final prices = {
      for (final passenger in data.passengers)
        passenger.seatCode: passenger.price,
    };
    JourneyStop stop(TripSearchResponseDtoOutputItemsInnerPickup point) =>
        JourneyStop(
          name: point.name,
          address: point.address,
          plannedAt: point.plannedAt,
        );
    return JourneyBooking(
      bookingId: data.bookingId,
      bookingCode: data.bookingCode,
      status: data.status.name,
      routeName: data.trip.routeName,
      operatorName: data.trip.operatorName,
      operatorHotline: data.trip.operatorHotline,
      vehicleTypeName: data.trip.vehicleTypeName,
      departureAt: data.trip.departureAt,
      pickup: stop(data.pickup),
      dropoff: stop(data.dropoff),
      contactEmail: data.contact.email,
      subtotal: data.subtotal,
      serviceFee: data.serviceFee,
      discount: data.discount,
      total: data.total,
      tiers: [
        for (final tier in data.cancellationPolicy.tiers)
          JourneyRefundTier(
            minHoursBefore: tier.minHoursBefore,
            refundPercent: tier.refundPercent,
          ),
      ],
      tickets: [
        for (final ticket in data.tickets)
          JourneyTicket(
            ticketId: ticket.ticketId,
            ticketCode: ticket.ticketCode,
            seatCode: ticket.seatCode,
            passengerName: ticket.passengerName,
            companionName: ticket.companionName,
            status: ticket.status.name,
            qrToken: ticket.qrToken,
            seatType: seatTypes[ticket.seatCode],
            price: prices[ticket.seatCode],
          ),
      ],
      refunds: [
        for (final refund in data.refunds)
          JourneyRefund(
            refundCode: refund.refundCode,
            amount: refund.amount,
            status: refund.status.name,
          ),
      ],
      paymentProvider: data.payment?.provider.name,
      paymentCode: data.payment?.paymentCode,
      paymentStatus: data.payment?.status.name,
    );
  }

  /// Điều kiện hủy (mốc hoàn đang áp dụng, số tiền hoàn) của các vé đã chọn.
  Future<JourneyCancellationQuote> quoteCancellation(
    String bookingId,
    List<String> ticketIds, {
    String? accessToken,
  }) async {
    final response = await _call(
      () => _client.getCancellationsApi().cancellationControllerQuote(
        bookingId: bookingId,
        ticketIds: ticketIds.join(','),
        xBookingToken: accessToken,
      ),
    );
    final data = response.data!;
    final blocked = data.tickets
        .where((ticket) => ticketIds.contains(ticket.ticketId))
        .where((ticket) => !ticket.cancellable)
        .map(
          (ticket) => ticket.reason ?? 'Vé ${ticket.seatCode} không hủy được.',
        )
        .firstOrNull;
    return JourneyCancellationQuote(
      refundPercent: data.refundPercent,
      selectedTotal: data.selectedTotal,
      refundAmount: data.refundAmount,
      nonRefundable: data.nonRefundable,
      blockedReason: blocked,
    );
  }

  /// Hủy các vé đã chọn; [expectedRefund] là số khách đã thấy ở bước xem điều kiện.
  Future<JourneyCancellation> cancel(
    String bookingId,
    List<String> ticketIds, {
    required int expectedRefund,
    String? reason,
    String? accessToken,
  }) async {
    final response = await _call(
      () => _client.getCancellationsApi().cancellationControllerCancel(
        bookingId: bookingId,
        xBookingToken: accessToken,
        cancellationInputDto: CancellationInputDto(
          (b) => b
            ..ticketIds.replace(ticketIds)
            ..expectedRefund = expectedRefund
            ..reason = reason,
        ),
      ),
    );
    final refund = response.data!.refund;
    return JourneyCancellation(
      refundAmount: refund?.amount ?? 0,
      refundCode: refund?.refundCode,
    );
  }

  Future<T> _call<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (error) {
      throw toApiFailure(error, _client.serializers);
    }
  }
}

/// Câu tiếng Việt cho lỗi của tab Hành trình.
String describeJourneyFailure(Object error) {
  if (error is! ApiFailure) return 'Đã xảy ra lỗi. Vui lòng thử lại.';
  if (error.isNetworkError) {
    return 'Không thể kết nối máy chủ. Vui lòng kiểm tra mạng và thử lại.';
  }
  return switch (error.code) {
    'TICKET_LOOKUP_OTP_INVALID' =>
      'Mã xác minh không đúng hoặc đã hết hạn. Vui lòng kiểm tra lại.',
    'TICKET_LOOKUP_RATE_LIMITED' =>
      'Bạn thao tác quá nhiều lần. Vui lòng thử lại sau ít phút.',
    'TICKET_LOOKUP_EXPIRED' =>
      'Phiên tra cứu đã hết hạn. Vui lòng tra cứu lại.',
    'BOOKING_REQUIRES_LOGIN' =>
      'Đơn này đặt bằng tài khoản. Vui lòng đăng nhập để xem và hủy vé.',
    'REFUND_AMOUNT_CHANGED' =>
      'Số tiền hoàn vừa thay đổi do qua mốc hủy. Vui lòng xem lại.',
    _ => error.detail,
  };
}
