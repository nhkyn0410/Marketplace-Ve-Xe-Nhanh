//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stop_point_reason_input_dto.g.dart';

/// StopPointReasonInputDto
///
/// Properties:
/// * [reason]
@BuiltValue()
abstract class StopPointReasonInputDto
    implements Built<StopPointReasonInputDto, StopPointReasonInputDtoBuilder> {
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  StopPointReasonInputDto._();

  factory StopPointReasonInputDto(
          [void updates(StopPointReasonInputDtoBuilder b)]) =
      _$StopPointReasonInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StopPointReasonInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StopPointReasonInputDto> get serializer =>
      _$StopPointReasonInputDtoSerializer();
}

class _$StopPointReasonInputDtoSerializer
    implements PrimitiveSerializer<StopPointReasonInputDto> {
  @override
  final Iterable<Type> types = const [
    StopPointReasonInputDto,
    _$StopPointReasonInputDto
  ];

  @override
  final String wireName = r'StopPointReasonInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StopPointReasonInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    StopPointReasonInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StopPointReasonInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StopPointReasonInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StopPointReasonInputDtoBuilder();
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
