// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_image_upload_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ContentImageUploadInputDtoContentTypeEnum
    _$contentImageUploadInputDtoContentTypeEnum_imageSlashJpeg =
    const ContentImageUploadInputDtoContentTypeEnum._('imageSlashJpeg');
const ContentImageUploadInputDtoContentTypeEnum
    _$contentImageUploadInputDtoContentTypeEnum_imageSlashPng =
    const ContentImageUploadInputDtoContentTypeEnum._('imageSlashPng');
const ContentImageUploadInputDtoContentTypeEnum
    _$contentImageUploadInputDtoContentTypeEnum_imageSlashWebp =
    const ContentImageUploadInputDtoContentTypeEnum._('imageSlashWebp');

ContentImageUploadInputDtoContentTypeEnum
    _$contentImageUploadInputDtoContentTypeEnumValueOf(String name) {
  switch (name) {
    case 'imageSlashJpeg':
      return _$contentImageUploadInputDtoContentTypeEnum_imageSlashJpeg;
    case 'imageSlashPng':
      return _$contentImageUploadInputDtoContentTypeEnum_imageSlashPng;
    case 'imageSlashWebp':
      return _$contentImageUploadInputDtoContentTypeEnum_imageSlashWebp;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ContentImageUploadInputDtoContentTypeEnum>
    _$contentImageUploadInputDtoContentTypeEnumValues = BuiltSet<
        ContentImageUploadInputDtoContentTypeEnum>(const <ContentImageUploadInputDtoContentTypeEnum>[
  _$contentImageUploadInputDtoContentTypeEnum_imageSlashJpeg,
  _$contentImageUploadInputDtoContentTypeEnum_imageSlashPng,
  _$contentImageUploadInputDtoContentTypeEnum_imageSlashWebp,
]);

Serializer<ContentImageUploadInputDtoContentTypeEnum>
    _$contentImageUploadInputDtoContentTypeEnumSerializer =
    _$ContentImageUploadInputDtoContentTypeEnumSerializer();

class _$ContentImageUploadInputDtoContentTypeEnumSerializer
    implements PrimitiveSerializer<ContentImageUploadInputDtoContentTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'imageSlashJpeg': 'image/jpeg',
    'imageSlashPng': 'image/png',
    'imageSlashWebp': 'image/webp',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'image/jpeg': 'imageSlashJpeg',
    'image/png': 'imageSlashPng',
    'image/webp': 'imageSlashWebp',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ContentImageUploadInputDtoContentTypeEnum
  ];
  @override
  final String wireName = 'ContentImageUploadInputDtoContentTypeEnum';

  @override
  Object serialize(Serializers serializers,
          ContentImageUploadInputDtoContentTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ContentImageUploadInputDtoContentTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ContentImageUploadInputDtoContentTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ContentImageUploadInputDto extends ContentImageUploadInputDto {
  @override
  final ContentImageUploadInputDtoContentTypeEnum contentType;
  @override
  final int sizeBytes;

  factory _$ContentImageUploadInputDto(
          [void Function(ContentImageUploadInputDtoBuilder)? updates]) =>
      (ContentImageUploadInputDtoBuilder()..update(updates))._build();

  _$ContentImageUploadInputDto._(
      {required this.contentType, required this.sizeBytes})
      : super._();
  @override
  ContentImageUploadInputDto rebuild(
          void Function(ContentImageUploadInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContentImageUploadInputDtoBuilder toBuilder() =>
      ContentImageUploadInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContentImageUploadInputDto &&
        contentType == other.contentType &&
        sizeBytes == other.sizeBytes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContentImageUploadInputDto')
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class ContentImageUploadInputDtoBuilder
    implements
        Builder<ContentImageUploadInputDto, ContentImageUploadInputDtoBuilder> {
  _$ContentImageUploadInputDto? _$v;

  ContentImageUploadInputDtoContentTypeEnum? _contentType;
  ContentImageUploadInputDtoContentTypeEnum? get contentType =>
      _$this._contentType;
  set contentType(ContentImageUploadInputDtoContentTypeEnum? contentType) =>
      _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  ContentImageUploadInputDtoBuilder() {
    ContentImageUploadInputDto._defaults(this);
  }

  ContentImageUploadInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContentImageUploadInputDto other) {
    _$v = other as _$ContentImageUploadInputDto;
  }

  @override
  void update(void Function(ContentImageUploadInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContentImageUploadInputDto build() => _build();

  _$ContentImageUploadInputDto _build() {
    final _$result = _$v ??
        _$ContentImageUploadInputDto._(
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'ContentImageUploadInputDto', 'contentType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'ContentImageUploadInputDto', 'sizeBytes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
