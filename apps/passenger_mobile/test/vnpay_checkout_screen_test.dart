import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passenger_mobile/features/ticket/vnpay_checkout_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart'
    as platform;

const _bookingId = 'booking-123';
final _returnUrl = Uri.parse(
  'https://vexenhanh.id.vn/bookings/$_bookingId/payment/result',
);

Uri _paymentUrl({String? returnUrl}) =>
    Uri.https('sandbox.vnpayment.vn', '/paymentv2/vpcpay.html', {
      'vnp_ReturnUrl': returnUrl ?? _returnUrl.toString(),
      'vnp_SecureHash': 'signed-value',
    });

class _FakeWebViewPlatform extends platform.WebViewPlatform {
  late _FakeController controller;
  late _FakeDelegate delegate;
  bool autoFinish = true;
  int controllerCount = 0;

  @override
  platform.PlatformWebViewController createPlatformWebViewController(
    platform.PlatformWebViewControllerCreationParams params,
  ) {
    controllerCount++;
    return controller = _FakeController(params, this);
  }

  @override
  platform.PlatformNavigationDelegate createPlatformNavigationDelegate(
    platform.PlatformNavigationDelegateCreationParams params,
  ) => delegate = _FakeDelegate(params);

  @override
  platform.PlatformWebViewWidget createPlatformWebViewWidget(
    platform.PlatformWebViewWidgetCreationParams params,
  ) => _FakeWebViewWidget(params);
}

class _FakeController extends platform.PlatformWebViewController {
  _FakeController(super.params, this.owner) : super.implementation();

  final _FakeWebViewPlatform owner;
  final loaded = <Uri>[];
  JavaScriptMode? javaScriptMode;
  String? documentMarker;

  @override
  Future<void> setJavaScriptMode(JavaScriptMode mode) async {
    javaScriptMode = mode;
  }

  @override
  Future<void> setPlatformNavigationDelegate(
    platform.PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> loadRequest(platform.LoadRequestParams params) async {
    loaded.add(params.uri);
    owner.delegate.pageStarted?.call(params.uri.toString());
    if (owner.autoFinish) {
      owner.delegate.pageFinished?.call(params.uri.toString());
    }
  }
}

class _FakeDelegate extends platform.PlatformNavigationDelegate {
  _FakeDelegate(super.params) : super.implementation();

  platform.NavigationRequestCallback? navigate;
  platform.PageEventCallback? pageStarted;
  platform.PageEventCallback? pageFinished;
  platform.WebResourceErrorCallback? resourceError;
  platform.SslAuthErrorCallback? sslError;

  @override
  Future<void> setOnNavigationRequest(
    platform.NavigationRequestCallback callback,
  ) async {
    navigate = callback;
  }

  @override
  Future<void> setOnPageStarted(platform.PageEventCallback callback) async {
    pageStarted = callback;
  }

  @override
  Future<void> setOnPageFinished(platform.PageEventCallback callback) async {
    pageFinished = callback;
  }

  @override
  Future<void> setOnWebResourceError(
    platform.WebResourceErrorCallback callback,
  ) async {
    resourceError = callback;
  }

  @override
  Future<void> setOnSSlAuthError(platform.SslAuthErrorCallback callback) async {
    sslError = callback;
  }
}

class _FakeWebViewWidget extends platform.PlatformWebViewWidget {
  _FakeWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) =>
      const SizedBox.expand(key: Key('fake-vnpay-webview'));
}

class _FakeSslError extends platform.PlatformSslAuthError {
  _FakeSslError() : super(certificate: null, description: 'test TLS error');

  bool cancelled = false;
  bool proceeded = false;

  @override
  Future<void> cancel() async {
    cancelled = true;
  }

  @override
  Future<void> proceed() async {
    proceeded = true;
  }
}

Future<Completer<bool>> _open(
  WidgetTester tester,
  _FakeWebViewPlatform fake, {
  VnpayCheckoutSession? session,
  Uri? paymentUrl,
}) async {
  final closed = Completer<bool>();
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: FilledButton(
            onPressed: () async => closed.complete(
              await openVnpayCheckout(
                context,
                paymentUrl: paymentUrl ?? _paymentUrl(),
                bookingId: _bookingId,
                session: session,
              ),
            ),
            child: const Text('Mở VNPay'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Mở VNPay'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  if (fake.autoFinish) await tester.pumpAndSettle();
  return closed;
}

void main() {
  late _FakeWebViewPlatform fake;
  setUp(() {
    fake = _FakeWebViewPlatform();
    platform.WebViewPlatform.instance = fake;
  });

  test('lấy callback đúng đơn mà không sửa URL thanh toán đã ký', () {
    final payment = _paymentUrl();
    final before = payment.toString();
    expect(vnpayReturnUrlForBooking(payment, _bookingId), _returnUrl);
    expect(payment.toString(), before);
  });

  test('từ chối callback thiếu, lặp, sai dạng, sai đơn hoặc có thông tin đăng nhập', () {
    final invalid = [
      Uri.parse('https://sandbox.vnpayment.vn/paymentv2/vpcpay.html'),
      Uri.parse(
        '${_paymentUrl()}&vnp_ReturnUrl=${Uri.encodeQueryComponent(_returnUrl.toString())}',
      ),
      for (final value in [
        '',
        'http://[',
        '/bookings/$_bookingId/payment/result',
        'javascript:alert(1)',
        'file:///bookings/$_bookingId/payment/result',
        'https://user@vexenhanh.id.vn/bookings/$_bookingId/payment/result',
        'https://vexenhanh.id.vn/bookings/other/payment/result',
        'https://vexenhanh.id.vn/bookings/$_bookingId/payment/result/extra',
        'https://vexenhanh.id.vn/bookings/$_bookingId/payment/result#other',
      ])
        _paymentUrl(returnUrl: value),
    ];
    for (final payment in invalid) {
      expect(
        () => vnpayReturnUrlForBooking(payment, _bookingId),
        throwsFormatException,
      );
    }
    expect(
      () => vnpayReturnUrlForBooking(_paymentUrl(), '../other'),
      throwsFormatException,
    );
  });

  test('callback khớp nguồn và đường dẫn; mã thành công hay hủy đều chỉ là tín hiệu quay về', () {
    for (final code in ['00', '24', '99']) {
      expect(
        matchesVnpayReturnUrl(
          _returnUrl.replace(queryParameters: {'vnp_ResponseCode': code}),
          _returnUrl,
        ),
        isTrue,
      );
    }
    expect(
      matchesVnpayReturnUrl(
        Uri.parse(
          'https://vexenhanh.id.vn:443/bookings/$_bookingId/payment/result',
        ),
        _returnUrl,
      ),
      isTrue,
    );
    for (final uri in [
      _returnUrl.replace(host: 'foreign.test'),
      _returnUrl.replace(host: 'vexenhanh.id.vn.foreign.test'),
      _returnUrl.replace(scheme: 'http'),
      _returnUrl.replace(port: 444),
      _returnUrl.replace(path: '/bookings/other/payment/result'),
      _returnUrl.replace(path: '${_returnUrl.path}/'),
      _returnUrl.replace(userInfo: 'user'),
    ]) {
      expect(matchesVnpayReturnUrl(uri, _returnUrl), isFalse);
    }
  });

  testWidgets(
    'mở nguyên URL đã ký trong WebView và chỉ đóng một lần khi nhận callback',
    (tester) async {
      for (final code in ['00', '24']) {
        final closed = await _open(tester, fake);
        expect(fake.controller.loaded.single, _paymentUrl());
        expect(fake.controller.javaScriptMode, JavaScriptMode.unrestricted);
        expect(find.byKey(const Key('fake-vnpay-webview')), findsOneWidget);
        final navigate = fake.delegate.navigate!;
        final request = NavigationRequest(
          url: _returnUrl
              .replace(queryParameters: {'vnp_ResponseCode': code})
              .toString(),
          isMainFrame: true,
        );
        expect(await navigate(request), NavigationDecision.prevent);
        expect(await navigate(request), NavigationDecision.prevent);
        await tester.pumpAndSettle();
        expect(await closed.future, isTrue);
        expect(find.byKey(const Key('vnpay-checkout-screen')), findsNothing);
        expect(find.text('Mở VNPay'), findsOneWidget);
      }
    },
  );

  testWidgets('iframe, host lạ và đơn khác không đóng trang VNPay', (
    tester,
  ) async {
    final closed = await _open(tester, fake);
    for (final request in [
      NavigationRequest(url: _returnUrl.toString(), isMainFrame: false),
      NavigationRequest(
        url: _returnUrl.replace(host: 'foreign.test').toString(),
        isMainFrame: true,
      ),
      NavigationRequest(
        url: _returnUrl
            .replace(path: '/bookings/other/payment/result')
            .toString(),
        isMainFrame: true,
      ),
    ]) {
      expect(
        await fake.delegate.navigate!(request),
        NavigationDecision.navigate,
      );
    }
    await tester.pump();
    expect(closed.isCompleted, isFalse);
    expect(find.byKey(const Key('vnpay-checkout-screen')), findsOneWidget);
    await tester.tap(find.byKey(const Key('vnpay-checkout-close')));
    await tester.pumpAndSettle();
    expect(await closed.future, isTrue);
  });

  testWidgets(
    'hiện tiến độ; lỗi khung phụ không chặn, lỗi trang chính có Thử lại',
    (tester) async {
      fake.autoFinish = false;
      final closed = await _open(tester, fake);
      expect(find.byKey(const Key('vnpay-checkout-loading')), findsOneWidget);
      fake.delegate.resourceError!(
        const WebResourceError(
          errorCode: -2,
          description: 'subresource',
          isForMainFrame: false,
        ),
      );
      await tester.pump();
      expect(find.byKey(const Key('vnpay-checkout-retry')), findsNothing);
      fake.delegate.resourceError!(
        const WebResourceError(
          errorCode: -2,
          description: 'main resource',
          isForMainFrame: true,
        ),
      );
      fake.delegate.pageFinished!(_paymentUrl().toString());
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('vnpay-checkout-retry')), findsOneWidget);
      expect(closed.isCompleted, isFalse);
      fake.autoFinish = true;
      await tester.tap(find.byKey(const Key('vnpay-checkout-retry')));
      await tester.pumpAndSettle();
      expect(fake.controller.loaded, [_paymentUrl(), _paymentUrl()]);
      expect(find.byKey(const Key('vnpay-checkout-retry')), findsNothing);
      await tester.tap(find.byKey(const Key('vnpay-checkout-back')));
      await tester.pumpAndSettle();
      expect(await closed.future, isTrue);
    },
  );

  testWidgets('không mở scheme ngoài HTTP và không bỏ qua lỗi TLS', (
    tester,
  ) async {
    final closed = await _open(tester, fake);
    for (final value in [
      'file:///private/data',
      'javascript:alert(1)',
      'intent://bank/#Intent;end',
    ]) {
      expect(
        await fake.delegate.navigate!(
          NavigationRequest(url: value, isMainFrame: true),
        ),
        NavigationDecision.prevent,
      );
    }
    final ssl = _FakeSslError();
    fake.delegate.sslError!(ssl);
    await tester.pumpAndSettle();
    expect(ssl.cancelled, isTrue);
    expect(ssl.proceeded, isFalse);
    expect(closed.isCompleted, isFalse);
    await tester.tap(find.byKey(const Key('vnpay-checkout-close')));
    await tester.pumpAndSettle();
    expect(await closed.future, isTrue);
  });

  testWidgets(
    'trang quay về tải trực tiếp vẫn đóng một lần, không tin mã kết quả',
    (tester) async {
      for (final code in ['00', '24']) {
        final closed = await _open(tester, fake);
        final pageStarted = fake.delegate.pageStarted!;
        pageStarted(_returnUrl.replace(host: 'foreign.test').toString());
        await tester.pump();
        expect(closed.isCompleted, isFalse);
        final callback = _returnUrl
            .replace(queryParameters: {'vnp_ResponseCode': code})
            .toString();
        pageStarted(callback);
        pageStarted(callback);
        await tester.pumpAndSettle();
        expect(await closed.future, isTrue);
        expect(find.byKey(const Key('vnpay-checkout-screen')), findsNothing);
        expect(find.text('Mở VNPay'), findsOneWidget);
      }
    },
  );

  testWidgets(
    'Back hệ thống rồi callback đến muộn không pop thêm màn ứng dụng',
    (tester) async {
      final closed = await _open(tester, fake);
      final navigate = fake.delegate.navigate!;
      await tester.binding.handlePopRoute();
      expect(
        await navigate(
          NavigationRequest(url: _returnUrl.toString(), isMainFrame: true),
        ),
        NavigationDecision.prevent,
      );
      await tester.pumpAndSettle();
      expect(await closed.future, isTrue);
      expect(find.text('Mở VNPay'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'giữ controller và trang xác nhận khi đóng rồi mở lại cùng phiên',
    (tester) async {
      final session = VnpayCheckoutSession();
      addTearDown(session.dispose);
      expect(fake.controllerCount, 0);
      final first = await _open(tester, fake, session: session);
      final controller = fake.controller;
      controller.documentMarker = 'otp-page-state';
      fake.delegate.pageStarted!(
        'https://sandbox.vnpayment.vn/paymentv2/Confirm.html',
      );
      fake.delegate.pageFinished!(
        'https://sandbox.vnpayment.vn/paymentv2/Confirm.html',
      );
      await tester.tap(find.byKey(const Key('vnpay-checkout-close')));
      await tester.pumpAndSettle();
      expect(await first.future, isTrue);

      final second = await _open(tester, fake, session: session);
      expect(fake.controllerCount, 1);
      expect(identical(fake.controller, controller), isTrue);
      expect(controller.loaded, [_paymentUrl()]);
      expect(controller.documentMarker, 'otp-page-state');
      await tester.tap(find.byKey(const Key('vnpay-checkout-close')));
      await tester.pumpAndSettle();
      expect(await second.future, isTrue);
    },
  );

  testWidgets(
    'redirect lúc ẩn vẫn chạy; callback chỉ ghi nhận rồi không mở lại cổng',
    (tester) async {
      final session = VnpayCheckoutSession();
      addTearDown(session.dispose);
      final first = await _open(tester, fake, session: session);
      final navigate = fake.delegate.navigate!;
      await tester.tap(find.byKey(const Key('vnpay-checkout-close')));
      await tester.pumpAndSettle();
      expect(await first.future, isTrue);
      expect(
        await navigate(
          const NavigationRequest(
            url: 'https://sandbox.vnpayment.vn/paymentv2/Confirm.html',
            isMainFrame: true,
          ),
        ),
        NavigationDecision.navigate,
      );
      expect(
        await navigate(
          NavigationRequest(
            url: _returnUrl
                .replace(queryParameters: {'vnp_ResponseCode': '24'})
                .toString(),
            isMainFrame: true,
          ),
        ),
        NavigationDecision.prevent,
      );
      await tester.pumpAndSettle();
      expect(find.text('Mở VNPay'), findsOneWidget);
      expect(tester.takeException(), isNull);

      final second = await _open(tester, fake, session: session);
      expect(await second.future, isTrue);
      expect(find.byKey(const Key('vnpay-checkout-screen')), findsNothing);
      expect(fake.controllerCount, 1);
      expect(fake.controller.loaded, [_paymentUrl()]);
    },
  );

  testWidgets('hai yêu cầu mở cùng phiên chỉ hiển thị một trang', (
    tester,
  ) async {
    final session = VnpayCheckoutSession();
    addTearDown(session.dispose);
    final first = await _open(tester, fake, session: session);
    final second = openVnpayCheckout(
      tester.element(find.byKey(const Key('vnpay-checkout-screen'))),
      paymentUrl: _paymentUrl(),
      bookingId: _bookingId,
      session: session,
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('vnpay-checkout-screen')), findsOneWidget);
    expect(fake.controllerCount, 1);
    await tester.tap(find.byKey(const Key('vnpay-checkout-close')));
    await tester.pumpAndSettle();
    expect(await first.future, isTrue);
    expect(await second, isTrue);
  });

  testWidgets(
    'URL mới cùng đơn dùng phiên mới; callback cũ không tác động phiên mới',
    (tester) async {
      final session = VnpayCheckoutSession();
      addTearDown(session.dispose);
      final first = await _open(tester, fake, session: session);
      final oldDelegate = fake.delegate;
      await tester.tap(find.byKey(const Key('vnpay-checkout-close')));
      await tester.pumpAndSettle();
      expect(await first.future, isTrue);
      final nextUrl = _paymentUrl().replace(
        queryParameters: {
          ..._paymentUrl().queryParameters,
          'vnp_SecureHash': 'new-signed-value',
        },
      );
      final next = await _open(
        tester,
        fake,
        session: session,
        paymentUrl: nextUrl,
      );
      expect(fake.controllerCount, 2);
      expect(fake.controller.loaded, [nextUrl]);
      oldDelegate.pageStarted!(_returnUrl.toString());
      expect(
        await oldDelegate.navigate!(
          NavigationRequest(url: _returnUrl.toString(), isMainFrame: true),
        ),
        NavigationDecision.prevent,
      );
      await tester.pumpAndSettle();
      expect(next.isCompleted, isFalse);
      expect(find.byKey(const Key('vnpay-checkout-screen')), findsOneWidget);
      await fake.delegate.navigate!(
        NavigationRequest(url: _returnUrl.toString(), isMainFrame: true),
      );
      await tester.pumpAndSettle();
      expect(await next.future, isTrue);
    },
  );

  testWidgets(
    'lỗi sau bước ngân hàng quay về app, không phát lại URL ban đầu',
    (tester) async {
      final closed = await _open(tester, fake);
      fake.delegate.pageStarted!(
        'https://sandbox.vnpayment.vn/paymentv2/Confirm.html',
      );
      fake.delegate.resourceError!(
        const WebResourceError(
          errorCode: -2,
          description: 'confirmation resource',
          isForMainFrame: true,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Kiểm tra trạng thái trong ứng dụng'), findsOneWidget);
      await tester.tap(find.byKey(const Key('vnpay-checkout-retry')));
      await tester.pumpAndSettle();
      expect(await closed.future, isTrue);
      expect(fake.controller.loaded, [_paymentUrl()]);
    },
  );

  testWidgets(
    'không dùng phiên cho đơn khác hoặc thay URL khi trang cũ còn mở',
    (tester) async {
      final session = VnpayCheckoutSession();
      addTearDown(session.dispose);
      final closed = await _open(tester, fake, session: session);
      final context = tester.element(
        find.byKey(const Key('vnpay-checkout-screen')),
      );
      await expectLater(
        openVnpayCheckout(
          context,
          paymentUrl: _paymentUrl(
            returnUrl: _returnUrl
                .replace(path: '/bookings/other/payment/result')
                .toString(),
          ),
          bookingId: 'other',
          session: session,
        ),
        throwsStateError,
      );
      await expectLater(
        openVnpayCheckout(
          context,
          paymentUrl: _paymentUrl().replace(
            queryParameters: {
              ..._paymentUrl().queryParameters,
              'vnp_SecureHash': 'different-signed-value',
            },
          ),
          bookingId: _bookingId,
          session: session,
        ),
        throwsStateError,
      );
      expect(fake.controllerCount, 1);
      await tester.tap(find.byKey(const Key('vnpay-checkout-close')));
      await tester.pumpAndSettle();
      expect(await closed.future, isTrue);
    },
  );
}
