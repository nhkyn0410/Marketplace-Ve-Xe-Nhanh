//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'redis_health_response_dto_output.g.dart';

/// RedisHealthResponseDtoOutput
///
/// Properties:
/// * [status] 
/// * [service] 
/// * [timestamp] 
@BuiltValue()
abstract class RedisHealthResponseDtoOutput implements Built<RedisHealthResponseDtoOutput, RedisHealthResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  RedisHealthResponseDtoOutputStatusEnum get status;
  // enum statusEnum {  ok,  };

  @BuiltValueField(wireName: r'service')
  RedisHealthResponseDtoOutputServiceEnum get service;
  // enum serviceEnum {  redis,  };

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  RedisHealthResponseDtoOutput._();

  factory RedisHealthResponseDtoOutput([void updates(RedisHealthResponseDtoOutputBuilder b)]) = _$RedisHealthResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RedisHealthResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RedisHealthResponseDtoOutput> get serializer => _$RedisHealthResponseDtoOutputSerializer();
}

class _$RedisHealthResponseDtoOutputSerializer implements PrimitiveSerializer<RedisHealthResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [RedisHealthResponseDtoOutput, _$RedisHealthResponseDtoOutput];

  @override
  final String wireName = r'RedisHealthResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RedisHealthResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(RedisHealthResponseDtoOutputStatusEnum),
    );
    yield r'service';
    yield serializers.serialize(
      object.service,
      specifiedType: const FullType(RedisHealthResponseDtoOutputServiceEnum),
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
    RedisHealthResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RedisHealthResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RedisHealthResponseDtoOutputStatusEnum),
          ) as RedisHealthResponseDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'service':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RedisHealthResponseDtoOutputServiceEnum),
          ) as RedisHealthResponseDtoOutputServiceEnum;
          result.service = valueDes;
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
  RedisHealthResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RedisHealthResponseDtoOutputBuilder();
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


class RedisHealthResponseDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ok')
  static const RedisHealthResponseDtoOutputStatusEnum ok = _$redisHealthResponseDtoOutputStatusEnum_ok;

  static Serializer<RedisHealthResponseDtoOutputStatusEnum> get serializer => _$redisHealthResponseDtoOutputStatusEnumSerializer;

  const RedisHealthResponseDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<RedisHealthResponseDtoOutputStatusEnum> get values => _$redisHealthResponseDtoOutputStatusEnumValues;
  static RedisHealthResponseDtoOutputStatusEnum valueOf(String name) => _$redisHealthResponseDtoOutputStatusEnumValueOf(name);
}

class RedisHealthResponseDtoOutputServiceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'redis')
  static const RedisHealthResponseDtoOutputServiceEnum redis = _$redisHealthResponseDtoOutputServiceEnum_redis;

  static Serializer<RedisHealthResponseDtoOutputServiceEnum> get serializer => _$redisHealthResponseDtoOutputServiceEnumSerializer;

  const RedisHealthResponseDtoOutputServiceEnum._(String name): super(name);

  static BuiltSet<RedisHealthResponseDtoOutputServiceEnum> get values => _$redisHealthResponseDtoOutputServiceEnumValues;
  static RedisHealthResponseDtoOutputServiceEnum valueOf(String name) => _$redisHealthResponseDtoOutputServiceEnumValueOf(name);
}

