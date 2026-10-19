// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_member_dto_output_next_tier.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LoyaltyMemberDtoOutputNextTierTierEnum
    _$loyaltyMemberDtoOutputNextTierTierEnum_BRONZE =
    const LoyaltyMemberDtoOutputNextTierTierEnum._('BRONZE');
const LoyaltyMemberDtoOutputNextTierTierEnum
    _$loyaltyMemberDtoOutputNextTierTierEnum_SILVER =
    const LoyaltyMemberDtoOutputNextTierTierEnum._('SILVER');
const LoyaltyMemberDtoOutputNextTierTierEnum
    _$loyaltyMemberDtoOutputNextTierTierEnum_GOLD =
    const LoyaltyMemberDtoOutputNextTierTierEnum._('GOLD');
const LoyaltyMemberDtoOutputNextTierTierEnum
    _$loyaltyMemberDtoOutputNextTierTierEnum_PLATINUM =
    const LoyaltyMemberDtoOutputNextTierTierEnum._('PLATINUM');

LoyaltyMemberDtoOutputNextTierTierEnum
    _$loyaltyMemberDtoOutputNextTierTierEnumValueOf(String name) {
  switch (name) {
    case 'BRONZE':
      return _$loyaltyMemberDtoOutputNextTierTierEnum_BRONZE;
    case 'SILVER':
      return _$loyaltyMemberDtoOutputNextTierTierEnum_SILVER;
    case 'GOLD':
      return _$loyaltyMemberDtoOutputNextTierTierEnum_GOLD;
    case 'PLATINUM':
      return _$loyaltyMemberDtoOutputNextTierTierEnum_PLATINUM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LoyaltyMemberDtoOutputNextTierTierEnum>
    _$loyaltyMemberDtoOutputNextTierTierEnumValues = BuiltSet<
        LoyaltyMemberDtoOutputNextTierTierEnum>(const <LoyaltyMemberDtoOutputNextTierTierEnum>[
  _$loyaltyMemberDtoOutputNextTierTierEnum_BRONZE,
  _$loyaltyMemberDtoOutputNextTierTierEnum_SILVER,
  _$loyaltyMemberDtoOutputNextTierTierEnum_GOLD,
  _$loyaltyMemberDtoOutputNextTierTierEnum_PLATINUM,
]);

Serializer<LoyaltyMemberDtoOutputNextTierTierEnum>
    _$loyaltyMemberDtoOutputNextTierTierEnumSerializer =
    _$LoyaltyMemberDtoOutputNextTierTierEnumSerializer();

class _$LoyaltyMemberDtoOutputNextTierTierEnumSerializer
    implements PrimitiveSerializer<LoyaltyMemberDtoOutputNextTierTierEnum> {
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
    LoyaltyMemberDtoOutputNextTierTierEnum
  ];
  @override
  final String wireName = 'LoyaltyMemberDtoOutputNextTierTierEnum';

  @override
  Object serialize(Serializers serializers,
          LoyaltyMemberDtoOutputNextTierTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LoyaltyMemberDtoOutputNextTierTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LoyaltyMemberDtoOutputNextTierTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LoyaltyMemberDtoOutputNextTier extends LoyaltyMemberDtoOutputNextTier {
  @override
  final LoyaltyMemberDtoOutputNextTierTierEnum tier;
  @override
  final int minPoints;
  @override
  final int remaining;

  factory _$LoyaltyMemberDtoOutputNextTier(
          [void Function(LoyaltyMemberDtoOutputNextTierBuilder)? updates]) =>
      (LoyaltyMemberDtoOutputNextTierBuilder()..update(updates))._build();

  _$LoyaltyMemberDtoOutputNextTier._(
      {required this.tier, required this.minPoints, required this.remaining})
      : super._();
  @override
  LoyaltyMemberDtoOutputNextTier rebuild(
          void Function(LoyaltyMemberDtoOutputNextTierBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoyaltyMemberDtoOutputNextTierBuilder toBuilder() =>
      LoyaltyMemberDtoOutputNextTierBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoyaltyMemberDtoOutputNextTier &&
        tier == other.tier &&
        minPoints == other.minPoints &&
        remaining == other.remaining;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jc(_$hash, minPoints.hashCode);
    _$hash = $jc(_$hash, remaining.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoyaltyMemberDtoOutputNextTier')
          ..add('tier', tier)
          ..add('minPoints', minPoints)
          ..add('remaining', remaining))
        .toString();
  }
}

class LoyaltyMemberDtoOutputNextTierBuilder
    implements
        Builder<LoyaltyMemberDtoOutputNextTier,
            LoyaltyMemberDtoOutputNextTierBuilder> {
  _$LoyaltyMemberDtoOutputNextTier? _$v;

  LoyaltyMemberDtoOutputNextTierTierEnum? _tier;
  LoyaltyMemberDtoOutputNextTierTierEnum? get tier => _$this._tier;
  set tier(LoyaltyMemberDtoOutputNextTierTierEnum? tier) => _$this._tier = tier;

  int? _minPoints;
  int? get minPoints => _$this._minPoints;
  set minPoints(int? minPoints) => _$this._minPoints = minPoints;

  int? _remaining;
  int? get remaining => _$this._remaining;
  set remaining(int? remaining) => _$this._remaining = remaining;

  LoyaltyMemberDtoOutputNextTierBuilder() {
    LoyaltyMemberDtoOutputNextTier._defaults(this);
  }

  LoyaltyMemberDtoOutputNextTierBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tier = $v.tier;
      _minPoints = $v.minPoints;
      _remaining = $v.remaining;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoyaltyMemberDtoOutputNextTier other) {
    _$v = other as _$LoyaltyMemberDtoOutputNextTier;
  }

  @override
  void update(void Function(LoyaltyMemberDtoOutputNextTierBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoyaltyMemberDtoOutputNextTier build() => _build();

  _$LoyaltyMemberDtoOutputNextTier _build() {
    final _$result = _$v ??
        _$LoyaltyMemberDtoOutputNextTier._(
          tier: BuiltValueNullFieldError.checkNotNull(
              tier, r'LoyaltyMemberDtoOutputNextTier', 'tier'),
          minPoints: BuiltValueNullFieldError.checkNotNull(
              minPoints, r'LoyaltyMemberDtoOutputNextTier', 'minPoints'),
          remaining: BuiltValueNullFieldError.checkNotNull(
              remaining, r'LoyaltyMemberDtoOutputNextTier', 'remaining'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
