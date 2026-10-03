//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'message_response_dto_output.g.dart';

/// MessageResponseDtoOutput
///
/// Properties:
/// * [status] 
@BuiltValue()
abstract class MessageResponseDtoOutput implements Built<MessageResponseDtoOutput, MessageResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  MessageResponseDtoOutputStatusEnum get status;
  // enum statusEnum {  ok,  };

  MessageResponseDtoOutput._();

  factory MessageResponseDtoOutput([void updates(MessageResponseDtoOutputBuilder b)]) = _$MessageResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MessageResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MessageResponseDtoOutput> get serializer => _$MessageResponseDtoOutputSerializer();
}

class _$MessageResponseDtoOutputSerializer implements PrimitiveSerializer<MessageResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [MessageResponseDtoOutput, _$MessageResponseDtoOutput];

  @override
  final String wireName = r'MessageResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MessageResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(MessageResponseDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MessageResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MessageResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MessageResponseDtoOutputStatusEnum),
          ) as MessageResponseDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MessageResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MessageResponseDtoOutputBuilder();
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


class MessageResponseDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ok')
  static const MessageResponseDtoOutputStatusEnum ok = _$messageResponseDtoOutputStatusEnum_ok;

  static Serializer<MessageResponseDtoOutputStatusEnum> get serializer => _$messageResponseDtoOutputStatusEnumSerializer;

  const MessageResponseDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<MessageResponseDtoOutputStatusEnum> get values => _$messageResponseDtoOutputStatusEnumValues;
  static MessageResponseDtoOutputStatusEnum valueOf(String name) => _$messageResponseDtoOutputStatusEnumValueOf(name);
}

