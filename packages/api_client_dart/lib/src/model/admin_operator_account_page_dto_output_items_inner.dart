//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_operator_account_page_dto_output_items_inner.g.dart';

/// AdminOperatorAccountPageDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [username] 
/// * [email] 
/// * [operatorId] 
/// * [operatorName] 
/// * [operatorStatus] 
/// * [role] 
/// * [status] 
/// * [mfaEnabled] 
/// * [passwordChangeRequired] 
/// * [credentialDeliveryPending] 
/// * [temporaryPasswordExpiresAt] 
/// * [createdAt] 
/// * [lastLoginAt] 
@BuiltValue()
abstract class AdminOperatorAccountPageDtoOutputItemsInner implements Built<AdminOperatorAccountPageDtoOutputItemsInner, AdminOperatorAccountPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'operatorStatus')
  AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum get operatorStatus;
  // enum operatorStatusEnum {  ACTIVE,  SUSPENDED,  };

  @BuiltValueField(wireName: r'role')
  AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum get role;
  // enum roleEnum {  OPERATOR_OWNER,  OPERATOR_MANAGER,  };

  @BuiltValueField(wireName: r'status')
  AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  ACTIVE,  LOCKED,  DISABLED,  };

  @BuiltValueField(wireName: r'mfaEnabled')
  bool get mfaEnabled;

  @BuiltValueField(wireName: r'passwordChangeRequired')
  bool get passwordChangeRequired;

  @BuiltValueField(wireName: r'credentialDeliveryPending')
  bool get credentialDeliveryPending;

  @BuiltValueField(wireName: r'temporaryPasswordExpiresAt')
  DateTime? get temporaryPasswordExpiresAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'lastLoginAt')
  DateTime? get lastLoginAt;

  AdminOperatorAccountPageDtoOutputItemsInner._();

  factory AdminOperatorAccountPageDtoOutputItemsInner([void updates(AdminOperatorAccountPageDtoOutputItemsInnerBuilder b)]) = _$AdminOperatorAccountPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOperatorAccountPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOperatorAccountPageDtoOutputItemsInner> get serializer => _$AdminOperatorAccountPageDtoOutputItemsInnerSerializer();
}

class _$AdminOperatorAccountPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminOperatorAccountPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminOperatorAccountPageDtoOutputItemsInner, _$AdminOperatorAccountPageDtoOutputItemsInner];

  @override
  final String wireName = r'AdminOperatorAccountPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOperatorAccountPageDtoOutputItemsInner object, {
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
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'operatorStatus';
    yield serializers.serialize(
      object.operatorStatus,
      specifiedType: const FullType(AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum),
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
    yield r'temporaryPasswordExpiresAt';
    yield object.temporaryPasswordExpiresAt == null ? null : serializers.serialize(
      object.temporaryPasswordExpiresAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'lastLoginAt';
    yield object.lastLoginAt == null ? null : serializers.serialize(
      object.lastLoginAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOperatorAccountPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOperatorAccountPageDtoOutputItemsInnerBuilder result,
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
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'operatorStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum),
          ) as AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum;
          result.operatorStatus = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum),
          ) as AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum;
          result.role = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum),
          ) as AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum;
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
        case r'temporaryPasswordExpiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.temporaryPasswordExpiresAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'lastLoginAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastLoginAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOperatorAccountPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOperatorAccountPageDtoOutputItemsInnerBuilder();
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


class AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum ACTIVE = _$adminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum SUSPENDED = _$adminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum_SUSPENDED;

  static Serializer<AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum> get serializer => _$adminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnumSerializer;

  const AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum._(String name): super(name);

  static BuiltSet<AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum> get values => _$adminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnumValues;
  static AdminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnum valueOf(String name) => _$adminOperatorAccountPageDtoOutputItemsInnerOperatorStatusEnumValueOf(name);
}

class AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPERATOR_OWNER')
  static const AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum OPERATOR_OWNER = _$adminOperatorAccountPageDtoOutputItemsInnerRoleEnum_OPERATOR_OWNER;
  @BuiltValueEnumConst(wireName: r'OPERATOR_MANAGER')
  static const AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum OPERATOR_MANAGER = _$adminOperatorAccountPageDtoOutputItemsInnerRoleEnum_OPERATOR_MANAGER;

  static Serializer<AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum> get serializer => _$adminOperatorAccountPageDtoOutputItemsInnerRoleEnumSerializer;

  const AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum._(String name): super(name);

  static BuiltSet<AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum> get values => _$adminOperatorAccountPageDtoOutputItemsInnerRoleEnumValues;
  static AdminOperatorAccountPageDtoOutputItemsInnerRoleEnum valueOf(String name) => _$adminOperatorAccountPageDtoOutputItemsInnerRoleEnumValueOf(name);
}

class AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum ACTIVE = _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum LOCKED = _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum DISABLED = _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnum_DISABLED;

  static Serializer<AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum> get serializer => _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnumSerializer;

  const AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum> get values => _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnumValues;
  static AdminOperatorAccountPageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminOperatorAccountPageDtoOutputItemsInnerStatusEnumValueOf(name);
}

