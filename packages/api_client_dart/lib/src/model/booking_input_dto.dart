//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/booking_input_dto_passengers_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/booking_input_dto_contact.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'booking_input_dto.g.dart';

/// BookingInputDto
///
/// Properties:
/// * [holdId] 
/// * [contact] 
/// * [passengers] 
/// * [note] 
/// * [expectedTotal] 
/// * [userVoucherId] 
/// * [promotionCode] 
@BuiltValue()
abstract class BookingInputDto implements Built<BookingInputDto, BookingInputDtoBuilder> {
  @BuiltValueField(wireName: r'holdId')
  String get holdId;

  @BuiltValueField(wireName: r'contact')
  BookingInputDtoContact get contact;

  @BuiltValueField(wireName: r'passengers')
  BuiltList<BookingInputDtoPassengersInner> get passengers;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'expectedTotal')
  int get expectedTotal;

  @BuiltValueField(wireName: r'userVoucherId')
  String? get userVoucherId;

  @BuiltValueField(wireName: r'promotionCode')
  String? get promotionCode;

  BookingInputDto._();

  factory BookingInputDto([void updates(BookingInputDtoBuilder b)]) = _$BookingInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BookingInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BookingInputDto> get serializer => _$BookingInputDtoSerializer();
}

class _$BookingInputDtoSerializer implements PrimitiveSerializer<BookingInputDto> {
  @override
  final Iterable<Type> types = const [BookingInputDto, _$BookingInputDto];

  @override
  final String wireName = r'BookingInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BookingInputDto object, {
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
      specifiedType: const FullType(BookingInputDtoContact),
    );
    yield r'passengers';
    yield serializers.serialize(
      object.passengers,
      specifiedType: const FullType(BuiltList, [FullType(BookingInputDtoPassengersInner)]),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
    yield r'expectedTotal';
    yield serializers.serialize(
      object.expectedTotal,
      specifiedType: const FullType(int),
    );
    if (object.userVoucherId != null) {
      yield r'userVoucherId';
      yield serializers.serialize(
        object.userVoucherId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.promotionCode != null) {
      yield r'promotionCode';
      yield serializers.serialize(
        object.promotionCode,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BookingInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BookingInputDtoBuilder result,
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
            specifiedType: const FullType(BookingInputDtoContact),
          ) as BookingInputDtoContact;
          result.contact.replace(valueDes);
          break;
        case r'passengers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BookingInputDtoPassengersInner)]),
          ) as BuiltList<BookingInputDtoPassengersInner>;
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
            specifiedType: const FullType(int),
          ) as int;
          result.expectedTotal = valueDes;
          break;
        case r'userVoucherId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.userVoucherId = valueDes;
          break;
        case r'promotionCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.promotionCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BookingInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BookingInputDtoBuilder();
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


