//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/policy_overview_dto_output_versions_inner.dart';
import 'package:api_client_dart/src/model/policy_overview_dto_output_overrides_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'policy_overview_dto_output.g.dart';

/// PolicyOverviewDtoOutput
///
/// Properties:
/// * [type] 
/// * [operatorId] 
/// * [operatorName] 
/// * [versions] 
/// * [activeOperatorCount] 
/// * [overrides] 
@BuiltValue()
abstract class PolicyOverviewDtoOutput implements Built<PolicyOverviewDtoOutput, PolicyOverviewDtoOutputBuilder> {
  @BuiltValueField(wireName: r'type')
  PolicyOverviewDtoOutputTypeEnum get type;
  // enum typeEnum {  CANCELLATION,  SEAT_HOLD,  PAYOUT,  LOYALTY,  };

  @BuiltValueField(wireName: r'operatorId')
  String? get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String? get operatorName;

  @BuiltValueField(wireName: r'versions')
  BuiltList<PolicyOverviewDtoOutputVersionsInner> get versions;

  @BuiltValueField(wireName: r'activeOperatorCount')
  int get activeOperatorCount;

  @BuiltValueField(wireName: r'overrides')
  BuiltList<PolicyOverviewDtoOutputOverridesInner> get overrides;

  PolicyOverviewDtoOutput._();

  factory PolicyOverviewDtoOutput([void updates(PolicyOverviewDtoOutputBuilder b)]) = _$PolicyOverviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PolicyOverviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PolicyOverviewDtoOutput> get serializer => _$PolicyOverviewDtoOutputSerializer();
}

class _$PolicyOverviewDtoOutputSerializer implements PrimitiveSerializer<PolicyOverviewDtoOutput> {
  @override
  final Iterable<Type> types = const [PolicyOverviewDtoOutput, _$PolicyOverviewDtoOutput];

  @override
  final String wireName = r'PolicyOverviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PolicyOverviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(PolicyOverviewDtoOutputTypeEnum),
    );
    yield r'operatorId';
    yield object.operatorId == null ? null : serializers.serialize(
      object.operatorId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'operatorName';
    yield object.operatorName == null ? null : serializers.serialize(
      object.operatorName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'versions';
    yield serializers.serialize(
      object.versions,
      specifiedType: const FullType(BuiltList, [FullType(PolicyOverviewDtoOutputVersionsInner)]),
    );
    yield r'activeOperatorCount';
    yield serializers.serialize(
      object.activeOperatorCount,
      specifiedType: const FullType(int),
    );
    yield r'overrides';
    yield serializers.serialize(
      object.overrides,
      specifiedType: const FullType(BuiltList, [FullType(PolicyOverviewDtoOutputOverridesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PolicyOverviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PolicyOverviewDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PolicyOverviewDtoOutputTypeEnum),
          ) as PolicyOverviewDtoOutputTypeEnum;
          result.type = valueDes;
          break;
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.operatorId = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.operatorName = valueDes;
          break;
        case r'versions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PolicyOverviewDtoOutputVersionsInner)]),
          ) as BuiltList<PolicyOverviewDtoOutputVersionsInner>;
          result.versions.replace(valueDes);
          break;
        case r'activeOperatorCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.activeOperatorCount = valueDes;
          break;
        case r'overrides':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PolicyOverviewDtoOutputOverridesInner)]),
          ) as BuiltList<PolicyOverviewDtoOutputOverridesInner>;
          result.overrides.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PolicyOverviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PolicyOverviewDtoOutputBuilder();
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


class PolicyOverviewDtoOutputTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CANCELLATION')
  static const PolicyOverviewDtoOutputTypeEnum CANCELLATION = _$policyOverviewDtoOutputTypeEnum_CANCELLATION;
  @BuiltValueEnumConst(wireName: r'SEAT_HOLD')
  static const PolicyOverviewDtoOutputTypeEnum SEAT_HOLD = _$policyOverviewDtoOutputTypeEnum_SEAT_HOLD;
  @BuiltValueEnumConst(wireName: r'PAYOUT')
  static const PolicyOverviewDtoOutputTypeEnum PAYOUT = _$policyOverviewDtoOutputTypeEnum_PAYOUT;
  @BuiltValueEnumConst(wireName: r'LOYALTY')
  static const PolicyOverviewDtoOutputTypeEnum LOYALTY = _$policyOverviewDtoOutputTypeEnum_LOYALTY;

  static Serializer<PolicyOverviewDtoOutputTypeEnum> get serializer => _$policyOverviewDtoOutputTypeEnumSerializer;

  const PolicyOverviewDtoOutputTypeEnum._(String name): super(name);

  static BuiltSet<PolicyOverviewDtoOutputTypeEnum> get values => _$policyOverviewDtoOutputTypeEnumValues;
  static PolicyOverviewDtoOutputTypeEnum valueOf(String name) => _$policyOverviewDtoOutputTypeEnumValueOf(name);
}

