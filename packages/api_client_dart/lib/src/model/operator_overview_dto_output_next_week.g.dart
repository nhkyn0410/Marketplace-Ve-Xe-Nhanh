// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_overview_dto_output_next_week.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperatorOverviewDtoOutputNextWeek
    extends OperatorOverviewDtoOutputNextWeek {
  @override
  final int trips;
  @override
  final int ticketsSold;
  @override
  final int seats;

  factory _$OperatorOverviewDtoOutputNextWeek(
          [void Function(OperatorOverviewDtoOutputNextWeekBuilder)? updates]) =>
      (OperatorOverviewDtoOutputNextWeekBuilder()..update(updates))._build();

  _$OperatorOverviewDtoOutputNextWeek._(
      {required this.trips, required this.ticketsSold, required this.seats})
      : super._();
  @override
  OperatorOverviewDtoOutputNextWeek rebuild(
          void Function(OperatorOverviewDtoOutputNextWeekBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorOverviewDtoOutputNextWeekBuilder toBuilder() =>
      OperatorOverviewDtoOutputNextWeekBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorOverviewDtoOutputNextWeek &&
        trips == other.trips &&
        ticketsSold == other.ticketsSold &&
        seats == other.seats;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, trips.hashCode);
    _$hash = $jc(_$hash, ticketsSold.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperatorOverviewDtoOutputNextWeek')
          ..add('trips', trips)
          ..add('ticketsSold', ticketsSold)
          ..add('seats', seats))
        .toString();
  }
}

class OperatorOverviewDtoOutputNextWeekBuilder
    implements
        Builder<OperatorOverviewDtoOutputNextWeek,
            OperatorOverviewDtoOutputNextWeekBuilder> {
  _$OperatorOverviewDtoOutputNextWeek? _$v;

  int? _trips;
  int? get trips => _$this._trips;
  set trips(int? trips) => _$this._trips = trips;

  int? _ticketsSold;
  int? get ticketsSold => _$this._ticketsSold;
  set ticketsSold(int? ticketsSold) => _$this._ticketsSold = ticketsSold;

  int? _seats;
  int? get seats => _$this._seats;
  set seats(int? seats) => _$this._seats = seats;

  OperatorOverviewDtoOutputNextWeekBuilder() {
    OperatorOverviewDtoOutputNextWeek._defaults(this);
  }

  OperatorOverviewDtoOutputNextWeekBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _trips = $v.trips;
      _ticketsSold = $v.ticketsSold;
      _seats = $v.seats;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorOverviewDtoOutputNextWeek other) {
    _$v = other as _$OperatorOverviewDtoOutputNextWeek;
  }

  @override
  void update(
      void Function(OperatorOverviewDtoOutputNextWeekBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorOverviewDtoOutputNextWeek build() => _build();

  _$OperatorOverviewDtoOutputNextWeek _build() {
    final _$result = _$v ??
        _$OperatorOverviewDtoOutputNextWeek._(
          trips: BuiltValueNullFieldError.checkNotNull(
              trips, r'OperatorOverviewDtoOutputNextWeek', 'trips'),
          ticketsSold: BuiltValueNullFieldError.checkNotNull(
              ticketsSold, r'OperatorOverviewDtoOutputNextWeek', 'ticketsSold'),
          seats: BuiltValueNullFieldError.checkNotNull(
              seats, r'OperatorOverviewDtoOutputNextWeek', 'seats'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
