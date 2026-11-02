//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/admin_stop_point_proposal_list_dto_output_items_inner_nearby_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_stop_point_proposal_list_dto_output_items_inner.g.dart';

/// AdminStopPointProposalListDtoOutputItemsInner
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
/// * [rejectionReason] 
/// * [catalogStopPointId] 
/// * [operatorId] 
/// * [operatorName] 
/// * [nearby] 
@BuiltValue()
abstract class AdminStopPointProposalListDtoOutputItemsInner implements Built<AdminStopPointProposalListDtoOutputItemsInner, AdminStopPointProposalListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'type')
  AdminStopPointProposalListDtoOutputItemsInnerTypeEnum get type;
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
  String get legalBasis;

  @BuiltValueField(wireName: r'status')
  AdminStopPointProposalListDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  PENDING,  APPROVED,  REJECTED,  };

  @BuiltValueField(wireName: r'rejectionReason')
  String? get rejectionReason;

  @BuiltValueField(wireName: r'catalogStopPointId')
  String? get catalogStopPointId;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'nearby')
  BuiltList<AdminStopPointProposalListDtoOutputItemsInnerNearbyInner> get nearby;

  AdminStopPointProposalListDtoOutputItemsInner._();

  factory AdminStopPointProposalListDtoOutputItemsInner([void updates(AdminStopPointProposalListDtoOutputItemsInnerBuilder b)]) = _$AdminStopPointProposalListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminStopPointProposalListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminStopPointProposalListDtoOutputItemsInner> get serializer => _$AdminStopPointProposalListDtoOutputItemsInnerSerializer();
}

class _$AdminStopPointProposalListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<AdminStopPointProposalListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [AdminStopPointProposalListDtoOutputItemsInner, _$AdminStopPointProposalListDtoOutputItemsInner];

  @override
  final String wireName = r'AdminStopPointProposalListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminStopPointProposalListDtoOutputItemsInner object, {
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
      specifiedType: const FullType(AdminStopPointProposalListDtoOutputItemsInnerTypeEnum),
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
    yield serializers.serialize(
      object.legalBasis,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminStopPointProposalListDtoOutputItemsInnerStatusEnum),
    );
    yield r'rejectionReason';
    yield object.rejectionReason == null ? null : serializers.serialize(
      object.rejectionReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'catalogStopPointId';
    yield object.catalogStopPointId == null ? null : serializers.serialize(
      object.catalogStopPointId,
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
    yield r'nearby';
    yield serializers.serialize(
      object.nearby,
      specifiedType: const FullType(BuiltList, [FullType(AdminStopPointProposalListDtoOutputItemsInnerNearbyInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminStopPointProposalListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminStopPointProposalListDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(AdminStopPointProposalListDtoOutputItemsInnerTypeEnum),
          ) as AdminStopPointProposalListDtoOutputItemsInnerTypeEnum;
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
            specifiedType: const FullType(String),
          ) as String;
          result.legalBasis = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminStopPointProposalListDtoOutputItemsInnerStatusEnum),
          ) as AdminStopPointProposalListDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'rejectionReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.rejectionReason = valueDes;
          break;
        case r'catalogStopPointId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.catalogStopPointId = valueDes;
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
        case r'nearby':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminStopPointProposalListDtoOutputItemsInnerNearbyInner)]),
          ) as BuiltList<AdminStopPointProposalListDtoOutputItemsInnerNearbyInner>;
          result.nearby.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminStopPointProposalListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminStopPointProposalListDtoOutputItemsInnerBuilder();
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


class AdminStopPointProposalListDtoOutputItemsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUS_STATION')
  static const AdminStopPointProposalListDtoOutputItemsInnerTypeEnum BUS_STATION = _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_BUS_STATION;
  @BuiltValueEnumConst(wireName: r'OFFICE')
  static const AdminStopPointProposalListDtoOutputItemsInnerTypeEnum OFFICE = _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_OFFICE;
  @BuiltValueEnumConst(wireName: r'REST_STOP')
  static const AdminStopPointProposalListDtoOutputItemsInnerTypeEnum REST_STOP = _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_REST_STOP;
  @BuiltValueEnumConst(wireName: r'PICKUP_POINT')
  static const AdminStopPointProposalListDtoOutputItemsInnerTypeEnum PICKUP_POINT = _$adminStopPointProposalListDtoOutputItemsInnerTypeEnum_PICKUP_POINT;

  static Serializer<AdminStopPointProposalListDtoOutputItemsInnerTypeEnum> get serializer => _$adminStopPointProposalListDtoOutputItemsInnerTypeEnumSerializer;

  const AdminStopPointProposalListDtoOutputItemsInnerTypeEnum._(String name): super(name);

  static BuiltSet<AdminStopPointProposalListDtoOutputItemsInnerTypeEnum> get values => _$adminStopPointProposalListDtoOutputItemsInnerTypeEnumValues;
  static AdminStopPointProposalListDtoOutputItemsInnerTypeEnum valueOf(String name) => _$adminStopPointProposalListDtoOutputItemsInnerTypeEnumValueOf(name);
}

class AdminStopPointProposalListDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const AdminStopPointProposalListDtoOutputItemsInnerStatusEnum PENDING = _$adminStopPointProposalListDtoOutputItemsInnerStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const AdminStopPointProposalListDtoOutputItemsInnerStatusEnum APPROVED = _$adminStopPointProposalListDtoOutputItemsInnerStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const AdminStopPointProposalListDtoOutputItemsInnerStatusEnum REJECTED = _$adminStopPointProposalListDtoOutputItemsInnerStatusEnum_REJECTED;

  static Serializer<AdminStopPointProposalListDtoOutputItemsInnerStatusEnum> get serializer => _$adminStopPointProposalListDtoOutputItemsInnerStatusEnumSerializer;

  const AdminStopPointProposalListDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminStopPointProposalListDtoOutputItemsInnerStatusEnum> get values => _$adminStopPointProposalListDtoOutputItemsInnerStatusEnumValues;
  static AdminStopPointProposalListDtoOutputItemsInnerStatusEnum valueOf(String name) => _$adminStopPointProposalListDtoOutputItemsInnerStatusEnumValueOf(name);
}

