// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_loyalty_dto_output_rules.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerLoyaltyDtoOutputRules extends PassengerLoyaltyDtoOutputRules {
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

  factory _$PassengerLoyaltyDtoOutputRules(
          [void Function(PassengerLoyaltyDtoOutputRulesBuilder)? updates]) =>
      (PassengerLoyaltyDtoOutputRulesBuilder()..update(updates))._build();

  _$PassengerLoyaltyDtoOutputRules._(
      {required this.earnUnit,
      required this.pointValue,
      required this.minRedeemPoints,
      required this.pointExpiryMonths,
      required this.voucherValidityDays,
      required this.tiers})
      : super._();
  @override
  PassengerLoyaltyDtoOutputRules rebuild(
          void Function(PassengerLoyaltyDtoOutputRulesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerLoyaltyDtoOutputRulesBuilder toBuilder() =>
      PassengerLoyaltyDtoOutputRulesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerLoyaltyDtoOutputRules &&
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
    return (newBuiltValueToStringHelper(r'PassengerLoyaltyDtoOutputRules')
          ..add('earnUnit', earnUnit)
          ..add('pointValue', pointValue)
          ..add('minRedeemPoints', minRedeemPoints)
          ..add('pointExpiryMonths', pointExpiryMonths)
          ..add('voucherValidityDays', voucherValidityDays)
          ..add('tiers', tiers))
        .toString();
  }
}

class PassengerLoyaltyDtoOutputRulesBuilder
    implements
        Builder<PassengerLoyaltyDtoOutputRules,
            PassengerLoyaltyDtoOutputRulesBuilder> {
  _$PassengerLoyaltyDtoOutputRules? _$v;

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

  PassengerLoyaltyDtoOutputRulesBuilder() {
    PassengerLoyaltyDtoOutputRules._defaults(this);
  }

  PassengerLoyaltyDtoOutputRulesBuilder get _$this {
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
  void replace(PassengerLoyaltyDtoOutputRules other) {
    _$v = other as _$PassengerLoyaltyDtoOutputRules;
  }

  @override
  void update(void Function(PassengerLoyaltyDtoOutputRulesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerLoyaltyDtoOutputRules build() => _build();

  _$PassengerLoyaltyDtoOutputRules _build() {
    _$PassengerLoyaltyDtoOutputRules _$result;
    try {
      _$result = _$v ??
          _$PassengerLoyaltyDtoOutputRules._(
            earnUnit: BuiltValueNullFieldError.checkNotNull(
                earnUnit, r'PassengerLoyaltyDtoOutputRules', 'earnUnit'),
            pointValue: BuiltValueNullFieldError.checkNotNull(
                pointValue, r'PassengerLoyaltyDtoOutputRules', 'pointValue'),
            minRedeemPoints: BuiltValueNullFieldError.checkNotNull(
                minRedeemPoints,
                r'PassengerLoyaltyDtoOutputRules',
                'minRedeemPoints'),
            pointExpiryMonths: BuiltValueNullFieldError.checkNotNull(
                pointExpiryMonths,
                r'PassengerLoyaltyDtoOutputRules',
                'pointExpiryMonths'),
            voucherValidityDays: BuiltValueNullFieldError.checkNotNull(
                voucherValidityDays,
                r'PassengerLoyaltyDtoOutputRules',
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
            r'PassengerLoyaltyDtoOutputRules', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
