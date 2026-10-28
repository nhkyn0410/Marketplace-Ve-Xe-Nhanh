// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_commission_overview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterCommissionOverviewDtoOutput
    extends CounterCommissionOverviewDtoOutput {
  @override
  final String operatorId;
  @override
  final String accrued;
  @override
  final String settled;
  @override
  final String outstanding;
  @override
  final BuiltList<CounterCommissionOverviewDtoOutputItemsInner> items;
  @override
  final BuiltList<CounterCommissionOverviewDtoOutputSettlementsInner>
      settlements;

  factory _$CounterCommissionOverviewDtoOutput(
          [void Function(CounterCommissionOverviewDtoOutputBuilder)?
              updates]) =>
      (CounterCommissionOverviewDtoOutputBuilder()..update(updates))._build();

  _$CounterCommissionOverviewDtoOutput._(
      {required this.operatorId,
      required this.accrued,
      required this.settled,
      required this.outstanding,
      required this.items,
      required this.settlements})
      : super._();
  @override
  CounterCommissionOverviewDtoOutput rebuild(
          void Function(CounterCommissionOverviewDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterCommissionOverviewDtoOutputBuilder toBuilder() =>
      CounterCommissionOverviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterCommissionOverviewDtoOutput &&
        operatorId == other.operatorId &&
        accrued == other.accrued &&
        settled == other.settled &&
        outstanding == other.outstanding &&
        items == other.items &&
        settlements == other.settlements;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, accrued.hashCode);
    _$hash = $jc(_$hash, settled.hashCode);
    _$hash = $jc(_$hash, outstanding.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, settlements.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CounterCommissionOverviewDtoOutput')
          ..add('operatorId', operatorId)
          ..add('accrued', accrued)
          ..add('settled', settled)
          ..add('outstanding', outstanding)
          ..add('items', items)
          ..add('settlements', settlements))
        .toString();
  }
}

class CounterCommissionOverviewDtoOutputBuilder
    implements
        Builder<CounterCommissionOverviewDtoOutput,
            CounterCommissionOverviewDtoOutputBuilder> {
  _$CounterCommissionOverviewDtoOutput? _$v;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _accrued;
  String? get accrued => _$this._accrued;
  set accrued(String? accrued) => _$this._accrued = accrued;

  String? _settled;
  String? get settled => _$this._settled;
  set settled(String? settled) => _$this._settled = settled;

  String? _outstanding;
  String? get outstanding => _$this._outstanding;
  set outstanding(String? outstanding) => _$this._outstanding = outstanding;

  ListBuilder<CounterCommissionOverviewDtoOutputItemsInner>? _items;
  ListBuilder<CounterCommissionOverviewDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<CounterCommissionOverviewDtoOutputItemsInner>();
  set items(ListBuilder<CounterCommissionOverviewDtoOutputItemsInner>? items) =>
      _$this._items = items;

  ListBuilder<CounterCommissionOverviewDtoOutputSettlementsInner>? _settlements;
  ListBuilder<CounterCommissionOverviewDtoOutputSettlementsInner>
      get settlements => _$this._settlements ??=
          ListBuilder<CounterCommissionOverviewDtoOutputSettlementsInner>();
  set settlements(
          ListBuilder<CounterCommissionOverviewDtoOutputSettlementsInner>?
              settlements) =>
      _$this._settlements = settlements;

  CounterCommissionOverviewDtoOutputBuilder() {
    CounterCommissionOverviewDtoOutput._defaults(this);
  }

  CounterCommissionOverviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operatorId = $v.operatorId;
      _accrued = $v.accrued;
      _settled = $v.settled;
      _outstanding = $v.outstanding;
      _items = $v.items.toBuilder();
      _settlements = $v.settlements.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterCommissionOverviewDtoOutput other) {
    _$v = other as _$CounterCommissionOverviewDtoOutput;
  }

  @override
  void update(
      void Function(CounterCommissionOverviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterCommissionOverviewDtoOutput build() => _build();

  _$CounterCommissionOverviewDtoOutput _build() {
    _$CounterCommissionOverviewDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CounterCommissionOverviewDtoOutput._(
            operatorId: BuiltValueNullFieldError.checkNotNull(operatorId,
                r'CounterCommissionOverviewDtoOutput', 'operatorId'),
            accrued: BuiltValueNullFieldError.checkNotNull(
                accrued, r'CounterCommissionOverviewDtoOutput', 'accrued'),
            settled: BuiltValueNullFieldError.checkNotNull(
                settled, r'CounterCommissionOverviewDtoOutput', 'settled'),
            outstanding: BuiltValueNullFieldError.checkNotNull(outstanding,
                r'CounterCommissionOverviewDtoOutput', 'outstanding'),
            items: items.build(),
            settlements: settlements.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
        _$failedField = 'settlements';
        settlements.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CounterCommissionOverviewDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
