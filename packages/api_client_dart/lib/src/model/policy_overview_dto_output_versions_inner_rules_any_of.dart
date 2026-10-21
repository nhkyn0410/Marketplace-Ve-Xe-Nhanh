//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/policy_overview_dto_output_versions_inner_rules_any_of_tiers_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'policy_overview_dto_output_versions_inner_rules_any_of.g.dart';

/// PolicyOverviewDtoOutputVersionsInnerRulesAnyOf
///
/// Properties:
/// * [tiers] 
@BuiltValue()
abstract class PolicyOverviewDtoOutputVersionsInnerRulesAnyOf implements Built<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf, PolicyOverviewDtoOutputVersionsInnerRulesAnyOfBuilder> {
  @BuiltValueField(wireName: r'tiers')
  BuiltList<PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner> get tiers;

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf._();

  factory PolicyOverviewDtoOutputVersionsInnerRulesAnyOf([void updates(PolicyOverviewDtoOutputVersionsInnerRulesAnyOfBuilder b)]) = _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PolicyOverviewDtoOutputVersionsInnerRulesAnyOfBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf> get serializer => _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOfSerializer();
}

class _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOfSerializer implements PrimitiveSerializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf> {
  @override
  final Iterable<Type> types = const [PolicyOverviewDtoOutputVersionsInnerRulesAnyOf, _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf];

  @override
  final String wireName = r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tiers';
    yield serializers.serialize(
      object.tiers,
      specifiedType: const FullType(BuiltList, [FullType(PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PolicyOverviewDtoOutputVersionsInnerRulesAnyOfBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tiers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner)]),
          ) as BuiltList<PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner>;
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
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PolicyOverviewDtoOutputVersionsInnerRulesAnyOfBuilder();
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


