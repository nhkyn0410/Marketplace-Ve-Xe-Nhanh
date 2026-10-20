//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_profile_dto_output.g.dart';

/// PassengerProfileDtoOutput
///
/// Properties:
/// * [userId]
/// * [name]
/// * [email]
/// * [emailVerified]
/// * [phone]
/// * [dateOfBirth]
/// * [image]
@BuiltValue()
abstract class PassengerProfileDtoOutput
    implements
        Built<PassengerProfileDtoOutput, PassengerProfileDtoOutputBuilder> {
  @BuiltValueField(wireName: r'userId')
  String get userId;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'emailVerified')
  bool get emailVerified;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'dateOfBirth')
  Date? get dateOfBirth;

  @BuiltValueField(wireName: r'image')
  String? get image;

  PassengerProfileDtoOutput._();

  factory PassengerProfileDtoOutput(
          [void updates(PassengerProfileDtoOutputBuilder b)]) =
      _$PassengerProfileDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerProfileDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerProfileDtoOutput> get serializer =>
      _$PassengerProfileDtoOutputSerializer();
}

class _$PassengerProfileDtoOutputSerializer
    implements PrimitiveSerializer<PassengerProfileDtoOutput> {
  @override
  final Iterable<Type> types = const [
    PassengerProfileDtoOutput,
    _$PassengerProfileDtoOutput
  ];

  @override
  final String wireName = r'PassengerProfileDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerProfileDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield object.name == null
        ? null
        : serializers.serialize(
            object.name,
            specifiedType: const FullType.nullable(String),
          );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'emailVerified';
    yield serializers.serialize(
      object.emailVerified,
      specifiedType: const FullType(bool),
    );
    yield r'phone';
    yield object.phone == null
        ? null
        : serializers.serialize(
            object.phone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'dateOfBirth';
    yield object.dateOfBirth == null
        ? null
        : serializers.serialize(
            object.dateOfBirth,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'image';
    yield object.image == null
        ? null
        : serializers.serialize(
            object.image,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    PassengerProfileDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PassengerProfileDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'emailVerified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.emailVerified = valueDes;
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
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.image = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PassengerProfileDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerProfileDtoOutputBuilder();
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
