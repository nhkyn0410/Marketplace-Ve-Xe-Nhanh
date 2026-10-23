//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pickup_window_input_dto.g.dart';

/// PickupWindowInputDto
///
/// Properties:
/// * [start] 
/// * [end] 
@BuiltValue()
abstract class PickupWindowInputDto implements Built<PickupWindowInputDto, PickupWindowInputDtoBuilder> {
  @BuiltValueField(wireName: r'start')
  DateTime? get start;

  @BuiltValueField(wireName: r'end')
  DateTime? get end;

  PickupWindowInputDto._();

  factory PickupWindowInputDto([void updates(PickupWindowInputDtoBuilder b)]) = _$PickupWindowInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PickupWindowInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PickupWindowInputDto> get serializer => _$PickupWindowInputDtoSerializer();
}

class _$PickupWindowInputDtoSerializer implements PrimitiveSerializer<PickupWindowInputDto> {
  @override
  final Iterable<Type> types = const [PickupWindowInputDto, _$PickupWindowInputDto];

  @override
  final String wireName = r'PickupWindowInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PickupWindowInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'start';
    yield object.start == null ? null : serializers.serialize(
      object.start,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'end';
    yield object.end == null ? null : serializers.serialize(
      object.end,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PickupWindowInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PickupWindowInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'start':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.start = valueDes;
          break;
        case r'end':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.end = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PickupWindowInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PickupWindowInputDtoBuilder();
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


