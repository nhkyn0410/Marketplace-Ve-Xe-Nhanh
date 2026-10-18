//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'booking_contact_dto_output_passengers_inner.g.dart';

/// BookingContactDtoOutputPassengersInner
///
/// Properties:
/// * [seatCode] 
/// * [phone] 
@BuiltValue()
abstract class BookingContactDtoOutputPassengersInner implements Built<BookingContactDtoOutputPassengersInner, BookingContactDtoOutputPassengersInnerBuilder> {
  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  BookingContactDtoOutputPassengersInner._();

  factory BookingContactDtoOutputPassengersInner([void updates(BookingContactDtoOutputPassengersInnerBuilder b)]) = _$BookingContactDtoOutputPassengersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BookingContactDtoOutputPassengersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BookingContactDtoOutputPassengersInner> get serializer => _$BookingContactDtoOutputPassengersInnerSerializer();
}

class _$BookingContactDtoOutputPassengersInnerSerializer implements PrimitiveSerializer<BookingContactDtoOutputPassengersInner> {
  @override
  final Iterable<Type> types = const [BookingContactDtoOutputPassengersInner, _$BookingContactDtoOutputPassengersInner];

  @override
  final String wireName = r'BookingContactDtoOutputPassengersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BookingContactDtoOutputPassengersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'seatCode';
    yield serializers.serialize(
      object.seatCode,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield object.phone == null ? null : serializers.serialize(
      object.phone,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BookingContactDtoOutputPassengersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BookingContactDtoOutputPassengersInnerBuilder result,
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
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BookingContactDtoOutputPassengersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BookingContactDtoOutputPassengersInnerBuilder();
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


