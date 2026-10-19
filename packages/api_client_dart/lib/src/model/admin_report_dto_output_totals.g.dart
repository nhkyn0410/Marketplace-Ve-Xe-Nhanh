// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_dto_output_totals.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReportDtoOutputTotals extends AdminReportDtoOutputTotals {
  @override
  final int gmv;
  @override
  final int bookings;
  @override
  final int tickets;
  @override
  final int netRevenue;
  @override
  final int reconcileOpen;
  @override
  final int trips;
  @override
  final int completedTrips;
  @override
  final int seats;
  @override
  final int ticketsSold;
  @override
  final int operatorCancelledTrips;
  @override
  final int tripsWithSales;

  factory _$AdminReportDtoOutputTotals(
          [void Function(AdminReportDtoOutputTotalsBuilder)? updates]) =>
      (AdminReportDtoOutputTotalsBuilder()..update(updates))._build();

  _$AdminReportDtoOutputTotals._(
      {required this.gmv,
      required this.bookings,
      required this.tickets,
      required this.netRevenue,
      required this.reconcileOpen,
      required this.trips,
      required this.completedTrips,
      required this.seats,
      required this.ticketsSold,
      required this.operatorCancelledTrips,
      required this.tripsWithSales})
      : super._();
  @override
  AdminReportDtoOutputTotals rebuild(
          void Function(AdminReportDtoOutputTotalsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminReportDtoOutputTotalsBuilder toBuilder() =>
      AdminReportDtoOutputTotalsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReportDtoOutputTotals &&
        gmv == other.gmv &&
        bookings == other.bookings &&
        tickets == other.tickets &&
        netRevenue == other.netRevenue &&
        reconcileOpen == other.reconcileOpen &&
        trips == other.trips &&
        completedTrips == other.completedTrips &&
        seats == other.seats &&
        ticketsSold == other.ticketsSold &&
        operatorCancelledTrips == other.operatorCancelledTrips &&
        tripsWithSales == other.tripsWithSales;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, gmv.hashCode);
    _$hash = $jc(_$hash, bookings.hashCode);
    _$hash = $jc(_$hash, tickets.hashCode);
    _$hash = $jc(_$hash, netRevenue.hashCode);
    _$hash = $jc(_$hash, reconcileOpen.hashCode);
    _$hash = $jc(_$hash, trips.hashCode);
    _$hash = $jc(_$hash, completedTrips.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jc(_$hash, ticketsSold.hashCode);
    _$hash = $jc(_$hash, operatorCancelledTrips.hashCode);
    _$hash = $jc(_$hash, tripsWithSales.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReportDtoOutputTotals')
          ..add('gmv', gmv)
          ..add('bookings', bookings)
          ..add('tickets', tickets)
          ..add('netRevenue', netRevenue)
          ..add('reconcileOpen', reconcileOpen)
          ..add('trips', trips)
          ..add('completedTrips', completedTrips)
          ..add('seats', seats)
          ..add('ticketsSold', ticketsSold)
          ..add('operatorCancelledTrips', operatorCancelledTrips)
          ..add('tripsWithSales', tripsWithSales))
        .toString();
  }
}

class AdminReportDtoOutputTotalsBuilder
    implements
        Builder<AdminReportDtoOutputTotals, AdminReportDtoOutputTotalsBuilder> {
  _$AdminReportDtoOutputTotals? _$v;

  int? _gmv;
  int? get gmv => _$this._gmv;
  set gmv(int? gmv) => _$this._gmv = gmv;

  int? _bookings;
  int? get bookings => _$this._bookings;
  set bookings(int? bookings) => _$this._bookings = bookings;

  int? _tickets;
  int? get tickets => _$this._tickets;
  set tickets(int? tickets) => _$this._tickets = tickets;

  int? _netRevenue;
  int? get netRevenue => _$this._netRevenue;
  set netRevenue(int? netRevenue) => _$this._netRevenue = netRevenue;

  int? _reconcileOpen;
  int? get reconcileOpen => _$this._reconcileOpen;
  set reconcileOpen(int? reconcileOpen) =>
      _$this._reconcileOpen = reconcileOpen;

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

  int? _operatorCancelledTrips;
  int? get operatorCancelledTrips => _$this._operatorCancelledTrips;
  set operatorCancelledTrips(int? operatorCancelledTrips) =>
      _$this._operatorCancelledTrips = operatorCancelledTrips;

  int? _tripsWithSales;
  int? get tripsWithSales => _$this._tripsWithSales;
  set tripsWithSales(int? tripsWithSales) =>
      _$this._tripsWithSales = tripsWithSales;

  AdminReportDtoOutputTotalsBuilder() {
    AdminReportDtoOutputTotals._defaults(this);
  }

  AdminReportDtoOutputTotalsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _gmv = $v.gmv;
      _bookings = $v.bookings;
      _tickets = $v.tickets;
      _netRevenue = $v.netRevenue;
      _reconcileOpen = $v.reconcileOpen;
      _trips = $v.trips;
      _completedTrips = $v.completedTrips;
      _seats = $v.seats;
      _ticketsSold = $v.ticketsSold;
      _operatorCancelledTrips = $v.operatorCancelledTrips;
      _tripsWithSales = $v.tripsWithSales;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReportDtoOutputTotals other) {
    _$v = other as _$AdminReportDtoOutputTotals;
  }

  @override
  void update(void Function(AdminReportDtoOutputTotalsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReportDtoOutputTotals build() => _build();

  _$AdminReportDtoOutputTotals _build() {
    final _$result = _$v ??
        _$AdminReportDtoOutputTotals._(
          gmv: BuiltValueNullFieldError.checkNotNull(
              gmv, r'AdminReportDtoOutputTotals', 'gmv'),
          bookings: BuiltValueNullFieldError.checkNotNull(
              bookings, r'AdminReportDtoOutputTotals', 'bookings'),
          tickets: BuiltValueNullFieldError.checkNotNull(
              tickets, r'AdminReportDtoOutputTotals', 'tickets'),
          netRevenue: BuiltValueNullFieldError.checkNotNull(
              netRevenue, r'AdminReportDtoOutputTotals', 'netRevenue'),
          reconcileOpen: BuiltValueNullFieldError.checkNotNull(
              reconcileOpen, r'AdminReportDtoOutputTotals', 'reconcileOpen'),
          trips: BuiltValueNullFieldError.checkNotNull(
              trips, r'AdminReportDtoOutputTotals', 'trips'),
          completedTrips: BuiltValueNullFieldError.checkNotNull(
              completedTrips, r'AdminReportDtoOutputTotals', 'completedTrips'),
          seats: BuiltValueNullFieldError.checkNotNull(
              seats, r'AdminReportDtoOutputTotals', 'seats'),
          ticketsSold: BuiltValueNullFieldError.checkNotNull(
              ticketsSold, r'AdminReportDtoOutputTotals', 'ticketsSold'),
          operatorCancelledTrips: BuiltValueNullFieldError.checkNotNull(
              operatorCancelledTrips,
              r'AdminReportDtoOutputTotals',
              'operatorCancelledTrips'),
          tripsWithSales: BuiltValueNullFieldError.checkNotNull(
              tripsWithSales, r'AdminReportDtoOutputTotals', 'tripsWithSales'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
