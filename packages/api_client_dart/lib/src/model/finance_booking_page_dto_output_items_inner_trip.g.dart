// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_booking_page_dto_output_items_inner_trip.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FinanceBookingPageDtoOutputItemsInnerTrip
    extends FinanceBookingPageDtoOutputItemsInnerTrip {
  @override
  final String tripId;
  @override
  final DateTime departureAt;
  @override
  final DateTime arrivalAt;
  @override
  final String routeName;

  factory _$FinanceBookingPageDtoOutputItemsInnerTrip(
          [void Function(FinanceBookingPageDtoOutputItemsInnerTripBuilder)?
              updates]) =>
      (FinanceBookingPageDtoOutputItemsInnerTripBuilder()..update(updates))
          ._build();

  _$FinanceBookingPageDtoOutputItemsInnerTrip._(
      {required this.tripId,
      required this.departureAt,
      required this.arrivalAt,
      required this.routeName})
      : super._();
  @override
  FinanceBookingPageDtoOutputItemsInnerTrip rebuild(
          void Function(FinanceBookingPageDtoOutputItemsInnerTripBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinanceBookingPageDtoOutputItemsInnerTripBuilder toBuilder() =>
      FinanceBookingPageDtoOutputItemsInnerTripBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinanceBookingPageDtoOutputItemsInnerTrip &&
        tripId == other.tripId &&
        departureAt == other.departureAt &&
        arrivalAt == other.arrivalAt &&
        routeName == other.routeName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, arrivalAt.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'FinanceBookingPageDtoOutputItemsInnerTrip')
          ..add('tripId', tripId)
          ..add('departureAt', departureAt)
          ..add('arrivalAt', arrivalAt)
          ..add('routeName', routeName))
        .toString();
  }
}

class FinanceBookingPageDtoOutputItemsInnerTripBuilder
    implements
        Builder<FinanceBookingPageDtoOutputItemsInnerTrip,
            FinanceBookingPageDtoOutputItemsInnerTripBuilder> {
  _$FinanceBookingPageDtoOutputItemsInnerTrip? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  DateTime? _arrivalAt;
  DateTime? get arrivalAt => _$this._arrivalAt;
  set arrivalAt(DateTime? arrivalAt) => _$this._arrivalAt = arrivalAt;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  FinanceBookingPageDtoOutputItemsInnerTripBuilder() {
    FinanceBookingPageDtoOutputItemsInnerTrip._defaults(this);
  }

  FinanceBookingPageDtoOutputItemsInnerTripBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _departureAt = $v.departureAt;
      _arrivalAt = $v.arrivalAt;
      _routeName = $v.routeName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FinanceBookingPageDtoOutputItemsInnerTrip other) {
    _$v = other as _$FinanceBookingPageDtoOutputItemsInnerTrip;
  }

  @override
  void update(
      void Function(FinanceBookingPageDtoOutputItemsInnerTripBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  FinanceBookingPageDtoOutputItemsInnerTrip build() => _build();

  _$FinanceBookingPageDtoOutputItemsInnerTrip _build() {
    final _$result = _$v ??
        _$FinanceBookingPageDtoOutputItemsInnerTrip._(
          tripId: BuiltValueNullFieldError.checkNotNull(
              tripId, r'FinanceBookingPageDtoOutputItemsInnerTrip', 'tripId'),
          departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
              r'FinanceBookingPageDtoOutputItemsInnerTrip', 'departureAt'),
          arrivalAt: BuiltValueNullFieldError.checkNotNull(arrivalAt,
              r'FinanceBookingPageDtoOutputItemsInnerTrip', 'arrivalAt'),
          routeName: BuiltValueNullFieldError.checkNotNull(routeName,
              r'FinanceBookingPageDtoOutputItemsInnerTrip', 'routeName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
