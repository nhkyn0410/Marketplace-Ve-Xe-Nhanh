// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_trip_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicTripDtoOutput extends PublicTripDtoOutput {
  @override
  final String tripId;
  @override
  final PublicTripDtoOutputOperator operator_;
  @override
  final String routeName;
  @override
  final DateTime departureAt;
  @override
  final DateTime arrivalAt;
  @override
  final DateTime onlineSaleClosesAt;
  @override
  final String? note;
  @override
  final TripSearchResponseDtoOutputItemsInnerVehicleType vehicleType;
  @override
  final BuiltList<TripSearchResponseDtoOutputItemsInnerAmenitiesInner>
      amenities;
  @override
  final BuiltList<PublicTripDtoOutputVehicleImagesInner> vehicleImages;
  @override
  final BuiltList<PublicTripDtoOutputStopsInner> stops;
  @override
  final BuiltList<PublicTripDtoOutputSeatsInner> seats;
  @override
  final PublicTripDtoOutputCancellationPolicy cancellationPolicy;

  factory _$PublicTripDtoOutput(
          [void Function(PublicTripDtoOutputBuilder)? updates]) =>
      (PublicTripDtoOutputBuilder()..update(updates))._build();

  _$PublicTripDtoOutput._(
      {required this.tripId,
      required this.operator_,
      required this.routeName,
      required this.departureAt,
      required this.arrivalAt,
      required this.onlineSaleClosesAt,
      this.note,
      required this.vehicleType,
      required this.amenities,
      required this.vehicleImages,
      required this.stops,
      required this.seats,
      required this.cancellationPolicy})
      : super._();
  @override
  PublicTripDtoOutput rebuild(
          void Function(PublicTripDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicTripDtoOutputBuilder toBuilder() =>
      PublicTripDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicTripDtoOutput &&
        tripId == other.tripId &&
        operator_ == other.operator_ &&
        routeName == other.routeName &&
        departureAt == other.departureAt &&
        arrivalAt == other.arrivalAt &&
        onlineSaleClosesAt == other.onlineSaleClosesAt &&
        note == other.note &&
        vehicleType == other.vehicleType &&
        amenities == other.amenities &&
        vehicleImages == other.vehicleImages &&
        stops == other.stops &&
        seats == other.seats &&
        cancellationPolicy == other.cancellationPolicy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, operator_.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, arrivalAt.hashCode);
    _$hash = $jc(_$hash, onlineSaleClosesAt.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, vehicleType.hashCode);
    _$hash = $jc(_$hash, amenities.hashCode);
    _$hash = $jc(_$hash, vehicleImages.hashCode);
    _$hash = $jc(_$hash, stops.hashCode);
    _$hash = $jc(_$hash, seats.hashCode);
    _$hash = $jc(_$hash, cancellationPolicy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicTripDtoOutput')
          ..add('tripId', tripId)
          ..add('operator_', operator_)
          ..add('routeName', routeName)
          ..add('departureAt', departureAt)
          ..add('arrivalAt', arrivalAt)
          ..add('onlineSaleClosesAt', onlineSaleClosesAt)
          ..add('note', note)
          ..add('vehicleType', vehicleType)
          ..add('amenities', amenities)
          ..add('vehicleImages', vehicleImages)
          ..add('stops', stops)
          ..add('seats', seats)
          ..add('cancellationPolicy', cancellationPolicy))
        .toString();
  }
}

class PublicTripDtoOutputBuilder
    implements Builder<PublicTripDtoOutput, PublicTripDtoOutputBuilder> {
  _$PublicTripDtoOutput? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  PublicTripDtoOutputOperatorBuilder? _operator_;
  PublicTripDtoOutputOperatorBuilder get operator_ =>
      _$this._operator_ ??= PublicTripDtoOutputOperatorBuilder();
  set operator_(PublicTripDtoOutputOperatorBuilder? operator_) =>
      _$this._operator_ = operator_;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  DateTime? _arrivalAt;
  DateTime? get arrivalAt => _$this._arrivalAt;
  set arrivalAt(DateTime? arrivalAt) => _$this._arrivalAt = arrivalAt;

  DateTime? _onlineSaleClosesAt;
  DateTime? get onlineSaleClosesAt => _$this._onlineSaleClosesAt;
  set onlineSaleClosesAt(DateTime? onlineSaleClosesAt) =>
      _$this._onlineSaleClosesAt = onlineSaleClosesAt;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder? _vehicleType;
  TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder get vehicleType =>
      _$this._vehicleType ??=
          TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder();
  set vehicleType(
          TripSearchResponseDtoOutputItemsInnerVehicleTypeBuilder?
              vehicleType) =>
      _$this._vehicleType = vehicleType;

  ListBuilder<TripSearchResponseDtoOutputItemsInnerAmenitiesInner>? _amenities;
  ListBuilder<TripSearchResponseDtoOutputItemsInnerAmenitiesInner>
      get amenities => _$this._amenities ??=
          ListBuilder<TripSearchResponseDtoOutputItemsInnerAmenitiesInner>();
  set amenities(
          ListBuilder<TripSearchResponseDtoOutputItemsInnerAmenitiesInner>?
              amenities) =>
      _$this._amenities = amenities;

  ListBuilder<PublicTripDtoOutputVehicleImagesInner>? _vehicleImages;
  ListBuilder<PublicTripDtoOutputVehicleImagesInner> get vehicleImages =>
      _$this._vehicleImages ??=
          ListBuilder<PublicTripDtoOutputVehicleImagesInner>();
  set vehicleImages(
          ListBuilder<PublicTripDtoOutputVehicleImagesInner>? vehicleImages) =>
      _$this._vehicleImages = vehicleImages;

  ListBuilder<PublicTripDtoOutputStopsInner>? _stops;
  ListBuilder<PublicTripDtoOutputStopsInner> get stops =>
      _$this._stops ??= ListBuilder<PublicTripDtoOutputStopsInner>();
  set stops(ListBuilder<PublicTripDtoOutputStopsInner>? stops) =>
      _$this._stops = stops;

  ListBuilder<PublicTripDtoOutputSeatsInner>? _seats;
  ListBuilder<PublicTripDtoOutputSeatsInner> get seats =>
      _$this._seats ??= ListBuilder<PublicTripDtoOutputSeatsInner>();
  set seats(ListBuilder<PublicTripDtoOutputSeatsInner>? seats) =>
      _$this._seats = seats;

  PublicTripDtoOutputCancellationPolicyBuilder? _cancellationPolicy;
  PublicTripDtoOutputCancellationPolicyBuilder get cancellationPolicy =>
      _$this._cancellationPolicy ??=
          PublicTripDtoOutputCancellationPolicyBuilder();
  set cancellationPolicy(
          PublicTripDtoOutputCancellationPolicyBuilder? cancellationPolicy) =>
      _$this._cancellationPolicy = cancellationPolicy;

  PublicTripDtoOutputBuilder() {
    PublicTripDtoOutput._defaults(this);
  }

  PublicTripDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _operator_ = $v.operator_.toBuilder();
      _routeName = $v.routeName;
      _departureAt = $v.departureAt;
      _arrivalAt = $v.arrivalAt;
      _onlineSaleClosesAt = $v.onlineSaleClosesAt;
      _note = $v.note;
      _vehicleType = $v.vehicleType.toBuilder();
      _amenities = $v.amenities.toBuilder();
      _vehicleImages = $v.vehicleImages.toBuilder();
      _stops = $v.stops.toBuilder();
      _seats = $v.seats.toBuilder();
      _cancellationPolicy = $v.cancellationPolicy.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicTripDtoOutput other) {
    _$v = other as _$PublicTripDtoOutput;
  }

  @override
  void update(void Function(PublicTripDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicTripDtoOutput build() => _build();

  _$PublicTripDtoOutput _build() {
    _$PublicTripDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PublicTripDtoOutput._(
            tripId: BuiltValueNullFieldError.checkNotNull(
                tripId, r'PublicTripDtoOutput', 'tripId'),
            operator_: operator_.build(),
            routeName: BuiltValueNullFieldError.checkNotNull(
                routeName, r'PublicTripDtoOutput', 'routeName'),
            departureAt: BuiltValueNullFieldError.checkNotNull(
                departureAt, r'PublicTripDtoOutput', 'departureAt'),
            arrivalAt: BuiltValueNullFieldError.checkNotNull(
                arrivalAt, r'PublicTripDtoOutput', 'arrivalAt'),
            onlineSaleClosesAt: BuiltValueNullFieldError.checkNotNull(
                onlineSaleClosesAt,
                r'PublicTripDtoOutput',
                'onlineSaleClosesAt'),
            note: note,
            vehicleType: vehicleType.build(),
            amenities: amenities.build(),
            vehicleImages: vehicleImages.build(),
            stops: stops.build(),
            seats: seats.build(),
            cancellationPolicy: cancellationPolicy.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'operator_';
        operator_.build();

        _$failedField = 'vehicleType';
        vehicleType.build();
        _$failedField = 'amenities';
        amenities.build();
        _$failedField = 'vehicleImages';
        vehicleImages.build();
        _$failedField = 'stops';
        stops.build();
        _$failedField = 'seats';
        seats.build();
        _$failedField = 'cancellationPolicy';
        cancellationPolicy.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PublicTripDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
