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

  @BuiltValueField(wireName: r'permissions')
  BuiltList<AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum> get permissions;
  // enum permissionsEnum {  profile:manage,  loyalty:use,  notification:manage,  incident:create,  journey-log:create,  system:run,  trip:search,  booking:create,  booking:read,  payment:create,  payment:monitor,  refund:request,  vehicle:manage,  vehicle:read,  route:manage,  trip:manage,  trip:dispatch,  office:manage,  office:read,  counter:sell,  counter:collect,  counter:read,  checkin:perform,  checkin:read,  trip:operate,  kyc:submit,  kyc:review,  catalog:manage,  content:moderate,  content:manage,  user:manage,  system:read,  finance:read,  finance:configure,  audit:read,  employee:manage,  account:lock,  support:create,  review:create,  support:respond,  support:manage,  dispute:decide,  promotion:manage,  promotion:configure,  loyalty:manage,  access:manage,  transport:read,  manager:manage,  payout:manage,  refund:manage,  };

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
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltList, [FullType(AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum)]),
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
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum)]),
          ) as BuiltList<AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum>;
          result.permissions.replace(valueDes);
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

class AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'profile:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum profileColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_profileColonManage;
  @BuiltValueEnumConst(wireName: r'loyalty:use')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum loyaltyColonUse = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_loyaltyColonUse;
  @BuiltValueEnumConst(wireName: r'notification:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum notificationColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_notificationColonManage;
  @BuiltValueEnumConst(wireName: r'incident:create')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum incidentColonCreate = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_incidentColonCreate;
  @BuiltValueEnumConst(wireName: r'journey-log:create')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum journeyLogColonCreate = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_journeyLogColonCreate;
  @BuiltValueEnumConst(wireName: r'system:run')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum systemColonRun = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_systemColonRun;
  @BuiltValueEnumConst(wireName: r'trip:search')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum tripColonSearch = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_tripColonSearch;
  @BuiltValueEnumConst(wireName: r'booking:create')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum bookingColonCreate = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_bookingColonCreate;
  @BuiltValueEnumConst(wireName: r'booking:read')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum bookingColonRead = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_bookingColonRead;
  @BuiltValueEnumConst(wireName: r'payment:create')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum paymentColonCreate = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_paymentColonCreate;
  @BuiltValueEnumConst(wireName: r'payment:monitor')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum paymentColonMonitor = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_paymentColonMonitor;
  @BuiltValueEnumConst(wireName: r'refund:request')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum refundColonRequest = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_refundColonRequest;
  @BuiltValueEnumConst(wireName: r'vehicle:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum vehicleColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_vehicleColonManage;
  @BuiltValueEnumConst(wireName: r'vehicle:read')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum vehicleColonRead = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_vehicleColonRead;
  @BuiltValueEnumConst(wireName: r'route:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum routeColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_routeColonManage;
  @BuiltValueEnumConst(wireName: r'trip:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum tripColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_tripColonManage;
  @BuiltValueEnumConst(wireName: r'trip:dispatch')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum tripColonDispatch = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_tripColonDispatch;
  @BuiltValueEnumConst(wireName: r'office:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum officeColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_officeColonManage;
  @BuiltValueEnumConst(wireName: r'office:read')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum officeColonRead = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_officeColonRead;
  @BuiltValueEnumConst(wireName: r'counter:sell')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum counterColonSell = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_counterColonSell;
  @BuiltValueEnumConst(wireName: r'counter:collect')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum counterColonCollect = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_counterColonCollect;
  @BuiltValueEnumConst(wireName: r'counter:read')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum counterColonRead = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_counterColonRead;
  @BuiltValueEnumConst(wireName: r'checkin:perform')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum checkinColonPerform = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_checkinColonPerform;
  @BuiltValueEnumConst(wireName: r'checkin:read')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum checkinColonRead = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_checkinColonRead;
  @BuiltValueEnumConst(wireName: r'trip:operate')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum tripColonOperate = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_tripColonOperate;
  @BuiltValueEnumConst(wireName: r'kyc:submit')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum kycColonSubmit = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_kycColonSubmit;
  @BuiltValueEnumConst(wireName: r'kyc:review')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum kycColonReview = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_kycColonReview;
  @BuiltValueEnumConst(wireName: r'catalog:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum catalogColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_catalogColonManage;
  @BuiltValueEnumConst(wireName: r'content:moderate')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum contentColonModerate = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_contentColonModerate;
  @BuiltValueEnumConst(wireName: r'content:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum contentColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_contentColonManage;
  @BuiltValueEnumConst(wireName: r'user:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum userColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_userColonManage;
  @BuiltValueEnumConst(wireName: r'system:read')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum systemColonRead = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_systemColonRead;
  @BuiltValueEnumConst(wireName: r'finance:read')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum financeColonRead = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_financeColonRead;
  @BuiltValueEnumConst(wireName: r'finance:configure')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum financeColonConfigure = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_financeColonConfigure;
  @BuiltValueEnumConst(wireName: r'audit:read')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum auditColonRead = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_auditColonRead;
  @BuiltValueEnumConst(wireName: r'employee:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum employeeColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_employeeColonManage;
  @BuiltValueEnumConst(wireName: r'account:lock')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum accountColonLock = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_accountColonLock;
  @BuiltValueEnumConst(wireName: r'support:create')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum supportColonCreate = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_supportColonCreate;
  @BuiltValueEnumConst(wireName: r'review:create')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum reviewColonCreate = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_reviewColonCreate;
  @BuiltValueEnumConst(wireName: r'support:respond')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum supportColonRespond = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_supportColonRespond;
  @BuiltValueEnumConst(wireName: r'support:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum supportColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_supportColonManage;
  @BuiltValueEnumConst(wireName: r'dispute:decide')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum disputeColonDecide = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_disputeColonDecide;
  @BuiltValueEnumConst(wireName: r'promotion:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum promotionColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_promotionColonManage;
  @BuiltValueEnumConst(wireName: r'promotion:configure')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum promotionColonConfigure = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_promotionColonConfigure;
  @BuiltValueEnumConst(wireName: r'loyalty:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum loyaltyColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_loyaltyColonManage;
  @BuiltValueEnumConst(wireName: r'access:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum accessColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_accessColonManage;
  @BuiltValueEnumConst(wireName: r'transport:read')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum transportColonRead = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_transportColonRead;
  @BuiltValueEnumConst(wireName: r'manager:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum managerColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_managerColonManage;
  @BuiltValueEnumConst(wireName: r'payout:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum payoutColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_payoutColonManage;
  @BuiltValueEnumConst(wireName: r'refund:manage')
  static const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum refundColonManage = _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnum_refundColonManage;

  static Serializer<AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum> get serializer => _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnumSerializer;

  const AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum._(String name): super(name);

  static BuiltSet<AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum> get values => _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnumValues;
  static AdminPlatformAccountListDtoOutputItemsInnerPermissionsEnum valueOf(String name) => _$adminPlatformAccountListDtoOutputItemsInnerPermissionsEnumValueOf(name);
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

