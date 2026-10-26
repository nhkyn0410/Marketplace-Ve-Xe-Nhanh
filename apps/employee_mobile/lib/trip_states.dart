import 'package:flutter/material.dart';

import 'design_system.dart';

/// Trạng thái hiển thị của danh sách chuyến mẫu.
enum AssignmentViewState { ready, loading, failed }

/// Nội dung chuyến đang tải, tải lỗi hoặc chưa được phân công theo Figma.
class AssignmentStateBody extends StatelessWidget {
  const AssignmentStateBody({
    super.key,
    required this.state,
    required this.date,
    required this.onDayChanged,
    required this.onReload,
    this.onSampleDay,
  });
  final AssignmentViewState state;
  final DateTime date;
  final ValueChanged<int> onDayChanged;
  final VoidCallback onReload;
  final VoidCallback? onSampleDay;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chào Minh,',
                    style: driverText(
                      14,
                      FontWeight.w500,
                      DriverColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Chuyến của tôi',
                    style: driverText(28, FontWeight.w700, DriverColors.navy),
                  ),
                ],
              ),
            ),
            const FigmaAsset(
              'state-refresh-imgNhanVienAvatar',
              width: 56,
              height: 56,
            ),
          ],
        ),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: DriverColors.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Ngày trước',
                    onPressed: state == AssignmentViewState.loading
                        ? null
                        : () => onDayChanged(-1),
                    icon: const FigmaAsset(
                      'state-refresh-imgIconBack',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          date == DateTime(2026, 10, 14)
                              ? 'Ngày mẫu'
                              : 'Ngày được chọn',
                          style: driverText(
                            12,
                            FontWeight.w400,
                            DriverColors.secondary,
                          ),
                        ),
                        Text(
                          '${date.day}/${date.month}/${date.year}',
                          style: driverText(
                            14,
                            FontWeight.w500,
                            DriverColors.navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Ngày sau',
                    onPressed: state == AssignmentViewState.loading
                        ? null
                        : () => onDayChanged(1),
                    icon: const FigmaAsset(
                      'state-refresh-imgIconRight',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (state == AssignmentViewState.loading) ...[
              Text(
                'Đang lấy chuyến được phân công…',
                style: driverText(14, FontWeight.w500, DriverColors.secondary),
              ),
              const SizedBox(height: 24),
              for (var i = 0; i < 2; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Opacity(
                    opacity: i == 0 ? 1 : .55,
                    child: const _TripSkeleton(),
                  ),
                ),
            ] else if (state == AssignmentViewState.failed)
              DriverCard(
                border: true,
                radius: 24,
                padding: 24,
                child: Column(
                  children: [
                    const FigmaAsset(
                      'state-refresh-imgIllustrationTripError',
                      width: 176,
                      height: 158.4,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Chưa tải được chuyến',
                      textAlign: TextAlign.center,
                      style: driverText(22, FontWeight.w600, DriverColors.navy),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Kiểm tra kết nối rồi thử lại.',
                      textAlign: TextAlign.center,
                      style: driverText(
                        14,
                        FontWeight.w500,
                        DriverColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SwipeAction(label: 'Thử lại', onComplete: onReload),
                  ],
                ),
              )
            else ...[
              const StateIllustration(
                asset: 'state-refresh-imgIllustrationTripEmpty',
                height: 220,
                imageWidth: 200,
              ),
              const SizedBox(height: 24),
              Text(
                'Chưa có chuyến',
                textAlign: TextAlign.center,
                style: driverText(22, FontWeight.w600, DriverColors.navy),
              ),
              const SizedBox(height: 12),
              Text(
                'Chuyến được phân công sẽ hiện tại đây.',
                textAlign: TextAlign.center,
                style: driverText(14, FontWeight.w500, DriverColors.secondary),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SwipeAction(label: 'Tải lại', onComplete: onReload),
              ),
              if (onSampleDay != null)
                TextButton(
                  onPressed: onSampleDay,
                  child: const Text('Về ngày có chuyến mẫu'),
                ),
            ],
          ],
        ),
      ),
    ],
  );
}

/// Khối minh họa trạng thái dùng nguyên bản tài sản SVG của thiết kế.
class StateIllustration extends StatelessWidget {
  const StateIllustration({
    super.key,
    required this.asset,
    required this.height,
    required this.imageWidth,
    this.color = DriverColors.canvas,
  });
  final String asset;
  final double height, imageWidth;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    height: height,
    width: double.infinity,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(24),
    ),
    child: FigmaAsset(asset, width: imageWidth, height: imageWidth * .9),
  );
}

/// Màn chặn hiển thị thông tin chuyến ngoài phạm vi phân công trong bản mẫu.
class TripAccessScreen extends StatelessWidget {
  const TripAccessScreen({super.key, required this.onReturn});
  final VoidCallback onReturn;
  @override
  Widget build(BuildContext context) => DriverPage(
    bottom: Padding(
      padding: const EdgeInsets.fromLTRB(40, 14, 40, 16),
      child: SwipeAction(label: 'Về chuyến của tôi', onComplete: onReturn),
    ),
    child: Column(
      children: [
        const DriverHeading('Truy cập chuyến'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const StateIllustration(
                asset: 'state-refresh-imgIllustrationAccessDenied',
                height: 280,
                imageWidth: 224,
              ),
              const SizedBox(height: 28),
              Text(
                'Chưa được phân công',
                style: driverText(22, FontWeight.w600, DriverColors.navy),
              ),
              const SizedBox(height: 12),
              Text(
                'Bạn chỉ có thể xem chuyến được giao.',
                style: driverText(14, FontWeight.w500, DriverColors.secondary),
              ),
              const SizedBox(height: 28),
              DriverCard(
                color: const Color(0xfff4f5f6),
                child: Row(
                  children: [
                    const FigmaAsset(
                      'state-refresh-imgIconLock',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Chuyến ngoài phạm vi phân công',
                        style: driverText(
                          12,
                          FontWeight.w400,
                          DriverColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _TripSkeleton extends StatelessWidget {
  const _TripSkeleton();
  Widget _bar(
    double width,
    double height, [
    Color color = DriverColors.border,
  ]) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(6),
    ),
  );
  @override
  Widget build(BuildContext context) => DriverCard(
    radius: 24,
    border: true,
    padding: 20,
    child: Column(
      children: [
        Row(
          children: [
            _bar(40, 40, DriverColors.canvas),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bar(120, 10),
                  const SizedBox(height: 8),
                  _bar(80, 8, const Color(0xfff4f5f6)),
                ],
              ),
            ),
            _bar(70, 24, DriverColors.canvas),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _bar(68, 12),
            _bar(60, 2, DriverColors.canvas),
            _bar(68, 12),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _bar(92, 8, const Color(0xfff4f5f6)),
            _bar(92, 8, const Color(0xfff4f5f6)),
          ],
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(child: _bar(100, 8, const Color(0xfff4f5f6))),
            const SizedBox(width: 12),
            Expanded(child: _bar(100, 8, const Color(0xfff4f5f6))),
          ],
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}
