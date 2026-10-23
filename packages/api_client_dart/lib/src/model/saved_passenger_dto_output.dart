//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'saved_passenger_dto_output.g.dart';

/// SavedPassengerDtoOutput
///
/// Properties:
/// * [passengerId] 
/// * [fullName] 
/// * [phone] 
@BuiltValue()
abstract class SavedPassengerDtoOutput implements Built<SavedPassengerDtoOutput, SavedPassengerDtoOutputBuilder> {
  @BuiltValueField(wireName: r'passengerId')
  String get passengerId;

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  SavedPassengerDtoOutput._();

  factory SavedPassengerDtoOutput([void updates(SavedPassengerDtoOutputBuilder b)]) = _$SavedPassengerDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SavedPassengerDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SavedPassengerDtoOutput> get serializer => _$SavedPassengerDtoOutputSerializer();
}

class _$SavedPassengerDtoOutputSerializer implements PrimitiveSerializer<SavedPassengerDtoOutput> {
  @override
  final Iterable<Type> types = const [SavedPassengerDtoOutput, _$SavedPassengerDtoOutput];

  @override
  final String wireName = r'SavedPassengerDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SavedPassengerDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'passengerId';
    yield serializers.serialize(
      object.passengerId,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    SavedPassengerDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SavedPassengerDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'passengerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.passengerId = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SavedPassengerDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SavedPassengerDtoOutputBuilder();
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


