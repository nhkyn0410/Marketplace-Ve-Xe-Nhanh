// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_operator_account_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum
    _$adminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum_ACTIVE =
    const AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum._(
        'ACTIVE');
const AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum
    _$adminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum_SUSPENDED =
    const AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum._(
        'SUSPENDED');

AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum
    _$adminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum_ACTIVE;
    case 'SUSPENDED':
      return _$adminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum_SUSPENDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum>
    _$adminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnumValues =
    BuiltSet<
        AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum>(const <AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum>[
  _$adminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum_ACTIVE,
  _$adminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum_SUSPENDED,
]);

const AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum
    _$adminOperatorAccountPageDtoOutputItemsInnerRoleEnum_OPERATOR_OWNER =
    const AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum._(
        'OPERATOR_OWNER');
const AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum
    _$adminOperatorAccountPageDtoOutputItemsInnerRoleEnum_OPERATOR_MANAGER =
    const AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum._(
        'OPERATOR_MANAGER');

AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum
    _$adminOperatorAccountPageDtoOutputItemsInnerRoleEnumValueOf(String name) {
  switch (name) {
    case 'OPERATOR_OWNER':
      return _$adminOperatorAccountPageDtoOutputItemsInnerRoleEnum_OPERATOR_OWNER;
    case 'OPERATOR_MANAGER':
      return _$adminOperatorAccountPageDtoOutputItemsInnerRoleEnum_OPERATOR_MANAGER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum>
    _$adminOperatorAccountPageDtoOutputItemsInnerRoleEnumValues = BuiltSet<
        AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum>(const <AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum>[
  _$adminOperatorAccountPageDtoOutputItemsInnerRoleEnum_OPERATOR_OWNER,
  _$adminOperatorAccountPageDtoOutputItemsInnerRoleEnum_OPERATOR_MANAGER,
]);

const AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum
    _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnum_ACTIVE =
    const AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum._('ACTIVE');
const AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum
    _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnum_LOCKED =
    const AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum._('LOCKED');
const AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum
    _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnum_DISABLED =
    const AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum._('DISABLED');

AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum
    _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'LOCKED':
      return _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnum_LOCKED;
    case 'DISABLED':
      return _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum>
    _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum>(const <AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum>[
  _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnum_LOCKED,
  _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnum_DISABLED,
]);

Serializer<AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum>
    _$adminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnumSerializer =
    _$AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnumSerializer();
Serializer<AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum>
    _$adminOperatorAccountPageDtoOutputItemsInnerRoleEnumSerializer =
    _$AdminOperatorAccountPageDtoOutputItemsInnerRoleEnumSerializer();
Serializer<AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum>
    _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminOperatorAccountPageDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnumSerializer
    implements
        PrimitiveSerializer<
            AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum> {
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
    AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum
  ];
  @override
  final String wireName =
      'AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminOperatorAccountPageDtoOutputItemsInnerRoleEnumSerializer
    implements
        PrimitiveSerializer<
            AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum> {
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
    AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum
  ];
  @override
  final String wireName = 'AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum';

  @override
  Object serialize(Serializers serializers,
          AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminOperatorAccountPageDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum> {
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
    AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName =
      'AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminOperatorAccountPageDtoOutputItemsInner
    extends AdminOperatorAccountPageDtoOutputItemsInner {
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
  final AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum
      operatorStatus;
  @override
  final AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum role;
  @override
  final AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum status;
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

  factory _$AdminOperatorAccountPageDtoOutputItemsInner(
          [void Function(AdminOperatorAccountPageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminOperatorAccountPageDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$AdminOperatorAccountPageDtoOutputItemsInner._(
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
  AdminOperatorAccountPageDtoOutputItemsInner rebuild(
          void Function(AdminOperatorAccountPageDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOperatorAccountPageDtoOutputItemsInnerBuilder toBuilder() =>
      AdminOperatorAccountPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOperatorAccountPageDtoOutputItemsInner &&
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
    return (newBuiltValueToStringHelper(
            r'AdminOperatorAccountPageDtoOutputItemsInner')
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

class AdminOperatorAccountPageDtoOutputItemsInnerBuilder
    implements
        Builder<AdminOperatorAccountPageDtoOutputItemsInner,
            AdminOperatorAccountPageDtoOutputItemsInnerBuilder> {
  _$AdminOperatorAccountPageDtoOutputItemsInner? _$v;

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

  AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum?
      _operatorStatus;
  AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum?
      get operatorStatus => _$this._operatorStatus;
  set operatorStatus(
          AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum?
              operatorStatus) =>
      _$this._operatorStatus = operatorStatus;

  AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum? _role;
  AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum? get role => _$this._role;
  set role(AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum? role) =>
      _$this._role = role;

  AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum? _status;
  AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum? status) =>
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

  AdminOperatorAccountPageDtoOutputItemsInnerBuilder() {
    AdminOperatorAccountPageDtoOutputItemsInner._defaults(this);
  }

  AdminOperatorAccountPageDtoOutputItemsInnerBuilder get _$this {
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
  void replace(AdminOperatorAccountPageDtoOutputItemsInner other) {
    _$v = other as _$AdminOperatorAccountPageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminOperatorAccountPageDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOperatorAccountPageDtoOutputItemsInner build() => _build();

  _$AdminOperatorAccountPageDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$AdminOperatorAccountPageDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminOperatorAccountPageDtoOutputItemsInner', 'id'),
          username: BuiltValueNullFieldError.checkNotNull(username,
              r'AdminOperatorAccountPageDtoOutputItemsInner', 'username'),
          email: email,
          operatorId: BuiltValueNullFieldError.checkNotNull(operatorId,
              r'AdminOperatorAccountPageDtoOutputItemsInner', 'operatorId'),
          operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
              r'AdminOperatorAccountPageDtoOutputItemsInner', 'operatorName'),
          operatorStatus: BuiltValueNullFieldError.checkNotNull(operatorStatus,
              r'AdminOperatorAccountPageDtoOutputItemsInner', 'operatorStatus'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'AdminOperatorAccountPageDtoOutputItemsInner', 'role'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminOperatorAccountPageDtoOutputItemsInner', 'status'),
          mfaEnabled: BuiltValueNullFieldError.checkNotNull(mfaEnabled,
              r'AdminOperatorAccountPageDtoOutputItemsInner', 'mfaEnabled'),
          passwordChangeRequired: BuiltValueNullFieldError.checkNotNull(
              passwordChangeRequired,
              r'AdminOperatorAccountPageDtoOutputItemsInner',
              'passwordChangeRequired'),
          credentialDeliveryPending: BuiltValueNullFieldError.checkNotNull(
              credentialDeliveryPending,
              r'AdminOperatorAccountPageDtoOutputItemsInner',
              'credentialDeliveryPending'),
          temporaryPasswordExpiresAt: temporaryPasswordExpiresAt,
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'AdminOperatorAccountPageDtoOutputItemsInner', 'createdAt'),
          lastLoginAt: lastLoginAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
