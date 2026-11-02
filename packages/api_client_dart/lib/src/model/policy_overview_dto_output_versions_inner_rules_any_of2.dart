//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'policy_overview_dto_output_versions_inner_rules_any_of2.g.dart';

/// PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2
///
/// Properties:
/// * [delayDays] 
/// * [channel] 
/// * [manualConfirmation] 
/// * [minimumAmount] 
@BuiltValue()
abstract class PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2 implements Built<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2, PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Builder> {
  @BuiltValueField(wireName: r'delayDays')
  int get delayDays;

  @BuiltValueField(wireName: r'channel')
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum get channel;
  // enum channelEnum {  BANK_TRANSFER,  };

  @BuiltValueField(wireName: r'manualConfirmation')
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum get manualConfirmation;
  // enum manualConfirmationEnum {  true,  };

  @BuiltValueField(wireName: r'minimumAmount')
  int? get minimumAmount;

  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2._();

  factory PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2([void updates(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Builder b)]) = _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2> get serializer => _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Serializer();
}

class _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Serializer implements PrimitiveSerializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2> {
  @override
  final Iterable<Type> types = const [PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2, _$PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2];

  @override
  final String wireName = r'PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'delayDays';
    yield serializers.serialize(
      object.delayDays,
      specifiedType: const FullType(int),
    );
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum),
    );
    yield r'manualConfirmation';
    yield serializers.serialize(
      object.manualConfirmation,
      specifiedType: const FullType(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum),
    );
    yield r'minimumAmount';
    yield object.minimumAmount == null ? null : serializers.serialize(
      object.minimumAmount,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'delayDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.delayDays = valueDes;
          break;
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum),
          ) as PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum;
          result.channel = valueDes;
          break;
        case r'manualConfirmation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum),
          ) as PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum;
          result.manualConfirmation = valueDes;
          break;
        case r'minimumAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.minimumAmount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2Builder();
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


class PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BANK_TRANSFER')
  static const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum BANK_TRANSFER = _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum_BANK_TRANSFER;

  static Serializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum> get serializer => _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnumSerializer;

  const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum._(String name): super(name);

  static BuiltSet<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum> get values => _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnumValues;
  static PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnum valueOf(String name) => _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ChannelEnumValueOf(name);
}

class PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum true_ = _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum_true_;

  static Serializer<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum> get serializer => _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnumSerializer;

  const PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum._(String name): super(name);

  static BuiltSet<PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum> get values => _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnumValues;
  static PolicyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnum valueOf(String name) => _$policyOverviewDtoOutputVersionsInnerRulesAnyOf2ManualConfirmationEnumValueOf(name);
}

