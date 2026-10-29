// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_route_detail_dto_output_next_trips_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRouteDetailDtoOutputNextTripsInner
    extends AdminRouteDetailDtoOutputNextTripsInner {
  @override
  final String id;
  @override
  final DateTime departureAt;
  @override
  final String status;
  @override
  final String? vehiclePlate;
  @override
  final int seats;
  @override
  final int ticketsSold;

  factory _$AdminRouteDetailDtoOutputNextTripsInner(
          [void Function(AdminRouteDetailDtoOutputNextTripsInnerBuilder)?
              updates]) =>
      (AdminRouteDetailDtoOutputNextTripsInnerBuilder()..update(updates))
          ._build();

  _$AdminRouteDetailDtoOutputNextTripsInner._(
      {required this.id,
      required this.departureAt,
      required this.status,
      this.vehiclePlate,
      required this.seats,
      required this.ticketsSold})
      : super._();
  @override
  AdminRouteDetailDtoOutputNextTripsInner rebuild(
          void Function(AdminRouteDetailDtoOutputNextTripsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminRouteDetailDtoOutputNextTripsInnerBuilder toBuilder() =>
      AdminRouteDetailDtoOutputNextTripsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRouteDetailDtoOutputNextTripsInner &&
        id == other.id &&
        departureAt == other.departureAt &&
        status == other.status &&
        vehiclePlate == other.vehiclePlate &&
        seats == other.seats &&
        ticketsSold == other.ticketsSold;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, vehiclePlate.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jc(_$hash, ticketsSold.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRouteDetailDtoOutputNextTripsInner')
          ..add('id', id)
          ..add('departureAt', departureAt)
          ..add('status', status)
          ..add('vehiclePlate', vehiclePlate)
          ..add('seats', seats)
          ..add('ticketsSold', ticketsSold))
        .toString();
  }
}

class AdminRouteDetailDtoOutputNextTripsInnerBuilder
    implements
        Builder<AdminRouteDetailDtoOutputNextTripsInner,
            AdminRouteDetailDtoOutputNextTripsInnerBuilder> {
  _$AdminRouteDetailDtoOutputNextTripsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _vehiclePlate;
  String? get vehiclePlate => _$this._vehiclePlate;
  set vehiclePlate(String? vehiclePlate) => _$this._vehiclePlate = vehiclePlate;

  int? _seats;
  int? get seats => _$this._seats;
  set seats(int? seats) => _$this._seats = seats;

  int? _ticketsSold;
  int? get ticketsSold => _$this._ticketsSold;
  set ticketsSold(int? ticketsSold) => _$this._ticketsSold = ticketsSold;

  AdminRouteDetailDtoOutputNextTripsInnerBuilder() {
    AdminRouteDetailDtoOutputNextTripsInner._defaults(this);
  }

  AdminRouteDetailDtoOutputNextTripsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _departureAt = $v.departureAt;
      _status = $v.status;
      _vehiclePlate = $v.vehiclePlate;
      _seats = $v.seats;
      _ticketsSold = $v.ticketsSold;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRouteDetailDtoOutputNextTripsInner other) {
    _$v = other as _$AdminRouteDetailDtoOutputNextTripsInner;
  }

  @override
  void update(
      void Function(AdminRouteDetailDtoOutputNextTripsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRouteDetailDtoOutputNextTripsInner build() => _build();

  _$AdminRouteDetailDtoOutputNextTripsInner _build() {
    final _$result = _$v ??
        _$AdminRouteDetailDtoOutputNextTripsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminRouteDetailDtoOutputNextTripsInner', 'id'),
          departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
              r'AdminRouteDetailDtoOutputNextTripsInner', 'departureAt'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminRouteDetailDtoOutputNextTripsInner', 'status'),
          vehiclePlate: vehiclePlate,
          seats: BuiltValueNullFieldError.checkNotNull(
              seats, r'AdminRouteDetailDtoOutputNextTripsInner', 'seats'),
          ticketsSold: BuiltValueNullFieldError.checkNotNull(ticketsSold,
              r'AdminRouteDetailDtoOutputNextTripsInner', 'ticketsSold'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
