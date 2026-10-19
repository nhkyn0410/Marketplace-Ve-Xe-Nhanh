// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_detail_dto_output_trip.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeDetailDtoOutputTrip extends DisputeDetailDtoOutputTrip {
  @override
  final String tripId;
  @override
  final String routeName;
  @override
  final DateTime departureAt;
  @override
  final DateTime? departedAt;
  @override
  final String? vehiclePlateNumber;

  factory _$DisputeDetailDtoOutputTrip(
          [void Function(DisputeDetailDtoOutputTripBuilder)? updates]) =>
      (DisputeDetailDtoOutputTripBuilder()..update(updates))._build();

  _$DisputeDetailDtoOutputTrip._(
      {required this.tripId,
      required this.routeName,
      required this.departureAt,
      this.departedAt,
      this.vehiclePlateNumber})
      : super._();
  @override
  DisputeDetailDtoOutputTrip rebuild(
          void Function(DisputeDetailDtoOutputTripBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeDetailDtoOutputTripBuilder toBuilder() =>
      DisputeDetailDtoOutputTripBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeDetailDtoOutputTrip &&
        tripId == other.tripId &&
        routeName == other.routeName &&
        departureAt == other.departureAt &&
        departedAt == other.departedAt &&
        vehiclePlateNumber == other.vehiclePlateNumber;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, departedAt.hashCode);
    _$hash = $jc(_$hash, vehiclePlateNumber.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeDetailDtoOutputTrip')
          ..add('tripId', tripId)
          ..add('routeName', routeName)
          ..add('departureAt', departureAt)
          ..add('departedAt', departedAt)
          ..add('vehiclePlateNumber', vehiclePlateNumber))
        .toString();
  }
}

class DisputeDetailDtoOutputTripBuilder
    implements
        Builder<DisputeDetailDtoOutputTrip, DisputeDetailDtoOutputTripBuilder> {
  _$DisputeDetailDtoOutputTrip? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  DateTime? _departedAt;
  DateTime? get departedAt => _$this._departedAt;
  set departedAt(DateTime? departedAt) => _$this._departedAt = departedAt;

  String? _vehiclePlateNumber;
  String? get vehiclePlateNumber => _$this._vehiclePlateNumber;
  set vehiclePlateNumber(String? vehiclePlateNumber) =>
      _$this._vehiclePlateNumber = vehiclePlateNumber;

  DisputeDetailDtoOutputTripBuilder() {
    DisputeDetailDtoOutputTrip._defaults(this);
  }

  DisputeDetailDtoOutputTripBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _routeName = $v.routeName;
      _departureAt = $v.departureAt;
      _departedAt = $v.departedAt;
      _vehiclePlateNumber = $v.vehiclePlateNumber;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeDetailDtoOutputTrip other) {
    _$v = other as _$DisputeDetailDtoOutputTrip;
  }

  @override
  void update(void Function(DisputeDetailDtoOutputTripBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeDetailDtoOutputTrip build() => _build();

  _$DisputeDetailDtoOutputTrip _build() {
    final _$result = _$v ??
        _$DisputeDetailDtoOutputTrip._(
          tripId: BuiltValueNullFieldError.checkNotNull(
              tripId, r'DisputeDetailDtoOutputTrip', 'tripId'),
          routeName: BuiltValueNullFieldError.checkNotNull(
              routeName, r'DisputeDetailDtoOutputTrip', 'routeName'),
          departureAt: BuiltValueNullFieldError.checkNotNull(
              departureAt, r'DisputeDetailDtoOutputTrip', 'departureAt'),
          departedAt: departedAt,
          vehiclePlateNumber: vehiclePlateNumber,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
