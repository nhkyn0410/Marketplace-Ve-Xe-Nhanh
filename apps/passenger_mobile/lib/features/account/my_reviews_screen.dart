import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _primary = Color(0xFF2088C9);
const _ink = Color(0xFF0C173D);
const _muted = Color(0xFF506D95);
const _background = Color(0xFFF7FBFF);
const _border = Color(0xFFEAF1F8);
const _calendarAsset = 'assets/account/reviews/calendar.svg';
const _bedAsset = 'assets/account/reviews/bed.svg';
const _filledStarAsset = 'assets/account/reviews/star_filled.svg';
const _outlineStarAsset = 'assets/account/reviews/star_outline.svg';

/// Ảnh mẫu lấy trực tiếp từ node Figma. Dữ liệu thật có thể truyền ảnh khác
/// qua [ReviewTripItem.imageAsset] mà không phải thay đổi khung hiển thị.
const reviewSampleTripAssets = <String>[
  'assets/account/reviews/trip_1.png',
  'assets/account/reviews/trip_2.png',
  'assets/account/reviews/trip_3.png',
];

/// Fixture đối chiếu node Figma 2381:1840. Chỉ được dùng ở debug khi API
/// chưa có endpoint danh sách đánh giá dành cho Passenger.
final figmaMyReviewsSample = MyReviewsData(
  pending: [
    ReviewTripItem(
      bookingId: 'figma-pending-1',
      routeName: 'TP. Hồ Chí Minh → Đà Lạt',
      operatorName: 'Phương Nam Travel',
      departureAt: DateTime(2026, 10, 16),
      vehicleType: 'Limousine 34 giường',
      imageAsset: reviewSampleTripAssets[0],
      draftRating: 4,
      draftComment: 'Xe sạch sẽ, nhân viên hỗ trợ nhiệt tình. Chuyến đi đúng giờ và khá thoải mái. Sẽ tiếp tục ủng hộ nhà xe trong những chuyến sau.',
    ),
    ReviewTripItem(
      bookingId: 'figma-pending-2',
      routeName: 'Hà Nội → Thanh Hóa',
      operatorName: 'Hoàng Long',
      departureAt: DateTime(2026, 10, 10),
      vehicleType: 'Giường nằm 40 chỗ',
      imageAsset: reviewSampleTripAssets[1],
    ),
    ReviewTripItem(
      bookingId: 'figma-pending-3',
      routeName: 'Đà Nẵng → Huế',
      operatorName: 'Queen Cafe',
      departureAt: DateTime(2026, 9, 28),
      vehicleType: 'Limousine 22 giường',
      imageAsset: reviewSampleTripAssets[2],
    ),
  ],
  reviewed: [
    ReviewTripItem(
      bookingId: 'figma-reviewed-1',
      routeName: 'TP. Hồ Chí Minh → Đà Lạt',
      operatorName: 'Phương Nam Travel',
      departureAt: DateTime(2026, 10, 16),
      imageAsset: reviewSampleTripAssets[0],
      rating: 4,
      comment: 'Xe sạch sẽ, nhân viên hỗ trợ nhiệt tình. Chuyến đi đúng giờ và khá thoải mái.',
      reviewedAt: DateTime(2026, 10, 17),
    ),
    ReviewTripItem(
      bookingId: 'figma-reviewed-2',
      routeName: 'Hà Nội → Thanh Hóa',
      operatorName: 'Hoàng Long',
      departureAt: DateTime(2026, 10, 10),
      imageAsset: reviewSampleTripAssets[1],
      rating: 5,
      comment: 'Chuyến đi rất tốt, xe chạy êm, không bị trễ giờ. Tài xế thân thiện và hỗ trợ hành khách.',
      reviewedAt: DateTime(2026, 10, 11),
    ),
    ReviewTripItem(
      bookingId: 'figma-reviewed-3',
      routeName: 'Đà Nẵng → Huế',
      operatorName: 'Queen Cafe',
      departureAt: DateTime(2026, 9, 28),
      imageAsset: reviewSampleTripAssets[2],
      rating: 3,
      comment: 'Chất lượng ổn, ghế nằm thoải mái. Tuy nhiên thời gian dừng trạm hơi lâu.',
      reviewedAt: DateTime(2026, 9, 29),
    ),
    ReviewTripItem(
      bookingId: 'figma-reviewed-4',
      routeName: 'TP. Hồ Chí Minh → Đà Lạt',
      operatorName: 'Phương Nam Travel',
      departureAt: DateTime(2026, 9, 20),
      imageAsset: reviewSampleTripAssets[0],
      rating: 5,
      comment: 'Chuyến đi thoải mái và đúng giờ.',
      reviewedAt: DateTime(2026, 9, 21),
    ),
    ReviewTripItem(
      bookingId: 'figma-reviewed-5',
      routeName: 'Hà Nội → Thanh Hóa',
      operatorName: 'Hoàng Long',
      departureAt: DateTime(2026, 9, 12),
      imageAsset: reviewSampleTripAssets[1],
      rating: 4,
      comment: 'Nhân viên hỗ trợ nhiệt tình.',
      reviewedAt: DateTime(2026, 9, 13),
    ),
  ],
);

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
    this.draftRating,
    this.draftComment,
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
  final int? draftRating;
  final String? draftComment;
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
      useSafeArea: false,
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
      height: 67,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 14,
            top: 6,
            child: Material(
              color: _background,
              shape: const CircleBorder(
                side: BorderSide(color: Color(0xFFDEEBF8)),
              ),
              child: InkWell(
                key: const Key('my-reviews-back'),
                onTap: onBack,
                customBorder: const CircleBorder(),
                child: const SizedBox.square(
                  dimension: 42,
                  child: Center(
                    child: Text(
                      '‹',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 30,
                        height: 1,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            top: 15,
            left: 56,
            right: 56,
            child: Text(
              'Đánh giá của tôi',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _ink,
                fontSize: 19,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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
        border: Border.all(color: const Color(0xFFD7E7F7)),
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
              color: selected ? Colors.white : const Color(0xFF294774),
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
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
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            left: 15,
            top: 14,
            child: _TripImage(asset: trip.imageAsset, size: 110),
          ),
          Positioned(
            left: 141,
            right: 18,
            top: 17,
            height: 100,
            child: _TripDetails(trip: trip, showVehicle: true),
          ),
          Positioned(
            left: 9,
            right: 9,
            top: 140,
            height: 46,
            child: Container(
              padding: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F9FA),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 11.5,
                    backgroundColor: Color(0xFF138A59),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Chuyến đã hoàn thành',
                      style: TextStyle(
                        color: Color(0xFF25736C),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 114,
                    height: 43,
                    child: Material(
                      color: Colors.transparent,
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFD9DCE5), _primary],
                          ),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        child: InkWell(
                          key: Key('write-review-${trip.bookingId}'),
                          onTap: onReview,
                          borderRadius: BorderRadius.circular(23),
                          child: const Center(
                            child: Text(
                              'Đánh giá',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
      height: 208,
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            left: 15,
            top: 14,
            child: _TripImage(asset: review.imageAsset, size: 100, height: 110),
          ),
          Positioned(
            left: 129,
            right: 14,
            top: 17,
            height: 101,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.routeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  review.operatorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 13),
                ),
                const SizedBox(height: 4),
                _IconLine(
                  asset: _calendarAsset,
                  label: _formatDate(review.departureAt),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    ReviewStars(rating: rating),
                    const Spacer(),
                    Text(
                      '$rating/5',
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if ((review.comment ?? '').trim().isNotEmpty)
            Positioned(
              left: 129,
              right: 14,
              top: 125,
              child: Text(
                review.comment!.trim(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
            ),
          Positioned(
            left: 129,
            right: 14,
            top: 176,
            child: Text(
              _reviewFooter(review),
              style: TextStyle(
                color: review.visibility == ReviewVisibility.visible
                    ? const Color(0xFF849CBD)
                    : const Color(0xFFB66A10),
                fontSize: 11,
              ),
            ),
          ),
          Positioned(
            right: 14,
            top: 12,
            child: Container(
              width: 27,
              height: 27,
              decoration: const BoxDecoration(
                color: Color(0xFFF5FAFF),
                shape: BoxShape.circle,
              ),
              alignment: const Alignment(0, -0.35),
              child: const Text(
                '···',
                style: TextStyle(
                  color: Color(0xFF294774),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
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
    final exactAsset = switch (rating) {
      3 => 'assets/account/reviews/rating_3.svg',
      4 => 'assets/account/reviews/rating_4.svg',
      5 => 'assets/account/reviews/rating_5.svg',
      _ => null,
    };
    if (size == 20 && exactAsset != null) {
      return SizedBox(
        width: 124,
        height: 20,
        child: SvgPicture.asset(exactAsset),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Padding(
          padding: EdgeInsets.only(right: index == 4 ? 0 : size * .25),
          child: SizedBox.square(
            dimension: size,
            child: Center(
              child: SvgPicture.asset(
                index < rating ? _filledStarAsset : _outlineStarAsset,
              ),
            ),
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
          style: const TextStyle(color: _muted, fontSize: 13),
        ),
        const SizedBox(height: 5),
        _IconLine(asset: _calendarAsset, label: _formatDate(trip.departureAt)),
        if (showVehicle && trip.vehicleType != null) ...[
          const SizedBox(height: 5),
          _IconLine(asset: _bedAsset, label: trip.vehicleType!),
        ],
      ],
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.asset, required this.label});

  final String asset;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 16,
          child: Center(child: SvgPicture.asset(asset)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _muted, fontSize: 12),
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
  late final TextEditingController _comment;
  late int _rating;
  bool _submitting = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _rating = widget.trip.draftRating ?? 0;
    _comment = TextEditingController(text: widget.trip.draftComment ?? '');
  }

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
    final media = MediaQuery.of(context);
    final availableHeight =
        media.size.height - media.padding.top - media.viewInsets.bottom;
    final sheetHeight = availableHeight.clamp(0.0, 626.0).toDouble();
    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: SizedBox(
        height: sheetHeight,
        child: Material(
          key: const Key('review-form-sheet'),
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 12, 20, 26),
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
                SizedBox(
                  height: 36,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Đánh giá chuyến đi',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 20,
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Material(
                        color: const Color(0xFFF1F7FC),
                        shape: const CircleBorder(),
                        child: InkWell(
                          key: const Key('close-review-form'),
                          onTap: () => Navigator.of(context).pop(),
                          customBorder: const CircleBorder(),
                          child: const SizedBox.square(
                            dimension: 36,
                            child: Icon(
                              Icons.close_rounded,
                              color: Color(0xFF38567B),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 19),
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
                            style: const TextStyle(color: _muted, fontSize: 13),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            '${_formatDate(widget.trip.departureAt)}${widget.trip.vehicleType == null ? '' : ' | ${widget.trip.vehicleType}'}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: _muted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 22, bottom: 17),
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
                SizedBox(
                  height: 38,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final value = index + 1;
                      return InkResponse(
                        key: Key('review-rating-$value'),
                        onTap: () {
                          widget.onInputChanged?.call();
                          setState(() {
                            _rating = value;
                            _submitError = null;
                          });
                        },
                        radius: 24,
                        child: SizedBox(
                          width: 55,
                          height: 38,
                          child: Center(
                            child: SvgPicture.asset(
                              value <= _rating
                                  ? _filledStarAsset
                                  : _outlineStarAsset,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: Text(
                    _ratingLabel(_rating),
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Nhận xét của bạn',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: TextField(
                    key: const Key('review-comment-input'),
                    controller: _comment,
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    maxLength: 500,
                    textAlignVertical: TextAlignVertical.top,
                    onChanged: (_) {
                      widget.onInputChanged?.call();
                      setState(() => _submitError = null);
                    },
                    style: const TextStyle(
                      color: Color(0xFF38567B),
                      fontSize: 13,
                      height: 1.45,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Chia sẻ trải nghiệm chuyến đi của bạn',
                      hintStyle: const TextStyle(color: Color(0xFFA1B1C1)),
                      counterText: '${_comment.text.characters.length}/500',
                      counterStyle: const TextStyle(
                        color: Color(0xFF788FAB),
                        fontSize: 11,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.fromLTRB(13, 11, 13, 7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF859AB7)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF859AB7)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: _primary,
                          width: 1.3,
                        ),
                      ),
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
                const SizedBox(height: 32),
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
                        borderRadius: BorderRadius.circular(24),
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
