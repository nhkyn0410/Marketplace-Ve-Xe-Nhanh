// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_cancel_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PolicyCancelDto extends PolicyCancelDto {
  @override
  final String reason;

  factory _$PolicyCancelDto([void Function(PolicyCancelDtoBuilder)? updates]) =>
      (PolicyCancelDtoBuilder()..update(updates))._build();

  _$PolicyCancelDto._({required this.reason}) : super._();
  @override
  PolicyCancelDto rebuild(void Function(PolicyCancelDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PolicyCancelDtoBuilder toBuilder() => PolicyCancelDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PolicyCancelDto && reason == other.reason;
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
    return (newBuiltValueToStringHelper(r'PolicyCancelDto')
          ..add('reason', reason))
        .toString();
  }
}

class PolicyCancelDtoBuilder
    implements Builder<PolicyCancelDto, PolicyCancelDtoBuilder> {
  _$PolicyCancelDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  PolicyCancelDtoBuilder() {
    PolicyCancelDto._defaults(this);
  }

  PolicyCancelDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PolicyCancelDto other) {
    _$v = other as _$PolicyCancelDto;
  }

  @override
  void update(void Function(PolicyCancelDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PolicyCancelDto build() => _build();

  _$PolicyCancelDto _build() {
    final _$result = _$v ??
        _$PolicyCancelDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'PolicyCancelDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
