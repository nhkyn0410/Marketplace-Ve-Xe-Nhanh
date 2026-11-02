// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_overview_dto_output_versions_inner_rules_any_of1.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1
    extends PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1 {
  @override
  final int holdMinutes;

  factory _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1(
          [void Function(
                  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Builder)?
              updates]) =>
      (PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Builder()
            ..update(updates))
          ._build();

  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1._(
      {required this.holdMinutes})
      : super._();
  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1 rebuild(
          void Function(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Builder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Builder toBuilder() =>
      PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1 &&
        holdMinutes == other.holdMinutes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, holdMinutes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1')
          ..add('holdMinutes', holdMinutes))
        .toString();
  }
}

class PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Builder
    implements
        Builder<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1,
            PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Builder> {
  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1? _$v;

  int? _holdMinutes;
  int? get holdMinutes => _$this._holdMinutes;
  set holdMinutes(int? holdMinutes) => _$this._holdMinutes = holdMinutes;

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Builder() {
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1._defaults(this);
  }

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _holdMinutes = $v.holdMinutes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1 other) {
    _$v = other as _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1;
  }

  @override
  void update(
      void Function(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Builder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1 build() => _build();

  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1 _build() {
    final _$result = _$v ??
        _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1._(
          holdMinutes: BuiltValueNullFieldError.checkNotNull(
              holdMinutes,
              r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1',
              'holdMinutes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
