//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'saved_passenger_input_dto.g.dart';

/// SavedPassengerInputDto
///
/// Properties:
/// * [fullName] 
/// * [phone] 
@BuiltValue()
abstract class SavedPassengerInputDto implements Built<SavedPassengerInputDto, SavedPassengerInputDtoBuilder> {
  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  SavedPassengerInputDto._();

  factory SavedPassengerInputDto([void updates(SavedPassengerInputDtoBuilder b)]) = _$SavedPassengerInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SavedPassengerInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SavedPassengerInputDto> get serializer => _$SavedPassengerInputDtoSerializer();
}

class _$SavedPassengerInputDtoSerializer implements PrimitiveSerializer<SavedPassengerInputDto> {
  @override
  final Iterable<Type> types = const [SavedPassengerInputDto, _$SavedPassengerInputDto];

  @override
  final String wireName = r'SavedPassengerInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SavedPassengerInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    if (object.phone != null) {
      yield r'phone';
      yield serializers.serialize(
        object.phone,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SavedPassengerInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SavedPassengerInputDtoBuilder result,
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
  SavedPassengerInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SavedPassengerInputDtoBuilder();
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


