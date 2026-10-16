//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_schedule_generate_input_dto.g.dart';

/// TripScheduleGenerateInputDto
///
/// Properties:
/// * [openForSale] 
@BuiltValue()
abstract class TripScheduleGenerateInputDto implements Built<TripScheduleGenerateInputDto, TripScheduleGenerateInputDtoBuilder> {
  @BuiltValueField(wireName: r'openForSale')
  bool get openForSale;

  TripScheduleGenerateInputDto._();

  factory TripScheduleGenerateInputDto([void updates(TripScheduleGenerateInputDtoBuilder b)]) = _$TripScheduleGenerateInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripScheduleGenerateInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripScheduleGenerateInputDto> get serializer => _$TripScheduleGenerateInputDtoSerializer();
}

class _$TripScheduleGenerateInputDtoSerializer implements PrimitiveSerializer<TripScheduleGenerateInputDto> {
  @override
  final Iterable<Type> types = const [TripScheduleGenerateInputDto, _$TripScheduleGenerateInputDto];

  @override
  final String wireName = r'TripScheduleGenerateInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripScheduleGenerateInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'openForSale';
    yield serializers.serialize(
      object.openForSale,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripScheduleGenerateInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripScheduleGenerateInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'openForSale':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.openForSale = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripScheduleGenerateInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripScheduleGenerateInputDtoBuilder();
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


