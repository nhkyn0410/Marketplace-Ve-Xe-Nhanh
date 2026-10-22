//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_loyalty_dto_output_rules_tiers_inner.g.dart';

/// PassengerLoyaltyDtoOutputRulesTiersInner
///
/// Properties:
/// * [tier] 
/// * [minPoints] 
/// * [multiplierPercent] 
@BuiltValue()
abstract class PassengerLoyaltyDtoOutputRulesTiersInner implements Built<PassengerLoyaltyDtoOutputRulesTiersInner, PassengerLoyaltyDtoOutputRulesTiersInnerBuilder> {
  @BuiltValueField(wireName: r'tier')
  PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum get tier;
  // enum tierEnum {  BRONZE,  SILVER,  GOLD,  PLATINUM,  };

  @BuiltValueField(wireName: r'minPoints')
  int get minPoints;

  @BuiltValueField(wireName: r'multiplierPercent')
  int get multiplierPercent;

  PassengerLoyaltyDtoOutputRulesTiersInner._();

  factory PassengerLoyaltyDtoOutputRulesTiersInner([void updates(PassengerLoyaltyDtoOutputRulesTiersInnerBuilder b)]) = _$PassengerLoyaltyDtoOutputRulesTiersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerLoyaltyDtoOutputRulesTiersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerLoyaltyDtoOutputRulesTiersInner> get serializer => _$PassengerLoyaltyDtoOutputRulesTiersInnerSerializer();
}

class _$PassengerLoyaltyDtoOutputRulesTiersInnerSerializer implements PrimitiveSerializer<PassengerLoyaltyDtoOutputRulesTiersInner> {
  @override
  final Iterable<Type> types = const [PassengerLoyaltyDtoOutputRulesTiersInner, _$PassengerLoyaltyDtoOutputRulesTiersInner];

  @override
  final String wireName = r'PassengerLoyaltyDtoOutputRulesTiersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerLoyaltyDtoOutputRulesTiersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum),
    );
    yield r'minPoints';
    yield serializers.serialize(
      object.minPoints,
      specifiedType: const FullType(int),
    );
    yield r'multiplierPercent';
    yield serializers.serialize(
      object.multiplierPercent,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PassengerLoyaltyDtoOutputRulesTiersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PassengerLoyaltyDtoOutputRulesTiersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum),
          ) as PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum;
          result.tier = valueDes;
          break;
        case r'minPoints':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minPoints = valueDes;
          break;
        case r'multiplierPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.multiplierPercent = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PassengerLoyaltyDtoOutputRulesTiersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerLoyaltyDtoOutputRulesTiersInnerBuilder();
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


class PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BRONZE')
  static const PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum BRONZE = _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_BRONZE;
  @BuiltValueEnumConst(wireName: r'SILVER')
  static const PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum SILVER = _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_SILVER;
  @BuiltValueEnumConst(wireName: r'GOLD')
  static const PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum GOLD = _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_GOLD;
  @BuiltValueEnumConst(wireName: r'PLATINUM')
  static const PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum PLATINUM = _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnum_PLATINUM;

  static Serializer<PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum> get serializer => _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnumSerializer;

  const PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum._(String name): super(name);

  static BuiltSet<PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum> get values => _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnumValues;
  static PassengerLoyaltyDtoOutputRulesTiersInnerTierEnum valueOf(String name) => _$passengerLoyaltyDtoOutputRulesTiersInnerTierEnumValueOf(name);
}

