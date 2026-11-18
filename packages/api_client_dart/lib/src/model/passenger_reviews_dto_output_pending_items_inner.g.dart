// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_reviews_dto_output_pending_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerReviewsDtoOutputPendingItemsInner
    extends PassengerReviewsDtoOutputPendingItemsInner {
  @override
  final String bookingId;
  @override
  final String bookingCode;
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final String routeName;
  @override
  final String? vehicleTypeName;
  @override
  final DateTime departureAt;

  factory _$PassengerReviewsDtoOutputPendingItemsInner(
          [void Function(PassengerReviewsDtoOutputPendingItemsInnerBuilder)?
              updates]) =>
      (PassengerReviewsDtoOutputPendingItemsInnerBuilder()..update(updates))
          ._build();

  _$PassengerReviewsDtoOutputPendingItemsInner._(
      {required this.bookingId,
      required this.bookingCode,
      required this.operatorId,
      required this.operatorName,
      required this.routeName,
      this.vehicleTypeName,
      required this.departureAt})
      : super._();
  @override
  PassengerReviewsDtoOutputPendingItemsInner rebuild(
          void Function(PassengerReviewsDtoOutputPendingItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerReviewsDtoOutputPendingItemsInnerBuilder toBuilder() =>
      PassengerReviewsDtoOutputPendingItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerReviewsDtoOutputPendingItemsInner &&
        bookingId == other.bookingId &&
        bookingCode == other.bookingCode &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        routeName == other.routeName &&
        vehicleTypeName == other.vehicleTypeName &&
        departureAt == other.departureAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, vehicleTypeName.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PassengerReviewsDtoOutputPendingItemsInner')
          ..add('bookingId', bookingId)
          ..add('bookingCode', bookingCode)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('routeName', routeName)
          ..add('vehicleTypeName', vehicleTypeName)
          ..add('departureAt', departureAt))
        .toString();
  }
}

class PassengerReviewsDtoOutputPendingItemsInnerBuilder
    implements
        Builder<PassengerReviewsDtoOutputPendingItemsInner,
            PassengerReviewsDtoOutputPendingItemsInnerBuilder> {
  _$PassengerReviewsDtoOutputPendingItemsInner? _$v;

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

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  String? _vehicleTypeName;
  String? get vehicleTypeName => _$this._vehicleTypeName;
  set vehicleTypeName(String? vehicleTypeName) =>
      _$this._vehicleTypeName = vehicleTypeName;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  PassengerReviewsDtoOutputPendingItemsInnerBuilder() {
    PassengerReviewsDtoOutputPendingItemsInner._defaults(this);
  }

  PassengerReviewsDtoOutputPendingItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingId = $v.bookingId;
      _bookingCode = $v.bookingCode;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _routeName = $v.routeName;
      _vehicleTypeName = $v.vehicleTypeName;
      _departureAt = $v.departureAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PassengerReviewsDtoOutputPendingItemsInner other) {
    _$v = other as _$PassengerReviewsDtoOutputPendingItemsInner;
  }

  @override
  void update(
      void Function(PassengerReviewsDtoOutputPendingItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerReviewsDtoOutputPendingItemsInner build() => _build();

  _$PassengerReviewsDtoOutputPendingItemsInner _build() {
    final _$result = _$v ??
        _$PassengerReviewsDtoOutputPendingItemsInner._(
          bookingId: BuiltValueNullFieldError.checkNotNull(bookingId,
              r'PassengerReviewsDtoOutputPendingItemsInner', 'bookingId'),
          bookingCode: BuiltValueNullFieldError.checkNotNull(bookingCode,
              r'PassengerReviewsDtoOutputPendingItemsInner', 'bookingCode'),
          operatorId: BuiltValueNullFieldError.checkNotNull(operatorId,
              r'PassengerReviewsDtoOutputPendingItemsInner', 'operatorId'),
          operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
              r'PassengerReviewsDtoOutputPendingItemsInner', 'operatorName'),
          routeName: BuiltValueNullFieldError.checkNotNull(routeName,
              r'PassengerReviewsDtoOutputPendingItemsInner', 'routeName'),
          vehicleTypeName: vehicleTypeName,
          departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
              r'PassengerReviewsDtoOutputPendingItemsInner', 'departureAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
