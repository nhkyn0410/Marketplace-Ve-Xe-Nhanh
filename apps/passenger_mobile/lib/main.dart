import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_shared/mobile_shared.dart';

/// Origin của API — KHÔNG kèm `/v1`.
///
/// `10.0.2.2` là alias của emulator Android trỏ về `localhost` máy host.
/// Thiết bị thật thì truyền IP LAN qua `--dart-define`.
const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:3000',
);

void main() => runApp(const PassengerApp());

class PassengerApp extends StatelessWidget {
  const PassengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vé Xe Nhanh',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const OtpLoginPage(),
    );
  }
}

/// Ba trạng thái của đường dọc mỏng: nhập email → nhập OTP → đã đăng nhập.
enum _Step { email, otp, signedIn }

class OtpLoginPage extends StatefulWidget {
  const OtpLoginPage({super.key});

  @override
  State<OtpLoginPage> createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends State<OtpLoginPage> {
  final _tokens = const TokenStorage();
  late final _api = createApiClient(baseUrl: apiBaseUrl, tokens: _tokens);
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();

  _Step _step = _Step.email;
  bool _busy = false;
  String? _error;
  AuthTokenResponseDtoOutput? _session;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  /// Bọc mọi lời gọi API: bật cờ bận, dịch lỗi Dio sang [ApiFailure], hiện lên UI.
  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on DioException catch (error) {
      final failure = toApiFailure(error, _api.serializers);
      if (mounted) setState(() => _error = failure.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _requestOtp() => _run(() async {
    await _api.getAuthApi().authControllerRequestOtp(
      otpRequestDto: OtpRequestDto(
        (b) => b..email = _emailController.text.trim(),
      ),
    );
    if (mounted) setState(() => _step = _Step.otp);
  });

  Future<void> _verifyOtp() => _run(() async {
    final response = await _api.getAuthApi().authControllerVerifyOtp(
      otpVerifyDto: OtpVerifyDto(
        (b) => b
          ..email = _emailController.text.trim()
          ..otp = _otpController.text.trim(),
      ),
    );
    final session = response.data!;
    await _tokens.saveAccessToken(session.accessToken);
    if (mounted) {
      setState(() {
        _session = session;
        _step = _Step.signedIn;
      });
    }
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_step == _Step.signedIn) ..._signedIn() else ..._loginForm(),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            if (_busy) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _loginForm() => [
    TextField(
      controller: _emailController,
      enabled: _step == _Step.email,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(labelText: 'Email'),
    ),
    const SizedBox(height: 12),
    if (_step == _Step.email)
      FilledButton(
        onPressed: _busy ? null : _requestOtp,
        child: const Text('Gửi mã OTP'),
      )
    else ...[
      TextField(
        controller: _otpController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Mã OTP (6 chữ số)'),
      ),
      const SizedBox(height: 12),
      FilledButton(
        onPressed: _busy ? null : _verifyOtp,
        child: const Text('Xác minh'),
      ),
    ],
  ];

  List<Widget> _signedIn() {
    final session = _session!;
    // Dùng serializer để in ra giá trị **trên dây** (`operator`), không phải tên
    // member Dart (`operator_`) — cùng loại bẫy với `Bearer` ↔ `bearer`.
    final scope = _api.serializers.serializeWith(
      AuthTokenResponseDtoOutputScopeEnum.serializer,
      session.scope,
    );
    return [
      const Text('Đăng nhập thành công', style: TextStyle(fontSize: 20)),
      const SizedBox(height: 12),
      Text('scope: $scope'),
      Text('role: ${session.role}'),
      Text('hết hạn sau: ${session.expiresIn}s'),
      const SizedBox(height: 12),
      const Text('Token đã lưu bằng flutter_secure_storage.'),
    ];
  }
}
