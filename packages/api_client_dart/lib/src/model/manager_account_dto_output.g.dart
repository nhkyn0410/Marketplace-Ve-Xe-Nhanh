// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_account_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ManagerAccountDtoOutputPermissionsEnum
    _$managerAccountDtoOutputPermissionsEnum_vehicleColonManage =
    const ManagerAccountDtoOutputPermissionsEnum._('vehicleColonManage');
const ManagerAccountDtoOutputPermissionsEnum
    _$managerAccountDtoOutputPermissionsEnum_routeColonManage =
    const ManagerAccountDtoOutputPermissionsEnum._('routeColonManage');
const ManagerAccountDtoOutputPermissionsEnum
    _$managerAccountDtoOutputPermissionsEnum_tripColonManage =
    const ManagerAccountDtoOutputPermissionsEnum._('tripColonManage');
const ManagerAccountDtoOutputPermissionsEnum
    _$managerAccountDtoOutputPermissionsEnum_tripColonDispatch =
    const ManagerAccountDtoOutputPermissionsEnum._('tripColonDispatch');
const ManagerAccountDtoOutputPermissionsEnum
    _$managerAccountDtoOutputPermissionsEnum_bookingColonRead =
    const ManagerAccountDtoOutputPermissionsEnum._('bookingColonRead');
const ManagerAccountDtoOutputPermissionsEnum
    _$managerAccountDtoOutputPermissionsEnum_financeColonRead =
    const ManagerAccountDtoOutputPermissionsEnum._('financeColonRead');
const ManagerAccountDtoOutputPermissionsEnum
    _$managerAccountDtoOutputPermissionsEnum_employeeColonManage =
    const ManagerAccountDtoOutputPermissionsEnum._('employeeColonManage');
const ManagerAccountDtoOutputPermissionsEnum
    _$managerAccountDtoOutputPermissionsEnum_supportColonRespond =
    const ManagerAccountDtoOutputPermissionsEnum._('supportColonRespond');
const ManagerAccountDtoOutputPermissionsEnum
    _$managerAccountDtoOutputPermissionsEnum_promotionColonManage =
    const ManagerAccountDtoOutputPermissionsEnum._('promotionColonManage');

ManagerAccountDtoOutputPermissionsEnum
    _$managerAccountDtoOutputPermissionsEnumValueOf(String name) {
  switch (name) {
    case 'vehicleColonManage':
      return _$managerAccountDtoOutputPermissionsEnum_vehicleColonManage;
    case 'routeColonManage':
      return _$managerAccountDtoOutputPermissionsEnum_routeColonManage;
    case 'tripColonManage':
      return _$managerAccountDtoOutputPermissionsEnum_tripColonManage;
    case 'tripColonDispatch':
      return _$managerAccountDtoOutputPermissionsEnum_tripColonDispatch;
    case 'bookingColonRead':
      return _$managerAccountDtoOutputPermissionsEnum_bookingColonRead;
    case 'financeColonRead':
      return _$managerAccountDtoOutputPermissionsEnum_financeColonRead;
    case 'employeeColonManage':
      return _$managerAccountDtoOutputPermissionsEnum_employeeColonManage;
    case 'supportColonRespond':
      return _$managerAccountDtoOutputPermissionsEnum_supportColonRespond;
    case 'promotionColonManage':
      return _$managerAccountDtoOutputPermissionsEnum_promotionColonManage;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ManagerAccountDtoOutputPermissionsEnum>
    _$managerAccountDtoOutputPermissionsEnumValues = BuiltSet<
        ManagerAccountDtoOutputPermissionsEnum>(const <ManagerAccountDtoOutputPermissionsEnum>[
  _$managerAccountDtoOutputPermissionsEnum_vehicleColonManage,
  _$managerAccountDtoOutputPermissionsEnum_routeColonManage,
  _$managerAccountDtoOutputPermissionsEnum_tripColonManage,
  _$managerAccountDtoOutputPermissionsEnum_tripColonDispatch,
  _$managerAccountDtoOutputPermissionsEnum_bookingColonRead,
  _$managerAccountDtoOutputPermissionsEnum_financeColonRead,
  _$managerAccountDtoOutputPermissionsEnum_employeeColonManage,
  _$managerAccountDtoOutputPermissionsEnum_supportColonRespond,
  _$managerAccountDtoOutputPermissionsEnum_promotionColonManage,
]);

const ManagerAccountDtoOutputStatusEnum
    _$managerAccountDtoOutputStatusEnum_ACTIVE =
    const ManagerAccountDtoOutputStatusEnum._('ACTIVE');
const ManagerAccountDtoOutputStatusEnum
    _$managerAccountDtoOutputStatusEnum_LOCKED =
    const ManagerAccountDtoOutputStatusEnum._('LOCKED');
const ManagerAccountDtoOutputStatusEnum
    _$managerAccountDtoOutputStatusEnum_DISABLED =
    const ManagerAccountDtoOutputStatusEnum._('DISABLED');

ManagerAccountDtoOutputStatusEnum _$managerAccountDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ACTIVE':
      return _$managerAccountDtoOutputStatusEnum_ACTIVE;
    case 'LOCKED':
      return _$managerAccountDtoOutputStatusEnum_LOCKED;
    case 'DISABLED':
      return _$managerAccountDtoOutputStatusEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ManagerAccountDtoOutputStatusEnum>
    _$managerAccountDtoOutputStatusEnumValues = BuiltSet<
        ManagerAccountDtoOutputStatusEnum>(const <ManagerAccountDtoOutputStatusEnum>[
  _$managerAccountDtoOutputStatusEnum_ACTIVE,
  _$managerAccountDtoOutputStatusEnum_LOCKED,
  _$managerAccountDtoOutputStatusEnum_DISABLED,
]);

Serializer<ManagerAccountDtoOutputPermissionsEnum>
    _$managerAccountDtoOutputPermissionsEnumSerializer =
    _$ManagerAccountDtoOutputPermissionsEnumSerializer();
Serializer<ManagerAccountDtoOutputStatusEnum>
    _$managerAccountDtoOutputStatusEnumSerializer =
    _$ManagerAccountDtoOutputStatusEnumSerializer();

class _$ManagerAccountDtoOutputPermissionsEnumSerializer
    implements PrimitiveSerializer<ManagerAccountDtoOutputPermissionsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'vehicleColonManage': 'vehicle:manage',
    'routeColonManage': 'route:manage',
    'tripColonManage': 'trip:manage',
    'tripColonDispatch': 'trip:dispatch',
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
    'trip:dispatch': 'tripColonDispatch',
    'booking:read': 'bookingColonRead',
    'finance:read': 'financeColonRead',
    'employee:manage': 'employeeColonManage',
    'support:respond': 'supportColonRespond',
    'promotion:manage': 'promotionColonManage',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ManagerAccountDtoOutputPermissionsEnum
  ];
  @override
  final String wireName = 'ManagerAccountDtoOutputPermissionsEnum';

  @override
  Object serialize(Serializers serializers,
          ManagerAccountDtoOutputPermissionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ManagerAccountDtoOutputPermissionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ManagerAccountDtoOutputPermissionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ManagerAccountDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<ManagerAccountDtoOutputStatusEnum> {
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
  final Iterable<Type> types = const <Type>[ManagerAccountDtoOutputStatusEnum];
  @override
  final String wireName = 'ManagerAccountDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ManagerAccountDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ManagerAccountDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ManagerAccountDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ManagerAccountDtoOutput extends ManagerAccountDtoOutput {
  @override
  final String id;
  @override
  final String username;
  @override
  final String? contactEmail;
  @override
  final BuiltList<ManagerAccountDtoOutputPermissionsEnum> permissions;
  @override
  final ManagerAccountDtoOutputStatusEnum status;
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

  factory _$ManagerAccountDtoOutput(
          [void Function(ManagerAccountDtoOutputBuilder)? updates]) =>
      (ManagerAccountDtoOutputBuilder()..update(updates))._build();

  _$ManagerAccountDtoOutput._(
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
  ManagerAccountDtoOutput rebuild(
          void Function(ManagerAccountDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ManagerAccountDtoOutputBuilder toBuilder() =>
      ManagerAccountDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ManagerAccountDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'ManagerAccountDtoOutput')
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

class ManagerAccountDtoOutputBuilder
    implements
        Builder<ManagerAccountDtoOutput, ManagerAccountDtoOutputBuilder> {
  _$ManagerAccountDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _contactEmail;
  String? get contactEmail => _$this._contactEmail;
  set contactEmail(String? contactEmail) => _$this._contactEmail = contactEmail;

  ListBuilder<ManagerAccountDtoOutputPermissionsEnum>? _permissions;
  ListBuilder<ManagerAccountDtoOutputPermissionsEnum> get permissions =>
      _$this._permissions ??=
          ListBuilder<ManagerAccountDtoOutputPermissionsEnum>();
  set permissions(
          ListBuilder<ManagerAccountDtoOutputPermissionsEnum>? permissions) =>
      _$this._permissions = permissions;

  ManagerAccountDtoOutputStatusEnum? _status;
  ManagerAccountDtoOutputStatusEnum? get status => _$this._status;
  set status(ManagerAccountDtoOutputStatusEnum? status) =>
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

  ManagerAccountDtoOutputBuilder() {
    ManagerAccountDtoOutput._defaults(this);
  }

  ManagerAccountDtoOutputBuilder get _$this {
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
  void replace(ManagerAccountDtoOutput other) {
    _$v = other as _$ManagerAccountDtoOutput;
  }

  @override
  void update(void Function(ManagerAccountDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ManagerAccountDtoOutput build() => _build();

  _$ManagerAccountDtoOutput _build() {
    _$ManagerAccountDtoOutput _$result;
    try {
      _$result = _$v ??
          _$ManagerAccountDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ManagerAccountDtoOutput', 'id'),
            username: BuiltValueNullFieldError.checkNotNull(
                username, r'ManagerAccountDtoOutput', 'username'),
            contactEmail: contactEmail,
            permissions: permissions.build(),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ManagerAccountDtoOutput', 'status'),
            mfaEnabled: BuiltValueNullFieldError.checkNotNull(
                mfaEnabled, r'ManagerAccountDtoOutput', 'mfaEnabled'),
            passwordChangeRequired: BuiltValueNullFieldError.checkNotNull(
                passwordChangeRequired,
                r'ManagerAccountDtoOutput',
                'passwordChangeRequired'),
            credentialDeliveryPending: BuiltValueNullFieldError.checkNotNull(
                credentialDeliveryPending,
                r'ManagerAccountDtoOutput',
                'credentialDeliveryPending'),
            temporaryPasswordExpiresAt: temporaryPasswordExpiresAt,
            lastLoginAt: lastLoginAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ManagerAccountDtoOutput', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissions';
        permissions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ManagerAccountDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
