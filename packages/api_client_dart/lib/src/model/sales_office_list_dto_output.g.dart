// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_office_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SalesOfficeListDtoOutput extends SalesOfficeListDtoOutput {
  @override
  final BuiltList<SalesOfficeListDtoOutputItemsInner> items;

  factory _$SalesOfficeListDtoOutput(
          [void Function(SalesOfficeListDtoOutputBuilder)? updates]) =>
      (SalesOfficeListDtoOutputBuilder()..update(updates))._build();

  _$SalesOfficeListDtoOutput._({required this.items}) : super._();
  @override
  SalesOfficeListDtoOutput rebuild(
          void Function(SalesOfficeListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SalesOfficeListDtoOutputBuilder toBuilder() =>
      SalesOfficeListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalesOfficeListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'SalesOfficeListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class SalesOfficeListDtoOutputBuilder
    implements
        Builder<SalesOfficeListDtoOutput, SalesOfficeListDtoOutputBuilder> {
  _$SalesOfficeListDtoOutput? _$v;

  ListBuilder<SalesOfficeListDtoOutputItemsInner>? _items;
  ListBuilder<SalesOfficeListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<SalesOfficeListDtoOutputItemsInner>();
  set items(ListBuilder<SalesOfficeListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  SalesOfficeListDtoOutputBuilder() {
    SalesOfficeListDtoOutput._defaults(this);
  }

  SalesOfficeListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalesOfficeListDtoOutput other) {
    _$v = other as _$SalesOfficeListDtoOutput;
  }

  @override
  void update(void Function(SalesOfficeListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalesOfficeListDtoOutput build() => _build();

  _$SalesOfficeListDtoOutput _build() {
    _$SalesOfficeListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$SalesOfficeListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SalesOfficeListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
