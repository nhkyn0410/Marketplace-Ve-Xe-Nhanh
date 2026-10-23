//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/booking_contact_dto_output_passengers_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'booking_contact_dto_output.g.dart';

/// BookingContactDtoOutput
///
/// Properties:
/// * [fullName] 
/// * [phone] 
/// * [email] 
/// * [passengers] 
@BuiltValue()
abstract class BookingContactDtoOutput implements Built<BookingContactDtoOutput, BookingContactDtoOutputBuilder> {
  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'passengers')
  BuiltList<BookingContactDtoOutputPassengersInner> get passengers;

  BookingContactDtoOutput._();

  factory BookingContactDtoOutput([void updates(BookingContactDtoOutputBuilder b)]) = _$BookingContactDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BookingContactDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BookingContactDtoOutput> get serializer => _$BookingContactDtoOutputSerializer();
}

class _$BookingContactDtoOutputSerializer implements PrimitiveSerializer<BookingContactDtoOutput> {
  @override
  final Iterable<Type> types = const [BookingContactDtoOutput, _$BookingContactDtoOutput];

  @override
  final String wireName = r'BookingContactDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BookingContactDtoOutput object, {
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
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'passengers';
    yield serializers.serialize(
      object.passengers,
      specifiedType: const FullType(BuiltList, [FullType(BookingContactDtoOutputPassengersInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BookingContactDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BookingContactDtoOutputBuilder result,
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
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'passengers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BookingContactDtoOutputPassengersInner)]),
          ) as BuiltList<BookingContactDtoOutputPassengersInner>;
          result.passengers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BookingContactDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BookingContactDtoOutputBuilder();
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


