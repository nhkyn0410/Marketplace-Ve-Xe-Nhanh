// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReviewDtoOutputStatusEnum _$reviewDtoOutputStatusEnum_VISIBLE =
    const ReviewDtoOutputStatusEnum._('VISIBLE');
const ReviewDtoOutputStatusEnum _$reviewDtoOutputStatusEnum_HELD =
    const ReviewDtoOutputStatusEnum._('HELD');
const ReviewDtoOutputStatusEnum _$reviewDtoOutputStatusEnum_HIDDEN =
    const ReviewDtoOutputStatusEnum._('HIDDEN');

ReviewDtoOutputStatusEnum _$reviewDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'VISIBLE':
      return _$reviewDtoOutputStatusEnum_VISIBLE;
    case 'HELD':
      return _$reviewDtoOutputStatusEnum_HELD;
    case 'HIDDEN':
      return _$reviewDtoOutputStatusEnum_HIDDEN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReviewDtoOutputStatusEnum> _$reviewDtoOutputStatusEnumValues =
    BuiltSet<ReviewDtoOutputStatusEnum>(const <ReviewDtoOutputStatusEnum>[
  _$reviewDtoOutputStatusEnum_VISIBLE,
  _$reviewDtoOutputStatusEnum_HELD,
  _$reviewDtoOutputStatusEnum_HIDDEN,
]);

const ReviewDtoOutputSignalsEnum _$reviewDtoOutputSignalsEnum_SPAM =
    const ReviewDtoOutputSignalsEnum._('SPAM');
const ReviewDtoOutputSignalsEnum
    _$reviewDtoOutputSignalsEnum_OPERATOR_REPORTED =
    const ReviewDtoOutputSignalsEnum._('OPERATOR_REPORTED');
const ReviewDtoOutputSignalsEnum _$reviewDtoOutputSignalsEnum_DISPUTED =
    const ReviewDtoOutputSignalsEnum._('DISPUTED');
const ReviewDtoOutputSignalsEnum _$reviewDtoOutputSignalsEnum_REPEATED =
    const ReviewDtoOutputSignalsEnum._('REPEATED');

ReviewDtoOutputSignalsEnum _$reviewDtoOutputSignalsEnumValueOf(String name) {
  switch (name) {
    case 'SPAM':
      return _$reviewDtoOutputSignalsEnum_SPAM;
    case 'OPERATOR_REPORTED':
      return _$reviewDtoOutputSignalsEnum_OPERATOR_REPORTED;
    case 'DISPUTED':
      return _$reviewDtoOutputSignalsEnum_DISPUTED;
    case 'REPEATED':
      return _$reviewDtoOutputSignalsEnum_REPEATED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReviewDtoOutputSignalsEnum> _$reviewDtoOutputSignalsEnumValues =
    BuiltSet<ReviewDtoOutputSignalsEnum>(const <ReviewDtoOutputSignalsEnum>[
  _$reviewDtoOutputSignalsEnum_SPAM,
  _$reviewDtoOutputSignalsEnum_OPERATOR_REPORTED,
  _$reviewDtoOutputSignalsEnum_DISPUTED,
  _$reviewDtoOutputSignalsEnum_REPEATED,
]);

Serializer<ReviewDtoOutputStatusEnum> _$reviewDtoOutputStatusEnumSerializer =
    _$ReviewDtoOutputStatusEnumSerializer();
Serializer<ReviewDtoOutputSignalsEnum> _$reviewDtoOutputSignalsEnumSerializer =
    _$ReviewDtoOutputSignalsEnumSerializer();

class _$ReviewDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<ReviewDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VISIBLE': 'VISIBLE',
    'HELD': 'HELD',
    'HIDDEN': 'HIDDEN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VISIBLE': 'VISIBLE',
    'HELD': 'HELD',
    'HIDDEN': 'HIDDEN',
  };

  @override
  final Iterable<Type> types = const <Type>[ReviewDtoOutputStatusEnum];
  @override
  final String wireName = 'ReviewDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers, ReviewDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReviewDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReviewDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReviewDtoOutputSignalsEnumSerializer
    implements PrimitiveSerializer<ReviewDtoOutputSignalsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SPAM': 'SPAM',
    'OPERATOR_REPORTED': 'OPERATOR_REPORTED',
    'DISPUTED': 'DISPUTED',
    'REPEATED': 'REPEATED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SPAM': 'SPAM',
    'OPERATOR_REPORTED': 'OPERATOR_REPORTED',
    'DISPUTED': 'DISPUTED',
    'REPEATED': 'REPEATED',
  };

  @override
  final Iterable<Type> types = const <Type>[ReviewDtoOutputSignalsEnum];
  @override
  final String wireName = 'ReviewDtoOutputSignalsEnum';

  @override
  Object serialize(Serializers serializers, ReviewDtoOutputSignalsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReviewDtoOutputSignalsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReviewDtoOutputSignalsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReviewDtoOutput extends ReviewDtoOutput {
  @override
  final String reviewId;
  @override
  final String bookingId;
  @override
  final String bookingCode;
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final String authorName;
  @override
  final int rating;
  @override
  final String? comment;
  @override
  final String routeName;
  @override
  final DateTime departureAt;
  @override
  final ReviewDtoOutputStatusEnum status;
  @override
  final String? operatorReply;
  @override
  final DateTime? operatorRepliedAt;
  @override
  final DateTime? operatorReportedAt;
  @override
  final String? operatorReportReason;
  @override
  final String? moderationReason;
  @override
  final BuiltList<ReviewDtoOutputSignalsEnum> signals;
  @override
  final DateTime createdAt;

  factory _$ReviewDtoOutput([void Function(ReviewDtoOutputBuilder)? updates]) =>
      (ReviewDtoOutputBuilder()..update(updates))._build();

  _$ReviewDtoOutput._(
      {required this.reviewId,
      required this.bookingId,
      required this.bookingCode,
      required this.operatorId,
      required this.operatorName,
      required this.authorName,
      required this.rating,
      this.comment,
      required this.routeName,
      required this.departureAt,
      required this.status,
      this.operatorReply,
      this.operatorRepliedAt,
      this.operatorReportedAt,
      this.operatorReportReason,
      this.moderationReason,
      required this.signals,
      required this.createdAt})
      : super._();
  @override
  ReviewDtoOutput rebuild(void Function(ReviewDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewDtoOutputBuilder toBuilder() => ReviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewDtoOutput &&
        reviewId == other.reviewId &&
        bookingId == other.bookingId &&
        bookingCode == other.bookingCode &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        authorName == other.authorName &&
        rating == other.rating &&
        comment == other.comment &&
        routeName == other.routeName &&
        departureAt == other.departureAt &&
        status == other.status &&
        operatorReply == other.operatorReply &&
        operatorRepliedAt == other.operatorRepliedAt &&
        operatorReportedAt == other.operatorReportedAt &&
        operatorReportReason == other.operatorReportReason &&
        moderationReason == other.moderationReason &&
        signals == other.signals &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reviewId.hashCode);
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, authorName.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, operatorReply.hashCode);
    _$hash = $jc(_$hash, operatorRepliedAt.hashCode);
    _$hash = $jc(_$hash, operatorReportedAt.hashCode);
    _$hash = $jc(_$hash, operatorReportReason.hashCode);
    _$hash = $jc(_$hash, moderationReason.hashCode);
    _$hash = $jc(_$hash, signals.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewDtoOutput')
          ..add('reviewId', reviewId)
          ..add('bookingId', bookingId)
          ..add('bookingCode', bookingCode)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('authorName', authorName)
          ..add('rating', rating)
          ..add('comment', comment)
          ..add('routeName', routeName)
          ..add('departureAt', departureAt)
          ..add('status', status)
          ..add('operatorReply', operatorReply)
          ..add('operatorRepliedAt', operatorRepliedAt)
          ..add('operatorReportedAt', operatorReportedAt)
          ..add('operatorReportReason', operatorReportReason)
          ..add('moderationReason', moderationReason)
          ..add('signals', signals)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ReviewDtoOutputBuilder
    implements Builder<ReviewDtoOutput, ReviewDtoOutputBuilder> {
  _$ReviewDtoOutput? _$v;

  String? _reviewId;
  String? get reviewId => _$this._reviewId;
  set reviewId(String? reviewId) => _$this._reviewId = reviewId;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  String? _authorName;
  String? get authorName => _$this._authorName;
  set authorName(String? authorName) => _$this._authorName = authorName;

  int? _rating;
  int? get rating => _$this._rating;
  set rating(int? rating) => _$this._rating = rating;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  ReviewDtoOutputStatusEnum? _status;
  ReviewDtoOutputStatusEnum? get status => _$this._status;
  set status(ReviewDtoOutputStatusEnum? status) => _$this._status = status;

  String? _operatorReply;
  String? get operatorReply => _$this._operatorReply;
  set operatorReply(String? operatorReply) =>
      _$this._operatorReply = operatorReply;

  DateTime? _operatorRepliedAt;
  DateTime? get operatorRepliedAt => _$this._operatorRepliedAt;
  set operatorRepliedAt(DateTime? operatorRepliedAt) =>
      _$this._operatorRepliedAt = operatorRepliedAt;

  DateTime? _operatorReportedAt;
  DateTime? get operatorReportedAt => _$this._operatorReportedAt;
  set operatorReportedAt(DateTime? operatorReportedAt) =>
      _$this._operatorReportedAt = operatorReportedAt;

  String? _operatorReportReason;
  String? get operatorReportReason => _$this._operatorReportReason;
  set operatorReportReason(String? operatorReportReason) =>
      _$this._operatorReportReason = operatorReportReason;

  String? _moderationReason;
  String? get moderationReason => _$this._moderationReason;
  set moderationReason(String? moderationReason) =>
      _$this._moderationReason = moderationReason;

  ListBuilder<ReviewDtoOutputSignalsEnum>? _signals;
  ListBuilder<ReviewDtoOutputSignalsEnum> get signals =>
      _$this._signals ??= ListBuilder<ReviewDtoOutputSignalsEnum>();
  set signals(ListBuilder<ReviewDtoOutputSignalsEnum>? signals) =>
      _$this._signals = signals;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ReviewDtoOutputBuilder() {
    ReviewDtoOutput._defaults(this);
  }

  ReviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reviewId = $v.reviewId;
      _bookingId = $v.bookingId;
      _bookingCode = $v.bookingCode;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _authorName = $v.authorName;
      _rating = $v.rating;
      _comment = $v.comment;
      _routeName = $v.routeName;
      _departureAt = $v.departureAt;
      _status = $v.status;
      _operatorReply = $v.operatorReply;
      _operatorRepliedAt = $v.operatorRepliedAt;
      _operatorReportedAt = $v.operatorReportedAt;
      _operatorReportReason = $v.operatorReportReason;
      _moderationReason = $v.moderationReason;
      _signals = $v.signals.toBuilder();
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewDtoOutput other) {
    _$v = other as _$ReviewDtoOutput;
  }

  @override
  void update(void Function(ReviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewDtoOutput build() => _build();

  _$ReviewDtoOutput _build() {
    _$ReviewDtoOutput _$result;
    try {
      _$result = _$v ??
          _$ReviewDtoOutput._(
            reviewId: BuiltValueNullFieldError.checkNotNull(
                reviewId, r'ReviewDtoOutput', 'reviewId'),
            bookingId: BuiltValueNullFieldError.checkNotNull(
                bookingId, r'ReviewDtoOutput', 'bookingId'),
            bookingCode: BuiltValueNullFieldError.checkNotNull(
                bookingCode, r'ReviewDtoOutput', 'bookingCode'),
            operatorId: BuiltValueNullFieldError.checkNotNull(
                operatorId, r'ReviewDtoOutput', 'operatorId'),
            operatorName: BuiltValueNullFieldError.checkNotNull(
                operatorName, r'ReviewDtoOutput', 'operatorName'),
            authorName: BuiltValueNullFieldError.checkNotNull(
                authorName, r'ReviewDtoOutput', 'authorName'),
            rating: BuiltValueNullFieldError.checkNotNull(
                rating, r'ReviewDtoOutput', 'rating'),
            comment: comment,
            routeName: BuiltValueNullFieldError.checkNotNull(
                routeName, r'ReviewDtoOutput', 'routeName'),
            departureAt: BuiltValueNullFieldError.checkNotNull(
                departureAt, r'ReviewDtoOutput', 'departureAt'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ReviewDtoOutput', 'status'),
            operatorReply: operatorReply,
            operatorRepliedAt: operatorRepliedAt,
            operatorReportedAt: operatorReportedAt,
            operatorReportReason: operatorReportReason,
            moderationReason: moderationReason,
            signals: signals.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ReviewDtoOutput', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'signals';
        signals.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ReviewDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
