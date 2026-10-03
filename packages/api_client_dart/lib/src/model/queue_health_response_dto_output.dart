//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/queue_health_response_dto_output_queues_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'queue_health_response_dto_output.g.dart';

/// QueueHealthResponseDtoOutput
///
/// Properties:
/// * [status] 
/// * [queues] 
/// * [timestamp] 
@BuiltValue()
abstract class QueueHealthResponseDtoOutput implements Built<QueueHealthResponseDtoOutput, QueueHealthResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  QueueHealthResponseDtoOutputStatusEnum get status;
  // enum statusEnum {  ok,  };

  @BuiltValueField(wireName: r'queues')
  BuiltList<QueueHealthResponseDtoOutputQueuesInner> get queues;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  QueueHealthResponseDtoOutput._();

  factory QueueHealthResponseDtoOutput([void updates(QueueHealthResponseDtoOutputBuilder b)]) = _$QueueHealthResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueueHealthResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueueHealthResponseDtoOutput> get serializer => _$QueueHealthResponseDtoOutputSerializer();
}

class _$QueueHealthResponseDtoOutputSerializer implements PrimitiveSerializer<QueueHealthResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [QueueHealthResponseDtoOutput, _$QueueHealthResponseDtoOutput];

  @override
  final String wireName = r'QueueHealthResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueueHealthResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(QueueHealthResponseDtoOutputStatusEnum),
    );
    yield r'queues';
    yield serializers.serialize(
      object.queues,
      specifiedType: const FullType(BuiltList, [FullType(QueueHealthResponseDtoOutputQueuesInner)]),
    );
    yield r'timestamp';
    yield serializers.serialize(
      object.timestamp,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    QueueHealthResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required QueueHealthResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QueueHealthResponseDtoOutputStatusEnum),
          ) as QueueHealthResponseDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'queues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(QueueHealthResponseDtoOutputQueuesInner)]),
          ) as BuiltList<QueueHealthResponseDtoOutputQueuesInner>;
          result.queues.replace(valueDes);
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueueHealthResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueueHealthResponseDtoOutputBuilder();
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


class QueueHealthResponseDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ok')
  static const QueueHealthResponseDtoOutputStatusEnum ok = _$queueHealthResponseDtoOutputStatusEnum_ok;

  static Serializer<QueueHealthResponseDtoOutputStatusEnum> get serializer => _$queueHealthResponseDtoOutputStatusEnumSerializer;

  const QueueHealthResponseDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<QueueHealthResponseDtoOutputStatusEnum> get values => _$queueHealthResponseDtoOutputStatusEnumValues;
  static QueueHealthResponseDtoOutputStatusEnum valueOf(String name) => _$queueHealthResponseDtoOutputStatusEnumValueOf(name);
}

