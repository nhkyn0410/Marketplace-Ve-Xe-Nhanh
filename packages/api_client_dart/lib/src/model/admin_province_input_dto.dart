//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_province_input_dto.g.dart';

/// AdminProvinceInputDto
///
/// Properties:
/// * [code] 
/// * [name] 
@BuiltValue()
abstract class AdminProvinceInputDto implements Built<AdminProvinceInputDto, AdminProvinceInputDtoBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  AdminProvinceInputDto._();

  factory AdminProvinceInputDto([void updates(AdminProvinceInputDtoBuilder b)]) = _$AdminProvinceInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminProvinceInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminProvinceInputDto> get serializer => _$AdminProvinceInputDtoSerializer();
}

class _$AdminProvinceInputDtoSerializer implements PrimitiveSerializer<AdminProvinceInputDto> {
  @override
  final Iterable<Type> types = const [AdminProvinceInputDto, _$AdminProvinceInputDto];

  @override
  final String wireName = r'AdminProvinceInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminProvinceInputDto object, {
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
    AdminProvinceInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminProvinceInputDtoBuilder result,
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
  AdminProvinceInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminProvinceInputDtoBuilder();
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


