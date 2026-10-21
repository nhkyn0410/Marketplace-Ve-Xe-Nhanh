//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/passenger_loyalty_dto_output_rules_tiers_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'policy_overview_dto_output_versions_inner_rules_any_of3.g.dart';

/// PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3
///
/// Properties:
/// * [earnUnit]
/// * [pointValue]
/// * [minRedeemPoints]
/// * [pointExpiryMonths]
/// * [voucherValidityDays]
/// * [tiers]
@BuiltValue()
abstract class PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3
    implements
        Built<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3,
            PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Builder> {
  @BuiltValueField(wireName: r'earnUnit')
  int get earnUnit;

  @BuiltValueField(wireName: r'pointValue')
  int get pointValue;

  @BuiltValueField(wireName: r'minRedeemPoints')
  int get minRedeemPoints;

  @BuiltValueField(wireName: r'pointExpiryMonths')
  int get pointExpiryMonths;

  @BuiltValueField(wireName: r'voucherValidityDays')
  int get voucherValidityDays;

  @BuiltValueField(wireName: r'tiers')
  BuiltList<PassengerLoyaltyDtoOutputRulesTiersInner> get tiers;

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3._();

  factory PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3(
          [void updates(
              PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Builder b)]) =
      _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
          PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Builder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3>
      get serializer =>
          _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Serializer();
}

class _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Serializer
    implements
        PrimitiveSerializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3> {
  @override
  final Iterable<Type> types = const [
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3,
    _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3
  ];

  @override
  final String wireName = r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'earnUnit';
    yield serializers.serialize(
      object.earnUnit,
      specifiedType: const FullType(int),
    );
    yield r'pointValue';
    yield serializers.serialize(
      object.pointValue,
      specifiedType: const FullType(int),
    );
    yield r'minRedeemPoints';
    yield serializers.serialize(
      object.minRedeemPoints,
      specifiedType: const FullType(int),
    );
    yield r'pointExpiryMonths';
    yield serializers.serialize(
      object.pointExpiryMonths,
      specifiedType: const FullType(int),
    );
    yield r'voucherValidityDays';
    yield serializers.serialize(
      object.voucherValidityDays,
      specifiedType: const FullType(int),
    );
    yield r'tiers';
    yield serializers.serialize(
      object.tiers,
      specifiedType: const FullType(
          BuiltList, [FullType(PassengerLoyaltyDtoOutputRulesTiersInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'earnUnit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.earnUnit = valueDes;
          break;
        case r'pointValue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pointValue = valueDes;
          break;
        case r'minRedeemPoints':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minRedeemPoints = valueDes;
          break;
        case r'pointExpiryMonths':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pointExpiryMonths = valueDes;
          break;
        case r'voucherValidityDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.voucherValidityDays = valueDes;
          break;
        case r'tiers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(PassengerLoyaltyDtoOutputRulesTiersInner)]),
          ) as BuiltList<PassengerLoyaltyDtoOutputRulesTiersInner>;
          result.tiers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3Builder();
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
