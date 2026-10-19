// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_platform_account_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminPlatformAccountListDtoOutputItemsInnerRoleEnum
    _$adminPlatformAccountListDtoOutputItemsInnerRoleEnum_PLATFORM_ADMIN =
    const AdminPlatformAccountListDtoOutputItemsInnerRoleEnum._(
        'PLATFORM_ADMIN');
const AdminPlatformAccountListDtoOutputItemsInnerRoleEnum
    _$adminPlatformAccountListDtoOutputItemsInnerRoleEnum_PLATFORM_SUPPORT =
    const AdminPlatformAccountListDtoOutputItemsInnerRoleEnum._(
        'PLATFORM_SUPPORT');

AdminPlatformAccountListDtoOutputItemsInnerRoleEnum
    _$adminPlatformAccountListDtoOutputItemsInnerRoleEnumValueOf(String name) {
  switch (name) {
    case 'PLATFORM_ADMIN':
      return _$adminPlatformAccountListDtoOutputItemsInnerRoleEnum_PLATFORM_ADMIN;
    case 'PLATFORM_SUPPORT':
      return _$adminPlatformAccountListDtoOutputItemsInnerRoleEnum_PLATFORM_SUPPORT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPlatformAccountListDtoOutputItemsInnerRoleEnum>
    _$adminPlatformAccountListDtoOutputItemsInnerRoleEnumValues = BuiltSet<
        AdminPlatformAccountListDtoOutputItemsInnerRoleEnum>(const <AdminPlatformAccountListDtoOutputItemsInnerRoleEnum>[
  _$adminPlatformAccountListDtoOutputItemsInnerRoleEnum_PLATFORM_ADMIN,
  _$adminPlatformAccountListDtoOutputItemsInnerRoleEnum_PLATFORM_SUPPORT,
]);

const AdminPlatformAccountListDtoOutputItemsInnerStatusEnum
    _$adminPlatformAccountListDtoOutputItemsInnerStatusEnum_ACTIVE =
    const AdminPlatformAccountListDtoOutputItemsInnerStatusEnum._('ACTIVE');
const AdminPlatformAccountListDtoOutputItemsInnerStatusEnum
    _$adminPlatformAccountListDtoOutputItemsInnerStatusEnum_LOCKED =
    const AdminPlatformAccountListDtoOutputItemsInnerStatusEnum._('LOCKED');
const AdminPlatformAccountListDtoOutputItemsInnerStatusEnum
    _$adminPlatformAccountListDtoOutputItemsInnerStatusEnum_DISABLED =
    const AdminPlatformAccountListDtoOutputItemsInnerStatusEnum._('DISABLED');

AdminPlatformAccountListDtoOutputItemsInnerStatusEnum
    _$adminPlatformAccountListDtoOutputItemsInnerStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminPlatformAccountListDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'LOCKED':
      return _$adminPlatformAccountListDtoOutputItemsInnerStatusEnum_LOCKED;
    case 'DISABLED':
      return _$adminPlatformAccountListDtoOutputItemsInnerStatusEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPlatformAccountListDtoOutputItemsInnerStatusEnum>
    _$adminPlatformAccountListDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminPlatformAccountListDtoOutputItemsInnerStatusEnum>(const <AdminPlatformAccountListDtoOutputItemsInnerStatusEnum>[
  _$adminPlatformAccountListDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$adminPlatformAccountListDtoOutputItemsInnerStatusEnum_LOCKED,
  _$adminPlatformAccountListDtoOutputItemsInnerStatusEnum_DISABLED,
]);

Serializer<AdminPlatformAccountListDtoOutputItemsInnerRoleEnum>
    _$adminPlatformAccountListDtoOutputItemsInnerRoleEnumSerializer =
    _$AdminPlatformAccountListDtoOutputItemsInnerRoleEnumSerializer();
Serializer<AdminPlatformAccountListDtoOutputItemsInnerStatusEnum>
    _$adminPlatformAccountListDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminPlatformAccountListDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminPlatformAccountListDtoOutputItemsInnerRoleEnumSerializer
    implements
        PrimitiveSerializer<
            AdminPlatformAccountListDtoOutputItemsInnerRoleEnum> {
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
    AdminPlatformAccountListDtoOutputItemsInnerRoleEnum
  ];
  @override
  final String wireName = 'AdminPlatformAccountListDtoOutputItemsInnerRoleEnum';

  @override
  Object serialize(Serializers serializers,
          AdminPlatformAccountListDtoOutputItemsInnerRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminPlatformAccountListDtoOutputItemsInnerRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminPlatformAccountListDtoOutputItemsInnerRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminPlatformAccountListDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            AdminPlatformAccountListDtoOutputItemsInnerStatusEnum> {
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
    AdminPlatformAccountListDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName =
      'AdminPlatformAccountListDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminPlatformAccountListDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminPlatformAccountListDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminPlatformAccountListDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminPlatformAccountListDtoOutputItemsInner
    extends AdminPlatformAccountListDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String username;
  @override
  final String? email;
  @override
  final AdminPlatformAccountListDtoOutputItemsInnerRoleEnum role;
  @override
  final AdminPlatformAccountListDtoOutputItemsInnerStatusEnum status;
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

  factory _$AdminPlatformAccountListDtoOutputItemsInner(
          [void Function(AdminPlatformAccountListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminPlatformAccountListDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$AdminPlatformAccountListDtoOutputItemsInner._(
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
  AdminPlatformAccountListDtoOutputItemsInner rebuild(
          void Function(AdminPlatformAccountListDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPlatformAccountListDtoOutputItemsInnerBuilder toBuilder() =>
      AdminPlatformAccountListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPlatformAccountListDtoOutputItemsInner &&
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
    return (newBuiltValueToStringHelper(
            r'AdminPlatformAccountListDtoOutputItemsInner')
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

class AdminPlatformAccountListDtoOutputItemsInnerBuilder
    implements
        Builder<AdminPlatformAccountListDtoOutputItemsInner,
            AdminPlatformAccountListDtoOutputItemsInnerBuilder> {
  _$AdminPlatformAccountListDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  AdminPlatformAccountListDtoOutputItemsInnerRoleEnum? _role;
  AdminPlatformAccountListDtoOutputItemsInnerRoleEnum? get role => _$this._role;
  set role(AdminPlatformAccountListDtoOutputItemsInnerRoleEnum? role) =>
      _$this._role = role;

  AdminPlatformAccountListDtoOutputItemsInnerStatusEnum? _status;
  AdminPlatformAccountListDtoOutputItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminPlatformAccountListDtoOutputItemsInnerStatusEnum? status) =>
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

  AdminPlatformAccountListDtoOutputItemsInnerBuilder() {
    AdminPlatformAccountListDtoOutputItemsInner._defaults(this);
  }

  AdminPlatformAccountListDtoOutputItemsInnerBuilder get _$this {
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
  void replace(AdminPlatformAccountListDtoOutputItemsInner other) {
    _$v = other as _$AdminPlatformAccountListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminPlatformAccountListDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPlatformAccountListDtoOutputItemsInner build() => _build();

  _$AdminPlatformAccountListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$AdminPlatformAccountListDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminPlatformAccountListDtoOutputItemsInner', 'id'),
          username: BuiltValueNullFieldError.checkNotNull(username,
              r'AdminPlatformAccountListDtoOutputItemsInner', 'username'),
          email: email,
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'AdminPlatformAccountListDtoOutputItemsInner', 'role'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminPlatformAccountListDtoOutputItemsInner', 'status'),
          mfaEnabled: BuiltValueNullFieldError.checkNotNull(mfaEnabled,
              r'AdminPlatformAccountListDtoOutputItemsInner', 'mfaEnabled'),
          passwordChangeRequired: BuiltValueNullFieldError.checkNotNull(
              passwordChangeRequired,
              r'AdminPlatformAccountListDtoOutputItemsInner',
              'passwordChangeRequired'),
          credentialDeliveryPending: BuiltValueNullFieldError.checkNotNull(
              credentialDeliveryPending,
              r'AdminPlatformAccountListDtoOutputItemsInner',
              'credentialDeliveryPending'),
          lockedReason: lockedReason,
          lockedAt: lockedAt,
          lastLoginAt: lastLoginAt,
          isSelf: BuiltValueNullFieldError.checkNotNull(
              isSelf, r'AdminPlatformAccountListDtoOutputItemsInner', 'isSelf'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
