//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'policy_overview_dto_output_versions_inner_rules_any_of3_tiers_inner.g.dart';

/// PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner
///
/// Properties:
/// * [tier] 
/// * [minPoints] 
/// * [multiplierPercent] 
@BuiltValue()
abstract class PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner implements Built<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner, PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerBuilder> {
  @BuiltValueField(wireName: r'tier')
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum get tier;
  // enum tierEnum {  BRONZE,  SILVER,  GOLD,  PLATINUM,  };

  @BuiltValueField(wireName: r'minPoints')
  int get minPoints;

  @BuiltValueField(wireName: r'multiplierPercent')
  int get multiplierPercent;

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner._();

  factory PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner([void updates(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerBuilder b)]) = _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner> get serializer => _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerSerializer();
}

class _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerSerializer implements PrimitiveSerializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner> {
  @override
  final Iterable<Type> types = const [PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner, _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner];

  @override
  final String wireName = r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum),
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
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum),
          ) as PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum;
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
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerBuilder();
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


class PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BRONZE')
  static const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum BRONZE = _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_BRONZE;
  @BuiltValueEnumConst(wireName: r'SILVER')
  static const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum SILVER = _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_SILVER;
  @BuiltValueEnumConst(wireName: r'GOLD')
  static const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum GOLD = _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_GOLD;
  @BuiltValueEnumConst(wireName: r'PLATINUM')
  static const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum PLATINUM = _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum_PLATINUM;

  static Serializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum> get serializer => _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnumSerializer;

  const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum._(String name): super(name);

  static BuiltSet<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum> get values => _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnumValues;
  static PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnum valueOf(String name) => _$policyOverviewDtoOutputVersionsInnerRulesAnyOf3TiersInnerTierEnumValueOf(name);
}

