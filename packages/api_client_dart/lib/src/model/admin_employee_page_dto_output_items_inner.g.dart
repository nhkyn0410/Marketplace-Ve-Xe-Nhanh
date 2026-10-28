// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_employee_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminEmployeePageDtoOutputItemsInnerRoleEnum
    _$adminEmployeePageDtoOutputItemsInnerRoleEnum_DRIVER =
    const AdminEmployeePageDtoOutputItemsInnerRoleEnum._('DRIVER');
const AdminEmployeePageDtoOutputItemsInnerRoleEnum
    _$adminEmployeePageDtoOutputItemsInnerRoleEnum_TICKET_STAFF =
    const AdminEmployeePageDtoOutputItemsInnerRoleEnum._('TICKET_STAFF');
const AdminEmployeePageDtoOutputItemsInnerRoleEnum
    _$adminEmployeePageDtoOutputItemsInnerRoleEnum_SUPPORT_STAFF =
    const AdminEmployeePageDtoOutputItemsInnerRoleEnum._('SUPPORT_STAFF');
const AdminEmployeePageDtoOutputItemsInnerRoleEnum
    _$adminEmployeePageDtoOutputItemsInnerRoleEnum_SALES_STAFF =
    const AdminEmployeePageDtoOutputItemsInnerRoleEnum._('SALES_STAFF');

AdminEmployeePageDtoOutputItemsInnerRoleEnum
    _$adminEmployeePageDtoOutputItemsInnerRoleEnumValueOf(String name) {
  switch (name) {
    case 'DRIVER':
      return _$adminEmployeePageDtoOutputItemsInnerRoleEnum_DRIVER;
    case 'TICKET_STAFF':
      return _$adminEmployeePageDtoOutputItemsInnerRoleEnum_TICKET_STAFF;
    case 'SUPPORT_STAFF':
      return _$adminEmployeePageDtoOutputItemsInnerRoleEnum_SUPPORT_STAFF;
    case 'SALES_STAFF':
      return _$adminEmployeePageDtoOutputItemsInnerRoleEnum_SALES_STAFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminEmployeePageDtoOutputItemsInnerRoleEnum>
    _$adminEmployeePageDtoOutputItemsInnerRoleEnumValues = BuiltSet<
        AdminEmployeePageDtoOutputItemsInnerRoleEnum>(const <AdminEmployeePageDtoOutputItemsInnerRoleEnum>[
  _$adminEmployeePageDtoOutputItemsInnerRoleEnum_DRIVER,
  _$adminEmployeePageDtoOutputItemsInnerRoleEnum_TICKET_STAFF,
  _$adminEmployeePageDtoOutputItemsInnerRoleEnum_SUPPORT_STAFF,
  _$adminEmployeePageDtoOutputItemsInnerRoleEnum_SALES_STAFF,
]);

const AdminEmployeePageDtoOutputItemsInnerStatusEnum
    _$adminEmployeePageDtoOutputItemsInnerStatusEnum_ACTIVE =
    const AdminEmployeePageDtoOutputItemsInnerStatusEnum._('ACTIVE');
const AdminEmployeePageDtoOutputItemsInnerStatusEnum
    _$adminEmployeePageDtoOutputItemsInnerStatusEnum_LOCKED =
    const AdminEmployeePageDtoOutputItemsInnerStatusEnum._('LOCKED');
const AdminEmployeePageDtoOutputItemsInnerStatusEnum
    _$adminEmployeePageDtoOutputItemsInnerStatusEnum_DISABLED =
    const AdminEmployeePageDtoOutputItemsInnerStatusEnum._('DISABLED');

AdminEmployeePageDtoOutputItemsInnerStatusEnum
    _$adminEmployeePageDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminEmployeePageDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'LOCKED':
      return _$adminEmployeePageDtoOutputItemsInnerStatusEnum_LOCKED;
    case 'DISABLED':
      return _$adminEmployeePageDtoOutputItemsInnerStatusEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminEmployeePageDtoOutputItemsInnerStatusEnum>
    _$adminEmployeePageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminEmployeePageDtoOutputItemsInnerStatusEnum>(const <AdminEmployeePageDtoOutputItemsInnerStatusEnum>[
  _$adminEmployeePageDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$adminEmployeePageDtoOutputItemsInnerStatusEnum_LOCKED,
  _$adminEmployeePageDtoOutputItemsInnerStatusEnum_DISABLED,
]);

Serializer<AdminEmployeePageDtoOutputItemsInnerRoleEnum>
    _$adminEmployeePageDtoOutputItemsInnerRoleEnumSerializer =
    _$AdminEmployeePageDtoOutputItemsInnerRoleEnumSerializer();
Serializer<AdminEmployeePageDtoOutputItemsInnerStatusEnum>
    _$adminEmployeePageDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminEmployeePageDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminEmployeePageDtoOutputItemsInnerRoleEnumSerializer
    implements
        PrimitiveSerializer<AdminEmployeePageDtoOutputItemsInnerRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DRIVER': 'DRIVER',
    'TICKET_STAFF': 'TICKET_STAFF',
    'SUPPORT_STAFF': 'SUPPORT_STAFF',
    'SALES_STAFF': 'SALES_STAFF',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DRIVER': 'DRIVER',
    'TICKET_STAFF': 'TICKET_STAFF',
    'SUPPORT_STAFF': 'SUPPORT_STAFF',
    'SALES_STAFF': 'SALES_STAFF',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminEmployeePageDtoOutputItemsInnerRoleEnum
  ];
  @override
  final String wireName = 'AdminEmployeePageDtoOutputItemsInnerRoleEnum';

  @override
  Object serialize(Serializers serializers,
          AdminEmployeePageDtoOutputItemsInnerRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminEmployeePageDtoOutputItemsInnerRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminEmployeePageDtoOutputItemsInnerRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminEmployeePageDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminEmployeePageDtoOutputItemsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'LOCKED': 'LOCKED',
    'DISABLED': 'DISABLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'LOCKED': 'LOCKED',
    'DISABLED': 'DISABLED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminEmployeePageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminEmployeePageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminEmployeePageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminEmployeePageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminEmployeePageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminEmployeePageDtoOutputItemsInner
    extends AdminEmployeePageDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String username;
  @override
  final String? email;
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final AdminEmployeePageDtoOutputItemsInnerRoleEnum role;
  @override
  final AdminEmployeePageDtoOutputItemsInnerStatusEnum status;
  @override
  final DateTime? lastLoginAt;

  factory _$AdminEmployeePageDtoOutputItemsInner(
          [void Function(AdminEmployeePageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminEmployeePageDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$AdminEmployeePageDtoOutputItemsInner._(
      {required this.id,
      required this.username,
      this.email,
      required this.operatorId,
      required this.operatorName,
      required this.role,
      required this.status,
      this.lastLoginAt})
      : super._();
  @override
  AdminEmployeePageDtoOutputItemsInner rebuild(
          void Function(AdminEmployeePageDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminEmployeePageDtoOutputItemsInnerBuilder toBuilder() =>
      AdminEmployeePageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEmployeePageDtoOutputItemsInner &&
        id == other.id &&
        username == other.username &&
        email == other.email &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        role == other.role &&
        status == other.status &&
        lastLoginAt == other.lastLoginAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, lastLoginAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminEmployeePageDtoOutputItemsInner')
          ..add('id', id)
          ..add('username', username)
          ..add('email', email)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('role', role)
          ..add('status', status)
          ..add('lastLoginAt', lastLoginAt))
        .toString();
  }
}

class AdminEmployeePageDtoOutputItemsInnerBuilder
    implements
        Builder<AdminEmployeePageDtoOutputItemsInner,
            AdminEmployeePageDtoOutputItemsInnerBuilder> {
  _$AdminEmployeePageDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  AdminEmployeePageDtoOutputItemsInnerRoleEnum? _role;
  AdminEmployeePageDtoOutputItemsInnerRoleEnum? get role => _$this._role;
  set role(AdminEmployeePageDtoOutputItemsInnerRoleEnum? role) =>
      _$this._role = role;

  AdminEmployeePageDtoOutputItemsInnerStatusEnum? _status;
  AdminEmployeePageDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(AdminEmployeePageDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  DateTime? _lastLoginAt;
  DateTime? get lastLoginAt => _$this._lastLoginAt;
  set lastLoginAt(DateTime? lastLoginAt) => _$this._lastLoginAt = lastLoginAt;

  AdminEmployeePageDtoOutputItemsInnerBuilder() {
    AdminEmployeePageDtoOutputItemsInner._defaults(this);
  }

  AdminEmployeePageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _username = $v.username;
      _email = $v.email;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _role = $v.role;
      _status = $v.status;
      _lastLoginAt = $v.lastLoginAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEmployeePageDtoOutputItemsInner other) {
    _$v = other as _$AdminEmployeePageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminEmployeePageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminEmployeePageDtoOutputItemsInner build() => _build();

  _$AdminEmployeePageDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$AdminEmployeePageDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminEmployeePageDtoOutputItemsInner', 'id'),
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'AdminEmployeePageDtoOutputItemsInner', 'username'),
          email: email,
          operatorId: BuiltValueNullFieldError.checkNotNull(operatorId,
              r'AdminEmployeePageDtoOutputItemsInner', 'operatorId'),
          operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
              r'AdminEmployeePageDtoOutputItemsInner', 'operatorName'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'AdminEmployeePageDtoOutputItemsInner', 'role'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminEmployeePageDtoOutputItemsInner', 'status'),
          lastLoginAt: lastLoginAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
