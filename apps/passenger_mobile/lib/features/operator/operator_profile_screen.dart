import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_shared/mobile_shared.dart';
import 'package:passenger_mobile/features/account/account_settings_header.dart';
import 'package:passenger_mobile/features/common/app_toast.dart';
import 'package:passenger_mobile/features/explore/article_markdown.dart';
import 'package:passenger_mobile/features/operator/operator_profile_models.dart';
import 'package:passenger_mobile/features/search/trip_search_form.dart';
import 'package:url_launcher/url_launcher.dart';

const _ink = Color(0xFF09243D);
const _primary = Color(0xFF2B7EAD);
const _primarySoft = Color(0xFFEBF5FB);
const _muted = Color(0xFF607A8E);
const _page = Color(0xFFF1F8FB);
const _border = Color(0xFFE3EEF5);
const _star = Color(0xFFFFB31A);

/// Mở `tel:` / `mailto:` bằng ứng dụng khác; `false` = không mở được.
typedef ExternalUriOpener = Future<bool> Function(Uri uri);

/// Trang nhà xe: thông tin công khai, chỉ số chất lượng, tuyến đang mở bán,
/// đánh giá và điều khoản dịch vụ (SCR-PSG-17, FR-MKT-06).
class OperatorProfileScreen extends StatefulWidget {
  const OperatorProfileScreen({
    required this.operatorId,
    required this.loadProfile,
    this.onViewTrips,
    this.openExternalUri,
    super.key,
  });

  final String operatorId;
  final OperatorProfileLoader loadProfile;

  /// Xem chuyến đang mở bán của nhà xe; `null` thì ẩn nút.
  final void Function(OperatorProfile profile)? onViewTrips;

  /// Gọi điện / gửi email; để trống dùng ứng dụng mặc định của máy.
  final ExternalUriOpener? openExternalUri;

  @override
  State<OperatorProfileScreen> createState() => _OperatorProfileScreenState();
}

class _OperatorProfileScreenState extends State<OperatorProfileScreen> {
  OperatorProfile? _profile;
  List<OperatorReview> _reviews = const [];
  String? _nextCursor;
  Object? _error;
  bool _loadingMore = false;
  int _request = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final request = ++_request;
    // Lượt tải thêm đang chạy sẽ bị bỏ kết quả vì danh sách được tải lại.
    if (_loadingMore) setState(() => _loadingMore = false);
    try {
      final profile = await widget.loadProfile(widget.operatorId);
      if (!mounted || request != _request) return;
      setState(() {
        _profile = profile;
        _reviews = profile.reviews;
        _nextCursor = profile.nextReviewCursor;
        _error = null;
      });
    } catch (error) {
      if (!mounted || request != _request) return;
      // Đang xem dữ liệu cũ thì giữ nguyên màn, chỉ báo chưa tải lại được.
      if (_profile != null) {
        AppToast.show(
          context,
          message: _describeError(error),
          type: AppToastType.error,
        );
        return;
      }
      setState(() => _error = error);
    }
  }

  void _retry() {
    setState(() => _error = null);
    _load();
  }

  Future<void> _loadMoreReviews() async {
    final cursor = _nextCursor;
    if (cursor == null || _loadingMore) return;
    final request = _request;
    setState(() => _loadingMore = true);
    try {
      final next = await widget.loadProfile(
        widget.operatorId,
        reviewCursor: cursor,
      );
      if (!mounted || request != _request) return;
      setState(() {
        _reviews = [..._reviews, ...next.reviews];
        _nextCursor = next.nextReviewCursor;
        _loadingMore = false;
      });
    } catch (error) {
      if (!mounted || request != _request) return;
      setState(() => _loadingMore = false);
      AppToast.show(
        context,
        message: _describeError(error),
        type: AppToastType.error,
      );
    }
  }

  Future<void> _open(Uri uri, String failureMessage) async {
    final opener =
        widget.openExternalUri ??
        (Uri target) =>
            launchUrl(target, mode: LaunchMode.externalApplication);
    var opened = false;
    try {
      opened = await opener(uri);
    } catch (_) {
      opened = false;
    }
    if (opened || !mounted) return;
    AppToast.show(context, message: failureMessage, type: AppToastType.error);
  }

  void _call(String hotline) => _open(
    Uri(scheme: 'tel', path: hotline.replaceAll(RegExp(r'[^\d+]'), '')),
    'Không thể mở ứng dụng gọi điện trên thiết bị này.',
  );

  void _email(String email) => _open(
    Uri(scheme: 'mailto', path: email),
    'Không thể mở ứng dụng email trên thiết bị này.',
  );

  @override
  Widget build(BuildContext context) {
    final profile = _profile;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        key: const Key('operator-profile-screen'),
        backgroundColor: _page,
        bottomNavigationBar: profile == null
            ? null
            : _ProfileActions(
                hotline: profile.hotline,
                onCall: _call,
                onViewTrips: widget.onViewTrips == null
                    ? null
                    : () => widget.onViewTrips!(profile),
              ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AccountSettingsHeader(
                title: 'Thông tin nhà xe',
                onBack: () => Navigator.of(context).maybePop(),
                backKey: const Key('operator-profile-back'),
              ),
              Expanded(child: _body(profile)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(OperatorProfile? profile) {
    final error = _error;
    if (error != null) return _LoadError(error: error, onRetry: _retry);
    if (profile == null) {
      return const Center(
        child: CircularProgressIndicator(
          key: Key('operator-profile-loading'),
          color: _primary,
        ),
      );
    }
    return RefreshIndicator(
      color: _primary,
      onRefresh: _load,
      child: ListView(
        key: const Key('operator-profile-scroll'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
        children: [
          _IdentityCard(profile: profile, onCall: _call, onEmail: _email),
          const _SectionTitle('Chỉ số chất lượng'),
          _ScorecardGrid(scorecard: profile.scorecard),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Tính từ đánh giá và dữ liệu vận hành trên Vé Xe Nhanh. '
              'Chỉ số chưa đủ dữ liệu được ghi rõ.',
              style: TextStyle(color: _muted, fontSize: 11.5, height: 1.45),
            ),
          ),
          const _SectionTitle('Tuyến đang mở bán'),
          _RoutesCard(routes: profile.routes),
          _SectionTitle(
            'Đánh giá từ hành khách',
            trailing: profile.scorecard.reviewCount == 0
                ? null
                : '${formatVnd(profile.scorecard.reviewCount, withSymbol: false)} đánh giá',
          ),
          if (_reviews.isEmpty)
            const _EmptyCard(
              key: Key('operator-reviews-empty'),
              icon: Icons.rate_review_outlined,
              message: 'Chưa có đánh giá để hiển thị.',
            )
          else
            for (var index = 0; index < _reviews.length; index++) ...[
              if (index > 0) const SizedBox(height: 10),
              _ReviewCard(review: _reviews[index]),
            ],
          if (_nextCursor != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                height: 44,
                child: OutlinedButton(
                  key: const Key('operator-reviews-more'),
                  onPressed: _loadingMore ? null : _loadMoreReviews,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primary,
                    side: const BorderSide(color: _border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _loadingMore
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: _primary,
                          ),
                        )
                      : const Text('Xem thêm đánh giá'),
                ),
              ),
            ),
          const _SectionTitle('Điều khoản dịch vụ'),
          _TermsCard(terms: profile.serviceTerms),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: _ink,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: const TextStyle(color: _muted, fontSize: 12),
            ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: _border),
);

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({
    required this.profile,
    required this.onCall,
    required this.onEmail,
  });

  final OperatorProfile profile;
  final ValueChanged<String> onCall;
  final ValueChanged<String> onEmail;

  @override
  Widget build(BuildContext context) {
    final rating = profile.scorecard.averageRating;
    final reviewCount = profile.scorecard.reviewCount;
    final description = profile.description?.trim();
    final hotline = profile.hotline?.trim();
    final email = profile.publicEmail?.trim();
    final address = profile.address?.trim();
    return Container(
      key: const Key('operator-identity-card'),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              OperatorInitialAvatar(
                name: profile.displayName,
                logoUrl: profile.logoUrl,
                size: 60,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.displayName,
                      key: const Key('operator-profile-name'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 18,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (rating != null && reviewCount > 0) ...[
                          const Icon(
                            Icons.star_rounded,
                            color: _star,
                            size: 17,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: _ink,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              '(${formatVnd(reviewCount, withSymbol: false)} đánh giá)',
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                        ] else
                          const Flexible(
                            child: Text(
                              'Chưa có đánh giá',
                              style: TextStyle(color: _muted, fontSize: 12.5),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: 12),
            _ExpandableText(text: description),
          ],
          if (hotline?.isNotEmpty == true ||
              email?.isNotEmpty == true ||
              address?.isNotEmpty == true) ...[
            const Divider(height: 24, color: _border),
            if (hotline != null && hotline.isNotEmpty)
              _ContactRow(
                key: const Key('operator-contact-hotline'),
                icon: Icons.call_rounded,
                text: hotline,
                onTap: () => onCall(hotline),
              ),
            if (email != null && email.isNotEmpty)
              _ContactRow(
                key: const Key('operator-contact-email'),
                icon: Icons.mail_rounded,
                text: email,
                onTap: () => onEmail(email),
              ),
            if (address != null && address.isNotEmpty)
              _ContactRow(
                key: const Key('operator-contact-address'),
                icon: Icons.location_on_rounded,
                text: address,
              ),
          ],
        ],
      ),
    );
  }
}

/// Giới thiệu dài chỉ hiện 4 dòng, bấm "Xem thêm" để đọc hết.
class _ExpandableText extends StatefulWidget {
  const _ExpandableText({required this.text});

  final String text;

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  static const _collapsedLines = 4;
  static const _style = TextStyle(color: _muted, fontSize: 13, height: 1.5);

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: _style),
          maxLines: _collapsedLines,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout(maxWidth: constraints.maxWidth);
        final overflows = painter.didExceedMaxLines;
        painter.dispose();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              maxLines: _expanded ? null : _collapsedLines,
              overflow: _expanded ? null : TextOverflow.ellipsis,
              style: _style,
            ),
            if (overflows)
              InkWell(
                key: const Key('operator-description-toggle'),
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    _expanded ? 'Thu gọn' : 'Xem thêm',
                    style: const TextStyle(
                      color: _primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.text,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: _primary, size: 18),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: onTap == null ? _ink : const Color(0xFF126993),
                  fontSize: 13,
                  height: 1.4,
                  fontWeight: onTap == null ? FontWeight.w400 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScorecardGrid extends StatelessWidget {
  const _ScorecardGrid({required this.scorecard});

  final OperatorScorecard scorecard;

  @override
  Widget build(BuildContext context) {
    final rating = scorecard.averageRating;
    final refund = scorecard.refundBookingRate;
    final dispute = scorecard.disputeBookingRate;
    final noShow = scorecard.noShowRate;
    return Column(
      key: const Key('operator-scorecard'),
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _MetricTile(
                  icon: Icons.star_rounded,
                  iconColor: _star,
                  label: 'Đánh giá trung bình',
                  value: rating == null || scorecard.reviewCount == 0
                      ? null
                      : rating.toStringAsFixed(1),
                  note: scorecard.reviewCount == 0
                      ? null
                      : '${formatVnd(scorecard.reviewCount, withSymbol: false)} đánh giá',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricTile(
                  icon: Icons.event_busy_rounded,
                  iconColor: const Color(0xFFE5484D),
                  label: 'Hủy chuyến do nhà xe',
                  value: _percent(scorecard.operatorCancellationRate),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _MetricTile(
                  icon: Icons.replay_rounded,
                  iconColor: const Color(0xFF7A5AF8),
                  label: 'Đơn hoàn tiền / tranh chấp',
                  value: refund == null && dispute == null
                      ? null
                      : '${_percent(refund) ?? '—'} / ${_percent(dispute) ?? '—'}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricTile(
                  icon: Icons.how_to_reg_rounded,
                  iconColor: const Color(0xFF169B62),
                  label: 'Tỷ lệ lên xe',
                  value: _percent(scorecard.checkInRate),
                  note: noShow == null
                      ? null
                      : 'Không đến: ${_percent(noShow)}',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// `0.125` → `12,5%`; `null` = chưa đủ dữ liệu.
String? _percent(double? ratio) {
  if (ratio == null) return null;
  return '${(ratio * 100).toStringAsFixed(1).replaceAll('.', ',')}%';
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.note,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  /// `null` hiện "Chưa có dữ liệu".
  final String? value;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: _muted, fontSize: 12, height: 1.35),
          ),
          const SizedBox(height: 4),
          if (value == null)
            const Text(
              'Chưa có dữ liệu',
              style: TextStyle(
                color: _muted,
                fontSize: 13.5,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            )
          else
            Text(
              value!,
              style: const TextStyle(
                color: _ink,
                fontSize: 18,
                height: 1.25,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (note != null) ...[
            const SizedBox(height: 2),
            Text(
              note!,
              style: const TextStyle(color: _muted, fontSize: 11.5),
            ),
          ],
        ],
      ),
    );
  }
}

class _RoutesCard extends StatelessWidget {
  const _RoutesCard({required this.routes});

  final List<OperatorRoute> routes;

  @override
  Widget build(BuildContext context) {
    if (routes.isEmpty) {
      return const _EmptyCard(
        key: Key('operator-routes-empty'),
        icon: Icons.alt_route_rounded,
        message: 'Nhà xe chưa có tuyến mở bán.',
      );
    }
    return Container(
      key: const Key('operator-routes'),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          for (var index = 0; index < routes.length; index++) ...[
            if (index > 0) const Divider(height: 1, color: _border),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.alt_route_rounded,
                    color: _primary,
                    size: 19,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      routes[index].name,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 13.5,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final OperatorReview review;

  @override
  Widget build(BuildContext context) {
    final comment = review.comment?.trim();
    final reply = review.operatorReply?.trim();
    final initial = review.authorName.trim().isEmpty
        ? '?'
        : review.authorName.trim().characters.first.toUpperCase();
    return Container(
      key: Key('operator-review-${review.id}'),
      padding: const EdgeInsets.all(13),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: _primarySoft,
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: _primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _vnDay(review.createdAt),
                      style: const TextStyle(color: _muted, fontSize: 11.5),
                    ),
                  ],
                ),
              ),
              Semantics(
                label: '${review.rating} trên 5 sao',
                child: ExcludeSemantics(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var star = 1; star <= 5; star++)
                        Icon(
                          Icons.star_rounded,
                          size: 15,
                          color: star <= review.rating
                              ? _star
                              : const Color(0xFFDCE5EC),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (comment != null && comment.isNotEmpty) ...[
            const SizedBox(height: 9),
            Text(
              comment,
              style: const TextStyle(color: _ink, fontSize: 13, height: 1.5),
            ),
          ],
          if (reply != null && reply.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _primarySoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phản hồi từ nhà xe',
                    style: TextStyle(
                      color: _primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    reply,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12.5,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Ngày theo giờ Việt Nam: `28/10/2026`.
String _vnDay(DateTime value) {
  final vn = value.toUtc().add(const Duration(hours: 7));
  String two(int part) => part.toString().padLeft(2, '0');
  return '${two(vn.day)}/${two(vn.month)}/${vn.year}';
}

class _TermsCard extends StatelessWidget {
  const _TermsCard({required this.terms});

  final OperatorServiceTerms? terms;

  @override
  Widget build(BuildContext context) {
    final value = terms;
    if (value == null) {
      return const _EmptyCard(
        key: Key('operator-terms-empty'),
        icon: Icons.description_outlined,
        message: 'Nhà xe chưa công bố điều khoản dịch vụ.',
      );
    }
    return Container(
      key: const Key('operator-terms'),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value.title,
            style: const TextStyle(
              color: _ink,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ArticleMarkdown(data: value.contentMarkdown),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.icon, required this.message, super.key});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9DB7C6), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: _muted, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActions extends StatelessWidget {
  const _ProfileActions({
    required this.hotline,
    required this.onCall,
    required this.onViewTrips,
  });

  final String? hotline;
  final ValueChanged<String> onCall;
  final VoidCallback? onViewTrips;

  @override
  Widget build(BuildContext context) {
    final phone = hotline?.trim();
    final canCall = phone != null && phone.isNotEmpty;
    if (!canCall && onViewTrips == null) return const SizedBox.shrink();
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x16092137),
            blurRadius: 13,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Row(
            children: [
              if (canCall)
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      key: const Key('operator-profile-call'),
                      onPressed: () => onCall(phone),
                      icon: const Icon(Icons.call_rounded, size: 18),
                      label: const Text(
                        'Gọi',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _primary,
                        side: const BorderSide(color: Color(0xFFB7D8E8)),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  ),
                ),
              if (canCall && onViewTrips != null) const SizedBox(width: 10),
              if (onViewTrips != null)
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: 50,
                    child: FilledButton(
                      key: const Key('operator-profile-view-trips'),
                      onPressed: onViewTrips,
                      style: FilledButton.styleFrom(
                        backgroundColor: _primary,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Xem chuyến của nhà xe',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
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

String _describeError(Object error) {
  if (error is ApiFailure && !error.isNetworkError) return error.detail;
  return 'Không thể kết nối máy chủ. Vui lòng kiểm tra mạng và thử lại.';
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final notFound = error is ApiFailure && (error as ApiFailure).status == 404;
    return Center(
      child: Padding(
        key: const Key('operator-profile-error'),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              notFound ? Icons.domain_disabled_outlined : Icons.cloud_off_rounded,
              color: _primary,
              size: 48,
            ),
            const SizedBox(height: 14),
            Text(
              notFound
                  ? 'Nhà xe không tồn tại hoặc đang tạm ngừng hoạt động.'
                  : 'Chưa thể tải thông tin nhà xe',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _ink,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!notFound) ...[
              const SizedBox(height: 6),
              Text(
                _describeError(error),
                textAlign: TextAlign.center,
                style: const TextStyle(color: _muted, fontSize: 13),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                key: const Key('operator-profile-retry'),
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Thử lại'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
