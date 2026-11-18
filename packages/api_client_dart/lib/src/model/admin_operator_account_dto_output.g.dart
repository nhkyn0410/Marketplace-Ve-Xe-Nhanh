// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_operator_account_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOperatorAccountDtoOutputOperatorStatusEnum
    _$adminOperatorAccountDtoOutputOperatorStatusEnum_ACTIVE =
    const AdminOperatorAccountDtoOutputOperatorStatusEnum._('ACTIVE');
const AdminOperatorAccountDtoOutputOperatorStatusEnum
    _$adminOperatorAccountDtoOutputOperatorStatusEnum_SUSPENDED =
    const AdminOperatorAccountDtoOutputOperatorStatusEnum._('SUSPENDED');

AdminOperatorAccountDtoOutputOperatorStatusEnum
    _$adminOperatorAccountDtoOutputOperatorStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminOperatorAccountDtoOutputOperatorStatusEnum_ACTIVE;
    case 'SUSPENDED':
      return _$adminOperatorAccountDtoOutputOperatorStatusEnum_SUSPENDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOperatorAccountDtoOutputOperatorStatusEnum>
    _$adminOperatorAccountDtoOutputOperatorStatusEnumValues = BuiltSet<
        AdminOperatorAccountDtoOutputOperatorStatusEnum>(const <AdminOperatorAccountDtoOutputOperatorStatusEnum>[
  _$adminOperatorAccountDtoOutputOperatorStatusEnum_ACTIVE,
  _$adminOperatorAccountDtoOutputOperatorStatusEnum_SUSPENDED,
]);

const AdminOperatorAccountDtoOutputRoleEnum
    _$adminOperatorAccountDtoOutputRoleEnum_OPERATOR_OWNER =
    const AdminOperatorAccountDtoOutputRoleEnum._('OPERATOR_OWNER');
const AdminOperatorAccountDtoOutputRoleEnum
    _$adminOperatorAccountDtoOutputRoleEnum_OPERATOR_MANAGER =
    const AdminOperatorAccountDtoOutputRoleEnum._('OPERATOR_MANAGER');

AdminOperatorAccountDtoOutputRoleEnum
    _$adminOperatorAccountDtoOutputRoleEnumValueOf(String name) {
  switch (name) {
    case 'OPERATOR_OWNER':
      return _$adminOperatorAccountDtoOutputRoleEnum_OPERATOR_OWNER;
    case 'OPERATOR_MANAGER':
      return _$adminOperatorAccountDtoOutputRoleEnum_OPERATOR_MANAGER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOperatorAccountDtoOutputRoleEnum>
    _$adminOperatorAccountDtoOutputRoleEnumValues = BuiltSet<
        AdminOperatorAccountDtoOutputRoleEnum>(const <AdminOperatorAccountDtoOutputRoleEnum>[
  _$adminOperatorAccountDtoOutputRoleEnum_OPERATOR_OWNER,
  _$adminOperatorAccountDtoOutputRoleEnum_OPERATOR_MANAGER,
]);

const AdminOperatorAccountDtoOutputStatusEnum
    _$adminOperatorAccountDtoOutputStatusEnum_ACTIVE =
    const AdminOperatorAccountDtoOutputStatusEnum._('ACTIVE');
const AdminOperatorAccountDtoOutputStatusEnum
    _$adminOperatorAccountDtoOutputStatusEnum_LOCKED =
    const AdminOperatorAccountDtoOutputStatusEnum._('LOCKED');
const AdminOperatorAccountDtoOutputStatusEnum
    _$adminOperatorAccountDtoOutputStatusEnum_DISABLED =
    const AdminOperatorAccountDtoOutputStatusEnum._('DISABLED');

AdminOperatorAccountDtoOutputStatusEnum
    _$adminOperatorAccountDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminOperatorAccountDtoOutputStatusEnum_ACTIVE;
    case 'LOCKED':
      return _$adminOperatorAccountDtoOutputStatusEnum_LOCKED;
    case 'DISABLED':
      return _$adminOperatorAccountDtoOutputStatusEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOperatorAccountDtoOutputStatusEnum>
    _$adminOperatorAccountDtoOutputStatusEnumValues = BuiltSet<
        AdminOperatorAccountDtoOutputStatusEnum>(const <AdminOperatorAccountDtoOutputStatusEnum>[
  _$adminOperatorAccountDtoOutputStatusEnum_ACTIVE,
  _$adminOperatorAccountDtoOutputStatusEnum_LOCKED,
  _$adminOperatorAccountDtoOutputStatusEnum_DISABLED,
]);

Serializer<AdminOperatorAccountDtoOutputOperatorStatusEnum>
    _$adminOperatorAccountDtoOutputOperatorStatusEnumSerializer =
    _$AdminOperatorAccountDtoOutputOperatorStatusEnumSerializer();
Serializer<AdminOperatorAccountDtoOutputRoleEnum>
    _$adminOperatorAccountDtoOutputRoleEnumSerializer =
    _$AdminOperatorAccountDtoOutputRoleEnumSerializer();
Serializer<AdminOperatorAccountDtoOutputStatusEnum>
    _$adminOperatorAccountDtoOutputStatusEnumSerializer =
    _$AdminOperatorAccountDtoOutputStatusEnumSerializer();

class _$AdminOperatorAccountDtoOutputOperatorStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminOperatorAccountDtoOutputOperatorStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOperatorAccountDtoOutputOperatorStatusEnum
  ];
  @override
  final String wireName = 'AdminOperatorAccountDtoOutputOperatorStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminOperatorAccountDtoOutputOperatorStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminOperatorAccountDtoOutputOperatorStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminOperatorAccountDtoOutputOperatorStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminOperatorAccountDtoOutputRoleEnumSerializer
    implements PrimitiveSerializer<AdminOperatorAccountDtoOutputRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPERATOR_OWNER': 'OPERATOR_OWNER',
    'OPERATOR_MANAGER': 'OPERATOR_MANAGER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPERATOR_OWNER': 'OPERATOR_OWNER',
    'OPERATOR_MANAGER': 'OPERATOR_MANAGER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOperatorAccountDtoOutputRoleEnum
  ];
  @override
  final String wireName = 'AdminOperatorAccountDtoOutputRoleEnum';

  @override
  Object serialize(
          Serializers serializers, AdminOperatorAccountDtoOutputRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminOperatorAccountDtoOutputRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminOperatorAccountDtoOutputRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminOperatorAccountDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminOperatorAccountDtoOutputStatusEnum> {
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
    AdminOperatorAccountDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'AdminOperatorAccountDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminOperatorAccountDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminOperatorAccountDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminOperatorAccountDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminOperatorAccountDtoOutput extends AdminOperatorAccountDtoOutput {
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
  final AdminOperatorAccountDtoOutputOperatorStatusEnum operatorStatus;
  @override
  final AdminOperatorAccountDtoOutputRoleEnum role;
  @override
  final AdminOperatorAccountDtoOutputStatusEnum status;
  @override
  final bool mfaEnabled;
  @override
  final bool passwordChangeRequired;
  @override
  final bool credentialDeliveryPending;
  @override
  final DateTime? temporaryPasswordExpiresAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime? lastLoginAt;

  factory _$AdminOperatorAccountDtoOutput(
          [void Function(AdminOperatorAccountDtoOutputBuilder)? updates]) =>
      (AdminOperatorAccountDtoOutputBuilder()..update(updates))._build();

  _$AdminOperatorAccountDtoOutput._(
      {required this.id,
      required this.username,
      this.email,
      required this.operatorId,
      required this.operatorName,
      required this.operatorStatus,
      required this.role,
      required this.status,
      required this.mfaEnabled,
      required this.passwordChangeRequired,
      required this.credentialDeliveryPending,
      this.temporaryPasswordExpiresAt,
      required this.createdAt,
      this.lastLoginAt})
      : super._();
  @override
  AdminOperatorAccountDtoOutput rebuild(
          void Function(AdminOperatorAccountDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOperatorAccountDtoOutputBuilder toBuilder() =>
      AdminOperatorAccountDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOperatorAccountDtoOutput &&
        id == other.id &&
        username == other.username &&
        email == other.email &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        operatorStatus == other.operatorStatus &&
        role == other.role &&
        status == other.status &&
        mfaEnabled == other.mfaEnabled &&
        passwordChangeRequired == other.passwordChangeRequired &&
        credentialDeliveryPending == other.credentialDeliveryPending &&
        temporaryPasswordExpiresAt == other.temporaryPasswordExpiresAt &&
        createdAt == other.createdAt &&
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
    _$hash = $jc(_$hash, operatorStatus.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, mfaEnabled.hashCode);
    _$hash = $jc(_$hash, passwordChangeRequired.hashCode);
    _$hash = $jc(_$hash, credentialDeliveryPending.hashCode);
    _$hash = $jc(_$hash, temporaryPasswordExpiresAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, lastLoginAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOperatorAccountDtoOutput')
          ..add('id', id)
          ..add('username', username)
          ..add('email', email)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('operatorStatus', operatorStatus)
          ..add('role', role)
          ..add('status', status)
          ..add('mfaEnabled', mfaEnabled)
          ..add('passwordChangeRequired', passwordChangeRequired)
          ..add('credentialDeliveryPending', credentialDeliveryPending)
          ..add('temporaryPasswordExpiresAt', temporaryPasswordExpiresAt)
          ..add('createdAt', createdAt)
          ..add('lastLoginAt', lastLoginAt))
        .toString();
  }
}

class AdminOperatorAccountDtoOutputBuilder
    implements
        Builder<AdminOperatorAccountDtoOutput,
            AdminOperatorAccountDtoOutputBuilder> {
  _$AdminOperatorAccountDtoOutput? _$v;

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

  AdminOperatorAccountDtoOutputOperatorStatusEnum? _operatorStatus;
  AdminOperatorAccountDtoOutputOperatorStatusEnum? get operatorStatus =>
      _$this._operatorStatus;
  set operatorStatus(
          AdminOperatorAccountDtoOutputOperatorStatusEnum? operatorStatus) =>
      _$this._operatorStatus = operatorStatus;

  AdminOperatorAccountDtoOutputRoleEnum? _role;
  AdminOperatorAccountDtoOutputRoleEnum? get role => _$this._role;
  set role(AdminOperatorAccountDtoOutputRoleEnum? role) => _$this._role = role;

  AdminOperatorAccountDtoOutputStatusEnum? _status;
  AdminOperatorAccountDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminOperatorAccountDtoOutputStatusEnum? status) =>
      _$this._status = status;

  bool? _mfaEnabled;
  bool? get mfaEnabled => _$this._mfaEnabled;
  set mfaEnabled(bool? mfaEnabled) => _$this._mfaEnabled = mfaEnabled;

  bool? _passwordChangeRequired;
  bool? get passwordChangeRequired => _$this._passwordChangeRequired;
  set passwordChangeRequired(bool? passwordChangeRequired) =>
      _$this._passwordChangeRequired = passwordChangeRequired;

  bool? _credentialDeliveryPending;
  bool? get credentialDeliveryPending => _$this._credentialDeliveryPending;
  set credentialDeliveryPending(bool? credentialDeliveryPending) =>
      _$this._credentialDeliveryPending = credentialDeliveryPending;

  DateTime? _temporaryPasswordExpiresAt;
  DateTime? get temporaryPasswordExpiresAt =>
      _$this._temporaryPasswordExpiresAt;
  set temporaryPasswordExpiresAt(DateTime? temporaryPasswordExpiresAt) =>
      _$this._temporaryPasswordExpiresAt = temporaryPasswordExpiresAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _lastLoginAt;
  DateTime? get lastLoginAt => _$this._lastLoginAt;
  set lastLoginAt(DateTime? lastLoginAt) => _$this._lastLoginAt = lastLoginAt;

  AdminOperatorAccountDtoOutputBuilder() {
    AdminOperatorAccountDtoOutput._defaults(this);
  }

  AdminOperatorAccountDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _username = $v.username;
      _email = $v.email;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _operatorStatus = $v.operatorStatus;
      _role = $v.role;
      _status = $v.status;
      _mfaEnabled = $v.mfaEnabled;
      _passwordChangeRequired = $v.passwordChangeRequired;
      _credentialDeliveryPending = $v.credentialDeliveryPending;
      _temporaryPasswordExpiresAt = $v.temporaryPasswordExpiresAt;
      _createdAt = $v.createdAt;
      _lastLoginAt = $v.lastLoginAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOperatorAccountDtoOutput other) {
    _$v = other as _$AdminOperatorAccountDtoOutput;
  }

  @override
  void update(void Function(AdminOperatorAccountDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOperatorAccountDtoOutput build() => _build();

  _$AdminOperatorAccountDtoOutput _build() {
    final _$result = _$v ??
        _$AdminOperatorAccountDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminOperatorAccountDtoOutput', 'id'),
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'AdminOperatorAccountDtoOutput', 'username'),
          email: email,
          operatorId: BuiltValueNullFieldError.checkNotNull(
              operatorId, r'AdminOperatorAccountDtoOutput', 'operatorId'),
          operatorName: BuiltValueNullFieldError.checkNotNull(
              operatorName, r'AdminOperatorAccountDtoOutput', 'operatorName'),
          operatorStatus: BuiltValueNullFieldError.checkNotNull(operatorStatus,
              r'AdminOperatorAccountDtoOutput', 'operatorStatus'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'AdminOperatorAccountDtoOutput', 'role'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminOperatorAccountDtoOutput', 'status'),
          mfaEnabled: BuiltValueNullFieldError.checkNotNull(
              mfaEnabled, r'AdminOperatorAccountDtoOutput', 'mfaEnabled'),
          passwordChangeRequired: BuiltValueNullFieldError.checkNotNull(
              passwordChangeRequired,
              r'AdminOperatorAccountDtoOutput',
              'passwordChangeRequired'),
          credentialDeliveryPending: BuiltValueNullFieldError.checkNotNull(
              credentialDeliveryPending,
              r'AdminOperatorAccountDtoOutput',
              'credentialDeliveryPending'),
          temporaryPasswordExpiresAt: temporaryPasswordExpiresAt,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminOperatorAccountDtoOutput', 'createdAt'),
          lastLoginAt: lastLoginAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
