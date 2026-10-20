// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_window_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PickupWindowInputDto extends PickupWindowInputDto {
  @override
  final DateTime? start;
  @override
  final DateTime? end;

  factory _$PickupWindowInputDto(
          [void Function(PickupWindowInputDtoBuilder)? updates]) =>
      (PickupWindowInputDtoBuilder()..update(updates))._build();

  _$PickupWindowInputDto._({this.start, this.end}) : super._();
  @override
  PickupWindowInputDto rebuild(
          void Function(PickupWindowInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PickupWindowInputDtoBuilder toBuilder() =>
      PickupWindowInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PickupWindowInputDto &&
        start == other.start &&
        end == other.end;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, start.hashCode);
    _$hash = $jc(_$hash, end.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PickupWindowInputDto')
          ..add('start', start)
          ..add('end', end))
        .toString();
  }
}

class PickupWindowInputDtoBuilder
    implements Builder<PickupWindowInputDto, PickupWindowInputDtoBuilder> {
  _$PickupWindowInputDto? _$v;

  DateTime? _start;
  DateTime? get start => _$this._start;
  set start(DateTime? start) => _$this._start = start;

  DateTime? _end;
  DateTime? get end => _$this._end;
  set end(DateTime? end) => _$this._end = end;

  PickupWindowInputDtoBuilder() {
    PickupWindowInputDto._defaults(this);
  }

  PickupWindowInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _start = $v.start;
      _end = $v.end;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PickupWindowInputDto other) {
    _$v = other as _$PickupWindowInputDto;
  }

  @override
  void update(void Function(PickupWindowInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PickupWindowInputDto build() => _build();

  _$PickupWindowInputDto _build() {
    final _$result = _$v ??
        _$PickupWindowInputDto._(
          start: start,
          end: end,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
