//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_operator_account_dto_output.g.dart';

/// AdminOperatorAccountDtoOutput
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
abstract class AdminOperatorAccountDtoOutput implements Built<AdminOperatorAccountDtoOutput, AdminOperatorAccountDtoOutputBuilder> {
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
  AdminOperatorAccountDtoOutputOperatorStatusEnum get operatorStatus;
  // enum operatorStatusEnum {  ACTIVE,  SUSPENDED,  };

  @BuiltValueField(wireName: r'role')
  AdminOperatorAccountDtoOutputRoleEnum get role;
  // enum roleEnum {  OPERATOR_OWNER,  OPERATOR_MANAGER,  };

  @BuiltValueField(wireName: r'status')
  AdminOperatorAccountDtoOutputStatusEnum get status;
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

  AdminOperatorAccountDtoOutput._();

  factory AdminOperatorAccountDtoOutput([void updates(AdminOperatorAccountDtoOutputBuilder b)]) = _$AdminOperatorAccountDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOperatorAccountDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOperatorAccountDtoOutput> get serializer => _$AdminOperatorAccountDtoOutputSerializer();
}

class _$AdminOperatorAccountDtoOutputSerializer implements PrimitiveSerializer<AdminOperatorAccountDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminOperatorAccountDtoOutput, _$AdminOperatorAccountDtoOutput];

  @override
  final String wireName = r'AdminOperatorAccountDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOperatorAccountDtoOutput object, {
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
      specifiedType: const FullType(AdminOperatorAccountDtoOutputOperatorStatusEnum),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(AdminOperatorAccountDtoOutputRoleEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminOperatorAccountDtoOutputStatusEnum),
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
    AdminOperatorAccountDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOperatorAccountDtoOutputBuilder result,
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
            specifiedType: const FullType(AdminOperatorAccountDtoOutputOperatorStatusEnum),
          ) as AdminOperatorAccountDtoOutputOperatorStatusEnum;
          result.operatorStatus = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOperatorAccountDtoOutputRoleEnum),
          ) as AdminOperatorAccountDtoOutputRoleEnum;
          result.role = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOperatorAccountDtoOutputStatusEnum),
          ) as AdminOperatorAccountDtoOutputStatusEnum;
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
  AdminOperatorAccountDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOperatorAccountDtoOutputBuilder();
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


class AdminOperatorAccountDtoOutputOperatorStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminOperatorAccountDtoOutputOperatorStatusEnum ACTIVE = _$adminOperatorAccountDtoOutputOperatorStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const AdminOperatorAccountDtoOutputOperatorStatusEnum SUSPENDED = _$adminOperatorAccountDtoOutputOperatorStatusEnum_SUSPENDED;

  static Serializer<AdminOperatorAccountDtoOutputOperatorStatusEnum> get serializer => _$adminOperatorAccountDtoOutputOperatorStatusEnumSerializer;

  const AdminOperatorAccountDtoOutputOperatorStatusEnum._(String name): super(name);

  static BuiltSet<AdminOperatorAccountDtoOutputOperatorStatusEnum> get values => _$adminOperatorAccountDtoOutputOperatorStatusEnumValues;
  static AdminOperatorAccountDtoOutputOperatorStatusEnum valueOf(String name) => _$adminOperatorAccountDtoOutputOperatorStatusEnumValueOf(name);
}

class AdminOperatorAccountDtoOutputRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPERATOR_OWNER')
  static const AdminOperatorAccountDtoOutputRoleEnum OPERATOR_OWNER = _$adminOperatorAccountDtoOutputRoleEnum_OPERATOR_OWNER;
  @BuiltValueEnumConst(wireName: r'OPERATOR_MANAGER')
  static const AdminOperatorAccountDtoOutputRoleEnum OPERATOR_MANAGER = _$adminOperatorAccountDtoOutputRoleEnum_OPERATOR_MANAGER;

  static Serializer<AdminOperatorAccountDtoOutputRoleEnum> get serializer => _$adminOperatorAccountDtoOutputRoleEnumSerializer;

  const AdminOperatorAccountDtoOutputRoleEnum._(String name): super(name);

  static BuiltSet<AdminOperatorAccountDtoOutputRoleEnum> get values => _$adminOperatorAccountDtoOutputRoleEnumValues;
  static AdminOperatorAccountDtoOutputRoleEnum valueOf(String name) => _$adminOperatorAccountDtoOutputRoleEnumValueOf(name);
}

class AdminOperatorAccountDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminOperatorAccountDtoOutputStatusEnum ACTIVE = _$adminOperatorAccountDtoOutputStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const AdminOperatorAccountDtoOutputStatusEnum LOCKED = _$adminOperatorAccountDtoOutputStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const AdminOperatorAccountDtoOutputStatusEnum DISABLED = _$adminOperatorAccountDtoOutputStatusEnum_DISABLED;

  static Serializer<AdminOperatorAccountDtoOutputStatusEnum> get serializer => _$adminOperatorAccountDtoOutputStatusEnumSerializer;

  const AdminOperatorAccountDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<AdminOperatorAccountDtoOutputStatusEnum> get values => _$adminOperatorAccountDtoOutputStatusEnumValues;
  static AdminOperatorAccountDtoOutputStatusEnum valueOf(String name) => _$adminOperatorAccountDtoOutputStatusEnumValueOf(name);
}

