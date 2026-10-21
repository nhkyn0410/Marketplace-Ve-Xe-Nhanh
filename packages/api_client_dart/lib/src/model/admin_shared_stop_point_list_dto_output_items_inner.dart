//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_shared_stop_point_list_dto_output_items_inner.g.dart';

/// AdminSharedStopPointListDtoOutputItemsInner
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
abstract class AdminSharedStopPointListDtoOutputItemsInner implements Built<AdminSharedStopPointListDtoOutputItemsInner, AdminSharedStopPointListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'type')
  AdminSharedStopPointListDtoOutputItemsInnerTypeEnum get type;
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
  AdminSharedStopPointListDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  };

  @BuiltValueField(wireName: r'routeCount')
  int get routeCount;

  AdminSharedStopPointListDtoOutputItemsInner._();

  factory AdminSharedStopPointListDtoOutputItemsInner([void updates(AdminSharedStopPointListDtoOutputItemsInnerBuilder b)]) = _$AdminSharedStopPointListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSharedStopPointListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSharedStopPointListDtoOutputItemsInner> get serializer => _$AdminSharedStopPointListDtoOutputItemsInnerSerializer();
}

class _$AdminSharedStopPointListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminSharedStopPointListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminSharedStopPointListDtoOutputItemsInner, _$AdminSharedStopPointListDtoOutputItemsInner];

  @override
  final String wireName = r'AdminSharedStopPointListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSharedStopPointListDtoOutputItemsInner object, {
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
      specifiedType: const FullType(AdminSharedStopPointListDtoOutputItemsInnerTypeEnum),
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
      specifiedType: const FullType(AdminSharedStopPointListDtoOutputItemsInnerStatusEnum),
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
    AdminSharedStopPointListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSharedStopPointListDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(AdminSharedStopPointListDtoOutputItemsInnerTypeEnum),
          ) as AdminSharedStopPointListDtoOutputItemsInnerTypeEnum;
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
            specifiedType: const FullType(AdminSharedStopPointListDtoOutputItemsInnerStatusEnum),
          ) as AdminSharedStopPointListDtoOutputItemsInnerStatusEnum;
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
  AdminSharedStopPointListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSharedStopPointListDtoOutputItemsInnerBuilder();
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


class AdminSharedStopPointListDtoOutputItemsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUS_STATION')
  static const AdminSharedStopPointListDtoOutputItemsInnerTypeEnum BUS_STATION = _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_BUS_STATION;
  @BuiltValueEnumConst(wireName: r'OFFICE')
  static const AdminSharedStopPointListDtoOutputItemsInnerTypeEnum OFFICE = _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_OFFICE;
  @BuiltValueEnumConst(wireName: r'REST_STOP')
  static const AdminSharedStopPointListDtoOutputItemsInnerTypeEnum REST_STOP = _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_REST_STOP;
  @BuiltValueEnumConst(wireName: r'PICKUP_POINT')
  static const AdminSharedStopPointListDtoOutputItemsInnerTypeEnum PICKUP_POINT = _$adminSharedStopPointListDtoOutputItemsInnerTypeEnum_PICKUP_POINT;

  static Serializer<AdminSharedStopPointListDtoOutputItemsInnerTypeEnum> get serializer => _$adminSharedStopPointListDtoOutputItemsInnerTypeEnumSerializer;

  const AdminSharedStopPointListDtoOutputItemsInnerTypeEnum._(String name): super(name);

  static BuiltSet<AdminSharedStopPointListDtoOutputItemsInnerTypeEnum> get values => _$adminSharedStopPointListDtoOutputItemsInnerTypeEnumValues;
  static AdminSharedStopPointListDtoOutputItemsInnerTypeEnum valueOf(String name) => _$adminSharedStopPointListDtoOutputItemsInnerTypeEnumValueOf(name);
}

class AdminSharedStopPointListDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminSharedStopPointListDtoOutputItemsInnerStatusEnum ACTIVE = _$adminSharedStopPointListDtoOutputItemsInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const AdminSharedStopPointListDtoOutputItemsInnerStatusEnum INACTIVE = _$adminSharedStopPointListDtoOutputItemsInnerStatusEnum_INACTIVE;

  static Serializer<AdminSharedStopPointListDtoOutputItemsInnerStatusEnum> get serializer => _$adminSharedStopPointListDtoOutputItemsInnerStatusEnumSerializer;

  const AdminSharedStopPointListDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminSharedStopPointListDtoOutputItemsInnerStatusEnum> get values => _$adminSharedStopPointListDtoOutputItemsInnerStatusEnumValues;
  static AdminSharedStopPointListDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminSharedStopPointListDtoOutputItemsInnerStatusEnumValueOf(name);
}

