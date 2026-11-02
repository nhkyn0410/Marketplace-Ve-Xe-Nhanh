// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_publish_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PolicyPublishDto extends PolicyPublishDto {
  @override
  final String changeReason;

  factory _$PolicyPublishDto(
          [void Function(PolicyPublishDtoBuilder)? updates]) =>
      (PolicyPublishDtoBuilder()..update(updates))._build();

  _$PolicyPublishDto._({required this.changeReason}) : super._();
  @override
  PolicyPublishDto rebuild(void Function(PolicyPublishDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PolicyPublishDtoBuilder toBuilder() =>
      PolicyPublishDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PolicyPublishDto && changeReason == other.changeReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, changeReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PolicyPublishDto')
          ..add('changeReason', changeReason))
        .toString();
  }
}

class PolicyPublishDtoBuilder
    implements Builder<PolicyPublishDto, PolicyPublishDtoBuilder> {
  _$PolicyPublishDto? _$v;

  String? _changeReason;
  String? get changeReason => _$this._changeReason;
  set changeReason(String? changeReason) => _$this._changeReason = changeReason;

  PolicyPublishDtoBuilder() {
    PolicyPublishDto._defaults(this);
  }

  PolicyPublishDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _changeReason = $v.changeReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PolicyPublishDto other) {
    _$v = other as _$PolicyPublishDto;
  }

  @override
  void update(void Function(PolicyPublishDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PolicyPublishDto build() => _build();

  _$PolicyPublishDto _build() {
    final _$result = _$v ??
        _$PolicyPublishDto._(
          changeReason: BuiltValueNullFieldError.checkNotNull(
              changeReason, r'PolicyPublishDto', 'changeReason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
