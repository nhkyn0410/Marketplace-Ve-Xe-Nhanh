// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_response_dto_output_documents_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApplicationResponseDtoOutputDocumentsInnerTypeEnum
    _$applicationResponseDtoOutputDocumentsInnerTypeEnum_BUSINESS_REGISTRATION =
    const ApplicationResponseDtoOutputDocumentsInnerTypeEnum._(
        'BUSINESS_REGISTRATION');
const ApplicationResponseDtoOutputDocumentsInnerTypeEnum
    _$applicationResponseDtoOutputDocumentsInnerTypeEnum_TRANSPORT_LICENSE =
    const ApplicationResponseDtoOutputDocumentsInnerTypeEnum._(
        'TRANSPORT_LICENSE');
const ApplicationResponseDtoOutputDocumentsInnerTypeEnum
    _$applicationResponseDtoOutputDocumentsInnerTypeEnum_REPRESENTATIVE_AUTHORIZATION =
    const ApplicationResponseDtoOutputDocumentsInnerTypeEnum._(
        'REPRESENTATIVE_AUTHORIZATION');

ApplicationResponseDtoOutputDocumentsInnerTypeEnum
    _$applicationResponseDtoOutputDocumentsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'BUSINESS_REGISTRATION':
      return _$applicationResponseDtoOutputDocumentsInnerTypeEnum_BUSINESS_REGISTRATION;
    case 'TRANSPORT_LICENSE':
      return _$applicationResponseDtoOutputDocumentsInnerTypeEnum_TRANSPORT_LICENSE;
    case 'REPRESENTATIVE_AUTHORIZATION':
      return _$applicationResponseDtoOutputDocumentsInnerTypeEnum_REPRESENTATIVE_AUTHORIZATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApplicationResponseDtoOutputDocumentsInnerTypeEnum>
    _$applicationResponseDtoOutputDocumentsInnerTypeEnumValues = BuiltSet<
        ApplicationResponseDtoOutputDocumentsInnerTypeEnum>(const <ApplicationResponseDtoOutputDocumentsInnerTypeEnum>[
  _$applicationResponseDtoOutputDocumentsInnerTypeEnum_BUSINESS_REGISTRATION,
  _$applicationResponseDtoOutputDocumentsInnerTypeEnum_TRANSPORT_LICENSE,
  _$applicationResponseDtoOutputDocumentsInnerTypeEnum_REPRESENTATIVE_AUTHORIZATION,
]);

Serializer<ApplicationResponseDtoOutputDocumentsInnerTypeEnum>
    _$applicationResponseDtoOutputDocumentsInnerTypeEnumSerializer =
    _$ApplicationResponseDtoOutputDocumentsInnerTypeEnumSerializer();

class _$ApplicationResponseDtoOutputDocumentsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<
            ApplicationResponseDtoOutputDocumentsInnerTypeEnum> {
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
  final Iterable<Type> types = const <Type>[
    ApplicationResponseDtoOutputDocumentsInnerTypeEnum
  ];
  @override
  final String wireName = 'ApplicationResponseDtoOutputDocumentsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          ApplicationResponseDtoOutputDocumentsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApplicationResponseDtoOutputDocumentsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApplicationResponseDtoOutputDocumentsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApplicationResponseDtoOutputDocumentsInner
    extends ApplicationResponseDtoOutputDocumentsInner {
  @override
  final ApplicationResponseDtoOutputDocumentsInnerTypeEnum type;
  @override
  final String objectKey;
  @override
  final String fileName;
  @override
  final String contentType;
  @override
  final int sizeBytes;
  @override
  final DateTime uploadedAt;

  factory _$ApplicationResponseDtoOutputDocumentsInner(
          [void Function(ApplicationResponseDtoOutputDocumentsInnerBuilder)?
              updates]) =>
      (ApplicationResponseDtoOutputDocumentsInnerBuilder()..update(updates))
          ._build();

  _$ApplicationResponseDtoOutputDocumentsInner._(
      {required this.type,
      required this.objectKey,
      required this.fileName,
      required this.contentType,
      required this.sizeBytes,
      required this.uploadedAt})
      : super._();
  @override
  ApplicationResponseDtoOutputDocumentsInner rebuild(
          void Function(ApplicationResponseDtoOutputDocumentsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApplicationResponseDtoOutputDocumentsInnerBuilder toBuilder() =>
      ApplicationResponseDtoOutputDocumentsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApplicationResponseDtoOutputDocumentsInner &&
        type == other.type &&
        objectKey == other.objectKey &&
        fileName == other.fileName &&
        contentType == other.contentType &&
        sizeBytes == other.sizeBytes &&
        uploadedAt == other.uploadedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, objectKey.hashCode);
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jc(_$hash, uploadedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApplicationResponseDtoOutputDocumentsInner')
          ..add('type', type)
          ..add('objectKey', objectKey)
          ..add('fileName', fileName)
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes)
          ..add('uploadedAt', uploadedAt))
        .toString();
  }
}

class ApplicationResponseDtoOutputDocumentsInnerBuilder
    implements
        Builder<ApplicationResponseDtoOutputDocumentsInner,
            ApplicationResponseDtoOutputDocumentsInnerBuilder> {
  _$ApplicationResponseDtoOutputDocumentsInner? _$v;

  ApplicationResponseDtoOutputDocumentsInnerTypeEnum? _type;
  ApplicationResponseDtoOutputDocumentsInnerTypeEnum? get type => _$this._type;
  set type(ApplicationResponseDtoOutputDocumentsInnerTypeEnum? type) =>
      _$this._type = type;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  DateTime? _uploadedAt;
  DateTime? get uploadedAt => _$this._uploadedAt;
  set uploadedAt(DateTime? uploadedAt) => _$this._uploadedAt = uploadedAt;

  ApplicationResponseDtoOutputDocumentsInnerBuilder() {
    ApplicationResponseDtoOutputDocumentsInner._defaults(this);
  }

  ApplicationResponseDtoOutputDocumentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _objectKey = $v.objectKey;
      _fileName = $v.fileName;
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _uploadedAt = $v.uploadedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApplicationResponseDtoOutputDocumentsInner other) {
    _$v = other as _$ApplicationResponseDtoOutputDocumentsInner;
  }

  @override
  void update(
      void Function(ApplicationResponseDtoOutputDocumentsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApplicationResponseDtoOutputDocumentsInner build() => _build();

  _$ApplicationResponseDtoOutputDocumentsInner _build() {
    final _$result = _$v ??
        _$ApplicationResponseDtoOutputDocumentsInner._(
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'ApplicationResponseDtoOutputDocumentsInner', 'type'),
          objectKey: BuiltValueNullFieldError.checkNotNull(objectKey,
              r'ApplicationResponseDtoOutputDocumentsInner', 'objectKey'),
          fileName: BuiltValueNullFieldError.checkNotNull(fileName,
              r'ApplicationResponseDtoOutputDocumentsInner', 'fileName'),
          contentType: BuiltValueNullFieldError.checkNotNull(contentType,
              r'ApplicationResponseDtoOutputDocumentsInner', 'contentType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(sizeBytes,
              r'ApplicationResponseDtoOutputDocumentsInner', 'sizeBytes'),
          uploadedAt: BuiltValueNullFieldError.checkNotNull(uploadedAt,
              r'ApplicationResponseDtoOutputDocumentsInner', 'uploadedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
