//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'health_response_dto_output.g.dart';

/// HealthResponseDtoOutput
///
/// Properties:
/// * [status] 
/// * [service] 
/// * [timestamp] 
@BuiltValue()
abstract class HealthResponseDtoOutput implements Built<HealthResponseDtoOutput, HealthResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  HealthResponseDtoOutputStatusEnum get status;
  // enum statusEnum {  ok,  };

  @BuiltValueField(wireName: r'service')
  String get service;

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  HealthResponseDtoOutput._();

  factory HealthResponseDtoOutput([void updates(HealthResponseDtoOutputBuilder b)]) = _$HealthResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HealthResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HealthResponseDtoOutput> get serializer => _$HealthResponseDtoOutputSerializer();
}

class _$HealthResponseDtoOutputSerializer implements PrimitiveSerializer<HealthResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [HealthResponseDtoOutput, _$HealthResponseDtoOutput];

  @override
  final String wireName = r'HealthResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HealthResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(HealthResponseDtoOutputStatusEnum),
    );
    yield r'service';
    yield serializers.serialize(
      object.service,
      specifiedType: const FullType(String),
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
    HealthResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required HealthResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(HealthResponseDtoOutputStatusEnum),
          ) as HealthResponseDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'service':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  HealthResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HealthResponseDtoOutputBuilder();
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


class HealthResponseDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ok')
  static const HealthResponseDtoOutputStatusEnum ok = _$healthResponseDtoOutputStatusEnum_ok;

  static Serializer<HealthResponseDtoOutputStatusEnum> get serializer => _$healthResponseDtoOutputStatusEnumSerializer;

  const HealthResponseDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<HealthResponseDtoOutputStatusEnum> get values => _$healthResponseDtoOutputStatusEnumValues;
  static HealthResponseDtoOutputStatusEnum valueOf(String name) => _$healthResponseDtoOutputStatusEnumValueOf(name);
}

