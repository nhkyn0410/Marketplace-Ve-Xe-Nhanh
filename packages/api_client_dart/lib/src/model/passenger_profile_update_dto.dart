//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_profile_update_dto.g.dart';

/// PassengerProfileUpdateDto
///
/// Properties:
/// * [name] 
/// * [phone] 
/// * [dateOfBirth] 
@BuiltValue()
abstract class PassengerProfileUpdateDto implements Built<PassengerProfileUpdateDto, PassengerProfileUpdateDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'dateOfBirth')
  Date? get dateOfBirth;

  PassengerProfileUpdateDto._();

  factory PassengerProfileUpdateDto([void updates(PassengerProfileUpdateDtoBuilder b)]) = _$PassengerProfileUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerProfileUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerProfileUpdateDto> get serializer => _$PassengerProfileUpdateDtoSerializer();
}

class _$PassengerProfileUpdateDtoSerializer implements PrimitiveSerializer<PassengerProfileUpdateDto> {
  @override
  final Iterable<Type> types = const [PassengerProfileUpdateDto, _$PassengerProfileUpdateDto];

  @override
  final String wireName = r'PassengerProfileUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerProfileUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.phone != null) {
      yield r'phone';
      yield serializers.serialize(
        object.phone,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.dateOfBirth != null) {
      yield r'dateOfBirth';
      yield serializers.serialize(
        object.dateOfBirth,
        specifiedType: const FullType.nullable(Date),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PassengerProfileUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PassengerProfileUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'dateOfBirth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.dateOfBirth = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PassengerProfileUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerProfileUpdateDtoBuilder();
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


