// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_change_input_dto_stops_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripChangeInputDtoStopsInner extends TripChangeInputDtoStopsInner {
  @override
  final int sequence;
  @override
  final String? catalogStopPointId;
  @override
  final String? stopPointId;

  factory _$TripChangeInputDtoStopsInner(
          [void Function(TripChangeInputDtoStopsInnerBuilder)? updates]) =>
      (TripChangeInputDtoStopsInnerBuilder()..update(updates))._build();

  _$TripChangeInputDtoStopsInner._(
      {required this.sequence, this.catalogStopPointId, this.stopPointId})
      : super._();
  @override
  TripChangeInputDtoStopsInner rebuild(
          void Function(TripChangeInputDtoStopsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripChangeInputDtoStopsInnerBuilder toBuilder() =>
      TripChangeInputDtoStopsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripChangeInputDtoStopsInner &&
        sequence == other.sequence &&
        catalogStopPointId == other.catalogStopPointId &&
        stopPointId == other.stopPointId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sequence.hashCode);
    _$hash = $jc(_$hash, catalogStopPointId.hashCode);
    _$hash = $jc(_$hash, stopPointId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripChangeInputDtoStopsInner')
          ..add('sequence', sequence)
          ..add('catalogStopPointId', catalogStopPointId)
          ..add('stopPointId', stopPointId))
        .toString();
  }
}

class TripChangeInputDtoStopsInnerBuilder
    implements
        Builder<TripChangeInputDtoStopsInner,
            TripChangeInputDtoStopsInnerBuilder> {
  _$TripChangeInputDtoStopsInner? _$v;

  int? _sequence;
  int? get sequence => _$this._sequence;
  set sequence(int? sequence) => _$this._sequence = sequence;

  String? _catalogStopPointId;
  String? get catalogStopPointId => _$this._catalogStopPointId;
  set catalogStopPointId(String? catalogStopPointId) =>
      _$this._catalogStopPointId = catalogStopPointId;

  String? _stopPointId;
  String? get stopPointId => _$this._stopPointId;
  set stopPointId(String? stopPointId) => _$this._stopPointId = stopPointId;

  TripChangeInputDtoStopsInnerBuilder() {
    TripChangeInputDtoStopsInner._defaults(this);
  }

  TripChangeInputDtoStopsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sequence = $v.sequence;
      _catalogStopPointId = $v.catalogStopPointId;
      _stopPointId = $v.stopPointId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripChangeInputDtoStopsInner other) {
    _$v = other as _$TripChangeInputDtoStopsInner;
  }

  @override
  void update(void Function(TripChangeInputDtoStopsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripChangeInputDtoStopsInner build() => _build();

  _$TripChangeInputDtoStopsInner _build() {
    final _$result = _$v ??
        _$TripChangeInputDtoStopsInner._(
          sequence: BuiltValueNullFieldError.checkNotNull(
              sequence, r'TripChangeInputDtoStopsInner', 'sequence'),
          catalogStopPointId: catalogStopPointId,
          stopPointId: stopPointId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
