// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_application_detail_dto_output_documents_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum
    _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnum_BUSINESS_REGISTRATION =
    const AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum._(
        'BUSINESS_REGISTRATION');
const AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum
    _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnum_TRANSPORT_LICENSE =
    const AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum._(
        'TRANSPORT_LICENSE');
const AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum
    _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnum_REPRESENTATIVE_AUTHORIZATION =
    const AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum._(
        'REPRESENTATIVE_AUTHORIZATION');

AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum
    _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'BUSINESS_REGISTRATION':
      return _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnum_BUSINESS_REGISTRATION;
    case 'TRANSPORT_LICENSE':
      return _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnum_TRANSPORT_LICENSE;
    case 'REPRESENTATIVE_AUTHORIZATION':
      return _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnum_REPRESENTATIVE_AUTHORIZATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum>
    _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnumValues = BuiltSet<
        AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum>(const <AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum>[
  _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnum_BUSINESS_REGISTRATION,
  _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnum_TRANSPORT_LICENSE,
  _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnum_REPRESENTATIVE_AUTHORIZATION,
]);

Serializer<AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum>
    _$adminApplicationDetailDtoOutputDocumentsInnerTypeEnumSerializer =
    _$AdminApplicationDetailDtoOutputDocumentsInnerTypeEnumSerializer();

class _$AdminApplicationDetailDtoOutputDocumentsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<
            AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum> {
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
    AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum
  ];
  @override
  final String wireName =
      'AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminApplicationDetailDtoOutputDocumentsInner
    extends AdminApplicationDetailDtoOutputDocumentsInner {
  @override
  final AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum type;
  @override
  final String fileName;
  @override
  final String contentType;
  @override
  final int sizeBytes;
  @override
  final DateTime uploadedAt;

  factory _$AdminApplicationDetailDtoOutputDocumentsInner(
          [void Function(AdminApplicationDetailDtoOutputDocumentsInnerBuilder)?
              updates]) =>
      (AdminApplicationDetailDtoOutputDocumentsInnerBuilder()..update(updates))
          ._build();

  _$AdminApplicationDetailDtoOutputDocumentsInner._(
      {required this.type,
      required this.fileName,
      required this.contentType,
      required this.sizeBytes,
      required this.uploadedAt})
      : super._();
  @override
  AdminApplicationDetailDtoOutputDocumentsInner rebuild(
          void Function(AdminApplicationDetailDtoOutputDocumentsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminApplicationDetailDtoOutputDocumentsInnerBuilder toBuilder() =>
      AdminApplicationDetailDtoOutputDocumentsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminApplicationDetailDtoOutputDocumentsInner &&
        type == other.type &&
        fileName == other.fileName &&
        contentType == other.contentType &&
        sizeBytes == other.sizeBytes &&
        uploadedAt == other.uploadedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
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
            r'AdminApplicationDetailDtoOutputDocumentsInner')
          ..add('type', type)
          ..add('fileName', fileName)
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes)
          ..add('uploadedAt', uploadedAt))
        .toString();
  }
}

class AdminApplicationDetailDtoOutputDocumentsInnerBuilder
    implements
        Builder<AdminApplicationDetailDtoOutputDocumentsInner,
            AdminApplicationDetailDtoOutputDocumentsInnerBuilder> {
  _$AdminApplicationDetailDtoOutputDocumentsInner? _$v;

  AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum? _type;
  AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum? get type =>
      _$this._type;
  set type(AdminApplicationDetailDtoOutputDocumentsInnerTypeEnum? type) =>
      _$this._type = type;

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

  AdminApplicationDetailDtoOutputDocumentsInnerBuilder() {
    AdminApplicationDetailDtoOutputDocumentsInner._defaults(this);
  }

  AdminApplicationDetailDtoOutputDocumentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _fileName = $v.fileName;
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _uploadedAt = $v.uploadedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminApplicationDetailDtoOutputDocumentsInner other) {
    _$v = other as _$AdminApplicationDetailDtoOutputDocumentsInner;
  }

  @override
  void update(
      void Function(AdminApplicationDetailDtoOutputDocumentsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminApplicationDetailDtoOutputDocumentsInner build() => _build();

  _$AdminApplicationDetailDtoOutputDocumentsInner _build() {
    final _$result = _$v ??
        _$AdminApplicationDetailDtoOutputDocumentsInner._(
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'AdminApplicationDetailDtoOutputDocumentsInner', 'type'),
          fileName: BuiltValueNullFieldError.checkNotNull(fileName,
              r'AdminApplicationDetailDtoOutputDocumentsInner', 'fileName'),
          contentType: BuiltValueNullFieldError.checkNotNull(contentType,
              r'AdminApplicationDetailDtoOutputDocumentsInner', 'contentType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(sizeBytes,
              r'AdminApplicationDetailDtoOutputDocumentsInner', 'sizeBytes'),
          uploadedAt: BuiltValueNullFieldError.checkNotNull(uploadedAt,
              r'AdminApplicationDetailDtoOutputDocumentsInner', 'uploadedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
