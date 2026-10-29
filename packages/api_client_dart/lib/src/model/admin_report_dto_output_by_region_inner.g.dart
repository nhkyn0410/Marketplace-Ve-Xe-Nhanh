// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_dto_output_by_region_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReportDtoOutputByRegionInner
    extends AdminReportDtoOutputByRegionInner {
  @override
  final String originProvinceId;
  @override
  final String originName;
  @override
  final String destinationProvinceId;
  @override
  final String destinationName;
  @override
  final int routes;
  @override
  final int operators;
  @override
  final int trips;
  @override
  final int seats;
  @override
  final int ticketsSold;
  @override
  final int ticketRevenue;

  factory _$AdminReportDtoOutputByRegionInner(
          [void Function(AdminReportDtoOutputByRegionInnerBuilder)? updates]) =>
      (AdminReportDtoOutputByRegionInnerBuilder()..update(updates))._build();

  _$AdminReportDtoOutputByRegionInner._(
      {required this.originProvinceId,
      required this.originName,
      required this.destinationProvinceId,
      required this.destinationName,
      required this.routes,
      required this.operators,
      required this.trips,
      required this.seats,
      required this.ticketsSold,
      required this.ticketRevenue})
      : super._();
  @override
  AdminReportDtoOutputByRegionInner rebuild(
          void Function(AdminReportDtoOutputByRegionInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminReportDtoOutputByRegionInnerBuilder toBuilder() =>
      AdminReportDtoOutputByRegionInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReportDtoOutputByRegionInner &&
        originProvinceId == other.originProvinceId &&
        originName == other.originName &&
        destinationProvinceId == other.destinationProvinceId &&
        destinationName == other.destinationName &&
        routes == other.routes &&
        operators == other.operators &&
        trips == other.trips &&
        seats == other.seats &&
        ticketsSold == other.ticketsSold &&
        ticketRevenue == other.ticketRevenue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, originProvinceId.hashCode);
    _$hash = $jc(_$hash, originName.hashCode);
    _$hash = $jc(_$hash, destinationProvinceId.hashCode);
    _$hash = $jc(_$hash, destinationName.hashCode);
    _$hash = $jc(_$hash, routes.hashCode);
    _$hash = $jc(_$hash, operators.hashCode);
    _$hash = $jc(_$hash, trips.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jc(_$hash, ticketsSold.hashCode);
    _$hash = $jc(_$hash, ticketRevenue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReportDtoOutputByRegionInner')
          ..add('originProvinceId', originProvinceId)
          ..add('originName', originName)
          ..add('destinationProvinceId', destinationProvinceId)
          ..add('destinationName', destinationName)
          ..add('routes', routes)
          ..add('operators', operators)
          ..add('trips', trips)
          ..add('seats', seats)
          ..add('ticketsSold', ticketsSold)
          ..add('ticketRevenue', ticketRevenue))
        .toString();
  }
}

class AdminReportDtoOutputByRegionInnerBuilder
    implements
        Builder<AdminReportDtoOutputByRegionInner,
            AdminReportDtoOutputByRegionInnerBuilder> {
  _$AdminReportDtoOutputByRegionInner? _$v;

  String? _originProvinceId;
  String? get originProvinceId => _$this._originProvinceId;
  set originProvinceId(String? originProvinceId) =>
      _$this._originProvinceId = originProvinceId;

  String? _originName;
  String? get originName => _$this._originName;
  set originName(String? originName) => _$this._originName = originName;

  String? _destinationProvinceId;
  String? get destinationProvinceId => _$this._destinationProvinceId;
  set destinationProvinceId(String? destinationProvinceId) =>
      _$this._destinationProvinceId = destinationProvinceId;

  String? _destinationName;
  String? get destinationName => _$this._destinationName;
  set destinationName(String? destinationName) =>
      _$this._destinationName = destinationName;

  int? _routes;
  int? get routes => _$this._routes;
  set routes(int? routes) => _$this._routes = routes;

  int? _operators;
  int? get operators => _$this._operators;
  set operators(int? operators) => _$this._operators = operators;

  int? _trips;
  int? get trips => _$this._trips;
  set trips(int? trips) => _$this._trips = trips;

  int? _seats;
  int? get seats => _$this._seats;
  set seats(int? seats) => _$this._seats = seats;

  int? _ticketsSold;
  int? get ticketsSold => _$this._ticketsSold;
  set ticketsSold(int? ticketsSold) => _$this._ticketsSold = ticketsSold;

  int? _ticketRevenue;
  int? get ticketRevenue => _$this._ticketRevenue;
  set ticketRevenue(int? ticketRevenue) =>
      _$this._ticketRevenue = ticketRevenue;

  AdminReportDtoOutputByRegionInnerBuilder() {
    AdminReportDtoOutputByRegionInner._defaults(this);
  }

  AdminReportDtoOutputByRegionInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _originProvinceId = $v.originProvinceId;
      _originName = $v.originName;
      _destinationProvinceId = $v.destinationProvinceId;
      _destinationName = $v.destinationName;
      _routes = $v.routes;
      _operators = $v.operators;
      _trips = $v.trips;
      _seats = $v.seats;
      _ticketsSold = $v.ticketsSold;
      _ticketRevenue = $v.ticketRevenue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReportDtoOutputByRegionInner other) {
    _$v = other as _$AdminReportDtoOutputByRegionInner;
  }

  @override
  void update(
      void Function(AdminReportDtoOutputByRegionInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReportDtoOutputByRegionInner build() => _build();

  _$AdminReportDtoOutputByRegionInner _build() {
    final _$result = _$v ??
        _$AdminReportDtoOutputByRegionInner._(
          originProvinceId: BuiltValueNullFieldError.checkNotNull(
              originProvinceId,
              r'AdminReportDtoOutputByRegionInner',
              'originProvinceId'),
          originName: BuiltValueNullFieldError.checkNotNull(
              originName, r'AdminReportDtoOutputByRegionInner', 'originName'),
          destinationProvinceId: BuiltValueNullFieldError.checkNotNull(
              destinationProvinceId,
              r'AdminReportDtoOutputByRegionInner',
              'destinationProvinceId'),
          destinationName: BuiltValueNullFieldError.checkNotNull(
              destinationName,
              r'AdminReportDtoOutputByRegionInner',
              'destinationName'),
          routes: BuiltValueNullFieldError.checkNotNull(
              routes, r'AdminReportDtoOutputByRegionInner', 'routes'),
          operators: BuiltValueNullFieldError.checkNotNull(
              operators, r'AdminReportDtoOutputByRegionInner', 'operators'),
          trips: BuiltValueNullFieldError.checkNotNull(
              trips, r'AdminReportDtoOutputByRegionInner', 'trips'),
          seats: BuiltValueNullFieldError.checkNotNull(
              seats, r'AdminReportDtoOutputByRegionInner', 'seats'),
          ticketsSold: BuiltValueNullFieldError.checkNotNull(
              ticketsSold, r'AdminReportDtoOutputByRegionInner', 'ticketsSold'),
          ticketRevenue: BuiltValueNullFieldError.checkNotNull(ticketRevenue,
              r'AdminReportDtoOutputByRegionInner', 'ticketRevenue'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
