// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ManagerListDtoOutput extends ManagerListDtoOutput {
  @override
  final BuiltList<ManagerListDtoOutputItemsInner> items;

  factory _$ManagerListDtoOutput(
          [void Function(ManagerListDtoOutputBuilder)? updates]) =>
      (ManagerListDtoOutputBuilder()..update(updates))._build();

  _$ManagerListDtoOutput._({required this.items}) : super._();
  @override
  ManagerListDtoOutput rebuild(
          void Function(ManagerListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ManagerListDtoOutputBuilder toBuilder() =>
      ManagerListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ManagerListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'ManagerListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class ManagerListDtoOutputBuilder
    implements Builder<ManagerListDtoOutput, ManagerListDtoOutputBuilder> {
  _$ManagerListDtoOutput? _$v;

  ListBuilder<ManagerListDtoOutputItemsInner>? _items;
  ListBuilder<ManagerListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<ManagerListDtoOutputItemsInner>();
  set items(ListBuilder<ManagerListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  ManagerListDtoOutputBuilder() {
    ManagerListDtoOutput._defaults(this);
  }

  ManagerListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ManagerListDtoOutput other) {
    _$v = other as _$ManagerListDtoOutput;
  }

  @override
  void update(void Function(ManagerListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ManagerListDtoOutput build() => _build();

  _$ManagerListDtoOutput _build() {
    _$ManagerListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$ManagerListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ManagerListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
