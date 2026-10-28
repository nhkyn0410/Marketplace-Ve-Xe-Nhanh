//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'manager_list_dto_output_items_inner.g.dart';

/// ManagerListDtoOutputItemsInner
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
abstract class ManagerListDtoOutputItemsInner implements Built<ManagerListDtoOutputItemsInner, ManagerListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'contactEmail')
  String? get contactEmail;

  @BuiltValueField(wireName: r'permissions')
  BuiltList<ManagerListDtoOutputItemsInnerPermissionsEnum> get permissions;
  // enum permissionsEnum {  vehicle:manage,  route:manage,  trip:manage,  trip:dispatch,  booking:read,  finance:read,  employee:manage,  support:respond,  promotion:manage,  };

  @BuiltValueField(wireName: r'status')
  ManagerListDtoOutputItemsInnerStatusEnum get status;
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

  ManagerListDtoOutputItemsInner._();

  factory ManagerListDtoOutputItemsInner([void updates(ManagerListDtoOutputItemsInnerBuilder b)]) = _$ManagerListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ManagerListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ManagerListDtoOutputItemsInner> get serializer => _$ManagerListDtoOutputItemsInnerSerializer();
}

class _$ManagerListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<ManagerListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [ManagerListDtoOutputItemsInner, _$ManagerListDtoOutputItemsInner];

  @override
  final String wireName = r'ManagerListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ManagerListDtoOutputItemsInner object, {
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
      specifiedType: const FullType(BuiltList, [FullType(ManagerListDtoOutputItemsInnerPermissionsEnum)]),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ManagerListDtoOutputItemsInnerStatusEnum),
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
    ManagerListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ManagerListDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(BuiltList, [FullType(ManagerListDtoOutputItemsInnerPermissionsEnum)]),
          ) as BuiltList<ManagerListDtoOutputItemsInnerPermissionsEnum>;
          result.permissions.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ManagerListDtoOutputItemsInnerStatusEnum),
          ) as ManagerListDtoOutputItemsInnerStatusEnum;
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
  ManagerListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ManagerListDtoOutputItemsInnerBuilder();
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


class ManagerListDtoOutputItemsInnerPermissionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'vehicle:manage')
  static const ManagerListDtoOutputItemsInnerPermissionsEnum vehicleColonManage = _$managerListDtoOutputItemsInnerPermissionsEnum_vehicleColonManage;
  @BuiltValueEnumConst(wireName: r'route:manage')
  static const ManagerListDtoOutputItemsInnerPermissionsEnum routeColonManage = _$managerListDtoOutputItemsInnerPermissionsEnum_routeColonManage;
  @BuiltValueEnumConst(wireName: r'trip:manage')
  static const ManagerListDtoOutputItemsInnerPermissionsEnum tripColonManage = _$managerListDtoOutputItemsInnerPermissionsEnum_tripColonManage;
  @BuiltValueEnumConst(wireName: r'trip:dispatch')
  static const ManagerListDtoOutputItemsInnerPermissionsEnum tripColonDispatch = _$managerListDtoOutputItemsInnerPermissionsEnum_tripColonDispatch;
  @BuiltValueEnumConst(wireName: r'booking:read')
  static const ManagerListDtoOutputItemsInnerPermissionsEnum bookingColonRead = _$managerListDtoOutputItemsInnerPermissionsEnum_bookingColonRead;
  @BuiltValueEnumConst(wireName: r'finance:read')
  static const ManagerListDtoOutputItemsInnerPermissionsEnum financeColonRead = _$managerListDtoOutputItemsInnerPermissionsEnum_financeColonRead;
  @BuiltValueEnumConst(wireName: r'employee:manage')
  static const ManagerListDtoOutputItemsInnerPermissionsEnum employeeColonManage = _$managerListDtoOutputItemsInnerPermissionsEnum_employeeColonManage;
  @BuiltValueEnumConst(wireName: r'support:respond')
  static const ManagerListDtoOutputItemsInnerPermissionsEnum supportColonRespond = _$managerListDtoOutputItemsInnerPermissionsEnum_supportColonRespond;
  @BuiltValueEnumConst(wireName: r'promotion:manage')
  static const ManagerListDtoOutputItemsInnerPermissionsEnum promotionColonManage = _$managerListDtoOutputItemsInnerPermissionsEnum_promotionColonManage;

  static Serializer<ManagerListDtoOutputItemsInnerPermissionsEnum> get serializer => _$managerListDtoOutputItemsInnerPermissionsEnumSerializer;

  const ManagerListDtoOutputItemsInnerPermissionsEnum._(String name): super(name);

  static BuiltSet<ManagerListDtoOutputItemsInnerPermissionsEnum> get values => _$managerListDtoOutputItemsInnerPermissionsEnumValues;
  static ManagerListDtoOutputItemsInnerPermissionsEnum valueOf(String name) => _$managerListDtoOutputItemsInnerPermissionsEnumValueOf(name);
}

class ManagerListDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const ManagerListDtoOutputItemsInnerStatusEnum ACTIVE = _$managerListDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const ManagerListDtoOutputItemsInnerStatusEnum LOCKED = _$managerListDtoOutputItemsInnerStatusEnum_LOCKED;
  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const ManagerListDtoOutputItemsInnerStatusEnum DISABLED = _$managerListDtoOutputItemsInnerStatusEnum_DISABLED;

  static Serializer<ManagerListDtoOutputItemsInnerStatusEnum> get serializer => _$managerListDtoOutputItemsInnerStatusEnumSerializer;

  const ManagerListDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<ManagerListDtoOutputItemsInnerStatusEnum> get values => _$managerListDtoOutputItemsInnerStatusEnumValues;
  static ManagerListDtoOutputItemsInnerStatusEnum valueOf(String name) => _$managerListDtoOutputItemsInnerStatusEnumValueOf(name);
}

