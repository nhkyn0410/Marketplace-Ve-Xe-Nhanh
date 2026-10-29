//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_route_detail_dto_output_stops_inner.g.dart';

/// AdminRouteDetailDtoOutputStopsInner
///
/// Properties:
/// * [sequence] 
/// * [name] 
/// * [address] 
/// * [type] 
/// * [shared] 
/// * [provinceName] 
/// * [latitude] 
/// * [longitude] 
/// * [allowPickup] 
/// * [allowDropoff] 
/// * [distanceMetersFromPrevious] 
/// * [durationSecondsFromPrevious] 
@BuiltValue()
abstract class AdminRouteDetailDtoOutputStopsInner implements Built<AdminRouteDetailDtoOutputStopsInner, AdminRouteDetailDtoOutputStopsInnerBuilder> {
  @BuiltValueField(wireName: r'sequence')
  int get sequence;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'address')
  String get address;

  @BuiltValueField(wireName: r'type')
  AdminRouteDetailDtoOutputStopsInnerTypeEnum get type;
  // enum typeEnum {  BUS_STATION,  OFFICE,  REST_STOP,  PICKUP_POINT,  };

  @BuiltValueField(wireName: r'shared')
  bool get shared;

  @BuiltValueField(wireName: r'provinceName')
  String? get provinceName;

  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'allowPickup')
  bool get allowPickup;

  @BuiltValueField(wireName: r'allowDropoff')
  bool get allowDropoff;

  @BuiltValueField(wireName: r'distanceMetersFromPrevious')
  int? get distanceMetersFromPrevious;

  @BuiltValueField(wireName: r'durationSecondsFromPrevious')
  int? get durationSecondsFromPrevious;

  AdminRouteDetailDtoOutputStopsInner._();

  factory AdminRouteDetailDtoOutputStopsInner([void updates(AdminRouteDetailDtoOutputStopsInnerBuilder b)]) = _$AdminRouteDetailDtoOutputStopsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRouteDetailDtoOutputStopsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRouteDetailDtoOutputStopsInner> get serializer => _$AdminRouteDetailDtoOutputStopsInnerSerializer();
}

class _$AdminRouteDetailDtoOutputStopsInnerSerializer implements PrimitiveSerializer<AdminRouteDetailDtoOutputStopsInner> {
  @override
  final Iterable<Type> types = const [AdminRouteDetailDtoOutputStopsInner, _$AdminRouteDetailDtoOutputStopsInner];

  @override
  final String wireName = r'AdminRouteDetailDtoOutputStopsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRouteDetailDtoOutputStopsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sequence';
    yield serializers.serialize(
      object.sequence,
      specifiedType: const FullType(int),
    );
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
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(AdminRouteDetailDtoOutputStopsInnerTypeEnum),
    );
    yield r'shared';
    yield serializers.serialize(
      object.shared,
      specifiedType: const FullType(bool),
    );
    yield r'provinceName';
    yield object.provinceName == null ? null : serializers.serialize(
      object.provinceName,
      specifiedType: const FullType.nullable(String),
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
    yield r'allowPickup';
    yield serializers.serialize(
      object.allowPickup,
      specifiedType: const FullType(bool),
    );
    yield r'allowDropoff';
    yield serializers.serialize(
      object.allowDropoff,
      specifiedType: const FullType(bool),
    );
    yield r'distanceMetersFromPrevious';
    yield object.distanceMetersFromPrevious == null ? null : serializers.serialize(
      object.distanceMetersFromPrevious,
      specifiedType: const FullType.nullable(int),
    );
    yield r'durationSecondsFromPrevious';
    yield object.durationSecondsFromPrevious == null ? null : serializers.serialize(
      object.durationSecondsFromPrevious,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRouteDetailDtoOutputStopsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRouteDetailDtoOutputStopsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sequence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sequence = valueDes;
          break;
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminRouteDetailDtoOutputStopsInnerTypeEnum),
          ) as AdminRouteDetailDtoOutputStopsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'shared':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.shared = valueDes;
          break;
        case r'provinceName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.provinceName = valueDes;
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
        case r'allowPickup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.allowPickup = valueDes;
          break;
        case r'allowDropoff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.allowDropoff = valueDes;
          break;
        case r'distanceMetersFromPrevious':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.distanceMetersFromPrevious = valueDes;
          break;
        case r'durationSecondsFromPrevious':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.durationSecondsFromPrevious = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRouteDetailDtoOutputStopsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRouteDetailDtoOutputStopsInnerBuilder();
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


class AdminRouteDetailDtoOutputStopsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUS_STATION')
  static const AdminRouteDetailDtoOutputStopsInnerTypeEnum BUS_STATION = _$adminRouteDetailDtoOutputStopsInnerTypeEnum_BUS_STATION;
  @BuiltValueEnumConst(wireName: r'OFFICE')
  static const AdminRouteDetailDtoOutputStopsInnerTypeEnum OFFICE = _$adminRouteDetailDtoOutputStopsInnerTypeEnum_OFFICE;
  @BuiltValueEnumConst(wireName: r'REST_STOP')
  static const AdminRouteDetailDtoOutputStopsInnerTypeEnum REST_STOP = _$adminRouteDetailDtoOutputStopsInnerTypeEnum_REST_STOP;
  @BuiltValueEnumConst(wireName: r'PICKUP_POINT')
  static const AdminRouteDetailDtoOutputStopsInnerTypeEnum PICKUP_POINT = _$adminRouteDetailDtoOutputStopsInnerTypeEnum_PICKUP_POINT;

  static Serializer<AdminRouteDetailDtoOutputStopsInnerTypeEnum> get serializer => _$adminRouteDetailDtoOutputStopsInnerTypeEnumSerializer;

  const AdminRouteDetailDtoOutputStopsInnerTypeEnum._(String name): super(name);

  static BuiltSet<AdminRouteDetailDtoOutputStopsInnerTypeEnum> get values => _$adminRouteDetailDtoOutputStopsInnerTypeEnumValues;
  static AdminRouteDetailDtoOutputStopsInnerTypeEnum valueOf(String name) => _$adminRouteDetailDtoOutputStopsInnerTypeEnumValueOf(name);
}

