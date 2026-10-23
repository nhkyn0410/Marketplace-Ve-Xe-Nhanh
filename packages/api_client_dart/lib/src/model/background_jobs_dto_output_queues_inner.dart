//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'background_jobs_dto_output_queues_inner.g.dart';

/// BackgroundJobsDtoOutputQueuesInner
///
/// Properties:
/// * [name] 
/// * [waiting] 
/// * [active] 
/// * [delayed] 
/// * [failed] 
@BuiltValue()
abstract class BackgroundJobsDtoOutputQueuesInner implements Built<BackgroundJobsDtoOutputQueuesInner, BackgroundJobsDtoOutputQueuesInnerBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'waiting')
  int get waiting;

  @BuiltValueField(wireName: r'active')
  int get active;

  @BuiltValueField(wireName: r'delayed')
  int get delayed;

  @BuiltValueField(wireName: r'failed')
  int get failed;

  BackgroundJobsDtoOutputQueuesInner._();

  factory BackgroundJobsDtoOutputQueuesInner([void updates(BackgroundJobsDtoOutputQueuesInnerBuilder b)]) = _$BackgroundJobsDtoOutputQueuesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BackgroundJobsDtoOutputQueuesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BackgroundJobsDtoOutputQueuesInner> get serializer => _$BackgroundJobsDtoOutputQueuesInnerSerializer();
}

class _$BackgroundJobsDtoOutputQueuesInnerSerializer implements PrimitiveSerializer<BackgroundJobsDtoOutputQueuesInner> {
  @override
  final Iterable<Type> types = const [BackgroundJobsDtoOutputQueuesInner, _$BackgroundJobsDtoOutputQueuesInner];

  @override
  final String wireName = r'BackgroundJobsDtoOutputQueuesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BackgroundJobsDtoOutputQueuesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'waiting';
    yield serializers.serialize(
      object.waiting,
      specifiedType: const FullType(int),
    );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(int),
    );
    yield r'delayed';
    yield serializers.serialize(
      object.delayed,
      specifiedType: const FullType(int),
    );
    yield r'failed';
    yield serializers.serialize(
      object.failed,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BackgroundJobsDtoOutputQueuesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BackgroundJobsDtoOutputQueuesInnerBuilder result,
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
        case r'waiting':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.waiting = valueDes;
          break;
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.active = valueDes;
          break;
        case r'delayed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.delayed = valueDes;
          break;
        case r'failed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.failed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BackgroundJobsDtoOutputQueuesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BackgroundJobsDtoOutputQueuesInnerBuilder();
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


