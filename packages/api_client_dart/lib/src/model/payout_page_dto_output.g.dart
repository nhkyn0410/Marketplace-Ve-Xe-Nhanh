// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PayoutPageDtoOutput extends PayoutPageDtoOutput {
  @override
  final BuiltList<PayoutPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;

  factory _$PayoutPageDtoOutput(
          [void Function(PayoutPageDtoOutputBuilder)? updates]) =>
      (PayoutPageDtoOutputBuilder()..update(updates))._build();

  _$PayoutPageDtoOutput._({required this.items, this.nextCursor}) : super._();
  @override
  PayoutPageDtoOutput rebuild(
          void Function(PayoutPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PayoutPageDtoOutputBuilder toBuilder() =>
      PayoutPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutPageDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PayoutPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class PayoutPageDtoOutputBuilder
    implements Builder<PayoutPageDtoOutput, PayoutPageDtoOutputBuilder> {
  _$PayoutPageDtoOutput? _$v;

  ListBuilder<PayoutPageDtoOutputItemsInner>? _items;
  ListBuilder<PayoutPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<PayoutPageDtoOutputItemsInner>();
  set items(ListBuilder<PayoutPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  PayoutPageDtoOutputBuilder() {
    PayoutPageDtoOutput._defaults(this);
  }

  PayoutPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutPageDtoOutput other) {
    _$v = other as _$PayoutPageDtoOutput;
  }

  @override
  void update(void Function(PayoutPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutPageDtoOutput build() => _build();

  _$PayoutPageDtoOutput _build() {
    _$PayoutPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PayoutPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PayoutPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
