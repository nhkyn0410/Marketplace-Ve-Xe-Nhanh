//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'manager_update_dto.g.dart';

/// ManagerUpdateDto
///
/// Properties:
/// * [permissions] 
/// * [status] 
/// * [reason] 
@BuiltValue()
abstract class ManagerUpdateDto implements Built<ManagerUpdateDto, ManagerUpdateDtoBuilder> {
  @BuiltValueField(wireName: r'permissions')
  BuiltList<ManagerUpdateDtoPermissionsEnum>? get permissions;
  // enum permissionsEnum {  vehicle:manage,  route:manage,  trip:manage,  trip:dispatch,  booking:read,  finance:read,  employee:manage,  support:respond,  promotion:manage,  };

  @BuiltValueField(wireName: r'status')
  ManagerUpdateDtoStatusEnum? get status;
  // enum statusEnum {  ACTIVE,  LOCKED,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  ManagerUpdateDto._();

  factory ManagerUpdateDto([void updates(ManagerUpdateDtoBuilder b)]) = _$ManagerUpdateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ManagerUpdateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ManagerUpdateDto> get serializer => _$ManagerUpdateDtoSerializer();
}

class _$ManagerUpdateDtoSerializer implements PrimitiveSerializer<ManagerUpdateDto> {
  @override
  final Iterable<Type> types = const [ManagerUpdateDto, _$ManagerUpdateDto];

  @override
  final String wireName = r'ManagerUpdateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ManagerUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.permissions != null) {
      yield r'permissions';
      yield serializers.serialize(
        object.permissions,
        specifiedType: const FullType(BuiltList, [FullType(ManagerUpdateDtoPermissionsEnum)]),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(ManagerUpdateDtoStatusEnum),
      );
    }
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ManagerUpdateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ManagerUpdateDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ManagerUpdateDtoPermissionsEnum)]),
          ) as BuiltList<ManagerUpdateDtoPermissionsEnum>?;
          if (valueDes == null) continue;
          result.permissions.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ManagerUpdateDtoStatusEnum),
          ) as ManagerUpdateDtoStatusEnum?;
          if (valueDes == null) continue;
          result.status = valueDes;
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
  ManagerUpdateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ManagerUpdateDtoBuilder();
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


class ManagerUpdateDtoPermissionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'vehicle:manage')
  static const ManagerUpdateDtoPermissionsEnum vehicleColonManage = _$managerUpdateDtoPermissionsEnum_vehicleColonManage;
  @BuiltValueEnumConst(wireName: r'route:manage')
  static const ManagerUpdateDtoPermissionsEnum routeColonManage = _$managerUpdateDtoPermissionsEnum_routeColonManage;
  @BuiltValueEnumConst(wireName: r'trip:manage')
  static const ManagerUpdateDtoPermissionsEnum tripColonManage = _$managerUpdateDtoPermissionsEnum_tripColonManage;
  @BuiltValueEnumConst(wireName: r'trip:dispatch')
  static const ManagerUpdateDtoPermissionsEnum tripColonDispatch = _$managerUpdateDtoPermissionsEnum_tripColonDispatch;
  @BuiltValueEnumConst(wireName: r'booking:read')
  static const ManagerUpdateDtoPermissionsEnum bookingColonRead = _$managerUpdateDtoPermissionsEnum_bookingColonRead;
  @BuiltValueEnumConst(wireName: r'finance:read')
  static const ManagerUpdateDtoPermissionsEnum financeColonRead = _$managerUpdateDtoPermissionsEnum_financeColonRead;
  @BuiltValueEnumConst(wireName: r'employee:manage')
  static const ManagerUpdateDtoPermissionsEnum employeeColonManage = _$managerUpdateDtoPermissionsEnum_employeeColonManage;
  @BuiltValueEnumConst(wireName: r'support:respond')
  static const ManagerUpdateDtoPermissionsEnum supportColonRespond = _$managerUpdateDtoPermissionsEnum_supportColonRespond;
  @BuiltValueEnumConst(wireName: r'promotion:manage')
  static const ManagerUpdateDtoPermissionsEnum promotionColonManage = _$managerUpdateDtoPermissionsEnum_promotionColonManage;

  static Serializer<ManagerUpdateDtoPermissionsEnum> get serializer => _$managerUpdateDtoPermissionsEnumSerializer;

  const ManagerUpdateDtoPermissionsEnum._(String name): super(name);

  static BuiltSet<ManagerUpdateDtoPermissionsEnum> get values => _$managerUpdateDtoPermissionsEnumValues;
  static ManagerUpdateDtoPermissionsEnum valueOf(String name) => _$managerUpdateDtoPermissionsEnumValueOf(name);
}

class ManagerUpdateDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const ManagerUpdateDtoStatusEnum ACTIVE = _$managerUpdateDtoStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LOCKED')
  static const ManagerUpdateDtoStatusEnum LOCKED = _$managerUpdateDtoStatusEnum_LOCKED;

  static Serializer<ManagerUpdateDtoStatusEnum> get serializer => _$managerUpdateDtoStatusEnumSerializer;

  const ManagerUpdateDtoStatusEnum._(String name): super(name);

  static BuiltSet<ManagerUpdateDtoStatusEnum> get values => _$managerUpdateDtoStatusEnumValues;
  static ManagerUpdateDtoStatusEnum valueOf(String name) => _$managerUpdateDtoStatusEnumValueOf(name);
}

