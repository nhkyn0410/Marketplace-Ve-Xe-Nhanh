// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_upload_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AttachmentUploadInputDtoContentTypeEnum
    _$attachmentUploadInputDtoContentTypeEnum_applicationSlashPdf =
    const AttachmentUploadInputDtoContentTypeEnum._('applicationSlashPdf');
const AttachmentUploadInputDtoContentTypeEnum
    _$attachmentUploadInputDtoContentTypeEnum_imageSlashJpeg =
    const AttachmentUploadInputDtoContentTypeEnum._('imageSlashJpeg');
const AttachmentUploadInputDtoContentTypeEnum
    _$attachmentUploadInputDtoContentTypeEnum_imageSlashPng =
    const AttachmentUploadInputDtoContentTypeEnum._('imageSlashPng');

AttachmentUploadInputDtoContentTypeEnum
    _$attachmentUploadInputDtoContentTypeEnumValueOf(String name) {
  switch (name) {
    case 'applicationSlashPdf':
      return _$attachmentUploadInputDtoContentTypeEnum_applicationSlashPdf;
    case 'imageSlashJpeg':
      return _$attachmentUploadInputDtoContentTypeEnum_imageSlashJpeg;
    case 'imageSlashPng':
      return _$attachmentUploadInputDtoContentTypeEnum_imageSlashPng;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AttachmentUploadInputDtoContentTypeEnum>
    _$attachmentUploadInputDtoContentTypeEnumValues = BuiltSet<
        AttachmentUploadInputDtoContentTypeEnum>(const <AttachmentUploadInputDtoContentTypeEnum>[
  _$attachmentUploadInputDtoContentTypeEnum_applicationSlashPdf,
  _$attachmentUploadInputDtoContentTypeEnum_imageSlashJpeg,
  _$attachmentUploadInputDtoContentTypeEnum_imageSlashPng,
]);

Serializer<AttachmentUploadInputDtoContentTypeEnum>
    _$attachmentUploadInputDtoContentTypeEnumSerializer =
    _$AttachmentUploadInputDtoContentTypeEnumSerializer();

class _$AttachmentUploadInputDtoContentTypeEnumSerializer
    implements PrimitiveSerializer<AttachmentUploadInputDtoContentTypeEnum> {
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
  final Iterable<Type> types = const <Type>[
    AttachmentUploadInputDtoContentTypeEnum
  ];
  @override
  final String wireName = 'AttachmentUploadInputDtoContentTypeEnum';

  @override
  Object serialize(Serializers serializers,
          AttachmentUploadInputDtoContentTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AttachmentUploadInputDtoContentTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AttachmentUploadInputDtoContentTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AttachmentUploadInputDto extends AttachmentUploadInputDto {
  @override
  final AttachmentUploadInputDtoContentTypeEnum contentType;
  @override
  final int sizeBytes;

  factory _$AttachmentUploadInputDto(
          [void Function(AttachmentUploadInputDtoBuilder)? updates]) =>
      (AttachmentUploadInputDtoBuilder()..update(updates))._build();

  _$AttachmentUploadInputDto._(
      {required this.contentType, required this.sizeBytes})
      : super._();
  @override
  AttachmentUploadInputDto rebuild(
          void Function(AttachmentUploadInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AttachmentUploadInputDtoBuilder toBuilder() =>
      AttachmentUploadInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AttachmentUploadInputDto &&
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
    return (newBuiltValueToStringHelper(r'AttachmentUploadInputDto')
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class AttachmentUploadInputDtoBuilder
    implements
        Builder<AttachmentUploadInputDto, AttachmentUploadInputDtoBuilder> {
  _$AttachmentUploadInputDto? _$v;

  AttachmentUploadInputDtoContentTypeEnum? _contentType;
  AttachmentUploadInputDtoContentTypeEnum? get contentType =>
      _$this._contentType;
  set contentType(AttachmentUploadInputDtoContentTypeEnum? contentType) =>
      _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  AttachmentUploadInputDtoBuilder() {
    AttachmentUploadInputDto._defaults(this);
  }

  AttachmentUploadInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AttachmentUploadInputDto other) {
    _$v = other as _$AttachmentUploadInputDto;
  }

  @override
  void update(void Function(AttachmentUploadInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AttachmentUploadInputDto build() => _build();

  _$AttachmentUploadInputDto _build() {
    final _$result = _$v ??
        _$AttachmentUploadInputDto._(
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'AttachmentUploadInputDto', 'contentType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'AttachmentUploadInputDto', 'sizeBytes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
