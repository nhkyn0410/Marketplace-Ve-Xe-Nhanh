// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_log_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$JourneyLogInputDto extends JourneyLogInputDto {
  @override
  final String tripId;
  @override
  final int? stopSequence;
  @override
  final DateTime actualAt;
  @override
  final String? vehicleStatus;
  @override
  final String? note;

  factory _$JourneyLogInputDto(
          [void Function(JourneyLogInputDtoBuilder)? updates]) =>
      (JourneyLogInputDtoBuilder()..update(updates))._build();

  _$JourneyLogInputDto._(
      {required this.tripId,
      this.stopSequence,
      required this.actualAt,
      this.vehicleStatus,
      this.note})
      : super._();
  @override
  JourneyLogInputDto rebuild(
          void Function(JourneyLogInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JourneyLogInputDtoBuilder toBuilder() =>
      JourneyLogInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JourneyLogInputDto &&
        tripId == other.tripId &&
        stopSequence == other.stopSequence &&
        actualAt == other.actualAt &&
        vehicleStatus == other.vehicleStatus &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tripId.hashCode);
    _$hash = $jc(_$hash, stopSequence.hashCode);
    _$hash = $jc(_$hash, actualAt.hashCode);
    _$hash = $jc(_$hash, vehicleStatus.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JourneyLogInputDto')
          ..add('tripId', tripId)
          ..add('stopSequence', stopSequence)
          ..add('actualAt', actualAt)
          ..add('vehicleStatus', vehicleStatus)
          ..add('note', note))
        .toString();
  }
}

class JourneyLogInputDtoBuilder
    implements Builder<JourneyLogInputDto, JourneyLogInputDtoBuilder> {
  _$JourneyLogInputDto? _$v;

  String? _tripId;
  String? get tripId => _$this._tripId;
  set tripId(String? tripId) => _$this._tripId = tripId;

  int? _stopSequence;
  int? get stopSequence => _$this._stopSequence;
  set stopSequence(int? stopSequence) => _$this._stopSequence = stopSequence;

  DateTime? _actualAt;
  DateTime? get actualAt => _$this._actualAt;
  set actualAt(DateTime? actualAt) => _$this._actualAt = actualAt;

  String? _vehicleStatus;
  String? get vehicleStatus => _$this._vehicleStatus;
  set vehicleStatus(String? vehicleStatus) =>
      _$this._vehicleStatus = vehicleStatus;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  JourneyLogInputDtoBuilder() {
    JourneyLogInputDto._defaults(this);
  }

  JourneyLogInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tripId = $v.tripId;
      _stopSequence = $v.stopSequence;
      _actualAt = $v.actualAt;
      _vehicleStatus = $v.vehicleStatus;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JourneyLogInputDto other) {
    _$v = other as _$JourneyLogInputDto;
  }

  @override
  void update(void Function(JourneyLogInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JourneyLogInputDto build() => _build();

  _$JourneyLogInputDto _build() {
    final _$result = _$v ??
        _$JourneyLogInputDto._(
          tripId: BuiltValueNullFieldError.checkNotNull(
              tripId, r'JourneyLogInputDto', 'tripId'),
          stopSequence: stopSequence,
          actualAt: BuiltValueNullFieldError.checkNotNull(
              actualAt, r'JourneyLogInputDto', 'actualAt'),
          vehicleStatus: vehicleStatus,
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
