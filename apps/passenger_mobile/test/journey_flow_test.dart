import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/journey/guest_journey_flow.dart';
import 'package:passenger_mobile/features/journey/journey_api.dart';
import 'package:passenger_mobile/features/journey/journey_models.dart';

JourneyBooking _booking({bool cancelled = false}) => JourneyBooking(
  bookingId: 'b-1',
  bookingCode: 'VXN-TEST01',
  status: cancelled ? 'CANCELLED' : 'CONFIRMED',
  routeName: 'TP. Hồ Chí Minh → Đà Lạt',
  operatorName: 'Nhà xe Sao Mai',
  vehicleTypeName: 'Giường nằm 34 chỗ',
  departureAt: DateTime.now().add(const Duration(days: 3)),
  pickup: JourneyStop(
    name: 'Bến xe Miền Đông mới',
    address: '501 Hoàng Hữu Nam',
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

  @override
  Future<JourneyLookupOtp> requestLookupOtp(String email) async {
    calls.add('otp:$email');
    return const JourneyLookupOtp(
      maskedEmail: 'kh***@example.com',
      expiresInSeconds: 300,
      resendAfterSeconds: 60,
    );
  }

  @override
  Future<String> verifyLookupOtp(String email, String otp) async {
    calls.add('verify:$otp');
    if (otp != '123456') {
      throw const ApiFailure(
        status: 422,
        code: 'TICKET_LOOKUP_OTP_INVALID',
        detail: 'Sai mã',
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

    await tester.tap(find.byKey(const Key('journey-open-VXN-TEST01')));
    await tester.pumpAndSettle();
    expect(api.calls, contains('access:b-1'));
    expect(api.calls, contains('load:b-1:access-token'));
    expect(find.text('Đơn VXN-TEST01 · 1 vé'), findsOneWidget);
    expect(find.text('Nguyễn An'), findsWidgets);
    expect(find.text('VXN-TEST01-01'), findsOneWidget);
    expect(find.byKey(const Key('journey-ticket-qr')), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'detail');

    final cancel = find.byKey(const Key('guest-ticket-cancel-button'));
    await tester.scrollUntilVisible(
      cancel,
      200,
      scrollable: find.byType(Scrollable).first,
    );
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

  testWidgets('đã đăng nhập: "Vé của tôi" → chi tiết không cần mã truy cập', (
    tester,
  ) async {
    final api = _FakeJourneyApi();
    await _pump(tester, MyJourneyFlow(api: api, onTabSelected: (_) {}));

    expect(find.text('Vé của tôi'), findsOneWidget);
    await tester.tap(find.byKey(const Key('journey-open-VXN-TEST01')));
    await tester.pumpAndSettle();
    expect(api.calls, contains('load:b-1:user'));
    expect(find.text('Vé chuyến - Nhà xe Sao Mai'), findsOneWidget);
    expect(find.text('Giường đơn'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('đơn đặt bằng tài khoản: khách vãng lai được mời đăng nhập', (
    tester,
  ) async {
    final api = _AccountBookingApi();
    var loginRequested = false;
    await _pump(
      tester,
      GuestJourneyFlow(
        api: api,
        onLoginRequested: () => loginRequested = true,
        onTabSelected: (_) {},
      ),
    );
    await tester.enterText(
      find.byKey(const Key('guest-email-field')),
      'khach@example.com',
    );
    await tester.tap(find.byKey(const Key('guest-request-otp-button')));
    await tester.pumpAndSettle();
    await _enterOtp(tester, '123456');
    await tester.tap(find.byKey(const Key('guest-journey-verify-otp')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('journey-open-VXN-TEST01')));
    await tester.pumpAndSettle();
    expect(api.calls.where((call) => call.startsWith('access')), isEmpty);
    await tester.tap(find.widgetWithText(SnackBarAction, 'Đăng nhập'));
    expect(loginRequested, isTrue);
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

    expect(find.text('Đã đi'), findsOneWidget);
    expect(find.text('Hợp lệ'), findsNothing);

    await tester.tap(find.byKey(const Key('journey-open-VXN-TEST01')));
    await tester.pumpAndSettle();

    expect(find.text('Đã sử dụng'), findsOneWidget);
    expect(find.text('Lên xe quét mã'), findsNothing);
    expect(find.text('Vé này không còn hủy được.'), findsOneWidget);
    expect(find.byKey(const Key('guest-ticket-cancel-button')), findsNothing);
    expect(find.text('Liên hệ hỗ trợ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chuyến đã qua giờ chạy thì không còn nút hủy dù vé chưa dùng', (
    tester,
  ) async {
    final api = _DepartedTripApi();
    await _pump(tester, MyJourneyFlow(api: api, onTabSelected: (_) {}));

    await tester.tap(find.byKey(const Key('journey-open-VXN-TEST01')));
    await tester.pumpAndSettle();

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

    await tester.tap(find.byKey(const Key('journey-open-VXN-TEST01')));
    await tester.pumpAndSettle();
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
    await tester.tap(find.byKey(const Key('journey-open-VXN-TEST01')));
    await tester.pumpAndSettle();
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
