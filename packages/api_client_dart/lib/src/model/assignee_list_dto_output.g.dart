// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignee_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssigneeListDtoOutput extends AssigneeListDtoOutput {
  @override
  final BuiltList<AssigneeListDtoOutputItemsInner> items;

  factory _$AssigneeListDtoOutput(
          [void Function(AssigneeListDtoOutputBuilder)? updates]) =>
      (AssigneeListDtoOutputBuilder()..update(updates))._build();

  _$AssigneeListDtoOutput._({required this.items}) : super._();
  @override
  AssigneeListDtoOutput rebuild(
          void Function(AssigneeListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssigneeListDtoOutputBuilder toBuilder() =>
      AssigneeListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssigneeListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'AssigneeListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class AssigneeListDtoOutputBuilder
    implements Builder<AssigneeListDtoOutput, AssigneeListDtoOutputBuilder> {
  _$AssigneeListDtoOutput? _$v;

  ListBuilder<AssigneeListDtoOutputItemsInner>? _items;
  ListBuilder<AssigneeListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AssigneeListDtoOutputItemsInner>();
  set items(ListBuilder<AssigneeListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  AssigneeListDtoOutputBuilder() {
    AssigneeListDtoOutput._defaults(this);
  }

  AssigneeListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssigneeListDtoOutput other) {
    _$v = other as _$AssigneeListDtoOutput;
  }

  @override
  void update(void Function(AssigneeListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssigneeListDtoOutput build() => _build();

  _$AssigneeListDtoOutput _build() {
    _$AssigneeListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AssigneeListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AssigneeListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
