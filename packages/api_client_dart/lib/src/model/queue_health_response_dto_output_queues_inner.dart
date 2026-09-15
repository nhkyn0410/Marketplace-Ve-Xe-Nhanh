//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'queue_health_response_dto_output_queues_inner.g.dart';

/// QueueHealthResponseDtoOutputQueuesInner
///
/// Properties:
/// * [name] 
/// * [counts] 
@BuiltValue()
abstract class QueueHealthResponseDtoOutputQueuesInner implements Built<QueueHealthResponseDtoOutputQueuesInner, QueueHealthResponseDtoOutputQueuesInnerBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'counts')
  BuiltMap<String, int> get counts;

  QueueHealthResponseDtoOutputQueuesInner._();

  factory QueueHealthResponseDtoOutputQueuesInner([void updates(QueueHealthResponseDtoOutputQueuesInnerBuilder b)]) = _$QueueHealthResponseDtoOutputQueuesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueueHealthResponseDtoOutputQueuesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueueHealthResponseDtoOutputQueuesInner> get serializer => _$QueueHealthResponseDtoOutputQueuesInnerSerializer();
}

class _$QueueHealthResponseDtoOutputQueuesInnerSerializer implements PrimitiveSerializer<QueueHealthResponseDtoOutputQueuesInner> {
  @override
  final Iterable<Type> types = const [QueueHealthResponseDtoOutputQueuesInner, _$QueueHealthResponseDtoOutputQueuesInner];

  @override
  final String wireName = r'QueueHealthResponseDtoOutputQueuesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueueHealthResponseDtoOutputQueuesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'counts';
    yield serializers.serialize(
      object.counts,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    QueueHealthResponseDtoOutputQueuesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required QueueHealthResponseDtoOutputQueuesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'counts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>;
          result.counts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueueHealthResponseDtoOutputQueuesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueueHealthResponseDtoOutputQueuesInnerBuilder();
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


