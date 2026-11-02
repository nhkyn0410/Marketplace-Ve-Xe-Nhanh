// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logo_upload_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LogoUploadInputDtoContentTypeEnum
    _$logoUploadInputDtoContentTypeEnum_imageSlashJpeg =
    const LogoUploadInputDtoContentTypeEnum._('imageSlashJpeg');
const LogoUploadInputDtoContentTypeEnum
    _$logoUploadInputDtoContentTypeEnum_imageSlashPng =
    const LogoUploadInputDtoContentTypeEnum._('imageSlashPng');
const LogoUploadInputDtoContentTypeEnum
    _$logoUploadInputDtoContentTypeEnum_imageSlashWebp =
    const LogoUploadInputDtoContentTypeEnum._('imageSlashWebp');

LogoUploadInputDtoContentTypeEnum _$logoUploadInputDtoContentTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'imageSlashJpeg':
      return _$logoUploadInputDtoContentTypeEnum_imageSlashJpeg;
    case 'imageSlashPng':
      return _$logoUploadInputDtoContentTypeEnum_imageSlashPng;
    case 'imageSlashWebp':
      return _$logoUploadInputDtoContentTypeEnum_imageSlashWebp;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LogoUploadInputDtoContentTypeEnum>
    _$logoUploadInputDtoContentTypeEnumValues = BuiltSet<
        LogoUploadInputDtoContentTypeEnum>(const <LogoUploadInputDtoContentTypeEnum>[
  _$logoUploadInputDtoContentTypeEnum_imageSlashJpeg,
  _$logoUploadInputDtoContentTypeEnum_imageSlashPng,
  _$logoUploadInputDtoContentTypeEnum_imageSlashWebp,
]);

Serializer<LogoUploadInputDtoContentTypeEnum>
    _$logoUploadInputDtoContentTypeEnumSerializer =
    _$LogoUploadInputDtoContentTypeEnumSerializer();

class _$LogoUploadInputDtoContentTypeEnumSerializer
    implements PrimitiveSerializer<LogoUploadInputDtoContentTypeEnum> {
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
  final Iterable<Type> types = const <Type>[LogoUploadInputDtoContentTypeEnum];
  @override
  final String wireName = 'LogoUploadInputDtoContentTypeEnum';

  @override
  Object serialize(
          Serializers serializers, LogoUploadInputDtoContentTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LogoUploadInputDtoContentTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LogoUploadInputDtoContentTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LogoUploadInputDto extends LogoUploadInputDto {
  @override
  final LogoUploadInputDtoContentTypeEnum contentType;
  @override
  final int sizeBytes;

  factory _$LogoUploadInputDto(
          [void Function(LogoUploadInputDtoBuilder)? updates]) =>
      (LogoUploadInputDtoBuilder()..update(updates))._build();

  _$LogoUploadInputDto._({required this.contentType, required this.sizeBytes})
      : super._();
  @override
  LogoUploadInputDto rebuild(
          void Function(LogoUploadInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LogoUploadInputDtoBuilder toBuilder() =>
      LogoUploadInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LogoUploadInputDto &&
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
    return (newBuiltValueToStringHelper(r'LogoUploadInputDto')
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class LogoUploadInputDtoBuilder
    implements Builder<LogoUploadInputDto, LogoUploadInputDtoBuilder> {
  _$LogoUploadInputDto? _$v;

  LogoUploadInputDtoContentTypeEnum? _contentType;
  LogoUploadInputDtoContentTypeEnum? get contentType => _$this._contentType;
  set contentType(LogoUploadInputDtoContentTypeEnum? contentType) =>
      _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  LogoUploadInputDtoBuilder() {
    LogoUploadInputDto._defaults(this);
  }

  LogoUploadInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LogoUploadInputDto other) {
    _$v = other as _$LogoUploadInputDto;
  }

  @override
  void update(void Function(LogoUploadInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LogoUploadInputDto build() => _build();

  _$LogoUploadInputDto _build() {
    final _$result = _$v ??
        _$LogoUploadInputDto._(
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'LogoUploadInputDto', 'contentType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'LogoUploadInputDto', 'sizeBytes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
