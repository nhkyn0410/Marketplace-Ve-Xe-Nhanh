// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_reviews_dto_output_reviewed_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum
    _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnum_VISIBLE =
    const PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum._('VISIBLE');
const PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum
    _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnum_HELD =
    const PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum._('HELD');
const PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum
    _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnum_HIDDEN =
    const PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum._('HIDDEN');

PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum
    _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'VISIBLE':
      return _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnum_VISIBLE;
    case 'HELD':
      return _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnum_HELD;
    case 'HIDDEN':
      return _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnum_HIDDEN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum>
    _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnumValues = BuiltSet<
        PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum>(const <PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum>[
  _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnum_VISIBLE,
  _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnum_HELD,
  _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnum_HIDDEN,
]);

Serializer<PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum>
    _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnumSerializer =
    _$PassengerReviewsDtoOutputReviewedItemsInnerStatusEnumSerializer();

class _$PassengerReviewsDtoOutputReviewedItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum> {
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
  final Iterable<Type> types = const <Type>[
    PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum
  ];
  @override
  final String wireName =
      'PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PassengerReviewsDtoOutputReviewedItemsInner
    extends PassengerReviewsDtoOutputReviewedItemsInner {
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
  final PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum status;
  @override
  final String? operatorReply;
  @override
  final DateTime? operatorRepliedAt;
  @override
  final DateTime createdAt;

  factory _$PassengerReviewsDtoOutputReviewedItemsInner(
          [void Function(PassengerReviewsDtoOutputReviewedItemsInnerBuilder)?
              updates]) =>
      (PassengerReviewsDtoOutputReviewedItemsInnerBuilder()..update(updates))
          ._build();

  _$PassengerReviewsDtoOutputReviewedItemsInner._(
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
      required this.createdAt})
      : super._();
  @override
  PassengerReviewsDtoOutputReviewedItemsInner rebuild(
          void Function(PassengerReviewsDtoOutputReviewedItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerReviewsDtoOutputReviewedItemsInnerBuilder toBuilder() =>
      PassengerReviewsDtoOutputReviewedItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerReviewsDtoOutputReviewedItemsInner &&
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
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PassengerReviewsDtoOutputReviewedItemsInner')
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
          ..add('createdAt', createdAt))
        .toString();
  }
}

class PassengerReviewsDtoOutputReviewedItemsInnerBuilder
    implements
        Builder<PassengerReviewsDtoOutputReviewedItemsInner,
            PassengerReviewsDtoOutputReviewedItemsInnerBuilder> {
  _$PassengerReviewsDtoOutputReviewedItemsInner? _$v;

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

  PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum? _status;
  PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum? status) =>
      _$this._status = status;

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

  PassengerReviewsDtoOutputReviewedItemsInnerBuilder() {
    PassengerReviewsDtoOutputReviewedItemsInner._defaults(this);
  }

  PassengerReviewsDtoOutputReviewedItemsInnerBuilder get _$this {
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
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PassengerReviewsDtoOutputReviewedItemsInner other) {
    _$v = other as _$PassengerReviewsDtoOutputReviewedItemsInner;
  }

  @override
  void update(
      void Function(PassengerReviewsDtoOutputReviewedItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerReviewsDtoOutputReviewedItemsInner build() => _build();

  _$PassengerReviewsDtoOutputReviewedItemsInner _build() {
    final _$result = _$v ??
        _$PassengerReviewsDtoOutputReviewedItemsInner._(
          reviewId: BuiltValueNullFieldError.checkNotNull(reviewId,
              r'PassengerReviewsDtoOutputReviewedItemsInner', 'reviewId'),
          bookingId: BuiltValueNullFieldError.checkNotNull(bookingId,
              r'PassengerReviewsDtoOutputReviewedItemsInner', 'bookingId'),
          bookingCode: BuiltValueNullFieldError.checkNotNull(bookingCode,
              r'PassengerReviewsDtoOutputReviewedItemsInner', 'bookingCode'),
          operatorId: BuiltValueNullFieldError.checkNotNull(operatorId,
              r'PassengerReviewsDtoOutputReviewedItemsInner', 'operatorId'),
          operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
              r'PassengerReviewsDtoOutputReviewedItemsInner', 'operatorName'),
          authorName: BuiltValueNullFieldError.checkNotNull(authorName,
              r'PassengerReviewsDtoOutputReviewedItemsInner', 'authorName'),
          rating: BuiltValueNullFieldError.checkNotNull(
              rating, r'PassengerReviewsDtoOutputReviewedItemsInner', 'rating'),
          comment: comment,
          routeName: BuiltValueNullFieldError.checkNotNull(routeName,
              r'PassengerReviewsDtoOutputReviewedItemsInner', 'routeName'),
          departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
              r'PassengerReviewsDtoOutputReviewedItemsInner', 'departureAt'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'PassengerReviewsDtoOutputReviewedItemsInner', 'status'),
          operatorReply: operatorReply,
          operatorRepliedAt: operatorRepliedAt,
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'PassengerReviewsDtoOutputReviewedItemsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
