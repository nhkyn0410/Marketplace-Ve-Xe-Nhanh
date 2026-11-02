//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/policy_overview_dto_output_versions_inner_rules.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'policy_draft_create_dto.g.dart';

/// PolicyDraftCreateDto
///
/// Properties:
/// * [rules] 
/// * [description] 
/// * [effectiveFrom] 
/// * [operatorId] 
@BuiltValue()
abstract class PolicyDraftCreateDto implements Built<PolicyDraftCreateDto, PolicyDraftCreateDtoBuilder> {
  @BuiltValueField(wireName: r'rules')
  PolicyOverviewDtoOutputVersionsInnerRules get rules;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime? get effectiveFrom;

  @BuiltValueField(wireName: r'operatorId')
  String? get operatorId;

  PolicyDraftCreateDto._();

  factory PolicyDraftCreateDto([void updates(PolicyDraftCreateDtoBuilder b)]) = _$PolicyDraftCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PolicyDraftCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PolicyDraftCreateDto> get serializer => _$PolicyDraftCreateDtoSerializer();
}

class _$PolicyDraftCreateDtoSerializer implements PrimitiveSerializer<PolicyDraftCreateDto> {
  @override
  final Iterable<Type> types = const [PolicyDraftCreateDto, _$PolicyDraftCreateDto];

  @override
  final String wireName = r'PolicyDraftCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PolicyDraftCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rules';
    yield serializers.serialize(
      object.rules,
      specifiedType: const FullType(PolicyOverviewDtoOutputVersionsInnerRules),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'effectiveFrom';
    yield object.effectiveFrom == null ? null : serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'operatorId';
    yield object.operatorId == null ? null : serializers.serialize(
      object.operatorId,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PolicyDraftCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PolicyDraftCreateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PolicyOverviewDtoOutputVersionsInnerRules),
          ) as PolicyOverviewDtoOutputVersionsInnerRules;
          result.rules.replace(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'effectiveFrom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.effectiveFrom = valueDes;
          break;
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.operatorId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PolicyDraftCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PolicyDraftCreateDtoBuilder();
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


