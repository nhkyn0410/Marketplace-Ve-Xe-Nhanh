//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_operator_stop_point_list_dto_output_items_inner.g.dart';

/// AdminOperatorStopPointListDtoOutputItemsInner
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
abstract class AdminOperatorStopPointListDtoOutputItemsInner implements Built<AdminOperatorStopPointListDtoOutputItemsInner, AdminOperatorStopPointListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'type')
  AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum get type;
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
  AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  SUSPENDED,  };

  @BuiltValueField(wireName: r'suspensionReason')
  String? get suspensionReason;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'routeCount')
  int get routeCount;

  AdminOperatorStopPointListDtoOutputItemsInner._();

  factory AdminOperatorStopPointListDtoOutputItemsInner([void updates(AdminOperatorStopPointListDtoOutputItemsInnerBuilder b)]) = _$AdminOperatorStopPointListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOperatorStopPointListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOperatorStopPointListDtoOutputItemsInner> get serializer => _$AdminOperatorStopPointListDtoOutputItemsInnerSerializer();
}

class _$AdminOperatorStopPointListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminOperatorStopPointListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminOperatorStopPointListDtoOutputItemsInner, _$AdminOperatorStopPointListDtoOutputItemsInner];

  @override
  final String wireName = r'AdminOperatorStopPointListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOperatorStopPointListDtoOutputItemsInner object, {
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
      specifiedType: const FullType(AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum),
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
      specifiedType: const FullType(AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum),
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
    AdminOperatorStopPointListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOperatorStopPointListDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum),
          ) as AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum;
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
            specifiedType: const FullType(AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum),
          ) as AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum;
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
  AdminOperatorStopPointListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOperatorStopPointListDtoOutputItemsInnerBuilder();
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


class AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUS_STATION')
  static const AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum BUS_STATION = _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_BUS_STATION;
  @BuiltValueEnumConst(wireName: r'OFFICE')
  static const AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum OFFICE = _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_OFFICE;
  @BuiltValueEnumConst(wireName: r'REST_STOP')
  static const AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum REST_STOP = _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_REST_STOP;
  @BuiltValueEnumConst(wireName: r'PICKUP_POINT')
  static const AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum PICKUP_POINT = _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnum_PICKUP_POINT;

  static Serializer<AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum> get serializer => _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnumSerializer;

  const AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum._(String name): super(name);

  static BuiltSet<AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum> get values => _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnumValues;
  static AdminOperatorStopPointListDtoOutputItemsInnerTypeEnum valueOf(String name) => _$adminOperatorStopPointListDtoOutputItemsInnerTypeEnumValueOf(name);
}

class AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum ACTIVE = _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum INACTIVE = _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnum_INACTIVE;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum SUSPENDED = _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnum_SUSPENDED;

  static Serializer<AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum> get serializer => _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnumSerializer;

  const AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum> get values => _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnumValues;
  static AdminOperatorStopPointListDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminOperatorStopPointListDtoOutputItemsInnerStatusEnumValueOf(name);
}

