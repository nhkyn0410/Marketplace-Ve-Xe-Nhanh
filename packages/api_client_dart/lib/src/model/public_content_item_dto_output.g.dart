// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_content_item_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PublicContentItemDtoOutputTypeEnum
    _$publicContentItemDtoOutputTypeEnum_FAQ =
    const PublicContentItemDtoOutputTypeEnum._('FAQ');
const PublicContentItemDtoOutputTypeEnum
    _$publicContentItemDtoOutputTypeEnum_BANNER =
    const PublicContentItemDtoOutputTypeEnum._('BANNER');
const PublicContentItemDtoOutputTypeEnum
    _$publicContentItemDtoOutputTypeEnum_PAGE =
    const PublicContentItemDtoOutputTypeEnum._('PAGE');

PublicContentItemDtoOutputTypeEnum _$publicContentItemDtoOutputTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'FAQ':
      return _$publicContentItemDtoOutputTypeEnum_FAQ;
    case 'BANNER':
      return _$publicContentItemDtoOutputTypeEnum_BANNER;
    case 'PAGE':
      return _$publicContentItemDtoOutputTypeEnum_PAGE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicContentItemDtoOutputTypeEnum>
    _$publicContentItemDtoOutputTypeEnumValues = BuiltSet<
        PublicContentItemDtoOutputTypeEnum>(const <PublicContentItemDtoOutputTypeEnum>[
  _$publicContentItemDtoOutputTypeEnum_FAQ,
  _$publicContentItemDtoOutputTypeEnum_BANNER,
  _$publicContentItemDtoOutputTypeEnum_PAGE,
]);

const PublicContentItemDtoOutputPlacementEnum
    _$publicContentItemDtoOutputPlacementEnum_HOME =
    const PublicContentItemDtoOutputPlacementEnum._('HOME');
const PublicContentItemDtoOutputPlacementEnum
    _$publicContentItemDtoOutputPlacementEnum_FOOTER =
    const PublicContentItemDtoOutputPlacementEnum._('FOOTER');
const PublicContentItemDtoOutputPlacementEnum
    _$publicContentItemDtoOutputPlacementEnum_BOOKING =
    const PublicContentItemDtoOutputPlacementEnum._('BOOKING');
const PublicContentItemDtoOutputPlacementEnum
    _$publicContentItemDtoOutputPlacementEnum_TICKET =
    const PublicContentItemDtoOutputPlacementEnum._('TICKET');
const PublicContentItemDtoOutputPlacementEnum
    _$publicContentItemDtoOutputPlacementEnum_ACCOUNT =
    const PublicContentItemDtoOutputPlacementEnum._('ACCOUNT');

PublicContentItemDtoOutputPlacementEnum
    _$publicContentItemDtoOutputPlacementEnumValueOf(String name) {
  switch (name) {
    case 'HOME':
      return _$publicContentItemDtoOutputPlacementEnum_HOME;
    case 'FOOTER':
      return _$publicContentItemDtoOutputPlacementEnum_FOOTER;
    case 'BOOKING':
      return _$publicContentItemDtoOutputPlacementEnum_BOOKING;
    case 'TICKET':
      return _$publicContentItemDtoOutputPlacementEnum_TICKET;
    case 'ACCOUNT':
      return _$publicContentItemDtoOutputPlacementEnum_ACCOUNT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicContentItemDtoOutputPlacementEnum>
    _$publicContentItemDtoOutputPlacementEnumValues = BuiltSet<
        PublicContentItemDtoOutputPlacementEnum>(const <PublicContentItemDtoOutputPlacementEnum>[
  _$publicContentItemDtoOutputPlacementEnum_HOME,
  _$publicContentItemDtoOutputPlacementEnum_FOOTER,
  _$publicContentItemDtoOutputPlacementEnum_BOOKING,
  _$publicContentItemDtoOutputPlacementEnum_TICKET,
  _$publicContentItemDtoOutputPlacementEnum_ACCOUNT,
]);

Serializer<PublicContentItemDtoOutputTypeEnum>
    _$publicContentItemDtoOutputTypeEnumSerializer =
    _$PublicContentItemDtoOutputTypeEnumSerializer();
Serializer<PublicContentItemDtoOutputPlacementEnum>
    _$publicContentItemDtoOutputPlacementEnumSerializer =
    _$PublicContentItemDtoOutputPlacementEnumSerializer();

class _$PublicContentItemDtoOutputTypeEnumSerializer
    implements PrimitiveSerializer<PublicContentItemDtoOutputTypeEnum> {
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
  final Iterable<Type> types = const <Type>[PublicContentItemDtoOutputTypeEnum];
  @override
  final String wireName = 'PublicContentItemDtoOutputTypeEnum';

  @override
  Object serialize(
          Serializers serializers, PublicContentItemDtoOutputTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicContentItemDtoOutputTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicContentItemDtoOutputTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicContentItemDtoOutputPlacementEnumSerializer
    implements PrimitiveSerializer<PublicContentItemDtoOutputPlacementEnum> {
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
    PublicContentItemDtoOutputPlacementEnum
  ];
  @override
  final String wireName = 'PublicContentItemDtoOutputPlacementEnum';

  @override
  Object serialize(Serializers serializers,
          PublicContentItemDtoOutputPlacementEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicContentItemDtoOutputPlacementEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicContentItemDtoOutputPlacementEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicContentItemDtoOutput extends PublicContentItemDtoOutput {
  @override
  final String id;
  @override
  final PublicContentItemDtoOutputTypeEnum type;
  @override
  final PublicContentItemDtoOutputPlacementEnum placement;
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

  factory _$PublicContentItemDtoOutput(
          [void Function(PublicContentItemDtoOutputBuilder)? updates]) =>
      (PublicContentItemDtoOutputBuilder()..update(updates))._build();

  _$PublicContentItemDtoOutput._(
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
  PublicContentItemDtoOutput rebuild(
          void Function(PublicContentItemDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicContentItemDtoOutputBuilder toBuilder() =>
      PublicContentItemDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicContentItemDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'PublicContentItemDtoOutput')
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

class PublicContentItemDtoOutputBuilder
    implements
        Builder<PublicContentItemDtoOutput, PublicContentItemDtoOutputBuilder> {
  _$PublicContentItemDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  PublicContentItemDtoOutputTypeEnum? _type;
  PublicContentItemDtoOutputTypeEnum? get type => _$this._type;
  set type(PublicContentItemDtoOutputTypeEnum? type) => _$this._type = type;

  PublicContentItemDtoOutputPlacementEnum? _placement;
  PublicContentItemDtoOutputPlacementEnum? get placement => _$this._placement;
  set placement(PublicContentItemDtoOutputPlacementEnum? placement) =>
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

  PublicContentItemDtoOutputBuilder() {
    PublicContentItemDtoOutput._defaults(this);
  }

  PublicContentItemDtoOutputBuilder get _$this {
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
  void replace(PublicContentItemDtoOutput other) {
    _$v = other as _$PublicContentItemDtoOutput;
  }

  @override
  void update(void Function(PublicContentItemDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicContentItemDtoOutput build() => _build();

  _$PublicContentItemDtoOutput _build() {
    final _$result = _$v ??
        _$PublicContentItemDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'PublicContentItemDtoOutput', 'id'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'PublicContentItemDtoOutput', 'type'),
          placement: BuiltValueNullFieldError.checkNotNull(
              placement, r'PublicContentItemDtoOutput', 'placement'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'PublicContentItemDtoOutput', 'title'),
          slug: slug,
          bodyMarkdown: BuiltValueNullFieldError.checkNotNull(
              bodyMarkdown, r'PublicContentItemDtoOutput', 'bodyMarkdown'),
          imageUrl: imageUrl,
          linkUrl: linkUrl,
          displayOrder: BuiltValueNullFieldError.checkNotNull(
              displayOrder, r'PublicContentItemDtoOutput', 'displayOrder'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'PublicContentItemDtoOutput', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
