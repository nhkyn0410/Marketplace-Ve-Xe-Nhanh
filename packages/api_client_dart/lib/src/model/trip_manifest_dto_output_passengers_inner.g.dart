// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_manifest_dto_output_passengers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TripManifestDtoOutputPassengersInnerStatusEnum
    _$tripManifestDtoOutputPassengersInnerStatusEnum_VALID =
    const TripManifestDtoOutputPassengersInnerStatusEnum._('VALID');
const TripManifestDtoOutputPassengersInnerStatusEnum
    _$tripManifestDtoOutputPassengersInnerStatusEnum_CANCELLED =
    const TripManifestDtoOutputPassengersInnerStatusEnum._('CANCELLED');
const TripManifestDtoOutputPassengersInnerStatusEnum
    _$tripManifestDtoOutputPassengersInnerStatusEnum_CHECKED_IN =
    const TripManifestDtoOutputPassengersInnerStatusEnum._('CHECKED_IN');
const TripManifestDtoOutputPassengersInnerStatusEnum
    _$tripManifestDtoOutputPassengersInnerStatusEnum_NO_SHOW =
    const TripManifestDtoOutputPassengersInnerStatusEnum._('NO_SHOW');
const TripManifestDtoOutputPassengersInnerStatusEnum
    _$tripManifestDtoOutputPassengersInnerStatusEnum_USED =
    const TripManifestDtoOutputPassengersInnerStatusEnum._('USED');
const TripManifestDtoOutputPassengersInnerStatusEnum
    _$tripManifestDtoOutputPassengersInnerStatusEnum_REFUNDED =
    const TripManifestDtoOutputPassengersInnerStatusEnum._('REFUNDED');

TripManifestDtoOutputPassengersInnerStatusEnum
    _$tripManifestDtoOutputPassengersInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'VALID':
      return _$tripManifestDtoOutputPassengersInnerStatusEnum_VALID;
    case 'CANCELLED':
      return _$tripManifestDtoOutputPassengersInnerStatusEnum_CANCELLED;
    case 'CHECKED_IN':
      return _$tripManifestDtoOutputPassengersInnerStatusEnum_CHECKED_IN;
    case 'NO_SHOW':
      return _$tripManifestDtoOutputPassengersInnerStatusEnum_NO_SHOW;
    case 'USED':
      return _$tripManifestDtoOutputPassengersInnerStatusEnum_USED;
    case 'REFUNDED':
      return _$tripManifestDtoOutputPassengersInnerStatusEnum_REFUNDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TripManifestDtoOutputPassengersInnerStatusEnum>
    _$tripManifestDtoOutputPassengersInnerStatusEnumValues = BuiltSet<
        TripManifestDtoOutputPassengersInnerStatusEnum>(const <TripManifestDtoOutputPassengersInnerStatusEnum>[
  _$tripManifestDtoOutputPassengersInnerStatusEnum_VALID,
  _$tripManifestDtoOutputPassengersInnerStatusEnum_CANCELLED,
  _$tripManifestDtoOutputPassengersInnerStatusEnum_CHECKED_IN,
  _$tripManifestDtoOutputPassengersInnerStatusEnum_NO_SHOW,
  _$tripManifestDtoOutputPassengersInnerStatusEnum_USED,
  _$tripManifestDtoOutputPassengersInnerStatusEnum_REFUNDED,
]);

Serializer<TripManifestDtoOutputPassengersInnerStatusEnum>
    _$tripManifestDtoOutputPassengersInnerStatusEnumSerializer =
    _$TripManifestDtoOutputPassengersInnerStatusEnumSerializer();

class _$TripManifestDtoOutputPassengersInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<TripManifestDtoOutputPassengersInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VALID': 'VALID',
    'CANCELLED': 'CANCELLED',
    'CHECKED_IN': 'CHECKED_IN',
    'NO_SHOW': 'NO_SHOW',
    'USED': 'USED',
    'REFUNDED': 'REFUNDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VALID': 'VALID',
    'CANCELLED': 'CANCELLED',
    'CHECKED_IN': 'CHECKED_IN',
    'NO_SHOW': 'NO_SHOW',
    'USED': 'USED',
    'REFUNDED': 'REFUNDED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    TripManifestDtoOutputPassengersInnerStatusEnum
  ];
  @override
  final String wireName = 'TripManifestDtoOutputPassengersInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          TripManifestDtoOutputPassengersInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TripManifestDtoOutputPassengersInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TripManifestDtoOutputPassengersInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TripManifestDtoOutputPassengersInner
    extends TripManifestDtoOutputPassengersInner {
  @override
  final String ticketId;
  @override
  final String ticketCode;
  @override
  final String seatCode;
  @override
  final String passengerName;
  @override
  final String phoneMasked;
  @override
  final TripManifestDtoOutputPassengersInnerPickup pickup;
  @override
  final TripManifestDtoOutputPassengersInnerPickup dropoff;
  @override
  final TripManifestDtoOutputPassengersInnerStatusEnum status;
  @override
  final DateTime? checkedInAt;

  factory _$TripManifestDtoOutputPassengersInner(
          [void Function(TripManifestDtoOutputPassengersInnerBuilder)?
              updates]) =>
      (TripManifestDtoOutputPassengersInnerBuilder()..update(updates))._build();

  _$TripManifestDtoOutputPassengersInner._(
      {required this.ticketId,
      required this.ticketCode,
      required this.seatCode,
      required this.passengerName,
      required this.phoneMasked,
      required this.pickup,
      required this.dropoff,
      required this.status,
      this.checkedInAt})
      : super._();
  @override
  TripManifestDtoOutputPassengersInner rebuild(
          void Function(TripManifestDtoOutputPassengersInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripManifestDtoOutputPassengersInnerBuilder toBuilder() =>
      TripManifestDtoOutputPassengersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripManifestDtoOutputPassengersInner &&
        ticketId == other.ticketId &&
        ticketCode == other.ticketCode &&
        seatCode == other.seatCode &&
        passengerName == other.passengerName &&
        phoneMasked == other.phoneMasked &&
        pickup == other.pickup &&
        dropoff == other.dropoff &&
        status == other.status &&
        checkedInAt == other.checkedInAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticketId.hashCode);
    _$hash = $jc(_$hash, ticketCode.hashCode);
    _$hash = $jc(_$hash, seatCode.hashCode);
    _$hash = $jc(_$hash, passengerName.hashCode);
    _$hash = $jc(_$hash, phoneMasked.hashCode);
    _$hash = $jc(_$hash, pickup.hashCode);
    _$hash = $jc(_$hash, dropoff.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, checkedInAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripManifestDtoOutputPassengersInner')
          ..add('ticketId', ticketId)
          ..add('ticketCode', ticketCode)
          ..add('seatCode', seatCode)
          ..add('passengerName', passengerName)
          ..add('phoneMasked', phoneMasked)
          ..add('pickup', pickup)
          ..add('dropoff', dropoff)
          ..add('status', status)
          ..add('checkedInAt', checkedInAt))
        .toString();
  }
}

class TripManifestDtoOutputPassengersInnerBuilder
    implements
        Builder<TripManifestDtoOutputPassengersInner,
            TripManifestDtoOutputPassengersInnerBuilder> {
  _$TripManifestDtoOutputPassengersInner? _$v;

  String? _ticketId;
  String? get ticketId => _$this._ticketId;
  set ticketId(String? ticketId) => _$this._ticketId = ticketId;

  String? _ticketCode;
  String? get ticketCode => _$this._ticketCode;
  set ticketCode(String? ticketCode) => _$this._ticketCode = ticketCode;

  String? _seatCode;
  String? get seatCode => _$this._seatCode;
  set seatCode(String? seatCode) => _$this._seatCode = seatCode;

  String? _passengerName;
  String? get passengerName => _$this._passengerName;
  set passengerName(String? passengerName) =>
      _$this._passengerName = passengerName;

  String? _phoneMasked;
  String? get phoneMasked => _$this._phoneMasked;
  set phoneMasked(String? phoneMasked) => _$this._phoneMasked = phoneMasked;

  TripManifestDtoOutputPassengersInnerPickupBuilder? _pickup;
  TripManifestDtoOutputPassengersInnerPickupBuilder get pickup =>
      _$this._pickup ??= TripManifestDtoOutputPassengersInnerPickupBuilder();
  set pickup(TripManifestDtoOutputPassengersInnerPickupBuilder? pickup) =>
      _$this._pickup = pickup;

  TripManifestDtoOutputPassengersInnerPickupBuilder? _dropoff;
  TripManifestDtoOutputPassengersInnerPickupBuilder get dropoff =>
      _$this._dropoff ??= TripManifestDtoOutputPassengersInnerPickupBuilder();
  set dropoff(TripManifestDtoOutputPassengersInnerPickupBuilder? dropoff) =>
      _$this._dropoff = dropoff;

  TripManifestDtoOutputPassengersInnerStatusEnum? _status;
  TripManifestDtoOutputPassengersInnerStatusEnum? get status => _$this._status;
  set status(TripManifestDtoOutputPassengersInnerStatusEnum? status) =>
      _$this._status = status;

  DateTime? _checkedInAt;
  DateTime? get checkedInAt => _$this._checkedInAt;
  set checkedInAt(DateTime? checkedInAt) => _$this._checkedInAt = checkedInAt;

  TripManifestDtoOutputPassengersInnerBuilder() {
    TripManifestDtoOutputPassengersInner._defaults(this);
  }

  TripManifestDtoOutputPassengersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketId = $v.ticketId;
      _ticketCode = $v.ticketCode;
      _seatCode = $v.seatCode;
      _passengerName = $v.passengerName;
      _phoneMasked = $v.phoneMasked;
      _pickup = $v.pickup.toBuilder();
      _dropoff = $v.dropoff.toBuilder();
      _status = $v.status;
      _checkedInAt = $v.checkedInAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripManifestDtoOutputPassengersInner other) {
    _$v = other as _$TripManifestDtoOutputPassengersInner;
  }

  @override
  void update(
      void Function(TripManifestDtoOutputPassengersInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripManifestDtoOutputPassengersInner build() => _build();

  _$TripManifestDtoOutputPassengersInner _build() {
    _$TripManifestDtoOutputPassengersInner _$result;
    try {
      _$result = _$v ??
          _$TripManifestDtoOutputPassengersInner._(
            ticketId: BuiltValueNullFieldError.checkNotNull(
                ticketId, r'TripManifestDtoOutputPassengersInner', 'ticketId'),
            ticketCode: BuiltValueNullFieldError.checkNotNull(ticketCode,
                r'TripManifestDtoOutputPassengersInner', 'ticketCode'),
            seatCode: BuiltValueNullFieldError.checkNotNull(
                seatCode, r'TripManifestDtoOutputPassengersInner', 'seatCode'),
            passengerName: BuiltValueNullFieldError.checkNotNull(passengerName,
                r'TripManifestDtoOutputPassengersInner', 'passengerName'),
            phoneMasked: BuiltValueNullFieldError.checkNotNull(phoneMasked,
                r'TripManifestDtoOutputPassengersInner', 'phoneMasked'),
            pickup: pickup.build(),
            dropoff: dropoff.build(),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'TripManifestDtoOutputPassengersInner', 'status'),
            checkedInAt: checkedInAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pickup';
        pickup.build();
        _$failedField = 'dropoff';
        dropoff.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripManifestDtoOutputPassengersInner',
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
