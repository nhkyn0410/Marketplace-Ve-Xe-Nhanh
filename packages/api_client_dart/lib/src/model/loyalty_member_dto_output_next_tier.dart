//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'loyalty_member_dto_output_next_tier.g.dart';

/// LoyaltyMemberDtoOutputNextTier
///
/// Properties:
/// * [tier] 
/// * [minPoints] 
/// * [remaining] 
@BuiltValue()
abstract class LoyaltyMemberDtoOutputNextTier implements Built<LoyaltyMemberDtoOutputNextTier, LoyaltyMemberDtoOutputNextTierBuilder> {
  @BuiltValueField(wireName: r'tier')
  LoyaltyMemberDtoOutputNextTierTierEnum get tier;
  // enum tierEnum {  BRONZE,  SILVER,  GOLD,  PLATINUM,  };

  @BuiltValueField(wireName: r'minPoints')
  int get minPoints;

  @BuiltValueField(wireName: r'remaining')
  int get remaining;

  LoyaltyMemberDtoOutputNextTier._();

  factory LoyaltyMemberDtoOutputNextTier([void updates(LoyaltyMemberDtoOutputNextTierBuilder b)]) = _$LoyaltyMemberDtoOutputNextTier;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoyaltyMemberDtoOutputNextTierBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoyaltyMemberDtoOutputNextTier> get serializer => _$LoyaltyMemberDtoOutputNextTierSerializer();
}

class _$LoyaltyMemberDtoOutputNextTierSerializer implements PrimitiveSerializer<LoyaltyMemberDtoOutputNextTier> {
  @override
  final Iterable<Type> types = const [LoyaltyMemberDtoOutputNextTier, _$LoyaltyMemberDtoOutputNextTier];

  @override
  final String wireName = r'LoyaltyMemberDtoOutputNextTier';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoyaltyMemberDtoOutputNextTier object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(LoyaltyMemberDtoOutputNextTierTierEnum),
    );
    yield r'minPoints';
    yield serializers.serialize(
      object.minPoints,
      specifiedType: const FullType(int),
    );
    yield r'remaining';
    yield serializers.serialize(
      object.remaining,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LoyaltyMemberDtoOutputNextTier object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoyaltyMemberDtoOutputNextTierBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LoyaltyMemberDtoOutputNextTierTierEnum),
          ) as LoyaltyMemberDtoOutputNextTierTierEnum;
          result.tier = valueDes;
          break;
        case r'minPoints':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minPoints = valueDes;
          break;
        case r'remaining':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.remaining = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoyaltyMemberDtoOutputNextTier deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoyaltyMemberDtoOutputNextTierBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


class LoyaltyMemberDtoOutputNextTierTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BRONZE')
  static const LoyaltyMemberDtoOutputNextTierTierEnum BRONZE = _$loyaltyMemberDtoOutputNextTierTierEnum_BRONZE;
  @BuiltValueEnumConst(wireName: r'SILVER')
  static const LoyaltyMemberDtoOutputNextTierTierEnum SILVER = _$loyaltyMemberDtoOutputNextTierTierEnum_SILVER;
  @BuiltValueEnumConst(wireName: r'GOLD')
  static const LoyaltyMemberDtoOutputNextTierTierEnum GOLD = _$loyaltyMemberDtoOutputNextTierTierEnum_GOLD;
  @BuiltValueEnumConst(wireName: r'PLATINUM')
  static const LoyaltyMemberDtoOutputNextTierTierEnum PLATINUM = _$loyaltyMemberDtoOutputNextTierTierEnum_PLATINUM;

  static Serializer<LoyaltyMemberDtoOutputNextTierTierEnum> get serializer => _$loyaltyMemberDtoOutputNextTierTierEnumSerializer;

  const LoyaltyMemberDtoOutputNextTierTierEnum._(String name): super(name);

  static BuiltSet<LoyaltyMemberDtoOutputNextTierTierEnum> get values => _$loyaltyMemberDtoOutputNextTierTierEnumValues;
  static LoyaltyMemberDtoOutputNextTierTierEnum valueOf(String name) => _$loyaltyMemberDtoOutputNextTierTierEnumValueOf(name);
}

