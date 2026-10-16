//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'policy_cancel_dto.g.dart';

/// PolicyCancelDto
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class PolicyCancelDto implements Built<PolicyCancelDto, PolicyCancelDtoBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  PolicyCancelDto._();

  factory PolicyCancelDto([void updates(PolicyCancelDtoBuilder b)]) = _$PolicyCancelDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PolicyCancelDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PolicyCancelDto> get serializer => _$PolicyCancelDtoSerializer();
}

class _$PolicyCancelDtoSerializer implements PrimitiveSerializer<PolicyCancelDto> {
  @override
  final Iterable<Type> types = const [PolicyCancelDto, _$PolicyCancelDto];

  @override
  final String wireName = r'PolicyCancelDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PolicyCancelDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PolicyCancelDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PolicyCancelDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PolicyCancelDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PolicyCancelDtoBuilder();
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


