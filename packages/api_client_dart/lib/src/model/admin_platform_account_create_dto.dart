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
/// * [permissions] 
@BuiltValue()
abstract class AdminPlatformAccountCreateDto implements Built<AdminPlatformAccountCreateDto, AdminPlatformAccountCreateDtoBuilder> {
  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'role')
  AdminPlatformAccountCreateDtoRoleEnum get role;
  // enum roleEnum {  PLATFORM_ADMIN,  PLATFORM_SUPPORT,  };

  @BuiltValueField(wireName: r'permissions')
  BuiltList<AdminPlatformAccountCreateDtoPermissionsEnum> get permissions;
  // enum permissionsEnum {  profile:manage,  loyalty:use,  notification:manage,  incident:create,  journey-log:create,  system:run,  trip:search,  booking:create,  booking:read,  payment:create,  payment:monitor,  refund:request,  vehicle:manage,  vehicle:read,  route:manage,  trip:manage,  trip:dispatch,  office:manage,  office:read,  counter:sell,  counter:collect,  counter:read,  checkin:perform,  checkin:read,  trip:operate,  kyc:submit,  kyc:review,  catalog:manage,  content:moderate,  content:manage,  user:manage,  system:read,  finance:read,  finance:configure,  audit:read,  employee:manage,  account:lock,  support:create,  review:create,  support:respond,  support:manage,  dispute:decide,  promotion:manage,  promotion:configure,  loyalty:manage,  access:manage,  transport:read,  manager:manage,  payout:manage,  refund:manage,  };

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
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltList, [FullType(AdminPlatformAccountCreateDtoPermissionsEnum)]),
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
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminPlatformAccountCreateDtoPermissionsEnum)]),
          ) as BuiltList<AdminPlatformAccountCreateDtoPermissionsEnum>;
          result.permissions.replace(valueDes);
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

class AdminPlatformAccountCreateDtoPermissionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'profile:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum profileColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_profileColonManage;
  @BuiltValueEnumConst(wireName: r'loyalty:use')
  static const AdminPlatformAccountCreateDtoPermissionsEnum loyaltyColonUse = _$adminPlatformAccountCreateDtoPermissionsEnum_loyaltyColonUse;
  @BuiltValueEnumConst(wireName: r'notification:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum notificationColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_notificationColonManage;
  @BuiltValueEnumConst(wireName: r'incident:create')
  static const AdminPlatformAccountCreateDtoPermissionsEnum incidentColonCreate = _$adminPlatformAccountCreateDtoPermissionsEnum_incidentColonCreate;
  @BuiltValueEnumConst(wireName: r'journey-log:create')
  static const AdminPlatformAccountCreateDtoPermissionsEnum journeyLogColonCreate = _$adminPlatformAccountCreateDtoPermissionsEnum_journeyLogColonCreate;
  @BuiltValueEnumConst(wireName: r'system:run')
  static const AdminPlatformAccountCreateDtoPermissionsEnum systemColonRun = _$adminPlatformAccountCreateDtoPermissionsEnum_systemColonRun;
  @BuiltValueEnumConst(wireName: r'trip:search')
  static const AdminPlatformAccountCreateDtoPermissionsEnum tripColonSearch = _$adminPlatformAccountCreateDtoPermissionsEnum_tripColonSearch;
  @BuiltValueEnumConst(wireName: r'booking:create')
  static const AdminPlatformAccountCreateDtoPermissionsEnum bookingColonCreate = _$adminPlatformAccountCreateDtoPermissionsEnum_bookingColonCreate;
  @BuiltValueEnumConst(wireName: r'booking:read')
  static const AdminPlatformAccountCreateDtoPermissionsEnum bookingColonRead = _$adminPlatformAccountCreateDtoPermissionsEnum_bookingColonRead;
  @BuiltValueEnumConst(wireName: r'payment:create')
  static const AdminPlatformAccountCreateDtoPermissionsEnum paymentColonCreate = _$adminPlatformAccountCreateDtoPermissionsEnum_paymentColonCreate;
  @BuiltValueEnumConst(wireName: r'payment:monitor')
  static const AdminPlatformAccountCreateDtoPermissionsEnum paymentColonMonitor = _$adminPlatformAccountCreateDtoPermissionsEnum_paymentColonMonitor;
  @BuiltValueEnumConst(wireName: r'refund:request')
  static const AdminPlatformAccountCreateDtoPermissionsEnum refundColonRequest = _$adminPlatformAccountCreateDtoPermissionsEnum_refundColonRequest;
  @BuiltValueEnumConst(wireName: r'vehicle:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum vehicleColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_vehicleColonManage;
  @BuiltValueEnumConst(wireName: r'vehicle:read')
  static const AdminPlatformAccountCreateDtoPermissionsEnum vehicleColonRead = _$adminPlatformAccountCreateDtoPermissionsEnum_vehicleColonRead;
  @BuiltValueEnumConst(wireName: r'route:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum routeColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_routeColonManage;
  @BuiltValueEnumConst(wireName: r'trip:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum tripColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_tripColonManage;
  @BuiltValueEnumConst(wireName: r'trip:dispatch')
  static const AdminPlatformAccountCreateDtoPermissionsEnum tripColonDispatch = _$adminPlatformAccountCreateDtoPermissionsEnum_tripColonDispatch;
  @BuiltValueEnumConst(wireName: r'office:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum officeColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_officeColonManage;
  @BuiltValueEnumConst(wireName: r'office:read')
  static const AdminPlatformAccountCreateDtoPermissionsEnum officeColonRead = _$adminPlatformAccountCreateDtoPermissionsEnum_officeColonRead;
  @BuiltValueEnumConst(wireName: r'counter:sell')
  static const AdminPlatformAccountCreateDtoPermissionsEnum counterColonSell = _$adminPlatformAccountCreateDtoPermissionsEnum_counterColonSell;
  @BuiltValueEnumConst(wireName: r'counter:collect')
  static const AdminPlatformAccountCreateDtoPermissionsEnum counterColonCollect = _$adminPlatformAccountCreateDtoPermissionsEnum_counterColonCollect;
  @BuiltValueEnumConst(wireName: r'counter:read')
  static const AdminPlatformAccountCreateDtoPermissionsEnum counterColonRead = _$adminPlatformAccountCreateDtoPermissionsEnum_counterColonRead;
  @BuiltValueEnumConst(wireName: r'checkin:perform')
  static const AdminPlatformAccountCreateDtoPermissionsEnum checkinColonPerform = _$adminPlatformAccountCreateDtoPermissionsEnum_checkinColonPerform;
  @BuiltValueEnumConst(wireName: r'checkin:read')
  static const AdminPlatformAccountCreateDtoPermissionsEnum checkinColonRead = _$adminPlatformAccountCreateDtoPermissionsEnum_checkinColonRead;
  @BuiltValueEnumConst(wireName: r'trip:operate')
  static const AdminPlatformAccountCreateDtoPermissionsEnum tripColonOperate = _$adminPlatformAccountCreateDtoPermissionsEnum_tripColonOperate;
  @BuiltValueEnumConst(wireName: r'kyc:submit')
  static const AdminPlatformAccountCreateDtoPermissionsEnum kycColonSubmit = _$adminPlatformAccountCreateDtoPermissionsEnum_kycColonSubmit;
  @BuiltValueEnumConst(wireName: r'kyc:review')
  static const AdminPlatformAccountCreateDtoPermissionsEnum kycColonReview = _$adminPlatformAccountCreateDtoPermissionsEnum_kycColonReview;
  @BuiltValueEnumConst(wireName: r'catalog:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum catalogColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_catalogColonManage;
  @BuiltValueEnumConst(wireName: r'content:moderate')
  static const AdminPlatformAccountCreateDtoPermissionsEnum contentColonModerate = _$adminPlatformAccountCreateDtoPermissionsEnum_contentColonModerate;
  @BuiltValueEnumConst(wireName: r'content:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum contentColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_contentColonManage;
  @BuiltValueEnumConst(wireName: r'user:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum userColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_userColonManage;
  @BuiltValueEnumConst(wireName: r'system:read')
  static const AdminPlatformAccountCreateDtoPermissionsEnum systemColonRead = _$adminPlatformAccountCreateDtoPermissionsEnum_systemColonRead;
  @BuiltValueEnumConst(wireName: r'finance:read')
  static const AdminPlatformAccountCreateDtoPermissionsEnum financeColonRead = _$adminPlatformAccountCreateDtoPermissionsEnum_financeColonRead;
  @BuiltValueEnumConst(wireName: r'finance:configure')
  static const AdminPlatformAccountCreateDtoPermissionsEnum financeColonConfigure = _$adminPlatformAccountCreateDtoPermissionsEnum_financeColonConfigure;
  @BuiltValueEnumConst(wireName: r'audit:read')
  static const AdminPlatformAccountCreateDtoPermissionsEnum auditColonRead = _$adminPlatformAccountCreateDtoPermissionsEnum_auditColonRead;
  @BuiltValueEnumConst(wireName: r'employee:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum employeeColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_employeeColonManage;
  @BuiltValueEnumConst(wireName: r'account:lock')
  static const AdminPlatformAccountCreateDtoPermissionsEnum accountColonLock = _$adminPlatformAccountCreateDtoPermissionsEnum_accountColonLock;
  @BuiltValueEnumConst(wireName: r'support:create')
  static const AdminPlatformAccountCreateDtoPermissionsEnum supportColonCreate = _$adminPlatformAccountCreateDtoPermissionsEnum_supportColonCreate;
  @BuiltValueEnumConst(wireName: r'review:create')
  static const AdminPlatformAccountCreateDtoPermissionsEnum reviewColonCreate = _$adminPlatformAccountCreateDtoPermissionsEnum_reviewColonCreate;
  @BuiltValueEnumConst(wireName: r'support:respond')
  static const AdminPlatformAccountCreateDtoPermissionsEnum supportColonRespond = _$adminPlatformAccountCreateDtoPermissionsEnum_supportColonRespond;
  @BuiltValueEnumConst(wireName: r'support:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum supportColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_supportColonManage;
  @BuiltValueEnumConst(wireName: r'dispute:decide')
  static const AdminPlatformAccountCreateDtoPermissionsEnum disputeColonDecide = _$adminPlatformAccountCreateDtoPermissionsEnum_disputeColonDecide;
  @BuiltValueEnumConst(wireName: r'promotion:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum promotionColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_promotionColonManage;
  @BuiltValueEnumConst(wireName: r'promotion:configure')
  static const AdminPlatformAccountCreateDtoPermissionsEnum promotionColonConfigure = _$adminPlatformAccountCreateDtoPermissionsEnum_promotionColonConfigure;
  @BuiltValueEnumConst(wireName: r'loyalty:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum loyaltyColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_loyaltyColonManage;
  @BuiltValueEnumConst(wireName: r'access:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum accessColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_accessColonManage;
  @BuiltValueEnumConst(wireName: r'transport:read')
  static const AdminPlatformAccountCreateDtoPermissionsEnum transportColonRead = _$adminPlatformAccountCreateDtoPermissionsEnum_transportColonRead;
  @BuiltValueEnumConst(wireName: r'manager:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum managerColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_managerColonManage;
  @BuiltValueEnumConst(wireName: r'payout:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum payoutColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_payoutColonManage;
  @BuiltValueEnumConst(wireName: r'refund:manage')
  static const AdminPlatformAccountCreateDtoPermissionsEnum refundColonManage = _$adminPlatformAccountCreateDtoPermissionsEnum_refundColonManage;

  static Serializer<AdminPlatformAccountCreateDtoPermissionsEnum> get serializer => _$adminPlatformAccountCreateDtoPermissionsEnumSerializer;

  const AdminPlatformAccountCreateDtoPermissionsEnum._(String name): super(name);

  static BuiltSet<AdminPlatformAccountCreateDtoPermissionsEnum> get values => _$adminPlatformAccountCreateDtoPermissionsEnumValues;
  static AdminPlatformAccountCreateDtoPermissionsEnum valueOf(String name) => _$adminPlatformAccountCreateDtoPermissionsEnumValueOf(name);
}

