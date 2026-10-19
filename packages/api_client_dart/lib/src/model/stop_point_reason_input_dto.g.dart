// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_point_reason_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StopPointReasonInputDto extends StopPointReasonInputDto {
  @override
  final String reason;

  factory _$StopPointReasonInputDto(
          [void Function(StopPointReasonInputDtoBuilder)? updates]) =>
      (StopPointReasonInputDtoBuilder()..update(updates))._build();

  _$StopPointReasonInputDto._({required this.reason}) : super._();
  @override
  StopPointReasonInputDto rebuild(
          void Function(StopPointReasonInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StopPointReasonInputDtoBuilder toBuilder() =>
      StopPointReasonInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StopPointReasonInputDto && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StopPointReasonInputDto')
          ..add('reason', reason))
        .toString();
  }
}

class StopPointReasonInputDtoBuilder
    implements
        Builder<StopPointReasonInputDto, StopPointReasonInputDtoBuilder> {
  _$StopPointReasonInputDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  StopPointReasonInputDtoBuilder() {
    StopPointReasonInputDto._defaults(this);
  }

  StopPointReasonInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StopPointReasonInputDto other) {
    _$v = other as _$StopPointReasonInputDto;
  }

  @override
  void update(void Function(StopPointReasonInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StopPointReasonInputDto build() => _build();

  _$StopPointReasonInputDto _build() {
    final _$result = _$v ??
        _$StopPointReasonInputDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'StopPointReasonInputDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
