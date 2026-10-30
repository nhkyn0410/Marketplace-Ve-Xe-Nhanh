import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';
import 'package:passenger_mobile/features/journey/guest_journey_shared.dart';

/// Xác minh mã; trả câu lỗi để hiện dưới ô nhập, `null` = đúng.
typedef JourneyOtpVerifier = Future<String?> Function(String otp);

/// Gửi lại mã; trả câu lỗi, `null` = đã gửi.
typedef JourneyOtpResender = Future<String?> Function();

class GuestJourneyOtpScreen extends StatefulWidget {
  const GuestJourneyOtpScreen({
    required this.maskedEmail,
    required this.onVerify,
    required this.onResend,
    required this.onChangeLookup,
    required this.onTabSelected,
    this.expiresInSeconds = 300,
    this.resendAfterSeconds = 60,
    super.key,
  });

  final String maskedEmail;
  final JourneyOtpVerifier onVerify;
  final JourneyOtpResender onResend;
  final VoidCallback onChangeLookup;
  final ValueChanged<int> onTabSelected;

  /// Hạn của mã vừa gửi (giây) — đếm ngược trên màn.
  final int expiresInSeconds;

  /// Thời gian chờ trước khi được gửi lại (giây).
  final int resendAfterSeconds;

  @override
  State<GuestJourneyOtpScreen> createState() => _GuestJourneyOtpScreenState();
}

class _GuestJourneyOtpScreenState extends State<GuestJourneyOtpScreen> {
  String _otp = '';
  bool _busy = false;
  String? _error;
  late int _expiresIn = widget.expiresInSeconds;
  late int _resendIn = widget.resendAfterSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_expiresIn == 0 && _resendIn == 0) return;
      setState(() {
        if (_expiresIn > 0) _expiresIn--;
        if (_resendIn > 0) _resendIn--;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _countdown =>
      '${(_expiresIn ~/ 60).toString().padLeft(2, '0')}:'
      '${(_expiresIn % 60).toString().padLeft(2, '0')}';

  Future<void> _verify() async {
    if (_otp.length != 6) {
      setState(() => _error = 'Vui lòng nhập đủ 6 số OTP.');
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    final error = await widget.onVerify(_otp);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
    });
  }

  Future<void> _resend() async {
    if (_resendIn > 0 || _busy) return;
    setState(() => _busy = true);
    final error = await widget.onResend();
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
      if (error == null) {
        _expiresIn = widget.expiresInSeconds;
        _resendIn = widget.resendAfterSeconds;
      }
    });
    if (error == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Đã gửi lại mã xác minh.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('guest-journey-otp-screen'),
      extendBody: true,
      backgroundColor: journeyPage,
      bottomNavigationBar: RouteDockTabBar(
        currentIndex: 3,
        onTap: widget.onTabSelected,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: journeyOverlayStyle,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            const SliverToBoxAdapter(
              child: JourneyHeroHeader(title: 'Xác thực tra cứu vé'),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 372),
                    child: JourneySurface(
                      padding: const EdgeInsets.fromLTRB(20, 19, 20, 20),
                      radius: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Nhập mã OTP',
                            style: TextStyle(
                              color: journeyInk,
                              fontSize: 23,
                              height: 31 / 23,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Mã OTP đã được gửi đến',
                            style: TextStyle(
                              color: journeyBody,
                              fontSize: 12.5,
                              height: 18 / 12.5,
                            ),
                          ),
                          Text(
                            widget.maskedEmail,
                            style: const TextStyle(
                              color: journeyInk,
                              fontSize: 13,
                              height: 19 / 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 17),
                          JourneyOtpFields(
                            onChanged: (value) => setState(() => _otp = value),
                          ),
                          if (_error case final error?) ...[
                            const SizedBox(height: 8),
                            Text(
                              error,
                              key: const Key('guest-journey-otp-error'),
                              style: const TextStyle(
                                color: Color(0xFFD92D20),
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              SvgPicture.asset(
                                '$journeyAssetRoot/clock.svg',
                                width: 17,
                                height: 17,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: _expiresIn > 0
                                        ? 'Mã hết hạn sau '
                                        : 'Mã đã hết hạn',
                                    children: [
                                      if (_expiresIn > 0)
                                        TextSpan(
                                          text: _countdown,
                                          style: const TextStyle(
                                            color: Color(0xFFF79009),
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: journeyBody,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                key: const Key('guest-journey-resend-otp'),
                                borderRadius: BorderRadius.circular(8),
                                onTap: _resendIn > 0 ? null : _resend,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        '$journeyAssetRoot/refresh.svg',
                                        width: 15,
                                        height: 15,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _resendIn > 0
                                            ? 'Gửi lại sau ${_resendIn}s'
                                            : 'Gửi lại mã',
                                        style: TextStyle(
                                          color: _resendIn > 0
                                              ? journeyBody
                                              : journeyPrimary,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 17),
                          JourneyPrimaryButton(
                            key: const Key('guest-journey-verify-otp'),
                            label: _busy ? 'Đang xác minh...' : 'Xác nhận OTP',
                            iconAsset: '$journeyAssetRoot/arrow_right.svg',
                            onPressed: _busy ? null : _verify,
                          ),
                          const SizedBox(height: 10),
                          JourneyOutlineButton(
                            label: 'Thay đổi thông tin tra cứu',
                            onPressed: widget.onChangeLookup,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
