// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_vehicle_type_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminVehicleTypeDtoOutputStatusEnum
    _$adminVehicleTypeDtoOutputStatusEnum_ACTIVE =
    const AdminVehicleTypeDtoOutputStatusEnum._('ACTIVE');
const AdminVehicleTypeDtoOutputStatusEnum
    _$adminVehicleTypeDtoOutputStatusEnum_INACTIVE =
    const AdminVehicleTypeDtoOutputStatusEnum._('INACTIVE');

AdminVehicleTypeDtoOutputStatusEnum
    _$adminVehicleTypeDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminVehicleTypeDtoOutputStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminVehicleTypeDtoOutputStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminVehicleTypeDtoOutputStatusEnum>
    _$adminVehicleTypeDtoOutputStatusEnumValues = BuiltSet<
        AdminVehicleTypeDtoOutputStatusEnum>(const <AdminVehicleTypeDtoOutputStatusEnum>[
  _$adminVehicleTypeDtoOutputStatusEnum_ACTIVE,
  _$adminVehicleTypeDtoOutputStatusEnum_INACTIVE,
]);

const AdminVehicleTypeDtoOutputFormEnum
    _$adminVehicleTypeDtoOutputFormEnum_SEATER =
    const AdminVehicleTypeDtoOutputFormEnum._('SEATER');
const AdminVehicleTypeDtoOutputFormEnum
    _$adminVehicleTypeDtoOutputFormEnum_SLEEPER =
    const AdminVehicleTypeDtoOutputFormEnum._('SLEEPER');
const AdminVehicleTypeDtoOutputFormEnum
    _$adminVehicleTypeDtoOutputFormEnum_CABIN =
    const AdminVehicleTypeDtoOutputFormEnum._('CABIN');

AdminVehicleTypeDtoOutputFormEnum _$adminVehicleTypeDtoOutputFormEnumValueOf(
    String name) {
  switch (name) {
    case 'SEATER':
      return _$adminVehicleTypeDtoOutputFormEnum_SEATER;
    case 'SLEEPER':
      return _$adminVehicleTypeDtoOutputFormEnum_SLEEPER;
    case 'CABIN':
      return _$adminVehicleTypeDtoOutputFormEnum_CABIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminVehicleTypeDtoOutputFormEnum>
    _$adminVehicleTypeDtoOutputFormEnumValues = BuiltSet<
        AdminVehicleTypeDtoOutputFormEnum>(const <AdminVehicleTypeDtoOutputFormEnum>[
  _$adminVehicleTypeDtoOutputFormEnum_SEATER,
  _$adminVehicleTypeDtoOutputFormEnum_SLEEPER,
  _$adminVehicleTypeDtoOutputFormEnum_CABIN,
]);

const AdminVehicleTypeDtoOutputClass_Enum
    _$adminVehicleTypeDtoOutputClassEnum_STANDARD =
    const AdminVehicleTypeDtoOutputClass_Enum._('STANDARD');
const AdminVehicleTypeDtoOutputClass_Enum
    _$adminVehicleTypeDtoOutputClassEnum_LIMOUSINE =
    const AdminVehicleTypeDtoOutputClass_Enum._('LIMOUSINE');

AdminVehicleTypeDtoOutputClass_Enum _$adminVehicleTypeDtoOutputClassEnumValueOf(
    String name) {
  switch (name) {
    case 'STANDARD':
      return _$adminVehicleTypeDtoOutputClassEnum_STANDARD;
    case 'LIMOUSINE':
      return _$adminVehicleTypeDtoOutputClassEnum_LIMOUSINE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminVehicleTypeDtoOutputClass_Enum>
    _$adminVehicleTypeDtoOutputClassEnumValues = BuiltSet<
        AdminVehicleTypeDtoOutputClass_Enum>(const <AdminVehicleTypeDtoOutputClass_Enum>[
  _$adminVehicleTypeDtoOutputClassEnum_STANDARD,
  _$adminVehicleTypeDtoOutputClassEnum_LIMOUSINE,
]);

Serializer<AdminVehicleTypeDtoOutputStatusEnum>
    _$adminVehicleTypeDtoOutputStatusEnumSerializer =
    _$AdminVehicleTypeDtoOutputStatusEnumSerializer();
Serializer<AdminVehicleTypeDtoOutputFormEnum>
    _$adminVehicleTypeDtoOutputFormEnumSerializer =
    _$AdminVehicleTypeDtoOutputFormEnumSerializer();
Serializer<AdminVehicleTypeDtoOutputClass_Enum>
    _$adminVehicleTypeDtoOutputClassEnumSerializer =
    _$AdminVehicleTypeDtoOutputClass_EnumSerializer();

class _$AdminVehicleTypeDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminVehicleTypeDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminVehicleTypeDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'AdminVehicleTypeDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AdminVehicleTypeDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminVehicleTypeDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminVehicleTypeDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminVehicleTypeDtoOutputFormEnumSerializer
    implements PrimitiveSerializer<AdminVehicleTypeDtoOutputFormEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SEATER': 'SEATER',
    'SLEEPER': 'SLEEPER',
    'CABIN': 'CABIN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SEATER': 'SEATER',
    'SLEEPER': 'SLEEPER',
    'CABIN': 'CABIN',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminVehicleTypeDtoOutputFormEnum];
  @override
  final String wireName = 'AdminVehicleTypeDtoOutputFormEnum';

  @override
  Object serialize(
          Serializers serializers, AdminVehicleTypeDtoOutputFormEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminVehicleTypeDtoOutputFormEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminVehicleTypeDtoOutputFormEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminVehicleTypeDtoOutputClass_EnumSerializer
    implements PrimitiveSerializer<AdminVehicleTypeDtoOutputClass_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'STANDARD': 'STANDARD',
    'LIMOUSINE': 'LIMOUSINE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'STANDARD': 'STANDARD',
    'LIMOUSINE': 'LIMOUSINE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminVehicleTypeDtoOutputClass_Enum
  ];
  @override
  final String wireName = 'AdminVehicleTypeDtoOutputClass_Enum';

  @override
  Object serialize(
          Serializers serializers, AdminVehicleTypeDtoOutputClass_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminVehicleTypeDtoOutputClass_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminVehicleTypeDtoOutputClass_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminVehicleTypeDtoOutput extends AdminVehicleTypeDtoOutput {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final AdminVehicleTypeDtoOutputStatusEnum status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? description;
  @override
  final AdminVehicleTypeDtoOutputFormEnum form;
  @override
  final AdminVehicleTypeDtoOutputClass_Enum class_;
  @override
  final int vehicleCount;
  @override
  final int operatorCount;
  @override
  final int fareRuleCount;

  factory _$AdminVehicleTypeDtoOutput(
          [void Function(AdminVehicleTypeDtoOutputBuilder)? updates]) =>
      (AdminVehicleTypeDtoOutputBuilder()..update(updates))._build();

  _$AdminVehicleTypeDtoOutput._(
      {required this.id,
      required this.code,
      required this.name,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.description,
      required this.form,
      required this.class_,
      required this.vehicleCount,
      required this.operatorCount,
      required this.fareRuleCount})
      : super._();
  @override
  AdminVehicleTypeDtoOutput rebuild(
          void Function(AdminVehicleTypeDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminVehicleTypeDtoOutputBuilder toBuilder() =>
      AdminVehicleTypeDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminVehicleTypeDtoOutput &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        status == other.status &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        description == other.description &&
        form == other.form &&
        class_ == other.class_ &&
        vehicleCount == other.vehicleCount &&
        operatorCount == other.operatorCount &&
        fareRuleCount == other.fareRuleCount;
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
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, form.hashCode);
    _$hash = $jc(_$hash, class_.hashCode);
    _$hash = $jc(_$hash, vehicleCount.hashCode);
    _$hash = $jc(_$hash, operatorCount.hashCode);
    _$hash = $jc(_$hash, fareRuleCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminVehicleTypeDtoOutput')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('description', description)
          ..add('form', form)
          ..add('class_', class_)
          ..add('vehicleCount', vehicleCount)
          ..add('operatorCount', operatorCount)
          ..add('fareRuleCount', fareRuleCount))
        .toString();
  }
}

class AdminVehicleTypeDtoOutputBuilder
    implements
        Builder<AdminVehicleTypeDtoOutput, AdminVehicleTypeDtoOutputBuilder> {
  _$AdminVehicleTypeDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminVehicleTypeDtoOutputStatusEnum? _status;
  AdminVehicleTypeDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminVehicleTypeDtoOutputStatusEnum? status) =>
      _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  AdminVehicleTypeDtoOutputFormEnum? _form;
  AdminVehicleTypeDtoOutputFormEnum? get form => _$this._form;
  set form(AdminVehicleTypeDtoOutputFormEnum? form) => _$this._form = form;

  AdminVehicleTypeDtoOutputClass_Enum? _class_;
  AdminVehicleTypeDtoOutputClass_Enum? get class_ => _$this._class_;
  set class_(AdminVehicleTypeDtoOutputClass_Enum? class_) =>
      _$this._class_ = class_;

  int? _vehicleCount;
  int? get vehicleCount => _$this._vehicleCount;
  set vehicleCount(int? vehicleCount) => _$this._vehicleCount = vehicleCount;

  int? _operatorCount;
  int? get operatorCount => _$this._operatorCount;
  set operatorCount(int? operatorCount) =>
      _$this._operatorCount = operatorCount;

  int? _fareRuleCount;
  int? get fareRuleCount => _$this._fareRuleCount;
  set fareRuleCount(int? fareRuleCount) =>
      _$this._fareRuleCount = fareRuleCount;

  AdminVehicleTypeDtoOutputBuilder() {
    AdminVehicleTypeDtoOutput._defaults(this);
  }

  AdminVehicleTypeDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _description = $v.description;
      _form = $v.form;
      _class_ = $v.class_;
      _vehicleCount = $v.vehicleCount;
      _operatorCount = $v.operatorCount;
      _fareRuleCount = $v.fareRuleCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminVehicleTypeDtoOutput other) {
    _$v = other as _$AdminVehicleTypeDtoOutput;
  }

  @override
  void update(void Function(AdminVehicleTypeDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminVehicleTypeDtoOutput build() => _build();

  _$AdminVehicleTypeDtoOutput _build() {
    final _$result = _$v ??
        _$AdminVehicleTypeDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminVehicleTypeDtoOutput', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AdminVehicleTypeDtoOutput', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminVehicleTypeDtoOutput', 'name'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminVehicleTypeDtoOutput', 'status'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminVehicleTypeDtoOutput', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'AdminVehicleTypeDtoOutput', 'updatedAt'),
          description: description,
          form: BuiltValueNullFieldError.checkNotNull(
              form, r'AdminVehicleTypeDtoOutput', 'form'),
          class_: BuiltValueNullFieldError.checkNotNull(
              class_, r'AdminVehicleTypeDtoOutput', 'class_'),
          vehicleCount: BuiltValueNullFieldError.checkNotNull(
              vehicleCount, r'AdminVehicleTypeDtoOutput', 'vehicleCount'),
          operatorCount: BuiltValueNullFieldError.checkNotNull(
              operatorCount, r'AdminVehicleTypeDtoOutput', 'operatorCount'),
          fareRuleCount: BuiltValueNullFieldError.checkNotNull(
              fareRuleCount, r'AdminVehicleTypeDtoOutput', 'fareRuleCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
