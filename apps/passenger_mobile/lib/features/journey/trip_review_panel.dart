import 'package:flutter/material.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/account/my_reviews_screen.dart';
import 'package:passenger_mobile/features/journey/guest_journey_shared.dart';
import 'package:passenger_mobile/features/journey/journey_api.dart';
import 'package:passenger_mobile/features/journey/journey_models.dart';

/// Khối đánh giá ở chi tiết vé của tài khoản; máy chủ quyết định có được gửi không (`canReview`).
///
/// Chưa đủ điều kiện hoặc tải lỗi thì không chiếm chỗ trên màn. Tự có khoảng cách phía trên vì lý do đó.
class TripReviewPanel extends StatefulWidget {
  const TripReviewPanel({required this.api, required this.booking, super.key});

  final JourneyApi api;
  final JourneyBooking booking;

  @override
  State<TripReviewPanel> createState() => _TripReviewPanelState();
}

class _TripReviewPanelState extends State<TripReviewPanel> {
  JourneyReview? _review;
  bool _canReview = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final JourneyReviewStatus status;
    try {
      status = await widget.api.loadReview(widget.booking.bookingId);
    } on ApiFailure {
      return;
    }
    if (!mounted) return;
    setState(() {
      _review = status.review;
      _canReview = status.canReview;
    });
  }

  /// Gửi lỗi mà đơn đã có đánh giá (lần trước mất phản hồi, gửi từ máy khác) thì coi như đã xong.
  Future<bool> _submit(ReviewSubmission input) async {
    final JourneyReview review;
    try {
      review = await widget.api.submitReview(
        widget.booking.bookingId,
        rating: input.rating,
        comment: input.comment,
      );
    } on ApiFailure {
      await _load();
      return _review != null;
    }
    if (mounted) {
      setState(() {
        _review = review;
        _canReview = false;
      });
    }
    return true;
  }

  void _openForm() {
    final booking = widget.booking;
    showReviewFormSheet(
      context,
      trip: ReviewTripItem(
        bookingId: booking.bookingId,
        routeName: booking.routeName,
        operatorName: booking.operatorName,
        departureAt: booking.departureAt,
        vehicleType: booking.vehicleTypeName,
      ),
      onSubmit: _submit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final review = _review;
    if (review == null && !_canReview) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 9),
      child: SizedBox(
        width: double.infinity,
        child: JourneySurface(
          key: const Key('trip-review-panel'),
          child: review == null
              ? _ReviewInvite(onPressed: _openForm)
              : _SubmittedReview(review: review),
        ),
      ),
    );
  }
}

const _titleStyle = TextStyle(
  color: journeyInk,
  fontWeight: FontWeight.w600,
  fontSize: 14,
);
const _bodyStyle = TextStyle(color: journeyBody, fontSize: 12, height: 1.5);

class _ReviewInvite extends StatelessWidget {
  const _ReviewInvite({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Chuyến đi đã hoàn thành', style: _titleStyle),
        const SizedBox(height: 6),
        const Text(
          'Đánh giá của bạn giúp nhà xe phục vụ tốt hơn.',
          style: _bodyStyle,
        ),
        const SizedBox(height: 10),
        JourneyPrimaryButton(
          key: const Key('trip-review-open'),
          label: 'Đánh giá chuyến đi',
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class _SubmittedReview extends StatelessWidget {
  const _SubmittedReview({required this.review});

  final JourneyReview review;

  @override
  Widget build(BuildContext context) {
    final comment = review.comment;
    final moderationNote = switch (review.status) {
      'HELD' => 'Đánh giá đang chờ duyệt',
      'HIDDEN' => 'Đánh giá hiện không được hiển thị',
      _ => null,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Đánh giá của bạn', style: _titleStyle),
        const SizedBox(height: 8),
        ReviewStars(rating: review.rating),
        if (comment != null) ...[
          const SizedBox(height: 8),
          Text(comment, style: _bodyStyle),
        ],
        if (moderationNote != null) ...[
          const SizedBox(height: 8),
          Text(moderationNote, style: _bodyStyle),
        ],
      ],
    );
  }
}
