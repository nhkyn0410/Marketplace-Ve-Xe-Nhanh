// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_options_dto_output_articles_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CampaignOptionsDtoOutputArticlesInner
    extends CampaignOptionsDtoOutputArticlesInner {
  @override
  final String id;
  @override
  final String title;
  @override
  final String slug;
  @override
  final DateTime? publishedAt;

  factory _$CampaignOptionsDtoOutputArticlesInner(
          [void Function(CampaignOptionsDtoOutputArticlesInnerBuilder)?
              updates]) =>
      (CampaignOptionsDtoOutputArticlesInnerBuilder()..update(updates))
          ._build();

  _$CampaignOptionsDtoOutputArticlesInner._(
      {required this.id,
      required this.title,
      required this.slug,
      this.publishedAt})
      : super._();
  @override
  CampaignOptionsDtoOutputArticlesInner rebuild(
          void Function(CampaignOptionsDtoOutputArticlesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CampaignOptionsDtoOutputArticlesInnerBuilder toBuilder() =>
      CampaignOptionsDtoOutputArticlesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CampaignOptionsDtoOutputArticlesInner &&
        id == other.id &&
        title == other.title &&
        slug == other.slug &&
        publishedAt == other.publishedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, publishedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CampaignOptionsDtoOutputArticlesInner')
          ..add('id', id)
          ..add('title', title)
          ..add('slug', slug)
          ..add('publishedAt', publishedAt))
        .toString();
  }
}

class CampaignOptionsDtoOutputArticlesInnerBuilder
    implements
        Builder<CampaignOptionsDtoOutputArticlesInner,
            CampaignOptionsDtoOutputArticlesInnerBuilder> {
  _$CampaignOptionsDtoOutputArticlesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  DateTime? _publishedAt;
  DateTime? get publishedAt => _$this._publishedAt;
  set publishedAt(DateTime? publishedAt) => _$this._publishedAt = publishedAt;

  CampaignOptionsDtoOutputArticlesInnerBuilder() {
    CampaignOptionsDtoOutputArticlesInner._defaults(this);
  }

  CampaignOptionsDtoOutputArticlesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _slug = $v.slug;
      _publishedAt = $v.publishedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CampaignOptionsDtoOutputArticlesInner other) {
    _$v = other as _$CampaignOptionsDtoOutputArticlesInner;
  }

  @override
  void update(
      void Function(CampaignOptionsDtoOutputArticlesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CampaignOptionsDtoOutputArticlesInner build() => _build();

  _$CampaignOptionsDtoOutputArticlesInner _build() {
    final _$result = _$v ??
        _$CampaignOptionsDtoOutputArticlesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CampaignOptionsDtoOutputArticlesInner', 'id'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'CampaignOptionsDtoOutputArticlesInner', 'title'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'CampaignOptionsDtoOutputArticlesInner', 'slug'),
          publishedAt: publishedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
