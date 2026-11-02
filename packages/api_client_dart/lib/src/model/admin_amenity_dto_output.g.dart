// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_amenity_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminAmenityDtoOutputStatusEnum _$adminAmenityDtoOutputStatusEnum_ACTIVE =
    const AdminAmenityDtoOutputStatusEnum._('ACTIVE');
const AdminAmenityDtoOutputStatusEnum
    _$adminAmenityDtoOutputStatusEnum_INACTIVE =
    const AdminAmenityDtoOutputStatusEnum._('INACTIVE');

AdminAmenityDtoOutputStatusEnum _$adminAmenityDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminAmenityDtoOutputStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminAmenityDtoOutputStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminAmenityDtoOutputStatusEnum>
    _$adminAmenityDtoOutputStatusEnumValues = BuiltSet<
        AdminAmenityDtoOutputStatusEnum>(const <AdminAmenityDtoOutputStatusEnum>[
  _$adminAmenityDtoOutputStatusEnum_ACTIVE,
  _$adminAmenityDtoOutputStatusEnum_INACTIVE,
]);

Serializer<AdminAmenityDtoOutputStatusEnum>
    _$adminAmenityDtoOutputStatusEnumSerializer =
    _$AdminAmenityDtoOutputStatusEnumSerializer();

class _$AdminAmenityDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminAmenityDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminAmenityDtoOutputStatusEnum];
  @override
  final String wireName = 'AdminAmenityDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AdminAmenityDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminAmenityDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminAmenityDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminAmenityDtoOutput extends AdminAmenityDtoOutput {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final AdminAmenityDtoOutputStatusEnum status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final int vehicleCount;

  factory _$AdminAmenityDtoOutput(
          [void Function(AdminAmenityDtoOutputBuilder)? updates]) =>
      (AdminAmenityDtoOutputBuilder()..update(updates))._build();

  _$AdminAmenityDtoOutput._(
      {required this.id,
      required this.code,
      required this.name,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.vehicleCount})
      : super._();
  @override
  AdminAmenityDtoOutput rebuild(
          void Function(AdminAmenityDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAmenityDtoOutputBuilder toBuilder() =>
      AdminAmenityDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAmenityDtoOutput &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        status == other.status &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        vehicleCount == other.vehicleCount;
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
    _$hash = $jc(_$hash, vehicleCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminAmenityDtoOutput')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('vehicleCount', vehicleCount))
        .toString();
  }
}

class AdminAmenityDtoOutputBuilder
    implements Builder<AdminAmenityDtoOutput, AdminAmenityDtoOutputBuilder> {
  _$AdminAmenityDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminAmenityDtoOutputStatusEnum? _status;
  AdminAmenityDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminAmenityDtoOutputStatusEnum? status) =>
      _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  int? _vehicleCount;
  int? get vehicleCount => _$this._vehicleCount;
  set vehicleCount(int? vehicleCount) => _$this._vehicleCount = vehicleCount;

  AdminAmenityDtoOutputBuilder() {
    AdminAmenityDtoOutput._defaults(this);
  }

  AdminAmenityDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _vehicleCount = $v.vehicleCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAmenityDtoOutput other) {
    _$v = other as _$AdminAmenityDtoOutput;
  }

  @override
  void update(void Function(AdminAmenityDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAmenityDtoOutput build() => _build();

  _$AdminAmenityDtoOutput _build() {
    final _$result = _$v ??
        _$AdminAmenityDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminAmenityDtoOutput', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AdminAmenityDtoOutput', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminAmenityDtoOutput', 'name'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminAmenityDtoOutput', 'status'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminAmenityDtoOutput', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'AdminAmenityDtoOutput', 'updatedAt'),
          vehicleCount: BuiltValueNullFieldError.checkNotNull(
              vehicleCount, r'AdminAmenityDtoOutput', 'vehicleCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
