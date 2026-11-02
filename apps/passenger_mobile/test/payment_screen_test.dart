import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/ticket/booking_flow_chrome.dart';
import 'package:passenger_mobile/features/ticket/payment_models.dart';
import 'package:passenger_mobile/features/ticket/payment_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'support/fake_booking_api.dart';

Future<FakeBookingApi> _pumpScreen(
  WidgetTester tester, {
  FakeBookingApi? api,
  double width = 412,
  double height = 900,
  DateTime Function()? now,
  Future<bool> Function(Uri)? launch,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  final actualApi = api ?? FakeBookingApi();
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Be Vietnam Pro',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E8ABE)),
      ),
      home: PaymentScreen(
        api: actualApi,
        booking: sampleBooking(),
        now: now,
        launchPaymentUrl: launch ?? (_) async => true,
      ),
    ),
  );
  await tester.pump();
  return actualApi;
}

Future<void> _pay(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('payment-submit')));
  await tester.pumpAndSettle();
}

Future<void> _show(WidgetTester tester, Key key) async {
  await tester.scrollUntilVisible(
    find.byKey(key),
    240,
    scrollable: find
        .descendant(
          of: find.byKey(const Key('payment-scroll')),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('màn chọn riêng có logo MoMo/VNPay và chưa tạo payment', (
    tester,
  ) async {
    final api = await _pumpScreen(tester);
    expect(find.text('Phương thức thanh toán'), findsOneWidget);
    expect(find.byKey(const Key('payment-checkout-screen')), findsNothing);
    expect(api.payments, isEmpty);
    await _show(tester, const Key('payment-method-MOMO'));
    expect(
      tester.widget<Image>(find.byKey(const Key('payment-logo-MOMO'))).image,
      isA<ResizeImage>(),
    );
    await _show(tester, const Key('payment-method-VNPAY'));
    expect(find.byKey(const Key('payment-logo-VNPAY')), findsOneWidget);
    expect(find.byKey(const Key('payment-transfer-qr')), findsNothing);
  });

  for (final method in [
    PassengerPaymentMethod.momo,
    PassengerPaymentMethod.vnpay,
  ]) {
    testWidgets(
      'chọn ${method.apiValue} mở đúng cổng trên màn thực hiện riêng',
      (tester) async {
        final launched = <Uri>[];
        final api = FakeBookingApi()
          ..paymentStarter = (booking, selected) async => BookingPaymentSession(
            paymentId: 'payment-${selected.apiValue}',
            paymentUrl: Uri.https(
              '${selected.apiValue.toLowerCase()}.example.com',
              '/checkout',
            ),
            expiresAt: booking.expiresAt,
          );
        await _pumpScreen(
          tester,
          api: api,
          launch: (uri) async {
            launched.add(uri);
            return true;
          },
        );
        await _show(tester, Key('payment-method-${method.apiValue}'));
        await tester.tap(find.byKey(Key('payment-method-${method.apiValue}')));
        expect(api.payments, isEmpty);
        await _pay(tester);
        expect(
          find.byKey(const Key('payment-checkout-screen')),
          findsOneWidget,
        );
        expect(find.text('Chọn phương thức thanh toán'), findsNothing);
        expect(api.payments, [method]);
        expect(
          launched.single.host,
          '${method.apiValue.toLowerCase()}.example.com',
        );
        expect(find.text(method.openLabel), findsOneWidget);
        expect(find.byKey(const Key('payment-transfer-qr')), findsNothing);
        expect(
          find.byKey(const Key('payment-completion-screen')),
          findsNothing,
        );
      },
    );
  }

  testWidgets('quay lại đổi cổng giữ nguyên đơn và hạn thanh toán', (
    tester,
  ) async {
    final now = DateTime.now();
    final api = await _pumpScreen(tester, now: () => now);
    final deadline = tester
        .widget<BookingFlowHeader>(find.byType(BookingFlowHeader))
        .timerLabel;
    await _pay(tester);
    await tester.tap(find.byKey(const Key('payment-back')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('payment-screen')), findsOneWidget);
    expect(
      tester
          .widget<BookingFlowHeader>(find.byType(BookingFlowHeader))
          .timerLabel,
      deadline,
    );
    await _show(tester, const Key('payment-method-MOMO'));
    await tester.tap(find.byKey(const Key('payment-method-MOMO')));
    await _pay(tester);
    expect(api.payments, [
      PassengerPaymentMethod.payos,
      PassengerPaymentMethod.momo,
    ]);
    expect(api.bookings, isEmpty);
  });

  testWidgets(
    'đã nhận tiền lúc quay về chọn cổng thì hiện vé, không tạo payment khác',
    (tester) async {
      final api = await _pumpScreen(tester);
      await _pay(tester);
      api.confirmAfterPayment = true;
      await tester.tap(find.byKey(const Key('payment-back')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('payment-completion-screen')),
        findsOneWidget,
      );
      expect(api.payments, [PassengerPaymentMethod.payos]);
    },
  );

  testWidgets(
    'hiện đơn thật và tạo payOS; không báo thành công khi mới có link',
    (tester) async {
      final api = await _pumpScreen(tester);
      expect(find.text('Trần Thị Bình'), findsOneWidget);
      expect(find.text('-50.000 ₫'), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const Key('payment-order-total'))).data,
        '550.000 ₫',
      );
      await _pay(tester);
      expect(api.payments, [PassengerPaymentMethod.payos]);
      expect(find.byKey(const Key('payment-completion-screen')), findsNothing);
      await _show(tester, const Key('payment-transfer-qr'));
      expect(find.byKey(const Key('payment-transfer-qr')), findsOneWidget);
      expect(find.textContaining('VNPay'), findsNothing);
      expect(find.textContaining('MoMo'), findsNothing);
    },
  );

  testWidgets('khóa lần bấm thứ hai trong khi đang tạo payment', (
    tester,
  ) async {
    final pending = Completer<BookingPaymentSession>();
    final api = FakeBookingApi()..paymentStarter = (_, _) => pending.future;
    await _pumpScreen(tester, api: api);
    await tester.tap(find.byKey(const Key('payment-submit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('payment-submit')), warnIfMissed: false);
    await tester.pump();
    expect(api.payments, hasLength(1));
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('payment-submit')))
          .onPressed,
      isNull,
    );
    pending.complete(
      BookingPaymentSession(
        paymentId: 'payment',
        paymentUrl: Uri.parse('https://pay.payos.vn/web/payment'),
        expiresAt: sampleBooking().expiresAt,
      ),
    );
    await tester.pumpAndSettle();
  });

  testWidgets('sao chép đúng nội dung chuyển khoản và mở deeplink ngân hàng', (
    tester,
  ) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    final launched = <Uri>[];
    await _pumpScreen(
      tester,
      launch: (uri) async {
        launched.add(uri);
        return true;
      },
    );
    await _pay(tester);
    await _show(tester, const Key('payment-copy-description'));
    await tester.tap(find.byKey(const Key('payment-copy-description')));
    await tester.pump();
    expect(copied, 'VXN123456');
    await _show(tester, const Key('payment-open-bank'));
    await tester.tap(find.byKey(const Key('payment-open-bank')));
    await tester.pump();
    final uri = launched.single;
    expect(uri.host, 'dl.vietqr.io');
    expect(uri.queryParameters['ba'], '123456789@mb');
    expect(uri.queryParameters['am'], '550000');
    expect(uri.queryParameters['tn'], 'VXN123456');
    expect(find.byKey(const Key('payment-completion-screen')), findsNothing);
  });

  testWidgets('cổng demo mở link ngoài và vẫn chờ xác nhận của máy chủ', (
    tester,
  ) async {
    final launched = <Uri>[];
    final api = await _pumpScreen(
      tester,
      launch: (uri) async {
        launched.add(uri);
        return true;
      },
    );
    await _show(tester, const Key('payment-method-DEMO'));
    await tester.tap(find.byKey(const Key('payment-method-DEMO')));
    await _pay(tester);
    expect(api.payments, [PassengerPaymentMethod.demo]);
    expect(launched, hasLength(1));
    expect(find.byKey(const Key('payment-completion-screen')), findsNothing);
  });

  testWidgets(
    'poll nhận vé thật rồi mới mở hoàn tất, không hiện QR và mã mẫu',
    (tester) async {
      final api = await _pumpScreen(tester);
      await _pay(tester);
      api.confirmAfterPayment = true;
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('payment-completion-screen')),
        findsOneWidget,
      );
      expect(find.text('Mã vé: TKT-A01'), findsOneWidget);
      expect(find.text('Phương Trang'), findsNothing);
      expect(find.byKey(const Key('ticket-issued-qr')), findsOneWidget);
      expect(find.byType(QrImageView), findsOneWidget);
      expect(tester.takeException(), isNull);
      final loads = api.paymentStateLoads;
      await tester.pump(const Duration(seconds: 8));
      expect(api.paymentStateLoads, loads);
    },
  );

  testWidgets('không poll khi nền; quay lại app kiểm tra ngay', (tester) async {
    final api = await _pumpScreen(tester);
    final initial = api.paymentStateLoads;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump(const Duration(seconds: 8));
    expect(api.paymentStateLoads, initial);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(api.paymentStateLoads, initial + 1);
    await tester.pumpWidget(const SizedBox());
    final disposed = api.paymentStateLoads;
    await tester.pump(const Duration(seconds: 8));
    expect(api.paymentStateLoads, disposed);
  });

  testWidgets('quá hạn thanh toán thì báo hết hạn và khóa tạo link', (
    tester,
  ) async {
    final api = await _pumpScreen(
      tester,
      now: () => DateTime.now().add(const Duration(minutes: 9)),
    );
    expect(find.text('Đã hết hạn'), findsOneWidget);
    expect(find.textContaining('đã quá hạn thanh toán'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('payment-submit')))
          .onPressed,
      isNull,
    );
    expect(api.payments, isEmpty);
  });

  testWidgets('đối soát khóa thanh toán và không phát hành vé trên app', (
    tester,
  ) async {
    final api = FakeBookingApi()
      ..paymentState = const BookingPaymentState(
        bookingStatus: 'PENDING_PAYMENT',
        paymentStatus: 'RECONCILING',
      );
    await _pumpScreen(tester, api: api);
    await _show(tester, const Key('payment-reconciling'));
    expect(find.textContaining('không chuyển tiền thêm'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('payment-submit')))
          .onPressed,
      isNull,
    );
    expect(find.byKey(const Key('payment-completion-screen')), findsNothing);
  });

  testWidgets('lỗi mạng hiện cách khắc phục và cho phép kiểm tra lại', (
    tester,
  ) async {
    final api = FakeBookingApi()
      ..paymentStateLoader = () async => throw const ApiFailure(
        status: 0,
        code: 'NETWORK_ERROR',
        detail: 'network',
      );
    await _pumpScreen(tester, api: api);
    await _show(tester, const Key('payment-error'));
    expect(find.textContaining('kiểm tra mạng'), findsOneWidget);
    api.paymentStateLoader = null;
    await _show(tester, const Key('payment-refresh'));
    await tester.tap(find.byKey(const Key('payment-refresh')));
    await tester.pump();
    expect(find.byKey(const Key('payment-error')), findsNothing);
  });

  testWidgets(
    'cổng chưa bật báo lỗi cụ thể, không chuyển sang thanh toán giả',
    (tester) async {
      final api = FakeBookingApi()
        ..paymentStarter = (_, _) async => throw const ApiFailure(
          status: 503,
          code: 'PAYMENT_PROVIDER_UNAVAILABLE',
          detail: 'Unavailable',
        );
      await _pumpScreen(tester, api: api);
      await _pay(tester);
      await _show(tester, const Key('payment-error'));
      expect(
        find.textContaining('Phương thức này chưa được bật'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('payment-checkout-card')), findsNothing);
    },
  );

  testWidgets(
    'viewport 320x568 không overflow khi hiện QR và thông tin chuyển khoản',
    (tester) async {
      await _pumpScreen(tester, width: 320, height: 568);
      await _pay(tester);
      await _show(tester, const Key('payment-open-bank'));
      expect(tester.takeException(), isNull);
    },
  );
}
