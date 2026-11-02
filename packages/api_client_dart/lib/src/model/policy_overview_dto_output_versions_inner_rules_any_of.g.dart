// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_overview_dto_output_versions_inner_rules_any_of.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf
    extends PolicyOverviewDtoOutputVersionsInnerRulesAnyOf {
  @override
  final BuiltList<PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner>
      tiers;

  factory _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf(
          [void Function(PolicyOverviewDtoOutputVersionsInnerRulesAnyOfBuilder)?
              updates]) =>
      (PolicyOverviewDtoOutputVersionsInnerRulesAnyOfBuilder()..update(updates))
          ._build();

  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf._({required this.tiers})
      : super._();
  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf rebuild(
          void Function(PolicyOverviewDtoOutputVersionsInnerRulesAnyOfBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOfBuilder toBuilder() =>
      PolicyOverviewDtoOutputVersionsInnerRulesAnyOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PolicyOverviewDtoOutputVersionsInnerRulesAnyOf &&
        tiers == other.tiers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tiers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf')
          ..add('tiers', tiers))
        .toString();
  }
}

class PolicyOverviewDtoOutputVersionsInnerRulesAnyOfBuilder
    implements
        Builder<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf,
            PolicyOverviewDtoOutputVersionsInnerRulesAnyOfBuilder> {
  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf? _$v;

  ListBuilder<PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner>? _tiers;
  ListBuilder<PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner>
      get tiers => _$this._tiers ??= ListBuilder<
          PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner>();
  set tiers(
          ListBuilder<PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner>?
              tiers) =>
      _$this._tiers = tiers;

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOfBuilder() {
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf._defaults(this);
  }

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tiers = $v.tiers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf other) {
    _$v = other as _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf;
  }

  @override
  void update(
      void Function(PolicyOverviewDtoOutputVersionsInnerRulesAnyOfBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf build() => _build();

  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf _build() {
    _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf _$result;
    try {
      _$result = _$v ??
          _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf._(
            tiers: tiers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tiers';
        tiers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
