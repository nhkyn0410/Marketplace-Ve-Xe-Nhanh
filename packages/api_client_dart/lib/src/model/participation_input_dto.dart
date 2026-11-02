//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'participation_input_dto.g.dart';

/// ParticipationInputDto
///
/// Properties:
/// * [joined] 
@BuiltValue()
abstract class ParticipationInputDto implements Built<ParticipationInputDto, ParticipationInputDtoBuilder> {
  @BuiltValueField(wireName: r'joined')
  bool get joined;

  ParticipationInputDto._();

  factory ParticipationInputDto([void updates(ParticipationInputDtoBuilder b)]) = _$ParticipationInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ParticipationInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ParticipationInputDto> get serializer => _$ParticipationInputDtoSerializer();
}

class _$ParticipationInputDtoSerializer implements PrimitiveSerializer<ParticipationInputDto> {
  @override
  final Iterable<Type> types = const [ParticipationInputDto, _$ParticipationInputDto];

  @override
  final String wireName = r'ParticipationInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ParticipationInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'joined';
    yield serializers.serialize(
      object.joined,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ParticipationInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ParticipationInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'joined':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.joined = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ParticipationInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ParticipationInputDtoBuilder();
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


