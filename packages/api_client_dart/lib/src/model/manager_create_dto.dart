//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'manager_create_dto.g.dart';

/// ManagerCreateDto
///
/// Properties:
/// * [username] 
/// * [contactEmail] 
/// * [permissions] 
/// * [reason] 
@BuiltValue()
abstract class ManagerCreateDto implements Built<ManagerCreateDto, ManagerCreateDtoBuilder> {
  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'contactEmail')
  String get contactEmail;

  @BuiltValueField(wireName: r'permissions')
  BuiltList<ManagerCreateDtoPermissionsEnum> get permissions;
  // enum permissionsEnum {  vehicle:manage,  route:manage,  trip:manage,  trip:dispatch,  booking:read,  finance:read,  employee:manage,  support:respond,  promotion:manage,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  ManagerCreateDto._();

  factory ManagerCreateDto([void updates(ManagerCreateDtoBuilder b)]) = _$ManagerCreateDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ManagerCreateDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ManagerCreateDto> get serializer => _$ManagerCreateDtoSerializer();
}

class _$ManagerCreateDtoSerializer implements PrimitiveSerializer<ManagerCreateDto> {
  @override
  final Iterable<Type> types = const [ManagerCreateDto, _$ManagerCreateDto];

  @override
  final String wireName = r'ManagerCreateDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ManagerCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'contactEmail';
    yield serializers.serialize(
      object.contactEmail,
      specifiedType: const FullType(String),
    );
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltList, [FullType(ManagerCreateDtoPermissionsEnum)]),
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
    ManagerCreateDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ManagerCreateDtoBuilder result,
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
        case r'contactEmail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contactEmail = valueDes;
          break;
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ManagerCreateDtoPermissionsEnum)]),
          ) as BuiltList<ManagerCreateDtoPermissionsEnum>;
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
  ManagerCreateDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ManagerCreateDtoBuilder();
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


class ManagerCreateDtoPermissionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'vehicle:manage')
  static const ManagerCreateDtoPermissionsEnum vehicleColonManage = _$managerCreateDtoPermissionsEnum_vehicleColonManage;
  @BuiltValueEnumConst(wireName: r'route:manage')
  static const ManagerCreateDtoPermissionsEnum routeColonManage = _$managerCreateDtoPermissionsEnum_routeColonManage;
  @BuiltValueEnumConst(wireName: r'trip:manage')
  static const ManagerCreateDtoPermissionsEnum tripColonManage = _$managerCreateDtoPermissionsEnum_tripColonManage;
  @BuiltValueEnumConst(wireName: r'trip:dispatch')
  static const ManagerCreateDtoPermissionsEnum tripColonDispatch = _$managerCreateDtoPermissionsEnum_tripColonDispatch;
  @BuiltValueEnumConst(wireName: r'booking:read')
  static const ManagerCreateDtoPermissionsEnum bookingColonRead = _$managerCreateDtoPermissionsEnum_bookingColonRead;
  @BuiltValueEnumConst(wireName: r'finance:read')
  static const ManagerCreateDtoPermissionsEnum financeColonRead = _$managerCreateDtoPermissionsEnum_financeColonRead;
  @BuiltValueEnumConst(wireName: r'employee:manage')
  static const ManagerCreateDtoPermissionsEnum employeeColonManage = _$managerCreateDtoPermissionsEnum_employeeColonManage;
  @BuiltValueEnumConst(wireName: r'support:respond')
  static const ManagerCreateDtoPermissionsEnum supportColonRespond = _$managerCreateDtoPermissionsEnum_supportColonRespond;
  @BuiltValueEnumConst(wireName: r'promotion:manage')
  static const ManagerCreateDtoPermissionsEnum promotionColonManage = _$managerCreateDtoPermissionsEnum_promotionColonManage;

  static Serializer<ManagerCreateDtoPermissionsEnum> get serializer => _$managerCreateDtoPermissionsEnumSerializer;

  const ManagerCreateDtoPermissionsEnum._(String name): super(name);

  static BuiltSet<ManagerCreateDtoPermissionsEnum> get values => _$managerCreateDtoPermissionsEnumValues;
  static ManagerCreateDtoPermissionsEnum valueOf(String name) => _$managerCreateDtoPermissionsEnumValueOf(name);
}

