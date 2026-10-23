import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primary = Color(0xFF2088C9);
const _ink = Color(0xFF0D173B);
const _muted = Color(0xFF7188A3);
const _background = Color(0xFFF7FBFF);
const _border = Color(0xFFEAF1F8);
const _star = Color(0xFFFFB31A);

/// Ảnh mẫu lấy trực tiếp từ node Figma. Dữ liệu thật có thể truyền ảnh khác
/// qua [ReviewTripItem.imageAsset] mà không phải thay đổi khung hiển thị.
const reviewSampleTripAssets = <String>[
  'assets/account/reviews/trip_1.png',
  'assets/account/reviews/trip_2.png',
  'assets/account/reviews/trip_3.png',
];

typedef MyReviewsLoader = Future<MyReviewsData> Function();
typedef ReviewSubmitter = Future<bool> Function(
  String bookingId,
  ReviewSubmission submission,
);

enum ReviewVisibility { visible, held, hidden }

class MyReviewsData {
  const MyReviewsData({required this.pending, required this.reviewed});

  final List<ReviewTripItem> pending;
  final List<ReviewTripItem> reviewed;
}

class ReviewTripItem {
  const ReviewTripItem({
    required this.bookingId,
    required this.routeName,
    required this.operatorName,
    required this.departureAt,
    this.vehicleType,
    this.imageAsset,
    this.rating,
    this.comment,
    this.reviewedAt,
    this.visibility = ReviewVisibility.visible,
  });

  final String bookingId;
  final String routeName;
  final String operatorName;
  final DateTime departureAt;
  final String? vehicleType;
  final String? imageAsset;
  final int? rating;
  final String? comment;
  final DateTime? reviewedAt;
  final ReviewVisibility visibility;
}

class ReviewSubmission {
  const ReviewSubmission({required this.rating, this.comment});

  final int rating;
  final String? comment;
}

enum _ReviewTab { pending, reviewed }

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({
    required this.loadReviews,
    required this.submitReview,
    required this.onBack,
    this.errorMessage,
    this.onInputChanged,
    super.key,
  });

  final MyReviewsLoader loadReviews;
  final ReviewSubmitter submitReview;
  final VoidCallback onBack;
  final String? errorMessage;
  final VoidCallback? onInputChanged;

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  _ReviewTab _tab = _ReviewTab.pending;
  late Future<MyReviewsData> _reviews = widget.loadReviews();

  Future<void> _reload() async {
    final next = widget.loadReviews();
    setState(() => _reviews = next);
    await next;
  }

  Future<void> _writeReview(ReviewTripItem trip) async {
    final submitted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReviewFormSheet(
        trip: trip,
        errorMessage: widget.errorMessage,
        onInputChanged: widget.onInputChanged,
        onSubmit: (input) => widget.submitReview(trip.bookingId, input),
      ),
    );
    if (submitted != true || !mounted) return;
    setState(() {
      _tab = _ReviewTab.reviewed;
      _reviews = widget.loadReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: const Key('my-reviews-screen'),
        backgroundColor: _background,
        body: SafeArea(
          child: Column(
            children: [
              _ReviewsHeader(onBack: widget.onBack),
              Expanded(
                child: FutureBuilder<MyReviewsData>(
                  future: _reviews,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        key: Key('my-reviews-loading'),
                        child: CircularProgressIndicator(color: _primary),
                      );
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return _LoadError(onRetry: _reload);
                    }
                    final data = snapshot.requireData;
                    final items = _tab == _ReviewTab.pending
                        ? data.pending
                        : data.reviewed;
                    return Column(
                      children: [
                        _ReviewTabs(
                          selected: _tab,
                          pendingCount: data.pending.length,
                          reviewedCount: data.reviewed.length,
                          onSelected: (tab) => setState(() => _tab = tab),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: items.isEmpty
                              ? _EmptyReviews(tab: _tab)
                              : RefreshIndicator(
                                  color: _primary,
                                  onRefresh: _reload,
                                  child: ListView.separated(
                                    key: Key(
                                      _tab == _ReviewTab.pending
                                          ? 'pending-review-list'
                                          : 'reviewed-list',
                                    ),
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(
                                      12,
                                      0,
                                      12,
                                      28,
                                    ),
                                    itemCount: items.length,
                                    separatorBuilder: (_, _) =>
                                        const SizedBox(height: 14),
                                    itemBuilder: (_, index) {
                                      final item = items[index];
                                      if (_tab == _ReviewTab.pending) {
                                        return PendingReviewCard(
                                          trip: item,
                                          onReview: () => _writeReview(item),
                                        );
                                      }
                                      return CompletedReviewCard(review: item);
                                    },
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewsHeader extends StatelessWidget {
  const _ReviewsHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: Row(
        children: [
          const SizedBox(width: 14),
          Material(
            color: const Color(0xFFF1F7FD),
            shape: const CircleBorder(),
            child: IconButton(
              key: const Key('my-reviews-back'),
              onPressed: onBack,
              icon: const Icon(Icons.chevron_left_rounded, size: 30),
              color: _ink,
              tooltip: 'Quay lại',
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Text(
              'Đánh giá của tôi',
              style: TextStyle(
                color: _ink,
                fontSize: 20,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }
}

class _ReviewTabs extends StatelessWidget {
  const _ReviewTabs({
    required this.selected,
    required this.pendingCount,
    required this.reviewedCount,
    required this.onSelected,
  });

  final _ReviewTab selected;
  final int pendingCount;
  final int reviewedCount;
  final ValueChanged<_ReviewTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F7FD),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ReviewTabButton(
              key: const Key('pending-review-tab'),
              label: 'Chờ đánh giá ($pendingCount)',
              selected: selected == _ReviewTab.pending,
              onTap: () => onSelected(_ReviewTab.pending),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: _ReviewTabButton(
              key: const Key('completed-review-tab'),
              label: 'Đã đánh giá ($reviewedCount)',
              selected: selected == _ReviewTab.reviewed,
              onTap: () => onSelected(_ReviewTab.reviewed),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewTabButton extends StatelessWidget {
  const _ReviewTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _primary : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : _muted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Khung chuyến đi có thể đánh giá, dùng lại cho mọi dữ liệu pending từ API.
class PendingReviewCard extends StatelessWidget {
  const PendingReviewCard({
    required this.trip,
    required this.onReview,
    super.key,
  });

  final ReviewTripItem trip;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('pending-review-${trip.bookingId}'),
      height: 200,
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 13),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TripImage(asset: trip.imageAsset, size: 110),
                const SizedBox(width: 16),
                Expanded(child: _TripDetails(trip: trip, showVehicle: true)),
              ],
            ),
          ),
          Container(
            height: 46,
            padding: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F9FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 11.5,
                  backgroundColor: Color(0xFFDDF3FC),
                  child: Icon(Icons.check_rounded, color: _primary, size: 16),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Chuyến đã hoàn thành',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  width: 114,
                  height: 43,
                  child: FilledButton(
                    key: Key('write-review-${trip.bookingId}'),
                    onPressed: onReview,
                    style: FilledButton.styleFrom(
                      backgroundColor: _primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Đánh giá',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
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
}

/// Khung đánh giá đã gửi, dùng lại cho mọi dữ liệu review từ API.
class CompletedReviewCard extends StatelessWidget {
  const CompletedReviewCard({required this.review, super.key});

  final ReviewTripItem review;

  @override
  Widget build(BuildContext context) {
    final rating = review.rating?.clamp(1, 5) ?? 1;
    return Container(
      key: Key('completed-review-${review.bookingId}'),
      constraints: const BoxConstraints(minHeight: 208),
      padding: const EdgeInsets.fromLTRB(16, 15, 13, 12),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TripImage(asset: review.imageAsset, size: 100, height: 110),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.routeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  review.operatorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
                const SizedBox(height: 7),
                _IconLine(
                  icon: Icons.calendar_month_outlined,
                  label: _formatDate(review.departureAt),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(child: ReviewStars(rating: rating)),
                    Text(
                      '$rating/5',
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
                if ((review.comment ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    review.comment!.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF4C6073),
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  _reviewFooter(review),
                  style: TextStyle(
                    color: review.visibility == ReviewVisibility.visible
                        ? _muted
                        : const Color(0xFFB66A10),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewStars extends StatelessWidget {
  const ReviewStars({required this.rating, this.size = 20, super.key});

  final int rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Padding(
          padding: EdgeInsets.only(right: index == 4 ? 0 : size * .25),
          child: Icon(
            index < rating ? Icons.star_rounded : Icons.star_border_rounded,
            color: _star,
            size: size,
          ),
        ),
      ),
    );
  }
}

class _TripDetails extends StatelessWidget {
  const _TripDetails({required this.trip, required this.showVehicle});

  final ReviewTripItem trip;
  final bool showVehicle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          trip.routeName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _ink,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          trip.operatorName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: _muted, fontSize: 12),
        ),
        const SizedBox(height: 8),
        _IconLine(
          icon: Icons.calendar_month_outlined,
          label: _formatDate(trip.departureAt),
        ),
        if (showVehicle && trip.vehicleType != null) ...[
          const SizedBox(height: 5),
          _IconLine(icon: Icons.airline_seat_flat, label: trip.vehicleType!),
        ],
      ],
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _muted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _muted, fontSize: 11),
          ),
        ),
      ],
    );
  }
}

class _TripImage extends StatelessWidget {
  const _TripImage({required this.asset, required this.size, this.height});

  final String? asset;
  final double size;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final imageAsset = asset;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: size,
        height: height ?? size,
        child: imageAsset == null
            ? const ColoredBox(
                color: Color(0xFFE8F4FB),
                child: Icon(Icons.directions_bus_rounded, color: _primary),
              )
            : Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: Color(0xFFE8F4FB),
                  child: Icon(Icons.directions_bus_rounded, color: _primary),
                ),
              ),
      ),
    );
  }
}

class _ReviewFormSheet extends StatefulWidget {
  const _ReviewFormSheet({
    required this.trip,
    required this.onSubmit,
    required this.errorMessage,
    required this.onInputChanged,
  });

  final ReviewTripItem trip;
  final Future<bool> Function(ReviewSubmission input) onSubmit;
  final String? errorMessage;
  final VoidCallback? onInputChanged;

  @override
  State<_ReviewFormSheet> createState() => _ReviewFormSheetState();
}

class _ReviewFormSheetState extends State<_ReviewFormSheet> {
  final _comment = TextEditingController();
  int _rating = 0;
  bool _submitting = false;
  String? _submitError;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0 || _submitting) return;
    setState(() => _submitting = true);
    final comment = _comment.text.trim();
    final succeeded = await widget.onSubmit(
      ReviewSubmission(
        rating: _rating,
        comment: comment.isEmpty ? null : comment,
      ),
    );
    if (!mounted) return;
    if (succeeded) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _submitting = false;
        _submitError =
            widget.errorMessage ?? 'Không thể gửi đánh giá. Vui lòng thử lại.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Material(
        key: const Key('review-form-sheet'),
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 72,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9E2EA),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Đánh giá chuyến đi',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    key: const Key('close-review-form'),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _TripImage(
                    asset: widget.trip.imageAsset,
                    size: 94,
                    height: 91,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.trip.routeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.trip.operatorName,
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '${_formatDate(widget.trip.departureAt)}${widget.trip.vehicleType == null ? '' : ' | ${widget.trip.vehicleType}'}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: _muted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(height: 1, color: _border),
              ),
              const Text(
                'Bạn đánh giá chuyến đi này thế nào?',
                style: TextStyle(
                  color: _ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final value = index + 1;
                  return IconButton(
                    key: Key('review-rating-$value'),
                    onPressed: () {
                      widget.onInputChanged?.call();
                      setState(() {
                        _rating = value;
                        _submitError = null;
                      });
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    icon: Icon(
                      value <= _rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: _star,
                      size: 38,
                    ),
                  );
                }),
              ),
              Center(
                child: Text(
                  _ratingLabel(_rating),
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 19),
              const Text(
                'Nhận xét của bạn',
                style: TextStyle(
                  color: _ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                key: const Key('review-comment-input'),
                controller: _comment,
                minLines: 4,
                maxLines: 4,
                maxLength: 500,
                onChanged: (_) {
                  widget.onInputChanged?.call();
                  setState(() => _submitError = null);
                },
                decoration: InputDecoration(
                  hintText: 'Chia sẻ trải nghiệm chuyến đi của bạn',
                  hintStyle: const TextStyle(color: Color(0xFFA1B1C1)),
                  counterText: '${_comment.text.characters.length}/500',
                  counterStyle: const TextStyle(color: _muted, fontSize: 10),
                  filled: true,
                  fillColor: const Color(0xFFFBFDFF),
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFDCE8F3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFDCE8F3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _primary, width: 1.3),
                  ),
                ),
              ),
              if ((_submitError ?? widget.errorMessage) != null) ...[
                const SizedBox(height: 8),
                Text(
                  _submitError ?? widget.errorMessage!,
                  key: const Key('review-submit-error'),
                  style: const TextStyle(
                    color: Color(0xFFB42318),
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  key: const Key('submit-review'),
                  onPressed: _rating == 0 || _submitting ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: _primary,
                    disabledBackgroundColor: const Color(0xFFB8D7E8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: _submitting
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Gửi đánh giá',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyReviews extends StatelessWidget {
  const _EmptyReviews({required this.tab});

  final _ReviewTab tab;

  @override
  Widget build(BuildContext context) {
    final pending = tab == _ReviewTab.pending;
    return Center(
      key: Key(pending ? 'pending-reviews-empty' : 'completed-reviews-empty'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 64),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 43,
              backgroundColor: const Color(0xFFE6F5FC),
              child: Icon(
                pending
                    ? Icons.rate_review_outlined
                    : Icons.star_outline_rounded,
                color: _primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              pending ? 'Chưa có chuyến chờ đánh giá' : 'Chưa có đánh giá',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _ink,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              pending
                  ? 'Các chuyến đi đủ điều kiện đánh giá sẽ xuất hiện tại đây.'
                  : 'Đánh giá đã gửi của bạn sẽ được lưu tại đây.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: _muted, fontSize: 12, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Chưa thể tải đánh giá',
            style: TextStyle(color: _ink, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            key: const Key('my-reviews-retry'),
            onPressed: onRetry,
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18),
  border: Border.all(color: _border),
  boxShadow: const [
    BoxShadow(color: Color(0x0A17324D), blurRadius: 12, offset: Offset(0, 4)),
  ],
);

String _formatDate(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

String _reviewFooter(ReviewTripItem review) {
  if (review.visibility == ReviewVisibility.held) {
    return 'Đánh giá đang chờ duyệt';
  }
  if (review.visibility == ReviewVisibility.hidden) {
    return 'Đánh giá hiện không được hiển thị';
  }
  final reviewedAt = review.reviewedAt;
  return reviewedAt == null
      ? 'Đã đánh giá'
      : 'Đánh giá ngày ${_formatDate(reviewedAt)}';
}

String _ratingLabel(int rating) => switch (rating) {
  1 => '1/5 - Rất không hài lòng',
  2 => '2/5 - Không hài lòng',
  3 => '3/5 - Bình thường',
  4 => '4/5 - Khá hài lòng',
  5 => '5/5 - Rất hài lòng',
  _ => 'Chọn số sao đánh giá',
};
