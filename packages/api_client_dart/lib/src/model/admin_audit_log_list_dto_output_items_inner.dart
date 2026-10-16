//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/admin_audit_log_list_dto_output_items_inner_operator.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_audit_log_list_dto_output_items_inner.g.dart';

/// AdminAuditLogListDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [createdAt] 
/// * [actorId] 
/// * [actorName] 
/// * [actorRole] 
/// * [actorType] 
/// * [action] 
/// * [module] 
/// * [result] 
/// * [targetType] 
/// * [targetId] 
/// * [operator_] 
/// * [reason] 
@BuiltValue()
abstract class AdminAuditLogListDtoOutputItemsInner implements Built<AdminAuditLogListDtoOutputItemsInner, AdminAuditLogListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'actorId')
  String? get actorId;

  @BuiltValueField(wireName: r'actorName')
  String? get actorName;

  @BuiltValueField(wireName: r'actorRole')
  String? get actorRole;

  @BuiltValueField(wireName: r'actorType')
  AdminAuditLogListDtoOutputItemsInnerActorTypeEnum get actorType;
  // enum actorTypeEnum {  PLATFORM,  OPERATOR,  EMPLOYEE,  PASSENGER,  SYSTEM,  UNKNOWN,  };

  @BuiltValueField(wireName: r'action')
  String get action;

  @BuiltValueField(wireName: r'module')
  AdminAuditLogListDtoOutputItemsInnerModuleEnum get module;
  // enum moduleEnum {  AUTH,  ACCOUNT,  OPERATOR_KYC,  CATALOG,  STOP_POINT,  VEHICLE,  TRIP,  FARE,  AUDIT,  OTHER,  };

  @BuiltValueField(wireName: r'result')
  AdminAuditLogListDtoOutputItemsInnerResultEnum get result;
  // enum resultEnum {  SUCCESS,  FAILURE,  };

  @BuiltValueField(wireName: r'targetType')
  String get targetType;

  @BuiltValueField(wireName: r'targetId')
  String get targetId;

  @BuiltValueField(wireName: r'operator')
  AdminAuditLogListDtoOutputItemsInnerOperator? get operator_;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  AdminAuditLogListDtoOutputItemsInner._();

  factory AdminAuditLogListDtoOutputItemsInner([void updates(AdminAuditLogListDtoOutputItemsInnerBuilder b)]) = _$AdminAuditLogListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAuditLogListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAuditLogListDtoOutputItemsInner> get serializer => _$AdminAuditLogListDtoOutputItemsInnerSerializer();
}

class _$AdminAuditLogListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminAuditLogListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminAuditLogListDtoOutputItemsInner, _$AdminAuditLogListDtoOutputItemsInner];

  @override
  final String wireName = r'AdminAuditLogListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAuditLogListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'actorId';
    yield object.actorId == null ? null : serializers.serialize(
      object.actorId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'actorName';
    yield object.actorName == null ? null : serializers.serialize(
      object.actorName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'actorRole';
    yield object.actorRole == null ? null : serializers.serialize(
      object.actorRole,
      specifiedType: const FullType.nullable(String),
    );
    yield r'actorType';
    yield serializers.serialize(
      object.actorType,
      specifiedType: const FullType(AdminAuditLogListDtoOutputItemsInnerActorTypeEnum),
    );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(String),
    );
    yield r'module';
    yield serializers.serialize(
      object.module,
      specifiedType: const FullType(AdminAuditLogListDtoOutputItemsInnerModuleEnum),
    );
    yield r'result';
    yield serializers.serialize(
      object.result,
      specifiedType: const FullType(AdminAuditLogListDtoOutputItemsInnerResultEnum),
    );
    yield r'targetType';
    yield serializers.serialize(
      object.targetType,
      specifiedType: const FullType(String),
    );
    yield r'targetId';
    yield serializers.serialize(
      object.targetId,
      specifiedType: const FullType(String),
    );
    yield r'operator';
    yield object.operator_ == null ? null : serializers.serialize(
      object.operator_,
      specifiedType: const FullType.nullable(AdminAuditLogListDtoOutputItemsInnerOperator),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAuditLogListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminAuditLogListDtoOutputItemsInnerBuilder result,
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
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'actorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.actorId = valueDes;
          break;
        case r'actorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.actorName = valueDes;
          break;
        case r'actorRole':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.actorRole = valueDes;
          break;
        case r'actorType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminAuditLogListDtoOutputItemsInnerActorTypeEnum),
          ) as AdminAuditLogListDtoOutputItemsInnerActorTypeEnum;
          result.actorType = valueDes;
          break;
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.action = valueDes;
          break;
        case r'module':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminAuditLogListDtoOutputItemsInnerModuleEnum),
          ) as AdminAuditLogListDtoOutputItemsInnerModuleEnum;
          result.module = valueDes;
          break;
        case r'result':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminAuditLogListDtoOutputItemsInnerResultEnum),
          ) as AdminAuditLogListDtoOutputItemsInnerResultEnum;
          result.result = valueDes;
          break;
        case r'targetType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.targetType = valueDes;
          break;
        case r'targetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.targetId = valueDes;
          break;
        case r'operator':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminAuditLogListDtoOutputItemsInnerOperator),
          ) as AdminAuditLogListDtoOutputItemsInnerOperator?;
          if (valueDes == null) continue;
          result.operator_.replace(valueDes);
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  AdminAuditLogListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAuditLogListDtoOutputItemsInnerBuilder();
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


class AdminAuditLogListDtoOutputItemsInnerActorTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const AdminAuditLogListDtoOutputItemsInnerActorTypeEnum PLATFORM = _$adminAuditLogListDtoOutputItemsInnerActorTypeEnum_PLATFORM;
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const AdminAuditLogListDtoOutputItemsInnerActorTypeEnum OPERATOR = _$adminAuditLogListDtoOutputItemsInnerActorTypeEnum_OPERATOR;
  @BuiltValueEnumConst(wireName: r'EMPLOYEE')
  static const AdminAuditLogListDtoOutputItemsInnerActorTypeEnum EMPLOYEE = _$adminAuditLogListDtoOutputItemsInnerActorTypeEnum_EMPLOYEE;
  @BuiltValueEnumConst(wireName: r'PASSENGER')
  static const AdminAuditLogListDtoOutputItemsInnerActorTypeEnum PASSENGER = _$adminAuditLogListDtoOutputItemsInnerActorTypeEnum_PASSENGER;
  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const AdminAuditLogListDtoOutputItemsInnerActorTypeEnum SYSTEM = _$adminAuditLogListDtoOutputItemsInnerActorTypeEnum_SYSTEM;
  @BuiltValueEnumConst(wireName: r'UNKNOWN')
  static const AdminAuditLogListDtoOutputItemsInnerActorTypeEnum UNKNOWN = _$adminAuditLogListDtoOutputItemsInnerActorTypeEnum_UNKNOWN;

  static Serializer<AdminAuditLogListDtoOutputItemsInnerActorTypeEnum> get serializer => _$adminAuditLogListDtoOutputItemsInnerActorTypeEnumSerializer;

  const AdminAuditLogListDtoOutputItemsInnerActorTypeEnum._(String name): super(name);

  static BuiltSet<AdminAuditLogListDtoOutputItemsInnerActorTypeEnum> get values => _$adminAuditLogListDtoOutputItemsInnerActorTypeEnumValues;
  static AdminAuditLogListDtoOutputItemsInnerActorTypeEnum valueOf(String name) => _$adminAuditLogListDtoOutputItemsInnerActorTypeEnumValueOf(name);
}

class AdminAuditLogListDtoOutputItemsInnerModuleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AUTH')
  static const AdminAuditLogListDtoOutputItemsInnerModuleEnum AUTH = _$adminAuditLogListDtoOutputItemsInnerModuleEnum_AUTH;
  @BuiltValueEnumConst(wireName: r'ACCOUNT')
  static const AdminAuditLogListDtoOutputItemsInnerModuleEnum ACCOUNT = _$adminAuditLogListDtoOutputItemsInnerModuleEnum_ACCOUNT;
  @BuiltValueEnumConst(wireName: r'OPERATOR_KYC')
  static const AdminAuditLogListDtoOutputItemsInnerModuleEnum OPERATOR_KYC = _$adminAuditLogListDtoOutputItemsInnerModuleEnum_OPERATOR_KYC;
  @BuiltValueEnumConst(wireName: r'CATALOG')
  static const AdminAuditLogListDtoOutputItemsInnerModuleEnum CATALOG = _$adminAuditLogListDtoOutputItemsInnerModuleEnum_CATALOG;
  @BuiltValueEnumConst(wireName: r'STOP_POINT')
  static const AdminAuditLogListDtoOutputItemsInnerModuleEnum STOP_POINT = _$adminAuditLogListDtoOutputItemsInnerModuleEnum_STOP_POINT;
  @BuiltValueEnumConst(wireName: r'VEHICLE')
  static const AdminAuditLogListDtoOutputItemsInnerModuleEnum VEHICLE = _$adminAuditLogListDtoOutputItemsInnerModuleEnum_VEHICLE;
  @BuiltValueEnumConst(wireName: r'TRIP')
  static const AdminAuditLogListDtoOutputItemsInnerModuleEnum TRIP = _$adminAuditLogListDtoOutputItemsInnerModuleEnum_TRIP;
  @BuiltValueEnumConst(wireName: r'FARE')
  static const AdminAuditLogListDtoOutputItemsInnerModuleEnum FARE = _$adminAuditLogListDtoOutputItemsInnerModuleEnum_FARE;
  @BuiltValueEnumConst(wireName: r'AUDIT')
  static const AdminAuditLogListDtoOutputItemsInnerModuleEnum AUDIT = _$adminAuditLogListDtoOutputItemsInnerModuleEnum_AUDIT;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const AdminAuditLogListDtoOutputItemsInnerModuleEnum OTHER = _$adminAuditLogListDtoOutputItemsInnerModuleEnum_OTHER;

  static Serializer<AdminAuditLogListDtoOutputItemsInnerModuleEnum> get serializer => _$adminAuditLogListDtoOutputItemsInnerModuleEnumSerializer;

  const AdminAuditLogListDtoOutputItemsInnerModuleEnum._(String name): super(name);

  static BuiltSet<AdminAuditLogListDtoOutputItemsInnerModuleEnum> get values => _$adminAuditLogListDtoOutputItemsInnerModuleEnumValues;
  static AdminAuditLogListDtoOutputItemsInnerModuleEnum valueOf(String name) => _$adminAuditLogListDtoOutputItemsInnerModuleEnumValueOf(name);
}

class AdminAuditLogListDtoOutputItemsInnerResultEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const AdminAuditLogListDtoOutputItemsInnerResultEnum SUCCESS = _$adminAuditLogListDtoOutputItemsInnerResultEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILURE')
  static const AdminAuditLogListDtoOutputItemsInnerResultEnum FAILURE = _$adminAuditLogListDtoOutputItemsInnerResultEnum_FAILURE;

  static Serializer<AdminAuditLogListDtoOutputItemsInnerResultEnum> get serializer => _$adminAuditLogListDtoOutputItemsInnerResultEnumSerializer;

  const AdminAuditLogListDtoOutputItemsInnerResultEnum._(String name): super(name);

  static BuiltSet<AdminAuditLogListDtoOutputItemsInnerResultEnum> get values => _$adminAuditLogListDtoOutputItemsInnerResultEnumValues;
  static AdminAuditLogListDtoOutputItemsInnerResultEnum valueOf(String name) => _$adminAuditLogListDtoOutputItemsInnerResultEnumValueOf(name);
}

