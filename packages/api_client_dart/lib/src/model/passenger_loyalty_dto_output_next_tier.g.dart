// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_loyalty_dto_output_next_tier.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PassengerLoyaltyDtoOutputNextTierTierEnum
    _$passengerLoyaltyDtoOutputNextTierTierEnum_BRONZE =
    const PassengerLoyaltyDtoOutputNextTierTierEnum._('BRONZE');
const PassengerLoyaltyDtoOutputNextTierTierEnum
    _$passengerLoyaltyDtoOutputNextTierTierEnum_SILVER =
    const PassengerLoyaltyDtoOutputNextTierTierEnum._('SILVER');
const PassengerLoyaltyDtoOutputNextTierTierEnum
    _$passengerLoyaltyDtoOutputNextTierTierEnum_GOLD =
    const PassengerLoyaltyDtoOutputNextTierTierEnum._('GOLD');
const PassengerLoyaltyDtoOutputNextTierTierEnum
    _$passengerLoyaltyDtoOutputNextTierTierEnum_PLATINUM =
    const PassengerLoyaltyDtoOutputNextTierTierEnum._('PLATINUM');

PassengerLoyaltyDtoOutputNextTierTierEnum
    _$passengerLoyaltyDtoOutputNextTierTierEnumValueOf(String name) {
  switch (name) {
    case 'BRONZE':
      return _$passengerLoyaltyDtoOutputNextTierTierEnum_BRONZE;
    case 'SILVER':
      return _$passengerLoyaltyDtoOutputNextTierTierEnum_SILVER;
    case 'GOLD':
      return _$passengerLoyaltyDtoOutputNextTierTierEnum_GOLD;
    case 'PLATINUM':
      return _$passengerLoyaltyDtoOutputNextTierTierEnum_PLATINUM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PassengerLoyaltyDtoOutputNextTierTierEnum>
    _$passengerLoyaltyDtoOutputNextTierTierEnumValues = BuiltSet<
        PassengerLoyaltyDtoOutputNextTierTierEnum>(const <PassengerLoyaltyDtoOutputNextTierTierEnum>[
  _$passengerLoyaltyDtoOutputNextTierTierEnum_BRONZE,
  _$passengerLoyaltyDtoOutputNextTierTierEnum_SILVER,
  _$passengerLoyaltyDtoOutputNextTierTierEnum_GOLD,
  _$passengerLoyaltyDtoOutputNextTierTierEnum_PLATINUM,
]);

Serializer<PassengerLoyaltyDtoOutputNextTierTierEnum>
    _$passengerLoyaltyDtoOutputNextTierTierEnumSerializer =
    _$PassengerLoyaltyDtoOutputNextTierTierEnumSerializer();

class _$PassengerLoyaltyDtoOutputNextTierTierEnumSerializer
    implements PrimitiveSerializer<PassengerLoyaltyDtoOutputNextTierTierEnum> {
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
    PassengerLoyaltyDtoOutputNextTierTierEnum
  ];
  @override
  final String wireName = 'PassengerLoyaltyDtoOutputNextTierTierEnum';

  @override
  Object serialize(Serializers serializers,
          PassengerLoyaltyDtoOutputNextTierTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PassengerLoyaltyDtoOutputNextTierTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PassengerLoyaltyDtoOutputNextTierTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PassengerLoyaltyDtoOutputNextTier
    extends PassengerLoyaltyDtoOutputNextTier {
  @override
  final PassengerLoyaltyDtoOutputNextTierTierEnum tier;
  @override
  final int minPoints;
  @override
  final int remaining;

  factory _$PassengerLoyaltyDtoOutputNextTier(
          [void Function(PassengerLoyaltyDtoOutputNextTierBuilder)? updates]) =>
      (PassengerLoyaltyDtoOutputNextTierBuilder()..update(updates))._build();

  _$PassengerLoyaltyDtoOutputNextTier._(
      {required this.tier, required this.minPoints, required this.remaining})
      : super._();
  @override
  PassengerLoyaltyDtoOutputNextTier rebuild(
          void Function(PassengerLoyaltyDtoOutputNextTierBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerLoyaltyDtoOutputNextTierBuilder toBuilder() =>
      PassengerLoyaltyDtoOutputNextTierBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerLoyaltyDtoOutputNextTier &&
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
    return (newBuiltValueToStringHelper(r'PassengerLoyaltyDtoOutputNextTier')
          ..add('tier', tier)
          ..add('minPoints', minPoints)
          ..add('remaining', remaining))
        .toString();
  }
}

class PassengerLoyaltyDtoOutputNextTierBuilder
    implements
        Builder<PassengerLoyaltyDtoOutputNextTier,
            PassengerLoyaltyDtoOutputNextTierBuilder> {
  _$PassengerLoyaltyDtoOutputNextTier? _$v;

  PassengerLoyaltyDtoOutputNextTierTierEnum? _tier;
  PassengerLoyaltyDtoOutputNextTierTierEnum? get tier => _$this._tier;
  set tier(PassengerLoyaltyDtoOutputNextTierTierEnum? tier) =>
      _$this._tier = tier;

  int? _minPoints;
  int? get minPoints => _$this._minPoints;
  set minPoints(int? minPoints) => _$this._minPoints = minPoints;

  int? _remaining;
  int? get remaining => _$this._remaining;
  set remaining(int? remaining) => _$this._remaining = remaining;

  PassengerLoyaltyDtoOutputNextTierBuilder() {
    PassengerLoyaltyDtoOutputNextTier._defaults(this);
  }

  PassengerLoyaltyDtoOutputNextTierBuilder get _$this {
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
  void replace(PassengerLoyaltyDtoOutputNextTier other) {
    _$v = other as _$PassengerLoyaltyDtoOutputNextTier;
  }

  @override
  void update(
      void Function(PassengerLoyaltyDtoOutputNextTierBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerLoyaltyDtoOutputNextTier build() => _build();

  _$PassengerLoyaltyDtoOutputNextTier _build() {
    final _$result = _$v ??
        _$PassengerLoyaltyDtoOutputNextTier._(
          tier: BuiltValueNullFieldError.checkNotNull(
              tier, r'PassengerLoyaltyDtoOutputNextTier', 'tier'),
          minPoints: BuiltValueNullFieldError.checkNotNull(
              minPoints, r'PassengerLoyaltyDtoOutputNextTier', 'minPoints'),
          remaining: BuiltValueNullFieldError.checkNotNull(
              remaining, r'PassengerLoyaltyDtoOutputNextTier', 'remaining'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
