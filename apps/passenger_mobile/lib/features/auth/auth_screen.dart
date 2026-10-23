import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/auth/auth_motion_timeline.dart';

const _canvasWidth = 412.0;
const _figmaCanvasHeight = 915.0;
const _loginFormHeight = 481.0;
const _otpFormHeight = 481.0;
const _minimumFormTop = 394.0;
const _minimumSystemBottomInset = 24.0;
const _formBottomSpacing = 16.0;
const _fontFamily = 'Be Vietnam Pro';

const _primary50 = Color(0xFFEBF5FB);
const _primary100 = Color(0xFFC8E3F3);
const _primary200 = Color(0xFF95C8E8);
const _primary300 = Color(0xFF62ACDC);
const _primary500 = Color(0xFF2B7EAD);
const _primary800 = Color(0xFF123D5C);
const _primary900 = Color(0xFF0A2840);
const _neutral0 = Color(0xFFFFFFFF);
const _neutral100 = Color(0xFFE4E5E7);
const _neutral600 = Color(0xFF5E6165);
const _neutral900 = Color(0xFF1C1E22);
const _textTertiary = Color(0xFF93969A);
const _link = Color(0xFF226A92);
const _error = Color(0xFFB3261E);
const _success = Color(0xFF277A43);
const _otpInk = Color(0xFF172B35);
const _otpMuted = Color(0xFF667680);
const _otpBorder = Color(0xFFD9E1E5);
const _otpFieldFill = Color(0xFFF7F9FB);
const _otpFocus = Color(0xFF00506A);

const _assetRoot = 'assets/auth';
const _waveFormBackgroundAsset = '$_assetRoot/waves/form_background.svg';
const _waveFormBackgroundLoader = _FilterlessSvgAssetLoader(
  _waveFormBackgroundAsset,
);
const _motionSvgAssets = <String>[
  '$_assetRoot/splash/mountains_far.svg',
  '$_assetRoot/splash/mountains_near.svg',
  '$_assetRoot/splash/hill.svg',
  '$_assetRoot/landscape/sun_halo_outer.svg',
  '$_assetRoot/landscape/sun_halo_inner.svg',
  '$_assetRoot/landscape/sun.svg',
  '$_assetRoot/landscape/mountains_far.svg',
  '$_assetRoot/landscape/cloud_c.svg',
  '$_assetRoot/landscape/mountains_near.svg',
  '$_assetRoot/landscape/cloud_a.svg',
  '$_assetRoot/landscape/cloud_b.svg',
  '$_assetRoot/landscape/hill.svg',
  '$_assetRoot/landscape/pine_1.svg',
  '$_assetRoot/landscape/pine_2.svg',
  '$_assetRoot/landscape/pine_3.svg',
  '$_assetRoot/landscape/pine_4.svg',
  '$_assetRoot/landscape/pine_5.svg',
  '$_assetRoot/landscape/ground.svg',
  '$_assetRoot/landscape/road.svg',
  '$_assetRoot/bus/shadow.svg',
  '$_assetRoot/bus/speed_streak_top.svg',
  '$_assetRoot/bus/speed_streak_middle.svg',
  '$_assetRoot/bus/speed_streak_bottom.svg',
  '$_assetRoot/bus/body.svg',
  '$_assetRoot/bus/wheel_rear.svg',
  '$_assetRoot/bus/wheel_front.svg',
  '$_assetRoot/waves/back.svg',
  _waveFormBackgroundAsset,
  '$_assetRoot/logo/light_mark.svg',
  '$_assetRoot/logo/light_wordmark.svg',
  '$_assetRoot/logo/dark_mark.svg',
  '$_assetRoot/logo/dark_wordmark.svg',
  '$_assetRoot/icons/cta_shine.svg',
  '$_assetRoot/icons/google.svg',
  '$_assetRoot/icons/facebook.svg',
];

class AuthEntryScreen extends StatefulWidget {
  const AuthEntryScreen({
    required this.onRequestOtp,
    this.onEmailChanged,
    this.onContinueAsGuest,
    this.busy = false,
    this.errorMessage,
    this.otpRequested = false,
    this.precacheMotionAssets = true,
    super.key,
  });

  final Future<void> Function(String email) onRequestOtp;
  final VoidCallback? onEmailChanged;
  final VoidCallback? onContinueAsGuest;
  final bool busy;
  final String? errorMessage;
  final bool otpRequested;
  final bool precacheMotionAssets;

  @override
  State<AuthEntryScreen> createState() => _AuthEntryScreenState();
}

class _AuthEntryScreenState extends State<AuthEntryScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motionController = AnimationController(
    vsync: this,
    duration: AuthMotionTimeline.duration,
  );
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  bool _motionStarted = false;
  String? _localError;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_motionStarted) return;

    _motionStarted = true;
    if (MediaQuery.of(context).disableAnimations) {
      _motionController.value = 1;
    } else if (widget.precacheMotionAssets) {
      _precacheAndStartMotion();
    } else {
      _motionController.forward();
    }
  }

  Future<void> _precacheAndStartMotion() async {
    for (final asset in _motionSvgAssets) {
      if (asset == _waveFormBackgroundAsset) {
        await _waveFormBackgroundLoader.loadBytes(context);
      } else {
        await SvgAssetLoader(asset).loadBytes(context);
      }
      if (!mounted) return;
    }
    await precacheImage(
      const AssetImage('$_assetRoot/icons/apple.png'),
      context,
    );
    if (mounted) _motionController.forward();
  }

  @override
  void dispose() {
    _motionController.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (widget.busy) return;

    final email = _emailController.text.trim();
    if (!_isValidEmail(email)) {
      setState(() => _localError = 'Vui lòng nhập một địa chỉ email hợp lệ.');
      _emailFocusNode.requestFocus();
      return;
    }

    setState(() => _localError = null);
    await widget.onRequestOtp(email);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }

  void _handleEmailChanged(String _) {
    if (_localError != null) setState(() => _localError = null);
    widget.onEmailChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      backgroundColor: _primary50,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        bottom: false,
        child: _ResponsiveAuthCanvas(
          motion: _motionController,
          emailController: _emailController,
          emailFocusNode: _emailFocusNode,
          busy: widget.busy,
          localError: _localError,
          apiError: widget.errorMessage,
          otpRequested: widget.otpRequested,
          onEmailChanged: _handleEmailChanged,
          onSubmit: _submit,
          onContinueAsGuest: widget.onContinueAsGuest,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _motionController,
      child: scaffold,
      builder: (context, child) {
        final progress = _motionController.value;
        final useLightSystemIcons = progress < 0.175;
        final brightness = useLightSystemIcons
            ? Brightness.light
            : Brightness.dark;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: brightness,
            statusBarBrightness: useLightSystemIcons
                ? Brightness.dark
                : Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: brightness,
            systemStatusBarContrastEnforced: false,
            systemNavigationBarContrastEnforced: false,
          ),
          child: child!,
        );
      },
    );
  }
}

typedef OtpVerifyCallback = Future<bool> Function(String otp);
typedef OtpResendCallback = Future<bool> Function();

/// Màn nhập OTP dùng cùng cảnh nền hoàn chỉnh của Login nhưng không khởi chạy
/// lại timeline Splash/Login khi được đưa vào luồng xác thực.
class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({
    required this.email,
    required this.issuedAt,
    required this.onVerify,
    required this.onResend,
    required this.onEditEmail,
    this.onOtpChanged,
    this.errorMessage,
    this.busy = false,
    this.now = DateTime.now,
    super.key,
  });

  final String email;
  final DateTime issuedAt;
  final OtpVerifyCallback onVerify;
  final OtpResendCallback onResend;
  final VoidCallback onEditEmail;
  final VoidCallback? onOtpChanged;
  final String? errorMessage;
  final bool busy;

  /// Có thể thay bằng clock giả trong widget test. Production dùng đồng hồ máy.
  final DateTime Function() now;

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with WidgetsBindingObserver {
  static const _otpLifetime = Duration(minutes: 5);
  static const _resendCooldown = Duration(seconds: 60);

  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();
  Timer? _ticker;
  late DateTime _issuedAt;
  bool _submitting = false;
  bool _resending = false;

  String get _otp => _otpController.text;

  int get _expirySeconds => _secondsUntil(_issuedAt.add(_otpLifetime));
  int get _cooldownSeconds => _secondsUntil(_issuedAt.add(_resendCooldown));

  bool get _expired => _expirySeconds == 0;
  bool get _canVerify =>
      _otp.length == 6 &&
      !_expired &&
      !widget.busy &&
      !_submitting &&
      !_resending;

  @override
  void initState() {
    super.initState();
    _issuedAt = widget.issuedAt;
    WidgetsBinding.instance.addObserver(this);
    _otpFocusNode.addListener(_refresh);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _refresh());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _otpFocusNode.requestFocus();
    });
  }

  @override
  void didUpdateWidget(covariant EmailVerificationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.issuedAt != widget.issuedAt) {
      _issuedAt = widget.issuedAt;
      _refresh();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    _otpFocusNode
      ..removeListener(_refresh)
      ..dispose();
    _otpController
      ..clear()
      ..dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  int _secondsUntil(DateTime deadline) {
    final milliseconds = deadline.difference(widget.now()).inMilliseconds;
    if (milliseconds <= 0) return 0;
    return (milliseconds / Duration.millisecondsPerSecond).ceil();
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void _handleOtpChanged(String rawValue) {
    final digits = rawValue.replaceAll(RegExp(r'[^0-9]'), '');
    final normalized = digits.length <= 6 ? digits : digits.substring(0, 6);
    if (_otpController.text != normalized) {
      _otpController.value = TextEditingValue(
        text: normalized,
        selection: TextSelection.collapsed(offset: normalized.length),
      );
    }
    widget.onOtpChanged?.call();
    _refresh();
  }

  Future<void> _verify() async {
    if (!_canVerify) return;
    setState(() => _submitting = true);
    final verified = await widget.onVerify(_otp);
    if (!mounted) return;
    setState(() => _submitting = false);
    if (!verified) _otpFocusNode.requestFocus();
  }

  Future<void> _resend() async {
    if (_cooldownSeconds > 0 || widget.busy || _resending || _submitting) {
      return;
    }

    setState(() => _resending = true);
    final accepted = await widget.onResend();
    if (!mounted) return;
    setState(() {
      _resending = false;
      if (accepted) {
        _issuedAt = widget.now();
        _otpController.clear();
      }
    });
    if (accepted) {
      widget.onOtpChanged?.call();
      _otpFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: _primary50,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          top: false,
          bottom: false,
          child: _ResponsiveOtpCanvas(content: _verificationContent(context)),
        ),
      ),
    );
  }

  Widget _verificationContent(BuildContext context) {
    final localExpiryError = _expired
        ? 'Mã đã hết hạn. Hãy gửi lại mã mới.'
        : null;
    final feedback = widget.errorMessage ?? localExpiryError;
    final helperText =
        feedback ?? 'Gõ hoặc dán mã gồm 6 số được gửi từ Vé Xe Nhanh.';
    final showError = feedback != null;

    return SizedBox(
      key: const Key('otp-content'),
      height: _otpFormHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            left: 0,
            top: 0,
            child: Text(
              'Xác nhận email',
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 28,
                fontWeight: FontWeight.w600,
                height: 1,
                color: _primary900,
              ),
            ),
          ),
          const Positioned(
            left: 0,
            top: 34,
            width: 278,
            child: Text(
              'Nếu email hợp lệ, mã xác minh sẽ được gửi đến bạn.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.2,
                color: _neutral600,
              ),
            ),
          ),
          Positioned(
            right: -8,
            top: 27,
            child: TextButton(
              key: const Key('edit-email-button'),
              onPressed: widget.busy ? null : widget.onEditEmail,
              style: TextButton.styleFrom(
                foregroundColor: _otpFocus,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Sửa email',
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ),
          const Positioned(
            left: 0,
            top: 82,
            child: Text(
              'MÃ OTP (6 CHỮ SỐ)',
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 16 / 12,
                letterSpacing: 0.6,
                color: _otpInk,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 108,
            width: 364,
            height: 60,
            child: _otpInputs(),
          ),
          Positioned(
            left: 0,
            top: 178,
            width: 364,
            height: 32,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                helperText,
                key: const Key('otp-feedback'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 16 / 12,
                  color: showError ? _error : _otpMuted,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 217,
            width: 364,
            height: 90,
            child: _timerAndResend(),
          ),
          Positioned(
            left: 0,
            top: 385,
            width: 364,
            child: _bottomActions(context),
          ),
        ],
      ),
    );
  }

  Widget _otpInputs() {
    final activeIndex = math.min(_otp.length, 5);
    return Stack(
      children: [
        ExcludeSemantics(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final digit = index < _otp.length ? _otp[index] : '';
              final active =
                  _otpFocusNode.hasFocus &&
                  index == activeIndex &&
                  !widget.busy;
              return AnimatedContainer(
                key: Key('otp-box-$index'),
                duration: const Duration(milliseconds: 120),
                width: 50,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? _neutral0 : _otpFieldFill,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: active ? _otpFocus : _otpBorder,
                    width: 2,
                  ),
                  boxShadow: active
                      ? const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 80, 106, 0.18),
                            spreadRadius: 3,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  digit,
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: _otpInk,
                  ),
                ),
              );
            }),
          ),
        ),
        Positioned.fill(
          child: AutofillGroup(
            child: TextField(
              key: const Key('otp-field'),
              controller: _otpController,
              focusNode: _otpFocusNode,
              enabled: !widget.busy,
              autofocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              onChanged: _handleOtpChanged,
              onSubmitted: (_) => _verify(),
              showCursor: false,
              cursorColor: Colors.transparent,
              style: const TextStyle(
                color: Colors.transparent,
                fontSize: 1,
                height: 1,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                counterText: '',
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _timerAndResend() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: _otpBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20,
            child: Row(
              children: [
                SvgPicture.asset(
                  '$_assetRoot/icons/otp_clock.svg',
                  width: 16,
                  height: 16,
                  excludeFromSemantics: true,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Hiệu lực của mã:',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                      color: _otpMuted,
                    ),
                  ),
                ),
                Text(
                  _formatDuration(_expirySeconds),
                  key: const Key('otp-expiry'),
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 20 / 14,
                    letterSpacing: 0.35,
                    color: _otpInk,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 10),
          SizedBox(
            height: 17,
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Chưa nhận được mã?',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                      color: _otpMuted,
                    ),
                  ),
                ),
                if (_resending)
                  const SizedBox(
                    key: Key('otp-resend-loading'),
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _otpFocus,
                    ),
                  )
                else if (_cooldownSeconds > 0)
                  Text.rich(
                    key: const Key('otp-resend-cooldown'),
                    TextSpan(
                      children: [
                        const TextSpan(text: 'Gửi lại sau '),
                        TextSpan(
                          text: _formatDuration(_cooldownSeconds),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _otpFocus,
                          ),
                        ),
                      ],
                    ),
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                      color: _otpMuted,
                    ),
                  )
                else
                  TextButton(
                    key: const Key('otp-resend-button'),
                    onPressed: widget.busy ? null : _resend,
                    style: TextButton.styleFrom(
                      foregroundColor: _otpFocus,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 20),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Gửi lại mã',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 16 / 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomActions(BuildContext context) {
    return Column(
      children: [
        Semantics(
          button: true,
          enabled: _canVerify,
          child: SizedBox(
            height: 56,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: _canVerify
                      ? const LinearGradient(
                          colors: [Color(0xFFF4B028), Color(0xFFEA831D)],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFFF1C97A), Color(0xFFE6AA70)],
                        ),
                ),
                child: InkWell(
                  key: const Key('otp-verify-button'),
                  onTap: _canVerify ? _verify : null,
                  child: Center(
                    child: _submitting
                        ? const SizedBox(
                            key: Key('otp-verify-loading'),
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: _neutral0,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Xác minh',
                                style: TextStyle(
                                  fontFamily: _fontFamily,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                  color: _neutral0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                '$_assetRoot/icons/otp_arrow.svg',
                                width: 20,
                                height: 20,
                                excludeFromSemantics: true,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 24,
          child: TextButton(
            key: const Key('otp-support-button'),
            onPressed: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Vui lòng gọi tổng đài 1900 6868 để được hỗ trợ.',
                    ),
                  ),
                );
            },
            style: TextButton.styleFrom(
              foregroundColor: _otpFocus,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 24),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text.rich(
              TextSpan(
                children: const [
                  TextSpan(
                    text: 'Cần hỗ trợ? ',
                    style: TextStyle(
                      color: _otpMuted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'Liên hệ tổng đài 1900 6868',
                    style: TextStyle(
                      color: _otpFocus,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationThickness: 1,
                    ),
                  ),
                ],
              ),
              style: const TextStyle(
                fontFamily: _fontFamily,
                fontSize: 12,
                height: 16 / 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResponsiveAuthCanvas extends StatelessWidget {
  const _ResponsiveAuthCanvas({
    required this.motion,
    required this.emailController,
    required this.emailFocusNode,
    required this.busy,
    required this.localError,
    required this.apiError,
    required this.otpRequested,
    required this.onEmailChanged,
    required this.onSubmit,
    this.onContinueAsGuest,
  });

  final Animation<double> motion;
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final bool busy;
  final String? localError;
  final String? apiError;
  final bool otpRequested;
  final ValueChanged<String> onEmailChanged;
  final VoidCallback onSubmit;
  final VoidCallback? onContinueAsGuest;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaQuery = MediaQuery.of(context);
        final canvasScale = constraints.maxWidth / _canvasWidth;
        final viewportHeight = mediaQuery.size.height / canvasScale;
        final safeTop = mediaQuery.padding.top / canvasScale;
        final safeBottom = mediaQuery.padding.bottom / canvasScale;
        final reservedBottom = math.max(safeBottom, _minimumSystemBottomInset);
        final formTop = math.max(
          _minimumFormTop,
          viewportHeight -
              reservedBottom -
              _formBottomSpacing -
              _loginFormHeight,
        );
        final contentHeight = math.max(
          viewportHeight,
          formTop + _loginFormHeight + reservedBottom + _formBottomSpacing,
        );

        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            key: const Key('auth-responsive-viewport'),
            width: constraints.maxWidth,
            height: contentHeight * canvasScale,
            child: OverflowBox(
              alignment: Alignment.topLeft,
              minWidth: _canvasWidth,
              maxWidth: _canvasWidth,
              minHeight: contentHeight,
              maxHeight: contentHeight,
              child: Transform.scale(
                scale: canvasScale,
                alignment: Alignment.topLeft,
                child: RepaintBoundary(
                  child: _AuthCanvas(
                    canvasHeight: contentHeight,
                    viewportHeight: viewportHeight,
                    safeTop: safeTop,
                    safeBottom: safeBottom,
                    formTop: formTop,
                    motion: motion,
                    emailController: emailController,
                    emailFocusNode: emailFocusNode,
                    busy: busy,
                    localError: localError,
                    apiError: apiError,
                    otpRequested: otpRequested,
                    onEmailChanged: onEmailChanged,
                    onSubmit: onSubmit,
                    onContinueAsGuest: onContinueAsGuest,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ResponsiveOtpCanvas extends StatelessWidget {
  const _ResponsiveOtpCanvas({required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaQuery = MediaQuery.of(context);
        final canvasScale = constraints.maxWidth / _canvasWidth;
        final viewportHeight = mediaQuery.size.height / canvasScale;
        final safeTop = mediaQuery.padding.top / canvasScale;
        final safeBottom = mediaQuery.padding.bottom / canvasScale;
        final reservedBottom = math.max(safeBottom, _minimumSystemBottomInset);
        final formTop = math.max(
          _minimumFormTop,
          viewportHeight - reservedBottom - _formBottomSpacing - _otpFormHeight,
        );
        final contentHeight = math.max(
          viewportHeight,
          formTop + _otpFormHeight + reservedBottom + _formBottomSpacing,
        );

        return SingleChildScrollView(
          key: const Key('otp-scroll-view'),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            key: const Key('otp-responsive-viewport'),
            width: constraints.maxWidth,
            height: contentHeight * canvasScale,
            child: OverflowBox(
              alignment: Alignment.topLeft,
              minWidth: _canvasWidth,
              maxWidth: _canvasWidth,
              minHeight: contentHeight,
              maxHeight: contentHeight,
              child: Transform.scale(
                scale: canvasScale,
                alignment: Alignment.topLeft,
                child: RepaintBoundary(
                  child: _AuthCanvas(
                    canvasHeight: contentHeight,
                    viewportHeight: viewportHeight,
                    safeTop: safeTop,
                    safeBottom: safeBottom,
                    formTop: formTop,
                    motion: const AlwaysStoppedAnimation(1),
                    foreground: content,
                    showSplashOverlay: false,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AuthCanvas extends StatelessWidget {
  const _AuthCanvas({
    required this.canvasHeight,
    required this.viewportHeight,
    required this.safeTop,
    required this.safeBottom,
    required this.formTop,
    required this.motion,
    this.emailController,
    this.emailFocusNode,
    this.busy = false,
    this.localError,
    this.apiError,
    this.otpRequested = false,
    this.onEmailChanged,
    this.onSubmit,
    this.onContinueAsGuest,
    this.foreground,
    this.showSplashOverlay = true,
  }) : assert(
         foreground != null ||
             (emailController != null &&
                 emailFocusNode != null &&
                 onEmailChanged != null &&
                 onSubmit != null),
       );

  final double canvasHeight;
  final double viewportHeight;
  final double safeTop;
  final double safeBottom;
  final double formTop;
  final Animation<double> motion;
  final TextEditingController? emailController;
  final FocusNode? emailFocusNode;
  final bool busy;
  final String? localError;
  final String? apiError;
  final bool otpRequested;
  final ValueChanged<String>? onEmailChanged;
  final VoidCallback? onSubmit;
  final VoidCallback? onContinueAsGuest;
  final Widget? foreground;
  final bool showSplashOverlay;

  @override
  Widget build(BuildContext context) {
    final logoTop = math.max(60.0, safeTop + 12);
    final sceneOffset = math.max(0.0, formTop - 394);

    return ColoredBox(
      color: _primary50,
      child: SizedBox(
        width: _canvasWidth,
        height: canvasHeight,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            _hero(sceneOffset),
            _waves(formTop),
            Positioned(
              left: 24,
              top: formTop,
              width: 364,
              child:
                  foreground ??
                  AnimatedBuilder(
                    animation: motion,
                    child: _loginForm(context),
                    builder: (context, child) => IgnorePointer(
                      ignoring: motion.value < 0.645,
                      child: child,
                    ),
                  ),
            ),
            Positioned(
              left: 24,
              top: logoTop,
              child: AuthMotionNode(
                nodeId: '1259:253',
                animation: motion,
                child: _logoPill(),
              ),
            ),
            if (showSplashOverlay)
              IgnorePointer(
                child: _splashOverlay(
                  viewportHeight: viewportHeight,
                  safeBottom: safeBottom,
                  logoTop: logoTop,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _hero(double sceneOffset) {
    return Positioned.fill(
      child: ColoredBox(
        color: _primary500,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: 0,
              top: 0,
              width: 412,
              height: 440 + sceneOffset,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_primary300, _primary200, _primary100],
                    stops: [0, 0.5, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 254,
              top: 62 + sceneOffset,
              width: 128,
              height: 128,
              child: AuthMotionNode(
                nodeId: '1255:215',
                animation: motion,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: AuthMotionNode(
                        nodeId: '1255:216',
                        animation: motion,
                        child: _svg('landscape/sun_halo_outer.svg'),
                      ),
                    ),
                    Positioned(
                      left: 21,
                      top: 21,
                      width: 86,
                      height: 86,
                      child: AuthMotionNode(
                        nodeId: '1255:217',
                        animation: motion,
                        child: _svg('landscape/sun_halo_inner.svg'),
                      ),
                    ),
                    Positioned(
                      left: 38,
                      top: 38,
                      width: 52,
                      height: 52,
                      child: _svg('landscape/sun.svg'),
                    ),
                  ],
                ),
              ),
            ),
            _motionSvg(
              nodeId: '1255:219',
              path: 'landscape/mountains_far.svg',
              left: 0,
              top: 160 + sceneOffset,
              width: 412,
              height: 150,
            ),
            Positioned(
              left: 148,
              top: 122 + sceneOffset,
              width: 50,
              height: 21,
              child: AuthMotionNode(
                nodeId: '1255:221',
                animation: motion,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      top: -2.2217,
                      width: 50,
                      height: 23.2217,
                      child: _svg('landscape/cloud_c.svg'),
                    ),
                  ],
                ),
              ),
            ),
            _motionSvg(
              nodeId: '1255:223',
              path: 'landscape/mountains_near.svg',
              left: 0,
              top: 178 + sceneOffset,
              width: 412,
              height: 150,
            ),
            _cloud(
              nodeId: '1255:225',
              path: 'landscape/cloud_a.svg',
              left: 30,
              top: 150 + sceneOffset,
              width: 96,
              slotHeight: 40,
              sourceHeight: 44.2319,
            ),
            _cloud(
              nodeId: '1255:227',
              path: 'landscape/cloud_b.svg',
              left: 228,
              top: 200 + sceneOffset,
              width: 74,
              slotHeight: 31,
              sourceHeight: 34.2797,
            ),
            _motionSvg(
              nodeId: '1255:229',
              path: 'landscape/hill.svg',
              left: 0,
              top: 236 + sceneOffset,
              width: 412,
              height: 110,
            ),
            _motionSvg(
              nodeId: '1255:231',
              path: 'landscape/pine_1.svg',
              left: 61,
              top: 229 + sceneOffset,
              width: 18,
              height: 30,
            ),
            _motionSvg(
              nodeId: '1255:233',
              path: 'landscape/pine_2.svg',
              left: 84,
              top: 226 + sceneOffset,
              width: 14.4,
              height: 24,
            ),
            _motionSvg(
              nodeId: '1255:235',
              path: 'landscape/pine_3.svg',
              left: 313,
              top: 233 + sceneOffset,
              width: 14.4,
              height: 24,
            ),
            _motionSvg(
              nodeId: '1255:237',
              path: 'landscape/pine_4.svg',
              left: 336,
              top: 223 + sceneOffset,
              width: 18,
              height: 30,
            ),
            _motionSvg(
              nodeId: '1255:239',
              path: 'landscape/pine_5.svg',
              left: 364,
              top: 228 + sceneOffset,
              width: 16.2,
              height: 27,
            ),
            _positionedSvg(
              path: 'landscape/ground.svg',
              left: 0,
              top: 276 + sceneOffset,
              width: 412,
              height: 164,
            ),
            Positioned(
              left: 0,
              top: 292 + sceneOffset,
              width: 412,
              height: 28,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    width: 414,
                    height: 28,
                    child: _svg('landscape/road.svg'),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 111,
              top: 247 + sceneOffset,
              width: 190,
              height: 72,
              child: AuthMotionNode(
                nodeId: '1256:214',
                animation: motion,
                child: _bus(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bus() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _positionedSvg(
          path: 'bus/shadow.svg',
          left: 8,
          top: 63,
          width: 176,
          height: 8,
        ),
        Positioned(
          left: -70,
          top: 16,
          width: 64,
          height: 30,
          child: AuthMotionNode(
            nodeId: '1256:217',
            animation: motion,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _positionedSvg(
                  path: 'bus/speed_streak_top.svg',
                  left: 14,
                  top: 0,
                  width: 42,
                  height: 3,
                ),
                _positionedSvg(
                  path: 'bus/speed_streak_middle.svg',
                  left: 0,
                  top: 13,
                  width: 50,
                  height: 3,
                ),
                _positionedSvg(
                  path: 'bus/speed_streak_bottom.svg',
                  left: 24,
                  top: 26,
                  width: 30,
                  height: 3,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 2,
          width: 188,
          height: 54,
          child: AuthMotionNode(
            nodeId: '1256:221',
            animation: motion,
            child: _svg('bus/body.svg'),
          ),
        ),
        Positioned(
          left: 29,
          top: 45,
          width: 22,
          height: 22,
          child: AuthMotionNode(
            nodeId: '1256:237',
            animation: motion,
            child: _svg('bus/wheel_rear.svg'),
          ),
        ),
        Positioned(
          left: 133,
          top: 45,
          width: 22,
          height: 22,
          child: AuthMotionNode(
            nodeId: '1256:242',
            animation: motion,
            child: _svg('bus/wheel_front.svg'),
          ),
        ),
      ],
    );
  }

  Widget _waves(double formTop) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -60,
          top: formTop - 77,
          width: 532,
          height: 678,
          child: AuthMotionNode(
            nodeId: '1259:235',
            animation: motion,
            child: _svg('waves/back.svg'),
          ),
        ),
        Positioned(
          left: 0,
          top: formTop - 62,
          width: 412,
          height: 663,
          child: AuthMotionNode(
            nodeId: '1259:237',
            animation: motion,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: -20,
                  top: -26,
                  width: 452,
                  height: 702.939,
                  child: _waveFormBackground(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _waveFormBackground() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Transform.translate(
            offset: const Offset(0, -6),
            child: ImageFiltered(
              key: const Key('wave-form-shadow'),
              imageFilter: ui.ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
                tileMode: ui.TileMode.decal,
              ),
              child: const SvgPicture(
                _waveFormBackgroundLoader,
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(10, 40, 64, 0.14),
                  BlendMode.srcIn,
                ),
                excludeFromSemantics: true,
              ),
            ),
          ),
        ),
        const Positioned.fill(
          child: SvgPicture(
            _waveFormBackgroundLoader,
            key: Key('wave-form-shape'),
            fit: BoxFit.fill,
            excludeFromSemantics: true,
          ),
        ),
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final feedback = localError ?? apiError;
    final subtitle =
        feedback ??
        (otpRequested
            ? 'Mã xác minh đã được gửi đến email của bạn.'
            : 'Nhập email để nhận mã xác minh');
    final subtitleColor = feedback != null
        ? _error
        : otpRequested
        ? _success
        : _neutral600;
    final hasError = feedback != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthMotionNode(
          nodeId: '1257:221',
          animation: motion,
          child: const Text(
            'Đăng nhập',
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 1,
              color: _primary900,
            ),
          ),
        ),
        const SizedBox(height: 4),
        AuthMotionNode(
          nodeId: '1257:222',
          animation: motion,
          child: Text(
            subtitle,
            key: const Key('auth-feedback'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.2,
              color: subtitleColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        AuthMotionNode(
          nodeId: '1257:223',
          animation: motion,
          child: SizedBox(
            height: 88,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Email',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: _neutral900,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 56,
                  child: TextField(
                    key: const Key('email-field'),
                    controller: emailController!,
                    focusNode: emailFocusNode!,
                    enabled: !busy,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.email],
                    onChanged: onEmailChanged!,
                    onSubmitted: busy ? null : (_) => onSubmit!(),
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: _neutral900,
                    ),
                    decoration: InputDecoration(
                      hintText: 'tenban@email.com',
                      hintStyle: const TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: _neutral600,
                      ),
                      filled: true,
                      fillColor: _neutral0,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: hasError ? _error : _neutral100,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: _neutral100),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: hasError ? _error : _primary500,
                          width: 1.5,
                        ),
                      ),
                    ),
                    cursorColor: _primary500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        AuthMotionNode(
          nodeId: '1259:238',
          animation: motion,
          child: _continueButton(),
        ),
        const SizedBox(height: 16),
        AuthMotionNode(
          nodeId: '1257:229',
          animation: motion,
          child: const SizedBox(
            height: 20,
            child: Row(
              children: [
                Expanded(child: Divider(height: 1, color: _neutral100)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'hoặc',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: _neutral600,
                    ),
                  ),
                ),
                Expanded(child: Divider(height: 1, color: _neutral100)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        AuthMotionNode(
          nodeId: '1257:234',
          animation: motion,
          child: _oauthButton(
            context,
            label: 'Tiếp tục với Google',
            provider: 'Google',
            icon: _svg('icons/google.svg', width: 20, height: 20),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AuthMotionNode(
                nodeId: '1257:242',
                animation: motion,
                child: _oauthButton(
                  context,
                  label: 'Apple',
                  provider: 'Apple',
                  icon: Image.asset(
                    '$_assetRoot/icons/apple.png',
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AuthMotionNode(
                nodeId: '1257:245',
                animation: motion,
                child: _oauthButton(
                  context,
                  label: 'Facebook',
                  provider: 'Facebook',
                  icon: _svg('icons/facebook.svg', width: 20, height: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AuthMotionNode(
          nodeId: '1257:251',
          animation: motion,
          child: SizedBox(
            height: 44,
            child: TextButton(
              key: const Key('guest-button'),
              onPressed:
                  onContinueAsGuest ??
                  () => _showUnavailable(context, 'Chế độ khách'),
              style: TextButton.styleFrom(
                foregroundColor: _primary500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 20 / 14,
                ),
              ),
              child: const Text('Khám phá trước, đăng nhập sau'),
            ),
          ),
        ),
        const SizedBox(height: 2),
        AuthMotionNode(
          nodeId: '1257:253',
          animation: motion,
          child: Text.rich(
            const TextSpan(
              children: [
                TextSpan(text: 'Bằng việc tiếp tục, bạn đồng ý với '),
                TextSpan(
                  text: 'Điều khoản sử dụng',
                  style: TextStyle(
                    color: _link,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: ' và '),
                TextSpan(
                  text: 'Chính sách dữ liệu cá nhân',
                  style: TextStyle(
                    color: _link,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: '.'),
              ],
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: _fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1,
              letterSpacing: 0.12,
              color: _textTertiary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _continueButton() {
    return Semantics(
      button: true,
      enabled: !busy,
      child: SizedBox(
        height: 56,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF4B028), Color(0xFFEA831D)],
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                InkWell(
                  key: const Key('continue-button'),
                  onTap: busy ? null : onSubmit!,
                  child: Center(
                    child: busy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: _neutral0,
                            ),
                          )
                        : const Text(
                            'Tiếp tục',
                            style: TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: _neutral0,
                            ),
                          ),
                  ),
                ),
                IgnorePointer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Positioned(
                          left: -110,
                          top: 0,
                          width: 96,
                          height: 56,
                          child: AuthMotionNode(
                            nodeId: '1259:240',
                            animation: motion,
                            child: _svg('icons/cta_shine.svg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _oauthButton(
    BuildContext context, {
    required String label,
    required String provider,
    required Widget icon,
  }) {
    return Semantics(
      button: true,
      hint: 'Chưa được tích hợp',
      child: SizedBox(
        height: 52,
        child: Material(
          color: _neutral0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: _neutral100),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            key: Key('oauth-${provider.toLowerCase()}'),
            onTap: () => _showUnavailable(context, 'Đăng nhập $provider'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: _neutral900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUnavailable(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$feature chưa được tích hợp trong giai đoạn này.'),
        ),
      );
  }

  Widget _logoPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: _neutral0,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(10, 40, 64, 0.12),
            offset: Offset(0, 4),
            blurRadius: 14,
          ),
        ],
      ),
      child: _lightLogo(),
    );
  }

  Widget _lightLogo() {
    return SizedBox(
      width: 117.422,
      height: 30,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            width: 30,
            height: 30,
            child: _svg('logo/light_mark.svg', fit: BoxFit.contain),
          ),
          Positioned(
            left: 30,
            top: 0,
            width: 87.422,
            height: 30,
            child: _svg('logo/light_wordmark.svg', fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }

  Widget _splashOverlay({
    required double viewportHeight,
    required double safeBottom,
    required double logoTop,
  }) {
    final mountainsFarTop = viewportHeight - (_figmaCanvasHeight - 664);
    final mountainsNearTop = viewportHeight - (_figmaCanvasHeight - 690);
    final hillTop = viewportHeight - (_figmaCanvasHeight - 760);
    final versionTop = viewportHeight - math.max(57.0, safeBottom + 33);

    return Stack(
      children: [
        Positioned.fill(
          child: AuthMotionNode(
            nodeId: '1259:260',
            animation: motion,
            child: ColoredBox(
              color: _primary800,
              child: Stack(
                children: [
                  _positionedSvg(
                    path: 'splash/mountains_far.svg',
                    left: 0,
                    top: mountainsFarTop,
                    width: 412,
                    height: 150,
                  ),
                  _positionedSvg(
                    path: 'splash/mountains_near.svg',
                    left: 0,
                    top: mountainsNearTop,
                    width: 412,
                    height: 150,
                  ),
                  _positionedSvg(
                    path: 'splash/hill.svg',
                    left: 0,
                    top: hillTop,
                    width: 412,
                    height: 200,
                  ),
                  Positioned(
                    left: 40,
                    top: logoTop + 432,
                    width: 332,
                    child: const Text(
                      'Đang chuẩn bị chuyến đi của bạn…',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        color: _primary100,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 140,
                    top: logoTop + 472,
                    width: 132,
                    height: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: const ColoredBox(
                        color: _neutral0,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 52,
                            height: 4,
                            child: ColoredBox(color: Color(0xFFE89B26)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 40,
                    top: versionTop,
                    width: 332,
                    child: const Opacity(
                      opacity: 0.7,
                      child: Text(
                        'PHIÊN BẢN 2.4.0',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          height: 0.2,
                          letterSpacing: 0.88,
                          color: _primary100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 86,
          top: logoTop + 347,
          width: 240,
          height: 61.317,
          child: AuthMotionNode(
            nodeId: '1259:261',
            animation: motion,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  width: 61.317,
                  height: 61.317,
                  child: _svg('logo/dark_mark.svg', fit: BoxFit.contain),
                ),
                Positioned(
                  left: 61.317,
                  top: 0,
                  width: 178.683,
                  height: 61.317,
                  child: _svg('logo/dark_wordmark.svg', fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _cloud({
    required String nodeId,
    required String path,
    required double left,
    required double top,
    required double width,
    required double slotHeight,
    required double sourceHeight,
  }) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: slotHeight,
      child: AuthMotionNode(
        nodeId: nodeId,
        animation: motion,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              top: slotHeight - sourceHeight,
              width: width,
              height: sourceHeight,
              child: _svg(path),
            ),
          ],
        ),
      ),
    );
  }

  Widget _motionSvg({
    required String nodeId,
    required String path,
    required double left,
    required double top,
    required double width,
    required double height,
  }) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: AuthMotionNode(
        nodeId: nodeId,
        animation: motion,
        child: _svg(path),
      ),
    );
  }

  Widget _positionedSvg({
    required String path,
    required double left,
    required double top,
    required double width,
    required double height,
  }) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: _svg(path),
    );
  }

  Widget _svg(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.fill,
  }) {
    return SvgPicture.asset(
      '$_assetRoot/$path',
      width: width,
      height: height,
      fit: fit,
      excludeFromSemantics: true,
    );
  }
}

/// Removes only the unsupported SVG filter at decode time; the source asset
/// remains untouched and its alpha is reused by Flutter for the exact shadow.
@immutable
class _FilterlessSvgAssetLoader extends SvgLoader<ByteData> {
  const _FilterlessSvgAssetLoader(this.assetName);

  static final _filterAttribute = RegExp(r'\sfilter="url\(#[^"]+\)"');
  static final _filterDefinition = RegExp(
    r'<filter\b[^>]*>.*?</filter>',
    dotAll: true,
  );

  final String assetName;

  @override
  Future<ByteData?> prepareMessage(BuildContext? context) {
    final bundle = context == null
        ? rootBundle
        : DefaultAssetBundle.of(context);
    return bundle.load(assetName);
  }

  @override
  String provideSvg(ByteData? message) {
    final source = utf8.decode(
      Uint8List.sublistView(message!),
      allowMalformed: true,
    );
    return source
        .replaceFirst(_filterAttribute, '')
        .replaceFirst(_filterDefinition, '');
  }

  @override
  int get hashCode => Object.hash(runtimeType, assetName);

  @override
  bool operator ==(Object other) {
    return other is _FilterlessSvgAssetLoader && other.assetName == assetName;
  }
}

/// Wrapper thật cho mỗi node motion; origin mặc định là tâm như Figma MCP.
class AuthMotionNode extends StatelessWidget {
  const AuthMotionNode({
    required this.nodeId,
    required this.animation,
    required this.child,
    super.key,
  });

  final String nodeId;
  final Animation<double> animation;
  final Widget child;

  double get progress => animation.value;

  double value(AuthMotionProperty property) {
    return AuthMotionTimeline.value(nodeId, property, progress);
  }

  double get opacity => value(AuthMotionProperty.opacity).clamp(0.0, 1.0);
  double get x => value(AuthMotionProperty.x);
  double get y => value(AuthMotionProperty.y);
  double get scale => value(AuthMotionProperty.scale);
  double get rotationRadians {
    return value(AuthMotionProperty.rotationRadians) +
        value(AuthMotionProperty.rotationDegrees) * math.pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final matrix = Matrix4.identity()
          ..translateByDouble(x, y, 0, 1)
          ..rotateZ(rotationRadians)
          ..scaleByDouble(scale, scale, 1, 1);

        return KeyedSubtree(
          key: Key('motion-$nodeId'),
          child: Opacity(
            opacity: opacity,
            child: Transform(
              alignment: Alignment.center,
              transform: matrix,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
