//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_booking_input_dto_passengers_inner.g.dart';

/// CounterBookingInputDtoPassengersInner
///
/// Properties:
/// * [seatCode] 
/// * [fullName] 
/// * [phone] 
/// * [companionName] 
@BuiltValue()
abstract class CounterBookingInputDtoPassengersInner implements Built<CounterBookingInputDtoPassengersInner, CounterBookingInputDtoPassengersInnerBuilder> {
  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'companionName')
  String? get companionName;

  CounterBookingInputDtoPassengersInner._();

  factory CounterBookingInputDtoPassengersInner([void updates(CounterBookingInputDtoPassengersInnerBuilder b)]) = _$CounterBookingInputDtoPassengersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterBookingInputDtoPassengersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterBookingInputDtoPassengersInner> get serializer => _$CounterBookingInputDtoPassengersInnerSerializer();
}

class _$CounterBookingInputDtoPassengersInnerSerializer implements PrimitiveSerializer<CounterBookingInputDtoPassengersInner> {
  @override
  final Iterable<Type> types = const [CounterBookingInputDtoPassengersInner, _$CounterBookingInputDtoPassengersInner];

  @override
  final String wireName = r'CounterBookingInputDtoPassengersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterBookingInputDtoPassengersInner object, {
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
    yield r'phone';
    yield object.phone == null ? null : serializers.serialize(
      object.phone,
      specifiedType: const FullType.nullable(String),
    );
    if (object.companionName != null) {
      yield r'companionName';
      yield serializers.serialize(
        object.companionName,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterBookingInputDtoPassengersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterBookingInputDtoPassengersInnerBuilder result,
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
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'companionName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.companionName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterBookingInputDtoPassengersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterBookingInputDtoPassengersInnerBuilder();
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


