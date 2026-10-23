// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_page_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ContentPageInputDtoTypeEnum _$contentPageInputDtoTypeEnum_FAQ =
    const ContentPageInputDtoTypeEnum._('FAQ');
const ContentPageInputDtoTypeEnum _$contentPageInputDtoTypeEnum_BANNER =
    const ContentPageInputDtoTypeEnum._('BANNER');
const ContentPageInputDtoTypeEnum _$contentPageInputDtoTypeEnum_PAGE =
    const ContentPageInputDtoTypeEnum._('PAGE');

ContentPageInputDtoTypeEnum _$contentPageInputDtoTypeEnumValueOf(String name) {
  switch (name) {
    case 'FAQ':
      return _$contentPageInputDtoTypeEnum_FAQ;
    case 'BANNER':
      return _$contentPageInputDtoTypeEnum_BANNER;
    case 'PAGE':
      return _$contentPageInputDtoTypeEnum_PAGE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ContentPageInputDtoTypeEnum>
    _$contentPageInputDtoTypeEnumValues =
    BuiltSet<ContentPageInputDtoTypeEnum>(const <ContentPageInputDtoTypeEnum>[
  _$contentPageInputDtoTypeEnum_FAQ,
  _$contentPageInputDtoTypeEnum_BANNER,
  _$contentPageInputDtoTypeEnum_PAGE,
]);

const ContentPageInputDtoPlacementEnum _$contentPageInputDtoPlacementEnum_HOME =
    const ContentPageInputDtoPlacementEnum._('HOME');
const ContentPageInputDtoPlacementEnum
    _$contentPageInputDtoPlacementEnum_FOOTER =
    const ContentPageInputDtoPlacementEnum._('FOOTER');
const ContentPageInputDtoPlacementEnum
    _$contentPageInputDtoPlacementEnum_BOOKING =
    const ContentPageInputDtoPlacementEnum._('BOOKING');
const ContentPageInputDtoPlacementEnum
    _$contentPageInputDtoPlacementEnum_TICKET =
    const ContentPageInputDtoPlacementEnum._('TICKET');
const ContentPageInputDtoPlacementEnum
    _$contentPageInputDtoPlacementEnum_ACCOUNT =
    const ContentPageInputDtoPlacementEnum._('ACCOUNT');

ContentPageInputDtoPlacementEnum _$contentPageInputDtoPlacementEnumValueOf(
    String name) {
  switch (name) {
    case 'HOME':
      return _$contentPageInputDtoPlacementEnum_HOME;
    case 'FOOTER':
      return _$contentPageInputDtoPlacementEnum_FOOTER;
    case 'BOOKING':
      return _$contentPageInputDtoPlacementEnum_BOOKING;
    case 'TICKET':
      return _$contentPageInputDtoPlacementEnum_TICKET;
    case 'ACCOUNT':
      return _$contentPageInputDtoPlacementEnum_ACCOUNT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ContentPageInputDtoPlacementEnum>
    _$contentPageInputDtoPlacementEnumValues = BuiltSet<
        ContentPageInputDtoPlacementEnum>(const <ContentPageInputDtoPlacementEnum>[
  _$contentPageInputDtoPlacementEnum_HOME,
  _$contentPageInputDtoPlacementEnum_FOOTER,
  _$contentPageInputDtoPlacementEnum_BOOKING,
  _$contentPageInputDtoPlacementEnum_TICKET,
  _$contentPageInputDtoPlacementEnum_ACCOUNT,
]);

Serializer<ContentPageInputDtoTypeEnum>
    _$contentPageInputDtoTypeEnumSerializer =
    _$ContentPageInputDtoTypeEnumSerializer();
Serializer<ContentPageInputDtoPlacementEnum>
    _$contentPageInputDtoPlacementEnumSerializer =
    _$ContentPageInputDtoPlacementEnumSerializer();

class _$ContentPageInputDtoTypeEnumSerializer
    implements PrimitiveSerializer<ContentPageInputDtoTypeEnum> {
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
  final Iterable<Type> types = const <Type>[ContentPageInputDtoTypeEnum];
  @override
  final String wireName = 'ContentPageInputDtoTypeEnum';

  @override
  Object serialize(Serializers serializers, ContentPageInputDtoTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ContentPageInputDtoTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ContentPageInputDtoTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ContentPageInputDtoPlacementEnumSerializer
    implements PrimitiveSerializer<ContentPageInputDtoPlacementEnum> {
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
  final Iterable<Type> types = const <Type>[ContentPageInputDtoPlacementEnum];
  @override
  final String wireName = 'ContentPageInputDtoPlacementEnum';

  @override
  Object serialize(
          Serializers serializers, ContentPageInputDtoPlacementEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ContentPageInputDtoPlacementEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ContentPageInputDtoPlacementEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ContentPageInputDto extends ContentPageInputDto {
  @override
  final ContentPageInputDtoTypeEnum type;
  @override
  final ContentPageInputDtoPlacementEnum placement;
  @override
  final String title;
  @override
  final String? slug;
  @override
  final String bodyMarkdown;
  @override
  final String? imageKey;
  @override
  final String? linkUrl;
  @override
  final int displayOrder;

  factory _$ContentPageInputDto(
          [void Function(ContentPageInputDtoBuilder)? updates]) =>
      (ContentPageInputDtoBuilder()..update(updates))._build();

  _$ContentPageInputDto._(
      {required this.type,
      required this.placement,
      required this.title,
      this.slug,
      required this.bodyMarkdown,
      this.imageKey,
      this.linkUrl,
      required this.displayOrder})
      : super._();
  @override
  ContentPageInputDto rebuild(
          void Function(ContentPageInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContentPageInputDtoBuilder toBuilder() =>
      ContentPageInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContentPageInputDto &&
        type == other.type &&
        placement == other.placement &&
        title == other.title &&
        slug == other.slug &&
        bodyMarkdown == other.bodyMarkdown &&
        imageKey == other.imageKey &&
        linkUrl == other.linkUrl &&
        displayOrder == other.displayOrder;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, placement.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, bodyMarkdown.hashCode);
    _$hash = $jc(_$hash, imageKey.hashCode);
    _$hash = $jc(_$hash, linkUrl.hashCode);
    _$hash = $jc(_$hash, displayOrder.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContentPageInputDto')
          ..add('type', type)
          ..add('placement', placement)
          ..add('title', title)
          ..add('slug', slug)
          ..add('bodyMarkdown', bodyMarkdown)
          ..add('imageKey', imageKey)
          ..add('linkUrl', linkUrl)
          ..add('displayOrder', displayOrder))
        .toString();
  }
}

class ContentPageInputDtoBuilder
    implements Builder<ContentPageInputDto, ContentPageInputDtoBuilder> {
  _$ContentPageInputDto? _$v;

  ContentPageInputDtoTypeEnum? _type;
  ContentPageInputDtoTypeEnum? get type => _$this._type;
  set type(ContentPageInputDtoTypeEnum? type) => _$this._type = type;

  ContentPageInputDtoPlacementEnum? _placement;
  ContentPageInputDtoPlacementEnum? get placement => _$this._placement;
  set placement(ContentPageInputDtoPlacementEnum? placement) =>
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

  String? _imageKey;
  String? get imageKey => _$this._imageKey;
  set imageKey(String? imageKey) => _$this._imageKey = imageKey;

  String? _linkUrl;
  String? get linkUrl => _$this._linkUrl;
  set linkUrl(String? linkUrl) => _$this._linkUrl = linkUrl;

  int? _displayOrder;
  int? get displayOrder => _$this._displayOrder;
  set displayOrder(int? displayOrder) => _$this._displayOrder = displayOrder;

  ContentPageInputDtoBuilder() {
    ContentPageInputDto._defaults(this);
  }

  ContentPageInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _placement = $v.placement;
      _title = $v.title;
      _slug = $v.slug;
      _bodyMarkdown = $v.bodyMarkdown;
      _imageKey = $v.imageKey;
      _linkUrl = $v.linkUrl;
      _displayOrder = $v.displayOrder;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContentPageInputDto other) {
    _$v = other as _$ContentPageInputDto;
  }

  @override
  void update(void Function(ContentPageInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContentPageInputDto build() => _build();

  _$ContentPageInputDto _build() {
    final _$result = _$v ??
        _$ContentPageInputDto._(
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'ContentPageInputDto', 'type'),
          placement: BuiltValueNullFieldError.checkNotNull(
              placement, r'ContentPageInputDto', 'placement'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'ContentPageInputDto', 'title'),
          slug: slug,
          bodyMarkdown: BuiltValueNullFieldError.checkNotNull(
              bodyMarkdown, r'ContentPageInputDto', 'bodyMarkdown'),
          imageKey: imageKey,
          linkUrl: linkUrl,
          displayOrder: BuiltValueNullFieldError.checkNotNull(
              displayOrder, r'ContentPageInputDto', 'displayOrder'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
