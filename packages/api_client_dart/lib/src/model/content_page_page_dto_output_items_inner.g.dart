// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_page_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ContentPagePageDtoOutputItemsInnerTypeEnum
    _$contentPagePageDtoOutputItemsInnerTypeEnum_FAQ =
    const ContentPagePageDtoOutputItemsInnerTypeEnum._('FAQ');
const ContentPagePageDtoOutputItemsInnerTypeEnum
    _$contentPagePageDtoOutputItemsInnerTypeEnum_BANNER =
    const ContentPagePageDtoOutputItemsInnerTypeEnum._('BANNER');
const ContentPagePageDtoOutputItemsInnerTypeEnum
    _$contentPagePageDtoOutputItemsInnerTypeEnum_PAGE =
    const ContentPagePageDtoOutputItemsInnerTypeEnum._('PAGE');

ContentPagePageDtoOutputItemsInnerTypeEnum
    _$contentPagePageDtoOutputItemsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'FAQ':
      return _$contentPagePageDtoOutputItemsInnerTypeEnum_FAQ;
    case 'BANNER':
      return _$contentPagePageDtoOutputItemsInnerTypeEnum_BANNER;
    case 'PAGE':
      return _$contentPagePageDtoOutputItemsInnerTypeEnum_PAGE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ContentPagePageDtoOutputItemsInnerTypeEnum>
    _$contentPagePageDtoOutputItemsInnerTypeEnumValues = BuiltSet<
        ContentPagePageDtoOutputItemsInnerTypeEnum>(const <ContentPagePageDtoOutputItemsInnerTypeEnum>[
  _$contentPagePageDtoOutputItemsInnerTypeEnum_FAQ,
  _$contentPagePageDtoOutputItemsInnerTypeEnum_BANNER,
  _$contentPagePageDtoOutputItemsInnerTypeEnum_PAGE,
]);

const ContentPagePageDtoOutputItemsInnerPlacementEnum
    _$contentPagePageDtoOutputItemsInnerPlacementEnum_HOME =
    const ContentPagePageDtoOutputItemsInnerPlacementEnum._('HOME');
const ContentPagePageDtoOutputItemsInnerPlacementEnum
    _$contentPagePageDtoOutputItemsInnerPlacementEnum_FOOTER =
    const ContentPagePageDtoOutputItemsInnerPlacementEnum._('FOOTER');
const ContentPagePageDtoOutputItemsInnerPlacementEnum
    _$contentPagePageDtoOutputItemsInnerPlacementEnum_BOOKING =
    const ContentPagePageDtoOutputItemsInnerPlacementEnum._('BOOKING');
const ContentPagePageDtoOutputItemsInnerPlacementEnum
    _$contentPagePageDtoOutputItemsInnerPlacementEnum_TICKET =
    const ContentPagePageDtoOutputItemsInnerPlacementEnum._('TICKET');
const ContentPagePageDtoOutputItemsInnerPlacementEnum
    _$contentPagePageDtoOutputItemsInnerPlacementEnum_ACCOUNT =
    const ContentPagePageDtoOutputItemsInnerPlacementEnum._('ACCOUNT');

ContentPagePageDtoOutputItemsInnerPlacementEnum
    _$contentPagePageDtoOutputItemsInnerPlacementEnumValueOf(String name) {
  switch (name) {
    case 'HOME':
      return _$contentPagePageDtoOutputItemsInnerPlacementEnum_HOME;
    case 'FOOTER':
      return _$contentPagePageDtoOutputItemsInnerPlacementEnum_FOOTER;
    case 'BOOKING':
      return _$contentPagePageDtoOutputItemsInnerPlacementEnum_BOOKING;
    case 'TICKET':
      return _$contentPagePageDtoOutputItemsInnerPlacementEnum_TICKET;
    case 'ACCOUNT':
      return _$contentPagePageDtoOutputItemsInnerPlacementEnum_ACCOUNT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ContentPagePageDtoOutputItemsInnerPlacementEnum>
    _$contentPagePageDtoOutputItemsInnerPlacementEnumValues = BuiltSet<
        ContentPagePageDtoOutputItemsInnerPlacementEnum>(const <ContentPagePageDtoOutputItemsInnerPlacementEnum>[
  _$contentPagePageDtoOutputItemsInnerPlacementEnum_HOME,
  _$contentPagePageDtoOutputItemsInnerPlacementEnum_FOOTER,
  _$contentPagePageDtoOutputItemsInnerPlacementEnum_BOOKING,
  _$contentPagePageDtoOutputItemsInnerPlacementEnum_TICKET,
  _$contentPagePageDtoOutputItemsInnerPlacementEnum_ACCOUNT,
]);

const ContentPagePageDtoOutputItemsInnerStatusEnum
    _$contentPagePageDtoOutputItemsInnerStatusEnum_DRAFT =
    const ContentPagePageDtoOutputItemsInnerStatusEnum._('DRAFT');
const ContentPagePageDtoOutputItemsInnerStatusEnum
    _$contentPagePageDtoOutputItemsInnerStatusEnum_PUBLISHED =
    const ContentPagePageDtoOutputItemsInnerStatusEnum._('PUBLISHED');

ContentPagePageDtoOutputItemsInnerStatusEnum
    _$contentPagePageDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'DRAFT':
      return _$contentPagePageDtoOutputItemsInnerStatusEnum_DRAFT;
    case 'PUBLISHED':
      return _$contentPagePageDtoOutputItemsInnerStatusEnum_PUBLISHED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ContentPagePageDtoOutputItemsInnerStatusEnum>
    _$contentPagePageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        ContentPagePageDtoOutputItemsInnerStatusEnum>(const <ContentPagePageDtoOutputItemsInnerStatusEnum>[
  _$contentPagePageDtoOutputItemsInnerStatusEnum_DRAFT,
  _$contentPagePageDtoOutputItemsInnerStatusEnum_PUBLISHED,
]);

Serializer<ContentPagePageDtoOutputItemsInnerTypeEnum>
    _$contentPagePageDtoOutputItemsInnerTypeEnumSerializer =
    _$ContentPagePageDtoOutputItemsInnerTypeEnumSerializer();
Serializer<ContentPagePageDtoOutputItemsInnerPlacementEnum>
    _$contentPagePageDtoOutputItemsInnerPlacementEnumSerializer =
    _$ContentPagePageDtoOutputItemsInnerPlacementEnumSerializer();
Serializer<ContentPagePageDtoOutputItemsInnerStatusEnum>
    _$contentPagePageDtoOutputItemsInnerStatusEnumSerializer =
    _$ContentPagePageDtoOutputItemsInnerStatusEnumSerializer();

class _$ContentPagePageDtoOutputItemsInnerTypeEnumSerializer
    implements PrimitiveSerializer<ContentPagePageDtoOutputItemsInnerTypeEnum> {
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
  final Iterable<Type> types = const <Type>[
    ContentPagePageDtoOutputItemsInnerTypeEnum
  ];
  @override
  final String wireName = 'ContentPagePageDtoOutputItemsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          ContentPagePageDtoOutputItemsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ContentPagePageDtoOutputItemsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ContentPagePageDtoOutputItemsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ContentPagePageDtoOutputItemsInnerPlacementEnumSerializer
    implements
        PrimitiveSerializer<ContentPagePageDtoOutputItemsInnerPlacementEnum> {
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
    ContentPagePageDtoOutputItemsInnerPlacementEnum
  ];
  @override
  final String wireName = 'ContentPagePageDtoOutputItemsInnerPlacementEnum';

  @override
  Object serialize(Serializers serializers,
          ContentPagePageDtoOutputItemsInnerPlacementEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ContentPagePageDtoOutputItemsInnerPlacementEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ContentPagePageDtoOutputItemsInnerPlacementEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ContentPagePageDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<ContentPagePageDtoOutputItemsInnerStatusEnum> {
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
    ContentPagePageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'ContentPagePageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          ContentPagePageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ContentPagePageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ContentPagePageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ContentPagePageDtoOutputItemsInner
    extends ContentPagePageDtoOutputItemsInner {
  @override
  final String id;
  @override
  final ContentPagePageDtoOutputItemsInnerTypeEnum type;
  @override
  final ContentPagePageDtoOutputItemsInnerPlacementEnum placement;
  @override
  final String title;
  @override
  final String? slug;
  @override
  final ContentPagePageDtoOutputItemsInnerStatusEnum status;
  @override
  final int displayOrder;
  @override
  final String? imageUrl;
  @override
  final DateTime updatedAt;

  factory _$ContentPagePageDtoOutputItemsInner(
          [void Function(ContentPagePageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (ContentPagePageDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$ContentPagePageDtoOutputItemsInner._(
      {required this.id,
      required this.type,
      required this.placement,
      required this.title,
      this.slug,
      required this.status,
      required this.displayOrder,
      this.imageUrl,
      required this.updatedAt})
      : super._();
  @override
  ContentPagePageDtoOutputItemsInner rebuild(
          void Function(ContentPagePageDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContentPagePageDtoOutputItemsInnerBuilder toBuilder() =>
      ContentPagePageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContentPagePageDtoOutputItemsInner &&
        id == other.id &&
        type == other.type &&
        placement == other.placement &&
        title == other.title &&
        slug == other.slug &&
        status == other.status &&
        displayOrder == other.displayOrder &&
        imageUrl == other.imageUrl &&
        updatedAt == other.updatedAt;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContentPagePageDtoOutputItemsInner')
          ..add('id', id)
          ..add('type', type)
          ..add('placement', placement)
          ..add('title', title)
          ..add('slug', slug)
          ..add('status', status)
          ..add('displayOrder', displayOrder)
          ..add('imageUrl', imageUrl)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ContentPagePageDtoOutputItemsInnerBuilder
    implements
        Builder<ContentPagePageDtoOutputItemsInner,
            ContentPagePageDtoOutputItemsInnerBuilder> {
  _$ContentPagePageDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ContentPagePageDtoOutputItemsInnerTypeEnum? _type;
  ContentPagePageDtoOutputItemsInnerTypeEnum? get type => _$this._type;
  set type(ContentPagePageDtoOutputItemsInnerTypeEnum? type) =>
      _$this._type = type;

  ContentPagePageDtoOutputItemsInnerPlacementEnum? _placement;
  ContentPagePageDtoOutputItemsInnerPlacementEnum? get placement =>
      _$this._placement;
  set placement(ContentPagePageDtoOutputItemsInnerPlacementEnum? placement) =>
      _$this._placement = placement;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  ContentPagePageDtoOutputItemsInnerStatusEnum? _status;
  ContentPagePageDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(ContentPagePageDtoOutputItemsInnerStatusEnum? status) =>
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

  ContentPagePageDtoOutputItemsInnerBuilder() {
    ContentPagePageDtoOutputItemsInner._defaults(this);
  }

  ContentPagePageDtoOutputItemsInnerBuilder get _$this {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContentPagePageDtoOutputItemsInner other) {
    _$v = other as _$ContentPagePageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(ContentPagePageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContentPagePageDtoOutputItemsInner build() => _build();

  _$ContentPagePageDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$ContentPagePageDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ContentPagePageDtoOutputItemsInner', 'id'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'ContentPagePageDtoOutputItemsInner', 'type'),
          placement: BuiltValueNullFieldError.checkNotNull(
              placement, r'ContentPagePageDtoOutputItemsInner', 'placement'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'ContentPagePageDtoOutputItemsInner', 'title'),
          slug: slug,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ContentPagePageDtoOutputItemsInner', 'status'),
          displayOrder: BuiltValueNullFieldError.checkNotNull(displayOrder,
              r'ContentPagePageDtoOutputItemsInner', 'displayOrder'),
          imageUrl: imageUrl,
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'ContentPagePageDtoOutputItemsInner', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
