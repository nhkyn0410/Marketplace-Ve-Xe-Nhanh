//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_loyalty_dto_output_next_tier.g.dart';

/// PassengerLoyaltyDtoOutputNextTier
///
/// Properties:
/// * [tier] 
/// * [minPoints] 
/// * [remaining] 
@BuiltValue()
abstract class PassengerLoyaltyDtoOutputNextTier implements Built<PassengerLoyaltyDtoOutputNextTier, PassengerLoyaltyDtoOutputNextTierBuilder> {
  @BuiltValueField(wireName: r'tier')
  PassengerLoyaltyDtoOutputNextTierTierEnum get tier;
  // enum tierEnum {  BRONZE,  SILVER,  GOLD,  PLATINUM,  };

  @BuiltValueField(wireName: r'minPoints')
  int get minPoints;

  @BuiltValueField(wireName: r'remaining')
  int get remaining;

  PassengerLoyaltyDtoOutputNextTier._();

  factory PassengerLoyaltyDtoOutputNextTier([void updates(PassengerLoyaltyDtoOutputNextTierBuilder b)]) = _$PassengerLoyaltyDtoOutputNextTier;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerLoyaltyDtoOutputNextTierBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerLoyaltyDtoOutputNextTier> get serializer => _$PassengerLoyaltyDtoOutputNextTierSerializer();
}

class _$PassengerLoyaltyDtoOutputNextTierSerializer implements PrimitiveSerializer<PassengerLoyaltyDtoOutputNextTier> {
  @override
  final Iterable<Type> types = const [PassengerLoyaltyDtoOutputNextTier, _$PassengerLoyaltyDtoOutputNextTier];

  @override
  final String wireName = r'PassengerLoyaltyDtoOutputNextTier';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerLoyaltyDtoOutputNextTier object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(PassengerLoyaltyDtoOutputNextTierTierEnum),
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
    PassengerLoyaltyDtoOutputNextTier object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PassengerLoyaltyDtoOutputNextTierBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PassengerLoyaltyDtoOutputNextTierTierEnum),
          ) as PassengerLoyaltyDtoOutputNextTierTierEnum;
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
  PassengerLoyaltyDtoOutputNextTier deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerLoyaltyDtoOutputNextTierBuilder();
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


class PassengerLoyaltyDtoOutputNextTierTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BRONZE')
  static const PassengerLoyaltyDtoOutputNextTierTierEnum BRONZE = _$passengerLoyaltyDtoOutputNextTierTierEnum_BRONZE;
  @BuiltValueEnumConst(wireName: r'SILVER')
  static const PassengerLoyaltyDtoOutputNextTierTierEnum SILVER = _$passengerLoyaltyDtoOutputNextTierTierEnum_SILVER;
  @BuiltValueEnumConst(wireName: r'GOLD')
  static const PassengerLoyaltyDtoOutputNextTierTierEnum GOLD = _$passengerLoyaltyDtoOutputNextTierTierEnum_GOLD;
  @BuiltValueEnumConst(wireName: r'PLATINUM')
  static const PassengerLoyaltyDtoOutputNextTierTierEnum PLATINUM = _$passengerLoyaltyDtoOutputNextTierTierEnum_PLATINUM;

  static Serializer<PassengerLoyaltyDtoOutputNextTierTierEnum> get serializer => _$passengerLoyaltyDtoOutputNextTierTierEnumSerializer;

  const PassengerLoyaltyDtoOutputNextTierTierEnum._(String name): super(name);

  static BuiltSet<PassengerLoyaltyDtoOutputNextTierTierEnum> get values => _$passengerLoyaltyDtoOutputNextTierTierEnumValues;
  static PassengerLoyaltyDtoOutputNextTierTierEnum valueOf(String name) => _$passengerLoyaltyDtoOutputNextTierTierEnumValueOf(name);
}

