// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_log_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$JourneyLogPageDtoOutputItemsInner
    extends JourneyLogPageDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String operatorId;
  @override
  final String tripId;
  @override
  final String employeeId;
  @override
  final int? stopSequence;
  @override
  final DateTime actualAt;
  @override
  final DateTime createdAt;
  @override
  final String? vehicleStatus;
  @override
  final String? note;
  @override
  final int delayMinutes;

  factory _$JourneyLogPageDtoOutputItemsInner(
          [void Function(JourneyLogPageDtoOutputItemsInnerBuilder)? updates]) =>
      (JourneyLogPageDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$JourneyLogPageDtoOutputItemsInner._(
      {required this.id,
      required this.operatorId,
      required this.tripId,
      required this.employeeId,
      this.stopSequence,
      required this.actualAt,
      required this.createdAt,
      this.vehicleStatus,
      this.note,
      required this.delayMinutes})
      : super._();
  @override
  JourneyLogPageDtoOutputItemsInner rebuild(
          void Function(JourneyLogPageDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JourneyLogPageDtoOutputItemsInnerBuilder toBuilder() =>
      JourneyLogPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JourneyLogPageDtoOutputItemsInner &&
        id == other.id &&
        operatorId == other.operatorId &&
        tripId == other.tripId &&
        employeeId == other.employeeId &&
        stopSequence == other.stopSequence &&
        actualAt == other.actualAt &&
        createdAt == other.createdAt &&
        vehicleStatus == other.vehicleStatus &&
        note == other.note &&
        delayMinutes == other.delayMinutes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, employeeId.hashCode);
    _$hash = $jc(_$hash, stopSequence.hashCode);
    _$hash = $jc(_$hash, actualAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, vehicleStatus.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, delayMinutes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JourneyLogPageDtoOutputItemsInner')
          ..add('id', id)
          ..add('operatorId', operatorId)
          ..add('tripId', tripId)
          ..add('employeeId', employeeId)
          ..add('stopSequence', stopSequence)
          ..add('actualAt', actualAt)
          ..add('createdAt', createdAt)
          ..add('vehicleStatus', vehicleStatus)
          ..add('note', note)
          ..add('delayMinutes', delayMinutes))
        .toString();
  }
}

class JourneyLogPageDtoOutputItemsInnerBuilder
    implements
        Builder<JourneyLogPageDtoOutputItemsInner,
            JourneyLogPageDtoOutputItemsInnerBuilder> {
  _$JourneyLogPageDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  String? _employeeId;
  String? get employeeId => _$this._employeeId;
  set employeeId(String? employeeId) => _$this._employeeId = employeeId;

  int? _stopSequence;
  int? get stopSequence => _$this._stopSequence;
  set stopSequence(int? stopSequence) => _$this._stopSequence = stopSequence;

  DateTime? _actualAt;
  DateTime? get actualAt => _$this._actualAt;
  set actualAt(DateTime? actualAt) => _$this._actualAt = actualAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _vehicleStatus;
  String? get vehicleStatus => _$this._vehicleStatus;
  set vehicleStatus(String? vehicleStatus) =>
      _$this._vehicleStatus = vehicleStatus;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  int? _delayMinutes;
  int? get delayMinutes => _$this._delayMinutes;
  set delayMinutes(int? delayMinutes) => _$this._delayMinutes = delayMinutes;

  JourneyLogPageDtoOutputItemsInnerBuilder() {
    JourneyLogPageDtoOutputItemsInner._defaults(this);
  }

  JourneyLogPageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _operatorId = $v.operatorId;
      _tripId = $v.tripId;
      _employeeId = $v.employeeId;
      _stopSequence = $v.stopSequence;
      _actualAt = $v.actualAt;
      _createdAt = $v.createdAt;
      _vehicleStatus = $v.vehicleStatus;
      _note = $v.note;
      _delayMinutes = $v.delayMinutes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JourneyLogPageDtoOutputItemsInner other) {
    _$v = other as _$JourneyLogPageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(JourneyLogPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JourneyLogPageDtoOutputItemsInner build() => _build();

  _$JourneyLogPageDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$JourneyLogPageDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'JourneyLogPageDtoOutputItemsInner', 'id'),
          operatorId: BuiltValueNullFieldError.checkNotNull(
              operatorId, r'JourneyLogPageDtoOutputItemsInner', 'operatorId'),
          tripId: BuiltValueNullFieldError.checkNotNull(
              tripId, r'JourneyLogPageDtoOutputItemsInner', 'tripId'),
          employeeId: BuiltValueNullFieldError.checkNotNull(
              employeeId, r'JourneyLogPageDtoOutputItemsInner', 'employeeId'),
          stopSequence: stopSequence,
          actualAt: BuiltValueNullFieldError.checkNotNull(
              actualAt, r'JourneyLogPageDtoOutputItemsInner', 'actualAt'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'JourneyLogPageDtoOutputItemsInner', 'createdAt'),
          vehicleStatus: vehicleStatus,
          note: note,
          delayMinutes: BuiltValueNullFieldError.checkNotNull(delayMinutes,
              r'JourneyLogPageDtoOutputItemsInner', 'delayMinutes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
