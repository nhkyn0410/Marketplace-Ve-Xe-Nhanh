// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_operator_profile_dto_output_reviews_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicOperatorProfileDtoOutputReviewsInner
    extends PublicOperatorProfileDtoOutputReviewsInner {
  @override
  final String reviewId;
  @override
  final String authorName;
  @override
  final int rating;
  @override
  final String? comment;
  @override
  final String? operatorReply;
  @override
  final DateTime? operatorRepliedAt;
  @override
  final DateTime createdAt;

  factory _$PublicOperatorProfileDtoOutputReviewsInner(
          [void Function(PublicOperatorProfileDtoOutputReviewsInnerBuilder)?
              updates]) =>
      (PublicOperatorProfileDtoOutputReviewsInnerBuilder()..update(updates))
          ._build();

  _$PublicOperatorProfileDtoOutputReviewsInner._(
      {required this.reviewId,
      required this.authorName,
      required this.rating,
      this.comment,
      this.operatorReply,
      this.operatorRepliedAt,
      required this.createdAt})
      : super._();
  @override
  PublicOperatorProfileDtoOutputReviewsInner rebuild(
          void Function(PublicOperatorProfileDtoOutputReviewsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicOperatorProfileDtoOutputReviewsInnerBuilder toBuilder() =>
      PublicOperatorProfileDtoOutputReviewsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicOperatorProfileDtoOutputReviewsInner &&
        reviewId == other.reviewId &&
        authorName == other.authorName &&
        rating == other.rating &&
        comment == other.comment &&
        operatorReply == other.operatorReply &&
        operatorRepliedAt == other.operatorRepliedAt &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reviewId.hashCode);
    _$hash = $jc(_$hash, authorName.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, operatorReply.hashCode);
    _$hash = $jc(_$hash, operatorRepliedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PublicOperatorProfileDtoOutputReviewsInner')
          ..add('reviewId', reviewId)
          ..add('authorName', authorName)
          ..add('rating', rating)
          ..add('comment', comment)
          ..add('operatorReply', operatorReply)
          ..add('operatorRepliedAt', operatorRepliedAt)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class PublicOperatorProfileDtoOutputReviewsInnerBuilder
    implements
        Builder<PublicOperatorProfileDtoOutputReviewsInner,
            PublicOperatorProfileDtoOutputReviewsInnerBuilder> {
  _$PublicOperatorProfileDtoOutputReviewsInner? _$v;

  String? _reviewId;
  String? get reviewId => _$this._reviewId;
  set reviewId(String? reviewId) => _$this._reviewId = reviewId;

  String? _authorName;
  String? get authorName => _$this._authorName;
  set authorName(String? authorName) => _$this._authorName = authorName;

  int? _rating;
  int? get rating => _$this._rating;
  set rating(int? rating) => _$this._rating = rating;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  String? _operatorReply;
  String? get operatorReply => _$this._operatorReply;
  set operatorReply(String? operatorReply) =>
      _$this._operatorReply = operatorReply;

  DateTime? _operatorRepliedAt;
  DateTime? get operatorRepliedAt => _$this._operatorRepliedAt;
  set operatorRepliedAt(DateTime? operatorRepliedAt) =>
      _$this._operatorRepliedAt = operatorRepliedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  PublicOperatorProfileDtoOutputReviewsInnerBuilder() {
    PublicOperatorProfileDtoOutputReviewsInner._defaults(this);
  }

  PublicOperatorProfileDtoOutputReviewsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reviewId = $v.reviewId;
      _authorName = $v.authorName;
      _rating = $v.rating;
      _comment = $v.comment;
      _operatorReply = $v.operatorReply;
      _operatorRepliedAt = $v.operatorRepliedAt;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicOperatorProfileDtoOutputReviewsInner other) {
    _$v = other as _$PublicOperatorProfileDtoOutputReviewsInner;
  }

  @override
  void update(
      void Function(PublicOperatorProfileDtoOutputReviewsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicOperatorProfileDtoOutputReviewsInner build() => _build();

  _$PublicOperatorProfileDtoOutputReviewsInner _build() {
    final _$result = _$v ??
        _$PublicOperatorProfileDtoOutputReviewsInner._(
          reviewId: BuiltValueNullFieldError.checkNotNull(reviewId,
              r'PublicOperatorProfileDtoOutputReviewsInner', 'reviewId'),
          authorName: BuiltValueNullFieldError.checkNotNull(authorName,
              r'PublicOperatorProfileDtoOutputReviewsInner', 'authorName'),
          rating: BuiltValueNullFieldError.checkNotNull(
              rating, r'PublicOperatorProfileDtoOutputReviewsInner', 'rating'),
          comment: comment,
          operatorReply: operatorReply,
          operatorRepliedAt: operatorRepliedAt,
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'PublicOperatorProfileDtoOutputReviewsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
