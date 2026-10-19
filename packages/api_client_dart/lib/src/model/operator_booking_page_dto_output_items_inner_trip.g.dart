// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_booking_page_dto_output_items_inner_trip.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperatorBookingPageDtoOutputItemsInnerTrip
    extends OperatorBookingPageDtoOutputItemsInnerTrip {
  @override
  final String tripId;
  @override
  final DateTime departureAt;
  @override
  final String routeName;
  @override
  final String? vehiclePlateNumber;

  factory _$OperatorBookingPageDtoOutputItemsInnerTrip(
          [void Function(OperatorBookingPageDtoOutputItemsInnerTripBuilder)?
              updates]) =>
      (OperatorBookingPageDtoOutputItemsInnerTripBuilder()..update(updates))
          ._build();

  _$OperatorBookingPageDtoOutputItemsInnerTrip._(
      {required this.tripId,
      required this.departureAt,
      required this.routeName,
      this.vehiclePlateNumber})
      : super._();
  @override
  OperatorBookingPageDtoOutputItemsInnerTrip rebuild(
          void Function(OperatorBookingPageDtoOutputItemsInnerTripBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorBookingPageDtoOutputItemsInnerTripBuilder toBuilder() =>
      OperatorBookingPageDtoOutputItemsInnerTripBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorBookingPageDtoOutputItemsInnerTrip &&
        tripId == other.tripId &&
        departureAt == other.departureAt &&
        routeName == other.routeName &&
        vehiclePlateNumber == other.vehiclePlateNumber;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, vehiclePlateNumber.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'OperatorBookingPageDtoOutputItemsInnerTrip')
          ..add('tripId', tripId)
          ..add('departureAt', departureAt)
          ..add('routeName', routeName)
          ..add('vehiclePlateNumber', vehiclePlateNumber))
        .toString();
  }
}

class OperatorBookingPageDtoOutputItemsInnerTripBuilder
    implements
        Builder<OperatorBookingPageDtoOutputItemsInnerTrip,
            OperatorBookingPageDtoOutputItemsInnerTripBuilder> {
  _$OperatorBookingPageDtoOutputItemsInnerTrip? _$v;

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

  OperatorBookingPageDtoOutputItemsInnerTripBuilder() {
    OperatorBookingPageDtoOutputItemsInnerTrip._defaults(this);
  }

  OperatorBookingPageDtoOutputItemsInnerTripBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _departureAt = $v.departureAt;
      _routeName = $v.routeName;
      _vehiclePlateNumber = $v.vehiclePlateNumber;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorBookingPageDtoOutputItemsInnerTrip other) {
    _$v = other as _$OperatorBookingPageDtoOutputItemsInnerTrip;
  }

  @override
  void update(
      void Function(OperatorBookingPageDtoOutputItemsInnerTripBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorBookingPageDtoOutputItemsInnerTrip build() => _build();

  _$OperatorBookingPageDtoOutputItemsInnerTrip _build() {
    final _$result = _$v ??
        _$OperatorBookingPageDtoOutputItemsInnerTrip._(
          tripId: BuiltValueNullFieldError.checkNotNull(
              tripId, r'OperatorBookingPageDtoOutputItemsInnerTrip', 'tripId'),
          departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
              r'OperatorBookingPageDtoOutputItemsInnerTrip', 'departureAt'),
          routeName: BuiltValueNullFieldError.checkNotNull(routeName,
              r'OperatorBookingPageDtoOutputItemsInnerTrip', 'routeName'),
          vehiclePlateNumber: vehiclePlateNumber,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
