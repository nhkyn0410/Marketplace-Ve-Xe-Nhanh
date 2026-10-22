// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ManagerListDtoOutputItemsInnerPermissionsEnum
    _$managerListDtoOutputItemsInnerPermissionsEnum_vehicleColonManage =
    const ManagerListDtoOutputItemsInnerPermissionsEnum._('vehicleColonManage');
const ManagerListDtoOutputItemsInnerPermissionsEnum
    _$managerListDtoOutputItemsInnerPermissionsEnum_routeColonManage =
    const ManagerListDtoOutputItemsInnerPermissionsEnum._('routeColonManage');
const ManagerListDtoOutputItemsInnerPermissionsEnum
    _$managerListDtoOutputItemsInnerPermissionsEnum_tripColonManage =
    const ManagerListDtoOutputItemsInnerPermissionsEnum._('tripColonManage');
const ManagerListDtoOutputItemsInnerPermissionsEnum
    _$managerListDtoOutputItemsInnerPermissionsEnum_bookingColonRead =
    const ManagerListDtoOutputItemsInnerPermissionsEnum._('bookingColonRead');
const ManagerListDtoOutputItemsInnerPermissionsEnum
    _$managerListDtoOutputItemsInnerPermissionsEnum_financeColonRead =
    const ManagerListDtoOutputItemsInnerPermissionsEnum._('financeColonRead');
const ManagerListDtoOutputItemsInnerPermissionsEnum
    _$managerListDtoOutputItemsInnerPermissionsEnum_employeeColonManage =
    const ManagerListDtoOutputItemsInnerPermissionsEnum._(
        'employeeColonManage');
const ManagerListDtoOutputItemsInnerPermissionsEnum
    _$managerListDtoOutputItemsInnerPermissionsEnum_supportColonRespond =
    const ManagerListDtoOutputItemsInnerPermissionsEnum._(
        'supportColonRespond');
const ManagerListDtoOutputItemsInnerPermissionsEnum
    _$managerListDtoOutputItemsInnerPermissionsEnum_promotionColonManage =
    const ManagerListDtoOutputItemsInnerPermissionsEnum._(
        'promotionColonManage');

ManagerListDtoOutputItemsInnerPermissionsEnum
    _$managerListDtoOutputItemsInnerPermissionsEnumValueOf(String name) {
  switch (name) {
    case 'vehicleColonManage':
      return _$managerListDtoOutputItemsInnerPermissionsEnum_vehicleColonManage;
    case 'routeColonManage':
      return _$managerListDtoOutputItemsInnerPermissionsEnum_routeColonManage;
    case 'tripColonManage':
      return _$managerListDtoOutputItemsInnerPermissionsEnum_tripColonManage;
    case 'bookingColonRead':
      return _$managerListDtoOutputItemsInnerPermissionsEnum_bookingColonRead;
    case 'financeColonRead':
      return _$managerListDtoOutputItemsInnerPermissionsEnum_financeColonRead;
    case 'employeeColonManage':
      return _$managerListDtoOutputItemsInnerPermissionsEnum_employeeColonManage;
    case 'supportColonRespond':
      return _$managerListDtoOutputItemsInnerPermissionsEnum_supportColonRespond;
    case 'promotionColonManage':
      return _$managerListDtoOutputItemsInnerPermissionsEnum_promotionColonManage;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ManagerListDtoOutputItemsInnerPermissionsEnum>
    _$managerListDtoOutputItemsInnerPermissionsEnumValues = BuiltSet<
        ManagerListDtoOutputItemsInnerPermissionsEnum>(const <ManagerListDtoOutputItemsInnerPermissionsEnum>[
  _$managerListDtoOutputItemsInnerPermissionsEnum_vehicleColonManage,
  _$managerListDtoOutputItemsInnerPermissionsEnum_routeColonManage,
  _$managerListDtoOutputItemsInnerPermissionsEnum_tripColonManage,
  _$managerListDtoOutputItemsInnerPermissionsEnum_bookingColonRead,
  _$managerListDtoOutputItemsInnerPermissionsEnum_financeColonRead,
  _$managerListDtoOutputItemsInnerPermissionsEnum_employeeColonManage,
  _$managerListDtoOutputItemsInnerPermissionsEnum_supportColonRespond,
  _$managerListDtoOutputItemsInnerPermissionsEnum_promotionColonManage,
]);

const ManagerListDtoOutputItemsInnerStatusEnum
    _$managerListDtoOutputItemsInnerStatusEnum_ACTIVE =
    const ManagerListDtoOutputItemsInnerStatusEnum._('ACTIVE');
const ManagerListDtoOutputItemsInnerStatusEnum
    _$managerListDtoOutputItemsInnerStatusEnum_LOCKED =
    const ManagerListDtoOutputItemsInnerStatusEnum._('LOCKED');
const ManagerListDtoOutputItemsInnerStatusEnum
    _$managerListDtoOutputItemsInnerStatusEnum_DISABLED =
    const ManagerListDtoOutputItemsInnerStatusEnum._('DISABLED');

ManagerListDtoOutputItemsInnerStatusEnum
    _$managerListDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$managerListDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'LOCKED':
      return _$managerListDtoOutputItemsInnerStatusEnum_LOCKED;
    case 'DISABLED':
      return _$managerListDtoOutputItemsInnerStatusEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ManagerListDtoOutputItemsInnerStatusEnum>
    _$managerListDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        ManagerListDtoOutputItemsInnerStatusEnum>(const <ManagerListDtoOutputItemsInnerStatusEnum>[
  _$managerListDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$managerListDtoOutputItemsInnerStatusEnum_LOCKED,
  _$managerListDtoOutputItemsInnerStatusEnum_DISABLED,
]);

Serializer<ManagerListDtoOutputItemsInnerPermissionsEnum>
    _$managerListDtoOutputItemsInnerPermissionsEnumSerializer =
    _$ManagerListDtoOutputItemsInnerPermissionsEnumSerializer();
Serializer<ManagerListDtoOutputItemsInnerStatusEnum>
    _$managerListDtoOutputItemsInnerStatusEnumSerializer =
    _$ManagerListDtoOutputItemsInnerStatusEnumSerializer();

class _$ManagerListDtoOutputItemsInnerPermissionsEnumSerializer
    implements
        PrimitiveSerializer<ManagerListDtoOutputItemsInnerPermissionsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'vehicleColonManage': 'vehicle:manage',
    'routeColonManage': 'route:manage',
    'tripColonManage': 'trip:manage',
    'bookingColonRead': 'booking:read',
    'financeColonRead': 'finance:read',
    'employeeColonManage': 'employee:manage',
    'supportColonRespond': 'support:respond',
    'promotionColonManage': 'promotion:manage',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'vehicle:manage': 'vehicleColonManage',
    'route:manage': 'routeColonManage',
    'trip:manage': 'tripColonManage',
    'booking:read': 'bookingColonRead',
    'finance:read': 'financeColonRead',
    'employee:manage': 'employeeColonManage',
    'support:respond': 'supportColonRespond',
    'promotion:manage': 'promotionColonManage',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ManagerListDtoOutputItemsInnerPermissionsEnum
  ];
  @override
  final String wireName = 'ManagerListDtoOutputItemsInnerPermissionsEnum';

  @override
  Object serialize(Serializers serializers,
          ManagerListDtoOutputItemsInnerPermissionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ManagerListDtoOutputItemsInnerPermissionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ManagerListDtoOutputItemsInnerPermissionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ManagerListDtoOutputItemsInnerStatusEnumSerializer
    implements PrimitiveSerializer<ManagerListDtoOutputItemsInnerStatusEnum> {
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
    ManagerListDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'ManagerListDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          ManagerListDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ManagerListDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ManagerListDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ManagerListDtoOutputItemsInner extends ManagerListDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String username;
  @override
  final String? contactEmail;
  @override
  final BuiltList<ManagerListDtoOutputItemsInnerPermissionsEnum> permissions;
  @override
  final ManagerListDtoOutputItemsInnerStatusEnum status;
  @override
  final bool mfaEnabled;
  @override
  final bool passwordChangeRequired;
  @override
  final bool credentialDeliveryPending;
  @override
  final DateTime? temporaryPasswordExpiresAt;
  @override
  final DateTime? lastLoginAt;
  @override
  final DateTime createdAt;

  factory _$ManagerListDtoOutputItemsInner(
          [void Function(ManagerListDtoOutputItemsInnerBuilder)? updates]) =>
      (ManagerListDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$ManagerListDtoOutputItemsInner._(
      {required this.id,
      required this.username,
      this.contactEmail,
      required this.permissions,
      required this.status,
      required this.mfaEnabled,
      required this.passwordChangeRequired,
      required this.credentialDeliveryPending,
      this.temporaryPasswordExpiresAt,
      this.lastLoginAt,
      required this.createdAt})
      : super._();
  @override
  ManagerListDtoOutputItemsInner rebuild(
          void Function(ManagerListDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ManagerListDtoOutputItemsInnerBuilder toBuilder() =>
      ManagerListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ManagerListDtoOutputItemsInner &&
        id == other.id &&
        username == other.username &&
        contactEmail == other.contactEmail &&
        permissions == other.permissions &&
        status == other.status &&
        mfaEnabled == other.mfaEnabled &&
        passwordChangeRequired == other.passwordChangeRequired &&
        credentialDeliveryPending == other.credentialDeliveryPending &&
        temporaryPasswordExpiresAt == other.temporaryPasswordExpiresAt &&
        lastLoginAt == other.lastLoginAt &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, contactEmail.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, mfaEnabled.hashCode);
    _$hash = $jc(_$hash, passwordChangeRequired.hashCode);
    _$hash = $jc(_$hash, credentialDeliveryPending.hashCode);
    _$hash = $jc(_$hash, temporaryPasswordExpiresAt.hashCode);
    _$hash = $jc(_$hash, lastLoginAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ManagerListDtoOutputItemsInner')
          ..add('id', id)
          ..add('username', username)
          ..add('contactEmail', contactEmail)
          ..add('permissions', permissions)
          ..add('status', status)
          ..add('mfaEnabled', mfaEnabled)
          ..add('passwordChangeRequired', passwordChangeRequired)
          ..add('credentialDeliveryPending', credentialDeliveryPending)
          ..add('temporaryPasswordExpiresAt', temporaryPasswordExpiresAt)
          ..add('lastLoginAt', lastLoginAt)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ManagerListDtoOutputItemsInnerBuilder
    implements
        Builder<ManagerListDtoOutputItemsInner,
            ManagerListDtoOutputItemsInnerBuilder> {
  _$ManagerListDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _contactEmail;
  String? get contactEmail => _$this._contactEmail;
  set contactEmail(String? contactEmail) => _$this._contactEmail = contactEmail;

  ListBuilder<ManagerListDtoOutputItemsInnerPermissionsEnum>? _permissions;
  ListBuilder<ManagerListDtoOutputItemsInnerPermissionsEnum> get permissions =>
      _$this._permissions ??=
          ListBuilder<ManagerListDtoOutputItemsInnerPermissionsEnum>();
  set permissions(
          ListBuilder<ManagerListDtoOutputItemsInnerPermissionsEnum>?
              permissions) =>
      _$this._permissions = permissions;

  ManagerListDtoOutputItemsInnerStatusEnum? _status;
  ManagerListDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(ManagerListDtoOutputItemsInnerStatusEnum? status) =>
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

  DateTime? _lastLoginAt;
  DateTime? get lastLoginAt => _$this._lastLoginAt;
  set lastLoginAt(DateTime? lastLoginAt) => _$this._lastLoginAt = lastLoginAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ManagerListDtoOutputItemsInnerBuilder() {
    ManagerListDtoOutputItemsInner._defaults(this);
  }

  ManagerListDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _username = $v.username;
      _contactEmail = $v.contactEmail;
      _permissions = $v.permissions.toBuilder();
      _status = $v.status;
      _mfaEnabled = $v.mfaEnabled;
      _passwordChangeRequired = $v.passwordChangeRequired;
      _credentialDeliveryPending = $v.credentialDeliveryPending;
      _temporaryPasswordExpiresAt = $v.temporaryPasswordExpiresAt;
      _lastLoginAt = $v.lastLoginAt;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ManagerListDtoOutputItemsInner other) {
    _$v = other as _$ManagerListDtoOutputItemsInner;
  }

  @override
  void update(void Function(ManagerListDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ManagerListDtoOutputItemsInner build() => _build();

  _$ManagerListDtoOutputItemsInner _build() {
    _$ManagerListDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$ManagerListDtoOutputItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ManagerListDtoOutputItemsInner', 'id'),
            username: BuiltValueNullFieldError.checkNotNull(
                username, r'ManagerListDtoOutputItemsInner', 'username'),
            contactEmail: contactEmail,
            permissions: permissions.build(),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ManagerListDtoOutputItemsInner', 'status'),
            mfaEnabled: BuiltValueNullFieldError.checkNotNull(
                mfaEnabled, r'ManagerListDtoOutputItemsInner', 'mfaEnabled'),
            passwordChangeRequired: BuiltValueNullFieldError.checkNotNull(
                passwordChangeRequired,
                r'ManagerListDtoOutputItemsInner',
                'passwordChangeRequired'),
            credentialDeliveryPending: BuiltValueNullFieldError.checkNotNull(
                credentialDeliveryPending,
                r'ManagerListDtoOutputItemsInner',
                'credentialDeliveryPending'),
            temporaryPasswordExpiresAt: temporaryPasswordExpiresAt,
            lastLoginAt: lastLoginAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ManagerListDtoOutputItemsInner', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissions';
        permissions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ManagerListDtoOutputItemsInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
