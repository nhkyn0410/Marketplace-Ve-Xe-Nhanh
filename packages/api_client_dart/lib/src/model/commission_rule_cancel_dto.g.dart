// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_rule_cancel_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionRuleCancelDto extends CommissionRuleCancelDto {
  @override
  final String reason;

  factory _$CommissionRuleCancelDto(
          [void Function(CommissionRuleCancelDtoBuilder)? updates]) =>
      (CommissionRuleCancelDtoBuilder()..update(updates))._build();

  _$CommissionRuleCancelDto._({required this.reason}) : super._();
  @override
  CommissionRuleCancelDto rebuild(
          void Function(CommissionRuleCancelDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionRuleCancelDtoBuilder toBuilder() =>
      CommissionRuleCancelDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionRuleCancelDto && reason == other.reason;
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
    return (newBuiltValueToStringHelper(r'CommissionRuleCancelDto')
          ..add('reason', reason))
        .toString();
  }
}

class CommissionRuleCancelDtoBuilder
    implements
        Builder<CommissionRuleCancelDto, CommissionRuleCancelDtoBuilder> {
  _$CommissionRuleCancelDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CommissionRuleCancelDtoBuilder() {
    CommissionRuleCancelDto._defaults(this);
  }

  CommissionRuleCancelDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionRuleCancelDto other) {
    _$v = other as _$CommissionRuleCancelDto;
  }

  @override
  void update(void Function(CommissionRuleCancelDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionRuleCancelDto build() => _build();

  _$CommissionRuleCancelDto _build() {
    final _$result = _$v ??
        _$CommissionRuleCancelDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'CommissionRuleCancelDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
