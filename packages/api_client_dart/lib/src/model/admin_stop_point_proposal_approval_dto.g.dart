// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_stop_point_proposal_approval_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminStopPointProposalApprovalDtoTypeEnum
    _$adminStopPointProposalApprovalDtoTypeEnum_BUS_STATION =
    const AdminStopPointProposalApprovalDtoTypeEnum._('BUS_STATION');
const AdminStopPointProposalApprovalDtoTypeEnum
    _$adminStopPointProposalApprovalDtoTypeEnum_PICKUP_POINT =
    const AdminStopPointProposalApprovalDtoTypeEnum._('PICKUP_POINT');

AdminStopPointProposalApprovalDtoTypeEnum
    _$adminStopPointProposalApprovalDtoTypeEnumValueOf(String name) {
  switch (name) {
    case 'BUS_STATION':
      return _$adminStopPointProposalApprovalDtoTypeEnum_BUS_STATION;
    case 'PICKUP_POINT':
      return _$adminStopPointProposalApprovalDtoTypeEnum_PICKUP_POINT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminStopPointProposalApprovalDtoTypeEnum>
    _$adminStopPointProposalApprovalDtoTypeEnumValues = BuiltSet<
        AdminStopPointProposalApprovalDtoTypeEnum>(const <AdminStopPointProposalApprovalDtoTypeEnum>[
  _$adminStopPointProposalApprovalDtoTypeEnum_BUS_STATION,
  _$adminStopPointProposalApprovalDtoTypeEnum_PICKUP_POINT,
]);

Serializer<AdminStopPointProposalApprovalDtoTypeEnum>
    _$adminStopPointProposalApprovalDtoTypeEnumSerializer =
    _$AdminStopPointProposalApprovalDtoTypeEnumSerializer();

class _$AdminStopPointProposalApprovalDtoTypeEnumSerializer
    implements PrimitiveSerializer<AdminStopPointProposalApprovalDtoTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUS_STATION': 'BUS_STATION',
    'PICKUP_POINT': 'PICKUP_POINT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUS_STATION': 'BUS_STATION',
    'PICKUP_POINT': 'PICKUP_POINT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminStopPointProposalApprovalDtoTypeEnum
  ];
  @override
  final String wireName = 'AdminStopPointProposalApprovalDtoTypeEnum';

  @override
  Object serialize(Serializers serializers,
          AdminStopPointProposalApprovalDtoTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminStopPointProposalApprovalDtoTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminStopPointProposalApprovalDtoTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminStopPointProposalApprovalDto
    extends AdminStopPointProposalApprovalDto {
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
  final AdminStopPointProposalApprovalDtoTypeEnum type;
  @override
  final String legalBasis;

  factory _$AdminStopPointProposalApprovalDto(
          [void Function(AdminStopPointProposalApprovalDtoBuilder)? updates]) =>
      (AdminStopPointProposalApprovalDtoBuilder()..update(updates))._build();

  _$AdminStopPointProposalApprovalDto._(
      {required this.name,
      required this.address,
      required this.provinceId,
      required this.wardId,
      required this.latitude,
      required this.longitude,
      this.description,
      required this.type,
      required this.legalBasis})
      : super._();
  @override
  AdminStopPointProposalApprovalDto rebuild(
          void Function(AdminStopPointProposalApprovalDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminStopPointProposalApprovalDtoBuilder toBuilder() =>
      AdminStopPointProposalApprovalDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminStopPointProposalApprovalDto &&
        name == other.name &&
        address == other.address &&
        provinceId == other.provinceId &&
        wardId == other.wardId &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        description == other.description &&
        type == other.type &&
        legalBasis == other.legalBasis;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminStopPointProposalApprovalDto')
          ..add('name', name)
          ..add('address', address)
          ..add('provinceId', provinceId)
          ..add('wardId', wardId)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('description', description)
          ..add('type', type)
          ..add('legalBasis', legalBasis))
        .toString();
  }
}

class AdminStopPointProposalApprovalDtoBuilder
    implements
        Builder<AdminStopPointProposalApprovalDto,
            AdminStopPointProposalApprovalDtoBuilder> {
  _$AdminStopPointProposalApprovalDto? _$v;

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

  AdminStopPointProposalApprovalDtoTypeEnum? _type;
  AdminStopPointProposalApprovalDtoTypeEnum? get type => _$this._type;
  set type(AdminStopPointProposalApprovalDtoTypeEnum? type) =>
      _$this._type = type;

  String? _legalBasis;
  String? get legalBasis => _$this._legalBasis;
  set legalBasis(String? legalBasis) => _$this._legalBasis = legalBasis;

  AdminStopPointProposalApprovalDtoBuilder() {
    AdminStopPointProposalApprovalDto._defaults(this);
  }

  AdminStopPointProposalApprovalDtoBuilder get _$this {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminStopPointProposalApprovalDto other) {
    _$v = other as _$AdminStopPointProposalApprovalDto;
  }

  @override
  void update(
      void Function(AdminStopPointProposalApprovalDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminStopPointProposalApprovalDto build() => _build();

  _$AdminStopPointProposalApprovalDto _build() {
    final _$result = _$v ??
        _$AdminStopPointProposalApprovalDto._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminStopPointProposalApprovalDto', 'name'),
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'AdminStopPointProposalApprovalDto', 'address'),
          provinceId: BuiltValueNullFieldError.checkNotNull(
              provinceId, r'AdminStopPointProposalApprovalDto', 'provinceId'),
          wardId: BuiltValueNullFieldError.checkNotNull(
              wardId, r'AdminStopPointProposalApprovalDto', 'wardId'),
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'AdminStopPointProposalApprovalDto', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'AdminStopPointProposalApprovalDto', 'longitude'),
          description: description,
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'AdminStopPointProposalApprovalDto', 'type'),
          legalBasis: BuiltValueNullFieldError.checkNotNull(
              legalBasis, r'AdminStopPointProposalApprovalDto', 'legalBasis'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
