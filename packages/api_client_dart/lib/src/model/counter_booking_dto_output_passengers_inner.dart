//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_booking_dto_output_passengers_inner.g.dart';

/// CounterBookingDtoOutputPassengersInner
///
/// Properties:
/// * [seatCode] 
/// * [fullName] 
/// * [price] 
@BuiltValue()
abstract class CounterBookingDtoOutputPassengersInner implements Built<CounterBookingDtoOutputPassengersInner, CounterBookingDtoOutputPassengersInnerBuilder> {
  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'price')
  String get price;

  CounterBookingDtoOutputPassengersInner._();

  factory CounterBookingDtoOutputPassengersInner([void updates(CounterBookingDtoOutputPassengersInnerBuilder b)]) = _$CounterBookingDtoOutputPassengersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterBookingDtoOutputPassengersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterBookingDtoOutputPassengersInner> get serializer => _$CounterBookingDtoOutputPassengersInnerSerializer();
}

class _$CounterBookingDtoOutputPassengersInnerSerializer implements PrimitiveSerializer<CounterBookingDtoOutputPassengersInner> {
  @override
  final Iterable<Type> types = const [CounterBookingDtoOutputPassengersInner, _$CounterBookingDtoOutputPassengersInner];

  @override
  final String wireName = r'CounterBookingDtoOutputPassengersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterBookingDtoOutputPassengersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'seatCode';
    yield serializers.serialize(
      object.seatCode,
      specifiedType: const FullType(String),
    );
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterBookingDtoOutputPassengersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterBookingDtoOutputPassengersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'seatCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.seatCode = valueDes;
          break;
        case r'fullName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.price = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterBookingDtoOutputPassengersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterBookingDtoOutputPassengersInnerBuilder();
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


