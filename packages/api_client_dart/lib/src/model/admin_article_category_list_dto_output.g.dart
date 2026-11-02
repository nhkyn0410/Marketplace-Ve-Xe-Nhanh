// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_article_category_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminArticleCategoryListDtoOutput
    extends AdminArticleCategoryListDtoOutput {
  @override
  final BuiltList<AdminArticleCategoryListDtoOutputItemsInner> items;

  factory _$AdminArticleCategoryListDtoOutput(
          [void Function(AdminArticleCategoryListDtoOutputBuilder)? updates]) =>
      (AdminArticleCategoryListDtoOutputBuilder()..update(updates))._build();

  _$AdminArticleCategoryListDtoOutput._({required this.items}) : super._();
  @override
  AdminArticleCategoryListDtoOutput rebuild(
          void Function(AdminArticleCategoryListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminArticleCategoryListDtoOutputBuilder toBuilder() =>
      AdminArticleCategoryListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminArticleCategoryListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'AdminArticleCategoryListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class AdminArticleCategoryListDtoOutputBuilder
    implements
        Builder<AdminArticleCategoryListDtoOutput,
            AdminArticleCategoryListDtoOutputBuilder> {
  _$AdminArticleCategoryListDtoOutput? _$v;

  ListBuilder<AdminArticleCategoryListDtoOutputItemsInner>? _items;
  ListBuilder<AdminArticleCategoryListDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<AdminArticleCategoryListDtoOutputItemsInner>();
  set items(ListBuilder<AdminArticleCategoryListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  AdminArticleCategoryListDtoOutputBuilder() {
    AdminArticleCategoryListDtoOutput._defaults(this);
  }

  AdminArticleCategoryListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminArticleCategoryListDtoOutput other) {
    _$v = other as _$AdminArticleCategoryListDtoOutput;
  }

  @override
  void update(
      void Function(AdminArticleCategoryListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminArticleCategoryListDtoOutput build() => _build();

  _$AdminArticleCategoryListDtoOutput _build() {
    _$AdminArticleCategoryListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminArticleCategoryListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminArticleCategoryListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
