// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_update_input_dto_documents_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApplicationUpdateInputDtoDocumentsInnerTypeEnum
    _$applicationUpdateInputDtoDocumentsInnerTypeEnum_BUSINESS_REGISTRATION =
    const ApplicationUpdateInputDtoDocumentsInnerTypeEnum._(
        'BUSINESS_REGISTRATION');
const ApplicationUpdateInputDtoDocumentsInnerTypeEnum
    _$applicationUpdateInputDtoDocumentsInnerTypeEnum_TRANSPORT_LICENSE =
    const ApplicationUpdateInputDtoDocumentsInnerTypeEnum._(
        'TRANSPORT_LICENSE');
const ApplicationUpdateInputDtoDocumentsInnerTypeEnum
    _$applicationUpdateInputDtoDocumentsInnerTypeEnum_REPRESENTATIVE_AUTHORIZATION =
    const ApplicationUpdateInputDtoDocumentsInnerTypeEnum._(
        'REPRESENTATIVE_AUTHORIZATION');

ApplicationUpdateInputDtoDocumentsInnerTypeEnum
    _$applicationUpdateInputDtoDocumentsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'BUSINESS_REGISTRATION':
      return _$applicationUpdateInputDtoDocumentsInnerTypeEnum_BUSINESS_REGISTRATION;
    case 'TRANSPORT_LICENSE':
      return _$applicationUpdateInputDtoDocumentsInnerTypeEnum_TRANSPORT_LICENSE;
    case 'REPRESENTATIVE_AUTHORIZATION':
      return _$applicationUpdateInputDtoDocumentsInnerTypeEnum_REPRESENTATIVE_AUTHORIZATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApplicationUpdateInputDtoDocumentsInnerTypeEnum>
    _$applicationUpdateInputDtoDocumentsInnerTypeEnumValues = BuiltSet<
        ApplicationUpdateInputDtoDocumentsInnerTypeEnum>(const <ApplicationUpdateInputDtoDocumentsInnerTypeEnum>[
  _$applicationUpdateInputDtoDocumentsInnerTypeEnum_BUSINESS_REGISTRATION,
  _$applicationUpdateInputDtoDocumentsInnerTypeEnum_TRANSPORT_LICENSE,
  _$applicationUpdateInputDtoDocumentsInnerTypeEnum_REPRESENTATIVE_AUTHORIZATION,
]);

Serializer<ApplicationUpdateInputDtoDocumentsInnerTypeEnum>
    _$applicationUpdateInputDtoDocumentsInnerTypeEnumSerializer =
    _$ApplicationUpdateInputDtoDocumentsInnerTypeEnumSerializer();

class _$ApplicationUpdateInputDtoDocumentsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<ApplicationUpdateInputDtoDocumentsInnerTypeEnum> {
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
    ApplicationUpdateInputDtoDocumentsInnerTypeEnum
  ];
  @override
  final String wireName = 'ApplicationUpdateInputDtoDocumentsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          ApplicationUpdateInputDtoDocumentsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApplicationUpdateInputDtoDocumentsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApplicationUpdateInputDtoDocumentsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApplicationUpdateInputDtoDocumentsInner
    extends ApplicationUpdateInputDtoDocumentsInner {
  @override
  final ApplicationUpdateInputDtoDocumentsInnerTypeEnum type;
  @override
  final String objectKey;
  @override
  final String fileName;

  factory _$ApplicationUpdateInputDtoDocumentsInner(
          [void Function(ApplicationUpdateInputDtoDocumentsInnerBuilder)?
              updates]) =>
      (ApplicationUpdateInputDtoDocumentsInnerBuilder()..update(updates))
          ._build();

  _$ApplicationUpdateInputDtoDocumentsInner._(
      {required this.type, required this.objectKey, required this.fileName})
      : super._();
  @override
  ApplicationUpdateInputDtoDocumentsInner rebuild(
          void Function(ApplicationUpdateInputDtoDocumentsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApplicationUpdateInputDtoDocumentsInnerBuilder toBuilder() =>
      ApplicationUpdateInputDtoDocumentsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApplicationUpdateInputDtoDocumentsInner &&
        type == other.type &&
        objectKey == other.objectKey &&
        fileName == other.fileName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, objectKey.hashCode);
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApplicationUpdateInputDtoDocumentsInner')
          ..add('type', type)
          ..add('objectKey', objectKey)
          ..add('fileName', fileName))
        .toString();
  }
}

class ApplicationUpdateInputDtoDocumentsInnerBuilder
    implements
        Builder<ApplicationUpdateInputDtoDocumentsInner,
            ApplicationUpdateInputDtoDocumentsInnerBuilder> {
  _$ApplicationUpdateInputDtoDocumentsInner? _$v;

  ApplicationUpdateInputDtoDocumentsInnerTypeEnum? _type;
  ApplicationUpdateInputDtoDocumentsInnerTypeEnum? get type => _$this._type;
  set type(ApplicationUpdateInputDtoDocumentsInnerTypeEnum? type) =>
      _$this._type = type;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  ApplicationUpdateInputDtoDocumentsInnerBuilder() {
    ApplicationUpdateInputDtoDocumentsInner._defaults(this);
  }

  ApplicationUpdateInputDtoDocumentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _objectKey = $v.objectKey;
      _fileName = $v.fileName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApplicationUpdateInputDtoDocumentsInner other) {
    _$v = other as _$ApplicationUpdateInputDtoDocumentsInner;
  }

  @override
  void update(
      void Function(ApplicationUpdateInputDtoDocumentsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApplicationUpdateInputDtoDocumentsInner build() => _build();

  _$ApplicationUpdateInputDtoDocumentsInner _build() {
    final _$result = _$v ??
        _$ApplicationUpdateInputDtoDocumentsInner._(
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'ApplicationUpdateInputDtoDocumentsInner', 'type'),
          objectKey: BuiltValueNullFieldError.checkNotNull(objectKey,
              r'ApplicationUpdateInputDtoDocumentsInner', 'objectKey'),
          fileName: BuiltValueNullFieldError.checkNotNull(
              fileName, r'ApplicationUpdateInputDtoDocumentsInner', 'fileName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
