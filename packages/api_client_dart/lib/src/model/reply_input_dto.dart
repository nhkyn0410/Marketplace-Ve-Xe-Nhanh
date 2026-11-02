//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reply_input_dto.g.dart';

/// ReplyInputDto
///
/// Properties:
/// * [reply] 
@BuiltValue()
abstract class ReplyInputDto implements Built<ReplyInputDto, ReplyInputDtoBuilder> {
  @BuiltValueField(wireName: r'reply')
  String get reply;

  ReplyInputDto._();

  factory ReplyInputDto([void updates(ReplyInputDtoBuilder b)]) = _$ReplyInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReplyInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReplyInputDto> get serializer => _$ReplyInputDtoSerializer();
}

class _$ReplyInputDtoSerializer implements PrimitiveSerializer<ReplyInputDto> {
  @override
  final Iterable<Type> types = const [ReplyInputDto, _$ReplyInputDto];

  @override
  final String wireName = r'ReplyInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReplyInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reply';
    yield serializers.serialize(
      object.reply,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReplyInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReplyInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reply':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reply = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReplyInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReplyInputDtoBuilder();
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


