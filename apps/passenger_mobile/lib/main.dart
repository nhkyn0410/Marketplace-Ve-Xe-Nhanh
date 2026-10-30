import 'package:api_client_dart/api_client_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/account/account_screen.dart';
import 'package:passenger_mobile/features/account/edit_profile_screen.dart';
import 'package:passenger_mobile/features/account/guest_account_screen.dart';
import 'package:passenger_mobile/features/account/my_reviews_screen.dart';
import 'package:passenger_mobile/features/account/notification_settings_screen.dart';
import 'package:passenger_mobile/features/account/point_history_screen.dart';
import 'package:passenger_mobile/features/account/saved_passengers_screen.dart';
import 'package:passenger_mobile/features/account/login_sessions_screen.dart';
import 'package:passenger_mobile/features/account/voucher_wallet_screen.dart';
import 'package:passenger_mobile/features/auth/auth_screen.dart';
import 'package:passenger_mobile/features/auth/google_auth_service.dart';
import 'package:passenger_mobile/features/explore/article_api.dart';
import 'package:passenger_mobile/features/explore/explore_screen.dart';
import 'package:passenger_mobile/features/home/home_models.dart';
import 'package:passenger_mobile/features/home/home_screen.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';
import 'package:passenger_mobile/features/journey/guest_journey_flow.dart';
import 'package:passenger_mobile/features/search/trip_search_form.dart';
import 'package:passenger_mobile/features/ticket/ticket_screen.dart';
import 'package:passenger_mobile/features/ticket/trip_booking_api.dart';
import 'package:passenger_mobile/features/ticket/trip_detail_screen.dart';
import 'package:passenger_mobile/features/ticket/trip_search_models.dart';
import 'package:url_launcher/url_launcher.dart';

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

enum _AccountView {
  overview,
  editProfile,
  savedPassengers,
  vouchers,
  points,
  reviews,
  notificationSettings,
  loginSessions,
}

/// Số thẻ tuyến phổ biến ở Trang chủ.
const _popularRouteCount = 4;

/// Ảnh có sẵn theo tỉnh đến (tên bỏ dấu, như web); tỉnh khác dùng lần lượt
/// các ảnh trong [_fallbackAssets].
const _destinationAssets = <(String, String)>[
  ('lam dong', 'assets/home/destinations/da_lat.png'),
  ('khanh hoa', 'assets/home/destinations/nha_trang.jpg'),
  ('da nang', 'assets/home/destinations/da_nang.jpg'),
];
const _fallbackAssets = <String>[
  'assets/home/destinations/da_lat.png',
  'assets/home/destinations/nha_trang.jpg',
  'assets/home/destinations/da_nang.jpg',
  'assets/home/destinations/phan_thiet.jpg',
];

String _destinationAsset(String provinceName, int index) {
  final plain = provinceName
      .toLowerCase()
      .replaceAll(RegExp('[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
      .replaceAll(RegExp('[èéẹẻẽêềếệểễ]'), 'e')
      .replaceAll(RegExp('[ìíịỉĩ]'), 'i')
      .replaceAll(RegExp('[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
      .replaceAll(RegExp('[ùúụủũưừứựửữ]'), 'u')
      .replaceAll(RegExp('[ỳýỵỷỹ]'), 'y')
      .replaceAll('đ', 'd');
  for (final (key, asset) in _destinationAssets) {
    if (plain.contains(key)) return asset;
  }
  return _fallbackAssets[index % _fallbackAssets.length];
}

/// Tên tỉnh gọn cho thẻ hẹp: "TP. Hồ Chí Minh" → "TP.HCM".
String _cardLabel(String provinceName) =>
    provinceName == 'TP. Hồ Chí Minh' ? 'TP.HCM' : provinceName;

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
  late final _articleApi = ArticleApi(_api);
  late final _bookingApi = TripBookingApi(
    _api,
    isSignedIn: () => _step == _AuthStep.signedIn,
  );
  late final _searchCatalog = TripSearchCatalog(
    loadProvinces: _bookingApi.loadProvinces,
    searchPlaces: _bookingApi.searchPlaces,
    loadOperators: _bookingApi.loadOperators,
    loadAmenities: _bookingApi.loadAmenities,
  );

  /// Lần tìm chuyến gần nhất — giữ để quay lại tab Mua vé vẫn thấy danh sách.
  HomeSearchQuery? _lastSearchQuery;

  _AuthStep _step = _AuthStep.email;

  /// Đã dựng màn đăng nhập lần đầu (đã chạy splash).
  bool _loginIntroPlayed = false;
  bool _busy = false;
  String? _error;
  String? _email;
  String? _profileEmail;
  String? _displayName;
  DateTime? _otpIssuedAt;
  int _currentTab = 2;
  _AccountView _accountView = _AccountView.overview;

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
      _currentTab = 2;
      _accountView = _AccountView.overview;
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
        _currentTab = 2;
        _accountView = _AccountView.overview;
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

  Future<void> _continueAsGuest() async {
    if (_busy) return;
    // Khách vãng lai không được gửi token cũ còn lưu trong máy: token hết hạn
    // làm API trả 401 ở giữ chỗ / đặt vé thay vì coi là khách.
    await _tokens.clear();
    if (!mounted) return;
    setState(() {
      _step = _AuthStep.guest;
      _error = null;
    });
  }

  void _returnToLogin() {
    setState(() {
      _step = _AuthStep.email;
      _currentTab = 2;
      _accountView = _AccountView.overview;
      _error = null;
    });
  }

  Future<int?> _loadSavedPassengerCount() async {
    try {
      final response = await _api
          .getPassengerProfileApi()
          .passengerProfileControllerSaved();
      return response.data?.items.length;
    } catch (_) {
      return null;
    }
  }

  Future<List<SavedPassengerData>> _loadSavedPassengers() async {
    final response = await _api
        .getPassengerProfileApi()
        .passengerProfileControllerSaved();
    final data = response.data;
    if (data == null) {
      throw StateError('Saved passenger response did not contain data.');
    }
    return data.items
        .map(
          (item) => SavedPassengerData(
            passengerId: item.passengerId,
            fullName: item.fullName,
            phone: item.phone,
          ),
        )
        .toList(growable: false);
  }

  Future<bool> _createSavedPassenger(SavedPassengerFormInput input) {
    return _run(() async {
      final response = await _api
          .getPassengerProfileApi()
          .passengerProfileControllerCreateSaved(
            savedPassengerInputDto: _savedPassengerInput(input),
          );
      if (response.data == null) {
        throw StateError(
          'Create saved passenger response did not contain data.',
        );
      }
    });
  }

  Future<bool> _updateSavedPassenger(
    String passengerId,
    SavedPassengerFormInput input,
  ) {
    return _run(() async {
      final response = await _api
          .getPassengerProfileApi()
          .passengerProfileControllerUpdateSaved(
            passengerId: passengerId,
            savedPassengerInputDto: _savedPassengerInput(input),
          );
      if (response.data == null) {
        throw StateError(
          'Update saved passenger response did not contain data.',
        );
      }
    });
  }

  Future<bool> _deleteSavedPassenger(String passengerId) {
    return _run(() async {
      await _api.getPassengerProfileApi().passengerProfileControllerDeleteSaved(
        passengerId: passengerId,
      );
    });
  }

  SavedPassengerInputDto _savedPassengerInput(SavedPassengerFormInput input) {
    return SavedPassengerInputDto((builder) {
      builder.fullName = input.fullName;
      final phone = input.phone;
      if (phone != null) builder.phone = phone;
    });
  }

  Future<PassengerLoyaltyDtoOutput?> _loadLoyalty() async {
    try {
      final response = await _api
          .getPassengerLoyaltyApi()
          .passengerLoyaltyControllerMember();
      return response.data;
    } catch (_) {
      return null;
    }
  }

  Future<List<VoucherWalletItem>> _loadVoucherWallet() async {
    final response = await _api
        .getPassengerLoyaltyApi()
        .passengerLoyaltyControllerVouchers(
          status: 'AVAILABLE',
          offset: 0,
          limit: 50,
        );
    final page = response.data;
    if (page == null) {
      throw StateError('Voucher response did not contain data.');
    }
    final vouchers = page.items
        .map(
          (item) => VoucherWalletItem(
            id: item.userVoucherId,
            name: item.name,
            discountType: item.discountType.name == 'PERCENT'
                ? VoucherDiscountType.percent
                : VoucherDiscountType.amount,
            discountValue: item.discountValue,
            minOrder: item.minOrder,
            maxDiscount: item.maxDiscount,
            expiresAt: item.expiresAt,
            source: item.source_.name == 'LOYALTY_REDEMPTION'
                ? VoucherSource.loyaltyRedemption
                : VoucherSource.savedPromotion,
            promotionCode: item.promotionCode,
          ),
        )
        .toList(growable: false);
    // Fixture Figma chỉ lấp dữ liệu rỗng khi chạy debug để đối chiếu UI.
    return vouchers.isEmpty && kDebugMode ? figmaVoucherSamples : vouchers;
  }

  Future<MyReviewsData> _loadMyReviews() async {
    // API hiện chỉ hỗ trợ GET/POST đánh giá theo từng bookingId. Không gọi
    // N+1 qua lịch sử booking. Fixture Figma chỉ hiển thị ở debug; release
    // vẫn trả trạng thái rỗng cho đến khi có endpoint danh sách Passenger.
    return kDebugMode
        ? figmaMyReviewsSample
        : const MyReviewsData(pending: [], reviewed: []);
  }

  Future<bool> _submitReview(String bookingId, ReviewSubmission input) {
    return _run(() async {
      final response = await _api
          .getReviewsApi()
          .customerReviewControllerCreate(
            bookingId: bookingId,
            reviewInputDto: ReviewInputDto((builder) {
              builder.rating = input.rating;
              final comment = input.comment;
              if (comment != null) builder.comment = comment;
            }),
          );
      if (response.data == null) {
        throw StateError('Create review response did not contain data.');
      }
    });
  }

  Future<bool> _saveVoucherCode(String promotionCode) {
    return _run(() async {
      final response = await _api
          .getPassengerLoyaltyApi()
          .passengerLoyaltyControllerSave(
            saveVoucherInputDto: SaveVoucherInputDto(
              (builder) => builder.promotionCode = promotionCode,
            ),
          );
      if (response.data == null) {
        throw StateError('Save voucher response did not contain data.');
      }
    });
  }

  Future<PointHistoryData> _loadPointHistory(PointHistoryQuery query) async {
    final range = _pointDateRange(query.date);
    final memberRequest = _api
        .getPassengerLoyaltyApi()
        .passengerLoyaltyControllerMember();
    final transactionRequest = _api
        .getPassengerLoyaltyApi()
        .passengerLoyaltyControllerTransactions(
          offset: 0,
          limit: 50,
          type: _pointType(query.type),
          from: range.$1,
          to: range.$2,
        );
    final member = (await memberRequest).data;
    final transactions = (await transactionRequest).data;
    if (member == null || transactions == null) {
      throw StateError('Point history response did not contain data.');
    }
    // Release giữ đúng empty state từ API; debug dùng fixture để duyệt giao diện.
    if (transactions.items.isEmpty && kDebugMode) {
      return figmaPointHistorySample(query);
    }
    return PointHistoryData(
      availablePoints: member.availablePoints,
      earnedPoints: transactions.totals.earned,
      redeemedPoints: transactions.totals.redeemed,
      expiredPoints: transactions.totals.expired,
      transactions: transactions.items
          .map(
            (item) => PointTransactionItem(
              id: item.id,
              kind: _pointKind(item.type.name),
              points: item.points,
              title: item.sourceLabel,
              detail: item.reason,
              createdAt: item.createdAt,
            ),
          )
          .toList(growable: false),
    );
  }

  String? _pointType(PointTypeFilter filter) => switch (filter) {
    PointTypeFilter.all => null,
    PointTypeFilter.earn => 'EARN',
    PointTypeFilter.redeem => 'REDEEM',
    PointTypeFilter.expire => 'EXPIRE',
  };

  PointTransactionKind _pointKind(String type) => switch (type) {
    'EARN' => PointTransactionKind.earn,
    'REDEEM' => PointTransactionKind.redeem,
    'EXPIRE' => PointTransactionKind.expire,
    'ADJUST' => PointTransactionKind.adjust,
    _ => PointTransactionKind.reversal,
  };

  (DateTime?, DateTime?) _pointDateRange(PointDateFilter filter) {
    if (filter == PointDateFilter.all || filter == PointDateFilter.custom) {
      return (null, null);
    }
    final now = DateTime.now();
    final currentMonth = DateTime.utc(now.year, now.month);
    return switch (filter) {
      PointDateFilter.currentMonth => (currentMonth, DateTime.now().toUtc()),
      PointDateFilter.previousMonth => (
        DateTime.utc(now.year, now.month - 1),
        currentMonth.subtract(const Duration(microseconds: 1)),
      ),
      PointDateFilter.threeMonths => (
        DateTime.utc(now.year, now.month - 2),
        DateTime.now().toUtc(),
      ),
      PointDateFilter.sixMonths => (
        DateTime.utc(now.year, now.month - 5),
        DateTime.now().toUtc(),
      ),
      PointDateFilter.all || PointDateFilter.custom => (null, null),
    };
  }

  Future<AccountOverview> _loadAccountOverview() async {
    final response = await _api
        .getPassengerProfileApi()
        .passengerProfileControllerGet();
    final profile = response.data;
    if (profile == null) {
      throw StateError('Profile response did not contain data.');
    }

    final summaries = await Future.wait<Object?>([
      _loadSavedPassengerCount(),
      _loadLoyalty(),
    ]);
    final loyalty = summaries[1] as PassengerLoyaltyDtoOutput?;
    return AccountOverview(
      name: profile.name?.trim().isNotEmpty == true
          ? profile.name!.trim()
          : profile.email.split('@').first,
      email: profile.email,
      emailVerified: profile.emailVerified,
      imageUrl: profile.image,
      availablePoints: loyalty?.availablePoints,
      loyaltyTier: loyalty?.tier.name,
      savedPassengerCount: summaries[0] as int?,
    );
  }

  Future<PassengerProfileFormData> _loadEditableProfile() async {
    final response = await _api
        .getPassengerProfileApi()
        .passengerProfileControllerGet();
    final profile = response.data;
    if (profile == null) {
      throw StateError('Profile response did not contain data.');
    }
    return PassengerProfileFormData(
      name: profile.name?.trim() ?? '',
      email: profile.email,
      emailVerified: profile.emailVerified,
      phone: profile.phone,
      dateOfBirth: profile.dateOfBirth?.toDateTime(),
      imageUrl: profile.image,
    );
  }

  Future<bool> _saveEditableProfile(PassengerProfileFormUpdate update) async {
    PassengerProfileDtoOutput? profile;
    final saved = await _run(() async {
      final response = await _api
          .getPassengerProfileApi()
          .passengerProfileControllerUpdate(
            passengerProfileUpdateDto: PassengerProfileUpdateDto((builder) {
              builder.name = update.name;
              if (update.phone != null) builder.phone = update.phone;
              final dateOfBirth = update.dateOfBirth;
              if (dateOfBirth != null) {
                builder.dateOfBirth = Date(
                  dateOfBirth.year,
                  dateOfBirth.month,
                  dateOfBirth.day,
                );
              }
            }),
          );
      profile = response.data;
      if (profile == null) {
        throw StateError('Profile update response did not contain data.');
      }
    });
    if (saved && mounted) {
      setState(() => _displayName = profile!.name?.trim());
    }
    return saved;
  }

  Future<bool> _logout() async {
    final succeeded = await _run(() async {
      await _api.getAuthApi().authControllerLogout(xAuthTransport: 'bearer');
      await _tokens.clear();
    });
    if (!succeeded || !mounted) return false;

    setState(() {
      _step = _AuthStep.email;
      _email = null;
      _profileEmail = null;
      _displayName = null;
      _otpIssuedAt = null;
      _currentTab = 2;
      _accountView = _AccountView.overview;
      _error = null;
    });
    return true;
  }

  void _selectMainTab(int index) {
    if (index == 0 ||
        index == 1 ||
        index == 2 ||
        (index == 3 && _step == _AuthStep.guest) ||
        index == 4) {
      setState(() {
        _currentTab = index;
        _accountView = _AccountView.overview;
        _error = null;
      });
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '${RouteDockTabBar.labels[index]} sẽ được triển khai ở bước tiếp theo.',
          ),
        ),
      );
  }

  /// Trang chủ bấm "Tìm chuyến": mở màn Kết quả để chọn chuyến theo điều kiện
  /// đã nhập; quay lại thì về Trang chủ. Tab Mua vé dùng lại điều kiện này.
  void _openTripResults(HomeSearchQuery query) {
    _lastSearchQuery = query;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TripResultsScreen(
          query: query,
          searchTrips: _bookingApi.searchTrips,
          searchCatalog: _searchCatalog,
          onTripSelected: _openTripDetail,
        ),
      ),
    );
  }

  /// Mở chi tiết chuyến từ danh sách Mua vé, giữ điểm đón / trả khớp lần tìm.
  void _openTripDetail(TripSummary trip, HomeSearchQuery? query) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TripDetailScreen(
          api: _bookingApi,
          tripId: trip.tripId,
          fromLabel: query?.from.name,
          toLabel: query?.to.name,
          pickupSequence: trip.pickup.sequence,
          dropoffSequence: trip.dropoff.sequence,
        ),
      ),
    );
  }

  /// Tuyến phổ biến (cặp tỉnh) — cùng nguồn `GET /catalog/popular-routes` với
  /// web, thay danh sách gõ cứng trước đây (từng trỏ tỉnh "Bình Thuận" đã sáp
  /// nhập). Giá "từ" theo bảng giá đang áp dụng của tuyến nên không phụ thuộc
  /// ngày đi; tuyến chưa có giá thì bỏ (chưa đặt được).
  Future<List<HomePopularRoute>> _loadPopularRoutes(DateTime _) async {
    final response = await _api
        .getCatalogApi()
        .catalogControllerListPopularRoutes(limit: _popularRouteCount);
    final items = response.data?.items;
    if (items == null) {
      throw StateError('Popular routes response did not contain data.');
    }
    final routes = <HomePopularRoute>[];
    for (final route in items) {
      final minPrice = route.minPrice;
      if (minPrice == null) continue;
      final from = shortProvinceName(route.originName);
      final to = shortProvinceName(route.destinationName);
      routes.add(
        HomePopularRoute(
          from: HomeLocation(id: route.originProvinceId, name: from),
          to: HomeLocation(id: route.destinationProvinceId, name: to),
          fromLabel: _cardLabel(from),
          toLabel: _cardLabel(to),
          minPriceVnd: minPrice,
          fallbackAsset: _destinationAsset(
            route.destinationName,
            routes.length,
          ),
        ),
      );
    }
    return routes;
  }

  Future<List<HomeFaqItem>> _loadHomeFaqs() async {
    final response = await _api.getContentPagesApi().contentPageControllerList(
      type: 'FAQ',
    );
    final items = response.data?.items;
    if (items == null) {
      throw StateError('FAQ response did not contain data.');
    }
    return items
        .map((item) => HomeFaqItem(title: item.title, body: item.bodyMarkdown))
        .toList(growable: false);
  }

  Future<void> _callSupport() async {
    if (await _launchSupportHotline('1900 636 707') || !mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Không thể mở ứng dụng gọi điện trên thiết bị này.'),
        ),
      );
  }

  Future<bool> _launchSupportHotline(String hotline) {
    final digits = hotline.replaceAll(RegExp(r'\D'), '');
    return launchUrl(
      Uri(scheme: 'tel', path: digits),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    return AnimatedSwitcher(
      key: const Key('auth-flow-transition'),
      duration: disableAnimations
          ? Duration.zero
          : const Duration(milliseconds: 420),
      reverseDuration: disableAnimations
          ? Duration.zero
          : const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, .025),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: KeyedSubtree(
        key: ValueKey('auth-step-${_step.name}'),
        child: _buildCurrentView(context),
      ),
    );
  }

  Widget _buildCurrentView(BuildContext context) {
    if ((_step == _AuthStep.signedIn || _step == _AuthStep.guest) &&
        _currentTab == 0) {
      return ExploreScreen(
        onTabSelected: _selectMainTab,
        loadFeed: _articleApi.loadFeed,
        loadArticle: _articleApi.loadArticle,
      );
    }
    if ((_step == _AuthStep.signedIn || _step == _AuthStep.guest) &&
        _currentTab == 1) {
      return TicketScreen(
        onTabSelected: _selectMainTab,
        searchCatalog: _searchCatalog,
        searchTrips: _bookingApi.searchTrips,
        loadOperatorFare: _bookingApi.loadOperatorMinFare,
        initialQuery: _lastSearchQuery,
        // Chưa tìm lần nào: xem mọi chuyến sắp chạy, không cần nhập điểm hay ngày.
        browseTrips: _bookingApi.browseTrips,
        onQueryChanged: (query) => _lastSearchQuery = query,
        onTripSelected: _openTripDetail,
      );
    }
    if (_step == _AuthStep.guest && _currentTab == 3) {
      return GuestJourneyFlow(
        onLoginRequested: _returnToLogin,
        onTabSelected: _selectMainTab,
        onFaqRequested: () => showHomeFaqSheet(context, _loadHomeFaqs),
        onSupportRequested: _callSupport,
      );
    }
    if (_step == _AuthStep.guest && _currentTab == 4) {
      return GuestAccountScreen(
        onLoginRequested: _returnToLogin,
        onTabSelected: _selectMainTab,
        onCallHotline: _launchSupportHotline,
      );
    }
    if (_step == _AuthStep.signedIn) {
      if (_currentTab == 4) {
        if (_accountView == _AccountView.savedPassengers) {
          return SavedPassengersScreen(
            loadPassengers: _loadSavedPassengers,
            createPassenger: _createSavedPassenger,
            updatePassenger: _updateSavedPassenger,
            deletePassenger: _deleteSavedPassenger,
            onBack: () => setState(() {
              _accountView = _AccountView.overview;
              _error = null;
            }),
          );
        }
        if (_accountView == _AccountView.editProfile) {
          return EditProfileScreen(
            loadProfile: _loadEditableProfile,
            saveProfile: _saveEditableProfile,
            errorMessage: _error,
            onFieldChanged: _clearFeedback,
            onBack: () => setState(() {
              _accountView = _AccountView.overview;
              _error = null;
            }),
            onSaved: () => setState(() {
              _accountView = _AccountView.overview;
              _error = null;
            }),
          );
        }
        if (_accountView == _AccountView.vouchers) {
          return VoucherWalletScreen(
            loadVouchers: _loadVoucherWallet,
            saveVoucherCode: _saveVoucherCode,
            errorMessage: _error,
            onCodeChanged: _clearFeedback,
            onBack: () => setState(() {
              _accountView = _AccountView.overview;
              _error = null;
            }),
          );
        }
        if (_accountView == _AccountView.points) {
          return PointHistoryScreen(
            loadHistory: _loadPointHistory,
            onLearnMore: () => setState(() {
              _accountView = _AccountView.overview;
              _error = null;
            }),
            onBack: () => setState(() {
              _accountView = _AccountView.overview;
              _error = null;
            }),
          );
        }
        if (_accountView == _AccountView.reviews) {
          return MyReviewsScreen(
            loadReviews: _loadMyReviews,
            submitReview: _submitReview,
            errorMessage: _error,
            onInputChanged: _clearFeedback,
            onBack: () => setState(() {
              _accountView = _AccountView.overview;
              _error = null;
            }),
          );
        }
        if (_accountView == _AccountView.notificationSettings) {
          return NotificationSettingsScreen(
            onBack: () => setState(() {
              _accountView = _AccountView.overview;
              _error = null;
            }),
          );
        }
        if (_accountView == _AccountView.loginSessions) {
          return LoginSessionsScreen(
            onBack: () => setState(() {
              _accountView = _AccountView.overview;
              _error = null;
            }),
          );
        }
        return AccountScreen(
          loadOverview: _loadAccountOverview,
          onLogout: _logout,
          onTabSelected: _selectMainTab,
          onEditProfile: () => setState(() {
            _accountView = _AccountView.editProfile;
            _error = null;
          }),
          onSavedPassengers: () => setState(() {
            _accountView = _AccountView.savedPassengers;
            _error = null;
          }),
          onVoucherWallet: () => setState(() {
            _accountView = _AccountView.vouchers;
            _error = null;
          }),
          onPointHistory: () => setState(() {
            _accountView = _AccountView.points;
            _error = null;
          }),
          onMyReviews: () => setState(() {
            _accountView = _AccountView.reviews;
            _error = null;
          }),
          onNotificationSettings: () => setState(() {
            _accountView = _AccountView.notificationSettings;
            _error = null;
          }),
          onLoginSessions: () => setState(() {
            _accountView = _AccountView.loginSessions;
            _error = null;
          }),
          logoutErrorMessage: _error,
        );
      }
      return _home(isLoggedIn: true);
    }
    if (_step == _AuthStep.guest) return _home(isLoggedIn: false);
    if (_step == _AuthStep.profile) {
      return ProfileCompletionScreen(
        email: _profileEmail ?? _email!,
        busy: _busy,
        errorMessage: _error,
        onComplete: _completeProfile,
      );
    }

    // Splash chỉ chạy lần mở app đầu tiên; quay lại đăng nhập sau đó (bấm Đăng nhập, đăng xuất, sửa email)
    // dựng lại màn nên phải tắt intro, nếu không splash chạy lại. `playIntro` chỉ được đọc lúc màn mới dựng.
    final playIntro = !_loginIntroPlayed;
    _loginIntroPlayed = true;
    return IndexedStack(
      index: _step == _AuthStep.email ? 0 : 1,
      children: [
        AuthEntryScreen(
          playIntro: playIntro,
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
      searchCatalog: _searchCatalog,
      loadPopularRoutes: _loadPopularRoutes,
      loadFaqs: _loadHomeFaqs,
      onSearch: _openTripResults,
      onCallHotline: _launchSupportHotline,
      onLoginRequested: isLoggedIn ? null : _returnToLogin,
      onTabSelected: _selectMainTab,
    );
  }
}
