// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_article_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminArticleInputDto extends AdminArticleInputDto {
  @override
  final String title;
  @override
  final String slug;
  @override
  final String summary;
  @override
  final String contentMarkdown;
  @override
  final String categoryId;
  @override
  final String? coverImageKey;
  @override
  final bool featured;

  factory _$AdminArticleInputDto(
          [void Function(AdminArticleInputDtoBuilder)? updates]) =>
      (AdminArticleInputDtoBuilder()..update(updates))._build();

  _$AdminArticleInputDto._(
      {required this.title,
      required this.slug,
      required this.summary,
      required this.contentMarkdown,
      required this.categoryId,
      this.coverImageKey,
      required this.featured})
      : super._();
  @override
  AdminArticleInputDto rebuild(
          void Function(AdminArticleInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminArticleInputDtoBuilder toBuilder() =>
      AdminArticleInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminArticleInputDto &&
        title == other.title &&
        slug == other.slug &&
        summary == other.summary &&
        contentMarkdown == other.contentMarkdown &&
        categoryId == other.categoryId &&
        coverImageKey == other.coverImageKey &&
        featured == other.featured;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, contentMarkdown.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, coverImageKey.hashCode);
    _$hash = $jc(_$hash, featured.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminArticleInputDto')
          ..add('title', title)
          ..add('slug', slug)
          ..add('summary', summary)
          ..add('contentMarkdown', contentMarkdown)
          ..add('categoryId', categoryId)
          ..add('coverImageKey', coverImageKey)
          ..add('featured', featured))
        .toString();
  }
}

class AdminArticleInputDtoBuilder
    implements Builder<AdminArticleInputDto, AdminArticleInputDtoBuilder> {
  _$AdminArticleInputDto? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _summary;
  String? get summary => _$this._summary;
  set summary(String? summary) => _$this._summary = summary;

  String? _contentMarkdown;
  String? get contentMarkdown => _$this._contentMarkdown;
  set contentMarkdown(String? contentMarkdown) =>
      _$this._contentMarkdown = contentMarkdown;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _coverImageKey;
  String? get coverImageKey => _$this._coverImageKey;
  set coverImageKey(String? coverImageKey) =>
      _$this._coverImageKey = coverImageKey;

  bool? _featured;
  bool? get featured => _$this._featured;
  set featured(bool? featured) => _$this._featured = featured;

  AdminArticleInputDtoBuilder() {
    AdminArticleInputDto._defaults(this);
  }

  AdminArticleInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _slug = $v.slug;
      _summary = $v.summary;
      _contentMarkdown = $v.contentMarkdown;
      _categoryId = $v.categoryId;
      _coverImageKey = $v.coverImageKey;
      _featured = $v.featured;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminArticleInputDto other) {
    _$v = other as _$AdminArticleInputDto;
  }

  @override
  void update(void Function(AdminArticleInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminArticleInputDto build() => _build();

  _$AdminArticleInputDto _build() {
    final _$result = _$v ??
        _$AdminArticleInputDto._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'AdminArticleInputDto', 'title'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'AdminArticleInputDto', 'slug'),
          summary: BuiltValueNullFieldError.checkNotNull(
              summary, r'AdminArticleInputDto', 'summary'),
          contentMarkdown: BuiltValueNullFieldError.checkNotNull(
              contentMarkdown, r'AdminArticleInputDto', 'contentMarkdown'),
          categoryId: BuiltValueNullFieldError.checkNotNull(
              categoryId, r'AdminArticleInputDto', 'categoryId'),
          coverImageKey: coverImageKey,
          featured: BuiltValueNullFieldError.checkNotNull(
              featured, r'AdminArticleInputDto', 'featured'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
