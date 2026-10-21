// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_report_dto_output_by_route_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperatorReportDtoOutputByRouteInner
    extends OperatorReportDtoOutputByRouteInner {
  @override
  final String routeId;
  @override
  final String routeName;
  @override
  final int trips;
  @override
  final int completedTrips;
  @override
  final int seats;
  @override
  final int ticketsSold;
  @override
  final int grossRevenue;

  factory _$OperatorReportDtoOutputByRouteInner(
          [void Function(OperatorReportDtoOutputByRouteInnerBuilder)?
              updates]) =>
      (OperatorReportDtoOutputByRouteInnerBuilder()..update(updates))._build();

  _$OperatorReportDtoOutputByRouteInner._(
      {required this.routeId,
      required this.routeName,
      required this.trips,
      required this.completedTrips,
      required this.seats,
      required this.ticketsSold,
      required this.grossRevenue})
      : super._();
  @override
  OperatorReportDtoOutputByRouteInner rebuild(
          void Function(OperatorReportDtoOutputByRouteInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorReportDtoOutputByRouteInnerBuilder toBuilder() =>
      OperatorReportDtoOutputByRouteInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorReportDtoOutputByRouteInner &&
        routeId == other.routeId &&
        routeName == other.routeName &&
        trips == other.trips &&
        completedTrips == other.completedTrips &&
        seats == other.seats &&
        ticketsSold == other.ticketsSold &&
        grossRevenue == other.grossRevenue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, routeId.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, trips.hashCode);
    _$hash = $jc(_$hash, completedTrips.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jc(_$hash, ticketsSold.hashCode);
    _$hash = $jc(_$hash, grossRevenue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperatorReportDtoOutputByRouteInner')
          ..add('routeId', routeId)
          ..add('routeName', routeName)
          ..add('trips', trips)
          ..add('completedTrips', completedTrips)
          ..add('seats', seats)
          ..add('ticketsSold', ticketsSold)
          ..add('grossRevenue', grossRevenue))
        .toString();
  }
}

class OperatorReportDtoOutputByRouteInnerBuilder
    implements
        Builder<OperatorReportDtoOutputByRouteInner,
            OperatorReportDtoOutputByRouteInnerBuilder> {
  _$OperatorReportDtoOutputByRouteInner? _$v;

  String? _routeId;
  String? get routeId => _$this._routeId;
  set routeId(String? routeId) => _$this._routeId = routeId;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  int? _trips;
  int? get trips => _$this._trips;
  set trips(int? trips) => _$this._trips = trips;

  int? _completedTrips;
  int? get completedTrips => _$this._completedTrips;
  set completedTrips(int? completedTrips) =>
      _$this._completedTrips = completedTrips;

  int? _seats;
  int? get seats => _$this._seats;
  set seats(int? seats) => _$this._seats = seats;

  int? _ticketsSold;
  int? get ticketsSold => _$this._ticketsSold;
  set ticketsSold(int? ticketsSold) => _$this._ticketsSold = ticketsSold;

  int? _grossRevenue;
  int? get grossRevenue => _$this._grossRevenue;
  set grossRevenue(int? grossRevenue) => _$this._grossRevenue = grossRevenue;

  OperatorReportDtoOutputByRouteInnerBuilder() {
    OperatorReportDtoOutputByRouteInner._defaults(this);
  }

  OperatorReportDtoOutputByRouteInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _routeId = $v.routeId;
      _routeName = $v.routeName;
      _trips = $v.trips;
      _completedTrips = $v.completedTrips;
      _seats = $v.seats;
      _ticketsSold = $v.ticketsSold;
      _grossRevenue = $v.grossRevenue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorReportDtoOutputByRouteInner other) {
    _$v = other as _$OperatorReportDtoOutputByRouteInner;
  }

  @override
  void update(
      void Function(OperatorReportDtoOutputByRouteInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorReportDtoOutputByRouteInner build() => _build();

  _$OperatorReportDtoOutputByRouteInner _build() {
    final _$result = _$v ??
        _$OperatorReportDtoOutputByRouteInner._(
          routeId: BuiltValueNullFieldError.checkNotNull(
              routeId, r'OperatorReportDtoOutputByRouteInner', 'routeId'),
          routeName: BuiltValueNullFieldError.checkNotNull(
              routeName, r'OperatorReportDtoOutputByRouteInner', 'routeName'),
          trips: BuiltValueNullFieldError.checkNotNull(
              trips, r'OperatorReportDtoOutputByRouteInner', 'trips'),
          completedTrips: BuiltValueNullFieldError.checkNotNull(completedTrips,
              r'OperatorReportDtoOutputByRouteInner', 'completedTrips'),
          seats: BuiltValueNullFieldError.checkNotNull(
              seats, r'OperatorReportDtoOutputByRouteInner', 'seats'),
          ticketsSold: BuiltValueNullFieldError.checkNotNull(ticketsSold,
              r'OperatorReportDtoOutputByRouteInner', 'ticketsSold'),
          grossRevenue: BuiltValueNullFieldError.checkNotNull(grossRevenue,
              r'OperatorReportDtoOutputByRouteInner', 'grossRevenue'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
