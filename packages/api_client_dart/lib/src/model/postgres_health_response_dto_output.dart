//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'postgres_health_response_dto_output.g.dart';

/// PostgresHealthResponseDtoOutput
///
/// Properties:
/// * [status] 
/// * [service] 
/// * [timestamp] 
@BuiltValue()
abstract class PostgresHealthResponseDtoOutput implements Built<PostgresHealthResponseDtoOutput, PostgresHealthResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  PostgresHealthResponseDtoOutputStatusEnum get status;
  // enum statusEnum {  ok,  };

  @BuiltValueField(wireName: r'service')
  PostgresHealthResponseDtoOutputServiceEnum get service;
  // enum serviceEnum {  postgres,  };

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  PostgresHealthResponseDtoOutput._();

  factory PostgresHealthResponseDtoOutput([void updates(PostgresHealthResponseDtoOutputBuilder b)]) = _$PostgresHealthResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PostgresHealthResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PostgresHealthResponseDtoOutput> get serializer => _$PostgresHealthResponseDtoOutputSerializer();
}

class _$PostgresHealthResponseDtoOutputSerializer implements PrimitiveSerializer<PostgresHealthResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [PostgresHealthResponseDtoOutput, _$PostgresHealthResponseDtoOutput];

  @override
  final String wireName = r'PostgresHealthResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PostgresHealthResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PostgresHealthResponseDtoOutputStatusEnum),
    );
    yield r'service';
    yield serializers.serialize(
      object.service,
      specifiedType: const FullType(PostgresHealthResponseDtoOutputServiceEnum),
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
    PostgresHealthResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PostgresHealthResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PostgresHealthResponseDtoOutputStatusEnum),
          ) as PostgresHealthResponseDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'service':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PostgresHealthResponseDtoOutputServiceEnum),
          ) as PostgresHealthResponseDtoOutputServiceEnum;
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
  PostgresHealthResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PostgresHealthResponseDtoOutputBuilder();
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


class PostgresHealthResponseDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ok')
  static const PostgresHealthResponseDtoOutputStatusEnum ok = _$postgresHealthResponseDtoOutputStatusEnum_ok;

  static Serializer<PostgresHealthResponseDtoOutputStatusEnum> get serializer => _$postgresHealthResponseDtoOutputStatusEnumSerializer;

  const PostgresHealthResponseDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<PostgresHealthResponseDtoOutputStatusEnum> get values => _$postgresHealthResponseDtoOutputStatusEnumValues;
  static PostgresHealthResponseDtoOutputStatusEnum valueOf(String name) => _$postgresHealthResponseDtoOutputStatusEnumValueOf(name);
}

class PostgresHealthResponseDtoOutputServiceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'postgres')
  static const PostgresHealthResponseDtoOutputServiceEnum postgres = _$postgresHealthResponseDtoOutputServiceEnum_postgres;

  static Serializer<PostgresHealthResponseDtoOutputServiceEnum> get serializer => _$postgresHealthResponseDtoOutputServiceEnumSerializer;

  const PostgresHealthResponseDtoOutputServiceEnum._(String name): super(name);

  static BuiltSet<PostgresHealthResponseDtoOutputServiceEnum> get values => _$postgresHealthResponseDtoOutputServiceEnumValues;
  static PostgresHealthResponseDtoOutputServiceEnum valueOf(String name) => _$postgresHealthResponseDtoOutputServiceEnumValueOf(name);
}

