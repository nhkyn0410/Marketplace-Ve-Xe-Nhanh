//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_departure_input_dto.g.dart';

/// TripDepartureInputDto
///
/// Properties:
/// * [note] 
@BuiltValue()
abstract class TripDepartureInputDto implements Built<TripDepartureInputDto, TripDepartureInputDtoBuilder> {
  @BuiltValueField(wireName: r'note')
  String? get note;

  TripDepartureInputDto._();

  factory TripDepartureInputDto([void updates(TripDepartureInputDtoBuilder b)]) = _$TripDepartureInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripDepartureInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripDepartureInputDto> get serializer => _$TripDepartureInputDtoSerializer();
}

class _$TripDepartureInputDtoSerializer implements PrimitiveSerializer<TripDepartureInputDto> {
  @override
  final Iterable<Type> types = const [TripDepartureInputDto, _$TripDepartureInputDto];

  @override
  final String wireName = r'TripDepartureInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripDepartureInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TripDepartureInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripDepartureInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripDepartureInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripDepartureInputDtoBuilder();
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


