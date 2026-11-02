// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_dto_output_by_route_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReportDtoOutputByRouteInner
    extends AdminReportDtoOutputByRouteInner {
  @override
  final String routeId;
  @override
  final String routeName;
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final String? originName;
  @override
  final String? destinationName;
  @override
  final int trips;
  @override
  final int seats;
  @override
  final int ticketsSold;
  @override
  final int ticketRevenue;

  factory _$AdminReportDtoOutputByRouteInner(
          [void Function(AdminReportDtoOutputByRouteInnerBuilder)? updates]) =>
      (AdminReportDtoOutputByRouteInnerBuilder()..update(updates))._build();

  _$AdminReportDtoOutputByRouteInner._(
      {required this.routeId,
      required this.routeName,
      required this.operatorId,
      required this.operatorName,
      this.originName,
      this.destinationName,
      required this.trips,
      required this.seats,
      required this.ticketsSold,
      required this.ticketRevenue})
      : super._();
  @override
  AdminReportDtoOutputByRouteInner rebuild(
          void Function(AdminReportDtoOutputByRouteInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminReportDtoOutputByRouteInnerBuilder toBuilder() =>
      AdminReportDtoOutputByRouteInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReportDtoOutputByRouteInner &&
        routeId == other.routeId &&
        routeName == other.routeName &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        originName == other.originName &&
        destinationName == other.destinationName &&
        trips == other.trips &&
        seats == other.seats &&
        ticketsSold == other.ticketsSold &&
        ticketRevenue == other.ticketRevenue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, routeId.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, originName.hashCode);
    _$hash = $jc(_$hash, destinationName.hashCode);
    _$hash = $jc(_$hash, trips.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jc(_$hash, ticketsSold.hashCode);
    _$hash = $jc(_$hash, ticketRevenue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReportDtoOutputByRouteInner')
          ..add('routeId', routeId)
          ..add('routeName', routeName)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('originName', originName)
          ..add('destinationName', destinationName)
          ..add('trips', trips)
          ..add('seats', seats)
          ..add('ticketsSold', ticketsSold)
          ..add('ticketRevenue', ticketRevenue))
        .toString();
  }
}

class AdminReportDtoOutputByRouteInnerBuilder
    implements
        Builder<AdminReportDtoOutputByRouteInner,
            AdminReportDtoOutputByRouteInnerBuilder> {
  _$AdminReportDtoOutputByRouteInner? _$v;

  String? _routeId;
  String? get routeId => _$this._routeId;
  set routeId(String? routeId) => _$this._routeId = routeId;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  String? _originName;
  String? get originName => _$this._originName;
  set originName(String? originName) => _$this._originName = originName;

  String? _destinationName;
  String? get destinationName => _$this._destinationName;
  set destinationName(String? destinationName) =>
      _$this._destinationName = destinationName;

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

  AdminReportDtoOutputByRouteInnerBuilder() {
    AdminReportDtoOutputByRouteInner._defaults(this);
  }

  AdminReportDtoOutputByRouteInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _routeId = $v.routeId;
      _routeName = $v.routeName;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _originName = $v.originName;
      _destinationName = $v.destinationName;
      _trips = $v.trips;
      _seats = $v.seats;
      _ticketsSold = $v.ticketsSold;
      _ticketRevenue = $v.ticketRevenue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReportDtoOutputByRouteInner other) {
    _$v = other as _$AdminReportDtoOutputByRouteInner;
  }

  @override
  void update(void Function(AdminReportDtoOutputByRouteInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReportDtoOutputByRouteInner build() => _build();

  _$AdminReportDtoOutputByRouteInner _build() {
    final _$result = _$v ??
        _$AdminReportDtoOutputByRouteInner._(
          routeId: BuiltValueNullFieldError.checkNotNull(
              routeId, r'AdminReportDtoOutputByRouteInner', 'routeId'),
          routeName: BuiltValueNullFieldError.checkNotNull(
              routeName, r'AdminReportDtoOutputByRouteInner', 'routeName'),
          operatorId: BuiltValueNullFieldError.checkNotNull(
              operatorId, r'AdminReportDtoOutputByRouteInner', 'operatorId'),
          operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
              r'AdminReportDtoOutputByRouteInner', 'operatorName'),
          originName: originName,
          destinationName: destinationName,
          trips: BuiltValueNullFieldError.checkNotNull(
              trips, r'AdminReportDtoOutputByRouteInner', 'trips'),
          seats: BuiltValueNullFieldError.checkNotNull(
              seats, r'AdminReportDtoOutputByRouteInner', 'seats'),
          ticketsSold: BuiltValueNullFieldError.checkNotNull(
              ticketsSold, r'AdminReportDtoOutputByRouteInner', 'ticketsSold'),
          ticketRevenue: BuiltValueNullFieldError.checkNotNull(ticketRevenue,
              r'AdminReportDtoOutputByRouteInner', 'ticketRevenue'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
