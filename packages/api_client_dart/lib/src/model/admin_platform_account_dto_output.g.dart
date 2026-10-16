// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_platform_account_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminPlatformAccountDtoOutputRoleEnum
    _$adminPlatformAccountDtoOutputRoleEnum_PLATFORM_ADMIN =
    const AdminPlatformAccountDtoOutputRoleEnum._('PLATFORM_ADMIN');
const AdminPlatformAccountDtoOutputRoleEnum
    _$adminPlatformAccountDtoOutputRoleEnum_PLATFORM_SUPPORT =
    const AdminPlatformAccountDtoOutputRoleEnum._('PLATFORM_SUPPORT');

AdminPlatformAccountDtoOutputRoleEnum
    _$adminPlatformAccountDtoOutputRoleEnumValueOf(String name) {
  switch (name) {
    case 'PLATFORM_ADMIN':
      return _$adminPlatformAccountDtoOutputRoleEnum_PLATFORM_ADMIN;
    case 'PLATFORM_SUPPORT':
      return _$adminPlatformAccountDtoOutputRoleEnum_PLATFORM_SUPPORT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPlatformAccountDtoOutputRoleEnum>
    _$adminPlatformAccountDtoOutputRoleEnumValues = BuiltSet<
        AdminPlatformAccountDtoOutputRoleEnum>(const <AdminPlatformAccountDtoOutputRoleEnum>[
  _$adminPlatformAccountDtoOutputRoleEnum_PLATFORM_ADMIN,
  _$adminPlatformAccountDtoOutputRoleEnum_PLATFORM_SUPPORT,
]);

const AdminPlatformAccountDtoOutputStatusEnum
    _$adminPlatformAccountDtoOutputStatusEnum_ACTIVE =
    const AdminPlatformAccountDtoOutputStatusEnum._('ACTIVE');
const AdminPlatformAccountDtoOutputStatusEnum
    _$adminPlatformAccountDtoOutputStatusEnum_LOCKED =
    const AdminPlatformAccountDtoOutputStatusEnum._('LOCKED');
const AdminPlatformAccountDtoOutputStatusEnum
    _$adminPlatformAccountDtoOutputStatusEnum_DISABLED =
    const AdminPlatformAccountDtoOutputStatusEnum._('DISABLED');

AdminPlatformAccountDtoOutputStatusEnum
    _$adminPlatformAccountDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminPlatformAccountDtoOutputStatusEnum_ACTIVE;
    case 'LOCKED':
      return _$adminPlatformAccountDtoOutputStatusEnum_LOCKED;
    case 'DISABLED':
      return _$adminPlatformAccountDtoOutputStatusEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPlatformAccountDtoOutputStatusEnum>
    _$adminPlatformAccountDtoOutputStatusEnumValues = BuiltSet<
        AdminPlatformAccountDtoOutputStatusEnum>(const <AdminPlatformAccountDtoOutputStatusEnum>[
  _$adminPlatformAccountDtoOutputStatusEnum_ACTIVE,
  _$adminPlatformAccountDtoOutputStatusEnum_LOCKED,
  _$adminPlatformAccountDtoOutputStatusEnum_DISABLED,
]);

Serializer<AdminPlatformAccountDtoOutputRoleEnum>
    _$adminPlatformAccountDtoOutputRoleEnumSerializer =
    _$AdminPlatformAccountDtoOutputRoleEnumSerializer();
Serializer<AdminPlatformAccountDtoOutputStatusEnum>
    _$adminPlatformAccountDtoOutputStatusEnumSerializer =
    _$AdminPlatformAccountDtoOutputStatusEnumSerializer();

class _$AdminPlatformAccountDtoOutputRoleEnumSerializer
    implements PrimitiveSerializer<AdminPlatformAccountDtoOutputRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PLATFORM_ADMIN': 'PLATFORM_ADMIN',
    'PLATFORM_SUPPORT': 'PLATFORM_SUPPORT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PLATFORM_ADMIN': 'PLATFORM_ADMIN',
    'PLATFORM_SUPPORT': 'PLATFORM_SUPPORT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminPlatformAccountDtoOutputRoleEnum
  ];
  @override
  final String wireName = 'AdminPlatformAccountDtoOutputRoleEnum';

  @override
  Object serialize(
          Serializers serializers, AdminPlatformAccountDtoOutputRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminPlatformAccountDtoOutputRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminPlatformAccountDtoOutputRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminPlatformAccountDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminPlatformAccountDtoOutputStatusEnum> {
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
    AdminPlatformAccountDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'AdminPlatformAccountDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminPlatformAccountDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminPlatformAccountDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminPlatformAccountDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminPlatformAccountDtoOutput extends AdminPlatformAccountDtoOutput {
  @override
  final String id;
  @override
  final String username;
  @override
  final String? email;
  @override
  final AdminPlatformAccountDtoOutputRoleEnum role;
  @override
  final AdminPlatformAccountDtoOutputStatusEnum status;
  @override
  final bool mfaEnabled;
  @override
  final bool passwordChangeRequired;
  @override
  final bool credentialDeliveryPending;
  @override
  final String? lockedReason;
  @override
  final DateTime? lockedAt;
  @override
  final DateTime? lastLoginAt;
  @override
  final bool isSelf;

  factory _$AdminPlatformAccountDtoOutput(
          [void Function(AdminPlatformAccountDtoOutputBuilder)? updates]) =>
      (AdminPlatformAccountDtoOutputBuilder()..update(updates))._build();

  _$AdminPlatformAccountDtoOutput._(
      {required this.id,
      required this.username,
      this.email,
      required this.role,
      required this.status,
      required this.mfaEnabled,
      required this.passwordChangeRequired,
      required this.credentialDeliveryPending,
      this.lockedReason,
      this.lockedAt,
      this.lastLoginAt,
      required this.isSelf})
      : super._();
  @override
  AdminPlatformAccountDtoOutput rebuild(
          void Function(AdminPlatformAccountDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPlatformAccountDtoOutputBuilder toBuilder() =>
      AdminPlatformAccountDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPlatformAccountDtoOutput &&
        id == other.id &&
        username == other.username &&
        email == other.email &&
        role == other.role &&
        status == other.status &&
        mfaEnabled == other.mfaEnabled &&
        passwordChangeRequired == other.passwordChangeRequired &&
        credentialDeliveryPending == other.credentialDeliveryPending &&
        lockedReason == other.lockedReason &&
        lockedAt == other.lockedAt &&
        lastLoginAt == other.lastLoginAt &&
        isSelf == other.isSelf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, mfaEnabled.hashCode);
    _$hash = $jc(_$hash, passwordChangeRequired.hashCode);
    _$hash = $jc(_$hash, credentialDeliveryPending.hashCode);
    _$hash = $jc(_$hash, lockedReason.hashCode);
    _$hash = $jc(_$hash, lockedAt.hashCode);
    _$hash = $jc(_$hash, lastLoginAt.hashCode);
    _$hash = $jc(_$hash, isSelf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPlatformAccountDtoOutput')
          ..add('id', id)
          ..add('username', username)
          ..add('email', email)
          ..add('role', role)
          ..add('status', status)
          ..add('mfaEnabled', mfaEnabled)
          ..add('passwordChangeRequired', passwordChangeRequired)
          ..add('credentialDeliveryPending', credentialDeliveryPending)
          ..add('lockedReason', lockedReason)
          ..add('lockedAt', lockedAt)
          ..add('lastLoginAt', lastLoginAt)
          ..add('isSelf', isSelf))
        .toString();
  }
}

class AdminPlatformAccountDtoOutputBuilder
    implements
        Builder<AdminPlatformAccountDtoOutput,
            AdminPlatformAccountDtoOutputBuilder> {
  _$AdminPlatformAccountDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  AdminPlatformAccountDtoOutputRoleEnum? _role;
  AdminPlatformAccountDtoOutputRoleEnum? get role => _$this._role;
  set role(AdminPlatformAccountDtoOutputRoleEnum? role) => _$this._role = role;

  AdminPlatformAccountDtoOutputStatusEnum? _status;
  AdminPlatformAccountDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminPlatformAccountDtoOutputStatusEnum? status) =>
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

  String? _lockedReason;
  String? get lockedReason => _$this._lockedReason;
  set lockedReason(String? lockedReason) => _$this._lockedReason = lockedReason;

  DateTime? _lockedAt;
  DateTime? get lockedAt => _$this._lockedAt;
  set lockedAt(DateTime? lockedAt) => _$this._lockedAt = lockedAt;

  DateTime? _lastLoginAt;
  DateTime? get lastLoginAt => _$this._lastLoginAt;
  set lastLoginAt(DateTime? lastLoginAt) => _$this._lastLoginAt = lastLoginAt;

  bool? _isSelf;
  bool? get isSelf => _$this._isSelf;
  set isSelf(bool? isSelf) => _$this._isSelf = isSelf;

  AdminPlatformAccountDtoOutputBuilder() {
    AdminPlatformAccountDtoOutput._defaults(this);
  }

  AdminPlatformAccountDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _username = $v.username;
      _email = $v.email;
      _role = $v.role;
      _status = $v.status;
      _mfaEnabled = $v.mfaEnabled;
      _passwordChangeRequired = $v.passwordChangeRequired;
      _credentialDeliveryPending = $v.credentialDeliveryPending;
      _lockedReason = $v.lockedReason;
      _lockedAt = $v.lockedAt;
      _lastLoginAt = $v.lastLoginAt;
      _isSelf = $v.isSelf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPlatformAccountDtoOutput other) {
    _$v = other as _$AdminPlatformAccountDtoOutput;
  }

  @override
  void update(void Function(AdminPlatformAccountDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPlatformAccountDtoOutput build() => _build();

  _$AdminPlatformAccountDtoOutput _build() {
    final _$result = _$v ??
        _$AdminPlatformAccountDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminPlatformAccountDtoOutput', 'id'),
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'AdminPlatformAccountDtoOutput', 'username'),
          email: email,
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'AdminPlatformAccountDtoOutput', 'role'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminPlatformAccountDtoOutput', 'status'),
          mfaEnabled: BuiltValueNullFieldError.checkNotNull(
              mfaEnabled, r'AdminPlatformAccountDtoOutput', 'mfaEnabled'),
          passwordChangeRequired: BuiltValueNullFieldError.checkNotNull(
              passwordChangeRequired,
              r'AdminPlatformAccountDtoOutput',
              'passwordChangeRequired'),
          credentialDeliveryPending: BuiltValueNullFieldError.checkNotNull(
              credentialDeliveryPending,
              r'AdminPlatformAccountDtoOutput',
              'credentialDeliveryPending'),
          lockedReason: lockedReason,
          lockedAt: lockedAt,
          lastLoginAt: lastLoginAt,
          isSelf: BuiltValueNullFieldError.checkNotNull(
              isSelf, r'AdminPlatformAccountDtoOutput', 'isSelf'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
