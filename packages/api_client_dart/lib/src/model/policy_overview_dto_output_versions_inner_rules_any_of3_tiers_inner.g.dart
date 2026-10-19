// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_overview_dto_output_versions_inner_rules_any_of3_tiers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum
    _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_BRONZE =
    const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum._(
        'BRONZE');
const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum
    _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_SILVER =
    const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum._(
        'SILVER');
const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum
    _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_GOLD =
    const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum._(
        'GOLD');
const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum
    _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_PLATINUM =
    const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum._(
        'PLATINUM');

PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum
    _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnumValueOf(
        String name) {
  switch (name) {
    case 'BRONZE':
      return _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_BRONZE;
    case 'SILVER':
      return _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_SILVER;
    case 'GOLD':
      return _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_GOLD;
    case 'PLATINUM':
      return _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_PLATINUM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<
        PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum>
    _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnumValues =
    BuiltSet<
        PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum>(const <PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum>[
  _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_BRONZE,
  _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_SILVER,
  _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_GOLD,
  _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_PLATINUM,
]);

Serializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum>
    _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnumSerializer =
    _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnumSerializer();

class _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnumSerializer
    implements
        PrimitiveSerializer<
            PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BRONZE': 'BRONZE',
    'SILVER': 'SILVER',
    'GOLD': 'GOLD',
    'PLATINUM': 'PLATINUM',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BRONZE': 'BRONZE',
    'SILVER': 'SILVER',
    'GOLD': 'GOLD',
    'PLATINUM': 'PLATINUM',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum
  ];
  @override
  final String wireName =
      'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum';

  @override
  Object serialize(
          Serializers serializers,
          PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum
              object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner
    extends PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner {
  @override
  final PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum tier;
  @override
  final int minPoints;
  @override
  final int multiplierPercent;

  factory _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner(
          [void Function(
                  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerBuilder)?
              updates]) =>
      (PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerBuilder()
            ..update(updates))
          ._build();

  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner._(
      {required this.tier,
      required this.minPoints,
      required this.multiplierPercent})
      : super._();
  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner rebuild(
          void Function(
                  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerBuilder
      toBuilder() =>
          PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerBuilder()
            ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner &&
        tier == other.tier &&
        minPoints == other.minPoints &&
        multiplierPercent == other.multiplierPercent;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jc(_$hash, minPoints.hashCode);
    _$hash = $jc(_$hash, multiplierPercent.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner')
          ..add('tier', tier)
          ..add('minPoints', minPoints)
          ..add('multiplierPercent', multiplierPercent))
        .toString();
  }
}

class PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerBuilder
    implements
        Builder<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner,
            PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerBuilder> {
  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner? _$v;

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum? _tier;
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum? get tier =>
      _$this._tier;
  set tier(
          PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum?
              tier) =>
      _$this._tier = tier;

  int? _minPoints;
  int? get minPoints => _$this._minPoints;
  set minPoints(int? minPoints) => _$this._minPoints = minPoints;

  int? _multiplierPercent;
  int? get multiplierPercent => _$this._multiplierPercent;
  set multiplierPercent(int? multiplierPercent) =>
      _$this._multiplierPercent = multiplierPercent;

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerBuilder() {
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner._defaults(this);
  }

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tier = $v.tier;
      _minPoints = $v.minPoints;
      _multiplierPercent = $v.multiplierPercent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
      PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner other) {
    _$v = other as _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner;
  }

  @override
  void update(
      void Function(
              PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner build() => _build();

  _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner _build() {
    final _$result = _$v ??
        _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner._(
          tier: BuiltValueNullFieldError.checkNotNull(
              tier,
              r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner',
              'tier'),
          minPoints: BuiltValueNullFieldError.checkNotNull(
              minPoints,
              r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner',
              'minPoints'),
          multiplierPercent: BuiltValueNullFieldError.checkNotNull(
              multiplierPercent,
              r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner',
              'multiplierPercent'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
