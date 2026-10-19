//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'policy_overview_dto_output_versions_inner_rules_any_of_tiers_inner.g.dart';

/// PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner
///
/// Properties:
/// * [minHoursBefore] 
/// * [refundPercent] 
@BuiltValue()
abstract class PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner implements Built<PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner, PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerBuilder> {
  @BuiltValueField(wireName: r'minHoursBefore')
  int get minHoursBefore;

  @BuiltValueField(wireName: r'refundPercent')
  int get refundPercent;

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner._();

  factory PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner([void updates(PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerBuilder b)]) = _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner> get serializer => _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerSerializer();
}

class _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerSerializer implements PrimitiveSerializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner> {
  @override
  final Iterable<Type> types = const [PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner, _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner];

  @override
  final String wireName = r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'minHoursBefore';
    yield serializers.serialize(
      object.minHoursBefore,
      specifiedType: const FullType(int),
    );
    yield r'refundPercent';
    yield serializers.serialize(
      object.refundPercent,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'minHoursBefore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minHoursBefore = valueDes;
          break;
        case r'refundPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundPercent = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PolicyOverviewDtoOutputVersionsInnerRulesAnyOfTiersInnerBuilder();
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


