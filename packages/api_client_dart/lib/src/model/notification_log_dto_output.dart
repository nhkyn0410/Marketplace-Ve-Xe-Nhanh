//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/notification_log_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_log_dto_output.g.dart';

/// NotificationLogDtoOutput
///
/// Properties:
/// * [items] 
/// * [total] 
/// * [offset] 
/// * [limit] 
@BuiltValue()
abstract class NotificationLogDtoOutput implements Built<NotificationLogDtoOutput, NotificationLogDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<NotificationLogDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'offset')
  int get offset;

  @BuiltValueField(wireName: r'limit')
  int get limit;

  NotificationLogDtoOutput._();

  factory NotificationLogDtoOutput([void updates(NotificationLogDtoOutputBuilder b)]) = _$NotificationLogDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationLogDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationLogDtoOutput> get serializer => _$NotificationLogDtoOutputSerializer();
}

class _$NotificationLogDtoOutputSerializer implements PrimitiveSerializer<NotificationLogDtoOutput> {
  @override
  final Iterable<Type> types = const [NotificationLogDtoOutput, _$NotificationLogDtoOutput];

  @override
  final String wireName = r'NotificationLogDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationLogDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(NotificationLogDtoOutputItemsInner)]),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'offset';
    yield serializers.serialize(
      object.offset,
      specifiedType: const FullType(int),
    );
    yield r'limit';
    yield serializers.serialize(
      object.limit,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationLogDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationLogDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(NotificationLogDtoOutputItemsInner)]),
          ) as BuiltList<NotificationLogDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'offset':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.offset = valueDes;
          break;
        case r'limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.limit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationLogDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationLogDtoOutputBuilder();
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


