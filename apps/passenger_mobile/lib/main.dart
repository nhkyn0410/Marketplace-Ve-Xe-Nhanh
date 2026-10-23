import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/auth/auth_screen.dart';
import 'package:passenger_mobile/features/auth/google_auth_service.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/home/home_screen.dart';

/// Origin của API — KHÔNG kèm `/v1`.
///
/// Android Emulator mặc định đi qua alias chính thức `10.0.2.2`. Khi caller chủ
/// động dùng `localhost` cùng `adb reverse`, đổi hostname sang loopback dạng số
/// để tránh DNS của emulator trả `Failed host lookup: localhost` trước khi ADB
/// có thể chuyển tiếp cổng. Thiết bị thật không cáp vẫn truyền IP LAN bằng
/// `--dart-define=API_BASE_URL=http://192.168.x.x:3000`.
///
/// `String.fromEnvironment` là compile-time: đổi giá trị phải dừng hẳn
/// `flutter run` rồi chạy lại, hot restart không áp dụng giá trị mới.
const _configuredApiBaseUrl = String.fromEnvironment('API_BASE_URL');

String resolveApiBaseUrl({
  String configured = _configuredApiBaseUrl,
  TargetPlatform? platform,
}) {
  final currentPlatform = platform ?? defaultTargetPlatform;
  final value = configured.trim();

  if (value.isEmpty) {
    return currentPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:3000'
        : 'http://localhost:3000';
  }

  if (currentPlatform != TargetPlatform.android) return value;

  final uri = Uri.tryParse(value);
  if (uri?.host != 'localhost') return value;
  return uri!.replace(host: '127.0.0.1').toString();
}

final apiBaseUrl = resolveApiBaseUrl();

String describePassengerAuthFailure(ApiFailure failure) {
  if (failure.isNetworkError) {
    return 'Không thể kết nối máy chủ. Vui lòng kiểm tra mạng và thử lại.';
  }
  if (failure.status == 429 || failure.code == 'AUTH_OTP_RATE_LIMITED') {
    return 'Bạn đã yêu cầu hoặc thử quá nhiều lần. Vui lòng thử lại sau.';
  }
  if (failure.code == 'AUTH_INVALID_CREDENTIALS') {
    return 'Mã OTP không đúng hoặc đã hết hạn.';
  }
  return failure.detail;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const PassengerApp());
}

class PassengerApp extends StatelessWidget {
  const PassengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vé Xe Nhanh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Be Vietnam Pro',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2B7EAD)),
      ),
      home: const OtpLoginPage(),
    );
  }
}

enum _AuthStep { email, otp, profile, guest, signedIn }

class OtpLoginPage extends StatefulWidget {
  const OtpLoginPage({
    this.requestOtpOverride,
    this.googleIdTokenOverride,
    super.key,
  });

  final Future<void> Function(String email)? requestOtpOverride;
  final Future<String> Function()? googleIdTokenOverride;

  @override
  State<OtpLoginPage> createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends State<OtpLoginPage> {
  final _tokens = const TokenStorage();
  late final _api = createApiClient(baseUrl: apiBaseUrl, tokens: _tokens);

  _AuthStep _step = _AuthStep.email;
  bool _busy = false;
  String? _error;
  String? _email;
  String? _profileEmail;
  String? _displayName;
  DateTime? _otpIssuedAt;

  /// Bọc mọi lời gọi API: bật cờ bận, dịch lỗi thành câu tiếng Việt, hiện lên UI.
  Future<bool> _run(Future<void> Function() action) async {
    if (_busy) return false;
    setState(() {
      _busy = true;
      _error = null;
    });

    String? message;
    var succeeded = false;
    try {
      await action();
      succeeded = true;
    } on GoogleAuthCancelledException {
      // Người dùng chủ động đóng account picker: trở lại màn hình, không coi là lỗi.
    } on GoogleAuthConfigurationException catch (error) {
      message = 'Đăng nhập Google chưa được cấu hình đúng. ${error.message}';
    } on GoogleAuthUnavailableException {
      message = 'Không thể mở đăng nhập Google. Vui lòng thử lại.';
    } on DioException catch (error) {
      message = _describeDioError(error);
    } catch (_) {
      // Không đưa exception/request body ra UI vì có thể chứa OTP hoặc token.
      message = 'Đã xảy ra lỗi không mong đợi. Vui lòng thử lại.';
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = message;
        });
      }
    }
    return succeeded;
  }

  /// Dịch [DioException] sang câu hiển thị được. Hàm này không được ném lỗi.
  String _describeDioError(DioException error) {
    try {
      final failure = toApiFailure(error, _api.serializers);
      return describePassengerAuthFailure(failure);
    } catch (_) {
      return 'Máy chủ trả lỗi ${error.response?.statusCode ?? 0}.';
    }
  }

  Future<void> _requestOtp(String email) async {
    final accepted = await _run(() async {
      final override = widget.requestOtpOverride;
      if (override != null) {
        await override(email);
        return;
      }
      await _api.getAuthApi().authControllerRequestOtp(
        otpRequestDto: OtpRequestDto((builder) => builder..email = email),
      );
    });
    if (!accepted || !mounted) return;

    setState(() {
      _email = email;
      _otpIssuedAt = DateTime.now();
      _step = _AuthStep.otp;
    });
  }

  Future<bool> _resendOtp() async {
    final email = _email;
    if (email == null) return false;
    return _run(() async {
      await _api.getAuthApi().authControllerRequestOtp(
        otpRequestDto: OtpRequestDto((builder) => builder..email = email),
      );
    });
  }

  Future<bool> _verifyOtp(String otp) async {
    final email = _email;
    if (email == null) return false;

    AuthTokenResponseDtoOutput? session;
    PassengerProfileDtoOutput? profile;
    final verified = await _run(() async {
      final response = await _api.getAuthApi().authControllerVerifyOtp(
        otpVerifyDto: OtpVerifyDto(
          (builder) => builder
            ..email = email
            ..otp = otp,
        ),
      );
      session = response.data;
      if (session == null) {
        throw StateError('OTP verify response did not contain a session.');
      }
      profile = await _saveSessionAndLoadProfile(session!);
    });

    if (verified && mounted) {
      _applyAuthenticatedProfile(profile!);
    }
    return verified;
  }

  Future<void> _signInWithGoogle() async {
    PassengerProfileDtoOutput? profile;
    final signedIn = await _run(() async {
      final idToken =
          await (widget.googleIdTokenOverride?.call() ??
              GoogleAuthService.instance.authenticate());
      final response = await _api.getAuthApi().authControllerOauthIdToken(
        provider: 'google',
        oAuthIdTokenDto: OAuthIdTokenDto(
          (builder) => builder.idToken = idToken,
        ),
      );
      final session = response.data;
      if (session == null) {
        throw StateError('Google sign-in response did not contain a session.');
      }
      profile = await _saveSessionAndLoadProfile(session);
    });

    if (signedIn && mounted) {
      _applyAuthenticatedProfile(profile!);
    }
  }

  Future<PassengerProfileDtoOutput> _saveSessionAndLoadProfile(
    AuthTokenResponseDtoOutput session,
  ) async {
    try {
      await _tokens.saveSession(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      final profileResponse = await _api
          .getPassengerProfileApi()
          .passengerProfileControllerGet();
      final profile = profileResponse.data;
      if (profile == null) {
        throw StateError('Profile response did not contain data.');
      }
      return profile;
    } catch (_) {
      // Không giữ access token đơn lẻ nếu lưu refresh token hoặc tải hồ sơ thất bại.
      await _tokens.clear();
      rethrow;
    }
  }

  void _applyAuthenticatedProfile(PassengerProfileDtoOutput profile) {
    final name = profile.name?.trim();
    setState(() {
      _email = profile.email;
      _profileEmail = profile.email;
      _displayName = name;
      _step = name == null || name.isEmpty
          ? _AuthStep.profile
          : _AuthStep.signedIn;
      _error = null;
    });
  }

  Future<bool> _completeProfile(String fullName, String? phone) async {
    PassengerProfileDtoOutput? profile;
    final completed = await _run(() async {
      final response = await _api
          .getPassengerProfileApi()
          .passengerProfileControllerUpdate(
            passengerProfileUpdateDto: PassengerProfileUpdateDto((builder) {
              builder.name = fullName;
              if (phone != null) builder.phone = phone;
            }),
          );
      profile = response.data;
      if (profile == null) {
        throw StateError('Profile update response did not contain data.');
      }
    });

    if (completed && mounted) {
      setState(() {
        _displayName = profile!.name?.trim() ?? fullName;
        _step = _AuthStep.signedIn;
        _error = null;
      });
    }
    return completed;
  }

  void _clearFeedback() {
    if (_error == null) return;
    setState(() => _error = null);
  }

  void _editEmail() {
    if (_busy) return;
    setState(() {
      _step = _AuthStep.email;
      _error = null;
      _otpIssuedAt = null;
    });
  }

  void _continueAsGuest() {
    if (_busy) return;
    setState(() {
      _step = _AuthStep.guest;
      _error = null;
    });
  }

  void _returnToLogin() {
    setState(() {
      _step = _AuthStep.email;
      _error = null;
    });
  }

  Future<List<HomeLocation>> _loadHomeLocations() async {
    final response = await _api
        .getCatalogApi()
        .catalogControllerListProvinces();
    final data = response.data;
    if (data == null) {
      throw StateError('Province response did not contain data.');
    }
    return data.items
        .map((item) => HomeLocation(id: item.id, name: item.name))
        .toList(growable: false);
  }

  Future<int> _searchHomeTrips(HomeSearchQuery query) async {
    String? fromProvinceId;
    String? fromStopPointId;
    String? toProvinceId;
    String? toStopPointId;
    if (query.from.kind == HomeLocationKind.province) {
      fromProvinceId = query.from.id;
    } else {
      fromStopPointId = query.from.id;
    }
    if (query.to.kind == HomeLocationKind.province) {
      toProvinceId = query.to.id;
    } else {
      toStopPointId = query.to.id;
    }

    final response = await _api.getTripsApi().publicTripControllerSearch(
      date: Date(query.date.year, query.date.month, query.date.day),
      fromProvinceId: fromProvinceId,
      fromStopPointId: fromStopPointId,
      toProvinceId: toProvinceId,
      toStopPointId: toStopPointId,
      passengers: query.passengers,
      operatorId: query.operatorId,
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Trip search response did not contain data.');
    }
    return data.total;
  }

  @override
  Widget build(BuildContext context) {
    if (_step == _AuthStep.signedIn) return _home(isLoggedIn: true);
    if (_step == _AuthStep.guest) return _home(isLoggedIn: false);
    if (_step == _AuthStep.profile) {
      return ProfileCompletionScreen(
        email: _profileEmail ?? _email!,
        busy: _busy,
        errorMessage: _error,
        onComplete: _completeProfile,
      );
    }

    return IndexedStack(
      index: _step == _AuthStep.email ? 0 : 1,
      children: [
        AuthEntryScreen(
          busy: _busy,
          errorMessage: _step == _AuthStep.email ? _error : null,
          onEmailChanged: _clearFeedback,
          onRequestOtp: _requestOtp,
          onGoogleSignIn: _signInWithGoogle,
          onContinueAsGuest: _continueAsGuest,
        ),
        if (_email != null && _otpIssuedAt != null)
          EmailVerificationScreen(
            key: ValueKey(_otpIssuedAt),
            email: _email!,
            issuedAt: _otpIssuedAt!,
            busy: _busy,
            errorMessage: _step == _AuthStep.otp ? _error : null,
            onOtpChanged: _clearFeedback,
            onVerify: _verifyOtp,
            onResend: _resendOtp,
            onEditEmail: _editEmail,
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }

  Widget _home({required bool isLoggedIn}) {
    final emailName = _email?.split('@').first;
    return HomeScreen(
      isLoggedIn: isLoggedIn,
      userName: _displayName ?? emailName,
      loadLocations: _loadHomeLocations,
      onSearch: _searchHomeTrips,
      onLoginRequested: isLoggedIn ? null : _returnToLogin,
    );
  }
}
