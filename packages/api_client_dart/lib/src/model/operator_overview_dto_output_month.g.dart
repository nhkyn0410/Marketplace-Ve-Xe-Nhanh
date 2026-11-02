// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_overview_dto_output_month.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperatorOverviewDtoOutputMonth extends OperatorOverviewDtoOutputMonth {
  @override
  final int grossRevenue;
  @override
  final int ticketsSold;
  @override
  final int completedTrips;

  factory _$OperatorOverviewDtoOutputMonth(
          [void Function(OperatorOverviewDtoOutputMonthBuilder)? updates]) =>
      (OperatorOverviewDtoOutputMonthBuilder()..update(updates))._build();

  _$OperatorOverviewDtoOutputMonth._(
      {required this.grossRevenue,
      required this.ticketsSold,
      required this.completedTrips})
      : super._();
  @override
  OperatorOverviewDtoOutputMonth rebuild(
          void Function(OperatorOverviewDtoOutputMonthBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorOverviewDtoOutputMonthBuilder toBuilder() =>
      OperatorOverviewDtoOutputMonthBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorOverviewDtoOutputMonth &&
        grossRevenue == other.grossRevenue &&
        ticketsSold == other.ticketsSold &&
        completedTrips == other.completedTrips;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, grossRevenue.hashCode);
    _$hash = $jc(_$hash, ticketsSold.hashCode);
    _$hash = $jc(_$hash, completedTrips.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperatorOverviewDtoOutputMonth')
          ..add('grossRevenue', grossRevenue)
          ..add('ticketsSold', ticketsSold)
          ..add('completedTrips', completedTrips))
        .toString();
  }
}

class OperatorOverviewDtoOutputMonthBuilder
    implements
        Builder<OperatorOverviewDtoOutputMonth,
            OperatorOverviewDtoOutputMonthBuilder> {
  _$OperatorOverviewDtoOutputMonth? _$v;

  int? _grossRevenue;
  int? get grossRevenue => _$this._grossRevenue;
  set grossRevenue(int? grossRevenue) => _$this._grossRevenue = grossRevenue;

  int? _ticketsSold;
  int? get ticketsSold => _$this._ticketsSold;
  set ticketsSold(int? ticketsSold) => _$this._ticketsSold = ticketsSold;

  int? _completedTrips;
  int? get completedTrips => _$this._completedTrips;
  set completedTrips(int? completedTrips) =>
      _$this._completedTrips = completedTrips;

  OperatorOverviewDtoOutputMonthBuilder() {
    OperatorOverviewDtoOutputMonth._defaults(this);
  }

  OperatorOverviewDtoOutputMonthBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _grossRevenue = $v.grossRevenue;
      _ticketsSold = $v.ticketsSold;
      _completedTrips = $v.completedTrips;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorOverviewDtoOutputMonth other) {
    _$v = other as _$OperatorOverviewDtoOutputMonth;
  }

  @override
  void update(void Function(OperatorOverviewDtoOutputMonthBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorOverviewDtoOutputMonth build() => _build();

  _$OperatorOverviewDtoOutputMonth _build() {
    final _$result = _$v ??
        _$OperatorOverviewDtoOutputMonth._(
          grossRevenue: BuiltValueNullFieldError.checkNotNull(
              grossRevenue, r'OperatorOverviewDtoOutputMonth', 'grossRevenue'),
          ticketsSold: BuiltValueNullFieldError.checkNotNull(
              ticketsSold, r'OperatorOverviewDtoOutputMonth', 'ticketsSold'),
          completedTrips: BuiltValueNullFieldError.checkNotNull(completedTrips,
              r'OperatorOverviewDtoOutputMonth', 'completedTrips'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
