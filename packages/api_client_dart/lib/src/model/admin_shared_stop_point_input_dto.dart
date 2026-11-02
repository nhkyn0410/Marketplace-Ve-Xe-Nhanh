//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_shared_stop_point_input_dto.g.dart';

/// AdminSharedStopPointInputDto
///
/// Properties:
/// * [name] 
/// * [address] 
/// * [provinceId] 
/// * [wardId] 
/// * [latitude] 
/// * [longitude] 
/// * [description] 
/// * [type] 
/// * [legalBasis] 
/// * [status] 
@BuiltValue()
abstract class AdminSharedStopPointInputDto implements Built<AdminSharedStopPointInputDto, AdminSharedStopPointInputDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

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

  @BuiltValueField(wireName: r'type')
  AdminSharedStopPointInputDtoTypeEnum get type;
  // enum typeEnum {  BUS_STATION,  PICKUP_POINT,  REST_STOP,  };

  @BuiltValueField(wireName: r'legalBasis')
  String? get legalBasis;

  @BuiltValueField(wireName: r'status')
  AdminSharedStopPointInputDtoStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  };

  AdminSharedStopPointInputDto._();

  factory AdminSharedStopPointInputDto([void updates(AdminSharedStopPointInputDtoBuilder b)]) = _$AdminSharedStopPointInputDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSharedStopPointInputDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSharedStopPointInputDto> get serializer => _$AdminSharedStopPointInputDtoSerializer();
}

class _$AdminSharedStopPointInputDtoSerializer implements PrimitiveSerializer<AdminSharedStopPointInputDto> {
  @override
  final Iterable<Type> types = const [AdminSharedStopPointInputDto, _$AdminSharedStopPointInputDto];

  @override
  final String wireName = r'AdminSharedStopPointInputDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSharedStopPointInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
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
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(AdminSharedStopPointInputDtoTypeEnum),
    );
    yield r'legalBasis';
    yield object.legalBasis == null ? null : serializers.serialize(
      object.legalBasis,
      specifiedType: const FullType.nullable(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminSharedStopPointInputDtoStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSharedStopPointInputDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSharedStopPointInputDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSharedStopPointInputDtoTypeEnum),
          ) as AdminSharedStopPointInputDtoTypeEnum;
          result.type = valueDes;
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
            specifiedType: const FullType(AdminSharedStopPointInputDtoStatusEnum),
          ) as AdminSharedStopPointInputDtoStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSharedStopPointInputDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSharedStopPointInputDtoBuilder();
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


class AdminSharedStopPointInputDtoTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUS_STATION')
  static const AdminSharedStopPointInputDtoTypeEnum BUS_STATION = _$adminSharedStopPointInputDtoTypeEnum_BUS_STATION;
  @BuiltValueEnumConst(wireName: r'PICKUP_POINT')
  static const AdminSharedStopPointInputDtoTypeEnum PICKUP_POINT = _$adminSharedStopPointInputDtoTypeEnum_PICKUP_POINT;
  @BuiltValueEnumConst(wireName: r'REST_STOP')
  static const AdminSharedStopPointInputDtoTypeEnum REST_STOP = _$adminSharedStopPointInputDtoTypeEnum_REST_STOP;

  static Serializer<AdminSharedStopPointInputDtoTypeEnum> get serializer => _$adminSharedStopPointInputDtoTypeEnumSerializer;

  const AdminSharedStopPointInputDtoTypeEnum._(String name): super(name);

  static BuiltSet<AdminSharedStopPointInputDtoTypeEnum> get values => _$adminSharedStopPointInputDtoTypeEnumValues;
  static AdminSharedStopPointInputDtoTypeEnum valueOf(String name) => _$adminSharedStopPointInputDtoTypeEnumValueOf(name);
}

class AdminSharedStopPointInputDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminSharedStopPointInputDtoStatusEnum ACTIVE = _$adminSharedStopPointInputDtoStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const AdminSharedStopPointInputDtoStatusEnum INACTIVE = _$adminSharedStopPointInputDtoStatusEnum_INACTIVE;

  static Serializer<AdminSharedStopPointInputDtoStatusEnum> get serializer => _$adminSharedStopPointInputDtoStatusEnumSerializer;

  const AdminSharedStopPointInputDtoStatusEnum._(String name): super(name);

  static BuiltSet<AdminSharedStopPointInputDtoStatusEnum> get values => _$adminSharedStopPointInputDtoStatusEnumValues;
  static AdminSharedStopPointInputDtoStatusEnum valueOf(String name) => _$adminSharedStopPointInputDtoStatusEnumValueOf(name);
}

