import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passenger_mobile/features/home/route_dock_tabbar.dart';
import 'package:passenger_mobile/features/journey/guest_journey_shared.dart';

class GuestJourneyOtpScreen extends StatefulWidget {
  const GuestJourneyOtpScreen({
    required this.maskedEmail,
    required this.onVerified,
    required this.onChangeLookup,
    required this.onTabSelected,
    super.key,
  });

  final String maskedEmail;
  final VoidCallback onVerified;
  final VoidCallback onChangeLookup;
  final ValueChanged<int> onTabSelected;

  @override
  State<GuestJourneyOtpScreen> createState() => _GuestJourneyOtpScreenState();
}

class _GuestJourneyOtpScreenState extends State<GuestJourneyOtpScreen> {
  String _otp = '';

  void _verify() {
    if (_otp.length != 6) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập đủ 6 số OTP.')),
        );
      return;
    }
    widget.onVerified();
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
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              SvgPicture.asset(
                                '$journeyAssetRoot/clock.svg',
                                width: 17,
                                height: 17,
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'Mã hết hạn sau ',
                                style: TextStyle(
                                  color: journeyBody,
                                  fontSize: 11,
                                ),
                              ),
                              const Text(
                                '05:00',
                                style: TextStyle(
                                  color: Color(0xFFF79009),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Đã gửi lại mã OTP mô phỏng.',
                                        ),
                                      ),
                                    );
                                },
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
                                      const Text(
                                        'Gửi lại mã',
                                        style: TextStyle(
                                          color: journeyPrimary,
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
                            label: 'Xác nhận OTP',
                            iconAsset: '$journeyAssetRoot/arrow_right.svg',
                            onPressed: _verify,
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
