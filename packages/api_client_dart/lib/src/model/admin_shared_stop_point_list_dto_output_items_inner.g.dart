// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_shared_stop_point_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSharedStopPointListDtoOutputItemsInnerTypeEnum
    _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_BUS_STATION =
    const AdminSharedStopPointListDtoOutputItemsInnerTypeEnum._('BUS_STATION');
const AdminSharedStopPointListDtoOutputItemsInnerTypeEnum
    _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_OFFICE =
    const AdminSharedStopPointListDtoOutputItemsInnerTypeEnum._('OFFICE');
const AdminSharedStopPointListDtoOutputItemsInnerTypeEnum
    _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_REST_STOP =
    const AdminSharedStopPointListDtoOutputItemsInnerTypeEnum._('REST_STOP');
const AdminSharedStopPointListDtoOutputItemsInnerTypeEnum
    _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_PICKUP_POINT =
    const AdminSharedStopPointListDtoOutputItemsInnerTypeEnum._('PICKUP_POINT');

AdminSharedStopPointListDtoOutputItemsInnerTypeEnum
    _$adminSharedStopPointListDtoOutputItemsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'BUS_STATION':
      return _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_BUS_STATION;
    case 'OFFICE':
      return _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_OFFICE;
    case 'REST_STOP':
      return _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_REST_STOP;
    case 'PICKUP_POINT':
      return _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_PICKUP_POINT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSharedStopPointListDtoOutputItemsInnerTypeEnum>
    _$adminSharedStopPointListDtoOutputItemsInnerTypeEnumValues = BuiltSet<
        AdminSharedStopPointListDtoOutputItemsInnerTypeEnum>(const <AdminSharedStopPointListDtoOutputItemsInnerTypeEnum>[
  _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_BUS_STATION,
  _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_OFFICE,
  _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_REST_STOP,
  _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_PICKUP_POINT,
]);

const AdminSharedStopPointListDtoOutputItemsInnerStatusEnum
    _$adminSharedStopPointListDtoOutputItemsInnerStatusEnum_ACTIVE =
    const AdminSharedStopPointListDtoOutputItemsInnerStatusEnum._('ACTIVE');
const AdminSharedStopPointListDtoOutputItemsInnerStatusEnum
    _$adminSharedStopPointListDtoOutputItemsInnerStatusEnum_INACTIVE =
    const AdminSharedStopPointListDtoOutputItemsInnerStatusEnum._('INACTIVE');

AdminSharedStopPointListDtoOutputItemsInnerStatusEnum
    _$adminSharedStopPointListDtoOutputItemsInnerStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminSharedStopPointListDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminSharedStopPointListDtoOutputItemsInnerStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSharedStopPointListDtoOutputItemsInnerStatusEnum>
    _$adminSharedStopPointListDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminSharedStopPointListDtoOutputItemsInnerStatusEnum>(const <AdminSharedStopPointListDtoOutputItemsInnerStatusEnum>[
  _$adminSharedStopPointListDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$adminSharedStopPointListDtoOutputItemsInnerStatusEnum_INACTIVE,
]);

Serializer<AdminSharedStopPointListDtoOutputItemsInnerTypeEnum>
    _$adminSharedStopPointListDtoOutputItemsInnerTypeEnumSerializer =
    _$AdminSharedStopPointListDtoOutputItemsInnerTypeEnumSerializer();
Serializer<AdminSharedStopPointListDtoOutputItemsInnerStatusEnum>
    _$adminSharedStopPointListDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminSharedStopPointListDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminSharedStopPointListDtoOutputItemsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<
            AdminSharedStopPointListDtoOutputItemsInnerTypeEnum> {
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
    AdminSharedStopPointListDtoOutputItemsInnerTypeEnum
  ];
  @override
  final String wireName = 'AdminSharedStopPointListDtoOutputItemsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSharedStopPointListDtoOutputItemsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSharedStopPointListDtoOutputItemsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSharedStopPointListDtoOutputItemsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSharedStopPointListDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            AdminSharedStopPointListDtoOutputItemsInnerStatusEnum> {
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
    AdminSharedStopPointListDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName =
      'AdminSharedStopPointListDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSharedStopPointListDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSharedStopPointListDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSharedStopPointListDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSharedStopPointListDtoOutputItemsInner
    extends AdminSharedStopPointListDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final AdminSharedStopPointListDtoOutputItemsInnerTypeEnum type;
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
  final AdminSharedStopPointListDtoOutputItemsInnerStatusEnum status;
  @override
  final int routeCount;

  factory _$AdminSharedStopPointListDtoOutputItemsInner(
          [void Function(AdminSharedStopPointListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminSharedStopPointListDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$AdminSharedStopPointListDtoOutputItemsInner._(
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
  AdminSharedStopPointListDtoOutputItemsInner rebuild(
          void Function(AdminSharedStopPointListDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSharedStopPointListDtoOutputItemsInnerBuilder toBuilder() =>
      AdminSharedStopPointListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSharedStopPointListDtoOutputItemsInner &&
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
    return (newBuiltValueToStringHelper(
            r'AdminSharedStopPointListDtoOutputItemsInner')
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

class AdminSharedStopPointListDtoOutputItemsInnerBuilder
    implements
        Builder<AdminSharedStopPointListDtoOutputItemsInner,
            AdminSharedStopPointListDtoOutputItemsInnerBuilder> {
  _$AdminSharedStopPointListDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminSharedStopPointListDtoOutputItemsInnerTypeEnum? _type;
  AdminSharedStopPointListDtoOutputItemsInnerTypeEnum? get type => _$this._type;
  set type(AdminSharedStopPointListDtoOutputItemsInnerTypeEnum? type) =>
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

  String? _legalBasis;
  String? get legalBasis => _$this._legalBasis;
  set legalBasis(String? legalBasis) => _$this._legalBasis = legalBasis;

  AdminSharedStopPointListDtoOutputItemsInnerStatusEnum? _status;
  AdminSharedStopPointListDtoOutputItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminSharedStopPointListDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  int? _routeCount;
  int? get routeCount => _$this._routeCount;
  set routeCount(int? routeCount) => _$this._routeCount = routeCount;

  AdminSharedStopPointListDtoOutputItemsInnerBuilder() {
    AdminSharedStopPointListDtoOutputItemsInner._defaults(this);
  }

  AdminSharedStopPointListDtoOutputItemsInnerBuilder get _$this {
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
  void replace(AdminSharedStopPointListDtoOutputItemsInner other) {
    _$v = other as _$AdminSharedStopPointListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminSharedStopPointListDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSharedStopPointListDtoOutputItemsInner build() => _build();

  _$AdminSharedStopPointListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$AdminSharedStopPointListDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminSharedStopPointListDtoOutputItemsInner', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminSharedStopPointListDtoOutputItemsInner', 'name'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'AdminSharedStopPointListDtoOutputItemsInner', 'type'),
          address: BuiltValueNullFieldError.checkNotNull(address,
              r'AdminSharedStopPointListDtoOutputItemsInner', 'address'),
          provinceId: BuiltValueNullFieldError.checkNotNull(provinceId,
              r'AdminSharedStopPointListDtoOutputItemsInner', 'provinceId'),
          wardId: BuiltValueNullFieldError.checkNotNull(
              wardId, r'AdminSharedStopPointListDtoOutputItemsInner', 'wardId'),
          latitude: BuiltValueNullFieldError.checkNotNull(latitude,
              r'AdminSharedStopPointListDtoOutputItemsInner', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(longitude,
              r'AdminSharedStopPointListDtoOutputItemsInner', 'longitude'),
          description: description,
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'AdminSharedStopPointListDtoOutputItemsInner', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt,
              r'AdminSharedStopPointListDtoOutputItemsInner', 'updatedAt'),
          provinceName: BuiltValueNullFieldError.checkNotNull(provinceName,
              r'AdminSharedStopPointListDtoOutputItemsInner', 'provinceName'),
          legalBasis: legalBasis,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminSharedStopPointListDtoOutputItemsInner', 'status'),
          routeCount: BuiltValueNullFieldError.checkNotNull(routeCount,
              r'AdminSharedStopPointListDtoOutputItemsInner', 'routeCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
