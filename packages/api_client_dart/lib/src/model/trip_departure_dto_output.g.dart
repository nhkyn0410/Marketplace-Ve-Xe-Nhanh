// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_departure_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripDepartureDtoOutput extends TripDepartureDtoOutput {
  @override
  final String tripId;
  @override
  final DateTime departedAt;

  factory _$TripDepartureDtoOutput(
          [void Function(TripDepartureDtoOutputBuilder)? updates]) =>
      (TripDepartureDtoOutputBuilder()..update(updates))._build();

  _$TripDepartureDtoOutput._({required this.tripId, required this.departedAt})
      : super._();
  @override
  TripDepartureDtoOutput rebuild(
          void Function(TripDepartureDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripDepartureDtoOutputBuilder toBuilder() =>
      TripDepartureDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripDepartureDtoOutput &&
        tripId == other.tripId &&
        departedAt == other.departedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, departedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripDepartureDtoOutput')
          ..add('tripId', tripId)
          ..add('departedAt', departedAt))
        .toString();
  }
}

class TripDepartureDtoOutputBuilder
    implements Builder<TripDepartureDtoOutput, TripDepartureDtoOutputBuilder> {
  _$TripDepartureDtoOutput? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  DateTime? _departedAt;
  DateTime? get departedAt => _$this._departedAt;
  set departedAt(DateTime? departedAt) => _$this._departedAt = departedAt;

  TripDepartureDtoOutputBuilder() {
    TripDepartureDtoOutput._defaults(this);
  }

  TripDepartureDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _departedAt = $v.departedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripDepartureDtoOutput other) {
    _$v = other as _$TripDepartureDtoOutput;
  }

  @override
  void update(void Function(TripDepartureDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripDepartureDtoOutput build() => _build();

  _$TripDepartureDtoOutput _build() {
    final _$result = _$v ??
        _$TripDepartureDtoOutput._(
          tripId: BuiltValueNullFieldError.checkNotNull(
              tripId, r'TripDepartureDtoOutput', 'tripId'),
          departedAt: BuiltValueNullFieldError.checkNotNull(
              departedAt, r'TripDepartureDtoOutput', 'departedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
