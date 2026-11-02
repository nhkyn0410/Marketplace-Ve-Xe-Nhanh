// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_operator_detail_dto_output_stats.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOperatorDetailDtoOutputStats
    extends AdminOperatorDetailDtoOutputStats {
  @override
  final Date from;
  @override
  final Date to;
  @override
  final int trips;
  @override
  final int completedTrips;
  @override
  final int cancelledTrips;
  @override
  final int seats;
  @override
  final int ticketsSold;
  @override
  final int? ticketRevenue;
  @override
  final int? refunded;
  @override
  final num? averageRating;
  @override
  final int reviewCount;

  factory _$AdminOperatorDetailDtoOutputStats(
          [void Function(AdminOperatorDetailDtoOutputStatsBuilder)? updates]) =>
      (AdminOperatorDetailDtoOutputStatsBuilder()..update(updates))._build();

  _$AdminOperatorDetailDtoOutputStats._(
      {required this.from,
      required this.to,
      required this.trips,
      required this.completedTrips,
      required this.cancelledTrips,
      required this.seats,
      required this.ticketsSold,
      this.ticketRevenue,
      this.refunded,
      this.averageRating,
      required this.reviewCount})
      : super._();
  @override
  AdminOperatorDetailDtoOutputStats rebuild(
          void Function(AdminOperatorDetailDtoOutputStatsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOperatorDetailDtoOutputStatsBuilder toBuilder() =>
      AdminOperatorDetailDtoOutputStatsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOperatorDetailDtoOutputStats &&
        from == other.from &&
        to == other.to &&
        trips == other.trips &&
        completedTrips == other.completedTrips &&
        cancelledTrips == other.cancelledTrips &&
        seats == other.seats &&
        ticketsSold == other.ticketsSold &&
        ticketRevenue == other.ticketRevenue &&
        refunded == other.refunded &&
        averageRating == other.averageRating &&
        reviewCount == other.reviewCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, trips.hashCode);
    _$hash = $jc(_$hash, completedTrips.hashCode);
    _$hash = $jc(_$hash, cancelledTrips.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jc(_$hash, ticketsSold.hashCode);
    _$hash = $jc(_$hash, ticketRevenue.hashCode);
    _$hash = $jc(_$hash, refunded.hashCode);
    _$hash = $jc(_$hash, averageRating.hashCode);
    _$hash = $jc(_$hash, reviewCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOperatorDetailDtoOutputStats')
          ..add('from', from)
          ..add('to', to)
          ..add('trips', trips)
          ..add('completedTrips', completedTrips)
          ..add('cancelledTrips', cancelledTrips)
          ..add('seats', seats)
          ..add('ticketsSold', ticketsSold)
          ..add('ticketRevenue', ticketRevenue)
          ..add('refunded', refunded)
          ..add('averageRating', averageRating)
          ..add('reviewCount', reviewCount))
        .toString();
  }
}

class AdminOperatorDetailDtoOutputStatsBuilder
    implements
        Builder<AdminOperatorDetailDtoOutputStats,
            AdminOperatorDetailDtoOutputStatsBuilder> {
  _$AdminOperatorDetailDtoOutputStats? _$v;

  Date? _from;
  Date? get from => _$this._from;
  set from(Date? from) => _$this._from = from;

  Date? _to;
  Date? get to => _$this._to;
  set to(Date? to) => _$this._to = to;

  int? _trips;
  int? get trips => _$this._trips;
  set trips(int? trips) => _$this._trips = trips;

  int? _completedTrips;
  int? get completedTrips => _$this._completedTrips;
  set completedTrips(int? completedTrips) =>
      _$this._completedTrips = completedTrips;

  int? _cancelledTrips;
  int? get cancelledTrips => _$this._cancelledTrips;
  set cancelledTrips(int? cancelledTrips) =>
      _$this._cancelledTrips = cancelledTrips;

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

  int? _refunded;
  int? get refunded => _$this._refunded;
  set refunded(int? refunded) => _$this._refunded = refunded;

  num? _averageRating;
  num? get averageRating => _$this._averageRating;
  set averageRating(num? averageRating) =>
      _$this._averageRating = averageRating;

  int? _reviewCount;
  int? get reviewCount => _$this._reviewCount;
  set reviewCount(int? reviewCount) => _$this._reviewCount = reviewCount;

  AdminOperatorDetailDtoOutputStatsBuilder() {
    AdminOperatorDetailDtoOutputStats._defaults(this);
  }

  AdminOperatorDetailDtoOutputStatsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _trips = $v.trips;
      _completedTrips = $v.completedTrips;
      _cancelledTrips = $v.cancelledTrips;
      _seats = $v.seats;
      _ticketsSold = $v.ticketsSold;
      _ticketRevenue = $v.ticketRevenue;
      _refunded = $v.refunded;
      _averageRating = $v.averageRating;
      _reviewCount = $v.reviewCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOperatorDetailDtoOutputStats other) {
    _$v = other as _$AdminOperatorDetailDtoOutputStats;
  }

  @override
  void update(
      void Function(AdminOperatorDetailDtoOutputStatsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOperatorDetailDtoOutputStats build() => _build();

  _$AdminOperatorDetailDtoOutputStats _build() {
    final _$result = _$v ??
        _$AdminOperatorDetailDtoOutputStats._(
          from: BuiltValueNullFieldError.checkNotNull(
              from, r'AdminOperatorDetailDtoOutputStats', 'from'),
          to: BuiltValueNullFieldError.checkNotNull(
              to, r'AdminOperatorDetailDtoOutputStats', 'to'),
          trips: BuiltValueNullFieldError.checkNotNull(
              trips, r'AdminOperatorDetailDtoOutputStats', 'trips'),
          completedTrips: BuiltValueNullFieldError.checkNotNull(completedTrips,
              r'AdminOperatorDetailDtoOutputStats', 'completedTrips'),
          cancelledTrips: BuiltValueNullFieldError.checkNotNull(cancelledTrips,
              r'AdminOperatorDetailDtoOutputStats', 'cancelledTrips'),
          seats: BuiltValueNullFieldError.checkNotNull(
              seats, r'AdminOperatorDetailDtoOutputStats', 'seats'),
          ticketsSold: BuiltValueNullFieldError.checkNotNull(
              ticketsSold, r'AdminOperatorDetailDtoOutputStats', 'ticketsSold'),
          ticketRevenue: ticketRevenue,
          refunded: refunded,
          averageRating: averageRating,
          reviewCount: BuiltValueNullFieldError.checkNotNull(
              reviewCount, r'AdminOperatorDetailDtoOutputStats', 'reviewCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
