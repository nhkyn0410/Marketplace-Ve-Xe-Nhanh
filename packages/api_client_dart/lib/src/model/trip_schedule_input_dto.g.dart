// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_schedule_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripScheduleInputDto extends TripScheduleInputDto {
  @override
  final String routeId;
  @override
  final String? vehicleId;
  @override
  final String departureTime;
  @override
  final int durationMinutes;
  @override
  final BuiltList<int> daysOfWeek;
  @override
  final Date startDate;
  @override
  final Date endDate;
  @override
  final int onlineSaleCutoffMinutes;
  @override
  final String? note;

  factory _$TripScheduleInputDto(
          [void Function(TripScheduleInputDtoBuilder)? updates]) =>
      (TripScheduleInputDtoBuilder()..update(updates))._build();

  _$TripScheduleInputDto._(
      {required this.routeId,
      this.vehicleId,
      required this.departureTime,
      required this.durationMinutes,
      required this.daysOfWeek,
      required this.startDate,
      required this.endDate,
      required this.onlineSaleCutoffMinutes,
      this.note})
      : super._();
  @override
  TripScheduleInputDto rebuild(
          void Function(TripScheduleInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripScheduleInputDtoBuilder toBuilder() =>
      TripScheduleInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripScheduleInputDto &&
        routeId == other.routeId &&
        vehicleId == other.vehicleId &&
        departureTime == other.departureTime &&
        durationMinutes == other.durationMinutes &&
        daysOfWeek == other.daysOfWeek &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        onlineSaleCutoffMinutes == other.onlineSaleCutoffMinutes &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, routeId.hashCode);
    _$hash = $jc(_$hash, vehicleId.hashCode);
    _$hash = $jc(_$hash, departureTime.hashCode);
    _$hash = $jc(_$hash, durationMinutes.hashCode);
    _$hash = $jc(_$hash, daysOfWeek.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, endDate.hashCode);
    _$hash = $jc(_$hash, onlineSaleCutoffMinutes.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripScheduleInputDto')
          ..add('routeId', routeId)
          ..add('vehicleId', vehicleId)
          ..add('departureTime', departureTime)
          ..add('durationMinutes', durationMinutes)
          ..add('daysOfWeek', daysOfWeek)
          ..add('startDate', startDate)
          ..add('endDate', endDate)
          ..add('onlineSaleCutoffMinutes', onlineSaleCutoffMinutes)
          ..add('note', note))
        .toString();
  }
}

class TripScheduleInputDtoBuilder
    implements Builder<TripScheduleInputDto, TripScheduleInputDtoBuilder> {
  _$TripScheduleInputDto? _$v;

  String? _routeId;
  String? get routeId => _$this._routeId;
  set routeId(String? routeId) => _$this._routeId = routeId;

  String? _vehicleId;
  String? get vehicleId => _$this._vehicleId;
  set vehicleId(String? vehicleId) => _$this._vehicleId = vehicleId;

  String? _departureTime;
  String? get departureTime => _$this._departureTime;
  set departureTime(String? departureTime) =>
      _$this._departureTime = departureTime;

  int? _durationMinutes;
  int? get durationMinutes => _$this._durationMinutes;
  set durationMinutes(int? durationMinutes) =>
      _$this._durationMinutes = durationMinutes;

  ListBuilder<int>? _daysOfWeek;
  ListBuilder<int> get daysOfWeek => _$this._daysOfWeek ??= ListBuilder<int>();
  set daysOfWeek(ListBuilder<int>? daysOfWeek) =>
      _$this._daysOfWeek = daysOfWeek;

  Date? _startDate;
  Date? get startDate => _$this._startDate;
  set startDate(Date? startDate) => _$this._startDate = startDate;

  Date? _endDate;
  Date? get endDate => _$this._endDate;
  set endDate(Date? endDate) => _$this._endDate = endDate;

  int? _onlineSaleCutoffMinutes;
  int? get onlineSaleCutoffMinutes => _$this._onlineSaleCutoffMinutes;
  set onlineSaleCutoffMinutes(int? onlineSaleCutoffMinutes) =>
      _$this._onlineSaleCutoffMinutes = onlineSaleCutoffMinutes;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  TripScheduleInputDtoBuilder() {
    TripScheduleInputDto._defaults(this);
  }

  TripScheduleInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _routeId = $v.routeId;
      _vehicleId = $v.vehicleId;
      _departureTime = $v.departureTime;
      _durationMinutes = $v.durationMinutes;
      _daysOfWeek = $v.daysOfWeek.toBuilder();
      _startDate = $v.startDate;
      _endDate = $v.endDate;
      _onlineSaleCutoffMinutes = $v.onlineSaleCutoffMinutes;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripScheduleInputDto other) {
    _$v = other as _$TripScheduleInputDto;
  }

  @override
  void update(void Function(TripScheduleInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripScheduleInputDto build() => _build();

  _$TripScheduleInputDto _build() {
    _$TripScheduleInputDto _$result;
    try {
      _$result = _$v ??
          _$TripScheduleInputDto._(
            routeId: BuiltValueNullFieldError.checkNotNull(
                routeId, r'TripScheduleInputDto', 'routeId'),
            vehicleId: vehicleId,
            departureTime: BuiltValueNullFieldError.checkNotNull(
                departureTime, r'TripScheduleInputDto', 'departureTime'),
            durationMinutes: BuiltValueNullFieldError.checkNotNull(
                durationMinutes, r'TripScheduleInputDto', 'durationMinutes'),
            daysOfWeek: daysOfWeek.build(),
            startDate: BuiltValueNullFieldError.checkNotNull(
                startDate, r'TripScheduleInputDto', 'startDate'),
            endDate: BuiltValueNullFieldError.checkNotNull(
                endDate, r'TripScheduleInputDto', 'endDate'),
            onlineSaleCutoffMinutes: BuiltValueNullFieldError.checkNotNull(
                onlineSaleCutoffMinutes,
                r'TripScheduleInputDto',
                'onlineSaleCutoffMinutes'),
            note: note,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'daysOfWeek';
        daysOfWeek.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripScheduleInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
