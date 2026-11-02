// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_shared_stop_point_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSharedStopPointDtoOutputTypeEnum
    _$adminSharedStopPointDtoOutputTypeEnum_BUS_STATION =
    const AdminSharedStopPointDtoOutputTypeEnum._('BUS_STATION');
const AdminSharedStopPointDtoOutputTypeEnum
    _$adminSharedStopPointDtoOutputTypeEnum_OFFICE =
    const AdminSharedStopPointDtoOutputTypeEnum._('OFFICE');
const AdminSharedStopPointDtoOutputTypeEnum
    _$adminSharedStopPointDtoOutputTypeEnum_REST_STOP =
    const AdminSharedStopPointDtoOutputTypeEnum._('REST_STOP');
const AdminSharedStopPointDtoOutputTypeEnum
    _$adminSharedStopPointDtoOutputTypeEnum_PICKUP_POINT =
    const AdminSharedStopPointDtoOutputTypeEnum._('PICKUP_POINT');

AdminSharedStopPointDtoOutputTypeEnum
    _$adminSharedStopPointDtoOutputTypeEnumValueOf(String name) {
  switch (name) {
    case 'BUS_STATION':
      return _$adminSharedStopPointDtoOutputTypeEnum_BUS_STATION;
    case 'OFFICE':
      return _$adminSharedStopPointDtoOutputTypeEnum_OFFICE;
    case 'REST_STOP':
      return _$adminSharedStopPointDtoOutputTypeEnum_REST_STOP;
    case 'PICKUP_POINT':
      return _$adminSharedStopPointDtoOutputTypeEnum_PICKUP_POINT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSharedStopPointDtoOutputTypeEnum>
    _$adminSharedStopPointDtoOutputTypeEnumValues = BuiltSet<
        AdminSharedStopPointDtoOutputTypeEnum>(const <AdminSharedStopPointDtoOutputTypeEnum>[
  _$adminSharedStopPointDtoOutputTypeEnum_BUS_STATION,
  _$adminSharedStopPointDtoOutputTypeEnum_OFFICE,
  _$adminSharedStopPointDtoOutputTypeEnum_REST_STOP,
  _$adminSharedStopPointDtoOutputTypeEnum_PICKUP_POINT,
]);

const AdminSharedStopPointDtoOutputStatusEnum
    _$adminSharedStopPointDtoOutputStatusEnum_ACTIVE =
    const AdminSharedStopPointDtoOutputStatusEnum._('ACTIVE');
const AdminSharedStopPointDtoOutputStatusEnum
    _$adminSharedStopPointDtoOutputStatusEnum_INACTIVE =
    const AdminSharedStopPointDtoOutputStatusEnum._('INACTIVE');

AdminSharedStopPointDtoOutputStatusEnum
    _$adminSharedStopPointDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminSharedStopPointDtoOutputStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminSharedStopPointDtoOutputStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSharedStopPointDtoOutputStatusEnum>
    _$adminSharedStopPointDtoOutputStatusEnumValues = BuiltSet<
        AdminSharedStopPointDtoOutputStatusEnum>(const <AdminSharedStopPointDtoOutputStatusEnum>[
  _$adminSharedStopPointDtoOutputStatusEnum_ACTIVE,
  _$adminSharedStopPointDtoOutputStatusEnum_INACTIVE,
]);

Serializer<AdminSharedStopPointDtoOutputTypeEnum>
    _$adminSharedStopPointDtoOutputTypeEnumSerializer =
    _$AdminSharedStopPointDtoOutputTypeEnumSerializer();
Serializer<AdminSharedStopPointDtoOutputStatusEnum>
    _$adminSharedStopPointDtoOutputStatusEnumSerializer =
    _$AdminSharedStopPointDtoOutputStatusEnumSerializer();

class _$AdminSharedStopPointDtoOutputTypeEnumSerializer
    implements PrimitiveSerializer<AdminSharedStopPointDtoOutputTypeEnum> {
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
    AdminSharedStopPointDtoOutputTypeEnum
  ];
  @override
  final String wireName = 'AdminSharedStopPointDtoOutputTypeEnum';

  @override
  Object serialize(
          Serializers serializers, AdminSharedStopPointDtoOutputTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSharedStopPointDtoOutputTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSharedStopPointDtoOutputTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSharedStopPointDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminSharedStopPointDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'INACTIVE': 'INACTIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSharedStopPointDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'AdminSharedStopPointDtoOutputStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSharedStopPointDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSharedStopPointDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSharedStopPointDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSharedStopPointDtoOutput extends AdminSharedStopPointDtoOutput {
  @override
  final String id;
  @override
  final String name;
  @override
  final AdminSharedStopPointDtoOutputTypeEnum type;
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
  final String? legalBasis;
  @override
  final AdminSharedStopPointDtoOutputStatusEnum status;
  @override
  final int routeCount;

  factory _$AdminSharedStopPointDtoOutput(
          [void Function(AdminSharedStopPointDtoOutputBuilder)? updates]) =>
      (AdminSharedStopPointDtoOutputBuilder()..update(updates))._build();

  _$AdminSharedStopPointDtoOutput._(
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
      this.legalBasis,
      required this.status,
      required this.routeCount})
      : super._();
  @override
  AdminSharedStopPointDtoOutput rebuild(
          void Function(AdminSharedStopPointDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSharedStopPointDtoOutputBuilder toBuilder() =>
      AdminSharedStopPointDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSharedStopPointDtoOutput &&
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
        legalBasis == other.legalBasis &&
        status == other.status &&
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
    _$hash = $jc(_$hash, legalBasis.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, routeCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSharedStopPointDtoOutput')
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
          ..add('legalBasis', legalBasis)
          ..add('status', status)
          ..add('routeCount', routeCount))
        .toString();
  }
}

class AdminSharedStopPointDtoOutputBuilder
    implements
        Builder<AdminSharedStopPointDtoOutput,
            AdminSharedStopPointDtoOutputBuilder> {
  _$AdminSharedStopPointDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminSharedStopPointDtoOutputTypeEnum? _type;
  AdminSharedStopPointDtoOutputTypeEnum? get type => _$this._type;
  set type(AdminSharedStopPointDtoOutputTypeEnum? type) => _$this._type = type;

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

  String? _legalBasis;
  String? get legalBasis => _$this._legalBasis;
  set legalBasis(String? legalBasis) => _$this._legalBasis = legalBasis;

  AdminSharedStopPointDtoOutputStatusEnum? _status;
  AdminSharedStopPointDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminSharedStopPointDtoOutputStatusEnum? status) =>
      _$this._status = status;

  int? _routeCount;
  int? get routeCount => _$this._routeCount;
  set routeCount(int? routeCount) => _$this._routeCount = routeCount;

  AdminSharedStopPointDtoOutputBuilder() {
    AdminSharedStopPointDtoOutput._defaults(this);
  }

  AdminSharedStopPointDtoOutputBuilder get _$this {
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
      _legalBasis = $v.legalBasis;
      _status = $v.status;
      _routeCount = $v.routeCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSharedStopPointDtoOutput other) {
    _$v = other as _$AdminSharedStopPointDtoOutput;
  }

  @override
  void update(void Function(AdminSharedStopPointDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSharedStopPointDtoOutput build() => _build();

  _$AdminSharedStopPointDtoOutput _build() {
    final _$result = _$v ??
        _$AdminSharedStopPointDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminSharedStopPointDtoOutput', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminSharedStopPointDtoOutput', 'name'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'AdminSharedStopPointDtoOutput', 'type'),
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'AdminSharedStopPointDtoOutput', 'address'),
          provinceId: BuiltValueNullFieldError.checkNotNull(
              provinceId, r'AdminSharedStopPointDtoOutput', 'provinceId'),
          wardId: BuiltValueNullFieldError.checkNotNull(
              wardId, r'AdminSharedStopPointDtoOutput', 'wardId'),
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'AdminSharedStopPointDtoOutput', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'AdminSharedStopPointDtoOutput', 'longitude'),
          description: description,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminSharedStopPointDtoOutput', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'AdminSharedStopPointDtoOutput', 'updatedAt'),
          provinceName: BuiltValueNullFieldError.checkNotNull(
              provinceName, r'AdminSharedStopPointDtoOutput', 'provinceName'),
          legalBasis: legalBasis,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminSharedStopPointDtoOutput', 'status'),
          routeCount: BuiltValueNullFieldError.checkNotNull(
              routeCount, r'AdminSharedStopPointDtoOutput', 'routeCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
