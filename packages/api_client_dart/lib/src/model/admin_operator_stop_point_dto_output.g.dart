// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_operator_stop_point_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOperatorStopPointDtoOutputTypeEnum
    _$adminOperatorStopPointDtoOutputTypeEnum_BUS_STATION =
    const AdminOperatorStopPointDtoOutputTypeEnum._('BUS_STATION');
const AdminOperatorStopPointDtoOutputTypeEnum
    _$adminOperatorStopPointDtoOutputTypeEnum_OFFICE =
    const AdminOperatorStopPointDtoOutputTypeEnum._('OFFICE');
const AdminOperatorStopPointDtoOutputTypeEnum
    _$adminOperatorStopPointDtoOutputTypeEnum_REST_STOP =
    const AdminOperatorStopPointDtoOutputTypeEnum._('REST_STOP');
const AdminOperatorStopPointDtoOutputTypeEnum
    _$adminOperatorStopPointDtoOutputTypeEnum_PICKUP_POINT =
    const AdminOperatorStopPointDtoOutputTypeEnum._('PICKUP_POINT');

AdminOperatorStopPointDtoOutputTypeEnum
    _$adminOperatorStopPointDtoOutputTypeEnumValueOf(String name) {
  switch (name) {
    case 'BUS_STATION':
      return _$adminOperatorStopPointDtoOutputTypeEnum_BUS_STATION;
    case 'OFFICE':
      return _$adminOperatorStopPointDtoOutputTypeEnum_OFFICE;
    case 'REST_STOP':
      return _$adminOperatorStopPointDtoOutputTypeEnum_REST_STOP;
    case 'PICKUP_POINT':
      return _$adminOperatorStopPointDtoOutputTypeEnum_PICKUP_POINT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOperatorStopPointDtoOutputTypeEnum>
    _$adminOperatorStopPointDtoOutputTypeEnumValues = BuiltSet<
        AdminOperatorStopPointDtoOutputTypeEnum>(const <AdminOperatorStopPointDtoOutputTypeEnum>[
  _$adminOperatorStopPointDtoOutputTypeEnum_BUS_STATION,
  _$adminOperatorStopPointDtoOutputTypeEnum_OFFICE,
  _$adminOperatorStopPointDtoOutputTypeEnum_REST_STOP,
  _$adminOperatorStopPointDtoOutputTypeEnum_PICKUP_POINT,
]);

const AdminOperatorStopPointDtoOutputStatusEnum
    _$adminOperatorStopPointDtoOutputStatusEnum_ACTIVE =
    const AdminOperatorStopPointDtoOutputStatusEnum._('ACTIVE');
const AdminOperatorStopPointDtoOutputStatusEnum
    _$adminOperatorStopPointDtoOutputStatusEnum_INACTIVE =
    const AdminOperatorStopPointDtoOutputStatusEnum._('INACTIVE');
const AdminOperatorStopPointDtoOutputStatusEnum
    _$adminOperatorStopPointDtoOutputStatusEnum_SUSPENDED =
    const AdminOperatorStopPointDtoOutputStatusEnum._('SUSPENDED');

AdminOperatorStopPointDtoOutputStatusEnum
    _$adminOperatorStopPointDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminOperatorStopPointDtoOutputStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminOperatorStopPointDtoOutputStatusEnum_INACTIVE;
    case 'SUSPENDED':
      return _$adminOperatorStopPointDtoOutputStatusEnum_SUSPENDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOperatorStopPointDtoOutputStatusEnum>
    _$adminOperatorStopPointDtoOutputStatusEnumValues = BuiltSet<
        AdminOperatorStopPointDtoOutputStatusEnum>(const <AdminOperatorStopPointDtoOutputStatusEnum>[
  _$adminOperatorStopPointDtoOutputStatusEnum_ACTIVE,
  _$adminOperatorStopPointDtoOutputStatusEnum_INACTIVE,
  _$adminOperatorStopPointDtoOutputStatusEnum_SUSPENDED,
]);

Serializer<AdminOperatorStopPointDtoOutputTypeEnum>
    _$adminOperatorStopPointDtoOutputTypeEnumSerializer =
    _$AdminOperatorStopPointDtoOutputTypeEnumSerializer();
Serializer<AdminOperatorStopPointDtoOutputStatusEnum>
    _$adminOperatorStopPointDtoOutputStatusEnumSerializer =
    _$AdminOperatorStopPointDtoOutputStatusEnumSerializer();

class _$AdminOperatorStopPointDtoOutputTypeEnumSerializer
    implements PrimitiveSerializer<AdminOperatorStopPointDtoOutputTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUS_STATION': 'BUS_STATION',
    'OFFICE': 'OFFICE',
    'REST_STOP': 'REST_STOP',
    'PICKUP_POINT': 'PICKUP_POINT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUS_STATION': 'BUS_STATION',
    'OFFICE': 'OFFICE',
    'REST_STOP': 'REST_STOP',
    'PICKUP_POINT': 'PICKUP_POINT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOperatorStopPointDtoOutputTypeEnum
  ];
  @override
  final String wireName = 'AdminOperatorStopPointDtoOutputTypeEnum';

  @override
  Object serialize(Serializers serializers,
          AdminOperatorStopPointDtoOutputTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminOperatorStopPointDtoOutputTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminOperatorStopPointDtoOutputTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminOperatorStopPointDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminOperatorStopPointDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
    'SUSPENDED': 'SUSPENDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
    'SUSPENDED': 'SUSPENDED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOperatorStopPointDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'AdminOperatorStopPointDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminOperatorStopPointDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminOperatorStopPointDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminOperatorStopPointDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminOperatorStopPointDtoOutput
    extends AdminOperatorStopPointDtoOutput {
  @override
  final String id;
  @override
  final String name;
  @override
  final AdminOperatorStopPointDtoOutputTypeEnum type;
  @override
  final String address;
  @override
  final String provinceId;
  @override
  final String wardId;
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final String? description;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String provinceName;
  @override
  final AdminOperatorStopPointDtoOutputStatusEnum status;
  @override
  final String? suspensionReason;
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final int routeCount;

  factory _$AdminOperatorStopPointDtoOutput(
          [void Function(AdminOperatorStopPointDtoOutputBuilder)? updates]) =>
      (AdminOperatorStopPointDtoOutputBuilder()..update(updates))._build();

  _$AdminOperatorStopPointDtoOutput._(
      {required this.id,
      required this.name,
      required this.type,
      required this.address,
      required this.provinceId,
      required this.wardId,
      required this.latitude,
      required this.longitude,
      this.description,
      required this.createdAt,
      required this.updatedAt,
      required this.provinceName,
      required this.status,
      this.suspensionReason,
      required this.operatorId,
      required this.operatorName,
      required this.routeCount})
      : super._();
  @override
  AdminOperatorStopPointDtoOutput rebuild(
          void Function(AdminOperatorStopPointDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOperatorStopPointDtoOutputBuilder toBuilder() =>
      AdminOperatorStopPointDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOperatorStopPointDtoOutput &&
        id == other.id &&
        name == other.name &&
        type == other.type &&
        address == other.address &&
        provinceId == other.provinceId &&
        wardId == other.wardId &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        description == other.description &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        provinceName == other.provinceName &&
        status == other.status &&
        suspensionReason == other.suspensionReason &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        routeCount == other.routeCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, provinceId.hashCode);
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, provinceName.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, suspensionReason.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, routeCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOperatorStopPointDtoOutput')
          ..add('id', id)
          ..add('name', name)
          ..add('type', type)
          ..add('address', address)
          ..add('provinceId', provinceId)
          ..add('wardId', wardId)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('description', description)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('provinceName', provinceName)
          ..add('status', status)
          ..add('suspensionReason', suspensionReason)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('routeCount', routeCount))
        .toString();
  }
}

class AdminOperatorStopPointDtoOutputBuilder
    implements
        Builder<AdminOperatorStopPointDtoOutput,
            AdminOperatorStopPointDtoOutputBuilder> {
  _$AdminOperatorStopPointDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminOperatorStopPointDtoOutputTypeEnum? _type;
  AdminOperatorStopPointDtoOutputTypeEnum? get type => _$this._type;
  set type(AdminOperatorStopPointDtoOutputTypeEnum? type) =>
      _$this._type = type;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _provinceId;
  String? get provinceId => _$this._provinceId;
  set provinceId(String? provinceId) => _$this._provinceId = provinceId;

  String? _wardId;
  String? get wardId => _$this._wardId;
  set wardId(String? wardId) => _$this._wardId = wardId;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _provinceName;
  String? get provinceName => _$this._provinceName;
  set provinceName(String? provinceName) => _$this._provinceName = provinceName;

  AdminOperatorStopPointDtoOutputStatusEnum? _status;
  AdminOperatorStopPointDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminOperatorStopPointDtoOutputStatusEnum? status) =>
      _$this._status = status;

  String? _suspensionReason;
  String? get suspensionReason => _$this._suspensionReason;
  set suspensionReason(String? suspensionReason) =>
      _$this._suspensionReason = suspensionReason;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  int? _routeCount;
  int? get routeCount => _$this._routeCount;
  set routeCount(int? routeCount) => _$this._routeCount = routeCount;

  AdminOperatorStopPointDtoOutputBuilder() {
    AdminOperatorStopPointDtoOutput._defaults(this);
  }

  AdminOperatorStopPointDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _type = $v.type;
      _address = $v.address;
      _provinceId = $v.provinceId;
      _wardId = $v.wardId;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _description = $v.description;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _provinceName = $v.provinceName;
      _status = $v.status;
      _suspensionReason = $v.suspensionReason;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _routeCount = $v.routeCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOperatorStopPointDtoOutput other) {
    _$v = other as _$AdminOperatorStopPointDtoOutput;
  }

  @override
  void update(void Function(AdminOperatorStopPointDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOperatorStopPointDtoOutput build() => _build();

  _$AdminOperatorStopPointDtoOutput _build() {
    final _$result = _$v ??
        _$AdminOperatorStopPointDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminOperatorStopPointDtoOutput', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminOperatorStopPointDtoOutput', 'name'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'AdminOperatorStopPointDtoOutput', 'type'),
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'AdminOperatorStopPointDtoOutput', 'address'),
          provinceId: BuiltValueNullFieldError.checkNotNull(
              provinceId, r'AdminOperatorStopPointDtoOutput', 'provinceId'),
          wardId: BuiltValueNullFieldError.checkNotNull(
              wardId, r'AdminOperatorStopPointDtoOutput', 'wardId'),
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'AdminOperatorStopPointDtoOutput', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'AdminOperatorStopPointDtoOutput', 'longitude'),
          description: description,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminOperatorStopPointDtoOutput', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'AdminOperatorStopPointDtoOutput', 'updatedAt'),
          provinceName: BuiltValueNullFieldError.checkNotNull(
              provinceName, r'AdminOperatorStopPointDtoOutput', 'provinceName'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminOperatorStopPointDtoOutput', 'status'),
          suspensionReason: suspensionReason,
          operatorId: BuiltValueNullFieldError.checkNotNull(
              operatorId, r'AdminOperatorStopPointDtoOutput', 'operatorId'),
          operatorName: BuiltValueNullFieldError.checkNotNull(
              operatorName, r'AdminOperatorStopPointDtoOutput', 'operatorName'),
          routeCount: BuiltValueNullFieldError.checkNotNull(
              routeCount, r'AdminOperatorStopPointDtoOutput', 'routeCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
