// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_search_response_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripSearchResponseDtoOutputItemsInner
    extends TripSearchResponseDtoOutputItemsInner {
  @override
  final String tripId;
  @override
  final TripSearchResponseDtoOutputItemsInnerOperator operator_;
  @override
  final String routeName;
  @override
  final TripSearchResponseDtoOutputItemsInnerVehicleType vehicleType;
  @override
  final DateTime departureAt;
  @override
  final DateTime arrivalAt;
  @override
  final TripSearchResponseDtoOutputItemsInnerPickup pickup;
  @override
  final TripSearchResponseDtoOutputItemsInnerPickup dropoff;
  @override
  final int durationMinutes;
  @override
  final int availableSeats;
  @override
  final int minPrice;
  @override
  final String? vehicleCoverImageUrl;
  @override
  final BuiltList<TripSearchResponseDtoOutputItemsInnerAmenitiesInner>
      amenities;
  @override
  final DateTime onlineSaleClosesAt;

  factory _$TripSearchResponseDtoOutputItemsInner(
          [void Function(TripSearchResponseDtoOutputItemsInnerBuilder)?
              updates]) =>
      (TripSearchResponseDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$TripSearchResponseDtoOutputItemsInner._(
      {required this.tripId,
      required this.operator_,
      required this.routeName,
      required this.vehicleType,
      required this.departureAt,
      required this.arrivalAt,
      required this.pickup,
      required this.dropoff,
      required this.durationMinutes,
      required this.availableSeats,
      required this.minPrice,
      this.vehicleCoverImageUrl,
      required this.amenities,
      required this.onlineSaleClosesAt})
      : super._();
  @override
  TripSearchResponseDtoOutputItemsInner rebuild(
          void Function(TripSearchResponseDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripSearchResponseDtoOutputItemsInnerBuilder toBuilder() =>
      TripSearchResponseDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripSearchResponseDtoOutputItemsInner &&
        tripId == other.tripId &&
        operator_ == other.operator_ &&
        routeName == other.routeName &&
        vehicleType == other.vehicleType &&
        departureAt == other.departureAt &&
        arrivalAt == other.arrivalAt &&
        pickup == other.pickup &&
        dropoff == other.dropoff &&
        durationMinutes == other.durationMinutes &&
        availableSeats == other.availableSeats &&
        minPrice == other.minPrice &&
        vehicleCoverImageUrl == other.vehicleCoverImageUrl &&
        amenities == other.amenities &&
        onlineSaleClosesAt == other.onlineSaleClosesAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, operator_.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, vehicleType.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, arrivalAt.hashCode);
    _$hash = $jc(_$hash, pickup.hashCode);
    _$hash = $jc(_$hash, dropoff.hashCode);
    _$hash = $jc(_$hash, durationMinutes.hashCode);
    _$hash = $jc(_$hash, availableSeats.hashCode);
    _$hash = $jc(_$hash, minPrice.hashCode);
    _$hash = $jc(_$hash, vehicleCoverImageUrl.hashCode);
    _$hash = $jc(_$hash, amenities.hashCode);
    _$hash = $jc(_$hash, onlineSaleClosesAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TripSearchResponseDtoOutputItemsInner')
          ..add('tripId', tripId)
          ..add('operator_', operator_)
          ..add('routeName', routeName)
          ..add('vehicleType', vehicleType)
          ..add('departureAt', departureAt)
          ..add('arrivalAt', arrivalAt)
          ..add('pickup', pickup)
          ..add('dropoff', dropoff)
          ..add('durationMinutes', durationMinutes)
          ..add('availableSeats', availableSeats)
          ..add('minPrice', minPrice)
          ..add('vehicleCoverImageUrl', vehicleCoverImageUrl)
          ..add('amenities', amenities)
          ..add('onlineSaleClosesAt', onlineSaleClosesAt))
        .toString();
  }
}

class TripSearchResponseDtoOutputItemsInnerBuilder
    implements
        Builder<TripSearchResponseDtoOutputItemsInner,
            TripSearchResponseDtoOutputItemsInnerBuilder> {
  _$TripSearchResponseDtoOutputItemsInner? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  TripSearchResponseDtoOutputItemsInnerOperatorBuilder? _operator_;
  TripSearchResponseDtoOutputItemsInnerOperatorBuilder get operator_ =>
      _$this._operator_ ??=
          TripSearchResponseDtoOutputItemsInnerOperatorBuilder();
  set operator_(
          TripSearchResponseDtoOutputItemsInnerOperatorBuilder? operator_) =>
      _$this._operator_ = operator_;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder? _vehicleType;
  TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder get vehicleType =>
      _$this._vehicleType ??=
          TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder();
  set vehicleType(
          TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder?
              vehicleType) =>
      _$this._vehicleType = vehicleType;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  DateTime? _arrivalAt;
  DateTime? get arrivalAt => _$this._arrivalAt;
  set arrivalAt(DateTime? arrivalAt) => _$this._arrivalAt = arrivalAt;

  TripSearchResponseDtoOutputItemsInnerPickupBuilder? _pickup;
  TripSearchResponseDtoOutputItemsInnerPickupBuilder get pickup =>
      _$this._pickup ??= TripSearchResponseDtoOutputItemsInnerPickupBuilder();
  set pickup(TripSearchResponseDtoOutputItemsInnerPickupBuilder? pickup) =>
      _$this._pickup = pickup;

  TripSearchResponseDtoOutputItemsInnerPickupBuilder? _dropoff;
  TripSearchResponseDtoOutputItemsInnerPickupBuilder get dropoff =>
      _$this._dropoff ??= TripSearchResponseDtoOutputItemsInnerPickupBuilder();
  set dropoff(TripSearchResponseDtoOutputItemsInnerPickupBuilder? dropoff) =>
      _$this._dropoff = dropoff;

  int? _durationMinutes;
  int? get durationMinutes => _$this._durationMinutes;
  set durationMinutes(int? durationMinutes) =>
      _$this._durationMinutes = durationMinutes;

  int? _availableSeats;
  int? get availableSeats => _$this._availableSeats;
  set availableSeats(int? availableSeats) =>
      _$this._availableSeats = availableSeats;

  int? _minPrice;
  int? get minPrice => _$this._minPrice;
  set minPrice(int? minPrice) => _$this._minPrice = minPrice;

  String? _vehicleCoverImageUrl;
  String? get vehicleCoverImageUrl => _$this._vehicleCoverImageUrl;
  set vehicleCoverImageUrl(String? vehicleCoverImageUrl) =>
      _$this._vehicleCoverImageUrl = vehicleCoverImageUrl;

  ListBuilder<TripSearchResponseDtoOutputItemsInnerAmenitiesInner>? _amenities;
  ListBuilder<TripSearchResponseDtoOutputItemsInnerAmenitiesInner>
      get amenities => _$this._amenities ??=
          ListBuilder<TripSearchResponseDtoOutputItemsInnerAmenitiesInner>();
  set amenities(
          ListBuilder<TripSearchResponseDtoOutputItemsInnerAmenitiesInner>?
              amenities) =>
      _$this._amenities = amenities;

  DateTime? _onlineSaleClosesAt;
  DateTime? get onlineSaleClosesAt => _$this._onlineSaleClosesAt;
  set onlineSaleClosesAt(DateTime? onlineSaleClosesAt) =>
      _$this._onlineSaleClosesAt = onlineSaleClosesAt;

  TripSearchResponseDtoOutputItemsInnerBuilder() {
    TripSearchResponseDtoOutputItemsInner._defaults(this);
  }

  TripSearchResponseDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _operator_ = $v.operator_.toBuilder();
      _routeName = $v.routeName;
      _vehicleType = $v.vehicleType.toBuilder();
      _departureAt = $v.departureAt;
      _arrivalAt = $v.arrivalAt;
      _pickup = $v.pickup.toBuilder();
      _dropoff = $v.dropoff.toBuilder();
      _durationMinutes = $v.durationMinutes;
      _availableSeats = $v.availableSeats;
      _minPrice = $v.minPrice;
      _vehicleCoverImageUrl = $v.vehicleCoverImageUrl;
      _amenities = $v.amenities.toBuilder();
      _onlineSaleClosesAt = $v.onlineSaleClosesAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripSearchResponseDtoOutputItemsInner other) {
    _$v = other as _$TripSearchResponseDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(TripSearchResponseDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripSearchResponseDtoOutputItemsInner build() => _build();

  _$TripSearchResponseDtoOutputItemsInner _build() {
    _$TripSearchResponseDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$TripSearchResponseDtoOutputItemsInner._(
            tripId: BuiltValueNullFieldError.checkNotNull(
                tripId, r'TripSearchResponseDtoOutputItemsInner', 'tripId'),
            operator_: operator_.build(),
            routeName: BuiltValueNullFieldError.checkNotNull(routeName,
                r'TripSearchResponseDtoOutputItemsInner', 'routeName'),
            vehicleType: vehicleType.build(),
            departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
                r'TripSearchResponseDtoOutputItemsInner', 'departureAt'),
            arrivalAt: BuiltValueNullFieldError.checkNotNull(arrivalAt,
                r'TripSearchResponseDtoOutputItemsInner', 'arrivalAt'),
            pickup: pickup.build(),
            dropoff: dropoff.build(),
            durationMinutes: BuiltValueNullFieldError.checkNotNull(
                durationMinutes,
                r'TripSearchResponseDtoOutputItemsInner',
                'durationMinutes'),
            availableSeats: BuiltValueNullFieldError.checkNotNull(
                availableSeats,
                r'TripSearchResponseDtoOutputItemsInner',
                'availableSeats'),
            minPrice: BuiltValueNullFieldError.checkNotNull(
                minPrice, r'TripSearchResponseDtoOutputItemsInner', 'minPrice'),
            vehicleCoverImageUrl: vehicleCoverImageUrl,
            amenities: amenities.build(),
            onlineSaleClosesAt: BuiltValueNullFieldError.checkNotNull(
                onlineSaleClosesAt,
                r'TripSearchResponseDtoOutputItemsInner',
                'onlineSaleClosesAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'operator_';
        operator_.build();

        _$failedField = 'vehicleType';
        vehicleType.build();

        _$failedField = 'pickup';
        pickup.build();
        _$failedField = 'dropoff';
        dropoff.build();

        _$failedField = 'amenities';
        amenities.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripSearchResponseDtoOutputItemsInner',
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
