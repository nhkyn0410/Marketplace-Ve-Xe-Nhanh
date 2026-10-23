// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_category_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ArticleCategoryListDtoOutput extends ArticleCategoryListDtoOutput {
  @override
  final BuiltList<ArticleCategoryListDtoOutputItemsInner> items;

  factory _$ArticleCategoryListDtoOutput(
          [void Function(ArticleCategoryListDtoOutputBuilder)? updates]) =>
      (ArticleCategoryListDtoOutputBuilder()..update(updates))._build();

  _$ArticleCategoryListDtoOutput._({required this.items}) : super._();
  @override
  ArticleCategoryListDtoOutput rebuild(
          void Function(ArticleCategoryListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ArticleCategoryListDtoOutputBuilder toBuilder() =>
      ArticleCategoryListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArticleCategoryListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'ArticleCategoryListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class ArticleCategoryListDtoOutputBuilder
    implements
        Builder<ArticleCategoryListDtoOutput,
            ArticleCategoryListDtoOutputBuilder> {
  _$ArticleCategoryListDtoOutput? _$v;

  ListBuilder<ArticleCategoryListDtoOutputItemsInner>? _items;
  ListBuilder<ArticleCategoryListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<ArticleCategoryListDtoOutputItemsInner>();
  set items(ListBuilder<ArticleCategoryListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  ArticleCategoryListDtoOutputBuilder() {
    ArticleCategoryListDtoOutput._defaults(this);
  }

  ArticleCategoryListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArticleCategoryListDtoOutput other) {
    _$v = other as _$ArticleCategoryListDtoOutput;
  }

  @override
  void update(void Function(ArticleCategoryListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ArticleCategoryListDtoOutput build() => _build();

  _$ArticleCategoryListDtoOutput _build() {
    _$ArticleCategoryListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$ArticleCategoryListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ArticleCategoryListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
