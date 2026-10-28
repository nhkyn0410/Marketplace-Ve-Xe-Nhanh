// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_create_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ManagerCreateDtoPermissionsEnum
    _$managerCreateDtoPermissionsEnum_vehicleColonManage =
    const ManagerCreateDtoPermissionsEnum._('vehicleColonManage');
const ManagerCreateDtoPermissionsEnum
    _$managerCreateDtoPermissionsEnum_routeColonManage =
    const ManagerCreateDtoPermissionsEnum._('routeColonManage');
const ManagerCreateDtoPermissionsEnum
    _$managerCreateDtoPermissionsEnum_tripColonManage =
    const ManagerCreateDtoPermissionsEnum._('tripColonManage');
const ManagerCreateDtoPermissionsEnum
    _$managerCreateDtoPermissionsEnum_tripColonDispatch =
    const ManagerCreateDtoPermissionsEnum._('tripColonDispatch');
const ManagerCreateDtoPermissionsEnum
    _$managerCreateDtoPermissionsEnum_bookingColonRead =
    const ManagerCreateDtoPermissionsEnum._('bookingColonRead');
const ManagerCreateDtoPermissionsEnum
    _$managerCreateDtoPermissionsEnum_financeColonRead =
    const ManagerCreateDtoPermissionsEnum._('financeColonRead');
const ManagerCreateDtoPermissionsEnum
    _$managerCreateDtoPermissionsEnum_employeeColonManage =
    const ManagerCreateDtoPermissionsEnum._('employeeColonManage');
const ManagerCreateDtoPermissionsEnum
    _$managerCreateDtoPermissionsEnum_supportColonRespond =
    const ManagerCreateDtoPermissionsEnum._('supportColonRespond');
const ManagerCreateDtoPermissionsEnum
    _$managerCreateDtoPermissionsEnum_promotionColonManage =
    const ManagerCreateDtoPermissionsEnum._('promotionColonManage');

ManagerCreateDtoPermissionsEnum _$managerCreateDtoPermissionsEnumValueOf(
    String name) {
  switch (name) {
    case 'vehicleColonManage':
      return _$managerCreateDtoPermissionsEnum_vehicleColonManage;
    case 'routeColonManage':
      return _$managerCreateDtoPermissionsEnum_routeColonManage;
    case 'tripColonManage':
      return _$managerCreateDtoPermissionsEnum_tripColonManage;
    case 'tripColonDispatch':
      return _$managerCreateDtoPermissionsEnum_tripColonDispatch;
    case 'bookingColonRead':
      return _$managerCreateDtoPermissionsEnum_bookingColonRead;
    case 'financeColonRead':
      return _$managerCreateDtoPermissionsEnum_financeColonRead;
    case 'employeeColonManage':
      return _$managerCreateDtoPermissionsEnum_employeeColonManage;
    case 'supportColonRespond':
      return _$managerCreateDtoPermissionsEnum_supportColonRespond;
    case 'promotionColonManage':
      return _$managerCreateDtoPermissionsEnum_promotionColonManage;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ManagerCreateDtoPermissionsEnum>
    _$managerCreateDtoPermissionsEnumValues = BuiltSet<
        ManagerCreateDtoPermissionsEnum>(const <ManagerCreateDtoPermissionsEnum>[
  _$managerCreateDtoPermissionsEnum_vehicleColonManage,
  _$managerCreateDtoPermissionsEnum_routeColonManage,
  _$managerCreateDtoPermissionsEnum_tripColonManage,
  _$managerCreateDtoPermissionsEnum_tripColonDispatch,
  _$managerCreateDtoPermissionsEnum_bookingColonRead,
  _$managerCreateDtoPermissionsEnum_financeColonRead,
  _$managerCreateDtoPermissionsEnum_employeeColonManage,
  _$managerCreateDtoPermissionsEnum_supportColonRespond,
  _$managerCreateDtoPermissionsEnum_promotionColonManage,
]);

Serializer<ManagerCreateDtoPermissionsEnum>
    _$managerCreateDtoPermissionsEnumSerializer =
    _$ManagerCreateDtoPermissionsEnumSerializer();

class _$ManagerCreateDtoPermissionsEnumSerializer
    implements PrimitiveSerializer<ManagerCreateDtoPermissionsEnum> {
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
  final Iterable<Type> types = const <Type>[ManagerCreateDtoPermissionsEnum];
  @override
  final String wireName = 'ManagerCreateDtoPermissionsEnum';

  @override
  Object serialize(
          Serializers serializers, ManagerCreateDtoPermissionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ManagerCreateDtoPermissionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ManagerCreateDtoPermissionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ManagerCreateDto extends ManagerCreateDto {
  @override
  final String username;
  @override
  final String contactEmail;
  @override
  final BuiltList<ManagerCreateDtoPermissionsEnum> permissions;
  @override
  final String reason;

  factory _$ManagerCreateDto(
          [void Function(ManagerCreateDtoBuilder)? updates]) =>
      (ManagerCreateDtoBuilder()..update(updates))._build();

  _$ManagerCreateDto._(
      {required this.username,
      required this.contactEmail,
      required this.permissions,
      required this.reason})
      : super._();
  @override
  ManagerCreateDto rebuild(void Function(ManagerCreateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ManagerCreateDtoBuilder toBuilder() =>
      ManagerCreateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ManagerCreateDto &&
        username == other.username &&
        contactEmail == other.contactEmail &&
        permissions == other.permissions &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, contactEmail.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ManagerCreateDto')
          ..add('username', username)
          ..add('contactEmail', contactEmail)
          ..add('permissions', permissions)
          ..add('reason', reason))
        .toString();
  }
}

class ManagerCreateDtoBuilder
    implements Builder<ManagerCreateDto, ManagerCreateDtoBuilder> {
  _$ManagerCreateDto? _$v;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _contactEmail;
  String? get contactEmail => _$this._contactEmail;
  set contactEmail(String? contactEmail) => _$this._contactEmail = contactEmail;

  ListBuilder<ManagerCreateDtoPermissionsEnum>? _permissions;
  ListBuilder<ManagerCreateDtoPermissionsEnum> get permissions =>
      _$this._permissions ??= ListBuilder<ManagerCreateDtoPermissionsEnum>();
  set permissions(ListBuilder<ManagerCreateDtoPermissionsEnum>? permissions) =>
      _$this._permissions = permissions;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ManagerCreateDtoBuilder() {
    ManagerCreateDto._defaults(this);
  }

  ManagerCreateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _username = $v.username;
      _contactEmail = $v.contactEmail;
      _permissions = $v.permissions.toBuilder();
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ManagerCreateDto other) {
    _$v = other as _$ManagerCreateDto;
  }

  @override
  void update(void Function(ManagerCreateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ManagerCreateDto build() => _build();

  _$ManagerCreateDto _build() {
    _$ManagerCreateDto _$result;
    try {
      _$result = _$v ??
          _$ManagerCreateDto._(
            username: BuiltValueNullFieldError.checkNotNull(
                username, r'ManagerCreateDto', 'username'),
            contactEmail: BuiltValueNullFieldError.checkNotNull(
                contactEmail, r'ManagerCreateDto', 'contactEmail'),
            permissions: permissions.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'ManagerCreateDto', 'reason'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissions';
        permissions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ManagerCreateDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
