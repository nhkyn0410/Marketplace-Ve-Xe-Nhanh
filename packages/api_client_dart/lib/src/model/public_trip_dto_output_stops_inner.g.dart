// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_trip_dto_output_stops_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PublicTripDtoOutputStopsInnerRoleEnum
    _$publicTripDtoOutputStopsInnerRoleEnum_ORIGIN =
    const PublicTripDtoOutputStopsInnerRoleEnum._('ORIGIN');
const PublicTripDtoOutputStopsInnerRoleEnum
    _$publicTripDtoOutputStopsInnerRoleEnum_INTERMEDIATE =
    const PublicTripDtoOutputStopsInnerRoleEnum._('INTERMEDIATE');
const PublicTripDtoOutputStopsInnerRoleEnum
    _$publicTripDtoOutputStopsInnerRoleEnum_DESTINATION =
    const PublicTripDtoOutputStopsInnerRoleEnum._('DESTINATION');

PublicTripDtoOutputStopsInnerRoleEnum
    _$publicTripDtoOutputStopsInnerRoleEnumValueOf(String name) {
  switch (name) {
    case 'ORIGIN':
      return _$publicTripDtoOutputStopsInnerRoleEnum_ORIGIN;
    case 'INTERMEDIATE':
      return _$publicTripDtoOutputStopsInnerRoleEnum_INTERMEDIATE;
    case 'DESTINATION':
      return _$publicTripDtoOutputStopsInnerRoleEnum_DESTINATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicTripDtoOutputStopsInnerRoleEnum>
    _$publicTripDtoOutputStopsInnerRoleEnumValues = BuiltSet<
        PublicTripDtoOutputStopsInnerRoleEnum>(const <PublicTripDtoOutputStopsInnerRoleEnum>[
  _$publicTripDtoOutputStopsInnerRoleEnum_ORIGIN,
  _$publicTripDtoOutputStopsInnerRoleEnum_INTERMEDIATE,
  _$publicTripDtoOutputStopsInnerRoleEnum_DESTINATION,
]);

const PublicTripDtoOutputStopsInnerTypeEnum
    _$publicTripDtoOutputStopsInnerTypeEnum_BUS_STATION =
    const PublicTripDtoOutputStopsInnerTypeEnum._('BUS_STATION');
const PublicTripDtoOutputStopsInnerTypeEnum
    _$publicTripDtoOutputStopsInnerTypeEnum_OFFICE =
    const PublicTripDtoOutputStopsInnerTypeEnum._('OFFICE');
const PublicTripDtoOutputStopsInnerTypeEnum
    _$publicTripDtoOutputStopsInnerTypeEnum_REST_STOP =
    const PublicTripDtoOutputStopsInnerTypeEnum._('REST_STOP');
const PublicTripDtoOutputStopsInnerTypeEnum
    _$publicTripDtoOutputStopsInnerTypeEnum_PICKUP_POINT =
    const PublicTripDtoOutputStopsInnerTypeEnum._('PICKUP_POINT');

PublicTripDtoOutputStopsInnerTypeEnum
    _$publicTripDtoOutputStopsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'BUS_STATION':
      return _$publicTripDtoOutputStopsInnerTypeEnum_BUS_STATION;
    case 'OFFICE':
      return _$publicTripDtoOutputStopsInnerTypeEnum_OFFICE;
    case 'REST_STOP':
      return _$publicTripDtoOutputStopsInnerTypeEnum_REST_STOP;
    case 'PICKUP_POINT':
      return _$publicTripDtoOutputStopsInnerTypeEnum_PICKUP_POINT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicTripDtoOutputStopsInnerTypeEnum>
    _$publicTripDtoOutputStopsInnerTypeEnumValues = BuiltSet<
        PublicTripDtoOutputStopsInnerTypeEnum>(const <PublicTripDtoOutputStopsInnerTypeEnum>[
  _$publicTripDtoOutputStopsInnerTypeEnum_BUS_STATION,
  _$publicTripDtoOutputStopsInnerTypeEnum_OFFICE,
  _$publicTripDtoOutputStopsInnerTypeEnum_REST_STOP,
  _$publicTripDtoOutputStopsInnerTypeEnum_PICKUP_POINT,
]);

Serializer<PublicTripDtoOutputStopsInnerRoleEnum>
    _$publicTripDtoOutputStopsInnerRoleEnumSerializer =
    _$PublicTripDtoOutputStopsInnerRoleEnumSerializer();
Serializer<PublicTripDtoOutputStopsInnerTypeEnum>
    _$publicTripDtoOutputStopsInnerTypeEnumSerializer =
    _$PublicTripDtoOutputStopsInnerTypeEnumSerializer();

class _$PublicTripDtoOutputStopsInnerRoleEnumSerializer
    implements PrimitiveSerializer<PublicTripDtoOutputStopsInnerRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ORIGIN': 'ORIGIN',
    'INTERMEDIATE': 'INTERMEDIATE',
    'DESTINATION': 'DESTINATION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ORIGIN': 'ORIGIN',
    'INTERMEDIATE': 'INTERMEDIATE',
    'DESTINATION': 'DESTINATION',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PublicTripDtoOutputStopsInnerRoleEnum
  ];
  @override
  final String wireName = 'PublicTripDtoOutputStopsInnerRoleEnum';

  @override
  Object serialize(
          Serializers serializers, PublicTripDtoOutputStopsInnerRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicTripDtoOutputStopsInnerRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicTripDtoOutputStopsInnerRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicTripDtoOutputStopsInnerTypeEnumSerializer
    implements PrimitiveSerializer<PublicTripDtoOutputStopsInnerTypeEnum> {
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
    PublicTripDtoOutputStopsInnerTypeEnum
  ];
  @override
  final String wireName = 'PublicTripDtoOutputStopsInnerTypeEnum';

  @override
  Object serialize(
          Serializers serializers, PublicTripDtoOutputStopsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicTripDtoOutputStopsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicTripDtoOutputStopsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicTripDtoOutputStopsInner extends PublicTripDtoOutputStopsInner {
  @override
  final int sequence;
  @override
  final PublicTripDtoOutputStopsInnerRoleEnum role;
  @override
  final String name;
  @override
  final String address;
  @override
  final PublicTripDtoOutputStopsInnerTypeEnum type;
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final DateTime plannedAt;
  @override
  final DateTime? pickupWindowStart;
  @override
  final DateTime? pickupWindowEnd;
  @override
  final bool allowPickup;
  @override
  final bool allowDropoff;
  @override
  final String? note;

  factory _$PublicTripDtoOutputStopsInner(
          [void Function(PublicTripDtoOutputStopsInnerBuilder)? updates]) =>
      (PublicTripDtoOutputStopsInnerBuilder()..update(updates))._build();

  _$PublicTripDtoOutputStopsInner._(
      {required this.sequence,
      required this.role,
      required this.name,
      required this.address,
      required this.type,
      required this.latitude,
      required this.longitude,
      required this.plannedAt,
      this.pickupWindowStart,
      this.pickupWindowEnd,
      required this.allowPickup,
      required this.allowDropoff,
      this.note})
      : super._();
  @override
  PublicTripDtoOutputStopsInner rebuild(
          void Function(PublicTripDtoOutputStopsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicTripDtoOutputStopsInnerBuilder toBuilder() =>
      PublicTripDtoOutputStopsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicTripDtoOutputStopsInner &&
        sequence == other.sequence &&
        role == other.role &&
        name == other.name &&
        address == other.address &&
        type == other.type &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        plannedAt == other.plannedAt &&
        pickupWindowStart == other.pickupWindowStart &&
        pickupWindowEnd == other.pickupWindowEnd &&
        allowPickup == other.allowPickup &&
        allowDropoff == other.allowDropoff &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sequence.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, plannedAt.hashCode);
    _$hash = $jc(_$hash, pickupWindowStart.hashCode);
    _$hash = $jc(_$hash, pickupWindowEnd.hashCode);
    _$hash = $jc(_$hash, allowPickup.hashCode);
    _$hash = $jc(_$hash, allowDropoff.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicTripDtoOutputStopsInner')
          ..add('sequence', sequence)
          ..add('role', role)
          ..add('name', name)
          ..add('address', address)
          ..add('type', type)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('plannedAt', plannedAt)
          ..add('pickupWindowStart', pickupWindowStart)
          ..add('pickupWindowEnd', pickupWindowEnd)
          ..add('allowPickup', allowPickup)
          ..add('allowDropoff', allowDropoff)
          ..add('note', note))
        .toString();
  }
}

class PublicTripDtoOutputStopsInnerBuilder
    implements
        Builder<PublicTripDtoOutputStopsInner,
            PublicTripDtoOutputStopsInnerBuilder> {
  _$PublicTripDtoOutputStopsInner? _$v;

  int? _sequence;
  int? get sequence => _$this._sequence;
  set sequence(int? sequence) => _$this._sequence = sequence;

  PublicTripDtoOutputStopsInnerRoleEnum? _role;
  PublicTripDtoOutputStopsInnerRoleEnum? get role => _$this._role;
  set role(PublicTripDtoOutputStopsInnerRoleEnum? role) => _$this._role = role;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  PublicTripDtoOutputStopsInnerTypeEnum? _type;
  PublicTripDtoOutputStopsInnerTypeEnum? get type => _$this._type;
  set type(PublicTripDtoOutputStopsInnerTypeEnum? type) => _$this._type = type;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  DateTime? _plannedAt;
  DateTime? get plannedAt => _$this._plannedAt;
  set plannedAt(DateTime? plannedAt) => _$this._plannedAt = plannedAt;

  DateTime? _pickupWindowStart;
  DateTime? get pickupWindowStart => _$this._pickupWindowStart;
  set pickupWindowStart(DateTime? pickupWindowStart) =>
      _$this._pickupWindowStart = pickupWindowStart;

  DateTime? _pickupWindowEnd;
  DateTime? get pickupWindowEnd => _$this._pickupWindowEnd;
  set pickupWindowEnd(DateTime? pickupWindowEnd) =>
      _$this._pickupWindowEnd = pickupWindowEnd;

  bool? _allowPickup;
  bool? get allowPickup => _$this._allowPickup;
  set allowPickup(bool? allowPickup) => _$this._allowPickup = allowPickup;

  bool? _allowDropoff;
  bool? get allowDropoff => _$this._allowDropoff;
  set allowDropoff(bool? allowDropoff) => _$this._allowDropoff = allowDropoff;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  PublicTripDtoOutputStopsInnerBuilder() {
    PublicTripDtoOutputStopsInner._defaults(this);
  }

  PublicTripDtoOutputStopsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sequence = $v.sequence;
      _role = $v.role;
      _name = $v.name;
      _address = $v.address;
      _type = $v.type;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _plannedAt = $v.plannedAt;
      _pickupWindowStart = $v.pickupWindowStart;
      _pickupWindowEnd = $v.pickupWindowEnd;
      _allowPickup = $v.allowPickup;
      _allowDropoff = $v.allowDropoff;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicTripDtoOutputStopsInner other) {
    _$v = other as _$PublicTripDtoOutputStopsInner;
  }

  @override
  void update(void Function(PublicTripDtoOutputStopsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicTripDtoOutputStopsInner build() => _build();

  _$PublicTripDtoOutputStopsInner _build() {
    final _$result = _$v ??
        _$PublicTripDtoOutputStopsInner._(
          sequence: BuiltValueNullFieldError.checkNotNull(
              sequence, r'PublicTripDtoOutputStopsInner', 'sequence'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'PublicTripDtoOutputStopsInner', 'role'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'PublicTripDtoOutputStopsInner', 'name'),
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'PublicTripDtoOutputStopsInner', 'address'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'PublicTripDtoOutputStopsInner', 'type'),
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'PublicTripDtoOutputStopsInner', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'PublicTripDtoOutputStopsInner', 'longitude'),
          plannedAt: BuiltValueNullFieldError.checkNotNull(
              plannedAt, r'PublicTripDtoOutputStopsInner', 'plannedAt'),
          pickupWindowStart: pickupWindowStart,
          pickupWindowEnd: pickupWindowEnd,
          allowPickup: BuiltValueNullFieldError.checkNotNull(
              allowPickup, r'PublicTripDtoOutputStopsInner', 'allowPickup'),
          allowDropoff: BuiltValueNullFieldError.checkNotNull(
              allowDropoff, r'PublicTripDtoOutputStopsInner', 'allowDropoff'),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
