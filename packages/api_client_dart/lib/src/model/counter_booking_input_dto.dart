//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/counter_booking_input_dto_contact.dart';
import 'package:api_client_dart/src/model/counter_booking_input_dto_passengers_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_booking_input_dto.g.dart';

/// CounterBookingInputDto
///
/// Properties:
/// * [holdId] 
/// * [contact] 
/// * [passengers] 
/// * [note] 
/// * [expectedTotal] 
@BuiltValue()
abstract class CounterBookingInputDto implements Built<CounterBookingInputDto, CounterBookingInputDtoBuilder> {
  @BuiltValueField(wireName: r'holdId')
  String get holdId;

  @BuiltValueField(wireName: r'contact')
  CounterBookingInputDtoContact get contact;

  @BuiltValueField(wireName: r'passengers')
  BuiltList<CounterBookingInputDtoPassengersInner> get passengers;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'expectedTotal')
  String get expectedTotal;

  CounterBookingInputDto._();

  factory CounterBookingInputDto([void updates(CounterBookingInputDtoBuilder b)]) = _$CounterBookingInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterBookingInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterBookingInputDto> get serializer => _$CounterBookingInputDtoSerializer();
}

class _$CounterBookingInputDtoSerializer implements PrimitiveSerializer<CounterBookingInputDto> {
  @override
  final Iterable<Type> types = const [CounterBookingInputDto, _$CounterBookingInputDto];

  @override
  final String wireName = r'CounterBookingInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterBookingInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'holdId';
    yield serializers.serialize(
      object.holdId,
      specifiedType: const FullType(String),
    );
    yield r'contact';
    yield serializers.serialize(
      object.contact,
      specifiedType: const FullType(CounterBookingInputDtoContact),
    );
    yield r'passengers';
    yield serializers.serialize(
      object.passengers,
      specifiedType: const FullType(BuiltList, [FullType(CounterBookingInputDtoPassengersInner)]),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
    yield r'expectedTotal';
    yield serializers.serialize(
      object.expectedTotal,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterBookingInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterBookingInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'holdId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.holdId = valueDes;
          break;
        case r'contact':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CounterBookingInputDtoContact),
          ) as CounterBookingInputDtoContact;
          result.contact.replace(valueDes);
          break;
        case r'passengers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CounterBookingInputDtoPassengersInner)]),
          ) as BuiltList<CounterBookingInputDtoPassengersInner>;
          result.passengers.replace(valueDes);
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'expectedTotal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.expectedTotal = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterBookingInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterBookingInputDtoBuilder();
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


