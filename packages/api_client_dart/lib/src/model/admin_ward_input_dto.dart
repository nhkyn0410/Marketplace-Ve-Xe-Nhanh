//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ward_input_dto.g.dart';

/// AdminWardInputDto
///
/// Properties:
/// * [provinceId] 
/// * [code] 
/// * [name] 
@BuiltValue()
abstract class AdminWardInputDto implements Built<AdminWardInputDto, AdminWardInputDtoBuilder> {
  @BuiltValueField(wireName: r'provinceId')
  String get provinceId;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  AdminWardInputDto._();

  factory AdminWardInputDto([void updates(AdminWardInputDtoBuilder b)]) = _$AdminWardInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminWardInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminWardInputDto> get serializer => _$AdminWardInputDtoSerializer();
}

class _$AdminWardInputDtoSerializer implements PrimitiveSerializer<AdminWardInputDto> {
  @override
  final Iterable<Type> types = const [AdminWardInputDto, _$AdminWardInputDto];

  @override
  final String wireName = r'AdminWardInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminWardInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'provinceId';
    yield serializers.serialize(
      object.provinceId,
      specifiedType: const FullType(String),
    );
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
    AdminWardInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminWardInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'provinceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provinceId = valueDes;
          break;
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
  AdminWardInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminWardInputDtoBuilder();
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


