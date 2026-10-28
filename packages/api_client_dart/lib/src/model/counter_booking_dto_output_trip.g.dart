// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_booking_dto_output_trip.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterBookingDtoOutputTrip extends CounterBookingDtoOutputTrip {
  @override
  final String routeName;
  @override
  final DateTime departureAt;
  @override
  final DateTime arrivalAt;

  factory _$CounterBookingDtoOutputTrip(
          [void Function(CounterBookingDtoOutputTripBuilder)? updates]) =>
      (CounterBookingDtoOutputTripBuilder()..update(updates))._build();

  _$CounterBookingDtoOutputTrip._(
      {required this.routeName,
      required this.departureAt,
      required this.arrivalAt})
      : super._();
  @override
  CounterBookingDtoOutputTrip rebuild(
          void Function(CounterBookingDtoOutputTripBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterBookingDtoOutputTripBuilder toBuilder() =>
      CounterBookingDtoOutputTripBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterBookingDtoOutputTrip &&
        routeName == other.routeName &&
        departureAt == other.departureAt &&
        arrivalAt == other.arrivalAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, arrivalAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CounterBookingDtoOutputTrip')
          ..add('routeName', routeName)
          ..add('departureAt', departureAt)
          ..add('arrivalAt', arrivalAt))
        .toString();
  }
}

class CounterBookingDtoOutputTripBuilder
    implements
        Builder<CounterBookingDtoOutputTrip,
            CounterBookingDtoOutputTripBuilder> {
  _$CounterBookingDtoOutputTrip? _$v;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  DateTime? _arrivalAt;
  DateTime? get arrivalAt => _$this._arrivalAt;
  set arrivalAt(DateTime? arrivalAt) => _$this._arrivalAt = arrivalAt;

  CounterBookingDtoOutputTripBuilder() {
    CounterBookingDtoOutputTrip._defaults(this);
  }

  CounterBookingDtoOutputTripBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _routeName = $v.routeName;
      _departureAt = $v.departureAt;
      _arrivalAt = $v.arrivalAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterBookingDtoOutputTrip other) {
    _$v = other as _$CounterBookingDtoOutputTrip;
  }

  @override
  void update(void Function(CounterBookingDtoOutputTripBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterBookingDtoOutputTrip build() => _build();

  _$CounterBookingDtoOutputTrip _build() {
    final _$result = _$v ??
        _$CounterBookingDtoOutputTrip._(
          routeName: BuiltValueNullFieldError.checkNotNull(
              routeName, r'CounterBookingDtoOutputTrip', 'routeName'),
          departureAt: BuiltValueNullFieldError.checkNotNull(
              departureAt, r'CounterBookingDtoOutputTrip', 'departureAt'),
          arrivalAt: BuiltValueNullFieldError.checkNotNull(
              arrivalAt, r'CounterBookingDtoOutputTrip', 'arrivalAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
