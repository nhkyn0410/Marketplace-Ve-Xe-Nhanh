//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'decision_input_dto.g.dart';

/// DecisionInputDto
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class DecisionInputDto implements Built<DecisionInputDto, DecisionInputDtoBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  DecisionInputDto._();

  factory DecisionInputDto([void updates(DecisionInputDtoBuilder b)]) = _$DecisionInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DecisionInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DecisionInputDto> get serializer => _$DecisionInputDtoSerializer();
}

class _$DecisionInputDtoSerializer implements PrimitiveSerializer<DecisionInputDto> {
  @override
  final Iterable<Type> types = const [DecisionInputDto, _$DecisionInputDto];

  @override
  final String wireName = r'DecisionInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DecisionInputDto object, {
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
    DecisionInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DecisionInputDtoBuilder result,
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
  DecisionInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DecisionInputDtoBuilder();
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


