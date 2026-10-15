//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_amenity_input_dto.g.dart';

/// AdminAmenityInputDto
///
/// Properties:
/// * [code] 
/// * [name] 
@BuiltValue()
abstract class AdminAmenityInputDto implements Built<AdminAmenityInputDto, AdminAmenityInputDtoBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  AdminAmenityInputDto._();

  factory AdminAmenityInputDto([void updates(AdminAmenityInputDtoBuilder b)]) = _$AdminAmenityInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAmenityInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAmenityInputDto> get serializer => _$AdminAmenityInputDtoSerializer();
}

class _$AdminAmenityInputDtoSerializer implements PrimitiveSerializer<AdminAmenityInputDto> {
  @override
  final Iterable<Type> types = const [AdminAmenityInputDto, _$AdminAmenityInputDto];

  @override
  final String wireName = r'AdminAmenityInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAmenityInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAmenityInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminAmenityInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAmenityInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAmenityInputDtoBuilder();
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


