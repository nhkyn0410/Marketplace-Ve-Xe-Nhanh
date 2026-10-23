// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ArticleDtoOutput extends ArticleDtoOutput {
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
  @override
  final String contentMarkdown;
  @override
  final DateTime updatedAt;

  factory _$ArticleDtoOutput(
          [void Function(ArticleDtoOutputBuilder)? updates]) =>
      (ArticleDtoOutputBuilder()..update(updates))._build();

  _$ArticleDtoOutput._(
      {required this.title,
      required this.slug,
      required this.summary,
      this.coverImageUrl,
      required this.featured,
      required this.category,
      required this.publishedAt,
      required this.contentMarkdown,
      required this.updatedAt})
      : super._();
  @override
  ArticleDtoOutput rebuild(void Function(ArticleDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ArticleDtoOutputBuilder toBuilder() =>
      ArticleDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArticleDtoOutput &&
        title == other.title &&
        slug == other.slug &&
        summary == other.summary &&
        coverImageUrl == other.coverImageUrl &&
        featured == other.featured &&
        category == other.category &&
        publishedAt == other.publishedAt &&
        contentMarkdown == other.contentMarkdown &&
        updatedAt == other.updatedAt;
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
    _$hash = $jc(_$hash, contentMarkdown.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ArticleDtoOutput')
          ..add('title', title)
          ..add('slug', slug)
          ..add('summary', summary)
          ..add('coverImageUrl', coverImageUrl)
          ..add('featured', featured)
          ..add('category', category)
          ..add('publishedAt', publishedAt)
          ..add('contentMarkdown', contentMarkdown)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ArticleDtoOutputBuilder
    implements Builder<ArticleDtoOutput, ArticleDtoOutputBuilder> {
  _$ArticleDtoOutput? _$v;

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

  String? _contentMarkdown;
  String? get contentMarkdown => _$this._contentMarkdown;
  set contentMarkdown(String? contentMarkdown) =>
      _$this._contentMarkdown = contentMarkdown;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ArticleDtoOutputBuilder() {
    ArticleDtoOutput._defaults(this);
  }

  ArticleDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _slug = $v.slug;
      _summary = $v.summary;
      _coverImageUrl = $v.coverImageUrl;
      _featured = $v.featured;
      _category = $v.category.toBuilder();
      _publishedAt = $v.publishedAt;
      _contentMarkdown = $v.contentMarkdown;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArticleDtoOutput other) {
    _$v = other as _$ArticleDtoOutput;
  }

  @override
  void update(void Function(ArticleDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ArticleDtoOutput build() => _build();

  _$ArticleDtoOutput _build() {
    _$ArticleDtoOutput _$result;
    try {
      _$result = _$v ??
          _$ArticleDtoOutput._(
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'ArticleDtoOutput', 'title'),
            slug: BuiltValueNullFieldError.checkNotNull(
                slug, r'ArticleDtoOutput', 'slug'),
            summary: BuiltValueNullFieldError.checkNotNull(
                summary, r'ArticleDtoOutput', 'summary'),
            coverImageUrl: coverImageUrl,
            featured: BuiltValueNullFieldError.checkNotNull(
                featured, r'ArticleDtoOutput', 'featured'),
            category: category.build(),
            publishedAt: BuiltValueNullFieldError.checkNotNull(
                publishedAt, r'ArticleDtoOutput', 'publishedAt'),
            contentMarkdown: BuiltValueNullFieldError.checkNotNull(
                contentMarkdown, r'ArticleDtoOutput', 'contentMarkdown'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'ArticleDtoOutput', 'updatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'category';
        category.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ArticleDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
