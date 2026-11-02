//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_stop_point_proposal_approval_dto.g.dart';

/// AdminStopPointProposalApprovalDto
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
@BuiltValue()
abstract class AdminStopPointProposalApprovalDto implements Built<AdminStopPointProposalApprovalDto, AdminStopPointProposalApprovalDtoBuilder> {
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
  AdminStopPointProposalApprovalDtoTypeEnum get type;
  // enum typeEnum {  BUS_STATION,  PICKUP_POINT,  };

  @BuiltValueField(wireName: r'legalBasis')
  String get legalBasis;

  AdminStopPointProposalApprovalDto._();

  factory AdminStopPointProposalApprovalDto([void updates(AdminStopPointProposalApprovalDtoBuilder b)]) = _$AdminStopPointProposalApprovalDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminStopPointProposalApprovalDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminStopPointProposalApprovalDto> get serializer => _$AdminStopPointProposalApprovalDtoSerializer();
}

class _$AdminStopPointProposalApprovalDtoSerializer implements PrimitiveSerializer<AdminStopPointProposalApprovalDto> {
  @override
  final Iterable<Type> types = const [AdminStopPointProposalApprovalDto, _$AdminStopPointProposalApprovalDto];

  @override
  final String wireName = r'AdminStopPointProposalApprovalDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminStopPointProposalApprovalDto object, {
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
      specifiedType: const FullType(AdminStopPointProposalApprovalDtoTypeEnum),
    );
    yield r'legalBasis';
    yield serializers.serialize(
      object.legalBasis,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminStopPointProposalApprovalDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminStopPointProposalApprovalDtoBuilder result,
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
            specifiedType: const FullType(AdminStopPointProposalApprovalDtoTypeEnum),
          ) as AdminStopPointProposalApprovalDtoTypeEnum;
          result.type = valueDes;
          break;
        case r'legalBasis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.legalBasis = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminStopPointProposalApprovalDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminStopPointProposalApprovalDtoBuilder();
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


class AdminStopPointProposalApprovalDtoTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUS_STATION')
  static const AdminStopPointProposalApprovalDtoTypeEnum BUS_STATION = _$adminStopPointProposalApprovalDtoTypeEnum_BUS_STATION;
  @BuiltValueEnumConst(wireName: r'PICKUP_POINT')
  static const AdminStopPointProposalApprovalDtoTypeEnum PICKUP_POINT = _$adminStopPointProposalApprovalDtoTypeEnum_PICKUP_POINT;

  static Serializer<AdminStopPointProposalApprovalDtoTypeEnum> get serializer => _$adminStopPointProposalApprovalDtoTypeEnumSerializer;

  const AdminStopPointProposalApprovalDtoTypeEnum._(String name): super(name);

  static BuiltSet<AdminStopPointProposalApprovalDtoTypeEnum> get values => _$adminStopPointProposalApprovalDtoTypeEnumValues;
  static AdminStopPointProposalApprovalDtoTypeEnum valueOf(String name) => _$adminStopPointProposalApprovalDtoTypeEnumValueOf(name);
}

