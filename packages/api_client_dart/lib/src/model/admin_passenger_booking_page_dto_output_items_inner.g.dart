// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_passenger_booking_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPassengerBookingPageDtoOutputItemsInner
    extends AdminPassengerBookingPageDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String bookingCode;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final int? total;
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
  final BuiltList<AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner>
      passengers;
  @override
  final String? paymentId;

  factory _$AdminPassengerBookingPageDtoOutputItemsInner(
          [void Function(AdminPassengerBookingPageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminPassengerBookingPageDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$AdminPassengerBookingPageDtoOutputItemsInner._(
      {required this.id,
      required this.bookingCode,
      required this.status,
      required this.createdAt,
      this.total,
      required this.operatorId,
      required this.operatorName,
      required this.tripId,
      required this.routeName,
      required this.departureAt,
      required this.passengers,
      this.paymentId})
      : super._();
  @override
  AdminPassengerBookingPageDtoOutputItemsInner rebuild(
          void Function(AdminPassengerBookingPageDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPassengerBookingPageDtoOutputItemsInnerBuilder toBuilder() =>
      AdminPassengerBookingPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPassengerBookingPageDtoOutputItemsInner &&
        id == other.id &&
        bookingCode == other.bookingCode &&
        status == other.status &&
        createdAt == other.createdAt &&
        total == other.total &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        tripId == other.tripId &&
        routeName == other.routeName &&
        departureAt == other.departureAt &&
        passengers == other.passengers &&
        paymentId == other.paymentId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, passengers.hashCode);
    _$hash = $jc(_$hash, paymentId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminPassengerBookingPageDtoOutputItemsInner')
          ..add('id', id)
          ..add('bookingCode', bookingCode)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('total', total)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('tripId', tripId)
          ..add('routeName', routeName)
          ..add('departureAt', departureAt)
          ..add('passengers', passengers)
          ..add('paymentId', paymentId))
        .toString();
  }
}

class AdminPassengerBookingPageDtoOutputItemsInnerBuilder
    implements
        Builder<AdminPassengerBookingPageDtoOutputItemsInner,
            AdminPassengerBookingPageDtoOutputItemsInnerBuilder> {
  _$AdminPassengerBookingPageDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

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

  ListBuilder<AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner>?
      _passengers;
  ListBuilder<AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner>
      get passengers => _$this._passengers ??= ListBuilder<
          AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner>();
  set passengers(
          ListBuilder<
                  AdminPassengerBookingPageDtoOutputItemsInnerPassengersInner>?
              passengers) =>
      _$this._passengers = passengers;

  String? _paymentId;
  String? get paymentId => _$this._paymentId;
  set paymentId(String? paymentId) => _$this._paymentId = paymentId;

  AdminPassengerBookingPageDtoOutputItemsInnerBuilder() {
    AdminPassengerBookingPageDtoOutputItemsInner._defaults(this);
  }

  AdminPassengerBookingPageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _bookingCode = $v.bookingCode;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _total = $v.total;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _tripId = $v.tripId;
      _routeName = $v.routeName;
      _departureAt = $v.departureAt;
      _passengers = $v.passengers.toBuilder();
      _paymentId = $v.paymentId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPassengerBookingPageDtoOutputItemsInner other) {
    _$v = other as _$AdminPassengerBookingPageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminPassengerBookingPageDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPassengerBookingPageDtoOutputItemsInner build() => _build();

  _$AdminPassengerBookingPageDtoOutputItemsInner _build() {
    _$AdminPassengerBookingPageDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$AdminPassengerBookingPageDtoOutputItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminPassengerBookingPageDtoOutputItemsInner', 'id'),
            bookingCode: BuiltValueNullFieldError.checkNotNull(bookingCode,
                r'AdminPassengerBookingPageDtoOutputItemsInner', 'bookingCode'),
            status: BuiltValueNullFieldError.checkNotNull(status,
                r'AdminPassengerBookingPageDtoOutputItemsInner', 'status'),
            createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
                r'AdminPassengerBookingPageDtoOutputItemsInner', 'createdAt'),
            total: total,
            operatorId: BuiltValueNullFieldError.checkNotNull(operatorId,
                r'AdminPassengerBookingPageDtoOutputItemsInner', 'operatorId'),
            operatorName: BuiltValueNullFieldError.checkNotNull(
                operatorName,
                r'AdminPassengerBookingPageDtoOutputItemsInner',
                'operatorName'),
            tripId: BuiltValueNullFieldError.checkNotNull(tripId,
                r'AdminPassengerBookingPageDtoOutputItemsInner', 'tripId'),
            routeName: BuiltValueNullFieldError.checkNotNull(routeName,
                r'AdminPassengerBookingPageDtoOutputItemsInner', 'routeName'),
            departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
                r'AdminPassengerBookingPageDtoOutputItemsInner', 'departureAt'),
            passengers: passengers.build(),
            paymentId: paymentId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'passengers';
        passengers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminPassengerBookingPageDtoOutputItemsInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
