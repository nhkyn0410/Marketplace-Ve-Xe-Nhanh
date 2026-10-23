// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_overview_dto_output_versions_inner_rules_any_of3.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3
    extends PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3 {
  @override
  final int earnUnit;
  @override
  final int pointValue;
  @override
  final int minRedeemPoints;
  @override
  final int pointExpiryMonths;
  @override
  final int voucherValidityDays;
  @override
  final BuiltList<PassengerLoyaltyDtoOutputRulesTiersInner> tiers;

  factory _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3(
          [void Function(
                  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Builder)?
              updates]) =>
      (PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Builder()
            ..update(updates))
          ._build();

  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3._(
      {required this.earnUnit,
      required this.pointValue,
      required this.minRedeemPoints,
      required this.pointExpiryMonths,
      required this.voucherValidityDays,
      required this.tiers})
      : super._();
  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3 rebuild(
          void Function(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Builder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Builder toBuilder() =>
      PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3 &&
        earnUnit == other.earnUnit &&
        pointValue == other.pointValue &&
        minRedeemPoints == other.minRedeemPoints &&
        pointExpiryMonths == other.pointExpiryMonths &&
        voucherValidityDays == other.voucherValidityDays &&
        tiers == other.tiers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, earnUnit.hashCode);
    _$hash = $jc(_$hash, pointValue.hashCode);
    _$hash = $jc(_$hash, minRedeemPoints.hashCode);
    _$hash = $jc(_$hash, pointExpiryMonths.hashCode);
    _$hash = $jc(_$hash, voucherValidityDays.hashCode);
    _$hash = $jc(_$hash, tiers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3')
          ..add('earnUnit', earnUnit)
          ..add('pointValue', pointValue)
          ..add('minRedeemPoints', minRedeemPoints)
          ..add('pointExpiryMonths', pointExpiryMonths)
          ..add('voucherValidityDays', voucherValidityDays)
          ..add('tiers', tiers))
        .toString();
  }
}

class PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Builder
    implements
        Builder<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3,
            PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Builder> {
  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3? _$v;

  int? _earnUnit;
  int? get earnUnit => _$this._earnUnit;
  set earnUnit(int? earnUnit) => _$this._earnUnit = earnUnit;

  int? _pointValue;
  int? get pointValue => _$this._pointValue;
  set pointValue(int? pointValue) => _$this._pointValue = pointValue;

  int? _minRedeemPoints;
  int? get minRedeemPoints => _$this._minRedeemPoints;
  set minRedeemPoints(int? minRedeemPoints) =>
      _$this._minRedeemPoints = minRedeemPoints;

  int? _pointExpiryMonths;
  int? get pointExpiryMonths => _$this._pointExpiryMonths;
  set pointExpiryMonths(int? pointExpiryMonths) =>
      _$this._pointExpiryMonths = pointExpiryMonths;

  int? _voucherValidityDays;
  int? get voucherValidityDays => _$this._voucherValidityDays;
  set voucherValidityDays(int? voucherValidityDays) =>
      _$this._voucherValidityDays = voucherValidityDays;

  ListBuilder<PassengerLoyaltyDtoOutputRulesTiersInner>? _tiers;
  ListBuilder<PassengerLoyaltyDtoOutputRulesTiersInner> get tiers =>
      _$this._tiers ??= ListBuilder<PassengerLoyaltyDtoOutputRulesTiersInner>();
  set tiers(ListBuilder<PassengerLoyaltyDtoOutputRulesTiersInner>? tiers) =>
      _$this._tiers = tiers;

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Builder() {
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3._defaults(this);
  }

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _earnUnit = $v.earnUnit;
      _pointValue = $v.pointValue;
      _minRedeemPoints = $v.minRedeemPoints;
      _pointExpiryMonths = $v.pointExpiryMonths;
      _voucherValidityDays = $v.voucherValidityDays;
      _tiers = $v.tiers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3 other) {
    _$v = other as _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3;
  }

  @override
  void update(
      void Function(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Builder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3 build() => _build();

  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3 _build() {
    _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3 _$result;
    try {
      _$result = _$v ??
          _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3._(
            earnUnit: BuiltValueNullFieldError.checkNotNull(earnUnit,
                r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3', 'earnUnit'),
            pointValue: BuiltValueNullFieldError.checkNotNull(
                pointValue,
                r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3',
                'pointValue'),
            minRedeemPoints: BuiltValueNullFieldError.checkNotNull(
                minRedeemPoints,
                r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3',
                'minRedeemPoints'),
            pointExpiryMonths: BuiltValueNullFieldError.checkNotNull(
                pointExpiryMonths,
                r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3',
                'pointExpiryMonths'),
            voucherValidityDays: BuiltValueNullFieldError.checkNotNull(
                voucherValidityDays,
                r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3',
                'voucherValidityDays'),
            tiers: tiers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tiers';
        tiers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3',
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
