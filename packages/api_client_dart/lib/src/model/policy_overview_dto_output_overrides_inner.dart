//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'policy_overview_dto_output_overrides_inner.g.dart';

/// PolicyOverviewDtoOutputOverridesInner
///
/// Properties:
/// * [operatorId] 
/// * [operatorName] 
/// * [operatorSlug] 
/// * [state] 
@BuiltValue()
abstract class PolicyOverviewDtoOutputOverridesInner implements Built<PolicyOverviewDtoOutputOverridesInner, PolicyOverviewDtoOutputOverridesInnerBuilder> {
  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'operatorSlug')
  String get operatorSlug;

  @BuiltValueField(wireName: r'state')
  PolicyOverviewDtoOutputOverridesInnerStateEnum get state;
  // enum stateEnum {  DRAFT,  SCHEDULED,  ACTIVE,  EXPIRED,  CANCELLED,  };

  PolicyOverviewDtoOutputOverridesInner._();

  factory PolicyOverviewDtoOutputOverridesInner([void updates(PolicyOverviewDtoOutputOverridesInnerBuilder b)]) = _$PolicyOverviewDtoOutputOverridesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PolicyOverviewDtoOutputOverridesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PolicyOverviewDtoOutputOverridesInner> get serializer => _$PolicyOverviewDtoOutputOverridesInnerSerializer();
}

class _$PolicyOverviewDtoOutputOverridesInnerSerializer implements PrimitiveSerializer<PolicyOverviewDtoOutputOverridesInner> {
  @override
  final Iterable<Type> types = const [PolicyOverviewDtoOutputOverridesInner, _$PolicyOverviewDtoOutputOverridesInner];

  @override
  final String wireName = r'PolicyOverviewDtoOutputOverridesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PolicyOverviewDtoOutputOverridesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'operatorSlug';
    yield serializers.serialize(
      object.operatorSlug,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(PolicyOverviewDtoOutputOverridesInnerStateEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PolicyOverviewDtoOutputOverridesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PolicyOverviewDtoOutputOverridesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'operatorSlug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorSlug = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PolicyOverviewDtoOutputOverridesInnerStateEnum),
          ) as PolicyOverviewDtoOutputOverridesInnerStateEnum;
          result.state = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PolicyOverviewDtoOutputOverridesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PolicyOverviewDtoOutputOverridesInnerBuilder();
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


class PolicyOverviewDtoOutputOverridesInnerStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const PolicyOverviewDtoOutputOverridesInnerStateEnum DRAFT = _$policyOverviewDtoOutputOverridesInnerStateEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const PolicyOverviewDtoOutputOverridesInnerStateEnum SCHEDULED = _$policyOverviewDtoOutputOverridesInnerStateEnum_SCHEDULED;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const PolicyOverviewDtoOutputOverridesInnerStateEnum ACTIVE = _$policyOverviewDtoOutputOverridesInnerStateEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const PolicyOverviewDtoOutputOverridesInnerStateEnum EXPIRED = _$policyOverviewDtoOutputOverridesInnerStateEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const PolicyOverviewDtoOutputOverridesInnerStateEnum CANCELLED = _$policyOverviewDtoOutputOverridesInnerStateEnum_CANCELLED;

  static Serializer<PolicyOverviewDtoOutputOverridesInnerStateEnum> get serializer => _$policyOverviewDtoOutputOverridesInnerStateEnumSerializer;

  const PolicyOverviewDtoOutputOverridesInnerStateEnum._(String name): super(name);

  static BuiltSet<PolicyOverviewDtoOutputOverridesInnerStateEnum> get values => _$policyOverviewDtoOutputOverridesInnerStateEnumValues;
  static PolicyOverviewDtoOutputOverridesInnerStateEnum valueOf(String name) => _$policyOverviewDtoOutputOverridesInnerStateEnumValueOf(name);
}

