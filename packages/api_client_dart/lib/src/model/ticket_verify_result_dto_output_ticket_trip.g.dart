// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_verify_result_dto_output_ticket_trip.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TicketVerifyResultDtoOutputTicketTrip
    extends TicketVerifyResultDtoOutputTicketTrip {
  @override
  final String routeName;
  @override
  final DateTime departureAt;

  factory _$TicketVerifyResultDtoOutputTicketTrip(
          [void Function(TicketVerifyResultDtoOutputTicketTripBuilder)?
              updates]) =>
      (TicketVerifyResultDtoOutputTicketTripBuilder()..update(updates))
          ._build();

  _$TicketVerifyResultDtoOutputTicketTrip._(
      {required this.routeName, required this.departureAt})
      : super._();
  @override
  TicketVerifyResultDtoOutputTicketTrip rebuild(
          void Function(TicketVerifyResultDtoOutputTicketTripBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketVerifyResultDtoOutputTicketTripBuilder toBuilder() =>
      TicketVerifyResultDtoOutputTicketTripBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketVerifyResultDtoOutputTicketTrip &&
        routeName == other.routeName &&
        departureAt == other.departureAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TicketVerifyResultDtoOutputTicketTrip')
          ..add('routeName', routeName)
          ..add('departureAt', departureAt))
        .toString();
  }
}

class TicketVerifyResultDtoOutputTicketTripBuilder
    implements
        Builder<TicketVerifyResultDtoOutputTicketTrip,
            TicketVerifyResultDtoOutputTicketTripBuilder> {
  _$TicketVerifyResultDtoOutputTicketTrip? _$v;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  TicketVerifyResultDtoOutputTicketTripBuilder() {
    TicketVerifyResultDtoOutputTicketTrip._defaults(this);
  }

  TicketVerifyResultDtoOutputTicketTripBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _routeName = $v.routeName;
      _departureAt = $v.departureAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketVerifyResultDtoOutputTicketTrip other) {
    _$v = other as _$TicketVerifyResultDtoOutputTicketTrip;
  }

  @override
  void update(
      void Function(TicketVerifyResultDtoOutputTicketTripBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketVerifyResultDtoOutputTicketTrip build() => _build();

  _$TicketVerifyResultDtoOutputTicketTrip _build() {
    final _$result = _$v ??
        _$TicketVerifyResultDtoOutputTicketTrip._(
          routeName: BuiltValueNullFieldError.checkNotNull(
              routeName, r'TicketVerifyResultDtoOutputTicketTrip', 'routeName'),
          departureAt: BuiltValueNullFieldError.checkNotNull(departureAt,
              r'TicketVerifyResultDtoOutputTicketTrip', 'departureAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
