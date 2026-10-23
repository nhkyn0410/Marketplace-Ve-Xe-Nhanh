// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_shared_stop_point_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSharedStopPointInputDtoTypeEnum
    _$adminSharedStopPointInputDtoTypeEnum_BUS_STATION =
    const AdminSharedStopPointInputDtoTypeEnum._('BUS_STATION');
const AdminSharedStopPointInputDtoTypeEnum
    _$adminSharedStopPointInputDtoTypeEnum_PICKUP_POINT =
    const AdminSharedStopPointInputDtoTypeEnum._('PICKUP_POINT');
const AdminSharedStopPointInputDtoTypeEnum
    _$adminSharedStopPointInputDtoTypeEnum_REST_STOP =
    const AdminSharedStopPointInputDtoTypeEnum._('REST_STOP');

AdminSharedStopPointInputDtoTypeEnum
    _$adminSharedStopPointInputDtoTypeEnumValueOf(String name) {
  switch (name) {
    case 'BUS_STATION':
      return _$adminSharedStopPointInputDtoTypeEnum_BUS_STATION;
    case 'PICKUP_POINT':
      return _$adminSharedStopPointInputDtoTypeEnum_PICKUP_POINT;
    case 'REST_STOP':
      return _$adminSharedStopPointInputDtoTypeEnum_REST_STOP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSharedStopPointInputDtoTypeEnum>
    _$adminSharedStopPointInputDtoTypeEnumValues = BuiltSet<
        AdminSharedStopPointInputDtoTypeEnum>(const <AdminSharedStopPointInputDtoTypeEnum>[
  _$adminSharedStopPointInputDtoTypeEnum_BUS_STATION,
  _$adminSharedStopPointInputDtoTypeEnum_PICKUP_POINT,
  _$adminSharedStopPointInputDtoTypeEnum_REST_STOP,
]);

const AdminSharedStopPointInputDtoStatusEnum
    _$adminSharedStopPointInputDtoStatusEnum_ACTIVE =
    const AdminSharedStopPointInputDtoStatusEnum._('ACTIVE');
const AdminSharedStopPointInputDtoStatusEnum
    _$adminSharedStopPointInputDtoStatusEnum_INACTIVE =
    const AdminSharedStopPointInputDtoStatusEnum._('INACTIVE');

AdminSharedStopPointInputDtoStatusEnum
    _$adminSharedStopPointInputDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminSharedStopPointInputDtoStatusEnum_ACTIVE;
    case 'INACTIVE':
      return _$adminSharedStopPointInputDtoStatusEnum_INACTIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSharedStopPointInputDtoStatusEnum>
    _$adminSharedStopPointInputDtoStatusEnumValues = BuiltSet<
        AdminSharedStopPointInputDtoStatusEnum>(const <AdminSharedStopPointInputDtoStatusEnum>[
  _$adminSharedStopPointInputDtoStatusEnum_ACTIVE,
  _$adminSharedStopPointInputDtoStatusEnum_INACTIVE,
]);

Serializer<AdminSharedStopPointInputDtoTypeEnum>
    _$adminSharedStopPointInputDtoTypeEnumSerializer =
    _$AdminSharedStopPointInputDtoTypeEnumSerializer();
Serializer<AdminSharedStopPointInputDtoStatusEnum>
    _$adminSharedStopPointInputDtoStatusEnumSerializer =
    _$AdminSharedStopPointInputDtoStatusEnumSerializer();

class _$AdminSharedStopPointInputDtoTypeEnumSerializer
    implements PrimitiveSerializer<AdminSharedStopPointInputDtoTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUS_STATION': 'BUS_STATION',
    'PICKUP_POINT': 'PICKUP_POINT',
    'REST_STOP': 'REST_STOP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUS_STATION': 'BUS_STATION',
    'PICKUP_POINT': 'PICKUP_POINT',
    'REST_STOP': 'REST_STOP',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSharedStopPointInputDtoTypeEnum
  ];
  @override
  final String wireName = 'AdminSharedStopPointInputDtoTypeEnum';

  @override
  Object serialize(
          Serializers serializers, AdminSharedStopPointInputDtoTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSharedStopPointInputDtoTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSharedStopPointInputDtoTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSharedStopPointInputDtoStatusEnumSerializer
    implements PrimitiveSerializer<AdminSharedStopPointInputDtoStatusEnum> {
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
    AdminSharedStopPointInputDtoStatusEnum
  ];
  @override
  final String wireName = 'AdminSharedStopPointInputDtoStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSharedStopPointInputDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSharedStopPointInputDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSharedStopPointInputDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSharedStopPointInputDto extends AdminSharedStopPointInputDto {
  @override
  final String name;
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
  final AdminSharedStopPointInputDtoTypeEnum type;
  @override
  final String? legalBasis;
  @override
  final AdminSharedStopPointInputDtoStatusEnum status;

  factory _$AdminSharedStopPointInputDto(
          [void Function(AdminSharedStopPointInputDtoBuilder)? updates]) =>
      (AdminSharedStopPointInputDtoBuilder()..update(updates))._build();

  _$AdminSharedStopPointInputDto._(
      {required this.name,
      required this.address,
      required this.provinceId,
      required this.wardId,
      required this.latitude,
      required this.longitude,
      this.description,
      required this.type,
      this.legalBasis,
      required this.status})
      : super._();
  @override
  AdminSharedStopPointInputDto rebuild(
          void Function(AdminSharedStopPointInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSharedStopPointInputDtoBuilder toBuilder() =>
      AdminSharedStopPointInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSharedStopPointInputDto &&
        name == other.name &&
        address == other.address &&
        provinceId == other.provinceId &&
        wardId == other.wardId &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        description == other.description &&
        type == other.type &&
        legalBasis == other.legalBasis &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, provinceId.hashCode);
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, legalBasis.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSharedStopPointInputDto')
          ..add('name', name)
          ..add('address', address)
          ..add('provinceId', provinceId)
          ..add('wardId', wardId)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('description', description)
          ..add('type', type)
          ..add('legalBasis', legalBasis)
          ..add('status', status))
        .toString();
  }
}

class AdminSharedStopPointInputDtoBuilder
    implements
        Builder<AdminSharedStopPointInputDto,
            AdminSharedStopPointInputDtoBuilder> {
  _$AdminSharedStopPointInputDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

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

  AdminSharedStopPointInputDtoTypeEnum? _type;
  AdminSharedStopPointInputDtoTypeEnum? get type => _$this._type;
  set type(AdminSharedStopPointInputDtoTypeEnum? type) => _$this._type = type;

  String? _legalBasis;
  String? get legalBasis => _$this._legalBasis;
  set legalBasis(String? legalBasis) => _$this._legalBasis = legalBasis;

  AdminSharedStopPointInputDtoStatusEnum? _status;
  AdminSharedStopPointInputDtoStatusEnum? get status => _$this._status;
  set status(AdminSharedStopPointInputDtoStatusEnum? status) =>
      _$this._status = status;

  AdminSharedStopPointInputDtoBuilder() {
    AdminSharedStopPointInputDto._defaults(this);
  }

  AdminSharedStopPointInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _address = $v.address;
      _provinceId = $v.provinceId;
      _wardId = $v.wardId;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _description = $v.description;
      _type = $v.type;
      _legalBasis = $v.legalBasis;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSharedStopPointInputDto other) {
    _$v = other as _$AdminSharedStopPointInputDto;
  }

  @override
  void update(void Function(AdminSharedStopPointInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSharedStopPointInputDto build() => _build();

  _$AdminSharedStopPointInputDto _build() {
    final _$result = _$v ??
        _$AdminSharedStopPointInputDto._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminSharedStopPointInputDto', 'name'),
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'AdminSharedStopPointInputDto', 'address'),
          provinceId: BuiltValueNullFieldError.checkNotNull(
              provinceId, r'AdminSharedStopPointInputDto', 'provinceId'),
          wardId: BuiltValueNullFieldError.checkNotNull(
              wardId, r'AdminSharedStopPointInputDto', 'wardId'),
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'AdminSharedStopPointInputDto', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'AdminSharedStopPointInputDto', 'longitude'),
          description: description,
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'AdminSharedStopPointInputDto', 'type'),
          legalBasis: legalBasis,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminSharedStopPointInputDto', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
