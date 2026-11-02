// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_image_upload_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VehicleImageUploadInputDtoContentTypeEnum
    _$vehicleImageUploadInputDtoContentTypeEnum_imageSlashJpeg =
    const VehicleImageUploadInputDtoContentTypeEnum._('imageSlashJpeg');
const VehicleImageUploadInputDtoContentTypeEnum
    _$vehicleImageUploadInputDtoContentTypeEnum_imageSlashPng =
    const VehicleImageUploadInputDtoContentTypeEnum._('imageSlashPng');
const VehicleImageUploadInputDtoContentTypeEnum
    _$vehicleImageUploadInputDtoContentTypeEnum_imageSlashWebp =
    const VehicleImageUploadInputDtoContentTypeEnum._('imageSlashWebp');

VehicleImageUploadInputDtoContentTypeEnum
    _$vehicleImageUploadInputDtoContentTypeEnumValueOf(String name) {
  switch (name) {
    case 'imageSlashJpeg':
      return _$vehicleImageUploadInputDtoContentTypeEnum_imageSlashJpeg;
    case 'imageSlashPng':
      return _$vehicleImageUploadInputDtoContentTypeEnum_imageSlashPng;
    case 'imageSlashWebp':
      return _$vehicleImageUploadInputDtoContentTypeEnum_imageSlashWebp;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VehicleImageUploadInputDtoContentTypeEnum>
    _$vehicleImageUploadInputDtoContentTypeEnumValues = BuiltSet<
        VehicleImageUploadInputDtoContentTypeEnum>(const <VehicleImageUploadInputDtoContentTypeEnum>[
  _$vehicleImageUploadInputDtoContentTypeEnum_imageSlashJpeg,
  _$vehicleImageUploadInputDtoContentTypeEnum_imageSlashPng,
  _$vehicleImageUploadInputDtoContentTypeEnum_imageSlashWebp,
]);

Serializer<VehicleImageUploadInputDtoContentTypeEnum>
    _$vehicleImageUploadInputDtoContentTypeEnumSerializer =
    _$VehicleImageUploadInputDtoContentTypeEnumSerializer();

class _$VehicleImageUploadInputDtoContentTypeEnumSerializer
    implements PrimitiveSerializer<VehicleImageUploadInputDtoContentTypeEnum> {
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
    VehicleImageUploadInputDtoContentTypeEnum
  ];
  @override
  final String wireName = 'VehicleImageUploadInputDtoContentTypeEnum';

  @override
  Object serialize(Serializers serializers,
          VehicleImageUploadInputDtoContentTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VehicleImageUploadInputDtoContentTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VehicleImageUploadInputDtoContentTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VehicleImageUploadInputDto extends VehicleImageUploadInputDto {
  @override
  final VehicleImageUploadInputDtoContentTypeEnum contentType;
  @override
  final int sizeBytes;

  factory _$VehicleImageUploadInputDto(
          [void Function(VehicleImageUploadInputDtoBuilder)? updates]) =>
      (VehicleImageUploadInputDtoBuilder()..update(updates))._build();

  _$VehicleImageUploadInputDto._(
      {required this.contentType, required this.sizeBytes})
      : super._();
  @override
  VehicleImageUploadInputDto rebuild(
          void Function(VehicleImageUploadInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VehicleImageUploadInputDtoBuilder toBuilder() =>
      VehicleImageUploadInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VehicleImageUploadInputDto &&
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
    return (newBuiltValueToStringHelper(r'VehicleImageUploadInputDto')
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class VehicleImageUploadInputDtoBuilder
    implements
        Builder<VehicleImageUploadInputDto, VehicleImageUploadInputDtoBuilder> {
  _$VehicleImageUploadInputDto? _$v;

  VehicleImageUploadInputDtoContentTypeEnum? _contentType;
  VehicleImageUploadInputDtoContentTypeEnum? get contentType =>
      _$this._contentType;
  set contentType(VehicleImageUploadInputDtoContentTypeEnum? contentType) =>
      _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  VehicleImageUploadInputDtoBuilder() {
    VehicleImageUploadInputDto._defaults(this);
  }

  VehicleImageUploadInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VehicleImageUploadInputDto other) {
    _$v = other as _$VehicleImageUploadInputDto;
  }

  @override
  void update(void Function(VehicleImageUploadInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VehicleImageUploadInputDto build() => _build();

  _$VehicleImageUploadInputDto _build() {
    final _$result = _$v ??
        _$VehicleImageUploadInputDto._(
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'VehicleImageUploadInputDto', 'contentType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'VehicleImageUploadInputDto', 'sizeBytes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
