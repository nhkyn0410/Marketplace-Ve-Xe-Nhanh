// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ArticlePageDtoOutputItemsInner extends ArticlePageDtoOutputItemsInner {
  @override
  final String title;
  @override
  final String slug;
  @override
  final String summary;
  @override
  final String? coverImageUrl;
  @override
  final bool featured;
  @override
  final ArticlePageDtoOutputItemsInnerCategory category;
  @override
  final DateTime publishedAt;

  factory _$ArticlePageDtoOutputItemsInner(
          [void Function(ArticlePageDtoOutputItemsInnerBuilder)? updates]) =>
      (ArticlePageDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$ArticlePageDtoOutputItemsInner._(
      {required this.title,
      required this.slug,
      required this.summary,
      this.coverImageUrl,
      required this.featured,
      required this.category,
      required this.publishedAt})
      : super._();
  @override
  ArticlePageDtoOutputItemsInner rebuild(
          void Function(ArticlePageDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ArticlePageDtoOutputItemsInnerBuilder toBuilder() =>
      ArticlePageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArticlePageDtoOutputItemsInner &&
        title == other.title &&
        slug == other.slug &&
        summary == other.summary &&
        coverImageUrl == other.coverImageUrl &&
        featured == other.featured &&
        category == other.category &&
        publishedAt == other.publishedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, coverImageUrl.hashCode);
    _$hash = $jc(_$hash, featured.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, publishedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ArticlePageDtoOutputItemsInner')
          ..add('title', title)
          ..add('slug', slug)
          ..add('summary', summary)
          ..add('coverImageUrl', coverImageUrl)
          ..add('featured', featured)
          ..add('category', category)
          ..add('publishedAt', publishedAt))
        .toString();
  }
}

class ArticlePageDtoOutputItemsInnerBuilder
    implements
        Builder<ArticlePageDtoOutputItemsInner,
            ArticlePageDtoOutputItemsInnerBuilder> {
  _$ArticlePageDtoOutputItemsInner? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _summary;
  String? get summary => _$this._summary;
  set summary(String? summary) => _$this._summary = summary;

  String? _coverImageUrl;
  String? get coverImageUrl => _$this._coverImageUrl;
  set coverImageUrl(String? coverImageUrl) =>
      _$this._coverImageUrl = coverImageUrl;

  bool? _featured;
  bool? get featured => _$this._featured;
  set featured(bool? featured) => _$this._featured = featured;

  ArticlePageDtoOutputItemsInnerCategoryBuilder? _category;
  ArticlePageDtoOutputItemsInnerCategoryBuilder get category =>
      _$this._category ??= ArticlePageDtoOutputItemsInnerCategoryBuilder();
  set category(ArticlePageDtoOutputItemsInnerCategoryBuilder? category) =>
      _$this._category = category;

  DateTime? _publishedAt;
  DateTime? get publishedAt => _$this._publishedAt;
  set publishedAt(DateTime? publishedAt) => _$this._publishedAt = publishedAt;

  ArticlePageDtoOutputItemsInnerBuilder() {
    ArticlePageDtoOutputItemsInner._defaults(this);
  }

  ArticlePageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _slug = $v.slug;
      _summary = $v.summary;
      _coverImageUrl = $v.coverImageUrl;
      _featured = $v.featured;
      _category = $v.category.toBuilder();
      _publishedAt = $v.publishedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArticlePageDtoOutputItemsInner other) {
    _$v = other as _$ArticlePageDtoOutputItemsInner;
  }

  @override
  void update(void Function(ArticlePageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ArticlePageDtoOutputItemsInner build() => _build();

  _$ArticlePageDtoOutputItemsInner _build() {
    _$ArticlePageDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$ArticlePageDtoOutputItemsInner._(
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'ArticlePageDtoOutputItemsInner', 'title'),
            slug: BuiltValueNullFieldError.checkNotNull(
                slug, r'ArticlePageDtoOutputItemsInner', 'slug'),
            summary: BuiltValueNullFieldError.checkNotNull(
                summary, r'ArticlePageDtoOutputItemsInner', 'summary'),
            coverImageUrl: coverImageUrl,
            featured: BuiltValueNullFieldError.checkNotNull(
                featured, r'ArticlePageDtoOutputItemsInner', 'featured'),
            category: category.build(),
            publishedAt: BuiltValueNullFieldError.checkNotNull(
                publishedAt, r'ArticlePageDtoOutputItemsInner', 'publishedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'category';
        category.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ArticlePageDtoOutputItemsInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
