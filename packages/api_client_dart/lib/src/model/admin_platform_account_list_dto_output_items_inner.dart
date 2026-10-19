//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_platform_account_list_dto_output_items_inner.g.dart';

/// AdminPlatformAccountListDtoOutputItemsInner
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
abstract class AdminPlatformAccountListDtoOutputItemsInner implements Built<AdminPlatformAccountListDtoOutputItemsInner, AdminPlatformAccountListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'role')
  AdminPlatformAccountListDtoOutputItemsInnerRoleEnum get role;
  // enum roleEnum {  PLATFORM_ADMIN,  PLATFORM_SUPPORT,  };

  @BuiltValueField(wireName: r'status')
  AdminPlatformAccountListDtoOutputItemsInnerStatusEnum get status;
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

  AdminPlatformAccountListDtoOutputItemsInner._();

  factory AdminPlatformAccountListDtoOutputItemsInner([void updates(AdminPlatformAccountListDtoOutputItemsInnerBuilder b)]) = _$AdminPlatformAccountListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPlatformAccountListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPlatformAccountListDtoOutputItemsInner> get serializer => _$AdminPlatformAccountListDtoOutputItemsInnerSerializer();
}

class _$AdminPlatformAccountListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminPlatformAccountListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminPlatformAccountListDtoOutputItemsInner, _$AdminPlatformAccountListDtoOutputItemsInner];

  @override
  final String wireName = r'AdminPlatformAccountListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPlatformAccountListDtoOutputItemsInner object, {
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
      specifiedType: const FullType(AdminPlatformAccountListDtoOutputItemsInnerRoleEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminPlatformAccountListDtoOutputItemsInnerStatusEnum),
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
    AdminPlatformAccountListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPlatformAccountListDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(AdminPlatformAccountListDtoOutputItemsInnerRoleEnum),
          ) as AdminPlatformAccountListDtoOutputItemsInnerRoleEnum;
          result.role = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPlatformAccountListDtoOutputItemsInnerStatusEnum),
          ) as AdminPlatformAccountListDtoOutputItemsInnerStatusEnum;
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
  AdminPlatformAccountListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPlatformAccountListDtoOutputItemsInnerBuilder();
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


class AdminPlatformAccountListDtoOutputItemsInnerRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PLATFORM_ADMIN')
  static const AdminPlatformAccountListDtoOutputItemsInnerRoleEnum PLATFORM_ADMIN = _$adminPlatformAccountListDtoOutputItemsInnerRoleEnum_PLATFORM_ADMIN;
  @BuiltValueEnumConst(wireName: r'PLATFORM_SUPPORT')
  static const AdminPlatformAccountListDtoOutputItemsInnerRoleEnum PLATFORM_SUPPORT = _$adminPlatformAccountListDtoOutputItemsInnerRoleEnum_PLATFORM_SUPPORT;

  static Serializer<AdminPlatformAccountListDtoOutputItemsInnerRoleEnum> get serializer => _$adminPlatformAccountListDtoOutputItemsInnerRoleEnumSerializer;

  const AdminPlatformAccountListDtoOutputItemsInnerRoleEnum._(String name): super(name);

  static BuiltSet<AdminPlatformAccountListDtoOutputItemsInnerRoleEnum> get values => _$adminPlatformAccountListDtoOutputItemsInnerRoleEnumValues;
  static AdminPlatformAccountListDtoOutputItemsInnerRoleEnum valueOf(String name) => _$adminPlatformAccountListDtoOutputItemsInnerRoleEnumValueOf(name);
}

class AdminPlatformAccountListDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminPlatformAccountListDtoOutputItemsInnerStatusEnum ACTIVE = _$adminPlatformAccountListDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const AdminPlatformAccountListDtoOutputItemsInnerStatusEnum LOCKED = _$adminPlatformAccountListDtoOutputItemsInnerStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const AdminPlatformAccountListDtoOutputItemsInnerStatusEnum DISABLED = _$adminPlatformAccountListDtoOutputItemsInnerStatusEnum_DISABLED;

  static Serializer<AdminPlatformAccountListDtoOutputItemsInnerStatusEnum> get serializer => _$adminPlatformAccountListDtoOutputItemsInnerStatusEnumSerializer;

  const AdminPlatformAccountListDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminPlatformAccountListDtoOutputItemsInnerStatusEnum> get values => _$adminPlatformAccountListDtoOutputItemsInnerStatusEnumValues;
  static AdminPlatformAccountListDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminPlatformAccountListDtoOutputItemsInnerStatusEnumValueOf(name);
}

