// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_vehicle_type_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminVehicleTypeListDtoOutputItemsInnerStatusEnum
    _$adminVehicleTypeListDtoOutputItemsInnerStatusEnum_ACTIVE =
    const AdminVehicleTypeListDtoOutputItemsInnerStatusEnum._('ACTIVE');
const AdminVehicleTypeListDtoOutputItemsInnerStatusEnum
    _$adminVehicleTypeListDtoOutputItemsInnerStatusEnum_INACTIVE =
    const AdminVehicleTypeListDtoOutputItemsInnerStatusEnum._('INACTIVE');

AdminVehicleTypeListDtoOutputItemsInnerStatusEnum
    _$adminVehicleTypeListDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminVehicleTypeListDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminVehicleTypeListDtoOutputItemsInnerStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminVehicleTypeListDtoOutputItemsInnerStatusEnum>
    _$adminVehicleTypeListDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminVehicleTypeListDtoOutputItemsInnerStatusEnum>(const <AdminVehicleTypeListDtoOutputItemsInnerStatusEnum>[
  _$adminVehicleTypeListDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$adminVehicleTypeListDtoOutputItemsInnerStatusEnum_INACTIVE,
]);

const AdminVehicleTypeListDtoOutputItemsInnerFormEnum
    _$adminVehicleTypeListDtoOutputItemsInnerFormEnum_SEATER =
    const AdminVehicleTypeListDtoOutputItemsInnerFormEnum._('SEATER');
const AdminVehicleTypeListDtoOutputItemsInnerFormEnum
    _$adminVehicleTypeListDtoOutputItemsInnerFormEnum_SLEEPER =
    const AdminVehicleTypeListDtoOutputItemsInnerFormEnum._('SLEEPER');
const AdminVehicleTypeListDtoOutputItemsInnerFormEnum
    _$adminVehicleTypeListDtoOutputItemsInnerFormEnum_CABIN =
    const AdminVehicleTypeListDtoOutputItemsInnerFormEnum._('CABIN');

AdminVehicleTypeListDtoOutputItemsInnerFormEnum
    _$adminVehicleTypeListDtoOutputItemsInnerFormEnumValueOf(String name) {
  switch (name) {
    case 'SEATER':
      return _$adminVehicleTypeListDtoOutputItemsInnerFormEnum_SEATER;
    case 'SLEEPER':
      return _$adminVehicleTypeListDtoOutputItemsInnerFormEnum_SLEEPER;
    case 'CABIN':
      return _$adminVehicleTypeListDtoOutputItemsInnerFormEnum_CABIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminVehicleTypeListDtoOutputItemsInnerFormEnum>
    _$adminVehicleTypeListDtoOutputItemsInnerFormEnumValues = BuiltSet<
        AdminVehicleTypeListDtoOutputItemsInnerFormEnum>(const <AdminVehicleTypeListDtoOutputItemsInnerFormEnum>[
  _$adminVehicleTypeListDtoOutputItemsInnerFormEnum_SEATER,
  _$adminVehicleTypeListDtoOutputItemsInnerFormEnum_SLEEPER,
  _$adminVehicleTypeListDtoOutputItemsInnerFormEnum_CABIN,
]);

const AdminVehicleTypeListDtoOutputItemsInnerClass_Enum
    _$adminVehicleTypeListDtoOutputItemsInnerClassEnum_STANDARD =
    const AdminVehicleTypeListDtoOutputItemsInnerClass_Enum._('STANDARD');
const AdminVehicleTypeListDtoOutputItemsInnerClass_Enum
    _$adminVehicleTypeListDtoOutputItemsInnerClassEnum_LIMOUSINE =
    const AdminVehicleTypeListDtoOutputItemsInnerClass_Enum._('LIMOUSINE');

AdminVehicleTypeListDtoOutputItemsInnerClass_Enum
    _$adminVehicleTypeListDtoOutputItemsInnerClassEnumValueOf(String name) {
  switch (name) {
    case 'STANDARD':
      return _$adminVehicleTypeListDtoOutputItemsInnerClassEnum_STANDARD;
    case 'LIMOUSINE':
      return _$adminVehicleTypeListDtoOutputItemsInnerClassEnum_LIMOUSINE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminVehicleTypeListDtoOutputItemsInnerClass_Enum>
    _$adminVehicleTypeListDtoOutputItemsInnerClassEnumValues = BuiltSet<
        AdminVehicleTypeListDtoOutputItemsInnerClass_Enum>(const <AdminVehicleTypeListDtoOutputItemsInnerClass_Enum>[
  _$adminVehicleTypeListDtoOutputItemsInnerClassEnum_STANDARD,
  _$adminVehicleTypeListDtoOutputItemsInnerClassEnum_LIMOUSINE,
]);

Serializer<AdminVehicleTypeListDtoOutputItemsInnerStatusEnum>
    _$adminVehicleTypeListDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminVehicleTypeListDtoOutputItemsInnerStatusEnumSerializer();
Serializer<AdminVehicleTypeListDtoOutputItemsInnerFormEnum>
    _$adminVehicleTypeListDtoOutputItemsInnerFormEnumSerializer =
    _$AdminVehicleTypeListDtoOutputItemsInnerFormEnumSerializer();
Serializer<AdminVehicleTypeListDtoOutputItemsInnerClass_Enum>
    _$adminVehicleTypeListDtoOutputItemsInnerClassEnumSerializer =
    _$AdminVehicleTypeListDtoOutputItemsInnerClass_EnumSerializer();

class _$AdminVehicleTypeListDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminVehicleTypeListDtoOutputItemsInnerStatusEnum> {
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
    AdminVehicleTypeListDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminVehicleTypeListDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminVehicleTypeListDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminVehicleTypeListDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminVehicleTypeListDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminVehicleTypeListDtoOutputItemsInnerFormEnumSerializer
    implements
        PrimitiveSerializer<AdminVehicleTypeListDtoOutputItemsInnerFormEnum> {
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
  final Iterable<Type> types = const <Type>[
    AdminVehicleTypeListDtoOutputItemsInnerFormEnum
  ];
  @override
  final String wireName = 'AdminVehicleTypeListDtoOutputItemsInnerFormEnum';

  @override
  Object serialize(Serializers serializers,
          AdminVehicleTypeListDtoOutputItemsInnerFormEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminVehicleTypeListDtoOutputItemsInnerFormEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminVehicleTypeListDtoOutputItemsInnerFormEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminVehicleTypeListDtoOutputItemsInnerClass_EnumSerializer
    implements
        PrimitiveSerializer<AdminVehicleTypeListDtoOutputItemsInnerClass_Enum> {
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
    AdminVehicleTypeListDtoOutputItemsInnerClass_Enum
  ];
  @override
  final String wireName = 'AdminVehicleTypeListDtoOutputItemsInnerClass_Enum';

  @override
  Object serialize(Serializers serializers,
          AdminVehicleTypeListDtoOutputItemsInnerClass_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminVehicleTypeListDtoOutputItemsInnerClass_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminVehicleTypeListDtoOutputItemsInnerClass_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminVehicleTypeListDtoOutputItemsInner
    extends AdminVehicleTypeListDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final AdminVehicleTypeListDtoOutputItemsInnerStatusEnum status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? description;
  @override
  final AdminVehicleTypeListDtoOutputItemsInnerFormEnum form;
  @override
  final AdminVehicleTypeListDtoOutputItemsInnerClass_Enum class_;
  @override
  final int vehicleCount;
  @override
  final int operatorCount;
  @override
  final int fareRuleCount;

  factory _$AdminVehicleTypeListDtoOutputItemsInner(
          [void Function(AdminVehicleTypeListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminVehicleTypeListDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$AdminVehicleTypeListDtoOutputItemsInner._(
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
  AdminVehicleTypeListDtoOutputItemsInner rebuild(
          void Function(AdminVehicleTypeListDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminVehicleTypeListDtoOutputItemsInnerBuilder toBuilder() =>
      AdminVehicleTypeListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminVehicleTypeListDtoOutputItemsInner &&
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
    return (newBuiltValueToStringHelper(
            r'AdminVehicleTypeListDtoOutputItemsInner')
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

class AdminVehicleTypeListDtoOutputItemsInnerBuilder
    implements
        Builder<AdminVehicleTypeListDtoOutputItemsInner,
            AdminVehicleTypeListDtoOutputItemsInnerBuilder> {
  _$AdminVehicleTypeListDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminVehicleTypeListDtoOutputItemsInnerStatusEnum? _status;
  AdminVehicleTypeListDtoOutputItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminVehicleTypeListDtoOutputItemsInnerStatusEnum? status) =>
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

  AdminVehicleTypeListDtoOutputItemsInnerFormEnum? _form;
  AdminVehicleTypeListDtoOutputItemsInnerFormEnum? get form => _$this._form;
  set form(AdminVehicleTypeListDtoOutputItemsInnerFormEnum? form) =>
      _$this._form = form;

  AdminVehicleTypeListDtoOutputItemsInnerClass_Enum? _class_;
  AdminVehicleTypeListDtoOutputItemsInnerClass_Enum? get class_ =>
      _$this._class_;
  set class_(AdminVehicleTypeListDtoOutputItemsInnerClass_Enum? class_) =>
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

  AdminVehicleTypeListDtoOutputItemsInnerBuilder() {
    AdminVehicleTypeListDtoOutputItemsInner._defaults(this);
  }

  AdminVehicleTypeListDtoOutputItemsInnerBuilder get _$this {
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
  void replace(AdminVehicleTypeListDtoOutputItemsInner other) {
    _$v = other as _$AdminVehicleTypeListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminVehicleTypeListDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminVehicleTypeListDtoOutputItemsInner build() => _build();

  _$AdminVehicleTypeListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$AdminVehicleTypeListDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminVehicleTypeListDtoOutputItemsInner', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AdminVehicleTypeListDtoOutputItemsInner', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminVehicleTypeListDtoOutputItemsInner', 'name'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminVehicleTypeListDtoOutputItemsInner', 'status'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'AdminVehicleTypeListDtoOutputItemsInner', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt,
              r'AdminVehicleTypeListDtoOutputItemsInner', 'updatedAt'),
          description: description,
          form: BuiltValueNullFieldError.checkNotNull(
              form, r'AdminVehicleTypeListDtoOutputItemsInner', 'form'),
          class_: BuiltValueNullFieldError.checkNotNull(
              class_, r'AdminVehicleTypeListDtoOutputItemsInner', 'class_'),
          vehicleCount: BuiltValueNullFieldError.checkNotNull(vehicleCount,
              r'AdminVehicleTypeListDtoOutputItemsInner', 'vehicleCount'),
          operatorCount: BuiltValueNullFieldError.checkNotNull(operatorCount,
              r'AdminVehicleTypeListDtoOutputItemsInner', 'operatorCount'),
          fareRuleCount: BuiltValueNullFieldError.checkNotNull(fareRuleCount,
              r'AdminVehicleTypeListDtoOutputItemsInner', 'fareRuleCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
