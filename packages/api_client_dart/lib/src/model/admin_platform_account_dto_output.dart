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
/// * [permissions] 
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

  @BuiltValueField(wireName: r'permissions')
  BuiltList<AdminPlatformAccountDtoOutputPermissionsEnum> get permissions;
  // enum permissionsEnum {  profile:manage,  loyalty:use,  notification:manage,  incident:create,  journey-log:create,  system:run,  trip:search,  booking:create,  booking:read,  payment:create,  payment:monitor,  refund:request,  vehicle:manage,  vehicle:read,  route:manage,  trip:manage,  trip:dispatch,  office:manage,  office:read,  counter:sell,  counter:collect,  counter:read,  checkin:perform,  checkin:read,  trip:operate,  kyc:submit,  kyc:review,  catalog:manage,  content:moderate,  content:manage,  user:manage,  system:read,  finance:read,  finance:configure,  audit:read,  employee:manage,  account:lock,  support:create,  review:create,  support:respond,  support:manage,  dispute:decide,  promotion:manage,  promotion:configure,  loyalty:manage,  access:manage,  transport:read,  manager:manage,  payout:manage,  refund:manage,  };

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
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltList, [FullType(AdminPlatformAccountDtoOutputPermissionsEnum)]),
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
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminPlatformAccountDtoOutputPermissionsEnum)]),
          ) as BuiltList<AdminPlatformAccountDtoOutputPermissionsEnum>;
          result.permissions.replace(valueDes);
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

class AdminPlatformAccountDtoOutputPermissionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'profile:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum profileColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_profileColonManage;
  @BuiltValueEnumConst(wireName: r'loyalty:use')
  static const AdminPlatformAccountDtoOutputPermissionsEnum loyaltyColonUse = _$adminPlatformAccountDtoOutputPermissionsEnum_loyaltyColonUse;
  @BuiltValueEnumConst(wireName: r'notification:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum notificationColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_notificationColonManage;
  @BuiltValueEnumConst(wireName: r'incident:create')
  static const AdminPlatformAccountDtoOutputPermissionsEnum incidentColonCreate = _$adminPlatformAccountDtoOutputPermissionsEnum_incidentColonCreate;
  @BuiltValueEnumConst(wireName: r'journey-log:create')
  static const AdminPlatformAccountDtoOutputPermissionsEnum journeyLogColonCreate = _$adminPlatformAccountDtoOutputPermissionsEnum_journeyLogColonCreate;
  @BuiltValueEnumConst(wireName: r'system:run')
  static const AdminPlatformAccountDtoOutputPermissionsEnum systemColonRun = _$adminPlatformAccountDtoOutputPermissionsEnum_systemColonRun;
  @BuiltValueEnumConst(wireName: r'trip:search')
  static const AdminPlatformAccountDtoOutputPermissionsEnum tripColonSearch = _$adminPlatformAccountDtoOutputPermissionsEnum_tripColonSearch;
  @BuiltValueEnumConst(wireName: r'booking:create')
  static const AdminPlatformAccountDtoOutputPermissionsEnum bookingColonCreate = _$adminPlatformAccountDtoOutputPermissionsEnum_bookingColonCreate;
  @BuiltValueEnumConst(wireName: r'booking:read')
  static const AdminPlatformAccountDtoOutputPermissionsEnum bookingColonRead = _$adminPlatformAccountDtoOutputPermissionsEnum_bookingColonRead;
  @BuiltValueEnumConst(wireName: r'payment:create')
  static const AdminPlatformAccountDtoOutputPermissionsEnum paymentColonCreate = _$adminPlatformAccountDtoOutputPermissionsEnum_paymentColonCreate;
  @BuiltValueEnumConst(wireName: r'payment:monitor')
  static const AdminPlatformAccountDtoOutputPermissionsEnum paymentColonMonitor = _$adminPlatformAccountDtoOutputPermissionsEnum_paymentColonMonitor;
  @BuiltValueEnumConst(wireName: r'refund:request')
  static const AdminPlatformAccountDtoOutputPermissionsEnum refundColonRequest = _$adminPlatformAccountDtoOutputPermissionsEnum_refundColonRequest;
  @BuiltValueEnumConst(wireName: r'vehicle:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum vehicleColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_vehicleColonManage;
  @BuiltValueEnumConst(wireName: r'vehicle:read')
  static const AdminPlatformAccountDtoOutputPermissionsEnum vehicleColonRead = _$adminPlatformAccountDtoOutputPermissionsEnum_vehicleColonRead;
  @BuiltValueEnumConst(wireName: r'route:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum routeColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_routeColonManage;
  @BuiltValueEnumConst(wireName: r'trip:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum tripColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_tripColonManage;
  @BuiltValueEnumConst(wireName: r'trip:dispatch')
  static const AdminPlatformAccountDtoOutputPermissionsEnum tripColonDispatch = _$adminPlatformAccountDtoOutputPermissionsEnum_tripColonDispatch;
  @BuiltValueEnumConst(wireName: r'office:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum officeColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_officeColonManage;
  @BuiltValueEnumConst(wireName: r'office:read')
  static const AdminPlatformAccountDtoOutputPermissionsEnum officeColonRead = _$adminPlatformAccountDtoOutputPermissionsEnum_officeColonRead;
  @BuiltValueEnumConst(wireName: r'counter:sell')
  static const AdminPlatformAccountDtoOutputPermissionsEnum counterColonSell = _$adminPlatformAccountDtoOutputPermissionsEnum_counterColonSell;
  @BuiltValueEnumConst(wireName: r'counter:collect')
  static const AdminPlatformAccountDtoOutputPermissionsEnum counterColonCollect = _$adminPlatformAccountDtoOutputPermissionsEnum_counterColonCollect;
  @BuiltValueEnumConst(wireName: r'counter:read')
  static const AdminPlatformAccountDtoOutputPermissionsEnum counterColonRead = _$adminPlatformAccountDtoOutputPermissionsEnum_counterColonRead;
  @BuiltValueEnumConst(wireName: r'checkin:perform')
  static const AdminPlatformAccountDtoOutputPermissionsEnum checkinColonPerform = _$adminPlatformAccountDtoOutputPermissionsEnum_checkinColonPerform;
  @BuiltValueEnumConst(wireName: r'checkin:read')
  static const AdminPlatformAccountDtoOutputPermissionsEnum checkinColonRead = _$adminPlatformAccountDtoOutputPermissionsEnum_checkinColonRead;
  @BuiltValueEnumConst(wireName: r'trip:operate')
  static const AdminPlatformAccountDtoOutputPermissionsEnum tripColonOperate = _$adminPlatformAccountDtoOutputPermissionsEnum_tripColonOperate;
  @BuiltValueEnumConst(wireName: r'kyc:submit')
  static const AdminPlatformAccountDtoOutputPermissionsEnum kycColonSubmit = _$adminPlatformAccountDtoOutputPermissionsEnum_kycColonSubmit;
  @BuiltValueEnumConst(wireName: r'kyc:review')
  static const AdminPlatformAccountDtoOutputPermissionsEnum kycColonReview = _$adminPlatformAccountDtoOutputPermissionsEnum_kycColonReview;
  @BuiltValueEnumConst(wireName: r'catalog:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum catalogColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_catalogColonManage;
  @BuiltValueEnumConst(wireName: r'content:moderate')
  static const AdminPlatformAccountDtoOutputPermissionsEnum contentColonModerate = _$adminPlatformAccountDtoOutputPermissionsEnum_contentColonModerate;
  @BuiltValueEnumConst(wireName: r'content:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum contentColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_contentColonManage;
  @BuiltValueEnumConst(wireName: r'user:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum userColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_userColonManage;
  @BuiltValueEnumConst(wireName: r'system:read')
  static const AdminPlatformAccountDtoOutputPermissionsEnum systemColonRead = _$adminPlatformAccountDtoOutputPermissionsEnum_systemColonRead;
  @BuiltValueEnumConst(wireName: r'finance:read')
  static const AdminPlatformAccountDtoOutputPermissionsEnum financeColonRead = _$adminPlatformAccountDtoOutputPermissionsEnum_financeColonRead;
  @BuiltValueEnumConst(wireName: r'finance:configure')
  static const AdminPlatformAccountDtoOutputPermissionsEnum financeColonConfigure = _$adminPlatformAccountDtoOutputPermissionsEnum_financeColonConfigure;
  @BuiltValueEnumConst(wireName: r'audit:read')
  static const AdminPlatformAccountDtoOutputPermissionsEnum auditColonRead = _$adminPlatformAccountDtoOutputPermissionsEnum_auditColonRead;
  @BuiltValueEnumConst(wireName: r'employee:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum employeeColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_employeeColonManage;
  @BuiltValueEnumConst(wireName: r'account:lock')
  static const AdminPlatformAccountDtoOutputPermissionsEnum accountColonLock = _$adminPlatformAccountDtoOutputPermissionsEnum_accountColonLock;
  @BuiltValueEnumConst(wireName: r'support:create')
  static const AdminPlatformAccountDtoOutputPermissionsEnum supportColonCreate = _$adminPlatformAccountDtoOutputPermissionsEnum_supportColonCreate;
  @BuiltValueEnumConst(wireName: r'review:create')
  static const AdminPlatformAccountDtoOutputPermissionsEnum reviewColonCreate = _$adminPlatformAccountDtoOutputPermissionsEnum_reviewColonCreate;
  @BuiltValueEnumConst(wireName: r'support:respond')
  static const AdminPlatformAccountDtoOutputPermissionsEnum supportColonRespond = _$adminPlatformAccountDtoOutputPermissionsEnum_supportColonRespond;
  @BuiltValueEnumConst(wireName: r'support:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum supportColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_supportColonManage;
  @BuiltValueEnumConst(wireName: r'dispute:decide')
  static const AdminPlatformAccountDtoOutputPermissionsEnum disputeColonDecide = _$adminPlatformAccountDtoOutputPermissionsEnum_disputeColonDecide;
  @BuiltValueEnumConst(wireName: r'promotion:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum promotionColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_promotionColonManage;
  @BuiltValueEnumConst(wireName: r'promotion:configure')
  static const AdminPlatformAccountDtoOutputPermissionsEnum promotionColonConfigure = _$adminPlatformAccountDtoOutputPermissionsEnum_promotionColonConfigure;
  @BuiltValueEnumConst(wireName: r'loyalty:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum loyaltyColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_loyaltyColonManage;
  @BuiltValueEnumConst(wireName: r'access:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum accessColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_accessColonManage;
  @BuiltValueEnumConst(wireName: r'transport:read')
  static const AdminPlatformAccountDtoOutputPermissionsEnum transportColonRead = _$adminPlatformAccountDtoOutputPermissionsEnum_transportColonRead;
  @BuiltValueEnumConst(wireName: r'manager:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum managerColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_managerColonManage;
  @BuiltValueEnumConst(wireName: r'payout:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum payoutColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_payoutColonManage;
  @BuiltValueEnumConst(wireName: r'refund:manage')
  static const AdminPlatformAccountDtoOutputPermissionsEnum refundColonManage = _$adminPlatformAccountDtoOutputPermissionsEnum_refundColonManage;

  static Serializer<AdminPlatformAccountDtoOutputPermissionsEnum> get serializer => _$adminPlatformAccountDtoOutputPermissionsEnumSerializer;

  const AdminPlatformAccountDtoOutputPermissionsEnum._(String name): super(name);

  static BuiltSet<AdminPlatformAccountDtoOutputPermissionsEnum> get values => _$adminPlatformAccountDtoOutputPermissionsEnumValues;
  static AdminPlatformAccountDtoOutputPermissionsEnum valueOf(String name) => _$adminPlatformAccountDtoOutputPermissionsEnumValueOf(name);
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

