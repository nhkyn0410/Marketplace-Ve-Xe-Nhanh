//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'policy_overview_dto_output_versions_inner_rules_any_of1.g.dart';

/// PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1
///
/// Properties:
/// * [holdMinutes] 
@BuiltValue()
abstract class PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1 implements Built<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1, PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Builder> {
  @BuiltValueField(wireName: r'holdMinutes')
  int get holdMinutes;

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1._();

  factory PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1([void updates(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Builder b)]) = _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1> get serializer => _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Serializer();
}

class _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Serializer implements PrimitiveSerializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1> {
  @override
  final Iterable<Type> types = const [PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1, _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1];

  @override
  final String wireName = r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'holdMinutes';
    yield serializers.serialize(
      object.holdMinutes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'holdMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.holdMinutes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PolicyOverviewDtoOutputVersionsInnerRulesAnyOf1Builder();
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


