// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_update_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ManagerUpdateDtoPermissionsEnum
    _$managerUpdateDtoPermissionsEnum_vehicleColonManage =
    const ManagerUpdateDtoPermissionsEnum._('vehicleColonManage');
const ManagerUpdateDtoPermissionsEnum
    _$managerUpdateDtoPermissionsEnum_routeColonManage =
    const ManagerUpdateDtoPermissionsEnum._('routeColonManage');
const ManagerUpdateDtoPermissionsEnum
    _$managerUpdateDtoPermissionsEnum_tripColonManage =
    const ManagerUpdateDtoPermissionsEnum._('tripColonManage');
const ManagerUpdateDtoPermissionsEnum
    _$managerUpdateDtoPermissionsEnum_tripColonDispatch =
    const ManagerUpdateDtoPermissionsEnum._('tripColonDispatch');
const ManagerUpdateDtoPermissionsEnum
    _$managerUpdateDtoPermissionsEnum_bookingColonRead =
    const ManagerUpdateDtoPermissionsEnum._('bookingColonRead');
const ManagerUpdateDtoPermissionsEnum
    _$managerUpdateDtoPermissionsEnum_financeColonRead =
    const ManagerUpdateDtoPermissionsEnum._('financeColonRead');
const ManagerUpdateDtoPermissionsEnum
    _$managerUpdateDtoPermissionsEnum_employeeColonManage =
    const ManagerUpdateDtoPermissionsEnum._('employeeColonManage');
const ManagerUpdateDtoPermissionsEnum
    _$managerUpdateDtoPermissionsEnum_supportColonRespond =
    const ManagerUpdateDtoPermissionsEnum._('supportColonRespond');
const ManagerUpdateDtoPermissionsEnum
    _$managerUpdateDtoPermissionsEnum_promotionColonManage =
    const ManagerUpdateDtoPermissionsEnum._('promotionColonManage');

ManagerUpdateDtoPermissionsEnum _$managerUpdateDtoPermissionsEnumValueOf(
    String name) {
  switch (name) {
    case 'vehicleColonManage':
      return _$managerUpdateDtoPermissionsEnum_vehicleColonManage;
    case 'routeColonManage':
      return _$managerUpdateDtoPermissionsEnum_routeColonManage;
    case 'tripColonManage':
      return _$managerUpdateDtoPermissionsEnum_tripColonManage;
    case 'tripColonDispatch':
      return _$managerUpdateDtoPermissionsEnum_tripColonDispatch;
    case 'bookingColonRead':
      return _$managerUpdateDtoPermissionsEnum_bookingColonRead;
    case 'financeColonRead':
      return _$managerUpdateDtoPermissionsEnum_financeColonRead;
    case 'employeeColonManage':
      return _$managerUpdateDtoPermissionsEnum_employeeColonManage;
    case 'supportColonRespond':
      return _$managerUpdateDtoPermissionsEnum_supportColonRespond;
    case 'promotionColonManage':
      return _$managerUpdateDtoPermissionsEnum_promotionColonManage;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ManagerUpdateDtoPermissionsEnum>
    _$managerUpdateDtoPermissionsEnumValues = BuiltSet<
        ManagerUpdateDtoPermissionsEnum>(const <ManagerUpdateDtoPermissionsEnum>[
  _$managerUpdateDtoPermissionsEnum_vehicleColonManage,
  _$managerUpdateDtoPermissionsEnum_routeColonManage,
  _$managerUpdateDtoPermissionsEnum_tripColonManage,
  _$managerUpdateDtoPermissionsEnum_tripColonDispatch,
  _$managerUpdateDtoPermissionsEnum_bookingColonRead,
  _$managerUpdateDtoPermissionsEnum_financeColonRead,
  _$managerUpdateDtoPermissionsEnum_employeeColonManage,
  _$managerUpdateDtoPermissionsEnum_supportColonRespond,
  _$managerUpdateDtoPermissionsEnum_promotionColonManage,
]);

const ManagerUpdateDtoStatusEnum _$managerUpdateDtoStatusEnum_ACTIVE =
    const ManagerUpdateDtoStatusEnum._('ACTIVE');
const ManagerUpdateDtoStatusEnum _$managerUpdateDtoStatusEnum_LOCKED =
    const ManagerUpdateDtoStatusEnum._('LOCKED');

ManagerUpdateDtoStatusEnum _$managerUpdateDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$managerUpdateDtoStatusEnum_ACTIVE;
    case 'LOCKED':
      return _$managerUpdateDtoStatusEnum_LOCKED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ManagerUpdateDtoStatusEnum> _$managerUpdateDtoStatusEnumValues =
    BuiltSet<ManagerUpdateDtoStatusEnum>(const <ManagerUpdateDtoStatusEnum>[
  _$managerUpdateDtoStatusEnum_ACTIVE,
  _$managerUpdateDtoStatusEnum_LOCKED,
]);

Serializer<ManagerUpdateDtoPermissionsEnum>
    _$managerUpdateDtoPermissionsEnumSerializer =
    _$ManagerUpdateDtoPermissionsEnumSerializer();
Serializer<ManagerUpdateDtoStatusEnum> _$managerUpdateDtoStatusEnumSerializer =
    _$ManagerUpdateDtoStatusEnumSerializer();

class _$ManagerUpdateDtoPermissionsEnumSerializer
    implements PrimitiveSerializer<ManagerUpdateDtoPermissionsEnum> {
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
  final Iterable<Type> types = const <Type>[ManagerUpdateDtoPermissionsEnum];
  @override
  final String wireName = 'ManagerUpdateDtoPermissionsEnum';

  @override
  Object serialize(
          Serializers serializers, ManagerUpdateDtoPermissionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ManagerUpdateDtoPermissionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ManagerUpdateDtoPermissionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ManagerUpdateDtoStatusEnumSerializer
    implements PrimitiveSerializer<ManagerUpdateDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'LOCKED': 'LOCKED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'LOCKED': 'LOCKED',
  };

  @override
  final Iterable<Type> types = const <Type>[ManagerUpdateDtoStatusEnum];
  @override
  final String wireName = 'ManagerUpdateDtoStatusEnum';

  @override
  Object serialize(Serializers serializers, ManagerUpdateDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ManagerUpdateDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ManagerUpdateDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ManagerUpdateDto extends ManagerUpdateDto {
  @override
  final BuiltList<ManagerUpdateDtoPermissionsEnum>? permissions;
  @override
  final ManagerUpdateDtoStatusEnum? status;
  @override
  final String reason;

  factory _$ManagerUpdateDto(
          [void Function(ManagerUpdateDtoBuilder)? updates]) =>
      (ManagerUpdateDtoBuilder()..update(updates))._build();

  _$ManagerUpdateDto._({this.permissions, this.status, required this.reason})
      : super._();
  @override
  ManagerUpdateDto rebuild(void Function(ManagerUpdateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ManagerUpdateDtoBuilder toBuilder() =>
      ManagerUpdateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ManagerUpdateDto &&
        permissions == other.permissions &&
        status == other.status &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ManagerUpdateDto')
          ..add('permissions', permissions)
          ..add('status', status)
          ..add('reason', reason))
        .toString();
  }
}

class ManagerUpdateDtoBuilder
    implements Builder<ManagerUpdateDto, ManagerUpdateDtoBuilder> {
  _$ManagerUpdateDto? _$v;

  ListBuilder<ManagerUpdateDtoPermissionsEnum>? _permissions;
  ListBuilder<ManagerUpdateDtoPermissionsEnum> get permissions =>
      _$this._permissions ??= ListBuilder<ManagerUpdateDtoPermissionsEnum>();
  set permissions(ListBuilder<ManagerUpdateDtoPermissionsEnum>? permissions) =>
      _$this._permissions = permissions;

  ManagerUpdateDtoStatusEnum? _status;
  ManagerUpdateDtoStatusEnum? get status => _$this._status;
  set status(ManagerUpdateDtoStatusEnum? status) => _$this._status = status;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ManagerUpdateDtoBuilder() {
    ManagerUpdateDto._defaults(this);
  }

  ManagerUpdateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _permissions = $v.permissions?.toBuilder();
      _status = $v.status;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ManagerUpdateDto other) {
    _$v = other as _$ManagerUpdateDto;
  }

  @override
  void update(void Function(ManagerUpdateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ManagerUpdateDto build() => _build();

  _$ManagerUpdateDto _build() {
    _$ManagerUpdateDto _$result;
    try {
      _$result = _$v ??
          _$ManagerUpdateDto._(
            permissions: _permissions?.build(),
            status: status,
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'ManagerUpdateDto', 'reason'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'permissions';
        _permissions?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ManagerUpdateDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
