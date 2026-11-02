// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_loyalty_dto_output_rules_tiers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum
    _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_BRONZE =
    const PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum._('BRONZE');
const PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum
    _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_SILVER =
    const PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum._('SILVER');
const PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum
    _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_GOLD =
    const PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum._('GOLD');
const PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum
    _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_PLATINUM =
    const PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum._('PLATINUM');

PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum
    _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnumValueOf(String name) {
  switch (name) {
    case 'BRONZE':
      return _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_BRONZE;
    case 'SILVER':
      return _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_SILVER;
    case 'GOLD':
      return _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_GOLD;
    case 'PLATINUM':
      return _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_PLATINUM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum>
    _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnumValues = BuiltSet<
        PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum>(const <PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum>[
  _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_BRONZE,
  _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_SILVER,
  _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_GOLD,
  _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_PLATINUM,
]);

Serializer<PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum>
    _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnumSerializer =
    _$PassengerLoyaltyDtoOutputRulesTiersInnerTierEnumSerializer();

class _$PassengerLoyaltyDtoOutputRulesTiersInnerTierEnumSerializer
    implements
        PrimitiveSerializer<PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum> {
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
    PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum
  ];
  @override
  final String wireName = 'PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum';

  @override
  Object serialize(Serializers serializers,
          PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PassengerLoyaltyDtoOutputRulesTiersInner
    extends PassengerLoyaltyDtoOutputRulesTiersInner {
  @override
  final PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum tier;
  @override
  final int minPoints;
  @override
  final int multiplierPercent;

  factory _$PassengerLoyaltyDtoOutputRulesTiersInner(
          [void Function(PassengerLoyaltyDtoOutputRulesTiersInnerBuilder)?
              updates]) =>
      (PassengerLoyaltyDtoOutputRulesTiersInnerBuilder()..update(updates))
          ._build();

  _$PassengerLoyaltyDtoOutputRulesTiersInner._(
      {required this.tier,
      required this.minPoints,
      required this.multiplierPercent})
      : super._();
  @override
  PassengerLoyaltyDtoOutputRulesTiersInner rebuild(
          void Function(PassengerLoyaltyDtoOutputRulesTiersInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerLoyaltyDtoOutputRulesTiersInnerBuilder toBuilder() =>
      PassengerLoyaltyDtoOutputRulesTiersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerLoyaltyDtoOutputRulesTiersInner &&
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
            r'PassengerLoyaltyDtoOutputRulesTiersInner')
          ..add('tier', tier)
          ..add('minPoints', minPoints)
          ..add('multiplierPercent', multiplierPercent))
        .toString();
  }
}

class PassengerLoyaltyDtoOutputRulesTiersInnerBuilder
    implements
        Builder<PassengerLoyaltyDtoOutputRulesTiersInner,
            PassengerLoyaltyDtoOutputRulesTiersInnerBuilder> {
  _$PassengerLoyaltyDtoOutputRulesTiersInner? _$v;

  PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum? _tier;
  PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum? get tier => _$this._tier;
  set tier(PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum? tier) =>
      _$this._tier = tier;

  int? _minPoints;
  int? get minPoints => _$this._minPoints;
  set minPoints(int? minPoints) => _$this._minPoints = minPoints;

  int? _multiplierPercent;
  int? get multiplierPercent => _$this._multiplierPercent;
  set multiplierPercent(int? multiplierPercent) =>
      _$this._multiplierPercent = multiplierPercent;

  PassengerLoyaltyDtoOutputRulesTiersInnerBuilder() {
    PassengerLoyaltyDtoOutputRulesTiersInner._defaults(this);
  }

  PassengerLoyaltyDtoOutputRulesTiersInnerBuilder get _$this {
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
  void replace(PassengerLoyaltyDtoOutputRulesTiersInner other) {
    _$v = other as _$PassengerLoyaltyDtoOutputRulesTiersInner;
  }

  @override
  void update(
      void Function(PassengerLoyaltyDtoOutputRulesTiersInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerLoyaltyDtoOutputRulesTiersInner build() => _build();

  _$PassengerLoyaltyDtoOutputRulesTiersInner _build() {
    final _$result = _$v ??
        _$PassengerLoyaltyDtoOutputRulesTiersInner._(
          tier: BuiltValueNullFieldError.checkNotNull(
              tier, r'PassengerLoyaltyDtoOutputRulesTiersInner', 'tier'),
          minPoints: BuiltValueNullFieldError.checkNotNull(minPoints,
              r'PassengerLoyaltyDtoOutputRulesTiersInner', 'minPoints'),
          multiplierPercent: BuiltValueNullFieldError.checkNotNull(
              multiplierPercent,
              r'PassengerLoyaltyDtoOutputRulesTiersInner',
              'multiplierPercent'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
