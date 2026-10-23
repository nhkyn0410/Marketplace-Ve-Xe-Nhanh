// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ward_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminWardDtoOutputStatusEnum _$adminWardDtoOutputStatusEnum_ACTIVE =
    const AdminWardDtoOutputStatusEnum._('ACTIVE');
const AdminWardDtoOutputStatusEnum _$adminWardDtoOutputStatusEnum_INACTIVE =
    const AdminWardDtoOutputStatusEnum._('INACTIVE');

AdminWardDtoOutputStatusEnum _$adminWardDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminWardDtoOutputStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminWardDtoOutputStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminWardDtoOutputStatusEnum>
    _$adminWardDtoOutputStatusEnumValues =
    BuiltSet<AdminWardDtoOutputStatusEnum>(const <AdminWardDtoOutputStatusEnum>[
  _$adminWardDtoOutputStatusEnum_ACTIVE,
  _$adminWardDtoOutputStatusEnum_INACTIVE,
]);

Serializer<AdminWardDtoOutputStatusEnum>
    _$adminWardDtoOutputStatusEnumSerializer =
    _$AdminWardDtoOutputStatusEnumSerializer();

class _$AdminWardDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminWardDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminWardDtoOutputStatusEnum];
  @override
  final String wireName = 'AdminWardDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers, AdminWardDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminWardDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminWardDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminWardDtoOutput extends AdminWardDtoOutput {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final AdminWardDtoOutputStatusEnum status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String provinceId;
  @override
  final String provinceName;
  @override
  final int stopPointCount;

  factory _$AdminWardDtoOutput(
          [void Function(AdminWardDtoOutputBuilder)? updates]) =>
      (AdminWardDtoOutputBuilder()..update(updates))._build();

  _$AdminWardDtoOutput._(
      {required this.id,
      required this.code,
      required this.name,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.provinceId,
      required this.provinceName,
      required this.stopPointCount})
      : super._();
  @override
  AdminWardDtoOutput rebuild(
          void Function(AdminWardDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminWardDtoOutputBuilder toBuilder() =>
      AdminWardDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminWardDtoOutput &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        status == other.status &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        provinceId == other.provinceId &&
        provinceName == other.provinceName &&
        stopPointCount == other.stopPointCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, provinceId.hashCode);
    _$hash = $jc(_$hash, provinceName.hashCode);
    _$hash = $jc(_$hash, stopPointCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminWardDtoOutput')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('provinceId', provinceId)
          ..add('provinceName', provinceName)
          ..add('stopPointCount', stopPointCount))
        .toString();
  }
}

class AdminWardDtoOutputBuilder
    implements Builder<AdminWardDtoOutput, AdminWardDtoOutputBuilder> {
  _$AdminWardDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminWardDtoOutputStatusEnum? _status;
  AdminWardDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminWardDtoOutputStatusEnum? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _provinceId;
  String? get provinceId => _$this._provinceId;
  set provinceId(String? provinceId) => _$this._provinceId = provinceId;

  String? _provinceName;
  String? get provinceName => _$this._provinceName;
  set provinceName(String? provinceName) => _$this._provinceName = provinceName;

  int? _stopPointCount;
  int? get stopPointCount => _$this._stopPointCount;
  set stopPointCount(int? stopPointCount) =>
      _$this._stopPointCount = stopPointCount;

  AdminWardDtoOutputBuilder() {
    AdminWardDtoOutput._defaults(this);
  }

  AdminWardDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _provinceId = $v.provinceId;
      _provinceName = $v.provinceName;
      _stopPointCount = $v.stopPointCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminWardDtoOutput other) {
    _$v = other as _$AdminWardDtoOutput;
  }

  @override
  void update(void Function(AdminWardDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminWardDtoOutput build() => _build();

  _$AdminWardDtoOutput _build() {
    final _$result = _$v ??
        _$AdminWardDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminWardDtoOutput', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AdminWardDtoOutput', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminWardDtoOutput', 'name'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminWardDtoOutput', 'status'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminWardDtoOutput', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'AdminWardDtoOutput', 'updatedAt'),
          provinceId: BuiltValueNullFieldError.checkNotNull(
              provinceId, r'AdminWardDtoOutput', 'provinceId'),
          provinceName: BuiltValueNullFieldError.checkNotNull(
              provinceName, r'AdminWardDtoOutput', 'provinceName'),
          stopPointCount: BuiltValueNullFieldError.checkNotNull(
              stopPointCount, r'AdminWardDtoOutput', 'stopPointCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
