//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'unread_count_dto_output.g.dart';

/// UnreadCountDtoOutput
///
/// Properties:
/// * [unreadCount] 
@BuiltValue()
abstract class UnreadCountDtoOutput implements Built<UnreadCountDtoOutput, UnreadCountDtoOutputBuilder> {
  @BuiltValueField(wireName: r'unreadCount')
  int get unreadCount;

  UnreadCountDtoOutput._();

  factory UnreadCountDtoOutput([void updates(UnreadCountDtoOutputBuilder b)]) = _$UnreadCountDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UnreadCountDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UnreadCountDtoOutput> get serializer => _$UnreadCountDtoOutputSerializer();
}

class _$UnreadCountDtoOutputSerializer implements PrimitiveSerializer<UnreadCountDtoOutput> {
  @override
  final Iterable<Type> types = const [UnreadCountDtoOutput, _$UnreadCountDtoOutput];

  @override
  final String wireName = r'UnreadCountDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UnreadCountDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'unreadCount';
    yield serializers.serialize(
      object.unreadCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UnreadCountDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UnreadCountDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'unreadCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unreadCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UnreadCountDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UnreadCountDtoOutputBuilder();
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


