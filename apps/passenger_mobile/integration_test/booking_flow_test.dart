// E2E luồng đặt vé của khách vãng lai: chạy app thật trên máy ảo / máy thật, gọi API thật.
//
// Cần API có dữ liệu chuyến TP. Hồ Chí Minh → Lâm Đồng ngày mai, rồi chạy:
//   flutter test integration_test -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:3100
//
// Mỗi lần chạy tạo thật một đơn chờ thanh toán (giữ chỗ tới khi đơn hết hạn) — chỉ chạy trên DB dev / demo.
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:passenger_mobile/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final api = Dio(BaseOptions(baseUrl: '$apiBaseUrl/v1'));

  /// Trạng thái chỗ [seat] của chuyến theo API công khai (`AVAILABLE` / `UNAVAILABLE`).
  Future<String> seatStatus(String tripId, String seat) async {
    final response = await api.get<Map<String, dynamic>>('/trips/$tripId');
    final seats = (response.data!['seats'] as List)
        .cast<Map<String, dynamic>>();
    return seats.firstWhere((item) => item['code'] == seat)['status'] as String;
  }

  testWidgets(
    'khách vãng lai tìm chuyến, giữ chỗ, nhập thông tin và tạo đơn chờ thanh toán',
    (tester) async {
      final trip = await _searchFirstTrip(tester);
      final seat = await _holdFirstFreeSeat(tester);
      expect(await seatStatus(trip, seat), 'UNAVAILABLE');

      // Thông tin hành khách: mã khuyến mãi sai hiện lỗi của API, không chặn đặt vé.
      final stamp = DateTime.now().millisecondsSinceEpoch;
      await _enter(tester, const Key('contact-name-field'), 'Khach E2E');
      await _enter(tester, const Key('contact-phone-field'), '0901234567');
      await _enter(
        tester,
        const Key('contact-email-field'),
        'e2e+$stamp@example.com',
      );
      await _enter(tester, Key('passenger-name-$seat'), 'Khach E2E');
      await _enter(tester, const Key('voucher-field'), 'KHONGCOMA');
      await _tap(tester, find.byKey(const Key('voucher-apply')));
      await _pumpUntil(
        tester,
        find.descendant(
          of: find.byKey(const Key('voucher-field')),
          matching: find.textContaining('khuyến mãi'),
        ),
      );
      expect(find.byKey(const Key('voucher-applied')), findsNothing);
      await _tap(
        tester,
        find.byKey(const Key('passenger-information-continue')),
      );

      // Xác nhận: phải đồng ý điều khoản mới đi tiếp.
      await _pumpUntil(
        tester,
        find.byKey(const Key('booking-confirmation-screen')),
      );
      expect(find.textContaining('Khach E2E'), findsWidgets);
      final continuePayment = find.byKey(const Key('booking-continue-payment'));
      expect(
        tester.widget<ButtonStyleButton>(continuePayment).onPressed,
        isNull,
      );
      // Ô điều khoản ở cuối danh sách cuộn, chưa dựng tới khi cuộn xuống.
      await tester.scrollUntilVisible(
        find.byKey(const Key('booking-terms-checkbox')),
        300,
        scrollable: find.descendant(
          of: find.byKey(const Key('booking-confirmation-scroll')),
          matching: find.byType(Scrollable),
        ),
      );
      await _tap(tester, find.byKey(const Key('booking-terms-checkbox')));
      await _tap(tester, continuePayment);

      // Đơn đã tạo: màn thanh toán có mã đơn, chỗ vẫn bị giữ cho đơn.
      await _pumpUntil(tester, find.byKey(const Key('payment-screen')));
      final code = tester
          .widget<Text>(find.byKey(const Key('payment-booking-code')))
          .data!;
      expect(code, startsWith('VXN'));
      expect(find.byKey(const Key('payment-pending-notice')), findsOneWidget);
      expect(await seatStatus(trip, seat), 'UNAVAILABLE');
    },
  );

  testWidgets('quay lại từ màn chọn chỗ thì trả chỗ đang giữ', (tester) async {
    final trip = await _searchFirstTrip(tester);
    final seat = await _holdFirstFreeSeat(tester);
    expect(await seatStatus(trip, seat), 'UNAVAILABLE');

    await _tap(tester, find.byKey(const Key('passenger-information-back')));
    await _pumpUntil(tester, find.byKey(const Key('seat-selection-screen')));
    await _tap(tester, find.byKey(const Key('seat-selection-back')));
    await _pumpUntil(tester, find.byKey(const Key('trip-detail-screen')));

    // Bỏ giữ chỗ chạy nền sau khi rời màn — chờ API thấy chỗ trống lại.
    var status = 'UNAVAILABLE';
    for (var i = 0; i < 20 && status != 'AVAILABLE'; i++) {
      await tester.pump(const Duration(milliseconds: 250));
      status = await seatStatus(trip, seat);
    }
    expect(status, 'AVAILABLE');
  });

  testWidgets(
    'khách vãng lai: mọi tab mở màn thật, không có thông báo "chưa triển khai"',
    (tester) async {
      await _enterGuestMode(tester);
      const screens = {
        0: 'explore-screen',
        1: 'ticket-screen',
        2: 'home-screen',
        3: 'guest-ticket-lookup-screen',
        4: 'guest-account-screen',
      };
      // Đi qua mọi cặp tab (từ màn nào sang màn nào cũng phải tới màn thật).
      for (final from in screens.keys) {
        for (final to in screens.keys) {
          if (from == to) continue;
          await _openTab(tester, from, screens[from]!);
          await _openTab(tester, to, screens[to]!);
        }
      }

      // Trang chủ: "Xem tất cả" của Khám phá & cẩm nang sang tab Khám phá.
      await _openTab(tester, 2, 'home-screen');
      final seeAll = find.text('Xem tất cả  ›');
      await tester.scrollUntilVisible(
        seeAll,
        300,
        // Thanh cuộn dọc ngoài cùng (bên trong còn các dải cuộn ngang).
        scrollable: find
            .descendant(
              of: find.byKey(const Key('home-content-scroll')),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      // Kéo thêm để nút không nằm dưới thanh tab nổi.
      await tester.drag(
        find.byKey(const Key('home-content-scroll')),
        const Offset(0, -250),
      );
      await _pumpFor(tester, const Duration(milliseconds: 500));
      await _tap(tester, seeAll);
      await _pumpUntil(tester, find.byKey(const Key('explore-screen')));
      _expectNoPlaceholder();

      // Tab Tài khoản (chưa đăng nhập) → nút đăng nhập mới mở màn đăng nhập.
      await _openTab(tester, 4, 'guest-account-screen');
      await _tap(tester, find.byKey(const Key('guest-account-lookup')));
      await _pumpUntil(
        tester,
        find.byKey(const Key('guest-ticket-lookup-screen')),
      );
      await _openTab(tester, 4, 'guest-account-screen');
      await _tap(tester, find.byKey(const Key('guest-account-login')));
      await _pumpUntil(tester, find.byKey(const Key('guest-button')));
      _expectNoPlaceholder();

      // Không chạy lại splash: chỉ chờ chuyển màn (~0,5 giây) là bấm được nút khách ngay.
      await _pumpFor(tester, const Duration(milliseconds: 700));
      await tester.tap(find.byKey(const Key('guest-button')));
      await _pumpUntil(
        tester,
        find.byKey(const Key('origin-input')),
        timeout: const Duration(seconds: 3),
      );

      // Tra cứu vé chỉ cần email (không có ô mã đặt vé).
      await _openTab(tester, 3, 'guest-ticket-lookup-screen');
      expect(find.byKey(const Key('guest-booking-code-field')), findsNothing);
      expect(find.byKey(const Key('guest-email-field')), findsOneWidget);
    },
  );
}

/// Không còn thông báo kiểu "sẽ được triển khai" / "chưa triển khai" / "sắp mở".
void _expectNoPlaceholder() {
  expect(
    find.textContaining(
      RegExp('triển khai|bước tiếp theo|sắp mở|chưa khả dụng'),
    ),
    findsNothing,
  );
}

/// Bấm tab [index] trên thanh điều hướng dưới, chờ màn [screenKey], kiểm không có thông báo giả.
Future<void> _openTab(WidgetTester tester, int index, String screenKey) async {
  final screen = find.byKey(Key(screenKey));
  if (screen.evaluate().isEmpty) {
    await _tap(tester, find.byKey(Key('route-dock-tab-$index')));
    await _pumpUntil(tester, screen);
    await _pumpFor(tester, const Duration(milliseconds: 600));
  }
  _expectNoPlaceholder();
}

/// Mở app, chờ animation màn đăng nhập rồi vào chế độ khách (trang chủ).
Future<void> _enterGuestMode(WidgetTester tester) async {
  await tester.pumpWidget(const PassengerApp());
  // Màn đăng nhập chạy animation vào — chờ xong mới bấm được nút khách.
  // Lần mở đầu (máy ảo còn nguội) animation có thể chậm hơn: bấm lại tới khi vào được.
  final home = find.byKey(const Key('origin-input'));
  for (var attempt = 0; attempt < 5 && home.evaluate().isEmpty; attempt++) {
    await _pumpFor(tester, const Duration(seconds: 3));
    final guest = find.byKey(const Key('guest-button'));
    if (guest.evaluate().isNotEmpty) {
      await tester.tap(guest, warnIfMissed: false);
    }
  }
  await _pumpUntil(tester, home);
  await _pumpFor(tester, const Duration(seconds: 2));
}

/// Mở app, vào chế độ khách, tìm TP. Hồ Chí Minh → Lâm Đồng ngày mai, mở chuyến đầu danh sách. Trả `tripId`.
Future<String> _searchFirstTrip(WidgetTester tester) async {
  await _enterGuestMode(tester);
  await _pickLocation(tester, const Key('origin-input'), 'Hồ Chí Minh');
  await _pickLocation(tester, const Key('destination-input'), 'Lâm Đồng');
  await _tap(tester, find.byKey(const Key('home-search-button')));

  // Trang chủ "Tìm chuyến" mở màn Kết quả (không còn chuyển sang tab Mua vé).
  final firstTrip = find.byWidgetPredicate(
    (widget) =>
        widget.key is ValueKey<String> &&
        (widget.key! as ValueKey<String>).value.startsWith('results-trip-'),
  );
  await _pumpUntil(tester, firstTrip);
  final tripId = (tester.widget(firstTrip.first).key! as ValueKey<String>).value
      .substring('results-trip-'.length);
  await _tap(tester, firstTrip.first);
  await _pumpUntil(tester, find.byKey(const Key('trip-detail-cta')));
  await _pumpUntil(
    tester,
    find.byWidgetPredicate(
      (widget) =>
          widget.key == const Key('trip-detail-cta') &&
          widget is ButtonStyleButton &&
          widget.onPressed != null,
    ),
  );
  return tripId;
}

/// Từ chi tiết chuyến: sang sơ đồ, chọn chỗ trống đầu tiên, giữ chỗ → màn thông tin hành khách. Trả mã chỗ.
Future<String> _holdFirstFreeSeat(WidgetTester tester) async {
  await _tap(tester, find.byKey(const Key('trip-detail-cta')));
  final freeSeat = find.byWidgetPredicate(
    (widget) =>
        widget is InkWell &&
        widget.key is ValueKey<String> &&
        RegExp(r'^seat-[A-Z]+\d+$')
            .hasMatch((widget.key! as ValueKey<String>).value) &&
        widget.onTap != null,
  );
  await _pumpUntil(tester, freeSeat);
  final seat = (tester.widget(freeSeat.first).key! as ValueKey<String>).value
      .substring('seat-'.length);
  await _tap(tester, freeSeat.first);
  await _tap(tester, find.byKey(const Key('seat-selection-continue')));
  await _pumpUntil(
    tester,
    find.byKey(const Key('passenger-information-screen')),
  );
  return seat;
}

/// Mở ô địa điểm [field], gõ [keyword], chọn tỉnh / thành đầu tiên khớp.
Future<void> _pickLocation(
  WidgetTester tester,
  Key field,
  String keyword,
) async {
  await _tap(tester, find.byKey(field));
  await _enter(tester, const Key('location-search-field'), keyword);
  final option = find.descendant(
    of: find.byType(ListTile),
    matching: find.textContaining(keyword),
  );
  await _pumpUntil(tester, option);
  await tester.tap(option.first);
  await tester.pump(const Duration(milliseconds: 500));
}

Future<void> _enter(WidgetTester tester, Key key, String text) async {
  final field = find.byKey(key);
  await _pumpUntil(tester, field);
  await tester.ensureVisible(field);
  await tester.pump();
  await tester.enterText(field, text);
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await _pumpUntil(tester, finder);
  await tester.ensureVisible(finder.first);
  await tester.pump(const Duration(milliseconds: 200));
  await tester.tap(finder.first);
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> _pumpFor(WidgetTester tester, Duration duration) async {
  final end = DateTime.now().add(duration);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Pump tới khi [finder] thấy widget — không dùng `pumpAndSettle` vì app có animation chạy liên tục.
Future<void> _pumpUntil(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  final end = DateTime.now().add(timeout);
  while (finder.evaluate().isEmpty) {
    if (DateTime.now().isAfter(end)) {
      throw TestFailure('Hết ${timeout.inSeconds}s vẫn không thấy: $finder');
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
}
