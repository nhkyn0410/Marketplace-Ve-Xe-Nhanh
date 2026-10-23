//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_platform_account_list_dto_output_grantable.g.dart';

/// AdminPlatformAccountListDtoOutputGrantable
///
/// Properties:
/// * [PLATFORM_ADMIN] 
/// * [PLATFORM_SUPPORT] 
@BuiltValue()
abstract class AdminPlatformAccountListDtoOutputGrantable implements Built<AdminPlatformAccountListDtoOutputGrantable, AdminPlatformAccountListDtoOutputGrantableBuilder> {
  @BuiltValueField(wireName: r'PLATFORM_ADMIN')
  BuiltList<AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum> get PLATFORM_ADMIN;
  // enum PLATFORM_ADMINEnum {  profile:manage,  loyalty:use,  notification:manage,  incident:create,  journey-log:create,  system:run,  trip:search,  booking:create,  booking:read,  payment:create,  payment:monitor,  refund:request,  vehicle:manage,  vehicle:read,  route:manage,  trip:manage,  checkin:perform,  checkin:read,  trip:operate,  kyc:submit,  kyc:review,  catalog:manage,  content:moderate,  content:manage,  user:manage,  system:read,  finance:read,  finance:configure,  audit:read,  employee:manage,  account:lock,  support:create,  review:create,  support:respond,  support:manage,  dispute:decide,  promotion:manage,  promotion:configure,  loyalty:manage,  access:manage,  transport:read,  manager:manage,  payout:manage,  refund:manage,  };

  @BuiltValueField(wireName: r'PLATFORM_SUPPORT')
  BuiltList<AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum> get PLATFORM_SUPPORT;
  // enum PLATFORM_SUPPORTEnum {  profile:manage,  loyalty:use,  notification:manage,  incident:create,  journey-log:create,  system:run,  trip:search,  booking:create,  booking:read,  payment:create,  payment:monitor,  refund:request,  vehicle:manage,  vehicle:read,  route:manage,  trip:manage,  checkin:perform,  checkin:read,  trip:operate,  kyc:submit,  kyc:review,  catalog:manage,  content:moderate,  content:manage,  user:manage,  system:read,  finance:read,  finance:configure,  audit:read,  employee:manage,  account:lock,  support:create,  review:create,  support:respond,  support:manage,  dispute:decide,  promotion:manage,  promotion:configure,  loyalty:manage,  access:manage,  transport:read,  manager:manage,  payout:manage,  refund:manage,  };

  AdminPlatformAccountListDtoOutputGrantable._();

  factory AdminPlatformAccountListDtoOutputGrantable([void updates(AdminPlatformAccountListDtoOutputGrantableBuilder b)]) = _$AdminPlatformAccountListDtoOutputGrantable;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPlatformAccountListDtoOutputGrantableBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPlatformAccountListDtoOutputGrantable> get serializer => _$AdminPlatformAccountListDtoOutputGrantableSerializer();
}

class _$AdminPlatformAccountListDtoOutputGrantableSerializer implements PrimitiveSerializer<AdminPlatformAccountListDtoOutputGrantable> {
  @override
  final Iterable<Type> types = const [AdminPlatformAccountListDtoOutputGrantable, _$AdminPlatformAccountListDtoOutputGrantable];

  @override
  final String wireName = r'AdminPlatformAccountListDtoOutputGrantable';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPlatformAccountListDtoOutputGrantable object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'PLATFORM_ADMIN';
    yield serializers.serialize(
      object.PLATFORM_ADMIN,
      specifiedType: const FullType(BuiltList, [FullType(AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum)]),
    );
    yield r'PLATFORM_SUPPORT';
    yield serializers.serialize(
      object.PLATFORM_SUPPORT,
      specifiedType: const FullType(BuiltList, [FullType(AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPlatformAccountListDtoOutputGrantable object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPlatformAccountListDtoOutputGrantableBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'PLATFORM_ADMIN':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum)]),
          ) as BuiltList<AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum>;
          result.PLATFORM_ADMIN.replace(valueDes);
          break;
        case r'PLATFORM_SUPPORT':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum)]),
          ) as BuiltList<AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum>;
          result.PLATFORM_SUPPORT.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPlatformAccountListDtoOutputGrantable deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPlatformAccountListDtoOutputGrantableBuilder();
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


class AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'profile:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum profileColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_profileColonManage;
  @BuiltValueEnumConst(wireName: r'loyalty:use')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum loyaltyColonUse = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_loyaltyColonUse;
  @BuiltValueEnumConst(wireName: r'notification:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum notificationColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_notificationColonManage;
  @BuiltValueEnumConst(wireName: r'incident:create')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum incidentColonCreate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_incidentColonCreate;
  @BuiltValueEnumConst(wireName: r'journey-log:create')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum journeyLogColonCreate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_journeyLogColonCreate;
  @BuiltValueEnumConst(wireName: r'system:run')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum systemColonRun = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_systemColonRun;
  @BuiltValueEnumConst(wireName: r'trip:search')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum tripColonSearch = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_tripColonSearch;
  @BuiltValueEnumConst(wireName: r'booking:create')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum bookingColonCreate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_bookingColonCreate;
  @BuiltValueEnumConst(wireName: r'booking:read')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum bookingColonRead = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_bookingColonRead;
  @BuiltValueEnumConst(wireName: r'payment:create')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum paymentColonCreate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_paymentColonCreate;
  @BuiltValueEnumConst(wireName: r'payment:monitor')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum paymentColonMonitor = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_paymentColonMonitor;
  @BuiltValueEnumConst(wireName: r'refund:request')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum refundColonRequest = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_refundColonRequest;
  @BuiltValueEnumConst(wireName: r'vehicle:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum vehicleColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_vehicleColonManage;
  @BuiltValueEnumConst(wireName: r'vehicle:read')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum vehicleColonRead = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_vehicleColonRead;
  @BuiltValueEnumConst(wireName: r'route:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum routeColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_routeColonManage;
  @BuiltValueEnumConst(wireName: r'trip:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum tripColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_tripColonManage;
  @BuiltValueEnumConst(wireName: r'checkin:perform')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum checkinColonPerform = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_checkinColonPerform;
  @BuiltValueEnumConst(wireName: r'checkin:read')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum checkinColonRead = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_checkinColonRead;
  @BuiltValueEnumConst(wireName: r'trip:operate')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum tripColonOperate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_tripColonOperate;
  @BuiltValueEnumConst(wireName: r'kyc:submit')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum kycColonSubmit = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_kycColonSubmit;
  @BuiltValueEnumConst(wireName: r'kyc:review')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum kycColonReview = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_kycColonReview;
  @BuiltValueEnumConst(wireName: r'catalog:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum catalogColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_catalogColonManage;
  @BuiltValueEnumConst(wireName: r'content:moderate')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum contentColonModerate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_contentColonModerate;
  @BuiltValueEnumConst(wireName: r'content:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum contentColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_contentColonManage;
  @BuiltValueEnumConst(wireName: r'user:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum userColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_userColonManage;
  @BuiltValueEnumConst(wireName: r'system:read')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum systemColonRead = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_systemColonRead;
  @BuiltValueEnumConst(wireName: r'finance:read')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum financeColonRead = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_financeColonRead;
  @BuiltValueEnumConst(wireName: r'finance:configure')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum financeColonConfigure = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_financeColonConfigure;
  @BuiltValueEnumConst(wireName: r'audit:read')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum auditColonRead = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_auditColonRead;
  @BuiltValueEnumConst(wireName: r'employee:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum employeeColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_employeeColonManage;
  @BuiltValueEnumConst(wireName: r'account:lock')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum accountColonLock = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_accountColonLock;
  @BuiltValueEnumConst(wireName: r'support:create')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum supportColonCreate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_supportColonCreate;
  @BuiltValueEnumConst(wireName: r'review:create')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum reviewColonCreate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_reviewColonCreate;
  @BuiltValueEnumConst(wireName: r'support:respond')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum supportColonRespond = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_supportColonRespond;
  @BuiltValueEnumConst(wireName: r'support:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum supportColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_supportColonManage;
  @BuiltValueEnumConst(wireName: r'dispute:decide')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum disputeColonDecide = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_disputeColonDecide;
  @BuiltValueEnumConst(wireName: r'promotion:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum promotionColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_promotionColonManage;
  @BuiltValueEnumConst(wireName: r'promotion:configure')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum promotionColonConfigure = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_promotionColonConfigure;
  @BuiltValueEnumConst(wireName: r'loyalty:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum loyaltyColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_loyaltyColonManage;
  @BuiltValueEnumConst(wireName: r'access:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum accessColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_accessColonManage;
  @BuiltValueEnumConst(wireName: r'transport:read')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum transportColonRead = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_transportColonRead;
  @BuiltValueEnumConst(wireName: r'manager:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum managerColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_managerColonManage;
  @BuiltValueEnumConst(wireName: r'payout:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum payoutColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_payoutColonManage;
  @BuiltValueEnumConst(wireName: r'refund:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum refundColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnum_refundColonManage;

  static Serializer<AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum> get serializer => _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnumSerializer;

  const AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum._(String name): super(name);

  static BuiltSet<AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum> get values => _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnumValues;
  static AdminPlatformAccountListDtoOutputGrantablePLATFORM_ADMINEnum valueOf(String name) => _$adminPlatformAccountListDtoOutputGrantablePLATFORMADMINEnumValueOf(name);
}

class AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'profile:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum profileColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_profileColonManage;
  @BuiltValueEnumConst(wireName: r'loyalty:use')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum loyaltyColonUse = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_loyaltyColonUse;
  @BuiltValueEnumConst(wireName: r'notification:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum notificationColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_notificationColonManage;
  @BuiltValueEnumConst(wireName: r'incident:create')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum incidentColonCreate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_incidentColonCreate;
  @BuiltValueEnumConst(wireName: r'journey-log:create')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum journeyLogColonCreate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_journeyLogColonCreate;
  @BuiltValueEnumConst(wireName: r'system:run')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum systemColonRun = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_systemColonRun;
  @BuiltValueEnumConst(wireName: r'trip:search')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum tripColonSearch = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_tripColonSearch;
  @BuiltValueEnumConst(wireName: r'booking:create')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum bookingColonCreate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_bookingColonCreate;
  @BuiltValueEnumConst(wireName: r'booking:read')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum bookingColonRead = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_bookingColonRead;
  @BuiltValueEnumConst(wireName: r'payment:create')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum paymentColonCreate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_paymentColonCreate;
  @BuiltValueEnumConst(wireName: r'payment:monitor')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum paymentColonMonitor = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_paymentColonMonitor;
  @BuiltValueEnumConst(wireName: r'refund:request')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum refundColonRequest = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_refundColonRequest;
  @BuiltValueEnumConst(wireName: r'vehicle:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum vehicleColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_vehicleColonManage;
  @BuiltValueEnumConst(wireName: r'vehicle:read')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum vehicleColonRead = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_vehicleColonRead;
  @BuiltValueEnumConst(wireName: r'route:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum routeColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_routeColonManage;
  @BuiltValueEnumConst(wireName: r'trip:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum tripColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_tripColonManage;
  @BuiltValueEnumConst(wireName: r'checkin:perform')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum checkinColonPerform = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_checkinColonPerform;
  @BuiltValueEnumConst(wireName: r'checkin:read')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum checkinColonRead = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_checkinColonRead;
  @BuiltValueEnumConst(wireName: r'trip:operate')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum tripColonOperate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_tripColonOperate;
  @BuiltValueEnumConst(wireName: r'kyc:submit')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum kycColonSubmit = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_kycColonSubmit;
  @BuiltValueEnumConst(wireName: r'kyc:review')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum kycColonReview = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_kycColonReview;
  @BuiltValueEnumConst(wireName: r'catalog:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum catalogColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_catalogColonManage;
  @BuiltValueEnumConst(wireName: r'content:moderate')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum contentColonModerate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_contentColonModerate;
  @BuiltValueEnumConst(wireName: r'content:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum contentColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_contentColonManage;
  @BuiltValueEnumConst(wireName: r'user:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum userColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_userColonManage;
  @BuiltValueEnumConst(wireName: r'system:read')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum systemColonRead = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_systemColonRead;
  @BuiltValueEnumConst(wireName: r'finance:read')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum financeColonRead = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_financeColonRead;
  @BuiltValueEnumConst(wireName: r'finance:configure')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum financeColonConfigure = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_financeColonConfigure;
  @BuiltValueEnumConst(wireName: r'audit:read')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum auditColonRead = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_auditColonRead;
  @BuiltValueEnumConst(wireName: r'employee:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum employeeColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_employeeColonManage;
  @BuiltValueEnumConst(wireName: r'account:lock')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum accountColonLock = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_accountColonLock;
  @BuiltValueEnumConst(wireName: r'support:create')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum supportColonCreate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_supportColonCreate;
  @BuiltValueEnumConst(wireName: r'review:create')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum reviewColonCreate = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_reviewColonCreate;
  @BuiltValueEnumConst(wireName: r'support:respond')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum supportColonRespond = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_supportColonRespond;
  @BuiltValueEnumConst(wireName: r'support:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum supportColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_supportColonManage;
  @BuiltValueEnumConst(wireName: r'dispute:decide')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum disputeColonDecide = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_disputeColonDecide;
  @BuiltValueEnumConst(wireName: r'promotion:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum promotionColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_promotionColonManage;
  @BuiltValueEnumConst(wireName: r'promotion:configure')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum promotionColonConfigure = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_promotionColonConfigure;
  @BuiltValueEnumConst(wireName: r'loyalty:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum loyaltyColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_loyaltyColonManage;
  @BuiltValueEnumConst(wireName: r'access:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum accessColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_accessColonManage;
  @BuiltValueEnumConst(wireName: r'transport:read')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum transportColonRead = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_transportColonRead;
  @BuiltValueEnumConst(wireName: r'manager:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum managerColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_managerColonManage;
  @BuiltValueEnumConst(wireName: r'payout:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum payoutColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_payoutColonManage;
  @BuiltValueEnumConst(wireName: r'refund:manage')
  static const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum refundColonManage = _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnum_refundColonManage;

  static Serializer<AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum> get serializer => _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnumSerializer;

  const AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum._(String name): super(name);

  static BuiltSet<AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum> get values => _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnumValues;
  static AdminPlatformAccountListDtoOutputGrantablePLATFORM_SUPPORTEnum valueOf(String name) => _$adminPlatformAccountListDtoOutputGrantablePLATFORMSUPPORTEnumValueOf(name);
}

