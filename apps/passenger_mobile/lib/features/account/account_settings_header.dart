import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

const accountSettingsBackground = Color(0xFFFCFDFE);
const accountSettingsInk = Color(0xFF080F49);
const accountSettingsMuted = Color(0xFF506D98);
const accountSettingsAssetRoot = 'assets/account/settings';

const accountSettingsOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
  systemNavigationBarColor: accountSettingsBackground,
  systemNavigationBarIconBrightness: Brightness.dark,
);

class AccountSettingsHeader extends StatelessWidget {
  const AccountSettingsHeader({
    required this.title,
    required this.onBack,
    this.backKey = const Key('account-settings-back'),
    super.key,
  });

  final String title;
  final VoidCallback onBack;
  final Key backKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: Stack(
        children: [
          Positioned(
            left: 22,
            top: 12,
            child: Material(
              color: const Color(0xFFF7FBFF),
              shape: const CircleBorder(
                side: BorderSide(color: Color(0xFFE4EFFB)),
              ),
              child: InkWell(
                key: backKey,
                onTap: onBack,
                customBorder: const CircleBorder(),
                child: SizedBox.square(
                  dimension: 42,
                  child: Center(
                    child: SvgPicture.asset(
                      '$accountSettingsAssetRoot/back.svg',
                      excludeFromSemantics: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 18,
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  title,
                  key: const Key('account-settings-title'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: accountSettingsInk,
                    fontSize: 19,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
