//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'policy_publish_dto.g.dart';

/// PolicyPublishDto
///
/// Properties:
/// * [changeReason] 
@BuiltValue()
abstract class PolicyPublishDto implements Built<PolicyPublishDto, PolicyPublishDtoBuilder> {
  @BuiltValueField(wireName: r'changeReason')
  String get changeReason;

  PolicyPublishDto._();

  factory PolicyPublishDto([void updates(PolicyPublishDtoBuilder b)]) = _$PolicyPublishDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PolicyPublishDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PolicyPublishDto> get serializer => _$PolicyPublishDtoSerializer();
}

class _$PolicyPublishDtoSerializer implements PrimitiveSerializer<PolicyPublishDto> {
  @override
  final Iterable<Type> types = const [PolicyPublishDto, _$PolicyPublishDto];

  @override
  final String wireName = r'PolicyPublishDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PolicyPublishDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'changeReason';
    yield serializers.serialize(
      object.changeReason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PolicyPublishDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PolicyPublishDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'changeReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.changeReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PolicyPublishDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PolicyPublishDtoBuilder();
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


