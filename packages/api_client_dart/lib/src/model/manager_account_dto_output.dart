//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'manager_account_dto_output.g.dart';

/// ManagerAccountDtoOutput
///
/// Properties:
/// * [id] 
/// * [username] 
/// * [contactEmail] 
/// * [permissions] 
/// * [status] 
/// * [mfaEnabled] 
/// * [passwordChangeRequired] 
/// * [credentialDeliveryPending] 
/// * [temporaryPasswordExpiresAt] 
/// * [lastLoginAt] 
/// * [createdAt] 
@BuiltValue()
abstract class ManagerAccountDtoOutput implements Built<ManagerAccountDtoOutput, ManagerAccountDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'contactEmail')
  String? get contactEmail;

  @BuiltValueField(wireName: r'permissions')
  BuiltList<ManagerAccountDtoOutputPermissionsEnum> get permissions;
  // enum permissionsEnum {  vehicle:manage,  route:manage,  trip:manage,  booking:read,  finance:read,  employee:manage,  support:respond,  promotion:manage,  };

  @BuiltValueField(wireName: r'status')
  ManagerAccountDtoOutputStatusEnum get status;
  // enum statusEnum {  ACTIVE,  LOCKED,  DISABLED,  };

  @BuiltValueField(wireName: r'mfaEnabled')
  bool get mfaEnabled;

  @BuiltValueField(wireName: r'passwordChangeRequired')
  bool get passwordChangeRequired;

  @BuiltValueField(wireName: r'credentialDeliveryPending')
  bool get credentialDeliveryPending;

  @BuiltValueField(wireName: r'temporaryPasswordExpiresAt')
  DateTime? get temporaryPasswordExpiresAt;

  @BuiltValueField(wireName: r'lastLoginAt')
  DateTime? get lastLoginAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  ManagerAccountDtoOutput._();

  factory ManagerAccountDtoOutput([void updates(ManagerAccountDtoOutputBuilder b)]) = _$ManagerAccountDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ManagerAccountDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ManagerAccountDtoOutput> get serializer => _$ManagerAccountDtoOutputSerializer();
}

class _$ManagerAccountDtoOutputSerializer implements PrimitiveSerializer<ManagerAccountDtoOutput> {
  @override
  final Iterable<Type> types = const [ManagerAccountDtoOutput, _$ManagerAccountDtoOutput];

  @override
  final String wireName = r'ManagerAccountDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ManagerAccountDtoOutput object, {
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
    yield r'contactEmail';
    yield object.contactEmail == null ? null : serializers.serialize(
      object.contactEmail,
      specifiedType: const FullType.nullable(String),
    );
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltList, [FullType(ManagerAccountDtoOutputPermissionsEnum)]),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ManagerAccountDtoOutputStatusEnum),
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
    yield r'lastLoginAt';
    yield object.lastLoginAt == null ? null : serializers.serialize(
      object.lastLoginAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ManagerAccountDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ManagerAccountDtoOutputBuilder result,
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
        case r'contactEmail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.contactEmail = valueDes;
          break;
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ManagerAccountDtoOutputPermissionsEnum)]),
          ) as BuiltList<ManagerAccountDtoOutputPermissionsEnum>;
          result.permissions.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ManagerAccountDtoOutputStatusEnum),
          ) as ManagerAccountDtoOutputStatusEnum;
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
        case r'lastLoginAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastLoginAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ManagerAccountDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ManagerAccountDtoOutputBuilder();
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


class ManagerAccountDtoOutputPermissionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'vehicle:manage')
  static const ManagerAccountDtoOutputPermissionsEnum vehicleColonManage = _$managerAccountDtoOutputPermissionsEnum_vehicleColonManage;
  @BuiltValueEnumConst(wireName: r'route:manage')
  static const ManagerAccountDtoOutputPermissionsEnum routeColonManage = _$managerAccountDtoOutputPermissionsEnum_routeColonManage;
  @BuiltValueEnumConst(wireName: r'trip:manage')
  static const ManagerAccountDtoOutputPermissionsEnum tripColonManage = _$managerAccountDtoOutputPermissionsEnum_tripColonManage;
  @BuiltValueEnumConst(wireName: r'booking:read')
  static const ManagerAccountDtoOutputPermissionsEnum bookingColonRead = _$managerAccountDtoOutputPermissionsEnum_bookingColonRead;
  @BuiltValueEnumConst(wireName: r'finance:read')
  static const ManagerAccountDtoOutputPermissionsEnum financeColonRead = _$managerAccountDtoOutputPermissionsEnum_financeColonRead;
  @BuiltValueEnumConst(wireName: r'employee:manage')
  static const ManagerAccountDtoOutputPermissionsEnum employeeColonManage = _$managerAccountDtoOutputPermissionsEnum_employeeColonManage;
  @BuiltValueEnumConst(wireName: r'support:respond')
  static const ManagerAccountDtoOutputPermissionsEnum supportColonRespond = _$managerAccountDtoOutputPermissionsEnum_supportColonRespond;
  @BuiltValueEnumConst(wireName: r'promotion:manage')
  static const ManagerAccountDtoOutputPermissionsEnum promotionColonManage = _$managerAccountDtoOutputPermissionsEnum_promotionColonManage;

  static Serializer<ManagerAccountDtoOutputPermissionsEnum> get serializer => _$managerAccountDtoOutputPermissionsEnumSerializer;

  const ManagerAccountDtoOutputPermissionsEnum._(String name): super(name);

  static BuiltSet<ManagerAccountDtoOutputPermissionsEnum> get values => _$managerAccountDtoOutputPermissionsEnumValues;
  static ManagerAccountDtoOutputPermissionsEnum valueOf(String name) => _$managerAccountDtoOutputPermissionsEnumValueOf(name);
}

class ManagerAccountDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const ManagerAccountDtoOutputStatusEnum ACTIVE = _$managerAccountDtoOutputStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const ManagerAccountDtoOutputStatusEnum LOCKED = _$managerAccountDtoOutputStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const ManagerAccountDtoOutputStatusEnum DISABLED = _$managerAccountDtoOutputStatusEnum_DISABLED;

  static Serializer<ManagerAccountDtoOutputStatusEnum> get serializer => _$managerAccountDtoOutputStatusEnumSerializer;

  const ManagerAccountDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<ManagerAccountDtoOutputStatusEnum> get values => _$managerAccountDtoOutputStatusEnumValues;
  static ManagerAccountDtoOutputStatusEnum valueOf(String name) => _$managerAccountDtoOutputStatusEnumValueOf(name);
}

