// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_page_dto_output_items_inner_category.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ArticlePageDtoOutputItemsInnerCategory
    extends ArticlePageDtoOutputItemsInnerCategory {
  @override
  final String name;
  @override
  final String slug;

  factory _$ArticlePageDtoOutputItemsInnerCategory(
          [void Function(ArticlePageDtoOutputItemsInnerCategoryBuilder)?
              updates]) =>
      (ArticlePageDtoOutputItemsInnerCategoryBuilder()..update(updates))
          ._build();

  _$ArticlePageDtoOutputItemsInnerCategory._(
      {required this.name, required this.slug})
      : super._();
  @override
  ArticlePageDtoOutputItemsInnerCategory rebuild(
          void Function(ArticlePageDtoOutputItemsInnerCategoryBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ArticlePageDtoOutputItemsInnerCategoryBuilder toBuilder() =>
      ArticlePageDtoOutputItemsInnerCategoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArticlePageDtoOutputItemsInnerCategory &&
        name == other.name &&
        slug == other.slug;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ArticlePageDtoOutputItemsInnerCategory')
          ..add('name', name)
          ..add('slug', slug))
        .toString();
  }
}

class ArticlePageDtoOutputItemsInnerCategoryBuilder
    implements
        Builder<ArticlePageDtoOutputItemsInnerCategory,
            ArticlePageDtoOutputItemsInnerCategoryBuilder> {
  _$ArticlePageDtoOutputItemsInnerCategory? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  ArticlePageDtoOutputItemsInnerCategoryBuilder() {
    ArticlePageDtoOutputItemsInnerCategory._defaults(this);
  }

  ArticlePageDtoOutputItemsInnerCategoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _slug = $v.slug;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArticlePageDtoOutputItemsInnerCategory other) {
    _$v = other as _$ArticlePageDtoOutputItemsInnerCategory;
  }

  @override
  void update(
      void Function(ArticlePageDtoOutputItemsInnerCategoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ArticlePageDtoOutputItemsInnerCategory build() => _build();

  _$ArticlePageDtoOutputItemsInnerCategory _build() {
    final _$result = _$v ??
        _$ArticlePageDtoOutputItemsInnerCategory._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ArticlePageDtoOutputItemsInnerCategory', 'name'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'ArticlePageDtoOutputItemsInnerCategory', 'slug'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
