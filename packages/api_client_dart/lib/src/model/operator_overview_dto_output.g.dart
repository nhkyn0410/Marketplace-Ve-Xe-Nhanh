// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_overview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperatorOverviewDtoOutput extends OperatorOverviewDtoOutput {
  @override
  final OperatorOverviewDtoOutputToday today;
  @override
  final OperatorOverviewDtoOutputNextWeek nextWeek;
  @override
  final OperatorOverviewDtoOutputMonth month;
  @override
  final OperatorOverviewDtoOutputAttention attention;
  @override
  final BuiltList<OperatorOverviewDtoOutputUpcomingInner> upcoming;

  factory _$OperatorOverviewDtoOutput(
          [void Function(OperatorOverviewDtoOutputBuilder)? updates]) =>
      (OperatorOverviewDtoOutputBuilder()..update(updates))._build();

  _$OperatorOverviewDtoOutput._(
      {required this.today,
      required this.nextWeek,
      required this.month,
      required this.attention,
      required this.upcoming})
      : super._();
  @override
  OperatorOverviewDtoOutput rebuild(
          void Function(OperatorOverviewDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorOverviewDtoOutputBuilder toBuilder() =>
      OperatorOverviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorOverviewDtoOutput &&
        today == other.today &&
        nextWeek == other.nextWeek &&
        month == other.month &&
        attention == other.attention &&
        upcoming == other.upcoming;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, today.hashCode);
    _$hash = $jc(_$hash, nextWeek.hashCode);
    _$hash = $jc(_$hash, month.hashCode);
    _$hash = $jc(_$hash, attention.hashCode);
    _$hash = $jc(_$hash, upcoming.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperatorOverviewDtoOutput')
          ..add('today', today)
          ..add('nextWeek', nextWeek)
          ..add('month', month)
          ..add('attention', attention)
          ..add('upcoming', upcoming))
        .toString();
  }
}

class OperatorOverviewDtoOutputBuilder
    implements
        Builder<OperatorOverviewDtoOutput, OperatorOverviewDtoOutputBuilder> {
  _$OperatorOverviewDtoOutput? _$v;

  OperatorOverviewDtoOutputTodayBuilder? _today;
  OperatorOverviewDtoOutputTodayBuilder get today =>
      _$this._today ??= OperatorOverviewDtoOutputTodayBuilder();
  set today(OperatorOverviewDtoOutputTodayBuilder? today) =>
      _$this._today = today;

  OperatorOverviewDtoOutputNextWeekBuilder? _nextWeek;
  OperatorOverviewDtoOutputNextWeekBuilder get nextWeek =>
      _$this._nextWeek ??= OperatorOverviewDtoOutputNextWeekBuilder();
  set nextWeek(OperatorOverviewDtoOutputNextWeekBuilder? nextWeek) =>
      _$this._nextWeek = nextWeek;

  OperatorOverviewDtoOutputMonthBuilder? _month;
  OperatorOverviewDtoOutputMonthBuilder get month =>
      _$this._month ??= OperatorOverviewDtoOutputMonthBuilder();
  set month(OperatorOverviewDtoOutputMonthBuilder? month) =>
      _$this._month = month;

  OperatorOverviewDtoOutputAttentionBuilder? _attention;
  OperatorOverviewDtoOutputAttentionBuilder get attention =>
      _$this._attention ??= OperatorOverviewDtoOutputAttentionBuilder();
  set attention(OperatorOverviewDtoOutputAttentionBuilder? attention) =>
      _$this._attention = attention;

  ListBuilder<OperatorOverviewDtoOutputUpcomingInner>? _upcoming;
  ListBuilder<OperatorOverviewDtoOutputUpcomingInner> get upcoming =>
      _$this._upcoming ??=
          ListBuilder<OperatorOverviewDtoOutputUpcomingInner>();
  set upcoming(ListBuilder<OperatorOverviewDtoOutputUpcomingInner>? upcoming) =>
      _$this._upcoming = upcoming;

  OperatorOverviewDtoOutputBuilder() {
    OperatorOverviewDtoOutput._defaults(this);
  }

  OperatorOverviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _today = $v.today.toBuilder();
      _nextWeek = $v.nextWeek.toBuilder();
      _month = $v.month.toBuilder();
      _attention = $v.attention.toBuilder();
      _upcoming = $v.upcoming.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorOverviewDtoOutput other) {
    _$v = other as _$OperatorOverviewDtoOutput;
  }

  @override
  void update(void Function(OperatorOverviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorOverviewDtoOutput build() => _build();

  _$OperatorOverviewDtoOutput _build() {
    _$OperatorOverviewDtoOutput _$result;
    try {
      _$result = _$v ??
          _$OperatorOverviewDtoOutput._(
            today: today.build(),
            nextWeek: nextWeek.build(),
            month: month.build(),
            attention: attention.build(),
            upcoming: upcoming.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'today';
        today.build();
        _$failedField = 'nextWeek';
        nextWeek.build();
        _$failedField = 'month';
        month.build();
        _$failedField = 'attention';
        attention.build();
        _$failedField = 'upcoming';
        upcoming.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OperatorOverviewDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
