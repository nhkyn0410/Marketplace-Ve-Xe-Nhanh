// Chỉ thử điều hướng WebView bằng trang công khai example.com.
// Không tạo booking, thanh toán hoặc gọi API production.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:passenger_mobile/features/ticket/vnpay_checkout_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('WebView Android giữ phiên khi mở lại và chặn URL quay về', (
    tester,
  ) async {
    const bookingId = 'test-return';
    final returnUri = Uri.https(
      'example.com',
      '/bookings/$bookingId/payment/result',
    );
    final paymentUri = Uri.https('example.com', '/', {
      'vnp_ReturnUrl': returnUri.toString(),
    });
    bool? returned;
    final session = VnpayCheckoutSession();

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            key: const Key('vnpay-return-host'),
            body: Center(
              child: FilledButton(
                key: const Key('open-vnpay-test'),
                onPressed: () async {
                  returned = await openVnpayCheckout(
                    context,
                    paymentUrl: paymentUri,
                    bookingId: bookingId,
                    session: session,
                  );
                },
                child: const Text('Mở trang thử VNPay'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('open-vnpay-test')));
    await tester.pump();

    await _waitUntil(tester, () async {
      final webviews = find.byType(WebViewWidget);
      if (webviews.evaluate().isEmpty) return false;
      final controller = tester
          .widget<WebViewWidget>(webviews)
          .platform
          .params
          .controller;
      final current = Uri.tryParse(await controller.currentUrl() ?? '');
      if (current?.host != 'example.com') return false;
      Object? document = await controller.runJavaScriptReturningResult(
        'JSON.stringify({href: window.location.href, '
        'readyState: document.readyState})',
      );
      // Android có thể trả nguyên JSON hoặc một chuỗi JSON đã bọc dấu nháy.
      for (var depth = 0; depth < 2 && document is String; depth++) {
        document = jsonDecode(document);
      }
      if (document is! Map<String, dynamic>) return false;
      final href = document['href'];
      final documentUrl = href is String ? Uri.tryParse(href) : null;
      return documentUrl?.scheme == paymentUri.scheme &&
          documentUrl?.host == paymentUri.host &&
          documentUrl?.path == paymentUri.path &&
          documentUrl?.query == paymentUri.query &&
          document['readyState'] == 'complete' &&
          find.byKey(const Key('vnpay-checkout-loading')).evaluate().isEmpty;
    }, 'WebView chưa tải xong trang example.com');

    final controller = tester
        .widget<WebViewWidget>(find.byType(WebViewWidget))
        .platform
        .params
        .controller;
    await controller.runJavaScript(
      'document.documentElement.setAttribute('
      '"data-vnpay-session-marker", "retained-native-session");',
    );
    await tester.tap(find.byKey(const Key('vnpay-checkout-close')));
    await _waitUntil(
      tester,
      () async =>
          returned == true && find.byType(WebViewWidget).evaluate().isEmpty,
      'WebView không đóng sau khi bấm đóng phiên thử',
    );
    returned = null;
    await tester.tap(find.byKey(const Key('open-vnpay-test')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    final reopenedController = tester
        .widget<WebViewWidget>(find.byType(WebViewWidget))
        .platform
        .params
        .controller;
    expect(identical(reopenedController, controller), isTrue);
    expect(await reopenedController.currentUrl(), paymentUri.toString());
    Object? retainedDocument = await reopenedController
        .runJavaScriptReturningResult(
          'JSON.stringify({href: window.location.href, '
          'marker: document.documentElement.getAttribute("data-vnpay-session-marker")})',
        );
    for (var depth = 0; depth < 2 && retainedDocument is String; depth++) {
      retainedDocument = jsonDecode(retainedDocument);
    }
    expect(retainedDocument, isA<Map<String, dynamic>>());
    final retained = retainedDocument as Map<String, dynamic>;
    expect(retained['href'], paymentUri.toString());
    expect(
      retained['marker'],
      'retained-native-session',
      reason:
          'Đóng rồi mở lại phải giữ DOM của phiên, không tải lại trang đầu.',
    );
    // Mã trả về chỉ đánh thức app; không được dùng làm bằng chứng đã trả tiền.
    final callback = returnUri.replace(
      queryParameters: {'vnp_ResponseCode': '00'},
    );
    await controller.runJavaScript(
      'window.location.href = ${jsonEncode(callback.toString())};',
    );

    await _waitUntil(
      tester,
      () async =>
          returned != null && find.byType(WebViewWidget).evaluate().isEmpty,
      'WebView không đóng sau khi điều hướng tới URL quay về',
      diagnostics: () async {
        final details = <String, Object?>{
          'returned': returned,
          'checkoutVisible': find
              .byKey(const Key('vnpay-checkout-screen'))
              .evaluate()
              .isNotEmpty,
          'retryVisible': find
              .byKey(const Key('vnpay-checkout-retry'))
              .evaluate()
              .isNotEmpty,
          'loadErrorVisible': find
              .textContaining('Không tải được trang thanh toán.')
              .evaluate()
              .isNotEmpty,
        };
        try {
          details['currentUrl'] = await controller.currentUrl().timeout(
            const Duration(seconds: 2),
          );
        } catch (error) {
          details['currentUrlError'] = error.toString();
        }
        try {
          details['document'] = await controller
              .runJavaScriptReturningResult(
                'JSON.stringify({href: window.location.href, '
                'readyState: document.readyState})',
              )
              .timeout(const Duration(seconds: 2));
        } catch (error) {
          details['documentError'] = error.toString();
        }
        return jsonEncode(details);
      },
    );
    expect(returned, isTrue);
    expect(find.byKey(const Key('vnpay-return-host')), findsOneWidget);
    expect(find.byKey(const Key('open-vnpay-test')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _waitUntil(
  WidgetTester tester,
  Future<bool> Function() ready,
  String message, {
  Future<String> Function()? diagnostics,
}) async {
  const timeout = Duration(seconds: 20);
  final elapsed = Stopwatch()..start();
  Object? lastError;
  while (elapsed.elapsed < timeout) {
    try {
      if (await ready().timeout(timeout - elapsed.elapsed)) return;
    } catch (error) {
      lastError = error;
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
  final details = diagnostics == null ? '' : '\n${await diagnostics()}';
  throw TestFailure('$message trong ${timeout.inSeconds}s. $lastError$details');
}
