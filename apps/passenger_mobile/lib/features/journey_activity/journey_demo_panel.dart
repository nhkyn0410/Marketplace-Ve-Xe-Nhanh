import 'package:flutter/material.dart';
import 'package:passenger_mobile/features/journey/journey_api.dart';
import 'package:passenger_mobile/features/journey/guest_journey_shared.dart';
import 'package:passenger_mobile/features/journey_activity/journey_activity_service.dart';

/// Chỉ được gắn vào chi tiết vé của tài khoản khi build bật cờ demo Android.
class JourneyDemoPanel extends StatefulWidget {
  const JourneyDemoPanel({
    required this.service,
    required this.bookingId,
    super.key,
  });

  final JourneyActivityService service;
  final String bookingId;

  @override
  State<JourneyDemoPanel> createState() => _JourneyDemoPanelState();
}

class _JourneyDemoPanelState extends State<JourneyDemoPanel> {
  bool _busy = false;

  Future<void> _run(bool active) async {
    setState(() => _busy = true);
    try {
      if (active) {
        await widget.service.stop();
      } else {
        await widget.service.start(widget.bookingId);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              active
                  ? 'Đã dừng mô phỏng.'
                  : 'Đã bật mô phỏng. Bạn có thể về Home hoặc khóa màn hình.',
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is StateError
                  ? error.message.toString()
                  : describeJourneyFailure(error),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.service,
    builder: (context, _) {
      final snapshot = widget.service.current;
      final active = snapshot?.bookingId == widget.bookingId;
      return JourneySurface(
        key: const Key('journey-demo-panel'),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mô phỏng hành trình',
              style: TextStyle(
                color: journeyInk,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              active
                  ? 'Đang qua ${snapshot!.provinceName}. Thông báo tiếp tục cập nhật khi khóa màn hình.'
                  : 'Chạy thử thông báo tiến độ ngoài ứng dụng. Dữ liệu mô phỏng, không đổi chuyến đi của bạn.',
              style: const TextStyle(
                color: journeyBody,
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              key: const Key('journey-demo-toggle'),
              onPressed: _busy ? null : () => _run(active),
              child: Text(
                _busy
                    ? 'Đang xử lý…'
                    : active
                    ? 'Dừng mô phỏng'
                    : 'Chạy thử hành trình',
              ),
            ),
          ],
        ),
      );
    },
  );
}
