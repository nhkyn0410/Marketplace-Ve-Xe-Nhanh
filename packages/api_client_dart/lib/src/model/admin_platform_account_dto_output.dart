//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_platform_account_dto_output.g.dart';

/// AdminPlatformAccountDtoOutput
///
/// Properties:
/// * [id] 
/// * [username] 
/// * [email] 
/// * [role] 
/// * [status] 
/// * [mfaEnabled] 
/// * [passwordChangeRequired] 
/// * [credentialDeliveryPending] 
/// * [lockedReason] 
/// * [lockedAt] 
/// * [lastLoginAt] 
/// * [isSelf] 
@BuiltValue()
abstract class AdminPlatformAccountDtoOutput implements Built<AdminPlatformAccountDtoOutput, AdminPlatformAccountDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'role')
  AdminPlatformAccountDtoOutputRoleEnum get role;
  // enum roleEnum {  PLATFORM_ADMIN,  PLATFORM_SUPPORT,  };

  @BuiltValueField(wireName: r'status')
  AdminPlatformAccountDtoOutputStatusEnum get status;
  // enum statusEnum {  ACTIVE,  LOCKED,  DISABLED,  };

  @BuiltValueField(wireName: r'mfaEnabled')
  bool get mfaEnabled;

  @BuiltValueField(wireName: r'passwordChangeRequired')
  bool get passwordChangeRequired;

  @BuiltValueField(wireName: r'credentialDeliveryPending')
  bool get credentialDeliveryPending;

  @BuiltValueField(wireName: r'lockedReason')
  String? get lockedReason;

  @BuiltValueField(wireName: r'lockedAt')
  DateTime? get lockedAt;

  @BuiltValueField(wireName: r'lastLoginAt')
  DateTime? get lastLoginAt;

  @BuiltValueField(wireName: r'isSelf')
  bool get isSelf;

  AdminPlatformAccountDtoOutput._();

  factory AdminPlatformAccountDtoOutput([void updates(AdminPlatformAccountDtoOutputBuilder b)]) = _$AdminPlatformAccountDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPlatformAccountDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPlatformAccountDtoOutput> get serializer => _$AdminPlatformAccountDtoOutputSerializer();
}

class _$AdminPlatformAccountDtoOutputSerializer implements PrimitiveSerializer<AdminPlatformAccountDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminPlatformAccountDtoOutput, _$AdminPlatformAccountDtoOutput];

  @override
  final String wireName = r'AdminPlatformAccountDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPlatformAccountDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield object.email == null ? null : serializers.serialize(
      object.email,
      specifiedType: const FullType.nullable(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(AdminPlatformAccountDtoOutputRoleEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminPlatformAccountDtoOutputStatusEnum),
    );
    yield r'mfaEnabled';
    yield serializers.serialize(
      object.mfaEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'passwordChangeRequired';
    yield serializers.serialize(
      object.passwordChangeRequired,
      specifiedType: const FullType(bool),
    );
    yield r'credentialDeliveryPending';
    yield serializers.serialize(
      object.credentialDeliveryPending,
      specifiedType: const FullType(bool),
    );
    yield r'lockedReason';
    yield object.lockedReason == null ? null : serializers.serialize(
      object.lockedReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'lockedAt';
    yield object.lockedAt == null ? null : serializers.serialize(
      object.lockedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'lastLoginAt';
    yield object.lastLoginAt == null ? null : serializers.serialize(
      object.lastLoginAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'isSelf';
    yield serializers.serialize(
      object.isSelf,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPlatformAccountDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPlatformAccountDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.email = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPlatformAccountDtoOutputRoleEnum),
          ) as AdminPlatformAccountDtoOutputRoleEnum;
          result.role = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPlatformAccountDtoOutputStatusEnum),
          ) as AdminPlatformAccountDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'mfaEnabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.mfaEnabled = valueDes;
          break;
        case r'passwordChangeRequired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.passwordChangeRequired = valueDes;
          break;
        case r'credentialDeliveryPending':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.credentialDeliveryPending = valueDes;
          break;
        case r'lockedReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lockedReason = valueDes;
          break;
        case r'lockedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lockedAt = valueDes;
          break;
        case r'lastLoginAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastLoginAt = valueDes;
          break;
        case r'isSelf':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isSelf = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPlatformAccountDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPlatformAccountDtoOutputBuilder();
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


class AdminPlatformAccountDtoOutputRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PLATFORM_ADMIN')
  static const AdminPlatformAccountDtoOutputRoleEnum PLATFORM_ADMIN = _$adminPlatformAccountDtoOutputRoleEnum_PLATFORM_ADMIN;
  @BuiltValueEnumConst(wireName: r'PLATFORM_SUPPORT')
  static const AdminPlatformAccountDtoOutputRoleEnum PLATFORM_SUPPORT = _$adminPlatformAccountDtoOutputRoleEnum_PLATFORM_SUPPORT;

  static Serializer<AdminPlatformAccountDtoOutputRoleEnum> get serializer => _$adminPlatformAccountDtoOutputRoleEnumSerializer;

  const AdminPlatformAccountDtoOutputRoleEnum._(String name): super(name);

  static BuiltSet<AdminPlatformAccountDtoOutputRoleEnum> get values => _$adminPlatformAccountDtoOutputRoleEnumValues;
  static AdminPlatformAccountDtoOutputRoleEnum valueOf(String name) => _$adminPlatformAccountDtoOutputRoleEnumValueOf(name);
}

class AdminPlatformAccountDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminPlatformAccountDtoOutputStatusEnum ACTIVE = _$adminPlatformAccountDtoOutputStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const AdminPlatformAccountDtoOutputStatusEnum LOCKED = _$adminPlatformAccountDtoOutputStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const AdminPlatformAccountDtoOutputStatusEnum DISABLED = _$adminPlatformAccountDtoOutputStatusEnum_DISABLED;

  static Serializer<AdminPlatformAccountDtoOutputStatusEnum> get serializer => _$adminPlatformAccountDtoOutputStatusEnumSerializer;

  const AdminPlatformAccountDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<AdminPlatformAccountDtoOutputStatusEnum> get values => _$adminPlatformAccountDtoOutputStatusEnumValues;
  static AdminPlatformAccountDtoOutputStatusEnum valueOf(String name) => _$adminPlatformAccountDtoOutputStatusEnumValueOf(name);
}

