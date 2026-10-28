// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_departure_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripDepartureInputDto extends TripDepartureInputDto {
  @override
  final String? note;

  factory _$TripDepartureInputDto(
          [void Function(TripDepartureInputDtoBuilder)? updates]) =>
      (TripDepartureInputDtoBuilder()..update(updates))._build();

  _$TripDepartureInputDto._({this.note}) : super._();
  @override
  TripDepartureInputDto rebuild(
          void Function(TripDepartureInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripDepartureInputDtoBuilder toBuilder() =>
      TripDepartureInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripDepartureInputDto && note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TripDepartureInputDto')
          ..add('note', note))
        .toString();
  }
}

class TripDepartureInputDtoBuilder
    implements Builder<TripDepartureInputDto, TripDepartureInputDtoBuilder> {
  _$TripDepartureInputDto? _$v;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  TripDepartureInputDtoBuilder() {
    TripDepartureInputDto._defaults(this);
  }

  TripDepartureInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripDepartureInputDto other) {
    _$v = other as _$TripDepartureInputDto;
  }

  @override
  void update(void Function(TripDepartureInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripDepartureInputDto build() => _build();

  _$TripDepartureInputDto _build() {
    final _$result = _$v ??
        _$TripDepartureInputDto._(
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
