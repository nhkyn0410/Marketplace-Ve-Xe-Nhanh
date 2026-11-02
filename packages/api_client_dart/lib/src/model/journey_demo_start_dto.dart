//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'journey_demo_start_dto.g.dart';

/// JourneyDemoStartDto
///
/// Properties:
/// * [bookingId] 
/// * [deviceId] 
@BuiltValue()
abstract class JourneyDemoStartDto implements Built<JourneyDemoStartDto, JourneyDemoStartDtoBuilder> {
  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  JourneyDemoStartDto._();

  factory JourneyDemoStartDto([void updates(JourneyDemoStartDtoBuilder b)]) = _$JourneyDemoStartDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JourneyDemoStartDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<JourneyDemoStartDto> get serializer => _$JourneyDemoStartDtoSerializer();
}

class _$JourneyDemoStartDtoSerializer implements PrimitiveSerializer<JourneyDemoStartDto> {
  @override
  final Iterable<Type> types = const [JourneyDemoStartDto, _$JourneyDemoStartDto];

  @override
  final String wireName = r'JourneyDemoStartDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    JourneyDemoStartDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'bookingId';
    yield serializers.serialize(
      object.bookingId,
      specifiedType: const FullType(String),
    );
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    JourneyDemoStartDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required JourneyDemoStartDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bookingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingId = valueDes;
          break;
        case r'deviceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  JourneyDemoStartDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JourneyDemoStartDtoBuilder();
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


