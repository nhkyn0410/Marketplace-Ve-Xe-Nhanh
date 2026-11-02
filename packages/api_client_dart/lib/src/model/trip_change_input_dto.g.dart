// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_change_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripChangeInputDto extends TripChangeInputDto {
  @override
  final DateTime departureAt;
  @override
  final BuiltList<DateTime>? stopTimes;
  @override
  final String vehicleId;
  @override
  final BuiltList<TripChangeInputDtoStopsInner> stops;
  @override
  final String reason;

  factory _$TripChangeInputDto(
          [void Function(TripChangeInputDtoBuilder)? updates]) =>
      (TripChangeInputDtoBuilder()..update(updates))._build();

  _$TripChangeInputDto._(
      {required this.departureAt,
      this.stopTimes,
      required this.vehicleId,
      required this.stops,
      required this.reason})
      : super._();
  @override
  TripChangeInputDto rebuild(
          void Function(TripChangeInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripChangeInputDtoBuilder toBuilder() =>
      TripChangeInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripChangeInputDto &&
        departureAt == other.departureAt &&
        stopTimes == other.stopTimes &&
        vehicleId == other.vehicleId &&
        stops == other.stops &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, departureAt.hashCode);
    _$hash = $jc(_$hash, stopTimes.hashCode);
    _$hash = $jc(_$hash, vehicleId.hashCode);
    _$hash = $jc(_$hash, stops.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripChangeInputDto')
          ..add('departureAt', departureAt)
          ..add('stopTimes', stopTimes)
          ..add('vehicleId', vehicleId)
          ..add('stops', stops)
          ..add('reason', reason))
        .toString();
  }
}

class TripChangeInputDtoBuilder
    implements Builder<TripChangeInputDto, TripChangeInputDtoBuilder> {
  _$TripChangeInputDto? _$v;

  DateTime? _departureAt;
  DateTime? get departureAt => _$this._departureAt;
  set departureAt(DateTime? departureAt) => _$this._departureAt = departureAt;

  ListBuilder<DateTime>? _stopTimes;
  ListBuilder<DateTime> get stopTimes =>
      _$this._stopTimes ??= ListBuilder<DateTime>();
  set stopTimes(ListBuilder<DateTime>? stopTimes) =>
      _$this._stopTimes = stopTimes;

  String? _vehicleId;
  String? get vehicleId => _$this._vehicleId;
  set vehicleId(String? vehicleId) => _$this._vehicleId = vehicleId;

  ListBuilder<TripChangeInputDtoStopsInner>? _stops;
  ListBuilder<TripChangeInputDtoStopsInner> get stops =>
      _$this._stops ??= ListBuilder<TripChangeInputDtoStopsInner>();
  set stops(ListBuilder<TripChangeInputDtoStopsInner>? stops) =>
      _$this._stops = stops;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  TripChangeInputDtoBuilder() {
    TripChangeInputDto._defaults(this);
  }

  TripChangeInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _departureAt = $v.departureAt;
      _stopTimes = $v.stopTimes?.toBuilder();
      _vehicleId = $v.vehicleId;
      _stops = $v.stops.toBuilder();
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripChangeInputDto other) {
    _$v = other as _$TripChangeInputDto;
  }

  @override
  void update(void Function(TripChangeInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripChangeInputDto build() => _build();

  _$TripChangeInputDto _build() {
    _$TripChangeInputDto _$result;
    try {
      _$result = _$v ??
          _$TripChangeInputDto._(
            departureAt: BuiltValueNullFieldError.checkNotNull(
                departureAt, r'TripChangeInputDto', 'departureAt'),
            stopTimes: _stopTimes?.build(),
            vehicleId: BuiltValueNullFieldError.checkNotNull(
                vehicleId, r'TripChangeInputDto', 'vehicleId'),
            stops: stops.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'TripChangeInputDto', 'reason'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stopTimes';
        _stopTimes?.build();

        _$failedField = 'stops';
        stops.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripChangeInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
