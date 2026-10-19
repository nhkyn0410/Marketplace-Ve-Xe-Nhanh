// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_transaction_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoyaltyTransactionPageDtoOutput
    extends LoyaltyTransactionPageDtoOutput {
  @override
  final BuiltList<LoyaltyTransactionPageDtoOutputItemsInner> items;
  @override
  final int total;

  factory _$LoyaltyTransactionPageDtoOutput(
          [void Function(LoyaltyTransactionPageDtoOutputBuilder)? updates]) =>
      (LoyaltyTransactionPageDtoOutputBuilder()..update(updates))._build();

  _$LoyaltyTransactionPageDtoOutput._(
      {required this.items, required this.total})
      : super._();
  @override
  LoyaltyTransactionPageDtoOutput rebuild(
          void Function(LoyaltyTransactionPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoyaltyTransactionPageDtoOutputBuilder toBuilder() =>
      LoyaltyTransactionPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoyaltyTransactionPageDtoOutput &&
        items == other.items &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoyaltyTransactionPageDtoOutput')
          ..add('items', items)
          ..add('total', total))
        .toString();
  }
}

class LoyaltyTransactionPageDtoOutputBuilder
    implements
        Builder<LoyaltyTransactionPageDtoOutput,
            LoyaltyTransactionPageDtoOutputBuilder> {
  _$LoyaltyTransactionPageDtoOutput? _$v;

  ListBuilder<LoyaltyTransactionPageDtoOutputItemsInner>? _items;
  ListBuilder<LoyaltyTransactionPageDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<LoyaltyTransactionPageDtoOutputItemsInner>();
  set items(ListBuilder<LoyaltyTransactionPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  LoyaltyTransactionPageDtoOutputBuilder() {
    LoyaltyTransactionPageDtoOutput._defaults(this);
  }

  LoyaltyTransactionPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoyaltyTransactionPageDtoOutput other) {
    _$v = other as _$LoyaltyTransactionPageDtoOutput;
  }

  @override
  void update(void Function(LoyaltyTransactionPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoyaltyTransactionPageDtoOutput build() => _build();

  _$LoyaltyTransactionPageDtoOutput _build() {
    _$LoyaltyTransactionPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$LoyaltyTransactionPageDtoOutput._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'LoyaltyTransactionPageDtoOutput', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LoyaltyTransactionPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
