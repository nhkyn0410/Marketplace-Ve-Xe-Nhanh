// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_content_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PublicContentListDtoOutputItemsInnerTypeEnum
    _$publicContentListDtoOutputItemsInnerTypeEnum_FAQ =
    const PublicContentListDtoOutputItemsInnerTypeEnum._('FAQ');
const PublicContentListDtoOutputItemsInnerTypeEnum
    _$publicContentListDtoOutputItemsInnerTypeEnum_BANNER =
    const PublicContentListDtoOutputItemsInnerTypeEnum._('BANNER');
const PublicContentListDtoOutputItemsInnerTypeEnum
    _$publicContentListDtoOutputItemsInnerTypeEnum_PAGE =
    const PublicContentListDtoOutputItemsInnerTypeEnum._('PAGE');

PublicContentListDtoOutputItemsInnerTypeEnum
    _$publicContentListDtoOutputItemsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'FAQ':
      return _$publicContentListDtoOutputItemsInnerTypeEnum_FAQ;
    case 'BANNER':
      return _$publicContentListDtoOutputItemsInnerTypeEnum_BANNER;
    case 'PAGE':
      return _$publicContentListDtoOutputItemsInnerTypeEnum_PAGE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicContentListDtoOutputItemsInnerTypeEnum>
    _$publicContentListDtoOutputItemsInnerTypeEnumValues = BuiltSet<
        PublicContentListDtoOutputItemsInnerTypeEnum>(const <PublicContentListDtoOutputItemsInnerTypeEnum>[
  _$publicContentListDtoOutputItemsInnerTypeEnum_FAQ,
  _$publicContentListDtoOutputItemsInnerTypeEnum_BANNER,
  _$publicContentListDtoOutputItemsInnerTypeEnum_PAGE,
]);

const PublicContentListDtoOutputItemsInnerPlacementEnum
    _$publicContentListDtoOutputItemsInnerPlacementEnum_HOME =
    const PublicContentListDtoOutputItemsInnerPlacementEnum._('HOME');
const PublicContentListDtoOutputItemsInnerPlacementEnum
    _$publicContentListDtoOutputItemsInnerPlacementEnum_FOOTER =
    const PublicContentListDtoOutputItemsInnerPlacementEnum._('FOOTER');
const PublicContentListDtoOutputItemsInnerPlacementEnum
    _$publicContentListDtoOutputItemsInnerPlacementEnum_BOOKING =
    const PublicContentListDtoOutputItemsInnerPlacementEnum._('BOOKING');
const PublicContentListDtoOutputItemsInnerPlacementEnum
    _$publicContentListDtoOutputItemsInnerPlacementEnum_TICKET =
    const PublicContentListDtoOutputItemsInnerPlacementEnum._('TICKET');
const PublicContentListDtoOutputItemsInnerPlacementEnum
    _$publicContentListDtoOutputItemsInnerPlacementEnum_ACCOUNT =
    const PublicContentListDtoOutputItemsInnerPlacementEnum._('ACCOUNT');

PublicContentListDtoOutputItemsInnerPlacementEnum
    _$publicContentListDtoOutputItemsInnerPlacementEnumValueOf(String name) {
  switch (name) {
    case 'HOME':
      return _$publicContentListDtoOutputItemsInnerPlacementEnum_HOME;
    case 'FOOTER':
      return _$publicContentListDtoOutputItemsInnerPlacementEnum_FOOTER;
    case 'BOOKING':
      return _$publicContentListDtoOutputItemsInnerPlacementEnum_BOOKING;
    case 'TICKET':
      return _$publicContentListDtoOutputItemsInnerPlacementEnum_TICKET;
    case 'ACCOUNT':
      return _$publicContentListDtoOutputItemsInnerPlacementEnum_ACCOUNT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicContentListDtoOutputItemsInnerPlacementEnum>
    _$publicContentListDtoOutputItemsInnerPlacementEnumValues = BuiltSet<
        PublicContentListDtoOutputItemsInnerPlacementEnum>(const <PublicContentListDtoOutputItemsInnerPlacementEnum>[
  _$publicContentListDtoOutputItemsInnerPlacementEnum_HOME,
  _$publicContentListDtoOutputItemsInnerPlacementEnum_FOOTER,
  _$publicContentListDtoOutputItemsInnerPlacementEnum_BOOKING,
  _$publicContentListDtoOutputItemsInnerPlacementEnum_TICKET,
  _$publicContentListDtoOutputItemsInnerPlacementEnum_ACCOUNT,
]);

Serializer<PublicContentListDtoOutputItemsInnerTypeEnum>
    _$publicContentListDtoOutputItemsInnerTypeEnumSerializer =
    _$PublicContentListDtoOutputItemsInnerTypeEnumSerializer();
Serializer<PublicContentListDtoOutputItemsInnerPlacementEnum>
    _$publicContentListDtoOutputItemsInnerPlacementEnumSerializer =
    _$PublicContentListDtoOutputItemsInnerPlacementEnumSerializer();

class _$PublicContentListDtoOutputItemsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<PublicContentListDtoOutputItemsInnerTypeEnum> {
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
    PublicContentListDtoOutputItemsInnerTypeEnum
  ];
  @override
  final String wireName = 'PublicContentListDtoOutputItemsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          PublicContentListDtoOutputItemsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicContentListDtoOutputItemsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicContentListDtoOutputItemsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicContentListDtoOutputItemsInnerPlacementEnumSerializer
    implements
        PrimitiveSerializer<PublicContentListDtoOutputItemsInnerPlacementEnum> {
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
    PublicContentListDtoOutputItemsInnerPlacementEnum
  ];
  @override
  final String wireName = 'PublicContentListDtoOutputItemsInnerPlacementEnum';

  @override
  Object serialize(Serializers serializers,
          PublicContentListDtoOutputItemsInnerPlacementEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicContentListDtoOutputItemsInnerPlacementEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicContentListDtoOutputItemsInnerPlacementEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicContentListDtoOutputItemsInner
    extends PublicContentListDtoOutputItemsInner {
  @override
  final String id;
  @override
  final PublicContentListDtoOutputItemsInnerTypeEnum type;
  @override
  final PublicContentListDtoOutputItemsInnerPlacementEnum placement;
  @override
  final String title;
  @override
  final String? slug;
  @override
  final String bodyMarkdown;
  @override
  final String? imageUrl;
  @override
  final String? linkUrl;
  @override
  final int displayOrder;
  @override
  final DateTime updatedAt;

  factory _$PublicContentListDtoOutputItemsInner(
          [void Function(PublicContentListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (PublicContentListDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$PublicContentListDtoOutputItemsInner._(
      {required this.id,
      required this.type,
      required this.placement,
      required this.title,
      this.slug,
      required this.bodyMarkdown,
      this.imageUrl,
      this.linkUrl,
      required this.displayOrder,
      required this.updatedAt})
      : super._();
  @override
  PublicContentListDtoOutputItemsInner rebuild(
          void Function(PublicContentListDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicContentListDtoOutputItemsInnerBuilder toBuilder() =>
      PublicContentListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicContentListDtoOutputItemsInner &&
        id == other.id &&
        type == other.type &&
        placement == other.placement &&
        title == other.title &&
        slug == other.slug &&
        bodyMarkdown == other.bodyMarkdown &&
        imageUrl == other.imageUrl &&
        linkUrl == other.linkUrl &&
        displayOrder == other.displayOrder &&
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
    _$hash = $jc(_$hash, bodyMarkdown.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, linkUrl.hashCode);
    _$hash = $jc(_$hash, displayOrder.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicContentListDtoOutputItemsInner')
          ..add('id', id)
          ..add('type', type)
          ..add('placement', placement)
          ..add('title', title)
          ..add('slug', slug)
          ..add('bodyMarkdown', bodyMarkdown)
          ..add('imageUrl', imageUrl)
          ..add('linkUrl', linkUrl)
          ..add('displayOrder', displayOrder)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class PublicContentListDtoOutputItemsInnerBuilder
    implements
        Builder<PublicContentListDtoOutputItemsInner,
            PublicContentListDtoOutputItemsInnerBuilder> {
  _$PublicContentListDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  PublicContentListDtoOutputItemsInnerTypeEnum? _type;
  PublicContentListDtoOutputItemsInnerTypeEnum? get type => _$this._type;
  set type(PublicContentListDtoOutputItemsInnerTypeEnum? type) =>
      _$this._type = type;

  PublicContentListDtoOutputItemsInnerPlacementEnum? _placement;
  PublicContentListDtoOutputItemsInnerPlacementEnum? get placement =>
      _$this._placement;
  set placement(PublicContentListDtoOutputItemsInnerPlacementEnum? placement) =>
      _$this._placement = placement;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _bodyMarkdown;
  String? get bodyMarkdown => _$this._bodyMarkdown;
  set bodyMarkdown(String? bodyMarkdown) => _$this._bodyMarkdown = bodyMarkdown;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  String? _linkUrl;
  String? get linkUrl => _$this._linkUrl;
  set linkUrl(String? linkUrl) => _$this._linkUrl = linkUrl;

  int? _displayOrder;
  int? get displayOrder => _$this._displayOrder;
  set displayOrder(int? displayOrder) => _$this._displayOrder = displayOrder;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  PublicContentListDtoOutputItemsInnerBuilder() {
    PublicContentListDtoOutputItemsInner._defaults(this);
  }

  PublicContentListDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _placement = $v.placement;
      _title = $v.title;
      _slug = $v.slug;
      _bodyMarkdown = $v.bodyMarkdown;
      _imageUrl = $v.imageUrl;
      _linkUrl = $v.linkUrl;
      _displayOrder = $v.displayOrder;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicContentListDtoOutputItemsInner other) {
    _$v = other as _$PublicContentListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(PublicContentListDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicContentListDtoOutputItemsInner build() => _build();

  _$PublicContentListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$PublicContentListDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'PublicContentListDtoOutputItemsInner', 'id'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'PublicContentListDtoOutputItemsInner', 'type'),
          placement: BuiltValueNullFieldError.checkNotNull(
              placement, r'PublicContentListDtoOutputItemsInner', 'placement'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'PublicContentListDtoOutputItemsInner', 'title'),
          slug: slug,
          bodyMarkdown: BuiltValueNullFieldError.checkNotNull(bodyMarkdown,
              r'PublicContentListDtoOutputItemsInner', 'bodyMarkdown'),
          imageUrl: imageUrl,
          linkUrl: linkUrl,
          displayOrder: BuiltValueNullFieldError.checkNotNull(displayOrder,
              r'PublicContentListDtoOutputItemsInner', 'displayOrder'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'PublicContentListDtoOutputItemsInner', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
