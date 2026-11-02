// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_stop_point_proposal_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminStopPointProposalListDtoOutputItemsInnerTypeEnum
    _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_BUS_STATION =
    const AdminStopPointProposalListDtoOutputItemsInnerTypeEnum._(
        'BUS_STATION');
const AdminStopPointProposalListDtoOutputItemsInnerTypeEnum
    _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_OFFICE =
    const AdminStopPointProposalListDtoOutputItemsInnerTypeEnum._('OFFICE');
const AdminStopPointProposalListDtoOutputItemsInnerTypeEnum
    _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_REST_STOP =
    const AdminStopPointProposalListDtoOutputItemsInnerTypeEnum._('REST_STOP');
const AdminStopPointProposalListDtoOutputItemsInnerTypeEnum
    _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_PICKUP_POINT =
    const AdminStopPointProposalListDtoOutputItemsInnerTypeEnum._(
        'PICKUP_POINT');

AdminStopPointProposalListDtoOutputItemsInnerTypeEnum
    _$adminStopPointProposalListDtoOutputItemsInnerTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'BUS_STATION':
      return _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_BUS_STATION;
    case 'OFFICE':
      return _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_OFFICE;
    case 'REST_STOP':
      return _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_REST_STOP;
    case 'PICKUP_POINT':
      return _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_PICKUP_POINT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminStopPointProposalListDtoOutputItemsInnerTypeEnum>
    _$adminStopPointProposalListDtoOutputItemsInnerTypeEnumValues = BuiltSet<
        AdminStopPointProposalListDtoOutputItemsInnerTypeEnum>(const <AdminStopPointProposalListDtoOutputItemsInnerTypeEnum>[
  _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_BUS_STATION,
  _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_OFFICE,
  _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_REST_STOP,
  _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_PICKUP_POINT,
]);

const AdminStopPointProposalListDtoOutputItemsInnerStatusEnum
    _$adminStopPointProposalListDtoOutputItemsInnerStatusEnum_PENDING =
    const AdminStopPointProposalListDtoOutputItemsInnerStatusEnum._('PENDING');
const AdminStopPointProposalListDtoOutputItemsInnerStatusEnum
    _$adminStopPointProposalListDtoOutputItemsInnerStatusEnum_APPROVED =
    const AdminStopPointProposalListDtoOutputItemsInnerStatusEnum._('APPROVED');
const AdminStopPointProposalListDtoOutputItemsInnerStatusEnum
    _$adminStopPointProposalListDtoOutputItemsInnerStatusEnum_REJECTED =
    const AdminStopPointProposalListDtoOutputItemsInnerStatusEnum._('REJECTED');

AdminStopPointProposalListDtoOutputItemsInnerStatusEnum
    _$adminStopPointProposalListDtoOutputItemsInnerStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'PENDING':
      return _$adminStopPointProposalListDtoOutputItemsInnerStatusEnum_PENDING;
    case 'APPROVED':
      return _$adminStopPointProposalListDtoOutputItemsInnerStatusEnum_APPROVED;
    case 'REJECTED':
      return _$adminStopPointProposalListDtoOutputItemsInnerStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminStopPointProposalListDtoOutputItemsInnerStatusEnum>
    _$adminStopPointProposalListDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminStopPointProposalListDtoOutputItemsInnerStatusEnum>(const <AdminStopPointProposalListDtoOutputItemsInnerStatusEnum>[
  _$adminStopPointProposalListDtoOutputItemsInnerStatusEnum_PENDING,
  _$adminStopPointProposalListDtoOutputItemsInnerStatusEnum_APPROVED,
  _$adminStopPointProposalListDtoOutputItemsInnerStatusEnum_REJECTED,
]);

Serializer<AdminStopPointProposalListDtoOutputItemsInnerTypeEnum>
    _$adminStopPointProposalListDtoOutputItemsInnerTypeEnumSerializer =
    _$AdminStopPointProposalListDtoOutputItemsInnerTypeEnumSerializer();
Serializer<AdminStopPointProposalListDtoOutputItemsInnerStatusEnum>
    _$adminStopPointProposalListDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminStopPointProposalListDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminStopPointProposalListDtoOutputItemsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<
            AdminStopPointProposalListDtoOutputItemsInnerTypeEnum> {
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
    AdminStopPointProposalListDtoOutputItemsInnerTypeEnum
  ];
  @override
  final String wireName =
      'AdminStopPointProposalListDtoOutputItemsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          AdminStopPointProposalListDtoOutputItemsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminStopPointProposalListDtoOutputItemsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminStopPointProposalListDtoOutputItemsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminStopPointProposalListDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            AdminStopPointProposalListDtoOutputItemsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminStopPointProposalListDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName =
      'AdminStopPointProposalListDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminStopPointProposalListDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminStopPointProposalListDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminStopPointProposalListDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminStopPointProposalListDtoOutputItemsInner
    extends AdminStopPointProposalListDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final AdminStopPointProposalListDtoOutputItemsInnerTypeEnum type;
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
  final String legalBasis;
  @override
  final AdminStopPointProposalListDtoOutputItemsInnerStatusEnum status;
  @override
  final String? rejectionReason;
  @override
  final String? catalogStopPointId;
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final BuiltList<AdminStopPointProposalListDtoOutputItemsInnerNearbyInner>
      nearby;

  factory _$AdminStopPointProposalListDtoOutputItemsInner(
          [void Function(AdminStopPointProposalListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminStopPointProposalListDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$AdminStopPointProposalListDtoOutputItemsInner._(
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
      required this.legalBasis,
      required this.status,
      this.rejectionReason,
      this.catalogStopPointId,
      required this.operatorId,
      required this.operatorName,
      required this.nearby})
      : super._();
  @override
  AdminStopPointProposalListDtoOutputItemsInner rebuild(
          void Function(AdminStopPointProposalListDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminStopPointProposalListDtoOutputItemsInnerBuilder toBuilder() =>
      AdminStopPointProposalListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminStopPointProposalListDtoOutputItemsInner &&
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
        rejectionReason == other.rejectionReason &&
        catalogStopPointId == other.catalogStopPointId &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        nearby == other.nearby;
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
    _$hash = $jc(_$hash, rejectionReason.hashCode);
    _$hash = $jc(_$hash, catalogStopPointId.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, nearby.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminStopPointProposalListDtoOutputItemsInner')
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
          ..add('rejectionReason', rejectionReason)
          ..add('catalogStopPointId', catalogStopPointId)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('nearby', nearby))
        .toString();
  }
}

class AdminStopPointProposalListDtoOutputItemsInnerBuilder
    implements
        Builder<AdminStopPointProposalListDtoOutputItemsInner,
            AdminStopPointProposalListDtoOutputItemsInnerBuilder> {
  _$AdminStopPointProposalListDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminStopPointProposalListDtoOutputItemsInnerTypeEnum? _type;
  AdminStopPointProposalListDtoOutputItemsInnerTypeEnum? get type =>
      _$this._type;
  set type(AdminStopPointProposalListDtoOutputItemsInnerTypeEnum? type) =>
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

  AdminStopPointProposalListDtoOutputItemsInnerStatusEnum? _status;
  AdminStopPointProposalListDtoOutputItemsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminStopPointProposalListDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _rejectionReason;
  String? get rejectionReason => _$this._rejectionReason;
  set rejectionReason(String? rejectionReason) =>
      _$this._rejectionReason = rejectionReason;

  String? _catalogStopPointId;
  String? get catalogStopPointId => _$this._catalogStopPointId;
  set catalogStopPointId(String? catalogStopPointId) =>
      _$this._catalogStopPointId = catalogStopPointId;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  ListBuilder<AdminStopPointProposalListDtoOutputItemsInnerNearbyInner>?
      _nearby;
  ListBuilder<AdminStopPointProposalListDtoOutputItemsInnerNearbyInner>
      get nearby => _$this._nearby ??= ListBuilder<
          AdminStopPointProposalListDtoOutputItemsInnerNearbyInner>();
  set nearby(
          ListBuilder<AdminStopPointProposalListDtoOutputItemsInnerNearbyInner>?
              nearby) =>
      _$this._nearby = nearby;

  AdminStopPointProposalListDtoOutputItemsInnerBuilder() {
    AdminStopPointProposalListDtoOutputItemsInner._defaults(this);
  }

  AdminStopPointProposalListDtoOutputItemsInnerBuilder get _$this {
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
      _rejectionReason = $v.rejectionReason;
      _catalogStopPointId = $v.catalogStopPointId;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _nearby = $v.nearby.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminStopPointProposalListDtoOutputItemsInner other) {
    _$v = other as _$AdminStopPointProposalListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminStopPointProposalListDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminStopPointProposalListDtoOutputItemsInner build() => _build();

  _$AdminStopPointProposalListDtoOutputItemsInner _build() {
    _$AdminStopPointProposalListDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$AdminStopPointProposalListDtoOutputItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminStopPointProposalListDtoOutputItemsInner', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'AdminStopPointProposalListDtoOutputItemsInner', 'name'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'AdminStopPointProposalListDtoOutputItemsInner', 'type'),
            address: BuiltValueNullFieldError.checkNotNull(address,
                r'AdminStopPointProposalListDtoOutputItemsInner', 'address'),
            provinceId: BuiltValueNullFieldError.checkNotNull(provinceId,
                r'AdminStopPointProposalListDtoOutputItemsInner', 'provinceId'),
            wardId: BuiltValueNullFieldError.checkNotNull(wardId,
                r'AdminStopPointProposalListDtoOutputItemsInner', 'wardId'),
            latitude: BuiltValueNullFieldError.checkNotNull(latitude,
                r'AdminStopPointProposalListDtoOutputItemsInner', 'latitude'),
            longitude: BuiltValueNullFieldError.checkNotNull(longitude,
                r'AdminStopPointProposalListDtoOutputItemsInner', 'longitude'),
            description: description,
            createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
                r'AdminStopPointProposalListDtoOutputItemsInner', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt,
                r'AdminStopPointProposalListDtoOutputItemsInner', 'updatedAt'),
            provinceName: BuiltValueNullFieldError.checkNotNull(
                provinceName,
                r'AdminStopPointProposalListDtoOutputItemsInner',
                'provinceName'),
            legalBasis: BuiltValueNullFieldError.checkNotNull(legalBasis,
                r'AdminStopPointProposalListDtoOutputItemsInner', 'legalBasis'),
            status: BuiltValueNullFieldError.checkNotNull(status,
                r'AdminStopPointProposalListDtoOutputItemsInner', 'status'),
            rejectionReason: rejectionReason,
            catalogStopPointId: catalogStopPointId,
            operatorId: BuiltValueNullFieldError.checkNotNull(operatorId,
                r'AdminStopPointProposalListDtoOutputItemsInner', 'operatorId'),
            operatorName: BuiltValueNullFieldError.checkNotNull(
                operatorName,
                r'AdminStopPointProposalListDtoOutputItemsInner',
                'operatorName'),
            nearby: nearby.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'nearby';
        nearby.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminStopPointProposalListDtoOutputItemsInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
