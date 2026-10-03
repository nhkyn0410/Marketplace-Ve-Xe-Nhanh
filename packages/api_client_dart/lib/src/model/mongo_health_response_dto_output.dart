//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mongo_health_response_dto_output.g.dart';

/// MongoHealthResponseDtoOutput
///
/// Properties:
/// * [status] 
/// * [service] 
/// * [timestamp] 
@BuiltValue()
abstract class MongoHealthResponseDtoOutput implements Built<MongoHealthResponseDtoOutput, MongoHealthResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  MongoHealthResponseDtoOutputStatusEnum get status;
  // enum statusEnum {  ok,  };

  @BuiltValueField(wireName: r'service')
  MongoHealthResponseDtoOutputServiceEnum get service;
  // enum serviceEnum {  mongo,  };

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  MongoHealthResponseDtoOutput._();

  factory MongoHealthResponseDtoOutput([void updates(MongoHealthResponseDtoOutputBuilder b)]) = _$MongoHealthResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MongoHealthResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MongoHealthResponseDtoOutput> get serializer => _$MongoHealthResponseDtoOutputSerializer();
}

class _$MongoHealthResponseDtoOutputSerializer implements PrimitiveSerializer<MongoHealthResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [MongoHealthResponseDtoOutput, _$MongoHealthResponseDtoOutput];

  @override
  final String wireName = r'MongoHealthResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MongoHealthResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(MongoHealthResponseDtoOutputStatusEnum),
    );
    yield r'service';
    yield serializers.serialize(
      object.service,
      specifiedType: const FullType(MongoHealthResponseDtoOutputServiceEnum),
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
    MongoHealthResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MongoHealthResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MongoHealthResponseDtoOutputStatusEnum),
          ) as MongoHealthResponseDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'service':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MongoHealthResponseDtoOutputServiceEnum),
          ) as MongoHealthResponseDtoOutputServiceEnum;
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
  MongoHealthResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MongoHealthResponseDtoOutputBuilder();
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


class MongoHealthResponseDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ok')
  static const MongoHealthResponseDtoOutputStatusEnum ok = _$mongoHealthResponseDtoOutputStatusEnum_ok;

  static Serializer<MongoHealthResponseDtoOutputStatusEnum> get serializer => _$mongoHealthResponseDtoOutputStatusEnumSerializer;

  const MongoHealthResponseDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<MongoHealthResponseDtoOutputStatusEnum> get values => _$mongoHealthResponseDtoOutputStatusEnumValues;
  static MongoHealthResponseDtoOutputStatusEnum valueOf(String name) => _$mongoHealthResponseDtoOutputStatusEnumValueOf(name);
}

class MongoHealthResponseDtoOutputServiceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'mongo')
  static const MongoHealthResponseDtoOutputServiceEnum mongo = _$mongoHealthResponseDtoOutputServiceEnum_mongo;

  static Serializer<MongoHealthResponseDtoOutputServiceEnum> get serializer => _$mongoHealthResponseDtoOutputServiceEnumSerializer;

  const MongoHealthResponseDtoOutputServiceEnum._(String name): super(name);

  static BuiltSet<MongoHealthResponseDtoOutputServiceEnum> get values => _$mongoHealthResponseDtoOutputServiceEnumValues;
  static MongoHealthResponseDtoOutputServiceEnum valueOf(String name) => _$mongoHealthResponseDtoOutputServiceEnumValueOf(name);
}

