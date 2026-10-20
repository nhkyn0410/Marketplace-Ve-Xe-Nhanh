// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_booking_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerBookingPageDtoOutputItemsInner
    extends PassengerBookingPageDtoOutputItemsInner {
  @override
  final String bookingId;
  @override
  final String bookingCode;
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final String tripId;
  @override
  final String routeName;
  @override
  final DateTime departureAt;
  @override
  final String status;
  @override
  final String total;
  @override
  final DateTime createdAt;

  factory _$PassengerBookingPageDtoOutputItemsInner(
          [void Function(PassengerBookingPageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (PassengerBookingPageDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$PassengerBookingPageDtoOutputItemsInner._(
      {required this.bookingId,
      required this.bookingCode,
      required this.operatorId,
      required this.operatorName,
      required this.tripId,
      required this.routeName,
      required this.departureAt,
      required this.status,
      required this.total,
      required this.createdAt})
      : super._();
  @override
  PassengerBookingPageDtoOutputItemsInner rebuild(
          void Function(PassengerBookingPageDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerBookingPageDtoOutputItemsInnerBuilder toBuilder() =>
      PassengerBookingPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerBookingPageDtoOutputItemsInner &&
        bookingId == other.bookingId &&
        bookingCode == other.bookingCode &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        tripId == other.tripId &&
        routeName == other.routeName &&
        departureAt == other.departureAt &&
        status == other.status &&
        total == other.total &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PassengerBookingPageDtoOutputItemsInner')
          ..add('bookingId', bookingId)
          ..add('bookingCode', bookingCode)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('tripId', tripId)
          ..add('routeName', routeName)
          ..add('departureAt', departureAt)
          ..add('status', status)
          ..add('total', total)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class PassengerBookingPageDtoOutputItemsInnerBuilder
    implements
        Builder<PassengerBookingPageDtoOutputItemsInner,
            PassengerBookingPageDtoOutputItemsInnerBuilder> {
  _$PassengerBookingPageDtoOutputItemsInner? _$v;

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

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  PassengerBookingPageDtoOutputItemsInnerBuilder() {
    PassengerBookingPageDtoOutputItemsInner._defaults(this);
  }

  PassengerBookingPageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingId = $v.bookingId;
      _bookingCode = $v.bookingCode;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _tripId = $v.tripId;
      _routeName = $v.routeName;
      _departureAt = $v.departureAt;
      _status = $v.status;
      _total = $v.total;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PassengerBookingPageDtoOutputItemsInner other) {
    _$v = other as _$PassengerBookingPageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(PassengerBookingPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerBookingPageDtoOutputItemsInner build() => _build();

  _$PassengerBookingPageDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$PassengerBookingPageDtoOutputItemsInner._(
          bookingId: BuiltValueNullFieldError.checkNotNull(bookingId,
              r'PassengerBookingPageDtoOutputItemsInner', 'bookingId'),
          bookingCode: BuiltValueNullFieldError.checkNotNull(bookingCode,
              r'PassengerBookingPageDtoOutputItemsInner', 'bookingCode'),
          operatorId: BuiltValueNullFieldError.checkNotNull(operatorId,
              r'PassengerBookingPageDtoOutputItemsInner', 'operatorId'),
          operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
              r'PassengerBookingPageDtoOutputItemsInner', 'operatorName'),
          tripId: BuiltValueNullFieldError.checkNotNull(
              tripId, r'PassengerBookingPageDtoOutputItemsInner', 'tripId'),
          routeName: BuiltValueNullFieldError.checkNotNull(routeName,
              r'PassengerBookingPageDtoOutputItemsInner', 'routeName'),
          departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
              r'PassengerBookingPageDtoOutputItemsInner', 'departureAt'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'PassengerBookingPageDtoOutputItemsInner', 'status'),
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'PassengerBookingPageDtoOutputItemsInner', 'total'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'PassengerBookingPageDtoOutputItemsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
