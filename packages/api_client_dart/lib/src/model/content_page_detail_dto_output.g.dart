// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_page_detail_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ContentPageDetailDtoOutputTypeEnum
    _$contentPageDetailDtoOutputTypeEnum_FAQ =
    const ContentPageDetailDtoOutputTypeEnum._('FAQ');
const ContentPageDetailDtoOutputTypeEnum
    _$contentPageDetailDtoOutputTypeEnum_BANNER =
    const ContentPageDetailDtoOutputTypeEnum._('BANNER');
const ContentPageDetailDtoOutputTypeEnum
    _$contentPageDetailDtoOutputTypeEnum_PAGE =
    const ContentPageDetailDtoOutputTypeEnum._('PAGE');

ContentPageDetailDtoOutputTypeEnum _$contentPageDetailDtoOutputTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'FAQ':
      return _$contentPageDetailDtoOutputTypeEnum_FAQ;
    case 'BANNER':
      return _$contentPageDetailDtoOutputTypeEnum_BANNER;
    case 'PAGE':
      return _$contentPageDetailDtoOutputTypeEnum_PAGE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ContentPageDetailDtoOutputTypeEnum>
    _$contentPageDetailDtoOutputTypeEnumValues = BuiltSet<
        ContentPageDetailDtoOutputTypeEnum>(const <ContentPageDetailDtoOutputTypeEnum>[
  _$contentPageDetailDtoOutputTypeEnum_FAQ,
  _$contentPageDetailDtoOutputTypeEnum_BANNER,
  _$contentPageDetailDtoOutputTypeEnum_PAGE,
]);

const ContentPageDetailDtoOutputPlacementEnum
    _$contentPageDetailDtoOutputPlacementEnum_HOME =
    const ContentPageDetailDtoOutputPlacementEnum._('HOME');
const ContentPageDetailDtoOutputPlacementEnum
    _$contentPageDetailDtoOutputPlacementEnum_FOOTER =
    const ContentPageDetailDtoOutputPlacementEnum._('FOOTER');
const ContentPageDetailDtoOutputPlacementEnum
    _$contentPageDetailDtoOutputPlacementEnum_BOOKING =
    const ContentPageDetailDtoOutputPlacementEnum._('BOOKING');
const ContentPageDetailDtoOutputPlacementEnum
    _$contentPageDetailDtoOutputPlacementEnum_TICKET =
    const ContentPageDetailDtoOutputPlacementEnum._('TICKET');
const ContentPageDetailDtoOutputPlacementEnum
    _$contentPageDetailDtoOutputPlacementEnum_ACCOUNT =
    const ContentPageDetailDtoOutputPlacementEnum._('ACCOUNT');

ContentPageDetailDtoOutputPlacementEnum
    _$contentPageDetailDtoOutputPlacementEnumValueOf(String name) {
  switch (name) {
    case 'HOME':
      return _$contentPageDetailDtoOutputPlacementEnum_HOME;
    case 'FOOTER':
      return _$contentPageDetailDtoOutputPlacementEnum_FOOTER;
    case 'BOOKING':
      return _$contentPageDetailDtoOutputPlacementEnum_BOOKING;
    case 'TICKET':
      return _$contentPageDetailDtoOutputPlacementEnum_TICKET;
    case 'ACCOUNT':
      return _$contentPageDetailDtoOutputPlacementEnum_ACCOUNT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ContentPageDetailDtoOutputPlacementEnum>
    _$contentPageDetailDtoOutputPlacementEnumValues = BuiltSet<
        ContentPageDetailDtoOutputPlacementEnum>(const <ContentPageDetailDtoOutputPlacementEnum>[
  _$contentPageDetailDtoOutputPlacementEnum_HOME,
  _$contentPageDetailDtoOutputPlacementEnum_FOOTER,
  _$contentPageDetailDtoOutputPlacementEnum_BOOKING,
  _$contentPageDetailDtoOutputPlacementEnum_TICKET,
  _$contentPageDetailDtoOutputPlacementEnum_ACCOUNT,
]);

const ContentPageDetailDtoOutputStatusEnum
    _$contentPageDetailDtoOutputStatusEnum_DRAFT =
    const ContentPageDetailDtoOutputStatusEnum._('DRAFT');
const ContentPageDetailDtoOutputStatusEnum
    _$contentPageDetailDtoOutputStatusEnum_PUBLISHED =
    const ContentPageDetailDtoOutputStatusEnum._('PUBLISHED');

ContentPageDetailDtoOutputStatusEnum
    _$contentPageDetailDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$contentPageDetailDtoOutputStatusEnum_DRAFT;
    case 'PUBLISHED':
      return _$contentPageDetailDtoOutputStatusEnum_PUBLISHED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ContentPageDetailDtoOutputStatusEnum>
    _$contentPageDetailDtoOutputStatusEnumValues = BuiltSet<
        ContentPageDetailDtoOutputStatusEnum>(const <ContentPageDetailDtoOutputStatusEnum>[
  _$contentPageDetailDtoOutputStatusEnum_DRAFT,
  _$contentPageDetailDtoOutputStatusEnum_PUBLISHED,
]);

Serializer<ContentPageDetailDtoOutputTypeEnum>
    _$contentPageDetailDtoOutputTypeEnumSerializer =
    _$ContentPageDetailDtoOutputTypeEnumSerializer();
Serializer<ContentPageDetailDtoOutputPlacementEnum>
    _$contentPageDetailDtoOutputPlacementEnumSerializer =
    _$ContentPageDetailDtoOutputPlacementEnumSerializer();
Serializer<ContentPageDetailDtoOutputStatusEnum>
    _$contentPageDetailDtoOutputStatusEnumSerializer =
    _$ContentPageDetailDtoOutputStatusEnumSerializer();

class _$ContentPageDetailDtoOutputTypeEnumSerializer
    implements PrimitiveSerializer<ContentPageDetailDtoOutputTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FAQ': 'FAQ',
    'BANNER': 'BANNER',
    'PAGE': 'PAGE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FAQ': 'FAQ',
    'BANNER': 'BANNER',
    'PAGE': 'PAGE',
  };

  @override
  final Iterable<Type> types = const <Type>[ContentPageDetailDtoOutputTypeEnum];
  @override
  final String wireName = 'ContentPageDetailDtoOutputTypeEnum';

  @override
  Object serialize(
          Serializers serializers, ContentPageDetailDtoOutputTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ContentPageDetailDtoOutputTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ContentPageDetailDtoOutputTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ContentPageDetailDtoOutputPlacementEnumSerializer
    implements PrimitiveSerializer<ContentPageDetailDtoOutputPlacementEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'HOME': 'HOME',
    'FOOTER': 'FOOTER',
    'BOOKING': 'BOOKING',
    'TICKET': 'TICKET',
    'ACCOUNT': 'ACCOUNT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'HOME': 'HOME',
    'FOOTER': 'FOOTER',
    'BOOKING': 'BOOKING',
    'TICKET': 'TICKET',
    'ACCOUNT': 'ACCOUNT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ContentPageDetailDtoOutputPlacementEnum
  ];
  @override
  final String wireName = 'ContentPageDetailDtoOutputPlacementEnum';

  @override
  Object serialize(Serializers serializers,
          ContentPageDetailDtoOutputPlacementEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ContentPageDetailDtoOutputPlacementEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ContentPageDetailDtoOutputPlacementEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ContentPageDetailDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<ContentPageDetailDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRAFT': 'DRAFT',
    'PUBLISHED': 'PUBLISHED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRAFT': 'DRAFT',
    'PUBLISHED': 'PUBLISHED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ContentPageDetailDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'ContentPageDetailDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ContentPageDetailDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ContentPageDetailDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ContentPageDetailDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ContentPageDetailDtoOutput extends ContentPageDetailDtoOutput {
  @override
  final String id;
  @override
  final ContentPageDetailDtoOutputTypeEnum type;
  @override
  final ContentPageDetailDtoOutputPlacementEnum placement;
  @override
  final String title;
  @override
  final String? slug;
  @override
  final ContentPageDetailDtoOutputStatusEnum status;
  @override
  final int displayOrder;
  @override
  final String? imageUrl;
  @override
  final DateTime updatedAt;
  @override
  final String bodyMarkdown;
  @override
  final String? imageKey;
  @override
  final String? linkUrl;
  @override
  final DateTime? publishedAt;
  @override
  final DateTime createdAt;
  @override
  final String? updatedByName;

  factory _$ContentPageDetailDtoOutput(
          [void Function(ContentPageDetailDtoOutputBuilder)? updates]) =>
      (ContentPageDetailDtoOutputBuilder()..update(updates))._build();

  _$ContentPageDetailDtoOutput._(
      {required this.id,
      required this.type,
      required this.placement,
      required this.title,
      this.slug,
      required this.status,
      required this.displayOrder,
      this.imageUrl,
      required this.updatedAt,
      required this.bodyMarkdown,
      this.imageKey,
      this.linkUrl,
      this.publishedAt,
      required this.createdAt,
      this.updatedByName})
      : super._();
  @override
  ContentPageDetailDtoOutput rebuild(
          void Function(ContentPageDetailDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContentPageDetailDtoOutputBuilder toBuilder() =>
      ContentPageDetailDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContentPageDetailDtoOutput &&
        id == other.id &&
        type == other.type &&
        placement == other.placement &&
        title == other.title &&
        slug == other.slug &&
        status == other.status &&
        displayOrder == other.displayOrder &&
        imageUrl == other.imageUrl &&
        updatedAt == other.updatedAt &&
        bodyMarkdown == other.bodyMarkdown &&
        imageKey == other.imageKey &&
        linkUrl == other.linkUrl &&
        publishedAt == other.publishedAt &&
        createdAt == other.createdAt &&
        updatedByName == other.updatedByName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, placement.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, displayOrder.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, bodyMarkdown.hashCode);
    _$hash = $jc(_$hash, imageKey.hashCode);
    _$hash = $jc(_$hash, linkUrl.hashCode);
    _$hash = $jc(_$hash, publishedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedByName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContentPageDetailDtoOutput')
          ..add('id', id)
          ..add('type', type)
          ..add('placement', placement)
          ..add('title', title)
          ..add('slug', slug)
          ..add('status', status)
          ..add('displayOrder', displayOrder)
          ..add('imageUrl', imageUrl)
          ..add('updatedAt', updatedAt)
          ..add('bodyMarkdown', bodyMarkdown)
          ..add('imageKey', imageKey)
          ..add('linkUrl', linkUrl)
          ..add('publishedAt', publishedAt)
          ..add('createdAt', createdAt)
          ..add('updatedByName', updatedByName))
        .toString();
  }
}

class ContentPageDetailDtoOutputBuilder
    implements
        Builder<ContentPageDetailDtoOutput, ContentPageDetailDtoOutputBuilder> {
  _$ContentPageDetailDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ContentPageDetailDtoOutputTypeEnum? _type;
  ContentPageDetailDtoOutputTypeEnum? get type => _$this._type;
  set type(ContentPageDetailDtoOutputTypeEnum? type) => _$this._type = type;

  ContentPageDetailDtoOutputPlacementEnum? _placement;
  ContentPageDetailDtoOutputPlacementEnum? get placement => _$this._placement;
  set placement(ContentPageDetailDtoOutputPlacementEnum? placement) =>
      _$this._placement = placement;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  ContentPageDetailDtoOutputStatusEnum? _status;
  ContentPageDetailDtoOutputStatusEnum? get status => _$this._status;
  set status(ContentPageDetailDtoOutputStatusEnum? status) =>
      _$this._status = status;

  int? _displayOrder;
  int? get displayOrder => _$this._displayOrder;
  set displayOrder(int? displayOrder) => _$this._displayOrder = displayOrder;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _bodyMarkdown;
  String? get bodyMarkdown => _$this._bodyMarkdown;
  set bodyMarkdown(String? bodyMarkdown) => _$this._bodyMarkdown = bodyMarkdown;

  String? _imageKey;
  String? get imageKey => _$this._imageKey;
  set imageKey(String? imageKey) => _$this._imageKey = imageKey;

  String? _linkUrl;
  String? get linkUrl => _$this._linkUrl;
  set linkUrl(String? linkUrl) => _$this._linkUrl = linkUrl;

  DateTime? _publishedAt;
  DateTime? get publishedAt => _$this._publishedAt;
  set publishedAt(DateTime? publishedAt) => _$this._publishedAt = publishedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _updatedByName;
  String? get updatedByName => _$this._updatedByName;
  set updatedByName(String? updatedByName) =>
      _$this._updatedByName = updatedByName;

  ContentPageDetailDtoOutputBuilder() {
    ContentPageDetailDtoOutput._defaults(this);
  }

  ContentPageDetailDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _placement = $v.placement;
      _title = $v.title;
      _slug = $v.slug;
      _status = $v.status;
      _displayOrder = $v.displayOrder;
      _imageUrl = $v.imageUrl;
      _updatedAt = $v.updatedAt;
      _bodyMarkdown = $v.bodyMarkdown;
      _imageKey = $v.imageKey;
      _linkUrl = $v.linkUrl;
      _publishedAt = $v.publishedAt;
      _createdAt = $v.createdAt;
      _updatedByName = $v.updatedByName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContentPageDetailDtoOutput other) {
    _$v = other as _$ContentPageDetailDtoOutput;
  }

  @override
  void update(void Function(ContentPageDetailDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContentPageDetailDtoOutput build() => _build();

  _$ContentPageDetailDtoOutput _build() {
    final _$result = _$v ??
        _$ContentPageDetailDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ContentPageDetailDtoOutput', 'id'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'ContentPageDetailDtoOutput', 'type'),
          placement: BuiltValueNullFieldError.checkNotNull(
              placement, r'ContentPageDetailDtoOutput', 'placement'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'ContentPageDetailDtoOutput', 'title'),
          slug: slug,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ContentPageDetailDtoOutput', 'status'),
          displayOrder: BuiltValueNullFieldError.checkNotNull(
              displayOrder, r'ContentPageDetailDtoOutput', 'displayOrder'),
          imageUrl: imageUrl,
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'ContentPageDetailDtoOutput', 'updatedAt'),
          bodyMarkdown: BuiltValueNullFieldError.checkNotNull(
              bodyMarkdown, r'ContentPageDetailDtoOutput', 'bodyMarkdown'),
          imageKey: imageKey,
          linkUrl: linkUrl,
          publishedAt: publishedAt,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'ContentPageDetailDtoOutput', 'createdAt'),
          updatedByName: updatedByName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
