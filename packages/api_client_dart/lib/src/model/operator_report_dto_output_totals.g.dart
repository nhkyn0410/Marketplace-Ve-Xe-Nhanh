// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_report_dto_output_totals.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperatorReportDtoOutputTotals extends OperatorReportDtoOutputTotals {
  @override
  final int grossRevenue;
  @override
  final int trips;
  @override
  final int completedTrips;
  @override
  final int ticketsSold;
  @override
  final int bookings;
  @override
  final int seats;
  @override
  final int cancelledTickets;
  @override
  final int refundedTickets;

  factory _$OperatorReportDtoOutputTotals(
          [void Function(OperatorReportDtoOutputTotalsBuilder)? updates]) =>
      (OperatorReportDtoOutputTotalsBuilder()..update(updates))._build();

  _$OperatorReportDtoOutputTotals._(
      {required this.grossRevenue,
      required this.trips,
      required this.completedTrips,
      required this.ticketsSold,
      required this.bookings,
      required this.seats,
      required this.cancelledTickets,
      required this.refundedTickets})
      : super._();
  @override
  OperatorReportDtoOutputTotals rebuild(
          void Function(OperatorReportDtoOutputTotalsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorReportDtoOutputTotalsBuilder toBuilder() =>
      OperatorReportDtoOutputTotalsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorReportDtoOutputTotals &&
        grossRevenue == other.grossRevenue &&
        trips == other.trips &&
        completedTrips == other.completedTrips &&
        ticketsSold == other.ticketsSold &&
        bookings == other.bookings &&
        seats == other.seats &&
        cancelledTickets == other.cancelledTickets &&
        refundedTickets == other.refundedTickets;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, grossRevenue.hashCode);
    _$hash = $jc(_$hash, trips.hashCode);
    _$hash = $jc(_$hash, completedTrips.hashCode);
    _$hash = $jc(_$hash, ticketsSold.hashCode);
    _$hash = $jc(_$hash, bookings.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jc(_$hash, cancelledTickets.hashCode);
    _$hash = $jc(_$hash, refundedTickets.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperatorReportDtoOutputTotals')
          ..add('grossRevenue', grossRevenue)
          ..add('trips', trips)
          ..add('completedTrips', completedTrips)
          ..add('ticketsSold', ticketsSold)
          ..add('bookings', bookings)
          ..add('seats', seats)
          ..add('cancelledTickets', cancelledTickets)
          ..add('refundedTickets', refundedTickets))
        .toString();
  }
}

class OperatorReportDtoOutputTotalsBuilder
    implements
        Builder<OperatorReportDtoOutputTotals,
            OperatorReportDtoOutputTotalsBuilder> {
  _$OperatorReportDtoOutputTotals? _$v;

  int? _grossRevenue;
  int? get grossRevenue => _$this._grossRevenue;
  set grossRevenue(int? grossRevenue) => _$this._grossRevenue = grossRevenue;

  int? _trips;
  int? get trips => _$this._trips;
  set trips(int? trips) => _$this._trips = trips;

  int? _completedTrips;
  int? get completedTrips => _$this._completedTrips;
  set completedTrips(int? completedTrips) =>
      _$this._completedTrips = completedTrips;

  int? _ticketsSold;
  int? get ticketsSold => _$this._ticketsSold;
  set ticketsSold(int? ticketsSold) => _$this._ticketsSold = ticketsSold;

  int? _bookings;
  int? get bookings => _$this._bookings;
  set bookings(int? bookings) => _$this._bookings = bookings;

  int? _seats;
  int? get seats => _$this._seats;
  set seats(int? seats) => _$this._seats = seats;

  int? _cancelledTickets;
  int? get cancelledTickets => _$this._cancelledTickets;
  set cancelledTickets(int? cancelledTickets) =>
      _$this._cancelledTickets = cancelledTickets;

  int? _refundedTickets;
  int? get refundedTickets => _$this._refundedTickets;
  set refundedTickets(int? refundedTickets) =>
      _$this._refundedTickets = refundedTickets;

  OperatorReportDtoOutputTotalsBuilder() {
    OperatorReportDtoOutputTotals._defaults(this);
  }

  OperatorReportDtoOutputTotalsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _grossRevenue = $v.grossRevenue;
      _trips = $v.trips;
      _completedTrips = $v.completedTrips;
      _ticketsSold = $v.ticketsSold;
      _bookings = $v.bookings;
      _seats = $v.seats;
      _cancelledTickets = $v.cancelledTickets;
      _refundedTickets = $v.refundedTickets;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorReportDtoOutputTotals other) {
    _$v = other as _$OperatorReportDtoOutputTotals;
  }

  @override
  void update(void Function(OperatorReportDtoOutputTotalsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorReportDtoOutputTotals build() => _build();

  _$OperatorReportDtoOutputTotals _build() {
    final _$result = _$v ??
        _$OperatorReportDtoOutputTotals._(
          grossRevenue: BuiltValueNullFieldError.checkNotNull(
              grossRevenue, r'OperatorReportDtoOutputTotals', 'grossRevenue'),
          trips: BuiltValueNullFieldError.checkNotNull(
              trips, r'OperatorReportDtoOutputTotals', 'trips'),
          completedTrips: BuiltValueNullFieldError.checkNotNull(completedTrips,
              r'OperatorReportDtoOutputTotals', 'completedTrips'),
          ticketsSold: BuiltValueNullFieldError.checkNotNull(
              ticketsSold, r'OperatorReportDtoOutputTotals', 'ticketsSold'),
          bookings: BuiltValueNullFieldError.checkNotNull(
              bookings, r'OperatorReportDtoOutputTotals', 'bookings'),
          seats: BuiltValueNullFieldError.checkNotNull(
              seats, r'OperatorReportDtoOutputTotals', 'seats'),
          cancelledTickets: BuiltValueNullFieldError.checkNotNull(
              cancelledTickets,
              r'OperatorReportDtoOutputTotals',
              'cancelledTickets'),
          refundedTickets: BuiltValueNullFieldError.checkNotNull(
              refundedTickets,
              r'OperatorReportDtoOutputTotals',
              'refundedTickets'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
