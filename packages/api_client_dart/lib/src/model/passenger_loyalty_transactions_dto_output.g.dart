// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_loyalty_transactions_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerLoyaltyTransactionsDtoOutput
    extends PassengerLoyaltyTransactionsDtoOutput {
  @override
  final BuiltList<PassengerLoyaltyTransactionsDtoOutputItemsInner> items;
  @override
  final int total;
  @override
  final PassengerLoyaltyTransactionsDtoOutputTotals totals;

  factory _$PassengerLoyaltyTransactionsDtoOutput(
          [void Function(PassengerLoyaltyTransactionsDtoOutputBuilder)?
              updates]) =>
      (PassengerLoyaltyTransactionsDtoOutputBuilder()..update(updates))
          ._build();

  _$PassengerLoyaltyTransactionsDtoOutput._(
      {required this.items, required this.total, required this.totals})
      : super._();
  @override
  PassengerLoyaltyTransactionsDtoOutput rebuild(
          void Function(PassengerLoyaltyTransactionsDtoOutputBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerLoyaltyTransactionsDtoOutputBuilder toBuilder() =>
      PassengerLoyaltyTransactionsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerLoyaltyTransactionsDtoOutput &&
        items == other.items &&
        total == other.total &&
        totals == other.totals;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, totals.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PassengerLoyaltyTransactionsDtoOutput')
          ..add('items', items)
          ..add('total', total)
          ..add('totals', totals))
        .toString();
  }
}

class PassengerLoyaltyTransactionsDtoOutputBuilder
    implements
        Builder<PassengerLoyaltyTransactionsDtoOutput,
            PassengerLoyaltyTransactionsDtoOutputBuilder> {
  _$PassengerLoyaltyTransactionsDtoOutput? _$v;

  ListBuilder<PassengerLoyaltyTransactionsDtoOutputItemsInner>? _items;
  ListBuilder<PassengerLoyaltyTransactionsDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<PassengerLoyaltyTransactionsDtoOutputItemsInner>();
  set items(
          ListBuilder<PassengerLoyaltyTransactionsDtoOutputItemsInner>?
              items) =>
      _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  PassengerLoyaltyTransactionsDtoOutputTotalsBuilder? _totals;
  PassengerLoyaltyTransactionsDtoOutputTotalsBuilder get totals =>
      _$this._totals ??= PassengerLoyaltyTransactionsDtoOutputTotalsBuilder();
  set totals(PassengerLoyaltyTransactionsDtoOutputTotalsBuilder? totals) =>
      _$this._totals = totals;

  PassengerLoyaltyTransactionsDtoOutputBuilder() {
    PassengerLoyaltyTransactionsDtoOutput._defaults(this);
  }

  PassengerLoyaltyTransactionsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _totals = $v.totals.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PassengerLoyaltyTransactionsDtoOutput other) {
    _$v = other as _$PassengerLoyaltyTransactionsDtoOutput;
  }

  @override
  void update(
      void Function(PassengerLoyaltyTransactionsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerLoyaltyTransactionsDtoOutput build() => _build();

  _$PassengerLoyaltyTransactionsDtoOutput _build() {
    _$PassengerLoyaltyTransactionsDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PassengerLoyaltyTransactionsDtoOutput._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'PassengerLoyaltyTransactionsDtoOutput', 'total'),
            totals: totals.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();

        _$failedField = 'totals';
        totals.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PassengerLoyaltyTransactionsDtoOutput',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
