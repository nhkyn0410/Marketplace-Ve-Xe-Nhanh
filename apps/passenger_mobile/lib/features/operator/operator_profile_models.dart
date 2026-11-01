/// Hồ sơ công khai của nhà xe (`GET /operators/{id}/public-profile`, FR-MKT-06).
class OperatorProfile {
  const OperatorProfile({
    required this.operatorId,
    required this.displayName,
    required this.scorecard,
    required this.routes,
    required this.reviews,
    this.logoUrl,
    this.description,
    this.hotline,
    this.publicEmail,
    this.address,
    this.serviceTerms,
    this.nextReviewCursor,
  });

  final String operatorId;
  final String displayName;
  final String? logoUrl;
  final String? description;
  final String? hotline;
  final String? publicEmail;
  final String? address;
  final OperatorScorecard scorecard;

  /// Tuyến đang có chuyến mở bán, tối đa 6 tuyến.
  final List<OperatorRoute> routes;
  final OperatorServiceTerms? serviceTerms;
  final List<OperatorReview> reviews;

  /// `null` = đã hết đánh giá để tải.
  final String? nextReviewCursor;
}

/// Chỉ số chất lượng; `null` = chưa đủ dữ liệu để tính.
class OperatorScorecard {
  const OperatorScorecard({
    required this.reviewCount,
    this.averageRating,
    this.operatorCancellationRate,
    this.refundBookingRate,
    this.disputeBookingRate,
    this.checkInRate,
    this.noShowRate,
  });

  final int reviewCount;
  final double? averageRating;
  final double? operatorCancellationRate;
  final double? refundBookingRate;
  final double? disputeBookingRate;
  final double? checkInRate;
  final double? noShowRate;
}

/// Một tuyến đang có chuyến mở bán của nhà xe.
class OperatorRoute {
  const OperatorRoute({required this.id, required this.name});

  final String id;
  final String name;
}

/// Điều khoản dịch vụ nhà xe công bố, nội dung dạng Markdown.
class OperatorServiceTerms {
  const OperatorServiceTerms({
    required this.title,
    required this.contentMarkdown,
  });

  final String title;
  final String contentMarkdown;
}

/// Một đánh giá đang hiển thị của nhà xe, kèm phản hồi của nhà xe nếu có.
class OperatorReview {
  const OperatorReview({
    required this.id,
    required this.authorName,
    required this.rating,
    required this.createdAt,
    this.comment,
    this.operatorReply,
  });

  final String id;

  /// API đã che bớt tên người viết.
  final String authorName;
  final int rating;
  final DateTime createdAt;
  final String? comment;
  final String? operatorReply;
}

/// [reviewCursor] tải trang đánh giá kế tiếp.
typedef OperatorProfileLoader =
    Future<OperatorProfile> Function(String operatorId, {String? reviewCursor});
