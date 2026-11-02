//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/admin_audit_log_list_dto_output_items_inner.dart';
import 'package:api_client_dart/src/model/admin_audit_log_list_dto_output_items_inner_operator.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_audit_log_detail_dto_output.g.dart';

/// AdminAuditLogDetailDtoOutput
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
/// * [before] 
/// * [after] 
/// * [ip] 
/// * [device] 
/// * [requestId] 
/// * [related] 
@BuiltValue()
abstract class AdminAuditLogDetailDtoOutput implements Built<AdminAuditLogDetailDtoOutput, AdminAuditLogDetailDtoOutputBuilder> {
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
  AdminAuditLogDetailDtoOutputActorTypeEnum get actorType;
  // enum actorTypeEnum {  PLATFORM,  OPERATOR,  EMPLOYEE,  PASSENGER,  SYSTEM,  UNKNOWN,  };

  @BuiltValueField(wireName: r'action')
  String get action;

  @BuiltValueField(wireName: r'module')
  AdminAuditLogDetailDtoOutputModuleEnum get module;
  // enum moduleEnum {  AUTH,  ACCOUNT,  OPERATOR_KYC,  CATALOG,  STOP_POINT,  VEHICLE,  TRIP,  FARE,  AUDIT,  OTHER,  };

  @BuiltValueField(wireName: r'result')
  AdminAuditLogDetailDtoOutputResultEnum get result;
  // enum resultEnum {  SUCCESS,  FAILURE,  };

  @BuiltValueField(wireName: r'targetType')
  String get targetType;

  @BuiltValueField(wireName: r'targetId')
  String get targetId;

  @BuiltValueField(wireName: r'operator')
  AdminAuditLogListDtoOutputItemsInnerOperator? get operator_;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'before')
  BuiltMap<String, JsonObject?>? get before;

  @BuiltValueField(wireName: r'after')
  BuiltMap<String, JsonObject?>? get after;

  @BuiltValueField(wireName: r'ip')
  String? get ip;

  @BuiltValueField(wireName: r'device')
  String? get device;

  @BuiltValueField(wireName: r'requestId')
  String? get requestId;

  @BuiltValueField(wireName: r'related')
  BuiltList<AdminAuditLogListDtoOutputItemsInner> get related;

  AdminAuditLogDetailDtoOutput._();

  factory AdminAuditLogDetailDtoOutput([void updates(AdminAuditLogDetailDtoOutputBuilder b)]) = _$AdminAuditLogDetailDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAuditLogDetailDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAuditLogDetailDtoOutput> get serializer => _$AdminAuditLogDetailDtoOutputSerializer();
}

class _$AdminAuditLogDetailDtoOutputSerializer implements PrimitiveSerializer<AdminAuditLogDetailDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminAuditLogDetailDtoOutput, _$AdminAuditLogDetailDtoOutput];

  @override
  final String wireName = r'AdminAuditLogDetailDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAuditLogDetailDtoOutput object, {
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
      specifiedType: const FullType(AdminAuditLogDetailDtoOutputActorTypeEnum),
    );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(String),
    );
    yield r'module';
    yield serializers.serialize(
      object.module,
      specifiedType: const FullType(AdminAuditLogDetailDtoOutputModuleEnum),
    );
    yield r'result';
    yield serializers.serialize(
      object.result,
      specifiedType: const FullType(AdminAuditLogDetailDtoOutputResultEnum),
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
    yield r'before';
    yield object.before == null ? null : serializers.serialize(
      object.before,
      specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'after';
    yield object.after == null ? null : serializers.serialize(
      object.after,
      specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'ip';
    yield object.ip == null ? null : serializers.serialize(
      object.ip,
      specifiedType: const FullType.nullable(String),
    );
    yield r'device';
    yield object.device == null ? null : serializers.serialize(
      object.device,
      specifiedType: const FullType.nullable(String),
    );
    yield r'requestId';
    yield object.requestId == null ? null : serializers.serialize(
      object.requestId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'related';
    yield serializers.serialize(
      object.related,
      specifiedType: const FullType(BuiltList, [FullType(AdminAuditLogListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAuditLogDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminAuditLogDetailDtoOutputBuilder result,
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
            specifiedType: const FullType(AdminAuditLogDetailDtoOutputActorTypeEnum),
          ) as AdminAuditLogDetailDtoOutputActorTypeEnum;
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
            specifiedType: const FullType(AdminAuditLogDetailDtoOutputModuleEnum),
          ) as AdminAuditLogDetailDtoOutputModuleEnum;
          result.module = valueDes;
          break;
        case r'result':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminAuditLogDetailDtoOutputResultEnum),
          ) as AdminAuditLogDetailDtoOutputResultEnum;
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
        case r'before':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.before.replace(valueDes);
          break;
        case r'after':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.after.replace(valueDes);
          break;
        case r'ip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ip = valueDes;
          break;
        case r'device':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.device = valueDes;
          break;
        case r'requestId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.requestId = valueDes;
          break;
        case r'related':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminAuditLogListDtoOutputItemsInner)]),
          ) as BuiltList<AdminAuditLogListDtoOutputItemsInner>;
          result.related.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAuditLogDetailDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAuditLogDetailDtoOutputBuilder();
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


class AdminAuditLogDetailDtoOutputActorTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const AdminAuditLogDetailDtoOutputActorTypeEnum PLATFORM = _$adminAuditLogDetailDtoOutputActorTypeEnum_PLATFORM;
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const AdminAuditLogDetailDtoOutputActorTypeEnum OPERATOR = _$adminAuditLogDetailDtoOutputActorTypeEnum_OPERATOR;
  @BuiltValueEnumConst(wireName: r'EMPLOYEE')
  static const AdminAuditLogDetailDtoOutputActorTypeEnum EMPLOYEE = _$adminAuditLogDetailDtoOutputActorTypeEnum_EMPLOYEE;
  @BuiltValueEnumConst(wireName: r'PASSENGER')
  static const AdminAuditLogDetailDtoOutputActorTypeEnum PASSENGER = _$adminAuditLogDetailDtoOutputActorTypeEnum_PASSENGER;
  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const AdminAuditLogDetailDtoOutputActorTypeEnum SYSTEM = _$adminAuditLogDetailDtoOutputActorTypeEnum_SYSTEM;
  @BuiltValueEnumConst(wireName: r'UNKNOWN')
  static const AdminAuditLogDetailDtoOutputActorTypeEnum UNKNOWN = _$adminAuditLogDetailDtoOutputActorTypeEnum_UNKNOWN;

  static Serializer<AdminAuditLogDetailDtoOutputActorTypeEnum> get serializer => _$adminAuditLogDetailDtoOutputActorTypeEnumSerializer;

  const AdminAuditLogDetailDtoOutputActorTypeEnum._(String name): super(name);

  static BuiltSet<AdminAuditLogDetailDtoOutputActorTypeEnum> get values => _$adminAuditLogDetailDtoOutputActorTypeEnumValues;
  static AdminAuditLogDetailDtoOutputActorTypeEnum valueOf(String name) => _$adminAuditLogDetailDtoOutputActorTypeEnumValueOf(name);
}

class AdminAuditLogDetailDtoOutputModuleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AUTH')
  static const AdminAuditLogDetailDtoOutputModuleEnum AUTH = _$adminAuditLogDetailDtoOutputModuleEnum_AUTH;
  @BuiltValueEnumConst(wireName: r'ACCOUNT')
  static const AdminAuditLogDetailDtoOutputModuleEnum ACCOUNT = _$adminAuditLogDetailDtoOutputModuleEnum_ACCOUNT;
  @BuiltValueEnumConst(wireName: r'OPERATOR_KYC')
  static const AdminAuditLogDetailDtoOutputModuleEnum OPERATOR_KYC = _$adminAuditLogDetailDtoOutputModuleEnum_OPERATOR_KYC;
  @BuiltValueEnumConst(wireName: r'CATALOG')
  static const AdminAuditLogDetailDtoOutputModuleEnum CATALOG = _$adminAuditLogDetailDtoOutputModuleEnum_CATALOG;
  @BuiltValueEnumConst(wireName: r'STOP_POINT')
  static const AdminAuditLogDetailDtoOutputModuleEnum STOP_POINT = _$adminAuditLogDetailDtoOutputModuleEnum_STOP_POINT;
  @BuiltValueEnumConst(wireName: r'VEHICLE')
  static const AdminAuditLogDetailDtoOutputModuleEnum VEHICLE = _$adminAuditLogDetailDtoOutputModuleEnum_VEHICLE;
  @BuiltValueEnumConst(wireName: r'TRIP')
  static const AdminAuditLogDetailDtoOutputModuleEnum TRIP = _$adminAuditLogDetailDtoOutputModuleEnum_TRIP;
  @BuiltValueEnumConst(wireName: r'FARE')
  static const AdminAuditLogDetailDtoOutputModuleEnum FARE = _$adminAuditLogDetailDtoOutputModuleEnum_FARE;
  @BuiltValueEnumConst(wireName: r'AUDIT')
  static const AdminAuditLogDetailDtoOutputModuleEnum AUDIT = _$adminAuditLogDetailDtoOutputModuleEnum_AUDIT;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const AdminAuditLogDetailDtoOutputModuleEnum OTHER = _$adminAuditLogDetailDtoOutputModuleEnum_OTHER;

  static Serializer<AdminAuditLogDetailDtoOutputModuleEnum> get serializer => _$adminAuditLogDetailDtoOutputModuleEnumSerializer;

  const AdminAuditLogDetailDtoOutputModuleEnum._(String name): super(name);

  static BuiltSet<AdminAuditLogDetailDtoOutputModuleEnum> get values => _$adminAuditLogDetailDtoOutputModuleEnumValues;
  static AdminAuditLogDetailDtoOutputModuleEnum valueOf(String name) => _$adminAuditLogDetailDtoOutputModuleEnumValueOf(name);
}

class AdminAuditLogDetailDtoOutputResultEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const AdminAuditLogDetailDtoOutputResultEnum SUCCESS = _$adminAuditLogDetailDtoOutputResultEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILURE')
  static const AdminAuditLogDetailDtoOutputResultEnum FAILURE = _$adminAuditLogDetailDtoOutputResultEnum_FAILURE;

  static Serializer<AdminAuditLogDetailDtoOutputResultEnum> get serializer => _$adminAuditLogDetailDtoOutputResultEnumSerializer;

  const AdminAuditLogDetailDtoOutputResultEnum._(String name): super(name);

  static BuiltSet<AdminAuditLogDetailDtoOutputResultEnum> get values => _$adminAuditLogDetailDtoOutputResultEnumValues;
  static AdminAuditLogDetailDtoOutputResultEnum valueOf(String name) => _$adminAuditLogDetailDtoOutputResultEnumValueOf(name);
}

