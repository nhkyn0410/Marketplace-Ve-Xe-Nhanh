import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

bool _isWebUrl(Uri uri) =>
    const {'http', 'https'}.contains(uri.scheme) &&
    uri.hasAuthority &&
    uri.host.isNotEmpty &&
    uri.userInfo.isEmpty;

/// Lấy địa chỉ quay về đúng đơn từ URL thanh toán đã được máy chủ ký.
Uri vnpayReturnUrlForBooking(Uri paymentUrl, String bookingId) {
  if (!_isWebUrl(paymentUrl) ||
      !RegExp(r'^[A-Za-z0-9-]+$').hasMatch(bookingId)) {
    throw const FormatException('Liên kết thanh toán không hợp lệ.');
  }
  final values = paymentUrl.queryParametersAll['vnp_ReturnUrl'];
  final returnUrl = values != null && values.length == 1
      ? Uri.tryParse(values.single)
      : null;
  if (returnUrl == null ||
      !_isWebUrl(returnUrl) ||
      returnUrl.hasFragment ||
      returnUrl.path != '/bookings/$bookingId/payment/result') {
    throw const FormatException('Liên kết quay về không khớp với đơn đặt vé.');
  }
  return returnUrl;
}

/// Nhận diện trang quay về theo nguồn và đường dẫn, không tin kết quả trên URL.
bool matchesVnpayReturnUrl(Uri navigation, Uri expected) =>
    _isWebUrl(navigation) &&
    _isWebUrl(expected) &&
    navigation.scheme == expected.scheme &&
    navigation.host == expected.host &&
    navigation.port == expected.port &&
    navigation.path == expected.path;

/// Giữ nguyên phiên VNPay của một đơn và URL đã ký khi đóng rồi mở lại trang.
class VnpayCheckoutSession extends ChangeNotifier {
  /// Tạo phiên chưa khởi tạo WebView; an toàn cả khi chưa dùng nền tảng di động.
  VnpayCheckoutSession();

  WebViewController? _controller;
  Uri? _paymentUrl;
  Uri? _returnUrl;
  String? _bookingId;
  Future<void>? _initialization;
  Future<void>? _activeRoute;
  bool _loading = true;
  bool _returned = false;
  bool _progressed = false;
  bool _initialPageFinished = false;
  bool _disposed = false;
  int _generation = 0;
  String? _error;

  WebViewController get _nativeController =>
      _controller ??= WebViewController();

  bool get _canRetryInitial => !_progressed && !_initialPageFinished;

  void _bind(Uri paymentUrl, String bookingId) {
    if (_disposed) throw StateError('Phiên thanh toán đã đóng.');
    final returnUrl = vnpayReturnUrlForBooking(paymentUrl, bookingId);
    if (_bookingId != null && _bookingId != bookingId) {
      throw StateError('Phiên thanh toán không khớp với liên kết của đơn.');
    }
    if (_paymentUrl != null &&
        _paymentUrl.toString() != paymentUrl.toString()) {
      if (_activeRoute != null) {
        throw StateError('Trang thanh toán trước vẫn đang mở.');
      }
      _generation++;
      _controller = null;
      _initialization = null;
      _loading = true;
      _returned = false;
      _progressed = false;
      _initialPageFinished = false;
      _error = null;
    }
    _paymentUrl = paymentUrl;
    _returnUrl = returnUrl;
    _bookingId = bookingId;
  }

  Future<void> _initialize() => _initialization ??= _configureAndLoad();

  Future<void> _configureAndLoad() async {
    final generation = _generation;
    try {
      final controller = _nativeController;
      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      if (!_isCurrent(generation)) return;
      await controller.setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) => _navigate(request, generation),
          onPageStarted: (url) {
            if (!_isCurrent(generation) || _returned) return;
            final uri = Uri.tryParse(url);
            if (uri != null && matchesVnpayReturnUrl(uri, _returnUrl!)) {
              _recordReturn();
              return;
            }
            if (uri != null && uri.toString() != _paymentUrl.toString()) {
              _progressed = true;
            }
            _loading = true;
            _error = null;
            notifyListeners();
          },
          onPageFinished: (_) {
            if (!_isCurrent(generation) || _returned) return;
            if (_error == null) _initialPageFinished = true;
            _loading = false;
            notifyListeners();
          },
          onWebResourceError: (error) {
            if (_isCurrent(generation) && error.isForMainFrame == true) {
              _showLoadError();
            }
          },
          onSslAuthError: (error) {
            unawaited(error.cancel());
            if (_isCurrent(generation)) _showLoadError();
          },
        ),
      );
      if (_isCurrent(generation)) await _loadInitial();
    } catch (_) {
      if (_isCurrent(generation)) _showLoadError();
    }
  }

  bool _isCurrent(int generation) => !_disposed && generation == _generation;

  Future<void> _loadInitial() async {
    if (_disposed || _returned || !_canRetryInitial) return;
    _loading = true;
    _error = null;
    notifyListeners();
    final generation = _generation;
    try {
      await _nativeController.loadRequest(_paymentUrl!);
    } catch (_) {
      if (_isCurrent(generation)) _showLoadError();
    }
  }

  NavigationDecision _navigate(NavigationRequest request, int generation) {
    final uri = Uri.tryParse(request.url);
    if (!_isCurrent(generation) || _returned) {
      return NavigationDecision.prevent;
    }
    if (uri != null &&
        request.isMainFrame &&
        matchesVnpayReturnUrl(uri, _returnUrl!)) {
      _recordReturn();
      return NavigationDecision.prevent;
    }
    if (uri == null || !_isWebUrl(uri)) {
      if (request.isMainFrame) _showLoadError();
      return NavigationDecision.prevent;
    }
    if (request.isMainFrame && uri.toString() != _paymentUrl.toString()) {
      _progressed = true;
    }
    return NavigationDecision.navigate;
  }

  void _recordReturn() {
    if (_disposed || _returned) return;
    _returned = true;
    _loading = false;
    _error = null;
    notifyListeners();
  }

  void _showLoadError() {
    if (_disposed || _returned) return;
    _loading = false;
    _error =
        'Không tải được trang thanh toán. Hãy kiểm tra kết nối và thử lại, '
        'hoặc quay lại ứng dụng để kiểm tra trạng thái đơn.';
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _controller = null;
    super.dispose();
  }
}

/// Mở VNPay trong ứng dụng; dùng lại phiên để tiếp tục đúng trang thanh toán.
Future<bool> openVnpayCheckout(
  BuildContext context, {
  required Uri paymentUrl,
  required String bookingId,
  VnpayCheckoutSession? session,
}) async {
  final checkout = session ?? VnpayCheckoutSession();
  checkout._bind(paymentUrl, bookingId);
  final active = checkout._activeRoute;
  if (active != null) {
    await active;
    return true;
  }
  if (checkout._returned) return true;
  final closed = Completer<void>();
  checkout._activeRoute = closed.future;
  try {
    final route = MaterialPageRoute<void>(
      builder: (_) => _VnpayCheckoutScreen(session: checkout),
    );
    await Navigator.of(context).push<void>(route);
    // Chờ widget cũ tháo khỏi native view trước khi cho phép gắn lại controller.
    await route.completed;
    return true;
  } finally {
    checkout._activeRoute = null;
    closed.complete();
    if (session == null) checkout.dispose();
  }
}

class _VnpayCheckoutScreen extends StatefulWidget {
  const _VnpayCheckoutScreen({required this.session});

  final VnpayCheckoutSession session;

  @override
  State<_VnpayCheckoutScreen> createState() => _VnpayCheckoutScreenState();
}

class _VnpayCheckoutScreenState extends State<_VnpayCheckoutScreen> {
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    widget.session.addListener(_changed);
    unawaited(widget.session._initialize());
  }

  @override
  void dispose() {
    widget.session.removeListener(_changed);
    super.dispose();
  }

  void _changed() {
    if (!mounted || _closing) return;
    if (widget.session._returned) {
      _close();
    } else {
      setState(() {});
    }
  }

  void _close() {
    if (!mounted || _closing) return;
    _closing = true;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => PopScope<void>(
    onPopInvokedWithResult: (didPop, _) {
      if (didPop) _closing = true;
    },
    child: Scaffold(
      key: const Key('vnpay-checkout-screen'),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thanh toán VNPay'),
        leading: IconButton(
          key: const Key('vnpay-checkout-back'),
          tooltip: 'Quay lại',
          onPressed: _close,
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            key: const Key('vnpay-checkout-close'),
            tooltip: 'Đóng thanh toán',
            onPressed: _close,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: widget.session._nativeController),
            if (widget.session._loading)
              const LinearProgressIndicator(key: Key('vnpay-checkout-loading')),
            if (widget.session._error != null)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off_outlined, size: 40),
                          const SizedBox(height: 16),
                          Text(
                            widget.session._error!,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            key: const Key('vnpay-checkout-retry'),
                            onPressed: () {
                              if (widget.session._canRetryInitial) {
                                unawaited(widget.session._loadInitial());
                              } else {
                                _close();
                              }
                            },
                            child: Text(
                              widget.session._canRetryInitial
                                  ? 'Thử lại'
                                  : 'Kiểm tra trạng thái trong ứng dụng',
                            ),
                          ),
                          TextButton(
                            onPressed: _close,
                            child: const Text('Quay lại ứng dụng'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
