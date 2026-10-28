import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

const journeyAssetRoot = 'assets/journey/flow';
const journeyPrimary = Color(0xFF087BFF);
const journeyButton = Color(0xFF2B7EAD);
const journeyInk = Color(0xFF08213B);
const journeyBody = Color(0xFF61769D);
const journeyPage = Color(0xFFE4F5FC);
const journeyBorder = Color(0xFFD8E6F0);

const journeyOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
  systemNavigationBarColor: journeyPage,
  systemNavigationBarIconBrightness: Brightness.dark,
);

class JourneyHeroHeader extends StatelessWidget {
  const JourneyHeroHeader({required this.title, this.subtitle, super.key});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            '$journeyAssetRoot/hero_250.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            filterQuality: FilterQuality.high,
          ),
          Positioned(
            left: 22,
            top: 44,
            width: 126,
            height: 35,
            child: const JourneyBrandLogo(),
          ),
          Positioned(
            left: 22,
            right: 20,
            top: 96,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF080E32),
                fontSize: 23,
                height: 30 / 23,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (subtitle != null)
            Positioned(
              left: 22,
              right: 20,
              top: 133,
              child: Text(
                subtitle!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: journeyBody,
                  fontSize: 12,
                  height: 17 / 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class JourneyDetailHeader extends StatelessWidget {
  const JourneyDetailHeader({
    required this.subtitle,
    required this.onBack,
    this.showLogo = false,
    super.key,
  });

  final String subtitle;
  final VoidCallback onBack;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            '$journeyAssetRoot/hero_150.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            filterQuality: FilterQuality.high,
          ),
          Positioned(
            left: 25,
            top: 42,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              child: InkWell(
                key: const Key('journey-detail-back'),
                customBorder: const CircleBorder(),
                onTap: onBack,
                child: SizedBox.square(
                  dimension: 30,
                  child: Center(
                    child: SvgPicture.asset(
                      '$journeyAssetRoot/back.svg',
                      width: 19,
                      height: 19,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (showLogo)
            Positioned(
              left: 67,
              top: 36,
              width: 126,
              height: 35,
              child: const JourneyBrandLogo(),
            ),
          const Positioned(
            left: 26,
            right: 20,
            top: 81,
            child: Text(
              'Chi tiết vé',
              style: TextStyle(
                color: Color(0xFF080E32),
                fontSize: 20,
                height: 28 / 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            left: 26,
            right: 20,
            top: 106,
            child: Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: journeyBody,
                fontSize: 11,
                height: 15 / 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JourneyBrandLogo extends StatelessWidget {
  const JourneyBrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17.5),
        border: Border.all(color: const Color(0xFFE0EFF8), width: .56),
        boxShadow: const [
          BoxShadow(
            color: Color(0x121F6EA6),
            blurRadius: 5.1,
            offset: Offset(0, 3.4),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/home/hero/logo_mark.svg'),
            SvgPicture.asset('assets/home/hero/logo_wordmark.svg'),
          ],
        ),
      ),
    );
  }
}

class JourneySurface extends StatelessWidget {
  const JourneySurface({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.radius = 14,
    this.borderColor,
    this.color = Colors.white,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? borderColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D1F6EA6),
            blurRadius: 9,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class JourneyPrimaryButton extends StatelessWidget {
  const JourneyPrimaryButton({
    required this.label,
    required this.onPressed,
    this.iconAsset,
    this.backgroundColor = journeyButton,
    this.height = 44,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? iconAsset;
  final Color backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: const Color(0xFF9FBBCB),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 19 / 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (iconAsset != null)
              Align(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(iconAsset!, width: 16, height: 16),
              ),
          ],
        ),
      ),
    );
  }
}

class JourneyOutlineButton extends StatelessWidget {
  const JourneyOutlineButton({
    required this.label,
    required this.onPressed,
    this.color = journeyPrimary,
    this.height = 40,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 13),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class JourneyOtpFields extends StatefulWidget {
  const JourneyOtpFields({
    required this.onChanged,
    this.boxHeight = 54,
    this.autofocus = true,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final double boxHeight;
  final bool autofocus;

  @override
  State<JourneyOtpFields> createState() => _JourneyOtpFieldsState();
}

class _JourneyOtpFieldsState extends State<JourneyOtpFields> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _notify() {
    widget.onChanged(_controllers.map((item) => item.text).join());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = constraints.maxWidth < 330 ? 5.0 : 8.0;
        final width = ((constraints.maxWidth - gap * 5) / 6)
            .clamp(38.0, 48.0)
            .toDouble();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: width,
              height: widget.boxHeight,
              child: TextField(
                key: Key('journey-otp-$index'),
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                autofocus: widget.autofocus && index == 0,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                textInputAction: index == 5
                    ? TextInputAction.done
                    : TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                style: const TextStyle(
                  color: journeyInk,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    _focusNodes[index + 1].requestFocus();
                  } else if (value.isEmpty && index > 0) {
                    _focusNodes[index - 1].requestFocus();
                  }
                  _notify();
                },
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: Colors.white,
                  border: _border(const Color(0xFFD2DFEB)),
                  enabledBorder: _border(const Color(0xFFD2DFEB)),
                  focusedBorder: _border(journeyPrimary, width: 1.5),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class JourneySheetHandle extends StatelessWidget {
  const JourneySheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFFC7CED7),
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}

class JourneyIconButton extends StatelessWidget {
  const JourneyIconButton({
    required this.asset,
    required this.onTap,
    this.size = 36,
    super.key,
  });

  final String asset;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox.square(
          dimension: size,
          child: Center(child: SvgPicture.asset(asset, width: 20, height: 20)),
        ),
      ),
    );
  }
}
