// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decision_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DecisionInputDto extends DecisionInputDto {
  @override
  final String reason;

  factory _$DecisionInputDto(
          [void Function(DecisionInputDtoBuilder)? updates]) =>
      (DecisionInputDtoBuilder()..update(updates))._build();

  _$DecisionInputDto._({required this.reason}) : super._();
  @override
  DecisionInputDto rebuild(void Function(DecisionInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DecisionInputDtoBuilder toBuilder() =>
      DecisionInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DecisionInputDto && reason == other.reason;
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
    return (newBuiltValueToStringHelper(r'DecisionInputDto')
          ..add('reason', reason))
        .toString();
  }
}

class DecisionInputDtoBuilder
    implements Builder<DecisionInputDto, DecisionInputDtoBuilder> {
  _$DecisionInputDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DecisionInputDtoBuilder() {
    DecisionInputDto._defaults(this);
  }

  DecisionInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DecisionInputDto other) {
    _$v = other as _$DecisionInputDto;
  }

  @override
  void update(void Function(DecisionInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DecisionInputDto build() => _build();

  _$DecisionInputDto _build() {
    final _$result = _$v ??
        _$DecisionInputDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'DecisionInputDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
