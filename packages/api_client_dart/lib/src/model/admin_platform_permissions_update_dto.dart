//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_platform_permissions_update_dto.g.dart';

/// AdminPlatformPermissionsUpdateDto
///
/// Properties:
/// * [permissions] 
/// * [reason] 
@BuiltValue()
abstract class AdminPlatformPermissionsUpdateDto implements Built<AdminPlatformPermissionsUpdateDto, AdminPlatformPermissionsUpdateDtoBuilder> {
  @BuiltValueField(wireName: r'permissions')
  BuiltList<AdminPlatformPermissionsUpdateDtoPermissionsEnum> get permissions;
  // enum permissionsEnum {  profile:manage,  loyalty:use,  notification:manage,  incident:create,  journey-log:create,  system:run,  trip:search,  booking:create,  booking:read,  payment:create,  payment:monitor,  refund:request,  vehicle:manage,  vehicle:read,  route:manage,  trip:manage,  checkin:perform,  checkin:read,  trip:operate,  kyc:submit,  kyc:review,  catalog:manage,  content:moderate,  content:manage,  user:manage,  system:read,  finance:read,  finance:configure,  audit:read,  employee:manage,  account:lock,  support:create,  review:create,  support:respond,  support:manage,  dispute:decide,  promotion:manage,  promotion:configure,  loyalty:manage,  access:manage,  transport:read,  manager:manage,  payout:manage,  refund:manage,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminPlatformPermissionsUpdateDto._();

  factory AdminPlatformPermissionsUpdateDto([void updates(AdminPlatformPermissionsUpdateDtoBuilder b)]) = _$AdminPlatformPermissionsUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPlatformPermissionsUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPlatformPermissionsUpdateDto> get serializer => _$AdminPlatformPermissionsUpdateDtoSerializer();
}

class _$AdminPlatformPermissionsUpdateDtoSerializer implements PrimitiveSerializer<AdminPlatformPermissionsUpdateDto> {
  @override
  final Iterable<Type> types = const [AdminPlatformPermissionsUpdateDto, _$AdminPlatformPermissionsUpdateDto];

  @override
  final String wireName = r'AdminPlatformPermissionsUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPlatformPermissionsUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltList, [FullType(AdminPlatformPermissionsUpdateDtoPermissionsEnum)]),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPlatformPermissionsUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPlatformPermissionsUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminPlatformPermissionsUpdateDtoPermissionsEnum)]),
          ) as BuiltList<AdminPlatformPermissionsUpdateDtoPermissionsEnum>;
          result.permissions.replace(valueDes);
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPlatformPermissionsUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPlatformPermissionsUpdateDtoBuilder();
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


class AdminPlatformPermissionsUpdateDtoPermissionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'profile:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum profileColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_profileColonManage;
  @BuiltValueEnumConst(wireName: r'loyalty:use')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum loyaltyColonUse = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_loyaltyColonUse;
  @BuiltValueEnumConst(wireName: r'notification:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum notificationColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_notificationColonManage;
  @BuiltValueEnumConst(wireName: r'incident:create')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum incidentColonCreate = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_incidentColonCreate;
  @BuiltValueEnumConst(wireName: r'journey-log:create')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum journeyLogColonCreate = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_journeyLogColonCreate;
  @BuiltValueEnumConst(wireName: r'system:run')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum systemColonRun = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_systemColonRun;
  @BuiltValueEnumConst(wireName: r'trip:search')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum tripColonSearch = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_tripColonSearch;
  @BuiltValueEnumConst(wireName: r'booking:create')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum bookingColonCreate = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_bookingColonCreate;
  @BuiltValueEnumConst(wireName: r'booking:read')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum bookingColonRead = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_bookingColonRead;
  @BuiltValueEnumConst(wireName: r'payment:create')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum paymentColonCreate = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_paymentColonCreate;
  @BuiltValueEnumConst(wireName: r'payment:monitor')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum paymentColonMonitor = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_paymentColonMonitor;
  @BuiltValueEnumConst(wireName: r'refund:request')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum refundColonRequest = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_refundColonRequest;
  @BuiltValueEnumConst(wireName: r'vehicle:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum vehicleColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_vehicleColonManage;
  @BuiltValueEnumConst(wireName: r'vehicle:read')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum vehicleColonRead = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_vehicleColonRead;
  @BuiltValueEnumConst(wireName: r'route:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum routeColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_routeColonManage;
  @BuiltValueEnumConst(wireName: r'trip:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum tripColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_tripColonManage;
  @BuiltValueEnumConst(wireName: r'checkin:perform')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum checkinColonPerform = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_checkinColonPerform;
  @BuiltValueEnumConst(wireName: r'checkin:read')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum checkinColonRead = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_checkinColonRead;
  @BuiltValueEnumConst(wireName: r'trip:operate')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum tripColonOperate = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_tripColonOperate;
  @BuiltValueEnumConst(wireName: r'kyc:submit')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum kycColonSubmit = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_kycColonSubmit;
  @BuiltValueEnumConst(wireName: r'kyc:review')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum kycColonReview = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_kycColonReview;
  @BuiltValueEnumConst(wireName: r'catalog:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum catalogColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_catalogColonManage;
  @BuiltValueEnumConst(wireName: r'content:moderate')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum contentColonModerate = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_contentColonModerate;
  @BuiltValueEnumConst(wireName: r'content:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum contentColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_contentColonManage;
  @BuiltValueEnumConst(wireName: r'user:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum userColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_userColonManage;
  @BuiltValueEnumConst(wireName: r'system:read')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum systemColonRead = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_systemColonRead;
  @BuiltValueEnumConst(wireName: r'finance:read')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum financeColonRead = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_financeColonRead;
  @BuiltValueEnumConst(wireName: r'finance:configure')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum financeColonConfigure = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_financeColonConfigure;
  @BuiltValueEnumConst(wireName: r'audit:read')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum auditColonRead = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_auditColonRead;
  @BuiltValueEnumConst(wireName: r'employee:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum employeeColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_employeeColonManage;
  @BuiltValueEnumConst(wireName: r'account:lock')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum accountColonLock = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_accountColonLock;
  @BuiltValueEnumConst(wireName: r'support:create')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum supportColonCreate = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_supportColonCreate;
  @BuiltValueEnumConst(wireName: r'review:create')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum reviewColonCreate = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_reviewColonCreate;
  @BuiltValueEnumConst(wireName: r'support:respond')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum supportColonRespond = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_supportColonRespond;
  @BuiltValueEnumConst(wireName: r'support:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum supportColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_supportColonManage;
  @BuiltValueEnumConst(wireName: r'dispute:decide')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum disputeColonDecide = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_disputeColonDecide;
  @BuiltValueEnumConst(wireName: r'promotion:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum promotionColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_promotionColonManage;
  @BuiltValueEnumConst(wireName: r'promotion:configure')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum promotionColonConfigure = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_promotionColonConfigure;
  @BuiltValueEnumConst(wireName: r'loyalty:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum loyaltyColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_loyaltyColonManage;
  @BuiltValueEnumConst(wireName: r'access:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum accessColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_accessColonManage;
  @BuiltValueEnumConst(wireName: r'transport:read')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum transportColonRead = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_transportColonRead;
  @BuiltValueEnumConst(wireName: r'manager:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum managerColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_managerColonManage;
  @BuiltValueEnumConst(wireName: r'payout:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum payoutColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_payoutColonManage;
  @BuiltValueEnumConst(wireName: r'refund:manage')
  static const AdminPlatformPermissionsUpdateDtoPermissionsEnum refundColonManage = _$adminPlatformPermissionsUpdateDtoPermissionsEnum_refundColonManage;

  static Serializer<AdminPlatformPermissionsUpdateDtoPermissionsEnum> get serializer => _$adminPlatformPermissionsUpdateDtoPermissionsEnumSerializer;

  const AdminPlatformPermissionsUpdateDtoPermissionsEnum._(String name): super(name);

  static BuiltSet<AdminPlatformPermissionsUpdateDtoPermissionsEnum> get values => _$adminPlatformPermissionsUpdateDtoPermissionsEnumValues;
  static AdminPlatformPermissionsUpdateDtoPermissionsEnum valueOf(String name) => _$adminPlatformPermissionsUpdateDtoPermissionsEnumValueOf(name);
}

