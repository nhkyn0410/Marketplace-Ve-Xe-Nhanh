//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_booking_dto_output_contact.g.dart';

/// CounterBookingDtoOutputContact
///
/// Properties:
/// * [fullName] 
/// * [phone] 
/// * [email] 
@BuiltValue()
abstract class CounterBookingDtoOutputContact implements Built<CounterBookingDtoOutputContact, CounterBookingDtoOutputContactBuilder> {
  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'email')
  String? get email;

  CounterBookingDtoOutputContact._();

  factory CounterBookingDtoOutputContact([void updates(CounterBookingDtoOutputContactBuilder b)]) = _$CounterBookingDtoOutputContact;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterBookingDtoOutputContactBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterBookingDtoOutputContact> get serializer => _$CounterBookingDtoOutputContactSerializer();
}

class _$CounterBookingDtoOutputContactSerializer implements PrimitiveSerializer<CounterBookingDtoOutputContact> {
  @override
  final Iterable<Type> types = const [CounterBookingDtoOutputContact, _$CounterBookingDtoOutputContact];

  @override
  final String wireName = r'CounterBookingDtoOutputContact';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterBookingDtoOutputContact object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield object.email == null ? null : serializers.serialize(
      object.email,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterBookingDtoOutputContact object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterBookingDtoOutputContactBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterBookingDtoOutputContact deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterBookingDtoOutputContactBuilder();
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


