// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_upload_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DocumentUploadInputDtoTypeEnum
    _$documentUploadInputDtoTypeEnum_BUSINESS_REGISTRATION =
    const DocumentUploadInputDtoTypeEnum._('BUSINESS_REGISTRATION');
const DocumentUploadInputDtoTypeEnum
    _$documentUploadInputDtoTypeEnum_TRANSPORT_LICENSE =
    const DocumentUploadInputDtoTypeEnum._('TRANSPORT_LICENSE');
const DocumentUploadInputDtoTypeEnum
    _$documentUploadInputDtoTypeEnum_REPRESENTATIVE_AUTHORIZATION =
    const DocumentUploadInputDtoTypeEnum._('REPRESENTATIVE_AUTHORIZATION');

DocumentUploadInputDtoTypeEnum _$documentUploadInputDtoTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'BUSINESS_REGISTRATION':
      return _$documentUploadInputDtoTypeEnum_BUSINESS_REGISTRATION;
    case 'TRANSPORT_LICENSE':
      return _$documentUploadInputDtoTypeEnum_TRANSPORT_LICENSE;
    case 'REPRESENTATIVE_AUTHORIZATION':
      return _$documentUploadInputDtoTypeEnum_REPRESENTATIVE_AUTHORIZATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DocumentUploadInputDtoTypeEnum>
    _$documentUploadInputDtoTypeEnumValues = BuiltSet<
        DocumentUploadInputDtoTypeEnum>(const <DocumentUploadInputDtoTypeEnum>[
  _$documentUploadInputDtoTypeEnum_BUSINESS_REGISTRATION,
  _$documentUploadInputDtoTypeEnum_TRANSPORT_LICENSE,
  _$documentUploadInputDtoTypeEnum_REPRESENTATIVE_AUTHORIZATION,
]);

const DocumentUploadInputDtoContentTypeEnum
    _$documentUploadInputDtoContentTypeEnum_applicationSlashPdf =
    const DocumentUploadInputDtoContentTypeEnum._('applicationSlashPdf');
const DocumentUploadInputDtoContentTypeEnum
    _$documentUploadInputDtoContentTypeEnum_imageSlashJpeg =
    const DocumentUploadInputDtoContentTypeEnum._('imageSlashJpeg');
const DocumentUploadInputDtoContentTypeEnum
    _$documentUploadInputDtoContentTypeEnum_imageSlashPng =
    const DocumentUploadInputDtoContentTypeEnum._('imageSlashPng');

DocumentUploadInputDtoContentTypeEnum
    _$documentUploadInputDtoContentTypeEnumValueOf(String name) {
  switch (name) {
    case 'applicationSlashPdf':
      return _$documentUploadInputDtoContentTypeEnum_applicationSlashPdf;
    case 'imageSlashJpeg':
      return _$documentUploadInputDtoContentTypeEnum_imageSlashJpeg;
    case 'imageSlashPng':
      return _$documentUploadInputDtoContentTypeEnum_imageSlashPng;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DocumentUploadInputDtoContentTypeEnum>
    _$documentUploadInputDtoContentTypeEnumValues = BuiltSet<
        DocumentUploadInputDtoContentTypeEnum>(const <DocumentUploadInputDtoContentTypeEnum>[
  _$documentUploadInputDtoContentTypeEnum_applicationSlashPdf,
  _$documentUploadInputDtoContentTypeEnum_imageSlashJpeg,
  _$documentUploadInputDtoContentTypeEnum_imageSlashPng,
]);

Serializer<DocumentUploadInputDtoTypeEnum>
    _$documentUploadInputDtoTypeEnumSerializer =
    _$DocumentUploadInputDtoTypeEnumSerializer();
Serializer<DocumentUploadInputDtoContentTypeEnum>
    _$documentUploadInputDtoContentTypeEnumSerializer =
    _$DocumentUploadInputDtoContentTypeEnumSerializer();

class _$DocumentUploadInputDtoTypeEnumSerializer
    implements PrimitiveSerializer<DocumentUploadInputDtoTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUSINESS_REGISTRATION': 'BUSINESS_REGISTRATION',
    'TRANSPORT_LICENSE': 'TRANSPORT_LICENSE',
    'REPRESENTATIVE_AUTHORIZATION': 'REPRESENTATIVE_AUTHORIZATION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUSINESS_REGISTRATION': 'BUSINESS_REGISTRATION',
    'TRANSPORT_LICENSE': 'TRANSPORT_LICENSE',
    'REPRESENTATIVE_AUTHORIZATION': 'REPRESENTATIVE_AUTHORIZATION',
  };

  @override
  final Iterable<Type> types = const <Type>[DocumentUploadInputDtoTypeEnum];
  @override
  final String wireName = 'DocumentUploadInputDtoTypeEnum';

  @override
  Object serialize(
          Serializers serializers, DocumentUploadInputDtoTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DocumentUploadInputDtoTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DocumentUploadInputDtoTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DocumentUploadInputDtoContentTypeEnumSerializer
    implements PrimitiveSerializer<DocumentUploadInputDtoContentTypeEnum> {
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
    DocumentUploadInputDtoContentTypeEnum
  ];
  @override
  final String wireName = 'DocumentUploadInputDtoContentTypeEnum';

  @override
  Object serialize(
          Serializers serializers, DocumentUploadInputDtoContentTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DocumentUploadInputDtoContentTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DocumentUploadInputDtoContentTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DocumentUploadInputDto extends DocumentUploadInputDto {
  @override
  final DocumentUploadInputDtoTypeEnum type;
  @override
  final DocumentUploadInputDtoContentTypeEnum contentType;
  @override
  final int sizeBytes;
  @override
  final String fileName;

  factory _$DocumentUploadInputDto(
          [void Function(DocumentUploadInputDtoBuilder)? updates]) =>
      (DocumentUploadInputDtoBuilder()..update(updates))._build();

  _$DocumentUploadInputDto._(
      {required this.type,
      required this.contentType,
      required this.sizeBytes,
      required this.fileName})
      : super._();
  @override
  DocumentUploadInputDto rebuild(
          void Function(DocumentUploadInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DocumentUploadInputDtoBuilder toBuilder() =>
      DocumentUploadInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DocumentUploadInputDto &&
        type == other.type &&
        contentType == other.contentType &&
        sizeBytes == other.sizeBytes &&
        fileName == other.fileName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DocumentUploadInputDto')
          ..add('type', type)
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes)
          ..add('fileName', fileName))
        .toString();
  }
}

class DocumentUploadInputDtoBuilder
    implements Builder<DocumentUploadInputDto, DocumentUploadInputDtoBuilder> {
  _$DocumentUploadInputDto? _$v;

  DocumentUploadInputDtoTypeEnum? _type;
  DocumentUploadInputDtoTypeEnum? get type => _$this._type;
  set type(DocumentUploadInputDtoTypeEnum? type) => _$this._type = type;

  DocumentUploadInputDtoContentTypeEnum? _contentType;
  DocumentUploadInputDtoContentTypeEnum? get contentType => _$this._contentType;
  set contentType(DocumentUploadInputDtoContentTypeEnum? contentType) =>
      _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  DocumentUploadInputDtoBuilder() {
    DocumentUploadInputDto._defaults(this);
  }

  DocumentUploadInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _fileName = $v.fileName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DocumentUploadInputDto other) {
    _$v = other as _$DocumentUploadInputDto;
  }

  @override
  void update(void Function(DocumentUploadInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DocumentUploadInputDto build() => _build();

  _$DocumentUploadInputDto _build() {
    final _$result = _$v ??
        _$DocumentUploadInputDto._(
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'DocumentUploadInputDto', 'type'),
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'DocumentUploadInputDto', 'contentType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'DocumentUploadInputDto', 'sizeBytes'),
          fileName: BuiltValueNullFieldError.checkNotNull(
              fileName, r'DocumentUploadInputDto', 'fileName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
