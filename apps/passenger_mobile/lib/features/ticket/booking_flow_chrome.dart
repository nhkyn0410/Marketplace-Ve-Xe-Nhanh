import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _detailAssets = 'assets/ticket/detail';
const _ink = Color(0xFF0B2942);
const _blue = Color(0xFF1E8ABE);
const _muted = Color(0xFF71899B);
const _orange = Color(0xFFF59B31);

class BookingFlowHeader extends StatelessWidget {
  const BookingFlowHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timerLabel,
    required this.expired,
    required this.onBack,
    required this.backKey,
    required this.timerKey,
    this.urgent = false,
    this.backgroundColor = Colors.white,
  });

  final String title;

  /// Dòng phụ dưới tiêu đề, vd. tên tuyến.
  final String subtitle;

  /// `null` = chưa giữ chỗ, không hiện đồng hồ.
  final String? timerLabel;
  final bool expired;
  final bool urgent;
  final VoidCallback onBack;
  final Key backKey;
  final Key timerKey;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final warning = expired || urgent;
    final maxBadgeWidth = MediaQuery.sizeOf(context).width * 0.46;

    return ColoredBox(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 8, 10, 6),
        child: Row(
          children: [
            IconButton(
              key: backKey,
              onPressed: onBack,
              icon: SvgPicture.asset(
                '$_detailAssets/back.svg',
                width: 22,
                height: 22,
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 19,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _muted, fontSize: 13),
                  ),
                ],
              ),
            ),
            if (timerLabel != null) ...[
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxBadgeWidth),
              child: Container(
                key: timerKey,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: warning
                      ? const Color(0xFFFFE4E4)
                      : const Color(0xFFFFF1D8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_filled_rounded,
                      color: warning ? const Color(0xFFD84A4A) : _orange,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: expired
                          ? Text(
                              'Đã hết hạn',
                              textAlign: TextAlign.end,
                              style: _timerStyle(warning),
                            )
                          : Wrap(
                              alignment: WrapAlignment.end,
                              children: [
                                Text(
                                  'Giữ ghế trong ',
                                  style: _timerStyle(warning),
                                ),
                                Text(timerLabel!, style: _timerStyle(warning)),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
            ],
          ],
        ),
      ),
    );
  }

  TextStyle _timerStyle(bool warning) {
    return TextStyle(
      color: warning ? const Color(0xFFD84A4A) : _orange,
      fontSize: 13,
      height: 1.2,
      fontWeight: FontWeight.w600,
    );
  }
}

class BookingStepProgress extends StatelessWidget {
  const BookingStepProgress({
    super.key,
    required this.activeStep,
    this.backgroundColor = Colors.white,
  });

  final int activeStep;
  final Color backgroundColor;

  static const _steps = [
    'Chọn ghế',
    'Thông tin\nhành khách',
    'Thanh toán',
    'Hoàn tất',
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(_steps.length, (index) {
            final active = index == activeStep;
            final completed = index < activeStep;
            final enabled = active || completed;
            return Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: index == 0
                              ? Colors.transparent
                              : index <= activeStep
                              ? _blue
                              : const Color(0xFFD7E4EA),
                          height: 16,
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: enabled ? _blue : const Color(0xFFEAF1F5),
                        ),
                        child: completed
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 18,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: active ? Colors.white : _muted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                      Expanded(
                        child: Divider(
                          color: index == _steps.length - 1
                              ? Colors.transparent
                              : index < activeStep
                              ? _blue
                              : const Color(0xFFD7E4EA),
                          height: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _steps[index],
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: TextStyle(
                      color: active ? _ink : _muted,
                      fontSize: 13,
                      height: 1.15,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
