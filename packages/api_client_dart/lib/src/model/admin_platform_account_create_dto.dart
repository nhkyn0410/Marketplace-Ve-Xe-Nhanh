//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_platform_account_create_dto.g.dart';

/// AdminPlatformAccountCreateDto
///
/// Properties:
/// * [username] 
/// * [email] 
/// * [role] 
@BuiltValue()
abstract class AdminPlatformAccountCreateDto implements Built<AdminPlatformAccountCreateDto, AdminPlatformAccountCreateDtoBuilder> {
  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'role')
  AdminPlatformAccountCreateDtoRoleEnum get role;
  // enum roleEnum {  PLATFORM_ADMIN,  PLATFORM_SUPPORT,  };

  AdminPlatformAccountCreateDto._();

  factory AdminPlatformAccountCreateDto([void updates(AdminPlatformAccountCreateDtoBuilder b)]) = _$AdminPlatformAccountCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPlatformAccountCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPlatformAccountCreateDto> get serializer => _$AdminPlatformAccountCreateDtoSerializer();
}

class _$AdminPlatformAccountCreateDtoSerializer implements PrimitiveSerializer<AdminPlatformAccountCreateDto> {
  @override
  final Iterable<Type> types = const [AdminPlatformAccountCreateDto, _$AdminPlatformAccountCreateDto];

  @override
  final String wireName = r'AdminPlatformAccountCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPlatformAccountCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(AdminPlatformAccountCreateDtoRoleEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPlatformAccountCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPlatformAccountCreateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPlatformAccountCreateDtoRoleEnum),
          ) as AdminPlatformAccountCreateDtoRoleEnum;
          result.role = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPlatformAccountCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPlatformAccountCreateDtoBuilder();
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


class AdminPlatformAccountCreateDtoRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PLATFORM_ADMIN')
  static const AdminPlatformAccountCreateDtoRoleEnum PLATFORM_ADMIN = _$adminPlatformAccountCreateDtoRoleEnum_PLATFORM_ADMIN;
  @BuiltValueEnumConst(wireName: r'PLATFORM_SUPPORT')
  static const AdminPlatformAccountCreateDtoRoleEnum PLATFORM_SUPPORT = _$adminPlatformAccountCreateDtoRoleEnum_PLATFORM_SUPPORT;

  static Serializer<AdminPlatformAccountCreateDtoRoleEnum> get serializer => _$adminPlatformAccountCreateDtoRoleEnumSerializer;

  const AdminPlatformAccountCreateDtoRoleEnum._(String name): super(name);

  static BuiltSet<AdminPlatformAccountCreateDtoRoleEnum> get values => _$adminPlatformAccountCreateDtoRoleEnumValues;
  static AdminPlatformAccountCreateDtoRoleEnum valueOf(String name) => _$adminPlatformAccountCreateDtoRoleEnumValueOf(name);
}

