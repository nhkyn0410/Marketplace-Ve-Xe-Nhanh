//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_shared_stop_point_dto_output.g.dart';

/// AdminSharedStopPointDtoOutput
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
/// * [legalBasis] 
/// * [status] 
/// * [routeCount] 
@BuiltValue()
abstract class AdminSharedStopPointDtoOutput implements Built<AdminSharedStopPointDtoOutput, AdminSharedStopPointDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'type')
  AdminSharedStopPointDtoOutputTypeEnum get type;
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

  @BuiltValueField(wireName: r'legalBasis')
  String? get legalBasis;

  @BuiltValueField(wireName: r'status')
  AdminSharedStopPointDtoOutputStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  };

  @BuiltValueField(wireName: r'routeCount')
  int get routeCount;

  AdminSharedStopPointDtoOutput._();

  factory AdminSharedStopPointDtoOutput([void updates(AdminSharedStopPointDtoOutputBuilder b)]) = _$AdminSharedStopPointDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSharedStopPointDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSharedStopPointDtoOutput> get serializer => _$AdminSharedStopPointDtoOutputSerializer();
}

class _$AdminSharedStopPointDtoOutputSerializer implements PrimitiveSerializer<AdminSharedStopPointDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminSharedStopPointDtoOutput, _$AdminSharedStopPointDtoOutput];

  @override
  final String wireName = r'AdminSharedStopPointDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSharedStopPointDtoOutput object, {
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
      specifiedType: const FullType(AdminSharedStopPointDtoOutputTypeEnum),
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
    yield r'legalBasis';
    yield object.legalBasis == null ? null : serializers.serialize(
      object.legalBasis,
      specifiedType: const FullType.nullable(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminSharedStopPointDtoOutputStatusEnum),
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
    AdminSharedStopPointDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSharedStopPointDtoOutputBuilder result,
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
            specifiedType: const FullType(AdminSharedStopPointDtoOutputTypeEnum),
          ) as AdminSharedStopPointDtoOutputTypeEnum;
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
        case r'legalBasis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.legalBasis = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSharedStopPointDtoOutputStatusEnum),
          ) as AdminSharedStopPointDtoOutputStatusEnum;
          result.status = valueDes;
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
  AdminSharedStopPointDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSharedStopPointDtoOutputBuilder();
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


class AdminSharedStopPointDtoOutputTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUS_STATION')
  static const AdminSharedStopPointDtoOutputTypeEnum BUS_STATION = _$adminSharedStopPointDtoOutputTypeEnum_BUS_STATION;
  @BuiltValueEnumConst(wireName: r'OFFICE')
  static const AdminSharedStopPointDtoOutputTypeEnum OFFICE = _$adminSharedStopPointDtoOutputTypeEnum_OFFICE;
  @BuiltValueEnumConst(wireName: r'REST_STOP')
  static const AdminSharedStopPointDtoOutputTypeEnum REST_STOP = _$adminSharedStopPointDtoOutputTypeEnum_REST_STOP;
  @BuiltValueEnumConst(wireName: r'PICKUP_POINT')
  static const AdminSharedStopPointDtoOutputTypeEnum PICKUP_POINT = _$adminSharedStopPointDtoOutputTypeEnum_PICKUP_POINT;

  static Serializer<AdminSharedStopPointDtoOutputTypeEnum> get serializer => _$adminSharedStopPointDtoOutputTypeEnumSerializer;

  const AdminSharedStopPointDtoOutputTypeEnum._(String name): super(name);

  static BuiltSet<AdminSharedStopPointDtoOutputTypeEnum> get values => _$adminSharedStopPointDtoOutputTypeEnumValues;
  static AdminSharedStopPointDtoOutputTypeEnum valueOf(String name) => _$adminSharedStopPointDtoOutputTypeEnumValueOf(name);
}

class AdminSharedStopPointDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminSharedStopPointDtoOutputStatusEnum ACTIVE = _$adminSharedStopPointDtoOutputStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const AdminSharedStopPointDtoOutputStatusEnum INACTIVE = _$adminSharedStopPointDtoOutputStatusEnum_INACTIVE;

  static Serializer<AdminSharedStopPointDtoOutputStatusEnum> get serializer => _$adminSharedStopPointDtoOutputStatusEnumSerializer;

  const AdminSharedStopPointDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<AdminSharedStopPointDtoOutputStatusEnum> get values => _$adminSharedStopPointDtoOutputStatusEnumValues;
  static AdminSharedStopPointDtoOutputStatusEnum valueOf(String name) => _$adminSharedStopPointDtoOutputStatusEnumValueOf(name);
}

