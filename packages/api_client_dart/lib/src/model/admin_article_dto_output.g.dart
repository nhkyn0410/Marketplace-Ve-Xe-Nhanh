// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_article_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminArticleDtoOutputStatusEnum _$adminArticleDtoOutputStatusEnum_DRAFT =
    const AdminArticleDtoOutputStatusEnum._('DRAFT');
const AdminArticleDtoOutputStatusEnum
    _$adminArticleDtoOutputStatusEnum_PUBLISHED =
    const AdminArticleDtoOutputStatusEnum._('PUBLISHED');
const AdminArticleDtoOutputStatusEnum
    _$adminArticleDtoOutputStatusEnum_ARCHIVED =
    const AdminArticleDtoOutputStatusEnum._('ARCHIVED');

AdminArticleDtoOutputStatusEnum _$adminArticleDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'DRAFT':
      return _$adminArticleDtoOutputStatusEnum_DRAFT;
    case 'PUBLISHED':
      return _$adminArticleDtoOutputStatusEnum_PUBLISHED;
    case 'ARCHIVED':
      return _$adminArticleDtoOutputStatusEnum_ARCHIVED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminArticleDtoOutputStatusEnum>
    _$adminArticleDtoOutputStatusEnumValues = BuiltSet<
        AdminArticleDtoOutputStatusEnum>(const <AdminArticleDtoOutputStatusEnum>[
  _$adminArticleDtoOutputStatusEnum_DRAFT,
  _$adminArticleDtoOutputStatusEnum_PUBLISHED,
  _$adminArticleDtoOutputStatusEnum_ARCHIVED,
]);

Serializer<AdminArticleDtoOutputStatusEnum>
    _$adminArticleDtoOutputStatusEnumSerializer =
    _$AdminArticleDtoOutputStatusEnumSerializer();

class _$AdminArticleDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminArticleDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'PUBLISHED': 'PUBLISHED',
    'ARCHIVED': 'ARCHIVED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'PUBLISHED': 'PUBLISHED',
    'ARCHIVED': 'ARCHIVED',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminArticleDtoOutputStatusEnum];
  @override
  final String wireName = 'AdminArticleDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AdminArticleDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminArticleDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminArticleDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminArticleDtoOutput extends AdminArticleDtoOutput {
  @override
  final String id;
  @override
  final String title;
  @override
  final String slug;
  @override
  final String summary;
  @override
  final String categoryId;
  @override
  final String categoryName;
  @override
  final String? coverImageKey;
  @override
  final String? coverImageUrl;
  @override
  final bool featured;
  @override
  final AdminArticleDtoOutputStatusEnum status;
  @override
  final DateTime? publishedAt;
  @override
  final int viewCount;
  @override
  final DateTime updatedAt;
  @override
  final String contentMarkdown;
  @override
  final DateTime createdAt;
  @override
  final String? updatedByName;

  factory _$AdminArticleDtoOutput(
          [void Function(AdminArticleDtoOutputBuilder)? updates]) =>
      (AdminArticleDtoOutputBuilder()..update(updates))._build();

  _$AdminArticleDtoOutput._(
      {required this.id,
      required this.title,
      required this.slug,
      required this.summary,
      required this.categoryId,
      required this.categoryName,
      this.coverImageKey,
      this.coverImageUrl,
      required this.featured,
      required this.status,
      this.publishedAt,
      required this.viewCount,
      required this.updatedAt,
      required this.contentMarkdown,
      required this.createdAt,
      this.updatedByName})
      : super._();
  @override
  AdminArticleDtoOutput rebuild(
          void Function(AdminArticleDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminArticleDtoOutputBuilder toBuilder() =>
      AdminArticleDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminArticleDtoOutput &&
        id == other.id &&
        title == other.title &&
        slug == other.slug &&
        summary == other.summary &&
        categoryId == other.categoryId &&
        categoryName == other.categoryName &&
        coverImageKey == other.coverImageKey &&
        coverImageUrl == other.coverImageUrl &&
        featured == other.featured &&
        status == other.status &&
        publishedAt == other.publishedAt &&
        viewCount == other.viewCount &&
        updatedAt == other.updatedAt &&
        contentMarkdown == other.contentMarkdown &&
        createdAt == other.createdAt &&
        updatedByName == other.updatedByName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, categoryName.hashCode);
    _$hash = $jc(_$hash, coverImageKey.hashCode);
    _$hash = $jc(_$hash, coverImageUrl.hashCode);
    _$hash = $jc(_$hash, featured.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, publishedAt.hashCode);
    _$hash = $jc(_$hash, viewCount.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, contentMarkdown.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedByName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminArticleDtoOutput')
          ..add('id', id)
          ..add('title', title)
          ..add('slug', slug)
          ..add('summary', summary)
          ..add('categoryId', categoryId)
          ..add('categoryName', categoryName)
          ..add('coverImageKey', coverImageKey)
          ..add('coverImageUrl', coverImageUrl)
          ..add('featured', featured)
          ..add('status', status)
          ..add('publishedAt', publishedAt)
          ..add('viewCount', viewCount)
          ..add('updatedAt', updatedAt)
          ..add('contentMarkdown', contentMarkdown)
          ..add('createdAt', createdAt)
          ..add('updatedByName', updatedByName))
        .toString();
  }
}

class AdminArticleDtoOutputBuilder
    implements Builder<AdminArticleDtoOutput, AdminArticleDtoOutputBuilder> {
  _$AdminArticleDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _summary;
  String? get summary => _$this._summary;
  set summary(String? summary) => _$this._summary = summary;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _categoryName;
  String? get categoryName => _$this._categoryName;
  set categoryName(String? categoryName) => _$this._categoryName = categoryName;

  String? _coverImageKey;
  String? get coverImageKey => _$this._coverImageKey;
  set coverImageKey(String? coverImageKey) =>
      _$this._coverImageKey = coverImageKey;

  String? _coverImageUrl;
  String? get coverImageUrl => _$this._coverImageUrl;
  set coverImageUrl(String? coverImageUrl) =>
      _$this._coverImageUrl = coverImageUrl;

  bool? _featured;
  bool? get featured => _$this._featured;
  set featured(bool? featured) => _$this._featured = featured;

  AdminArticleDtoOutputStatusEnum? _status;
  AdminArticleDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminArticleDtoOutputStatusEnum? status) =>
      _$this._status = status;

  DateTime? _publishedAt;
  DateTime? get publishedAt => _$this._publishedAt;
  set publishedAt(DateTime? publishedAt) => _$this._publishedAt = publishedAt;

  int? _viewCount;
  int? get viewCount => _$this._viewCount;
  set viewCount(int? viewCount) => _$this._viewCount = viewCount;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _contentMarkdown;
  String? get contentMarkdown => _$this._contentMarkdown;
  set contentMarkdown(String? contentMarkdown) =>
      _$this._contentMarkdown = contentMarkdown;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _updatedByName;
  String? get updatedByName => _$this._updatedByName;
  set updatedByName(String? updatedByName) =>
      _$this._updatedByName = updatedByName;

  AdminArticleDtoOutputBuilder() {
    AdminArticleDtoOutput._defaults(this);
  }

  AdminArticleDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _slug = $v.slug;
      _summary = $v.summary;
      _categoryId = $v.categoryId;
      _categoryName = $v.categoryName;
      _coverImageKey = $v.coverImageKey;
      _coverImageUrl = $v.coverImageUrl;
      _featured = $v.featured;
      _status = $v.status;
      _publishedAt = $v.publishedAt;
      _viewCount = $v.viewCount;
      _updatedAt = $v.updatedAt;
      _contentMarkdown = $v.contentMarkdown;
      _createdAt = $v.createdAt;
      _updatedByName = $v.updatedByName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminArticleDtoOutput other) {
    _$v = other as _$AdminArticleDtoOutput;
  }

  @override
  void update(void Function(AdminArticleDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminArticleDtoOutput build() => _build();

  _$AdminArticleDtoOutput _build() {
    final _$result = _$v ??
        _$AdminArticleDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminArticleDtoOutput', 'id'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'AdminArticleDtoOutput', 'title'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'AdminArticleDtoOutput', 'slug'),
          summary: BuiltValueNullFieldError.checkNotNull(
              summary, r'AdminArticleDtoOutput', 'summary'),
          categoryId: BuiltValueNullFieldError.checkNotNull(
              categoryId, r'AdminArticleDtoOutput', 'categoryId'),
          categoryName: BuiltValueNullFieldError.checkNotNull(
              categoryName, r'AdminArticleDtoOutput', 'categoryName'),
          coverImageKey: coverImageKey,
          coverImageUrl: coverImageUrl,
          featured: BuiltValueNullFieldError.checkNotNull(
              featured, r'AdminArticleDtoOutput', 'featured'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminArticleDtoOutput', 'status'),
          publishedAt: publishedAt,
          viewCount: BuiltValueNullFieldError.checkNotNull(
              viewCount, r'AdminArticleDtoOutput', 'viewCount'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'AdminArticleDtoOutput', 'updatedAt'),
          contentMarkdown: BuiltValueNullFieldError.checkNotNull(
              contentMarkdown, r'AdminArticleDtoOutput', 'contentMarkdown'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminArticleDtoOutput', 'createdAt'),
          updatedByName: updatedByName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
