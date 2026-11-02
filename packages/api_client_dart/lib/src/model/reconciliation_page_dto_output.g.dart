// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconciliation_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReconciliationPageDtoOutput extends ReconciliationPageDtoOutput {
  @override
  final BuiltList<ReconciliationPageDtoOutputItemsInner> items;

  factory _$ReconciliationPageDtoOutput(
          [void Function(ReconciliationPageDtoOutputBuilder)? updates]) =>
      (ReconciliationPageDtoOutputBuilder()..update(updates))._build();

  _$ReconciliationPageDtoOutput._({required this.items}) : super._();
  @override
  ReconciliationPageDtoOutput rebuild(
          void Function(ReconciliationPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReconciliationPageDtoOutputBuilder toBuilder() =>
      ReconciliationPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReconciliationPageDtoOutput && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReconciliationPageDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class ReconciliationPageDtoOutputBuilder
    implements
        Builder<ReconciliationPageDtoOutput,
            ReconciliationPageDtoOutputBuilder> {
  _$ReconciliationPageDtoOutput? _$v;

  ListBuilder<ReconciliationPageDtoOutputItemsInner>? _items;
  ListBuilder<ReconciliationPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<ReconciliationPageDtoOutputItemsInner>();
  set items(ListBuilder<ReconciliationPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  ReconciliationPageDtoOutputBuilder() {
    ReconciliationPageDtoOutput._defaults(this);
  }

  ReconciliationPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReconciliationPageDtoOutput other) {
    _$v = other as _$ReconciliationPageDtoOutput;
  }

  @override
  void update(void Function(ReconciliationPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReconciliationPageDtoOutput build() => _build();

  _$ReconciliationPageDtoOutput _build() {
    _$ReconciliationPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$ReconciliationPageDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ReconciliationPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
