// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_reason_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RefundReasonInputDto extends RefundReasonInputDto {
  @override
  final String reason;

  factory _$RefundReasonInputDto(
          [void Function(RefundReasonInputDtoBuilder)? updates]) =>
      (RefundReasonInputDtoBuilder()..update(updates))._build();

  _$RefundReasonInputDto._({required this.reason}) : super._();
  @override
  RefundReasonInputDto rebuild(
          void Function(RefundReasonInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RefundReasonInputDtoBuilder toBuilder() =>
      RefundReasonInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RefundReasonInputDto && reason == other.reason;
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
    return (newBuiltValueToStringHelper(r'RefundReasonInputDto')
          ..add('reason', reason))
        .toString();
  }
}

class RefundReasonInputDtoBuilder
    implements Builder<RefundReasonInputDto, RefundReasonInputDtoBuilder> {
  _$RefundReasonInputDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  RefundReasonInputDtoBuilder() {
    RefundReasonInputDto._defaults(this);
  }

  RefundReasonInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RefundReasonInputDto other) {
    _$v = other as _$RefundReasonInputDto;
  }

  @override
  void update(void Function(RefundReasonInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RefundReasonInputDto build() => _build();

  _$RefundReasonInputDto _build() {
    final _$result = _$v ??
        _$RefundReasonInputDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'RefundReasonInputDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
