// Chẩn đoán tùy chọn trên VNPay sandbox; chỉ nhánh CONFIRM_TEST mới dùng
// thẻ giả công khai của VNPay. Không tạo booking hay gọi API production.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:passenger_mobile/features/ticket/vnpay_checkout_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _diagnosticUrl = String.fromEnvironment('VNPAY_DIAGNOSTIC_URL');
const _diagnosticBookingId = String.fromEnvironment(
  'VNPAY_DIAGNOSTIC_BOOKING_ID',
);
const _selectBank = bool.fromEnvironment('VNPAY_DIAGNOSTIC_SELECT_BANK');
const _preserveSession = bool.fromEnvironment(
  'VNPAY_DIAGNOSTIC_PRESERVE_SESSION',
);
const _submitTestOtp = bool.fromEnvironment('VNPAY_DIAGNOSTIC_SUBMIT_TEST_OTP');
const _confirmTest =
    bool.fromEnvironment('VNPAY_DIAGNOSTIC_CONFIRM_TEST') || _submitTestOtp;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'chẩn đoán trang VNPay sandbox khi mở mới và mở lại cùng link',
    (tester) async {
      final paymentUri = Uri.parse(_diagnosticUrl);
      expect(paymentUri.scheme, 'https');
      expect(paymentUri.host, 'sandbox.vnpayment.vn');
      expect(_diagnosticBookingId, isNotEmpty);
      final diagnostics = <Map<String, Object?>>[];
      final session = _preserveSession ? VnpayCheckoutSession() : null;
      var closed = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: FilledButton(
                  key: const Key('open-vnpay-diagnostic'),
                  onPressed: () async {
                    if (await openVnpayCheckout(
                      context,
                      paymentUrl: paymentUri,
                      bookingId: _diagnosticBookingId,
                      session: session,
                    )) {
                      closed++;
                    }
                  },
                  child: const Text('Mở chẩn đoán VNPay sandbox'),
                ),
              ),
            ),
          ),
        ),
      );

      for (final attempt in ['fresh', 'reopened']) {
        await tester.tap(find.byKey(const Key('open-vnpay-diagnostic')));
        await tester.pump();
        final ready = await _waitForDocument(tester);
        final snapshot = await _safeSnapshot(tester);
        final record = <String, Object?>{
          'attempt': attempt,
          'loaded': ready,
          'createDate': paymentUri.queryParameters['vnp_CreateDate'],
          'expireDate': paymentUri.queryParameters['vnp_ExpireDate'],
          ...snapshot,
        };
        diagnostics.add(record);
        // Không xuất URL đầy đủ, chữ ký, nội dung form hay cookie.
        debugPrint('VNPAY_SANDBOX_DIAGNOSTIC ${jsonEncode(record)}');
        if (attempt == 'fresh' && ready) {
          await _printSafeActions(tester);
          if (_selectBank || _confirmTest) {
            final controller = tester
                .widget<WebViewWidget>(find.byType(WebViewWidget))
                .platform
                .params
                .controller;
            // Chỉ chọn nút ngân hàng đã xác định từ DOM; không nhập hay gửi form.
            await controller
                .runJavaScript("document.getElementById('NCB').click();")
                .timeout(const Duration(seconds: 3));
            final bankReady = await _waitForDocument(
              tester,
              afterPath: snapshot['path'] as String?,
            );
            final bankRecord = <String, Object?>{
              'attempt': 'bank-selected',
              'loaded': bankReady,
              ...await _safeSnapshot(tester),
            };
            diagnostics.add(bankRecord);
            debugPrint('VNPAY_SANDBOX_DIAGNOSTIC ${jsonEncode(bankRecord)}');
            if (bankReady) {
              await _printSafeActions(tester);
              await _printSafeFields(tester);
              if (_confirmTest) {
                await _confirmPublicDummyCard(
                  tester,
                  bankRecord['path'] as String?,
                );
              }
            }
          }
        }
        if (find.byType(WebViewWidget).evaluate().isNotEmpty) {
          await tester.tap(find.byKey(const Key('vnpay-checkout-close')));
        }
        await tester.pumpAndSettle();
        expect(find.byType(WebViewWidget), findsNothing);
      }

      expect(closed, 2);
      expect(
        diagnostics.first['loaded'],
        isTrue,
        reason: 'Trang sandbox mới phải hoàn tất tải để so sánh điều hướng.',
      );
      expect(
        diagnostics.first['gatewayError'],
        isFalse,
        reason: 'Trang sandbox mở lần đầu đang trả lỗi; xem chẩn đoán an toàn.',
      );
      if (_preserveSession && _confirmTest && !_submitTestOtp) {
        final reopened = diagnostics.last;
        expect(reopened['attempt'], 'reopened');
        expect(reopened['loaded'], isTrue);
        expect(reopened['gatewayError'], isFalse);
        expect(
          reopened['path'],
          '/paymentv2/Ncb/Transaction/Confirm.html',
          reason:
              'Mở lại phải giữ trang OTP hiện tại, không tải lại link ban đầu.',
        );
      }
      expect(tester.takeException(), isNull);
    },
    skip: _diagnosticUrl.isEmpty || _diagnosticBookingId.isEmpty,
    timeout: const Timeout(Duration(minutes: 3)),
  );
}

Future<void> _confirmPublicDummyCard(
  WidgetTester tester,
  String? bankPath,
) async {
  final continued = await _sandboxAction(tester, '''
var dummyNumber = '9704198526191432198';
var fields = {
  card_number_mask: dummyNumber,
  cardHolder: 'NGUYEN VAN A',
  cardDate: '07/15'
};
Object.keys(fields).forEach(function (id) {
  var element = document.getElementById(id);
  if (!element || element.type === 'hidden') throw new Error('Missing visible test field');
  element.value = fields[id];
  ['input', 'change', 'keyup', 'blur'].forEach(function (type) {
    element.dispatchEvent(new Event(type, {bubbles: true}));
  });
});
var hiddenNumber = document.getElementById('cardNumber');
if (!hiddenNumber || hiddenNumber.value !== dummyNumber) return false;
var button = document.getElementById('btnContinue');
if (!button || !button.getClientRects().length || button.disabled) return false;
button.click();
return true;
''');
  expect(
    continued,
    isTrue,
    reason: 'Chỉ tiếp tục khi handler nhận đúng thẻ giả công khai.',
  );
  final continuedReady = await _waitForNextStage(
    tester,
    bankPath,
    allowAgreement: true,
  );
  await _printStage(tester, 'test-card-continued', continuedReady);
  if (find.byType(WebViewWidget).evaluate().isEmpty || !continuedReady) return;
  final document = await _document(tester);
  if (document['agreeVisible'] != true) return;
  final agreed = await _sandboxAction(tester, '''
var button = document.getElementById('btnAgree');
if (!button || !button.getClientRects().length || button.disabled) return false;
button.click();
return true;
''');
  expect(
    agreed,
    isTrue,
    reason: 'Chỉ xác nhận hộp thoại sandbox đang hiển thị.',
  );
  final confirmedReady = await _waitForNextStage(tester, bankPath);
  await _printStage(tester, 'test-card-confirmed', confirmedReady);
  if (_submitTestOtp &&
      confirmedReady &&
      find.byType(WebViewWidget).evaluate().isNotEmpty) {
    await _submitPublicTestOtp(tester);
  }
}

Future<void> _submitPublicTestOtp(WidgetTester tester) async {
  const confirmPath = '/paymentv2/Ncb/Transaction/Confirm.html';
  final submitted = await _sandboxAction(tester, '''
if (window.location.pathname !== '$confirmPath') return false;
var otp = document.getElementById('otpvalue');
var button = document.getElementById('btnConfirm');
if (!otp || otp.type !== 'text' || !otp.getClientRects().length || !button || !button.getClientRects().length || button.disabled) return false;
otp.value = '123456';
['input', 'change', 'keyup', 'blur'].forEach(function (type) {
  otp.dispatchEvent(new Event(type, {bubbles: true}));
});
button.click();
return true;
''');
  expect(
    submitted,
    isTrue,
    reason: 'Chỉ gửi OTP giả trên đúng trang NCB sandbox đã kiểm chứng.',
  );
  final ready = await _waitForNextStage(tester, confirmPath);
  await _printStage(tester, 'test-otp-submitted', ready);
}

Future<bool> _sandboxAction(WidgetTester tester, String script) async {
  try {
    final webview = tester.widget<WebViewWidget>(find.byType(WebViewWidget));
    final result = await webview.platform.params.controller
        .runJavaScriptReturningResult('''
(function () {
  if (window.location.protocol !== 'https:' || window.location.hostname !== 'sandbox.vnpayment.vn') return false;
  $script
})()
''')
        .timeout(const Duration(seconds: 3));
    return result == true || result == 'true';
  } catch (_) {
    return false;
  }
}

Future<bool> _waitForNextStage(
  WidgetTester tester,
  String? previousPath, {
  bool allowAgreement = false,
}) async {
  final elapsed = Stopwatch()..start();
  while (elapsed.elapsed < const Duration(seconds: 30)) {
    if (find.byType(WebViewWidget).evaluate().isEmpty) return true;
    try {
      final document = await _document(tester);
      final href = Uri.tryParse(document['href'] as String? ?? '');
      if (document['readyState'] == 'complete' &&
          (href?.path != previousPath ||
              document['processingOrExpired'] == true ||
              document['expired'] == true ||
              (allowAgreement && document['agreeVisible'] == true)) &&
          find.byKey(const Key('vnpay-checkout-loading')).evaluate().isEmpty) {
        return true;
      }
    } catch (_) {
      // Không xuất exception có thể chứa URL thanh toán đã ký.
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
  return false;
}

Future<void> _printStage(
  WidgetTester tester,
  String attempt,
  bool loaded,
) async {
  debugPrint(
    'VNPAY_SANDBOX_DIAGNOSTIC ${jsonEncode({'attempt': attempt, 'loaded': loaded, ...await _safeSnapshot(tester)})}',
  );
  if (find.byType(WebViewWidget).evaluate().isNotEmpty) {
    await _printSafeActions(tester);
    await _printSafeFields(tester);
  }
}

Future<void> _printSafeActions(WidgetTester tester) async {
  try {
    final webview = tester.widget<WebViewWidget>(find.byType(WebViewWidget));
    Object? value = await webview.platform.params.controller
        .runJavaScriptReturningResult('''
JSON.stringify(Array.from(document.querySelectorAll('a, button, input[type="button"]')).slice(0, 60).map(function (element) {
  var path = null;
  var href = element.getAttribute('href');
  if (href && !/^javascript:/i.test(href)) {
    try { path = new URL(href, window.location.href).pathname; } catch (_) {}
  }
  return {
    tag: element.tagName.toLowerCase(),
    text: (element.innerText || '').trim().slice(0, 90),
    id: element.id,
    class: element.className,
    bankCode: element.getAttribute('data-bankcode'),
    hrefPathOnly: path
  };
}))
''')
        .timeout(const Duration(seconds: 3));
    for (var depth = 0; depth < 2 && value is String; depth++) {
      value = jsonDecode(value);
    }
    debugPrint('VNPAY_SANDBOX_ACTIONS ${jsonEncode(value)}');
  } catch (_) {
    // Không xuất exception có thể chứa URL thanh toán đã ký.
    debugPrint('VNPAY_SANDBOX_ACTIONS {"diagnosticReadFailed":true}');
  }
}

Future<void> _printSafeFields(WidgetTester tester) async {
  try {
    final webview = tester.widget<WebViewWidget>(find.byType(WebViewWidget));
    Object? value = await webview.platform.params.controller
        .runJavaScriptReturningResult('''
JSON.stringify(Array.from(document.querySelectorAll('input, select')).slice(0, 60).map(function (element) {
  return {
    tag: element.tagName.toLowerCase(),
    type: element.getAttribute('type'),
    id: element.id,
    name: element.getAttribute('name'),
    placeholder: element.getAttribute('placeholder')
  };
}))
''')
        .timeout(const Duration(seconds: 3));
    for (var depth = 0; depth < 2 && value is String; depth++) {
      value = jsonDecode(value);
    }
    debugPrint('VNPAY_SANDBOX_FIELDS ${jsonEncode(value)}');
  } catch (_) {
    // Không xuất exception có thể chứa URL thanh toán đã ký.
    debugPrint('VNPAY_SANDBOX_FIELDS {"diagnosticReadFailed":true}');
  }
}

Future<Map<String, dynamic>> _document(WidgetTester tester) async {
  final webview = tester.widget<WebViewWidget>(find.byType(WebViewWidget));
  Object? value = await webview.platform.params.controller
      .runJavaScriptReturningResult('''
JSON.stringify({
  href: window.location.href,
  readyState: document.readyState,
  title: document.title,
  agreeVisible: (function () {
    var button = document.getElementById('btnAgree');
    return !!(button && button.getClientRects().length && !button.disabled && window.getComputedStyle(button).visibility !== 'hidden');
  })(),
  processingOrExpired: /Giao dịch đang được xử lý hoặc đã quá thời gian thanh toán/.test(document.body ? document.body.innerText : ''),
  expired: /Giao dịch đã quá thời gian/.test(document.body ? document.body.innerText : ''),
  choosePayment: /Chọn phương thức thanh toán|Chọn ngân hàng|Thẻ nội địa|Tài khoản ngân hàng/.test(document.body ? document.body.innerText : ''),
  cardFieldPresent: !!document.querySelector('input[autocomplete="cc-number"], input[name*="card" i]')
})
''')
      .timeout(const Duration(seconds: 3));
  // Android có thể bọc chuỗi JSON thêm một lần.
  for (var depth = 0; depth < 2 && value is String; depth++) {
    value = jsonDecode(value);
  }
  return value is Map<String, dynamic> ? value : <String, dynamic>{};
}

Future<bool> _waitForDocument(WidgetTester tester, {String? afterPath}) async {
  final elapsed = Stopwatch()..start();
  while (elapsed.elapsed < const Duration(seconds: 30)) {
    try {
      if (find.byType(WebViewWidget).evaluate().isNotEmpty) {
        final document = await _document(tester);
        final href = Uri.tryParse(document['href'] as String? ?? '');
        final controller = tester
            .widget<WebViewWidget>(find.byType(WebViewWidget))
            .platform
            .params
            .controller;
        final nativeUrl = Uri.tryParse(await controller.currentUrl() ?? '');
        if (href?.host == 'sandbox.vnpayment.vn' &&
            nativeUrl?.toString() == href?.toString() &&
            document['readyState'] == 'complete' &&
            (afterPath == null ||
                href?.path != afterPath ||
                document['cardFieldPresent'] == true) &&
            find
                .byKey(const Key('vnpay-checkout-loading'))
                .evaluate()
                .isEmpty) {
          return true;
        }
      }
    } catch (_) {
      // Không xuất exception có thể chứa URL thanh toán đã ký.
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
  return false;
}

Future<Map<String, Object?>> _safeSnapshot(WidgetTester tester) async {
  if (find.byType(WebViewWidget).evaluate().isEmpty) {
    return {'callbackReturned': true};
  }
  try {
    final document = await _document(tester);
    final href = Uri.tryParse(document['href'] as String? ?? '');
    return {
      'host': href?.host,
      'path': href?.path,
      'errorCode': href?.path.toLowerCase().contains('/error') == true
          ? href?.queryParameters['code']
          : null,
      'title': document['title'],
      'readyState': document['readyState'],
      'gatewayError':
          href?.path.toLowerCase().contains('/error') == true ||
          document['processingOrExpired'] == true ||
          document['expired'] == true,
      'processingOrExpired': document['processingOrExpired'],
      'expired': document['expired'],
      'choosePayment': document['choosePayment'],
      'cardFieldPresent': document['cardFieldPresent'],
      'retryVisible': find
          .byKey(const Key('vnpay-checkout-retry'))
          .evaluate()
          .isNotEmpty,
    };
  } catch (_) {
    return {'diagnosticReadFailed': true};
  }
}
