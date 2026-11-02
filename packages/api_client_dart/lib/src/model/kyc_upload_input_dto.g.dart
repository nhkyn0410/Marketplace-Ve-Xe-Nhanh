// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_upload_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const KycUploadInputDtoContentTypeEnum
    _$kycUploadInputDtoContentTypeEnum_applicationSlashPdf =
    const KycUploadInputDtoContentTypeEnum._('applicationSlashPdf');
const KycUploadInputDtoContentTypeEnum
    _$kycUploadInputDtoContentTypeEnum_imageSlashJpeg =
    const KycUploadInputDtoContentTypeEnum._('imageSlashJpeg');
const KycUploadInputDtoContentTypeEnum
    _$kycUploadInputDtoContentTypeEnum_imageSlashPng =
    const KycUploadInputDtoContentTypeEnum._('imageSlashPng');

KycUploadInputDtoContentTypeEnum _$kycUploadInputDtoContentTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'applicationSlashPdf':
      return _$kycUploadInputDtoContentTypeEnum_applicationSlashPdf;
    case 'imageSlashJpeg':
      return _$kycUploadInputDtoContentTypeEnum_imageSlashJpeg;
    case 'imageSlashPng':
      return _$kycUploadInputDtoContentTypeEnum_imageSlashPng;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<KycUploadInputDtoContentTypeEnum>
    _$kycUploadInputDtoContentTypeEnumValues = BuiltSet<
        KycUploadInputDtoContentTypeEnum>(const <KycUploadInputDtoContentTypeEnum>[
  _$kycUploadInputDtoContentTypeEnum_applicationSlashPdf,
  _$kycUploadInputDtoContentTypeEnum_imageSlashJpeg,
  _$kycUploadInputDtoContentTypeEnum_imageSlashPng,
]);

Serializer<KycUploadInputDtoContentTypeEnum>
    _$kycUploadInputDtoContentTypeEnumSerializer =
    _$KycUploadInputDtoContentTypeEnumSerializer();

class _$KycUploadInputDtoContentTypeEnumSerializer
    implements PrimitiveSerializer<KycUploadInputDtoContentTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'applicationSlashPdf': 'application/pdf',
    'imageSlashJpeg': 'image/jpeg',
    'imageSlashPng': 'image/png',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'application/pdf': 'applicationSlashPdf',
    'image/jpeg': 'imageSlashJpeg',
    'image/png': 'imageSlashPng',
  };

  @override
  final Iterable<Type> types = const <Type>[KycUploadInputDtoContentTypeEnum];
  @override
  final String wireName = 'KycUploadInputDtoContentTypeEnum';

  @override
  Object serialize(
          Serializers serializers, KycUploadInputDtoContentTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  KycUploadInputDtoContentTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      KycUploadInputDtoContentTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$KycUploadInputDto extends KycUploadInputDto {
  @override
  final KycUploadInputDtoContentTypeEnum contentType;
  @override
  final int sizeBytes;

  factory _$KycUploadInputDto(
          [void Function(KycUploadInputDtoBuilder)? updates]) =>
      (KycUploadInputDtoBuilder()..update(updates))._build();

  _$KycUploadInputDto._({required this.contentType, required this.sizeBytes})
      : super._();
  @override
  KycUploadInputDto rebuild(void Function(KycUploadInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KycUploadInputDtoBuilder toBuilder() =>
      KycUploadInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KycUploadInputDto &&
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
    return (newBuiltValueToStringHelper(r'KycUploadInputDto')
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class KycUploadInputDtoBuilder
    implements Builder<KycUploadInputDto, KycUploadInputDtoBuilder> {
  _$KycUploadInputDto? _$v;

  KycUploadInputDtoContentTypeEnum? _contentType;
  KycUploadInputDtoContentTypeEnum? get contentType => _$this._contentType;
  set contentType(KycUploadInputDtoContentTypeEnum? contentType) =>
      _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  KycUploadInputDtoBuilder() {
    KycUploadInputDto._defaults(this);
  }

  KycUploadInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(KycUploadInputDto other) {
    _$v = other as _$KycUploadInputDto;
  }

  @override
  void update(void Function(KycUploadInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  KycUploadInputDto build() => _build();

  _$KycUploadInputDto _build() {
    final _$result = _$v ??
        _$KycUploadInputDto._(
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'KycUploadInputDto', 'contentType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'KycUploadInputDto', 'sizeBytes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
