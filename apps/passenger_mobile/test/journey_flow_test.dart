import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/journey/guest_journey_flow.dart';
import 'package:passenger_mobile/features/journey/guest_ticket_detail_screen.dart';
import 'package:passenger_mobile/features/journey/journey_api.dart';
import 'package:passenger_mobile/features/journey/journey_models.dart';
import 'package:passenger_mobile/features/journey/journey_ticket_filters.dart';

JourneyBooking _booking({
  bool cancelled = false,
  String bookingId = 'b-1',
  String bookingCode = 'VXN-TEST01',
  String routeName = 'TP. Hồ Chí Minh → Đà Lạt',
  String pickupName = 'Bến xe Miền Đông mới',
  String pickupAddress = '501 Hoàng Hữu Nam',
}) => JourneyBooking(
  bookingId: bookingId,
  bookingCode: bookingCode,
  status: cancelled ? 'CANCELLED' : 'CONFIRMED',
  routeName: routeName,
  operatorName: 'Nhà xe Sao Mai',
  vehicleTypeName: 'Giường nằm 34 chỗ',
  departureAt: DateTime.now().add(const Duration(days: 3)),
  pickup: JourneyStop(
    name: pickupName,
    address: pickupAddress,
    plannedAt: DateTime.now().add(const Duration(days: 3)),
  ),
  dropoff: JourneyStop(
    name: 'Bến xe liên tỉnh Đà Lạt',
    address: '01 Tô Hiến Thành',
    plannedAt: DateTime.now().add(const Duration(days: 3, hours: 7)),
  ),
  contactEmail: 'khach@example.com',
  subtotal: 300000,
  serviceFee: 0,
  discount: 0,
  total: 300000,
  tiers: const [
    JourneyRefundTier(minHoursBefore: 24, refundPercent: 90),
    JourneyRefundTier(minHoursBefore: 4, refundPercent: 50),
  ],
  tickets: [
    JourneyTicket(
      ticketId: 't-1',
      ticketCode: 'VXN-TEST01-01',
      seatCode: 'A3',
      passengerName: 'Nguyễn An',
      status: cancelled ? 'CANCELLED' : 'VALID',
      qrToken: 'qr-token-1',
      seatType: 'BED',
      price: 300000,
    ),
  ],
  refunds: cancelled
      ? const [
          JourneyRefund(
            refundCode: 'RF-1',
            amount: 270000,
            status: 'REQUESTED',
          ),
        ]
      : const [],
  paymentProvider: 'VNPAY',
  paymentCode: 'PAY-1',
  paymentStatus: 'SUCCESS',
);

final _summary = JourneyBookingSummary(
  bookingId: 'b-1',
  bookingCode: 'VXN-TEST01',
  status: 'CONFIRMED',
  routeName: 'TP. Hồ Chí Minh → Đà Lạt',
  operatorName: 'Nhà xe Sao Mai',
  departureAt: DateTime.now().add(const Duration(days: 3)),
  total: 300000,
  ticketCount: 1,
);

/// [JourneyApi] giả: một đơn, mã OTP đúng là 123456, hủy vé hoàn 90%.
class _FakeJourneyApi implements JourneyApi {
  final calls = <String>[];
  bool cancelled = false;
  JourneyReviewStatus reviewStatus = const JourneyReviewStatus(
    canReview: false,
  );
  ApiFailure? reviewLoadFailure;
  ApiFailure? reviewSubmitFailure;

  /// Câu máy chủ trả khi nhập sai mã tra cứu.
  String otpFailureDetail = 'Sai mã';

  @override
  Future<JourneyReviewStatus> loadReview(String bookingId) async {
    calls.add('review-load:$bookingId');
    if (reviewLoadFailure case final failure?) throw failure;
    return reviewStatus;
  }

  @override
  Future<JourneyReview> submitReview(
    String bookingId, {
    required int rating,
    String? comment,
  }) async {
    calls.add('review:$bookingId:$rating:$comment');
    if (reviewSubmitFailure case final failure?) throw failure;
    return JourneyReview(rating: rating, status: 'VISIBLE', comment: comment);
  }

  @override
  Future<JourneyLookupOtp> requestLookupOtp(
    String email, {
    String? bookingCode,
  }) async {
    calls.add(bookingCode == null ? 'otp:$email' : 'otp:$email:$bookingCode');
    return const JourneyLookupOtp(
      maskedEmail: 'kh***@example.com',
      expiresInSeconds: 300,
      resendAfterSeconds: 60,
    );
  }

  @override
  Future<String> verifyLookupOtp(
    String email,
    String otp, {
    String? bookingCode,
  }) async {
    calls.add(bookingCode == null ? 'verify:$otp' : 'verify:$otp:$bookingCode');
    if (otp != '123456') {
      throw ApiFailure(
        status: 422,
        code: 'TICKET_LOOKUP_OTP_INVALID',
        detail: otpFailureDetail,
      );
    }
    return 'lookup-token-0123456789-abcdef';
  }

  @override
  Future<JourneyLookupResult> listLookupBookings(String lookupToken) async =>
      JourneyLookupResult(
        maskedEmail: 'kh***@example.com',
        hasAccount: false,
        bookings: [_summary],
      );

  @override
  Future<String> grantLookupAccess(String lookupToken, String bookingId) async {
    calls.add('access:$bookingId');
    return 'access-token';
  }

  @override
  Future<JourneyBooking> lookupBooking(
    String lookupToken,
    String bookingId,
  ) async {
    calls.add('lookup:$bookingId');
    return _booking(cancelled: cancelled);
  }

  @override
  Future<List<JourneyBookingSummary>> listMyBookings() async => [_summary];

  @override
  Future<JourneyBooking> loadBooking(
    String bookingId, {
    String? accessToken,
  }) async {
    calls.add('load:$bookingId:${accessToken ?? 'user'}');
    return _booking(cancelled: cancelled);
  }

  @override
  Future<JourneyCancellationQuote> quoteCancellation(
    String bookingId,
    List<String> ticketIds, {
    String? accessToken,
  }) async => const JourneyCancellationQuote(
    refundPercent: 90,
    selectedTotal: 300000,
    refundAmount: 270000,
    nonRefundable: 30000,
    blockedReason: null,
  );

  @override
  Future<JourneyCancellation> cancel(
    String bookingId,
    List<String> ticketIds, {
    required int expectedRefund,
    String? reason,
    String? accessToken,
  }) async {
    calls.add('cancel:${ticketIds.join(',')}:$expectedRefund:$accessToken');
    cancelled = true;
    return const JourneyCancellation(refundAmount: 270000, refundCode: 'RF-1');
  }
}

Future<void> _pump(WidgetTester tester, Widget child) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(412, 915);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(home: child));
  await tester.pumpAndSettle();
}

/// Chạm sau khi cuộn tới (thanh tab / ô tìm đẩy thẻ vé xuống dưới màn nhỏ).
Future<void> _tapVisible(WidgetTester tester, Key key) async {
  await tester.ensureVisible(find.byKey(key));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(key));
  await tester.pumpAndSettle();
}

Future<void> _openDetail(WidgetTester tester, JourneyApi api) async {
  await _pump(tester, MyJourneyFlow(api: api, onTabSelected: (_) {}));
  // Vé đã đi nằm ở tab "Đã đi"; tab "Tất cả" luôn có đơn mẫu.
  await _tapVisible(tester, const Key('journey-tab-all'));
  await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));
}

Future<void> _enterOtp(WidgetTester tester, String otp) async {
  final fields = find.byType(EditableText);
  for (var index = 0; index < otp.length; index++) {
    await tester.enterText(fields.at(index), otp[index]);
  }
  await tester.pump();
}

void main() {
  testWidgets('khách vãng lai: email → OTP → danh sách → vé thật → hủy vé', (
    tester,
  ) async {
    final api = _FakeJourneyApi();
    await _pump(
      tester,
      GuestJourneyFlow(
        api: api,
        onLoginRequested: () {},
        onTabSelected: (_) {},
      ),
    );

    await tester.enterText(
      find.byKey(const Key('guest-email-field')),
      'khach@example.com',
    );
    await tester.tap(find.byKey(const Key('guest-request-otp-button')));
    await tester.pumpAndSettle();
    expect(api.calls, contains('otp:khach@example.com'));
    expect(find.text('kh***@example.com'), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'otp-screen');

    await _enterOtp(tester, '000000');
    await tester.tap(find.byKey(const Key('guest-journey-verify-otp')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('guest-journey-otp-error')), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'otp-error');

    await _enterOtp(tester, '123456');
    await tester.tap(find.byKey(const Key('guest-journey-verify-otp')));
    await tester.pumpAndSettle();
    expect(find.text('Kết quả tra cứu vé'), findsOneWidget);
    expect(find.text('TP. Hồ Chí Minh → Đà Lạt'), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'results');

    await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));
    expect(api.calls, contains('access:b-1'));
    expect(api.calls, contains('load:b-1:access-token'));
    expect(find.text('Đơn VXN-TEST01 · 1 vé'), findsOneWidget);
    expect(find.text('Nguyễn An'), findsWidgets);
    expect(find.text('VXN-TEST01-01'), findsOneWidget);
    expect(find.byKey(const Key('journey-ticket-qr')), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'detail');
    // API đánh giá chỉ nhận tài khoản: khách vãng lai không gọi và không có khối này.
    expect(api.calls.where((call) => call.startsWith('review')), isEmpty);
    expect(find.byKey(const Key('trip-review-panel')), findsNothing);

    final cancel = find.byKey(const Key('guest-ticket-cancel-button'));
    await tester.scrollUntilVisible(
      cancel,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    // Cuộn thêm để nút không nằm dưới thanh tab nổi.
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(cancel);
    await tester.pumpAndSettle();
    expect(find.text('270.000đ'), findsWidgets);
    expect(tester.takeException(), isNull, reason: 'cancel-sheet');
    await tester.tap(find.byKey(const Key('continue-ticket-cancellation')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-ticket-cancellation')));
    await tester.pumpAndSettle();
    expect(api.calls, contains('cancel:t-1:270000:access-token'));
    expect(tester.takeException(), isNull, reason: 'after-cancel');
    expect(find.text('Hủy vé thành công'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // PASSENGER-PARITY A17 / Q6 (SCR-PSG-24): tab có đếm + ô tìm.
  test('chia đơn vào tab như web và lọc theo mã / tuyến / nhà xe', () {
    final bookings = _ManyBookingsApi.items;
    expect(bookings.map(journeyTicketTabOf), [
      JourneyTicketTab.upcoming,
      JourneyTicketTab.completed,
      JourneyTicketTab.cancelled,
      JourneyTicketTab.upcoming,
    ]);
    expect(journeyTicketCounts(bookings), {
      JourneyTicketTab.upcoming: 2,
      JourneyTicketTab.completed: 1,
      JourneyTicketTab.cancelled: 1,
      JourneyTicketTab.all: 4,
    });
    String codes(JourneyTicketTab tab, String query) => filterJourneyBookings(
      bookings,
      tab,
      query,
    ).map((booking) => booking.bookingCode).join(',');
    expect(codes(JourneyTicketTab.all, 'vxn-past'), 'VXN-PAST01');
    expect(codes(JourneyTicketTab.all, 'nha trang'), 'VXN-NT0001');
    expect(codes(JourneyTicketTab.upcoming, 'sao mai'), 'VXN-TEST01');
    expect(codes(JourneyTicketTab.cancelled, 'đà lạt'), 'VXN-CANCEL');
  });

  testWidgets('Vé của tôi: mặc định Sắp tới, đổi tab, tìm không thấy thì báo', (
    tester,
  ) async {
    await _pump(
      tester,
      MyJourneyFlow(api: _ManyBookingsApi(), onTabSelected: (_) {}),
    );
    expect(find.text('Sắp tới (2)'), findsOneWidget);
    expect(find.text('Đã đi (1)'), findsOneWidget);
    expect(find.text('Đã hủy (1)'), findsOneWidget);
    expect(find.text('Tất cả (4)'), findsOneWidget);
    expect(find.byKey(const Key('journey-open-VXN-TEST01')), findsOneWidget);
    expect(find.byKey(const Key('journey-open-VXN-PAST01')), findsNothing);

    await _tapVisible(tester, const Key('journey-tab-cancelled'));
    expect(find.byKey(const Key('journey-open-VXN-CANCEL')), findsOneWidget);
    expect(find.byKey(const Key('journey-open-VXN-TEST01')), findsNothing);

    await _tapVisible(tester, const Key('journey-tab-all'));
    await tester.enterText(
      find.byKey(const Key('journey-ticket-search')),
      'nha trang',
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('journey-open-VXN-NT0001')), findsOneWidget);
    expect(find.byKey(const Key('journey-open-VXN-TEST01')), findsNothing);

    await tester.enterText(
      find.byKey(const Key('journey-ticket-search')),
      'không có',
    );
    await tester.pumpAndSettle();
    expect(find.text('Không tìm thấy đơn khớp "không có".'), findsOneWidget);
    expect(find.byKey(const Key('journey-results-book')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('đã đăng nhập: "Vé của tôi" → chi tiết không cần mã truy cập', (
    tester,
  ) async {
    final api = _FakeJourneyApi();
    await _pump(tester, MyJourneyFlow(api: api, onTabSelected: (_) {}));

    expect(find.text('Vé của tôi'), findsOneWidget);
    await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));
    expect(api.calls, contains('load:b-1:user'));
    expect(find.text('Vé chuyến - Nhà xe Sao Mai'), findsOneWidget);
    expect(find.text('Giường đơn'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // PASSENGER-PARITY A24 (Q16): "Gửi yêu cầu" mở khiếu nại của đúng đơn thay vì chỉ gọi tổng đài.
  testWidgets('đã đăng nhập: "Gửi yêu cầu" ở chi tiết vé mở khiếu nại của đơn đó', (
    tester,
  ) async {
    final opened = <String>[];
    var hotlineCalls = 0;
    await _pump(
      tester,
      MyJourneyFlow(
        api: _FakeJourneyApi(),
        onTabSelected: (_) {},
        onSupportRequested: () => hotlineCalls++,
        onOpenSupport: (booking) => opened.add(booking.bookingCode),
      ),
    );
    await _tapVisible(tester, const Key('journey-tab-all'));
    await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));

    final link = find.text('Cần hỗ trợ về chuyến đi?  Gửi yêu cầu →');
    await tester.ensureVisible(link);
    await tester.pumpAndSettle();
    await tester.tap(link);
    await tester.pump();

    expect(opened, ['VXN-TEST01']);
    expect(hotlineCalls, 0);
  });

  // PASSENGER-PARITY A22 / Q17: chỉ đường Goong (cùng link web) và chia sẻ vé.
  testWidgets('chi tiết vé: mở chỉ đường Goong tới điểm đón, chia sẻ không kèm mã QR', (
    tester,
  ) async {
    final launched = <Uri>[];
    final shared = <(String, String)>[];
    await _pump(
      tester,
      GuestTicketDetailScreen(
        booking: _booking(),
        onBack: () {},
        onTabSelected: (_) {},
        quoteCancellation: (_) async => throw UnimplementedError(),
        cancelTickets: (_, _, _) async => throw UnimplementedError(),
        launchExternal: (uri) async {
          launched.add(uri);
          return true;
        },
        shareTicket: (subject, text) async => shared.add((subject, text)),
      ),
    );
    await _tapVisible(tester, const Key('journey-open-directions'));
    expect(
      launched.single.toString(),
      'https://maps.goong.io/?q=501%20Ho%C3%A0ng%20H%E1%BB%AFu%20Nam',
    );

    await _tapVisible(tester, const Key('journey-share-ticket'));
    final (subject, text) = shared.single;
    expect(subject, 'Vé VXN-TEST01');
    expect(text, contains('Mã đặt vé: VXN-TEST01'));
    expect(text, contains('Đón: '));
    expect(text, contains('Bến xe Miền Đông mới'));
    expect(text, contains('Chỗ: A3'));
    expect(text, isNot(contains('qr-token')));
    expect(tester.takeException(), isNull);
  });

  // PASSENGER-PARITY A21 (S31, SCR-PSG-28): sai mã hiện câu của máy chủ + "Còn N lần thử".
  testWidgets('OTP tra cứu: hiện số lần thử còn lại, sai mã cập nhật theo máy chủ', (
    tester,
  ) async {
    final api = _FakeJourneyApi()
      ..otpFailureDetail = 'Mã xác minh không đúng. Còn 4 lần thử.';
    await _pump(
      tester,
      GuestJourneyFlow(
        api: api,
        onLoginRequested: () {},
        onTabSelected: (_) {},
      ),
    );
    await tester.enterText(
      find.byKey(const Key('guest-email-field')),
      'khach@example.com',
    );
    await tester.tap(find.byKey(const Key('guest-request-otp-button')));
    await tester.pumpAndSettle();
    expect(find.text('Còn 5 lần thử'), findsOneWidget);

    await _enterOtp(tester, '000000');
    await tester.tap(find.byKey(const Key('guest-journey-verify-otp')));
    await tester.pumpAndSettle();
    expect(find.text('Mã xác minh không đúng. Còn 4 lần thử.'), findsOneWidget);
    expect(find.text('Còn 4 lần thử'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // PASSENGER-PARITY A13 / UC-35 A1b, bước 6.
  Future<void> lookupByEmail(WidgetTester tester, {String? code}) async {
    await tester.enterText(
      find.byKey(const Key('guest-email-field')),
      'khach@example.com',
    );
    if (code != null) {
      await tester.enterText(
        find.byKey(const Key('guest-booking-code-field')),
        code,
      );
    }
    await tester.tap(find.byKey(const Key('guest-request-otp-button')));
    await tester.pumpAndSettle();
    await _enterOtp(tester, '123456');
    await tester.tap(find.byKey(const Key('guest-journey-verify-otp')));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'đơn đặt bằng tài khoản: ghi nhãn, mời đăng nhập; chọn Đăng nhập',
    (tester) async {
      final api = _AccountBookingApi();
      var loginRequested = 0;
      await _pump(
        tester,
        GuestJourneyFlow(
          api: api,
          onLoginRequested: () => loginRequested++,
          onTabSelected: (_) {},
        ),
      );
      await lookupByEmail(tester);
      expect(
        find.byKey(const Key('journey-booked-with-account')),
        findsOneWidget,
      );
      expect(find.text('Đặt bằng tài khoản'), findsOneWidget);
      expect(
        find.byKey(const Key('journey-lookup-login-invite')),
        findsOneWidget,
      );

      await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));
      expect(
        find.byKey(const Key('journey-account-booking-dialog')),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('journey-account-booking-login')));
      await tester.pumpAndSettle();
      expect(loginRequested, 1);
      expect(api.calls.where((call) => call.startsWith('access')), isEmpty);
      expect(api.calls.where((call) => call.startsWith('lookup')), isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'đơn đặt bằng tài khoản: "Chỉ xem vé" mở chi tiết chỉ đọc, không hỏi lại',
    (tester) async {
      final api = _AccountBookingApi();
      final key = GlobalKey();
      await _pump(
        tester,
        GuestJourneyFlow(
          key: key,
          api: api,
          onLoginRequested: () {},
          onTabSelected: (_) {},
        ),
      );
      await lookupByEmail(tester);
      await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));
      await tester.tap(find.byKey(const Key('journey-account-booking-view')));
      await tester.pumpAndSettle();

      expect(api.calls, contains('lookup:b-1'));
      expect(api.calls.where((call) => call.startsWith('access')), isEmpty);
      expect(find.text('Đơn VXN-TEST01 · 1 vé'), findsOneWidget);
      expect(find.byKey(const Key('journey-ticket-qr')), findsOneWidget);
      expect(find.byKey(const Key('journey-detail-read-only')), findsOneWidget);
      expect(find.byKey(const Key('journey-detail-login')), findsOneWidget);
      expect(find.byKey(const Key('guest-ticket-cancel-button')), findsNothing);
      expect(find.textContaining('Gửi yêu cầu'), findsNothing);
      // Chính sách hủy vẫn cho biết mức hoàn hiện tại (vé còn hủy được sau khi đăng nhập).
      expect(find.text('Vé này không còn hủy được.'), findsNothing);

      expect((key.currentState! as JourneyBackHandler).handleBack(), isTrue);
      await tester.pumpAndSettle();
      await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));
      expect(
        find.byKey(const Key('journey-account-booking-dialog')),
        findsNothing,
        reason: 'đã chọn chỉ xem một lần trong phiên',
      );
      expect(find.byKey(const Key('journey-detail-read-only')), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('có mã đặt vé: gửi kèm mã, sau OTP mở thẳng đơn đó', (
    tester,
  ) async {
    final api = _BookingScopedApi();
    final key = GlobalKey();
    await _pump(
      tester,
      GuestJourneyFlow(
        key: key,
        api: api,
        onLoginRequested: () {},
        onTabSelected: (_) {},
      ),
    );
    await lookupByEmail(tester, code: 'vxn-test01-01');
    expect(api.calls, contains('otp:khach@example.com:VXNTEST01'));
    expect(api.calls, contains('verify:123456:VXNTEST01'));
    expect(api.calls, contains('access:b-1'));
    expect(find.text('Đơn VXN-TEST01 · 1 vé'), findsOneWidget);
    expect(find.byKey(const Key('guest-ticket-cancel-button')), findsOneWidget);

    // Back về danh sách một đơn của phiên, không tự mở lại.
    expect((key.currentState! as JourneyBackHandler).handleBack(), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('Kết quả tra cứu vé'), findsOneWidget);
    expect(find.byKey(const Key('journey-open-VXN-TEST01')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('tên cổng và nhãn hoàn tiền lỗi viết cho hành khách đọc, giống web', () {
    expect(journeyProviderLabel('DEMO'), 'Cổng thanh toán thử');
    expect(journeyProviderLabel('PAYOS'), 'payOS');
    expect(journeyProviderLabel('VNPAY'), 'VNPay');
    expect(journeyProviderLabel('MOMO'), 'MoMo');
    expect(journeyProviderLabel(null), 'Chưa thanh toán');
    expect(
      journeyBookingStatusLabel('REFUND_FAILED'),
      'Hoàn tiền chưa thành công',
    );
    expect(
      journeyRefundStatusLabel('FAILED'),
      'Hoàn tiền chưa thành công — đang hỗ trợ',
    );
  });

  test('trạng thái hiện cho khách lấy theo vé còn hiệu lực', () {
    String display(String status, List<String> tickets) =>
        JourneyBookingSummary(
          bookingId: 'b',
          bookingCode: 'VXN',
          status: status,
          routeName: 'R',
          operatorName: 'O',
          departureAt: DateTime(2026, 11, 2),
          total: 1,
          ticketStatuses: tickets,
        ).displayStatus;

    expect(display('CONFIRMED', ['VALID']), 'CONFIRMED');
    expect(display('CONFIRMED', ['VALID', 'USED']), 'CONFIRMED');
    expect(display('CONFIRMED', ['USED']), 'USED');
    expect(display('CONFIRMED', ['USED', 'NO_SHOW']), 'USED');
    expect(display('CONFIRMED', ['NO_SHOW']), 'NO_SHOW');
    expect(display('CONFIRMED', ['CHECKED_IN', 'USED']), 'CHECKED_IN');
    expect(display('PARTIALLY_CANCELLED', ['CANCELLED', 'USED']), 'USED');
    expect(display('PENDING_PAYMENT', const []), 'PENDING_PAYMENT');
    expect(display('REFUNDED', ['REFUNDED']), 'REFUNDED');
  });

  testWidgets('vé đã đi: danh sách ghi "Đã đi", chi tiết không còn nút hủy', (
    tester,
  ) async {
    final api = _UsedTicketApi();
    await _pump(tester, MyJourneyFlow(api: api, onTabSelected: (_) {}));
    await _tapVisible(tester, const Key('journey-tab-completed'));

    expect(find.text('Đã đi'), findsOneWidget);
    expect(find.text('Hợp lệ'), findsNothing);

    await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));

    expect(find.text('Đã sử dụng'), findsOneWidget);
    expect(find.text('Lên xe quét mã'), findsNothing);
    expect(find.byKey(const Key('journey-ticket-qr-zoom')), findsNothing);
    expect(find.text('Vé này không còn hủy được.'), findsOneWidget);
    expect(find.byKey(const Key('guest-ticket-cancel-button')), findsNothing);
    expect(find.text('Liên hệ hỗ trợ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('vé đã đi: gửi đánh giá từ chi tiết vé, gửi xong hiện lại', (
    tester,
  ) async {
    final api = _UsedTicketApi()
      ..reviewStatus = const JourneyReviewStatus(canReview: true);
    await _openDetail(tester, api);

    expect(api.calls, contains('review-load:b-1'));
    await tester.tap(find.byKey(const Key('trip-review-open')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('review-form-sheet')), findsOneWidget);
    expect(find.text('Nhà xe Sao Mai'), findsWidgets);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('submit-review')))
          .onPressed,
      isNull,
      reason: 'chưa chọn sao thì chưa gửi được',
    );

    await tester.tap(find.byKey(const Key('review-rating-4')));
    await tester.enterText(
      find.byKey(const Key('review-comment-input')),
      '  Xe đúng giờ  ',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('submit-review')));
    await tester.pumpAndSettle();

    expect(api.calls, contains('review:b-1:4:Xe đúng giờ'));
    expect(find.byKey(const Key('review-form-sheet')), findsNothing);
    expect(find.byKey(const Key('trip-review-open')), findsNothing);
    expect(find.text('Đánh giá của bạn'), findsOneWidget);
    expect(find.text('Xe đúng giờ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('đã đánh giá: chỉ hiện lại, đang chờ duyệt thì ghi rõ', (
    tester,
  ) async {
    final api = _UsedTicketApi()
      ..reviewStatus = const JourneyReviewStatus(
        canReview: false,
        review: JourneyReview(rating: 3, status: 'HELD', comment: 'Tạm ổn'),
      );
    await _openDetail(tester, api);

    expect(find.text('Đánh giá của bạn'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('trip-review-panel'))).width,
      378,
      reason: 'nhận xét ngắn vẫn rộng bằng các thẻ khác',
    );
    expect(find.text('Tạm ổn'), findsOneWidget);
    expect(find.text('Đánh giá đang chờ duyệt'), findsOneWidget);
    expect(find.byKey(const Key('trip-review-open')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chưa đủ điều kiện hoặc tải lỗi: không có khối đánh giá', (
    tester,
  ) async {
    await _openDetail(tester, _UsedTicketApi());
    expect(find.byKey(const Key('trip-review-panel')), findsNothing);

    final failing = _UsedTicketApi()
      ..reviewLoadFailure = const ApiFailure(
        status: 500,
        code: 'INTERNAL',
        detail: 'Lỗi',
      );
    await tester.pumpWidget(const SizedBox());
    await _openDetail(tester, failing);
    expect(failing.calls, contains('review-load:b-1'));
    expect(find.byKey(const Key('trip-review-panel')), findsNothing);
    expect(find.text('Đã sử dụng'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('gửi lỗi: giữ form để gửi lại; đơn đã có thì đóng form', (
    tester,
  ) async {
    final api = _UsedTicketApi()
      ..reviewStatus = const JourneyReviewStatus(canReview: true)
      ..reviewSubmitFailure = const ApiFailure(
        status: 409,
        code: 'REVIEW_NOT_ALLOWED',
        detail: 'Đơn này đã được đánh giá.',
      );
    await _openDetail(tester, api);
    await tester.tap(find.byKey(const Key('trip-review-open')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('review-rating-5')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('submit-review')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('review-form-sheet')), findsOneWidget);
    expect(find.byKey(const Key('review-submit-error')), findsOneWidget);

    api.reviewStatus = const JourneyReviewStatus(
      canReview: false,
      review: JourneyReview(rating: 5, status: 'VISIBLE'),
    );
    await tester.tap(find.byKey(const Key('submit-review')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('review-form-sheet')), findsNothing);
    expect(find.text('Đánh giá của bạn'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('đang xem vé, mở đơn khác: vé và đánh giá theo đơn mới', (
    tester,
  ) async {
    final key = GlobalKey();
    final api = _TwoBookingsApi();
    await _pump(
      tester,
      MyJourneyFlow(key: key, api: api, onTabSelected: (_) {}),
    );
    final opener = key.currentState! as JourneyBookingOpener;

    await opener.openBooking('b-1');
    await tester.pumpAndSettle();
    expect(find.text('Đơn VXN-TEST01 · 1 vé'), findsOneWidget);
    expect(find.byKey(const Key('trip-review-open')), findsNothing);

    await opener.openBooking('b-2');
    await tester.pumpAndSettle();
    expect(find.text('Đơn VXN-TEST02 · 1 vé'), findsOneWidget);
    expect(api.calls, contains('review-load:b-2'));
    expect(find.byKey(const Key('trip-review-open')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('thẻ vé: bỏ tên điểm dưới giờ, trạng thái nằm dưới mã QR', (
    tester,
  ) async {
    await _pump(
      tester,
      MyJourneyFlow(api: _FakeJourneyApi(), onTabSelected: (_) {}),
    );
    await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));

    // Tên điểm chỉ còn ở phần Hành trình.
    expect(find.text('Bến xe Miền Đông mới'), findsOneWidget);
    expect(find.text('Bến xe liên tỉnh Đà Lạt'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Hợp lệ')).dy,
      greaterThan(
        tester.getBottomLeft(find.byKey(const Key('journey-ticket-qr'))).dy,
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('tên tuyến và điểm đón dài: hiện đủ, máy hẹp không tràn', (
    tester,
  ) async {
    const pickup =
        'Văn phòng Phương Trang Lê Hồng Phong và điểm trung chuyển Quận 10';
    const address =
        '231-233 Lê Hồng Phong, Phường Chợ Quán, Thành phố Hồ Chí Minh, Việt Nam';
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: MyJourneyFlow(api: _LongNamesApi(), onTabSelected: (_) {}),
      ),
    );
    await tester.pumpAndSettle();
    await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));

    expect(find.textContaining('BX Miền Đông mới'), findsOneWidget);
    expect(find.textContaining('Quốc lộ 20'), findsOneWidget);
    for (final text in [pickup, address]) {
      expect(tester.widget<Text>(find.text(text)).maxLines, isNull);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'chạm mã QR: thẻ vé phóng to, xoay ngang; Back hoặc nút đóng thì trở lại',
    (tester) async {
      await _pump(
        tester,
        MyJourneyFlow(api: _FakeJourneyApi(), onTabSelected: (_) {}),
      );
      await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));
      const enlarged = Key('journey-ticket-enlarged');
      const zoom = Key('journey-ticket-qr-zoom');

      await tester.tap(find.byKey(zoom));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byKey(enlarged), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'đang chạy hiệu ứng');
      await tester.pumpAndSettle();

      final pass = tester.renderObject<RenderBox>(find.byKey(enlarged));
      final bounds = Rect.fromPoints(
        pass.localToGlobal(Offset.zero),
        pass.localToGlobal(pass.size.bottomRight(Offset.zero)),
      );
      expect(
        bounds.height,
        greaterThan(bounds.width),
        reason: 'cạnh dài nằm dọc',
      );
      expect(
        bounds.width,
        greaterThan(412 * .85),
        reason: 'gần hết chiều ngang',
      );
      expect(const Rect.fromLTWH(0, 0, 412, 915).intersect(bounds), bounds);

      // Trong màn phóng to, chạm mã QR không mở thêm lớp nữa.
      expect(find.byKey(zoom), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byKey(enlarged), findsNothing);
      expect(find.text('Đơn VXN-TEST01 · 1 vé'), findsOneWidget);

      await tester.tap(find.byKey(zoom));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('journey-ticket-enlarged-close')));
      await tester.pumpAndSettle();
      expect(find.byKey(enlarged), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('khách xoay máy ngang khi đang phóng to: thẻ không xoay thêm', (
    tester,
  ) async {
    await _pump(
      tester,
      MyJourneyFlow(api: _FakeJourneyApi(), onTabSelected: (_) {}),
    );
    await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));

    await tester.tap(find.byKey(const Key('journey-ticket-qr-zoom')));
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(915, 412);
    await tester.pumpAndSettle();
    final pass = tester.renderObject<RenderBox>(
      find.byKey(const Key('journey-ticket-enlarged')),
    );
    final bounds = Rect.fromPoints(
      pass.localToGlobal(Offset.zero),
      pass.localToGlobal(pass.size.bottomRight(Offset.zero)),
    );
    expect(bounds.width, greaterThan(bounds.height));
    expect(tester.takeException(), isNull);
  });

  testWidgets('vé đã hủy: mã QR không phóng to được', (tester) async {
    final api = _FakeJourneyApi()..cancelled = true;
    await _pump(tester, MyJourneyFlow(api: api, onTabSelected: (_) {}));
    await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));

    expect(find.text('Đã hủy'), findsWidgets);
    expect(find.text('QR không còn hiệu lực'), findsOneWidget);
    expect(find.byKey(const Key('journey-ticket-qr-zoom')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chuyến đã qua giờ chạy thì không còn nút hủy dù vé chưa dùng', (
    tester,
  ) async {
    final api = _DepartedTripApi();
    await _pump(tester, MyJourneyFlow(api: api, onTabSelected: (_) {}));

    await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));

    expect(find.byKey(const Key('guest-ticket-cancel-button')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Back ở chi tiết vé về danh sách, không rời tab và không lỗi', (
    tester,
  ) async {
    final key = GlobalKey();
    await _pump(
      tester,
      MyJourneyFlow(key: key, api: _FakeJourneyApi(), onTabSelected: (_) {}),
    );
    final flow = key.currentState! as JourneyBackHandler;

    expect(flow.handleBack(), isFalse, reason: 'danh sách là bước đầu');

    await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));
    expect(find.text('Đơn VXN-TEST01 · 1 vé'), findsOneWidget);

    expect(flow.handleBack(), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('Vé của tôi'), findsOneWidget);
    expect(find.text('Đơn VXN-TEST01 · 1 vé'), findsNothing);
    // `setState` trả về Future sẽ ném lỗi ngay tại đây ở bản debug.
    expect(tester.takeException(), isNull);
  });

  testWidgets('khách vãng lai: Back lùi từng bước của tra cứu', (tester) async {
    final key = GlobalKey();
    await _pump(
      tester,
      GuestJourneyFlow(
        key: key,
        api: _FakeJourneyApi(),
        onLoginRequested: () {},
        onTabSelected: (_) {},
      ),
    );
    final flow = key.currentState! as JourneyBackHandler;
    expect(flow.handleBack(), isFalse);

    await tester.enterText(
      find.byKey(const Key('guest-email-field')),
      'khach@example.com',
    );
    await tester.tap(find.byKey(const Key('guest-request-otp-button')));
    await tester.pumpAndSettle();
    await _enterOtp(tester, '123456');
    await tester.tap(find.byKey(const Key('guest-journey-verify-otp')));
    await tester.pumpAndSettle();
    await _tapVisible(tester, const Key('journey-open-VXN-TEST01'));
    expect(find.text('Đơn VXN-TEST01 · 1 vé'), findsOneWidget);

    expect(flow.handleBack(), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('Kết quả tra cứu vé'), findsOneWidget);

    expect(flow.handleBack(), isTrue);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('guest-email-field')), findsOneWidget);
    expect(flow.handleBack(), isFalse);
    expect(tester.takeException(), isNull);
  });
}

/// Bốn đơn của tài khoản: sắp đi, đã đi, đã hủy và một chuyến sắp đi khác tuyến.
class _ManyBookingsApi extends _FakeJourneyApi {
  static final items = [
    _summary,
    JourneyBookingSummary(
      bookingId: 'b-past',
      bookingCode: 'VXN-PAST01',
      status: 'CONFIRMED',
      routeName: 'TP. Hồ Chí Minh → Vũng Tàu',
      operatorName: 'Nhà xe Hoa Mai',
      departureAt: DateTime.now().subtract(const Duration(days: 5)),
      total: 180000,
      ticketStatuses: const ['USED'],
    ),
    JourneyBookingSummary(
      bookingId: 'b-cancel',
      bookingCode: 'VXN-CANCEL',
      status: 'REFUNDED',
      routeName: 'TP. Hồ Chí Minh → Đà Lạt',
      operatorName: 'Nhà xe Thành Bưởi',
      departureAt: DateTime.now().add(const Duration(days: 9)),
      total: 320000,
      ticketStatuses: const ['REFUNDED'],
    ),
    JourneyBookingSummary(
      bookingId: 'b-nt',
      bookingCode: 'VXN-NT0001',
      status: 'PENDING_PAYMENT',
      routeName: 'TP. Hồ Chí Minh → Nha Trang',
      operatorName: 'Nhà xe Phương Nam',
      departureAt: DateTime.now().add(const Duration(days: 2)),
      total: 400000,
    ),
  ];

  @override
  Future<List<JourneyBookingSummary>> listMyBookings() async => items;
}

class _UsedTicketApi extends _FakeJourneyApi {
  @override
  Future<List<JourneyBookingSummary>> listMyBookings() async => [
    JourneyBookingSummary(
      bookingId: 'b-1',
      bookingCode: 'VXN-TEST01',
      status: 'CONFIRMED',
      routeName: 'TP. Hồ Chí Minh → Đà Lạt',
      operatorName: 'Nhà xe Sao Mai',
      departureAt: DateTime.now().subtract(const Duration(days: 3)),
      total: 300000,
      ticketStatuses: const ['USED'],
    ),
  ];

  @override
  Future<JourneyBooking> loadBooking(
    String bookingId, {
    String? accessToken,
  }) async => _withTicketStatus(_booking(), 'USED');
}

/// Hai đơn: b-1 chưa đánh giá được, b-2 đã đi và đánh giá được.
class _TwoBookingsApi extends _FakeJourneyApi {
  @override
  Future<JourneyBooking> loadBooking(
    String bookingId, {
    String? accessToken,
  }) async => bookingId == 'b-2'
      ? _withTicketStatus(
          _booking(bookingId: 'b-2', bookingCode: 'VXN-TEST02'),
          'USED',
        )
      : _booking();

  @override
  Future<JourneyReviewStatus> loadReview(String bookingId) async {
    calls.add('review-load:$bookingId');
    return JourneyReviewStatus(canReview: bookingId == 'b-2');
  }
}

class _LongNamesApi extends _FakeJourneyApi {
  @override
  Future<JourneyBooking> loadBooking(
    String bookingId, {
    String? accessToken,
  }) async => _booking(
    routeName: 'TP. Hồ Chí Minh (BX Miền Đông mới) – Đà Lạt (Quốc lộ 20)',
    pickupName:
        'Văn phòng Phương Trang Lê Hồng Phong và điểm trung chuyển Quận 10',
    pickupAddress: '231-233 Lê Hồng Phong, Phường Chợ Quán, Thành phố Hồ Chí Minh, Việt Nam',
  );
}

class _DepartedTripApi extends _FakeJourneyApi {
  @override
  Future<JourneyBooking> loadBooking(
    String bookingId, {
    String? accessToken,
  }) async => _withTicketStatus(
    _booking(),
    'VALID',
    departureAt: DateTime.now().subtract(const Duration(hours: 1)),
  );
}

JourneyBooking _withTicketStatus(
  JourneyBooking base,
  String status, {
  DateTime? departureAt,
}) => JourneyBooking(
  bookingId: base.bookingId,
  bookingCode: base.bookingCode,
  status: base.status,
  routeName: base.routeName,
  operatorName: base.operatorName,
  vehicleTypeName: base.vehicleTypeName,
  departureAt: departureAt ?? base.departureAt,
  pickup: base.pickup,
  dropoff: base.dropoff,
  contactEmail: base.contactEmail,
  subtotal: base.subtotal,
  serviceFee: base.serviceFee,
  discount: base.discount,
  total: base.total,
  tiers: base.tiers,
  tickets: [
    for (final ticket in base.tickets)
      JourneyTicket(
        ticketId: ticket.ticketId,
        ticketCode: ticket.ticketCode,
        seatCode: ticket.seatCode,
        passengerName: ticket.passengerName,
        status: status,
        qrToken: ticket.qrToken,
        seatType: ticket.seatType,
        price: ticket.price,
      ),
  ],
  refunds: base.refunds,
  paymentProvider: base.paymentProvider,
  paymentCode: base.paymentCode,
  paymentStatus: base.paymentStatus,
);

/// Phiên mở bằng mã đặt vé: chỉ một đơn khách vãng lai.
class _BookingScopedApi extends _FakeJourneyApi {
  @override
  Future<JourneyLookupResult> listLookupBookings(String lookupToken) async =>
      JourneyLookupResult(
        maskedEmail: 'kh***@example.com',
        hasAccount: false,
        bookingScoped: true,
        bookings: [_summary],
      );
}

class _AccountBookingApi extends _FakeJourneyApi {
  @override
  Future<JourneyLookupResult> listLookupBookings(String lookupToken) async =>
      JourneyLookupResult(
        maskedEmail: 'kh***@example.com',
        hasAccount: true,
        bookings: [
          JourneyBookingSummary(
            bookingId: 'b-1',
            bookingCode: 'VXN-TEST01',
            status: 'CONFIRMED',
            routeName: 'TP. Hồ Chí Minh → Đà Lạt',
            operatorName: 'Nhà xe Sao Mai',
            departureAt: DateTime.now().add(const Duration(days: 3)),
            total: 300000,
            bookedWithAccount: true,
          ),
        ],
      );
}
