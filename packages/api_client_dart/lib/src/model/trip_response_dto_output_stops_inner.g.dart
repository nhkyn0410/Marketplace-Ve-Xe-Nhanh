// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_response_dto_output_stops_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TripResponseDtoOutputStopsInnerRoleEnum
    _$tripResponseDtoOutputStopsInnerRoleEnum_ORIGIN =
    const TripResponseDtoOutputStopsInnerRoleEnum._('ORIGIN');
const TripResponseDtoOutputStopsInnerRoleEnum
    _$tripResponseDtoOutputStopsInnerRoleEnum_INTERMEDIATE =
    const TripResponseDtoOutputStopsInnerRoleEnum._('INTERMEDIATE');
const TripResponseDtoOutputStopsInnerRoleEnum
    _$tripResponseDtoOutputStopsInnerRoleEnum_DESTINATION =
    const TripResponseDtoOutputStopsInnerRoleEnum._('DESTINATION');

TripResponseDtoOutputStopsInnerRoleEnum
    _$tripResponseDtoOutputStopsInnerRoleEnumValueOf(String name) {
  switch (name) {
    case 'ORIGIN':
      return _$tripResponseDtoOutputStopsInnerRoleEnum_ORIGIN;
    case 'INTERMEDIATE':
      return _$tripResponseDtoOutputStopsInnerRoleEnum_INTERMEDIATE;
    case 'DESTINATION':
      return _$tripResponseDtoOutputStopsInnerRoleEnum_DESTINATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TripResponseDtoOutputStopsInnerRoleEnum>
    _$tripResponseDtoOutputStopsInnerRoleEnumValues = BuiltSet<
        TripResponseDtoOutputStopsInnerRoleEnum>(const <TripResponseDtoOutputStopsInnerRoleEnum>[
  _$tripResponseDtoOutputStopsInnerRoleEnum_ORIGIN,
  _$tripResponseDtoOutputStopsInnerRoleEnum_INTERMEDIATE,
  _$tripResponseDtoOutputStopsInnerRoleEnum_DESTINATION,
]);

const TripResponseDtoOutputStopsInnerTypeEnum
    _$tripResponseDtoOutputStopsInnerTypeEnum_BUS_STATION =
    const TripResponseDtoOutputStopsInnerTypeEnum._('BUS_STATION');
const TripResponseDtoOutputStopsInnerTypeEnum
    _$tripResponseDtoOutputStopsInnerTypeEnum_OFFICE =
    const TripResponseDtoOutputStopsInnerTypeEnum._('OFFICE');
const TripResponseDtoOutputStopsInnerTypeEnum
    _$tripResponseDtoOutputStopsInnerTypeEnum_REST_STOP =
    const TripResponseDtoOutputStopsInnerTypeEnum._('REST_STOP');
const TripResponseDtoOutputStopsInnerTypeEnum
    _$tripResponseDtoOutputStopsInnerTypeEnum_PICKUP_POINT =
    const TripResponseDtoOutputStopsInnerTypeEnum._('PICKUP_POINT');

TripResponseDtoOutputStopsInnerTypeEnum
    _$tripResponseDtoOutputStopsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'BUS_STATION':
      return _$tripResponseDtoOutputStopsInnerTypeEnum_BUS_STATION;
    case 'OFFICE':
      return _$tripResponseDtoOutputStopsInnerTypeEnum_OFFICE;
    case 'REST_STOP':
      return _$tripResponseDtoOutputStopsInnerTypeEnum_REST_STOP;
    case 'PICKUP_POINT':
      return _$tripResponseDtoOutputStopsInnerTypeEnum_PICKUP_POINT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TripResponseDtoOutputStopsInnerTypeEnum>
    _$tripResponseDtoOutputStopsInnerTypeEnumValues = BuiltSet<
        TripResponseDtoOutputStopsInnerTypeEnum>(const <TripResponseDtoOutputStopsInnerTypeEnum>[
  _$tripResponseDtoOutputStopsInnerTypeEnum_BUS_STATION,
  _$tripResponseDtoOutputStopsInnerTypeEnum_OFFICE,
  _$tripResponseDtoOutputStopsInnerTypeEnum_REST_STOP,
  _$tripResponseDtoOutputStopsInnerTypeEnum_PICKUP_POINT,
]);

Serializer<TripResponseDtoOutputStopsInnerRoleEnum>
    _$tripResponseDtoOutputStopsInnerRoleEnumSerializer =
    _$TripResponseDtoOutputStopsInnerRoleEnumSerializer();
Serializer<TripResponseDtoOutputStopsInnerTypeEnum>
    _$tripResponseDtoOutputStopsInnerTypeEnumSerializer =
    _$TripResponseDtoOutputStopsInnerTypeEnumSerializer();

class _$TripResponseDtoOutputStopsInnerRoleEnumSerializer
    implements PrimitiveSerializer<TripResponseDtoOutputStopsInnerRoleEnum> {
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
    TripResponseDtoOutputStopsInnerRoleEnum
  ];
  @override
  final String wireName = 'TripResponseDtoOutputStopsInnerRoleEnum';

  @override
  Object serialize(Serializers serializers,
          TripResponseDtoOutputStopsInnerRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TripResponseDtoOutputStopsInnerRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TripResponseDtoOutputStopsInnerRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TripResponseDtoOutputStopsInnerTypeEnumSerializer
    implements PrimitiveSerializer<TripResponseDtoOutputStopsInnerTypeEnum> {
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
    TripResponseDtoOutputStopsInnerTypeEnum
  ];
  @override
  final String wireName = 'TripResponseDtoOutputStopsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          TripResponseDtoOutputStopsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TripResponseDtoOutputStopsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TripResponseDtoOutputStopsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TripResponseDtoOutputStopsInner
    extends TripResponseDtoOutputStopsInner {
  @override
  final int sequence;
  @override
  final TripResponseDtoOutputStopsInnerRoleEnum role;
  @override
  final String? catalogStopPointId;
  @override
  final String? stopPointId;
  @override
  final String name;
  @override
  final String address;
  @override
  final TripResponseDtoOutputStopsInnerTypeEnum type;
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

  factory _$TripResponseDtoOutputStopsInner(
          [void Function(TripResponseDtoOutputStopsInnerBuilder)? updates]) =>
      (TripResponseDtoOutputStopsInnerBuilder()..update(updates))._build();

  _$TripResponseDtoOutputStopsInner._(
      {required this.sequence,
      required this.role,
      this.catalogStopPointId,
      this.stopPointId,
      required this.name,
      required this.address,
      required this.type,
      required this.plannedAt,
      this.pickupWindowStart,
      this.pickupWindowEnd,
      required this.allowPickup,
      required this.allowDropoff,
      this.note})
      : super._();
  @override
  TripResponseDtoOutputStopsInner rebuild(
          void Function(TripResponseDtoOutputStopsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripResponseDtoOutputStopsInnerBuilder toBuilder() =>
      TripResponseDtoOutputStopsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripResponseDtoOutputStopsInner &&
        sequence == other.sequence &&
        role == other.role &&
        catalogStopPointId == other.catalogStopPointId &&
        stopPointId == other.stopPointId &&
        name == other.name &&
        address == other.address &&
        type == other.type &&
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
    _$hash = $jc(_$hash, catalogStopPointId.hashCode);
    _$hash = $jc(_$hash, stopPointId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
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
    return (newBuiltValueToStringHelper(r'TripResponseDtoOutputStopsInner')
          ..add('sequence', sequence)
          ..add('role', role)
          ..add('catalogStopPointId', catalogStopPointId)
          ..add('stopPointId', stopPointId)
          ..add('name', name)
          ..add('address', address)
          ..add('type', type)
          ..add('plannedAt', plannedAt)
          ..add('pickupWindowStart', pickupWindowStart)
          ..add('pickupWindowEnd', pickupWindowEnd)
          ..add('allowPickup', allowPickup)
          ..add('allowDropoff', allowDropoff)
          ..add('note', note))
        .toString();
  }
}

class TripResponseDtoOutputStopsInnerBuilder
    implements
        Builder<TripResponseDtoOutputStopsInner,
            TripResponseDtoOutputStopsInnerBuilder> {
  _$TripResponseDtoOutputStopsInner? _$v;

  int? _sequence;
  int? get sequence => _$this._sequence;
  set sequence(int? sequence) => _$this._sequence = sequence;

  TripResponseDtoOutputStopsInnerRoleEnum? _role;
  TripResponseDtoOutputStopsInnerRoleEnum? get role => _$this._role;
  set role(TripResponseDtoOutputStopsInnerRoleEnum? role) =>
      _$this._role = role;

  String? _catalogStopPointId;
  String? get catalogStopPointId => _$this._catalogStopPointId;
  set catalogStopPointId(String? catalogStopPointId) =>
      _$this._catalogStopPointId = catalogStopPointId;

  String? _stopPointId;
  String? get stopPointId => _$this._stopPointId;
  set stopPointId(String? stopPointId) => _$this._stopPointId = stopPointId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  TripResponseDtoOutputStopsInnerTypeEnum? _type;
  TripResponseDtoOutputStopsInnerTypeEnum? get type => _$this._type;
  set type(TripResponseDtoOutputStopsInnerTypeEnum? type) =>
      _$this._type = type;

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

  TripResponseDtoOutputStopsInnerBuilder() {
    TripResponseDtoOutputStopsInner._defaults(this);
  }

  TripResponseDtoOutputStopsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sequence = $v.sequence;
      _role = $v.role;
      _catalogStopPointId = $v.catalogStopPointId;
      _stopPointId = $v.stopPointId;
      _name = $v.name;
      _address = $v.address;
      _type = $v.type;
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
  void replace(TripResponseDtoOutputStopsInner other) {
    _$v = other as _$TripResponseDtoOutputStopsInner;
  }

  @override
  void update(void Function(TripResponseDtoOutputStopsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripResponseDtoOutputStopsInner build() => _build();

  _$TripResponseDtoOutputStopsInner _build() {
    final _$result = _$v ??
        _$TripResponseDtoOutputStopsInner._(
          sequence: BuiltValueNullFieldError.checkNotNull(
              sequence, r'TripResponseDtoOutputStopsInner', 'sequence'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'TripResponseDtoOutputStopsInner', 'role'),
          catalogStopPointId: catalogStopPointId,
          stopPointId: stopPointId,
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'TripResponseDtoOutputStopsInner', 'name'),
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'TripResponseDtoOutputStopsInner', 'address'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'TripResponseDtoOutputStopsInner', 'type'),
          plannedAt: BuiltValueNullFieldError.checkNotNull(
              plannedAt, r'TripResponseDtoOutputStopsInner', 'plannedAt'),
          pickupWindowStart: pickupWindowStart,
          pickupWindowEnd: pickupWindowEnd,
          allowPickup: BuiltValueNullFieldError.checkNotNull(
              allowPickup, r'TripResponseDtoOutputStopsInner', 'allowPickup'),
          allowDropoff: BuiltValueNullFieldError.checkNotNull(
              allowDropoff, r'TripResponseDtoOutputStopsInner', 'allowDropoff'),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
