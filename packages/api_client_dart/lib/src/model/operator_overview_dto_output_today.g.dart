// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_overview_dto_output_today.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperatorOverviewDtoOutputToday extends OperatorOverviewDtoOutputToday {
  @override
  final int trips;
  @override
  final int running;
  @override
  final int ticketsSold;
  @override
  final int seats;

  factory _$OperatorOverviewDtoOutputToday(
          [void Function(OperatorOverviewDtoOutputTodayBuilder)? updates]) =>
      (OperatorOverviewDtoOutputTodayBuilder()..update(updates))._build();

  _$OperatorOverviewDtoOutputToday._(
      {required this.trips,
      required this.running,
      required this.ticketsSold,
      required this.seats})
      : super._();
  @override
  OperatorOverviewDtoOutputToday rebuild(
          void Function(OperatorOverviewDtoOutputTodayBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorOverviewDtoOutputTodayBuilder toBuilder() =>
      OperatorOverviewDtoOutputTodayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorOverviewDtoOutputToday &&
        trips == other.trips &&
        running == other.running &&
        ticketsSold == other.ticketsSold &&
        seats == other.seats;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, trips.hashCode);
    _$hash = $jc(_$hash, running.hashCode);
    _$hash = $jc(_$hash, ticketsSold.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperatorOverviewDtoOutputToday')
          ..add('trips', trips)
          ..add('running', running)
          ..add('ticketsSold', ticketsSold)
          ..add('seats', seats))
        .toString();
  }
}

class OperatorOverviewDtoOutputTodayBuilder
    implements
        Builder<OperatorOverviewDtoOutputToday,
            OperatorOverviewDtoOutputTodayBuilder> {
  _$OperatorOverviewDtoOutputToday? _$v;

  int? _trips;
  int? get trips => _$this._trips;
  set trips(int? trips) => _$this._trips = trips;

  int? _running;
  int? get running => _$this._running;
  set running(int? running) => _$this._running = running;

  int? _ticketsSold;
  int? get ticketsSold => _$this._ticketsSold;
  set ticketsSold(int? ticketsSold) => _$this._ticketsSold = ticketsSold;

  int? _seats;
  int? get seats => _$this._seats;
  set seats(int? seats) => _$this._seats = seats;

  OperatorOverviewDtoOutputTodayBuilder() {
    OperatorOverviewDtoOutputToday._defaults(this);
  }

  OperatorOverviewDtoOutputTodayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _trips = $v.trips;
      _running = $v.running;
      _ticketsSold = $v.ticketsSold;
      _seats = $v.seats;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorOverviewDtoOutputToday other) {
    _$v = other as _$OperatorOverviewDtoOutputToday;
  }

  @override
  void update(void Function(OperatorOverviewDtoOutputTodayBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorOverviewDtoOutputToday build() => _build();

  _$OperatorOverviewDtoOutputToday _build() {
    final _$result = _$v ??
        _$OperatorOverviewDtoOutputToday._(
          trips: BuiltValueNullFieldError.checkNotNull(
              trips, r'OperatorOverviewDtoOutputToday', 'trips'),
          running: BuiltValueNullFieldError.checkNotNull(
              running, r'OperatorOverviewDtoOutputToday', 'running'),
          ticketsSold: BuiltValueNullFieldError.checkNotNull(
              ticketsSold, r'OperatorOverviewDtoOutputToday', 'ticketsSold'),
          seats: BuiltValueNullFieldError.checkNotNull(
              seats, r'OperatorOverviewDtoOutputToday', 'seats'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
