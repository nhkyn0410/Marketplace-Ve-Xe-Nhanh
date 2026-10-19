// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_schedule_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripScheduleResponseDtoOutput extends TripScheduleResponseDtoOutput {
  @override
  final String id;
  @override
  final String routeId;
  @override
  final String routeName;
  @override
  final String? vehicleId;
  @override
  final String? vehiclePlateNumber;
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
  @override
  final int tripCount;
  @override
  final DateTime? lastGeneratedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$TripScheduleResponseDtoOutput(
          [void Function(TripScheduleResponseDtoOutputBuilder)? updates]) =>
      (TripScheduleResponseDtoOutputBuilder()..update(updates))._build();

  _$TripScheduleResponseDtoOutput._(
      {required this.id,
      required this.routeId,
      required this.routeName,
      this.vehicleId,
      this.vehiclePlateNumber,
      required this.departureTime,
      required this.durationMinutes,
      required this.daysOfWeek,
      required this.startDate,
      required this.endDate,
      required this.onlineSaleCutoffMinutes,
      this.note,
      required this.tripCount,
      this.lastGeneratedAt,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  TripScheduleResponseDtoOutput rebuild(
          void Function(TripScheduleResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripScheduleResponseDtoOutputBuilder toBuilder() =>
      TripScheduleResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripScheduleResponseDtoOutput &&
        id == other.id &&
        routeId == other.routeId &&
        routeName == other.routeName &&
        vehicleId == other.vehicleId &&
        vehiclePlateNumber == other.vehiclePlateNumber &&
        departureTime == other.departureTime &&
        durationMinutes == other.durationMinutes &&
        daysOfWeek == other.daysOfWeek &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        onlineSaleCutoffMinutes == other.onlineSaleCutoffMinutes &&
        note == other.note &&
        tripCount == other.tripCount &&
        lastGeneratedAt == other.lastGeneratedAt &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, routeId.hashCode);
    _$hash = $jc(_$hash, routeName.hashCode);
    _$hash = $jc(_$hash, vehicleId.hashCode);
    _$hash = $jc(_$hash, vehiclePlateNumber.hashCode);
    _$hash = $jc(_$hash, departureTime.hashCode);
    _$hash = $jc(_$hash, durationMinutes.hashCode);
    _$hash = $jc(_$hash, daysOfWeek.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, endDate.hashCode);
    _$hash = $jc(_$hash, onlineSaleCutoffMinutes.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, tripCount.hashCode);
    _$hash = $jc(_$hash, lastGeneratedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripScheduleResponseDtoOutput')
          ..add('id', id)
          ..add('routeId', routeId)
          ..add('routeName', routeName)
          ..add('vehicleId', vehicleId)
          ..add('vehiclePlateNumber', vehiclePlateNumber)
          ..add('departureTime', departureTime)
          ..add('durationMinutes', durationMinutes)
          ..add('daysOfWeek', daysOfWeek)
          ..add('startDate', startDate)
          ..add('endDate', endDate)
          ..add('onlineSaleCutoffMinutes', onlineSaleCutoffMinutes)
          ..add('note', note)
          ..add('tripCount', tripCount)
          ..add('lastGeneratedAt', lastGeneratedAt)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class TripScheduleResponseDtoOutputBuilder
    implements
        Builder<TripScheduleResponseDtoOutput,
            TripScheduleResponseDtoOutputBuilder> {
  _$TripScheduleResponseDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _routeId;
  String? get routeId => _$this._routeId;
  set routeId(String? routeId) => _$this._routeId = routeId;

  String? _routeName;
  String? get routeName => _$this._routeName;
  set routeName(String? routeName) => _$this._routeName = routeName;

  String? _vehicleId;
  String? get vehicleId => _$this._vehicleId;
  set vehicleId(String? vehicleId) => _$this._vehicleId = vehicleId;

  String? _vehiclePlateNumber;
  String? get vehiclePlateNumber => _$this._vehiclePlateNumber;
  set vehiclePlateNumber(String? vehiclePlateNumber) =>
      _$this._vehiclePlateNumber = vehiclePlateNumber;

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

  int? _tripCount;
  int? get tripCount => _$this._tripCount;
  set tripCount(int? tripCount) => _$this._tripCount = tripCount;

  DateTime? _lastGeneratedAt;
  DateTime? get lastGeneratedAt => _$this._lastGeneratedAt;
  set lastGeneratedAt(DateTime? lastGeneratedAt) =>
      _$this._lastGeneratedAt = lastGeneratedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  TripScheduleResponseDtoOutputBuilder() {
    TripScheduleResponseDtoOutput._defaults(this);
  }

  TripScheduleResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _routeId = $v.routeId;
      _routeName = $v.routeName;
      _vehicleId = $v.vehicleId;
      _vehiclePlateNumber = $v.vehiclePlateNumber;
      _departureTime = $v.departureTime;
      _durationMinutes = $v.durationMinutes;
      _daysOfWeek = $v.daysOfWeek.toBuilder();
      _startDate = $v.startDate;
      _endDate = $v.endDate;
      _onlineSaleCutoffMinutes = $v.onlineSaleCutoffMinutes;
      _note = $v.note;
      _tripCount = $v.tripCount;
      _lastGeneratedAt = $v.lastGeneratedAt;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripScheduleResponseDtoOutput other) {
    _$v = other as _$TripScheduleResponseDtoOutput;
  }

  @override
  void update(void Function(TripScheduleResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripScheduleResponseDtoOutput build() => _build();

  _$TripScheduleResponseDtoOutput _build() {
    _$TripScheduleResponseDtoOutput _$result;
    try {
      _$result = _$v ??
          _$TripScheduleResponseDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'TripScheduleResponseDtoOutput', 'id'),
            routeId: BuiltValueNullFieldError.checkNotNull(
                routeId, r'TripScheduleResponseDtoOutput', 'routeId'),
            routeName: BuiltValueNullFieldError.checkNotNull(
                routeName, r'TripScheduleResponseDtoOutput', 'routeName'),
            vehicleId: vehicleId,
            vehiclePlateNumber: vehiclePlateNumber,
            departureTime: BuiltValueNullFieldError.checkNotNull(departureTime,
                r'TripScheduleResponseDtoOutput', 'departureTime'),
            durationMinutes: BuiltValueNullFieldError.checkNotNull(
                durationMinutes,
                r'TripScheduleResponseDtoOutput',
                'durationMinutes'),
            daysOfWeek: daysOfWeek.build(),
            startDate: BuiltValueNullFieldError.checkNotNull(
                startDate, r'TripScheduleResponseDtoOutput', 'startDate'),
            endDate: BuiltValueNullFieldError.checkNotNull(
                endDate, r'TripScheduleResponseDtoOutput', 'endDate'),
            onlineSaleCutoffMinutes: BuiltValueNullFieldError.checkNotNull(
                onlineSaleCutoffMinutes,
                r'TripScheduleResponseDtoOutput',
                'onlineSaleCutoffMinutes'),
            note: note,
            tripCount: BuiltValueNullFieldError.checkNotNull(
                tripCount, r'TripScheduleResponseDtoOutput', 'tripCount'),
            lastGeneratedAt: lastGeneratedAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'TripScheduleResponseDtoOutput', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'TripScheduleResponseDtoOutput', 'updatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'daysOfWeek';
        daysOfWeek.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TripScheduleResponseDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
