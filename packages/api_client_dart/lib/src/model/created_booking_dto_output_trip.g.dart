// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_booking_dto_output_trip.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreatedBookingDtoOutputTrip extends CreatedBookingDtoOutputTrip {
  @override
  final String routeName;
  @override
  final String operatorName;
  @override
  final String? operatorHotline;
  @override
  final String vehicleTypeName;
  @override
  final DateTime departureAt;
  @override
  final DateTime arrivalAt;

  factory _$CreatedBookingDtoOutputTrip(
          [void Function(CreatedBookingDtoOutputTripBuilder)? updates]) =>
      (CreatedBookingDtoOutputTripBuilder()..update(updates))._build();

  _$CreatedBookingDtoOutputTrip._(
      {required this.routeName,
      required this.operatorName,
      this.operatorHotline,
      required this.vehicleTypeName,
      required this.departureAt,
      required this.arrivalAt})
      : super._();
  @override
  CreatedBookingDtoOutputTrip rebuild(
          void Function(CreatedBookingDtoOutputTripBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreatedBookingDtoOutputTripBuilder toBuilder() =>
      CreatedBookingDtoOutputTripBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreatedBookingDtoOutputTrip &&
        routeName == other.routeName &&
        operatorName == other.operatorName &&
        operatorHotline == other.operatorHotline &&
        vehicleTypeName == other.vehicleTypeName &&
        departureAt == other.departureAt &&
        arrivalAt == other.arrivalAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, operatorHotline.hashCode);
    _$hash = $jc(_$hash, vehicleTypeName.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, arrivalAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreatedBookingDtoOutputTrip')
          ..add('routeName', routeName)
          ..add('operatorName', operatorName)
          ..add('operatorHotline', operatorHotline)
          ..add('vehicleTypeName', vehicleTypeName)
          ..add('departureAt', departureAt)
          ..add('arrivalAt', arrivalAt))
        .toString();
  }
}

class CreatedBookingDtoOutputTripBuilder
    implements
        Builder<CreatedBookingDtoOutputTrip,
            CreatedBookingDtoOutputTripBuilder> {
  _$CreatedBookingDtoOutputTrip? _$v;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  String? _operatorHotline;
  String? get operatorHotline => _$this._operatorHotline;
  set operatorHotline(String? operatorHotline) =>
      _$this._operatorHotline = operatorHotline;

  String? _vehicleTypeName;
  String? get vehicleTypeName => _$this._vehicleTypeName;
  set vehicleTypeName(String? vehicleTypeName) =>
      _$this._vehicleTypeName = vehicleTypeName;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  DateTime? _arrivalAt;
  DateTime? get arrivalAt => _$this._arrivalAt;
  set arrivalAt(DateTime? arrivalAt) => _$this._arrivalAt = arrivalAt;

  CreatedBookingDtoOutputTripBuilder() {
    CreatedBookingDtoOutputTrip._defaults(this);
  }

  CreatedBookingDtoOutputTripBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _routeName = $v.routeName;
      _operatorName = $v.operatorName;
      _operatorHotline = $v.operatorHotline;
      _vehicleTypeName = $v.vehicleTypeName;
      _departureAt = $v.departureAt;
      _arrivalAt = $v.arrivalAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreatedBookingDtoOutputTrip other) {
    _$v = other as _$CreatedBookingDtoOutputTrip;
  }

  @override
  void update(void Function(CreatedBookingDtoOutputTripBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreatedBookingDtoOutputTrip build() => _build();

  _$CreatedBookingDtoOutputTrip _build() {
    final _$result = _$v ??
        _$CreatedBookingDtoOutputTrip._(
          routeName: BuiltValueNullFieldError.checkNotNull(
              routeName, r'CreatedBookingDtoOutputTrip', 'routeName'),
          operatorName: BuiltValueNullFieldError.checkNotNull(
              operatorName, r'CreatedBookingDtoOutputTrip', 'operatorName'),
          operatorHotline: operatorHotline,
          vehicleTypeName: BuiltValueNullFieldError.checkNotNull(
              vehicleTypeName,
              r'CreatedBookingDtoOutputTrip',
              'vehicleTypeName'),
          departureAt: BuiltValueNullFieldError.checkNotNull(
              departureAt, r'CreatedBookingDtoOutputTrip', 'departureAt'),
          arrivalAt: BuiltValueNullFieldError.checkNotNull(
              arrivalAt, r'CreatedBookingDtoOutputTrip', 'arrivalAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
