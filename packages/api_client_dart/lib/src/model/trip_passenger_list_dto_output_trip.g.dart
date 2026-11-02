// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_passenger_list_dto_output_trip.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripPassengerListDtoOutputTrip extends TripPassengerListDtoOutputTrip {
  @override
  final String tripId;
  @override
  final DateTime departureAt;
  @override
  final String routeName;
  @override
  final String? vehiclePlateNumber;
  @override
  final int seatCount;

  factory _$TripPassengerListDtoOutputTrip(
          [void Function(TripPassengerListDtoOutputTripBuilder)? updates]) =>
      (TripPassengerListDtoOutputTripBuilder()..update(updates))._build();

  _$TripPassengerListDtoOutputTrip._(
      {required this.tripId,
      required this.departureAt,
      required this.routeName,
      this.vehiclePlateNumber,
      required this.seatCount})
      : super._();
  @override
  TripPassengerListDtoOutputTrip rebuild(
          void Function(TripPassengerListDtoOutputTripBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripPassengerListDtoOutputTripBuilder toBuilder() =>
      TripPassengerListDtoOutputTripBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripPassengerListDtoOutputTrip &&
        tripId == other.tripId &&
        departureAt == other.departureAt &&
        routeName == other.routeName &&
        vehiclePlateNumber == other.vehiclePlateNumber &&
        seatCount == other.seatCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, vehiclePlateNumber.hashCode);
    _$hash = $jc(_$hash, seatCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripPassengerListDtoOutputTrip')
          ..add('tripId', tripId)
          ..add('departureAt', departureAt)
          ..add('routeName', routeName)
          ..add('vehiclePlateNumber', vehiclePlateNumber)
          ..add('seatCount', seatCount))
        .toString();
  }
}

class TripPassengerListDtoOutputTripBuilder
    implements
        Builder<TripPassengerListDtoOutputTrip,
            TripPassengerListDtoOutputTripBuilder> {
  _$TripPassengerListDtoOutputTrip? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  String? _vehiclePlateNumber;
  String? get vehiclePlateNumber => _$this._vehiclePlateNumber;
  set vehiclePlateNumber(String? vehiclePlateNumber) =>
      _$this._vehiclePlateNumber = vehiclePlateNumber;

  int? _seatCount;
  int? get seatCount => _$this._seatCount;
  set seatCount(int? seatCount) => _$this._seatCount = seatCount;

  TripPassengerListDtoOutputTripBuilder() {
    TripPassengerListDtoOutputTrip._defaults(this);
  }

  TripPassengerListDtoOutputTripBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _departureAt = $v.departureAt;
      _routeName = $v.routeName;
      _vehiclePlateNumber = $v.vehiclePlateNumber;
      _seatCount = $v.seatCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripPassengerListDtoOutputTrip other) {
    _$v = other as _$TripPassengerListDtoOutputTrip;
  }

  @override
  void update(void Function(TripPassengerListDtoOutputTripBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripPassengerListDtoOutputTrip build() => _build();

  _$TripPassengerListDtoOutputTrip _build() {
    final _$result = _$v ??
        _$TripPassengerListDtoOutputTrip._(
          tripId: BuiltValueNullFieldError.checkNotNull(
              tripId, r'TripPassengerListDtoOutputTrip', 'tripId'),
          departureAt: BuiltValueNullFieldError.checkNotNull(
              departureAt, r'TripPassengerListDtoOutputTrip', 'departureAt'),
          routeName: BuiltValueNullFieldError.checkNotNull(
              routeName, r'TripPassengerListDtoOutputTrip', 'routeName'),
          vehiclePlateNumber: vehiclePlateNumber,
          seatCount: BuiltValueNullFieldError.checkNotNull(
              seatCount, r'TripPassengerListDtoOutputTrip', 'seatCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
