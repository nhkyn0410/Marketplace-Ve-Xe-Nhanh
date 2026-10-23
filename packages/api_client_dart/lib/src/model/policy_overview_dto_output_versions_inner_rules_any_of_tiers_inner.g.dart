// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_overview_dto_output_versions_inner_rules_any_of_tiers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner
    extends PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner {
  @override
  final int minHoursBefore;
  @override
  final int refundPercent;

  factory _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner(
          [void Function(
                  PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerBuilder)?
              updates]) =>
      (PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerBuilder()
            ..update(updates))
          ._build();

  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner._(
      {required this.minHoursBefore, required this.refundPercent})
      : super._();
  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner rebuild(
          void Function(
                  PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerBuilder toBuilder() =>
      PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner &&
        minHoursBefore == other.minHoursBefore &&
        refundPercent == other.refundPercent;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, minHoursBefore.hashCode);
    _$hash = $jc(_$hash, refundPercent.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner')
          ..add('minHoursBefore', minHoursBefore)
          ..add('refundPercent', refundPercent))
        .toString();
  }
}

class PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerBuilder
    implements
        Builder<PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner,
            PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerBuilder> {
  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner? _$v;

  int? _minHoursBefore;
  int? get minHoursBefore => _$this._minHoursBefore;
  set minHoursBefore(int? minHoursBefore) =>
      _$this._minHoursBefore = minHoursBefore;

  int? _refundPercent;
  int? get refundPercent => _$this._refundPercent;
  set refundPercent(int? refundPercent) =>
      _$this._refundPercent = refundPercent;

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerBuilder() {
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner._defaults(this);
  }

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _minHoursBefore = $v.minHoursBefore;
      _refundPercent = $v.refundPercent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner other) {
    _$v = other as _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner;
  }

  @override
  void update(
      void Function(
              PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner build() => _build();

  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner _build() {
    final _$result = _$v ??
        _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner._(
          minHoursBefore: BuiltValueNullFieldError.checkNotNull(
              minHoursBefore,
              r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner',
              'minHoursBefore'),
          refundPercent: BuiltValueNullFieldError.checkNotNull(
              refundPercent,
              r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner',
              'refundPercent'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
