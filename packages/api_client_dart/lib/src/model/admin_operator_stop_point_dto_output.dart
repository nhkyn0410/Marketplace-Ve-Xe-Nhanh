//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_operator_stop_point_dto_output.g.dart';

/// AdminOperatorStopPointDtoOutput
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [type] 
/// * [address] 
/// * [provinceId] 
/// * [wardId] 
/// * [latitude] 
/// * [longitude] 
/// * [description] 
/// * [createdAt] 
/// * [updatedAt] 
/// * [provinceName] 
/// * [status] 
/// * [suspensionReason] 
/// * [operatorId] 
/// * [operatorName] 
/// * [routeCount] 
@BuiltValue()
abstract class AdminOperatorStopPointDtoOutput implements Built<AdminOperatorStopPointDtoOutput, AdminOperatorStopPointDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'type')
  AdminOperatorStopPointDtoOutputTypeEnum get type;
  // enum typeEnum {  BUS_STATION,  OFFICE,  REST_STOP,  PICKUP_POINT,  };

  @BuiltValueField(wireName: r'address')
  String get address;

  @BuiltValueField(wireName: r'provinceId')
  String get provinceId;

  @BuiltValueField(wireName: r'wardId')
  String get wardId;

  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'provinceName')
  String get provinceName;

  @BuiltValueField(wireName: r'status')
  AdminOperatorStopPointDtoOutputStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  SUSPENDED,  };

  @BuiltValueField(wireName: r'suspensionReason')
  String? get suspensionReason;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'routeCount')
  int get routeCount;

  AdminOperatorStopPointDtoOutput._();

  factory AdminOperatorStopPointDtoOutput([void updates(AdminOperatorStopPointDtoOutputBuilder b)]) = _$AdminOperatorStopPointDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOperatorStopPointDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOperatorStopPointDtoOutput> get serializer => _$AdminOperatorStopPointDtoOutputSerializer();
}

class _$AdminOperatorStopPointDtoOutputSerializer implements PrimitiveSerializer<AdminOperatorStopPointDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminOperatorStopPointDtoOutput, _$AdminOperatorStopPointDtoOutput];

  @override
  final String wireName = r'AdminOperatorStopPointDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOperatorStopPointDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(AdminOperatorStopPointDtoOutputTypeEnum),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(String),
    );
    yield r'provinceId';
    yield serializers.serialize(
      object.provinceId,
      specifiedType: const FullType(String),
    );
    yield r'wardId';
    yield serializers.serialize(
      object.wardId,
      specifiedType: const FullType(String),
    );
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'provinceName';
    yield serializers.serialize(
      object.provinceName,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminOperatorStopPointDtoOutputStatusEnum),
    );
    yield r'suspensionReason';
    yield object.suspensionReason == null ? null : serializers.serialize(
      object.suspensionReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'routeCount';
    yield serializers.serialize(
      object.routeCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOperatorStopPointDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOperatorStopPointDtoOutputBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOperatorStopPointDtoOutputTypeEnum),
          ) as AdminOperatorStopPointDtoOutputTypeEnum;
          result.type = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.address = valueDes;
          break;
        case r'provinceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provinceId = valueDes;
          break;
        case r'wardId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.wardId = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.longitude = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'provinceName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provinceName = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOperatorStopPointDtoOutputStatusEnum),
          ) as AdminOperatorStopPointDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'suspensionReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.suspensionReason = valueDes;
          break;
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'routeCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.routeCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOperatorStopPointDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOperatorStopPointDtoOutputBuilder();
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


class AdminOperatorStopPointDtoOutputTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUS_STATION')
  static const AdminOperatorStopPointDtoOutputTypeEnum BUS_STATION = _$adminOperatorStopPointDtoOutputTypeEnum_BUS_STATION;
  @BuiltValueEnumConst(wireName: r'OFFICE')
  static const AdminOperatorStopPointDtoOutputTypeEnum OFFICE = _$adminOperatorStopPointDtoOutputTypeEnum_OFFICE;
  @BuiltValueEnumConst(wireName: r'REST_STOP')
  static const AdminOperatorStopPointDtoOutputTypeEnum REST_STOP = _$adminOperatorStopPointDtoOutputTypeEnum_REST_STOP;
  @BuiltValueEnumConst(wireName: r'PICKUP_POINT')
  static const AdminOperatorStopPointDtoOutputTypeEnum PICKUP_POINT = _$adminOperatorStopPointDtoOutputTypeEnum_PICKUP_POINT;

  static Serializer<AdminOperatorStopPointDtoOutputTypeEnum> get serializer => _$adminOperatorStopPointDtoOutputTypeEnumSerializer;

  const AdminOperatorStopPointDtoOutputTypeEnum._(String name): super(name);

  static BuiltSet<AdminOperatorStopPointDtoOutputTypeEnum> get values => _$adminOperatorStopPointDtoOutputTypeEnumValues;
  static AdminOperatorStopPointDtoOutputTypeEnum valueOf(String name) => _$adminOperatorStopPointDtoOutputTypeEnumValueOf(name);
}

class AdminOperatorStopPointDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminOperatorStopPointDtoOutputStatusEnum ACTIVE = _$adminOperatorStopPointDtoOutputStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const AdminOperatorStopPointDtoOutputStatusEnum INACTIVE = _$adminOperatorStopPointDtoOutputStatusEnum_INACTIVE;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const AdminOperatorStopPointDtoOutputStatusEnum SUSPENDED = _$adminOperatorStopPointDtoOutputStatusEnum_SUSPENDED;

  static Serializer<AdminOperatorStopPointDtoOutputStatusEnum> get serializer => _$adminOperatorStopPointDtoOutputStatusEnumSerializer;

  const AdminOperatorStopPointDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<AdminOperatorStopPointDtoOutputStatusEnum> get values => _$adminOperatorStopPointDtoOutputStatusEnumValues;
  static AdminOperatorStopPointDtoOutputStatusEnum valueOf(String name) => _$adminOperatorStopPointDtoOutputStatusEnumValueOf(name);
}

