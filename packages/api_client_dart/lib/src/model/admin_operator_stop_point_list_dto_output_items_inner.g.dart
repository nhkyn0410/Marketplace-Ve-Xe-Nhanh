// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_operator_stop_point_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum
    _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_BUS_STATION =
    const AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum._(
        'BUS_STATION');
const AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum
    _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_OFFICE =
    const AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum._('OFFICE');
const AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum
    _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_REST_STOP =
    const AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum._('REST_STOP');
const AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum
    _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_PICKUP_POINT =
    const AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum._(
        'PICKUP_POINT');

AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum
    _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'BUS_STATION':
      return _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_BUS_STATION;
    case 'OFFICE':
      return _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_OFFICE;
    case 'REST_STOP':
      return _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_REST_STOP;
    case 'PICKUP_POINT':
      return _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_PICKUP_POINT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum>
    _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnumValues = BuiltSet<
        AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum>(const <AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum>[
  _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_BUS_STATION,
  _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_OFFICE,
  _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_REST_STOP,
  _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_PICKUP_POINT,
]);

const AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum
    _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnum_ACTIVE =
    const AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum._('ACTIVE');
const AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum
    _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnum_INACTIVE =
    const AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum._('INACTIVE');
const AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum
    _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnum_SUSPENDED =
    const AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum._(
        'SUSPENDED');

AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum
    _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnum_INACTIVE;
    case 'SUSPENDED':
      return _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnum_SUSPENDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum>
    _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum>(const <AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum>[
  _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnum_ACTIVE,
  _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnum_INACTIVE,
  _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnum_SUSPENDED,
]);

Serializer<AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum>
    _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnumSerializer =
    _$AdminOperatorStopPointListDtoOutputItemsInnerTypeEnumSerializer();
Serializer<AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum>
    _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminOperatorStopPointListDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminOperatorStopPointListDtoOutputItemsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<
            AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum> {
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
    AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum
  ];
  @override
  final String wireName =
      'AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminOperatorStopPointListDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum> {
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
    AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName =
      'AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminOperatorStopPointListDtoOutputItemsInner
    extends AdminOperatorStopPointListDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum type;
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
  final AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum status;
  @override
  final String? suspensionReason;
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final int routeCount;

  factory _$AdminOperatorStopPointListDtoOutputItemsInner(
          [void Function(AdminOperatorStopPointListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminOperatorStopPointListDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$AdminOperatorStopPointListDtoOutputItemsInner._(
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
  AdminOperatorStopPointListDtoOutputItemsInner rebuild(
          void Function(AdminOperatorStopPointListDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOperatorStopPointListDtoOutputItemsInnerBuilder toBuilder() =>
      AdminOperatorStopPointListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOperatorStopPointListDtoOutputItemsInner &&
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
    return (newBuiltValueToStringHelper(
            r'AdminOperatorStopPointListDtoOutputItemsInner')
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

class AdminOperatorStopPointListDtoOutputItemsInnerBuilder
    implements
        Builder<AdminOperatorStopPointListDtoOutputItemsInner,
            AdminOperatorStopPointListDtoOutputItemsInnerBuilder> {
  _$AdminOperatorStopPointListDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum? _type;
  AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum? get type =>
      _$this._type;
  set type(AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum? type) =>
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

  AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum? _status;
  AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum? status) =>
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

  AdminOperatorStopPointListDtoOutputItemsInnerBuilder() {
    AdminOperatorStopPointListDtoOutputItemsInner._defaults(this);
  }

  AdminOperatorStopPointListDtoOutputItemsInnerBuilder get _$this {
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
  void replace(AdminOperatorStopPointListDtoOutputItemsInner other) {
    _$v = other as _$AdminOperatorStopPointListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminOperatorStopPointListDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOperatorStopPointListDtoOutputItemsInner build() => _build();

  _$AdminOperatorStopPointListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$AdminOperatorStopPointListDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminOperatorStopPointListDtoOutputItemsInner', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminOperatorStopPointListDtoOutputItemsInner', 'name'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'AdminOperatorStopPointListDtoOutputItemsInner', 'type'),
          address: BuiltValueNullFieldError.checkNotNull(address,
              r'AdminOperatorStopPointListDtoOutputItemsInner', 'address'),
          provinceId: BuiltValueNullFieldError.checkNotNull(provinceId,
              r'AdminOperatorStopPointListDtoOutputItemsInner', 'provinceId'),
          wardId: BuiltValueNullFieldError.checkNotNull(wardId,
              r'AdminOperatorStopPointListDtoOutputItemsInner', 'wardId'),
          latitude: BuiltValueNullFieldError.checkNotNull(latitude,
              r'AdminOperatorStopPointListDtoOutputItemsInner', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(longitude,
              r'AdminOperatorStopPointListDtoOutputItemsInner', 'longitude'),
          description: description,
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'AdminOperatorStopPointListDtoOutputItemsInner', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt,
              r'AdminOperatorStopPointListDtoOutputItemsInner', 'updatedAt'),
          provinceName: BuiltValueNullFieldError.checkNotNull(provinceName,
              r'AdminOperatorStopPointListDtoOutputItemsInner', 'provinceName'),
          status: BuiltValueNullFieldError.checkNotNull(status,
              r'AdminOperatorStopPointListDtoOutputItemsInner', 'status'),
          suspensionReason: suspensionReason,
          operatorId: BuiltValueNullFieldError.checkNotNull(operatorId,
              r'AdminOperatorStopPointListDtoOutputItemsInner', 'operatorId'),
          operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
              r'AdminOperatorStopPointListDtoOutputItemsInner', 'operatorName'),
          routeCount: BuiltValueNullFieldError.checkNotNull(routeCount,
              r'AdminOperatorStopPointListDtoOutputItemsInner', 'routeCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
