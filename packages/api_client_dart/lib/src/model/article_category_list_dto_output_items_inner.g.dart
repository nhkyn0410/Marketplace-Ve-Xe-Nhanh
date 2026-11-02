// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_category_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ArticleCategoryListDtoOutputItemsInner
    extends ArticleCategoryListDtoOutputItemsInner {
  @override
  final String name;
  @override
  final String slug;
  @override
  final int articleCount;

  factory _$ArticleCategoryListDtoOutputItemsInner(
          [void Function(ArticleCategoryListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (ArticleCategoryListDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$ArticleCategoryListDtoOutputItemsInner._(
      {required this.name, required this.slug, required this.articleCount})
      : super._();
  @override
  ArticleCategoryListDtoOutputItemsInner rebuild(
          void Function(ArticleCategoryListDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ArticleCategoryListDtoOutputItemsInnerBuilder toBuilder() =>
      ArticleCategoryListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArticleCategoryListDtoOutputItemsInner &&
        name == other.name &&
        slug == other.slug &&
        articleCount == other.articleCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, articleCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ArticleCategoryListDtoOutputItemsInner')
          ..add('name', name)
          ..add('slug', slug)
          ..add('articleCount', articleCount))
        .toString();
  }
}

class ArticleCategoryListDtoOutputItemsInnerBuilder
    implements
        Builder<ArticleCategoryListDtoOutputItemsInner,
            ArticleCategoryListDtoOutputItemsInnerBuilder> {
  _$ArticleCategoryListDtoOutputItemsInner? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  int? _articleCount;
  int? get articleCount => _$this._articleCount;
  set articleCount(int? articleCount) => _$this._articleCount = articleCount;

  ArticleCategoryListDtoOutputItemsInnerBuilder() {
    ArticleCategoryListDtoOutputItemsInner._defaults(this);
  }

  ArticleCategoryListDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _slug = $v.slug;
      _articleCount = $v.articleCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArticleCategoryListDtoOutputItemsInner other) {
    _$v = other as _$ArticleCategoryListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(ArticleCategoryListDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ArticleCategoryListDtoOutputItemsInner build() => _build();

  _$ArticleCategoryListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$ArticleCategoryListDtoOutputItemsInner._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ArticleCategoryListDtoOutputItemsInner', 'name'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'ArticleCategoryListDtoOutputItemsInner', 'slug'),
          articleCount: BuiltValueNullFieldError.checkNotNull(articleCount,
              r'ArticleCategoryListDtoOutputItemsInner', 'articleCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
