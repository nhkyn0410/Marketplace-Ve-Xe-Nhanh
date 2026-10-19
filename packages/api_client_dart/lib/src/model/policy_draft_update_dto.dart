//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/policy_overview_dto_output_versions_inner_rules.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'policy_draft_update_dto.g.dart';

/// PolicyDraftUpdateDto
///
/// Properties:
/// * [rules] 
/// * [description] 
/// * [effectiveFrom] 
@BuiltValue()
abstract class PolicyDraftUpdateDto implements Built<PolicyDraftUpdateDto, PolicyDraftUpdateDtoBuilder> {
  @BuiltValueField(wireName: r'rules')
  PolicyOverviewDtoOutputVersionsInnerRules get rules;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime? get effectiveFrom;

  PolicyDraftUpdateDto._();

  factory PolicyDraftUpdateDto([void updates(PolicyDraftUpdateDtoBuilder b)]) = _$PolicyDraftUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PolicyDraftUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PolicyDraftUpdateDto> get serializer => _$PolicyDraftUpdateDtoSerializer();
}

class _$PolicyDraftUpdateDtoSerializer implements PrimitiveSerializer<PolicyDraftUpdateDto> {
  @override
  final Iterable<Type> types = const [PolicyDraftUpdateDto, _$PolicyDraftUpdateDto];

  @override
  final String wireName = r'PolicyDraftUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PolicyDraftUpdateDto object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    PolicyDraftUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PolicyDraftUpdateDtoBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PolicyDraftUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PolicyDraftUpdateDtoBuilder();
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


