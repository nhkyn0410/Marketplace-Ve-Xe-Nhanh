//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/policy_overview_dto_output_versions_inner_rules_any_of3.dart';
import 'package:api_client_dart/src/model/policy_overview_dto_output_versions_inner_rules_any_of.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/policy_overview_dto_output_versions_inner_rules_any_of1.dart';
import 'package:api_client_dart/src/model/policy_overview_dto_output_versions_inner_rules_any_of3_tiers_inner.dart';
import 'package:api_client_dart/src/model/policy_overview_dto_output_versions_inner_rules_any_of2.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/any_of.dart';

part 'policy_overview_dto_output_versions_inner_rules.g.dart';

/// PolicyOverviewDtoOutputVersionsInnerRules
///
/// Properties:
/// * [tiers] 
/// * [holdMinutes] 
/// * [delayDays] 
/// * [channel] 
/// * [manualConfirmation] 
/// * [minimumAmount] 
/// * [earnUnit] 
/// * [pointValue] 
/// * [minRedeemPoints] 
/// * [pointExpiryMonths] 
/// * [voucherValidityDays] 
@BuiltValue()
abstract class PolicyOverviewDtoOutputVersionsInnerRules implements Built<PolicyOverviewDtoOutputVersionsInnerRules, PolicyOverviewDtoOutputVersionsInnerRulesBuilder> {
  /// Any Of [PolicyOverviewDtoOutputVersionsInnerRulesAnyOf], [PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1], [PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2], [PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3]
  AnyOf get anyOf;

  PolicyOverviewDtoOutputVersionsInnerRules._();

  factory PolicyOverviewDtoOutputVersionsInnerRules([void updates(PolicyOverviewDtoOutputVersionsInnerRulesBuilder b)]) = _$PolicyOverviewDtoOutputVersionsInnerRules;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PolicyOverviewDtoOutputVersionsInnerRulesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PolicyOverviewDtoOutputVersionsInnerRules> get serializer => _$PolicyOverviewDtoOutputVersionsInnerRulesSerializer();
}

class _$PolicyOverviewDtoOutputVersionsInnerRulesSerializer implements PrimitiveSerializer<PolicyOverviewDtoOutputVersionsInnerRules> {
  @override
  final Iterable<Type> types = const [PolicyOverviewDtoOutputVersionsInnerRules, _$PolicyOverviewDtoOutputVersionsInnerRules];

  @override
  final String wireName = r'PolicyOverviewDtoOutputVersionsInnerRules';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PolicyOverviewDtoOutputVersionsInnerRules object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    PolicyOverviewDtoOutputVersionsInnerRules object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final anyOf = object.anyOf;
    return serializers.serialize(anyOf, specifiedType: FullType(AnyOf, anyOf.types.map((type) => FullType(type)).toList()))!;
  }

  @override
  PolicyOverviewDtoOutputVersionsInnerRules deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PolicyOverviewDtoOutputVersionsInnerRulesBuilder();
    Object? anyOfDataSrc;
    final targetType = const FullType(AnyOf, [FullType(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf), FullType(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1), FullType(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2), FullType(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf3), ]);
    anyOfDataSrc = serialized;
    result.anyOf = serializers.deserialize(anyOfDataSrc, specifiedType: targetType) as AnyOf;
    return result.build();
  }
}


class PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BANK_TRANSFER')
  static const PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum BANK_TRANSFER = _$policyOverviewDtoOutputVersionsInnerRulesChannelEnum_BANK_TRANSFER;

  static Serializer<PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum> get serializer => _$policyOverviewDtoOutputVersionsInnerRulesChannelEnumSerializer;

  const PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum._(String name): super(name);

  static BuiltSet<PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum> get values => _$policyOverviewDtoOutputVersionsInnerRulesChannelEnumValues;
  static PolicyOverviewDtoOutputVersionsInnerRulesChannelEnum valueOf(String name) => _$policyOverviewDtoOutputVersionsInnerRulesChannelEnumValueOf(name);
}

class PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum true_ = _$policyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum_true_;

  static Serializer<PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum> get serializer => _$policyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnumSerializer;

  const PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum._(String name): super(name);

  static BuiltSet<PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum> get values => _$policyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnumValues;
  static PolicyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnum valueOf(String name) => _$policyOverviewDtoOutputVersionsInnerRulesManualConfirmationEnumValueOf(name);
}

