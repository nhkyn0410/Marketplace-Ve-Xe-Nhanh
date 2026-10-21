// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_province_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminProvinceDtoOutputStatusEnum
    _$adminProvinceDtoOutputStatusEnum_ACTIVE =
    const AdminProvinceDtoOutputStatusEnum._('ACTIVE');
const AdminProvinceDtoOutputStatusEnum
    _$adminProvinceDtoOutputStatusEnum_INACTIVE =
    const AdminProvinceDtoOutputStatusEnum._('INACTIVE');

AdminProvinceDtoOutputStatusEnum _$adminProvinceDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminProvinceDtoOutputStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminProvinceDtoOutputStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminProvinceDtoOutputStatusEnum>
    _$adminProvinceDtoOutputStatusEnumValues = BuiltSet<
        AdminProvinceDtoOutputStatusEnum>(const <AdminProvinceDtoOutputStatusEnum>[
  _$adminProvinceDtoOutputStatusEnum_ACTIVE,
  _$adminProvinceDtoOutputStatusEnum_INACTIVE,
]);

Serializer<AdminProvinceDtoOutputStatusEnum>
    _$adminProvinceDtoOutputStatusEnumSerializer =
    _$AdminProvinceDtoOutputStatusEnumSerializer();

class _$AdminProvinceDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminProvinceDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminProvinceDtoOutputStatusEnum];
  @override
  final String wireName = 'AdminProvinceDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AdminProvinceDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminProvinceDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminProvinceDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminProvinceDtoOutput extends AdminProvinceDtoOutput {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final AdminProvinceDtoOutputStatusEnum status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final int wardCount;
  @override
  final int stopPointCount;

  factory _$AdminProvinceDtoOutput(
          [void Function(AdminProvinceDtoOutputBuilder)? updates]) =>
      (AdminProvinceDtoOutputBuilder()..update(updates))._build();

  _$AdminProvinceDtoOutput._(
      {required this.id,
      required this.code,
      required this.name,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.wardCount,
      required this.stopPointCount})
      : super._();
  @override
  AdminProvinceDtoOutput rebuild(
          void Function(AdminProvinceDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminProvinceDtoOutputBuilder toBuilder() =>
      AdminProvinceDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminProvinceDtoOutput &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        status == other.status &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        wardCount == other.wardCount &&
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
    _$hash = $jc(_$hash, wardCount.hashCode);
    _$hash = $jc(_$hash, stopPointCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminProvinceDtoOutput')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('wardCount', wardCount)
          ..add('stopPointCount', stopPointCount))
        .toString();
  }
}

class AdminProvinceDtoOutputBuilder
    implements Builder<AdminProvinceDtoOutput, AdminProvinceDtoOutputBuilder> {
  _$AdminProvinceDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminProvinceDtoOutputStatusEnum? _status;
  AdminProvinceDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminProvinceDtoOutputStatusEnum? status) =>
      _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  int? _wardCount;
  int? get wardCount => _$this._wardCount;
  set wardCount(int? wardCount) => _$this._wardCount = wardCount;

  int? _stopPointCount;
  int? get stopPointCount => _$this._stopPointCount;
  set stopPointCount(int? stopPointCount) =>
      _$this._stopPointCount = stopPointCount;

  AdminProvinceDtoOutputBuilder() {
    AdminProvinceDtoOutput._defaults(this);
  }

  AdminProvinceDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _wardCount = $v.wardCount;
      _stopPointCount = $v.stopPointCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminProvinceDtoOutput other) {
    _$v = other as _$AdminProvinceDtoOutput;
  }

  @override
  void update(void Function(AdminProvinceDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminProvinceDtoOutput build() => _build();

  _$AdminProvinceDtoOutput _build() {
    final _$result = _$v ??
        _$AdminProvinceDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminProvinceDtoOutput', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AdminProvinceDtoOutput', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminProvinceDtoOutput', 'name'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminProvinceDtoOutput', 'status'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminProvinceDtoOutput', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'AdminProvinceDtoOutput', 'updatedAt'),
          wardCount: BuiltValueNullFieldError.checkNotNull(
              wardCount, r'AdminProvinceDtoOutput', 'wardCount'),
          stopPointCount: BuiltValueNullFieldError.checkNotNull(
              stopPointCount, r'AdminProvinceDtoOutput', 'stopPointCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
