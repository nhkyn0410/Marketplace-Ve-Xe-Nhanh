// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_trip_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CounterTripListDtoOutputItemsInnerStatusEnum
    _$counterTripListDtoOutputItemsInnerStatusEnum_OPEN_FOR_SALE =
    const CounterTripListDtoOutputItemsInnerStatusEnum._('OPEN_FOR_SALE');
const CounterTripListDtoOutputItemsInnerStatusEnum
    _$counterTripListDtoOutputItemsInnerStatusEnum_BOARDING =
    const CounterTripListDtoOutputItemsInnerStatusEnum._('BOARDING');

CounterTripListDtoOutputItemsInnerStatusEnum
    _$counterTripListDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'OPEN_FOR_SALE':
      return _$counterTripListDtoOutputItemsInnerStatusEnum_OPEN_FOR_SALE;
    case 'BOARDING':
      return _$counterTripListDtoOutputItemsInnerStatusEnum_BOARDING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CounterTripListDtoOutputItemsInnerStatusEnum>
    _$counterTripListDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        CounterTripListDtoOutputItemsInnerStatusEnum>(const <CounterTripListDtoOutputItemsInnerStatusEnum>[
  _$counterTripListDtoOutputItemsInnerStatusEnum_OPEN_FOR_SALE,
  _$counterTripListDtoOutputItemsInnerStatusEnum_BOARDING,
]);

Serializer<CounterTripListDtoOutputItemsInnerStatusEnum>
    _$counterTripListDtoOutputItemsInnerStatusEnumSerializer =
    _$CounterTripListDtoOutputItemsInnerStatusEnumSerializer();

class _$CounterTripListDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<CounterTripListDtoOutputItemsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN_FOR_SALE': 'OPEN_FOR_SALE',
    'BOARDING': 'BOARDING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN_FOR_SALE': 'OPEN_FOR_SALE',
    'BOARDING': 'BOARDING',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CounterTripListDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'CounterTripListDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          CounterTripListDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CounterTripListDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CounterTripListDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CounterTripListDtoOutputItemsInner
    extends CounterTripListDtoOutputItemsInner {
  @override
  final String tripId;
  @override
  final String routeName;
  @override
  final DateTime departureAt;
  @override
  final DateTime arrivalAt;
  @override
  final CounterTripListDtoOutputItemsInnerStatusEnum status;
  @override
  final String? vehiclePlateNumber;
  @override
  final BuiltList<CounterTripListDtoOutputItemsInnerStopsInner> stops;
  @override
  final BuiltList<CounterTripListDtoOutputItemsInnerSeatsInner> seats;

  factory _$CounterTripListDtoOutputItemsInner(
          [void Function(CounterTripListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (CounterTripListDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$CounterTripListDtoOutputItemsInner._(
      {required this.tripId,
      required this.routeName,
      required this.departureAt,
      required this.arrivalAt,
      required this.status,
      this.vehiclePlateNumber,
      required this.stops,
      required this.seats})
      : super._();
  @override
  CounterTripListDtoOutputItemsInner rebuild(
          void Function(CounterTripListDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterTripListDtoOutputItemsInnerBuilder toBuilder() =>
      CounterTripListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterTripListDtoOutputItemsInner &&
        tripId == other.tripId &&
        routeName == other.routeName &&
        departureAt == other.departureAt &&
        arrivalAt == other.arrivalAt &&
        status == other.status &&
        vehiclePlateNumber == other.vehiclePlateNumber &&
        stops == other.stops &&
        seats == other.seats;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, arrivalAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, vehiclePlateNumber.hashCode);
    _$hash = $jc(_$hash, stops.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CounterTripListDtoOutputItemsInner')
          ..add('tripId', tripId)
          ..add('routeName', routeName)
          ..add('departureAt', departureAt)
          ..add('arrivalAt', arrivalAt)
          ..add('status', status)
          ..add('vehiclePlateNumber', vehiclePlateNumber)
          ..add('stops', stops)
          ..add('seats', seats))
        .toString();
  }
}

class CounterTripListDtoOutputItemsInnerBuilder
    implements
        Builder<CounterTripListDtoOutputItemsInner,
            CounterTripListDtoOutputItemsInnerBuilder> {
  _$CounterTripListDtoOutputItemsInner? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  DateTime? _arrivalAt;
  DateTime? get arrivalAt => _$this._arrivalAt;
  set arrivalAt(DateTime? arrivalAt) => _$this._arrivalAt = arrivalAt;

  CounterTripListDtoOutputItemsInnerStatusEnum? _status;
  CounterTripListDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(CounterTripListDtoOutputItemsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _vehiclePlateNumber;
  String? get vehiclePlateNumber => _$this._vehiclePlateNumber;
  set vehiclePlateNumber(String? vehiclePlateNumber) =>
      _$this._vehiclePlateNumber = vehiclePlateNumber;

  ListBuilder<CounterTripListDtoOutputItemsInnerStopsInner>? _stops;
  ListBuilder<CounterTripListDtoOutputItemsInnerStopsInner> get stops =>
      _$this._stops ??=
          ListBuilder<CounterTripListDtoOutputItemsInnerStopsInner>();
  set stops(ListBuilder<CounterTripListDtoOutputItemsInnerStopsInner>? stops) =>
      _$this._stops = stops;

  ListBuilder<CounterTripListDtoOutputItemsInnerSeatsInner>? _seats;
  ListBuilder<CounterTripListDtoOutputItemsInnerSeatsInner> get seats =>
      _$this._seats ??=
          ListBuilder<CounterTripListDtoOutputItemsInnerSeatsInner>();
  set seats(ListBuilder<CounterTripListDtoOutputItemsInnerSeatsInner>? seats) =>
      _$this._seats = seats;

  CounterTripListDtoOutputItemsInnerBuilder() {
    CounterTripListDtoOutputItemsInner._defaults(this);
  }

  CounterTripListDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _routeName = $v.routeName;
      _departureAt = $v.departureAt;
      _arrivalAt = $v.arrivalAt;
      _status = $v.status;
      _vehiclePlateNumber = $v.vehiclePlateNumber;
      _stops = $v.stops.toBuilder();
      _seats = $v.seats.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterTripListDtoOutputItemsInner other) {
    _$v = other as _$CounterTripListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(CounterTripListDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterTripListDtoOutputItemsInner build() => _build();

  _$CounterTripListDtoOutputItemsInner _build() {
    _$CounterTripListDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$CounterTripListDtoOutputItemsInner._(
            tripId: BuiltValueNullFieldError.checkNotNull(
                tripId, r'CounterTripListDtoOutputItemsInner', 'tripId'),
            routeName: BuiltValueNullFieldError.checkNotNull(
                routeName, r'CounterTripListDtoOutputItemsInner', 'routeName'),
            departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
                r'CounterTripListDtoOutputItemsInner', 'departureAt'),
            arrivalAt: BuiltValueNullFieldError.checkNotNull(
                arrivalAt, r'CounterTripListDtoOutputItemsInner', 'arrivalAt'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'CounterTripListDtoOutputItemsInner', 'status'),
            vehiclePlateNumber: vehiclePlateNumber,
            stops: stops.build(),
            seats: seats.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stops';
        stops.build();
        _$failedField = 'seats';
        seats.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CounterTripListDtoOutputItemsInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
