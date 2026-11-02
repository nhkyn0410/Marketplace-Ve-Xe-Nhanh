// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_route_detail_dto_output_stops_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRouteDetailDtoOutputStopsInnerTypeEnum
    _$adminRouteDetailDtoOutputStopsInnerTypeEnum_BUS_STATION =
    const AdminRouteDetailDtoOutputStopsInnerTypeEnum._('BUS_STATION');
const AdminRouteDetailDtoOutputStopsInnerTypeEnum
    _$adminRouteDetailDtoOutputStopsInnerTypeEnum_OFFICE =
    const AdminRouteDetailDtoOutputStopsInnerTypeEnum._('OFFICE');
const AdminRouteDetailDtoOutputStopsInnerTypeEnum
    _$adminRouteDetailDtoOutputStopsInnerTypeEnum_REST_STOP =
    const AdminRouteDetailDtoOutputStopsInnerTypeEnum._('REST_STOP');
const AdminRouteDetailDtoOutputStopsInnerTypeEnum
    _$adminRouteDetailDtoOutputStopsInnerTypeEnum_PICKUP_POINT =
    const AdminRouteDetailDtoOutputStopsInnerTypeEnum._('PICKUP_POINT');

AdminRouteDetailDtoOutputStopsInnerTypeEnum
    _$adminRouteDetailDtoOutputStopsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'BUS_STATION':
      return _$adminRouteDetailDtoOutputStopsInnerTypeEnum_BUS_STATION;
    case 'OFFICE':
      return _$adminRouteDetailDtoOutputStopsInnerTypeEnum_OFFICE;
    case 'REST_STOP':
      return _$adminRouteDetailDtoOutputStopsInnerTypeEnum_REST_STOP;
    case 'PICKUP_POINT':
      return _$adminRouteDetailDtoOutputStopsInnerTypeEnum_PICKUP_POINT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRouteDetailDtoOutputStopsInnerTypeEnum>
    _$adminRouteDetailDtoOutputStopsInnerTypeEnumValues = BuiltSet<
        AdminRouteDetailDtoOutputStopsInnerTypeEnum>(const <AdminRouteDetailDtoOutputStopsInnerTypeEnum>[
  _$adminRouteDetailDtoOutputStopsInnerTypeEnum_BUS_STATION,
  _$adminRouteDetailDtoOutputStopsInnerTypeEnum_OFFICE,
  _$adminRouteDetailDtoOutputStopsInnerTypeEnum_REST_STOP,
  _$adminRouteDetailDtoOutputStopsInnerTypeEnum_PICKUP_POINT,
]);

Serializer<AdminRouteDetailDtoOutputStopsInnerTypeEnum>
    _$adminRouteDetailDtoOutputStopsInnerTypeEnumSerializer =
    _$AdminRouteDetailDtoOutputStopsInnerTypeEnumSerializer();

class _$AdminRouteDetailDtoOutputStopsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<AdminRouteDetailDtoOutputStopsInnerTypeEnum> {
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
    AdminRouteDetailDtoOutputStopsInnerTypeEnum
  ];
  @override
  final String wireName = 'AdminRouteDetailDtoOutputStopsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          AdminRouteDetailDtoOutputStopsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminRouteDetailDtoOutputStopsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminRouteDetailDtoOutputStopsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminRouteDetailDtoOutputStopsInner
    extends AdminRouteDetailDtoOutputStopsInner {
  @override
  final int sequence;
  @override
  final String name;
  @override
  final String address;
  @override
  final AdminRouteDetailDtoOutputStopsInnerTypeEnum type;
  @override
  final bool shared;
  @override
  final String? provinceName;
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final bool allowPickup;
  @override
  final bool allowDropoff;
  @override
  final int? distanceMetersFromPrevious;
  @override
  final int? durationSecondsFromPrevious;

  factory _$AdminRouteDetailDtoOutputStopsInner(
          [void Function(AdminRouteDetailDtoOutputStopsInnerBuilder)?
              updates]) =>
      (AdminRouteDetailDtoOutputStopsInnerBuilder()..update(updates))._build();

  _$AdminRouteDetailDtoOutputStopsInner._(
      {required this.sequence,
      required this.name,
      required this.address,
      required this.type,
      required this.shared,
      this.provinceName,
      required this.latitude,
      required this.longitude,
      required this.allowPickup,
      required this.allowDropoff,
      this.distanceMetersFromPrevious,
      this.durationSecondsFromPrevious})
      : super._();
  @override
  AdminRouteDetailDtoOutputStopsInner rebuild(
          void Function(AdminRouteDetailDtoOutputStopsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminRouteDetailDtoOutputStopsInnerBuilder toBuilder() =>
      AdminRouteDetailDtoOutputStopsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRouteDetailDtoOutputStopsInner &&
        sequence == other.sequence &&
        name == other.name &&
        address == other.address &&
        type == other.type &&
        shared == other.shared &&
        provinceName == other.provinceName &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        allowPickup == other.allowPickup &&
        allowDropoff == other.allowDropoff &&
        distanceMetersFromPrevious == other.distanceMetersFromPrevious &&
        durationSecondsFromPrevious == other.durationSecondsFromPrevious;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sequence.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, shared.hashCode);
    _$hash = $jc(_$hash, provinceName.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, allowPickup.hashCode);
    _$hash = $jc(_$hash, allowDropoff.hashCode);
    _$hash = $jc(_$hash, distanceMetersFromPrevious.hashCode);
    _$hash = $jc(_$hash, durationSecondsFromPrevious.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRouteDetailDtoOutputStopsInner')
          ..add('sequence', sequence)
          ..add('name', name)
          ..add('address', address)
          ..add('type', type)
          ..add('shared', shared)
          ..add('provinceName', provinceName)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('allowPickup', allowPickup)
          ..add('allowDropoff', allowDropoff)
          ..add('distanceMetersFromPrevious', distanceMetersFromPrevious)
          ..add('durationSecondsFromPrevious', durationSecondsFromPrevious))
        .toString();
  }
}

class AdminRouteDetailDtoOutputStopsInnerBuilder
    implements
        Builder<AdminRouteDetailDtoOutputStopsInner,
            AdminRouteDetailDtoOutputStopsInnerBuilder> {
  _$AdminRouteDetailDtoOutputStopsInner? _$v;

  int? _sequence;
  int? get sequence => _$this._sequence;
  set sequence(int? sequence) => _$this._sequence = sequence;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  AdminRouteDetailDtoOutputStopsInnerTypeEnum? _type;
  AdminRouteDetailDtoOutputStopsInnerTypeEnum? get type => _$this._type;
  set type(AdminRouteDetailDtoOutputStopsInnerTypeEnum? type) =>
      _$this._type = type;

  bool? _shared;
  bool? get shared => _$this._shared;
  set shared(bool? shared) => _$this._shared = shared;

  String? _provinceName;
  String? get provinceName => _$this._provinceName;
  set provinceName(String? provinceName) => _$this._provinceName = provinceName;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  bool? _allowPickup;
  bool? get allowPickup => _$this._allowPickup;
  set allowPickup(bool? allowPickup) => _$this._allowPickup = allowPickup;

  bool? _allowDropoff;
  bool? get allowDropoff => _$this._allowDropoff;
  set allowDropoff(bool? allowDropoff) => _$this._allowDropoff = allowDropoff;

  int? _distanceMetersFromPrevious;
  int? get distanceMetersFromPrevious => _$this._distanceMetersFromPrevious;
  set distanceMetersFromPrevious(int? distanceMetersFromPrevious) =>
      _$this._distanceMetersFromPrevious = distanceMetersFromPrevious;

  int? _durationSecondsFromPrevious;
  int? get durationSecondsFromPrevious => _$this._durationSecondsFromPrevious;
  set durationSecondsFromPrevious(int? durationSecondsFromPrevious) =>
      _$this._durationSecondsFromPrevious = durationSecondsFromPrevious;

  AdminRouteDetailDtoOutputStopsInnerBuilder() {
    AdminRouteDetailDtoOutputStopsInner._defaults(this);
  }

  AdminRouteDetailDtoOutputStopsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sequence = $v.sequence;
      _name = $v.name;
      _address = $v.address;
      _type = $v.type;
      _shared = $v.shared;
      _provinceName = $v.provinceName;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _allowPickup = $v.allowPickup;
      _allowDropoff = $v.allowDropoff;
      _distanceMetersFromPrevious = $v.distanceMetersFromPrevious;
      _durationSecondsFromPrevious = $v.durationSecondsFromPrevious;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRouteDetailDtoOutputStopsInner other) {
    _$v = other as _$AdminRouteDetailDtoOutputStopsInner;
  }

  @override
  void update(
      void Function(AdminRouteDetailDtoOutputStopsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRouteDetailDtoOutputStopsInner build() => _build();

  _$AdminRouteDetailDtoOutputStopsInner _build() {
    final _$result = _$v ??
        _$AdminRouteDetailDtoOutputStopsInner._(
          sequence: BuiltValueNullFieldError.checkNotNull(
              sequence, r'AdminRouteDetailDtoOutputStopsInner', 'sequence'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminRouteDetailDtoOutputStopsInner', 'name'),
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'AdminRouteDetailDtoOutputStopsInner', 'address'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'AdminRouteDetailDtoOutputStopsInner', 'type'),
          shared: BuiltValueNullFieldError.checkNotNull(
              shared, r'AdminRouteDetailDtoOutputStopsInner', 'shared'),
          provinceName: provinceName,
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'AdminRouteDetailDtoOutputStopsInner', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'AdminRouteDetailDtoOutputStopsInner', 'longitude'),
          allowPickup: BuiltValueNullFieldError.checkNotNull(allowPickup,
              r'AdminRouteDetailDtoOutputStopsInner', 'allowPickup'),
          allowDropoff: BuiltValueNullFieldError.checkNotNull(allowDropoff,
              r'AdminRouteDetailDtoOutputStopsInner', 'allowDropoff'),
          distanceMetersFromPrevious: distanceMetersFromPrevious,
          durationSecondsFromPrevious: durationSecondsFromPrevious,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
