// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_reason_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PayoutReasonInputDto extends PayoutReasonInputDto {
  @override
  final String reason;

  factory _$PayoutReasonInputDto(
          [void Function(PayoutReasonInputDtoBuilder)? updates]) =>
      (PayoutReasonInputDtoBuilder()..update(updates))._build();

  _$PayoutReasonInputDto._({required this.reason}) : super._();
  @override
  PayoutReasonInputDto rebuild(
          void Function(PayoutReasonInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PayoutReasonInputDtoBuilder toBuilder() =>
      PayoutReasonInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutReasonInputDto && reason == other.reason;
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
    return (newBuiltValueToStringHelper(r'PayoutReasonInputDto')
          ..add('reason', reason))
        .toString();
  }
}

class PayoutReasonInputDtoBuilder
    implements Builder<PayoutReasonInputDto, PayoutReasonInputDtoBuilder> {
  _$PayoutReasonInputDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  PayoutReasonInputDtoBuilder() {
    PayoutReasonInputDto._defaults(this);
  }

  PayoutReasonInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutReasonInputDto other) {
    _$v = other as _$PayoutReasonInputDto;
  }

  @override
  void update(void Function(PayoutReasonInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutReasonInputDto build() => _build();

  _$PayoutReasonInputDto _build() {
    final _$result = _$v ??
        _$PayoutReasonInputDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'PayoutReasonInputDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
