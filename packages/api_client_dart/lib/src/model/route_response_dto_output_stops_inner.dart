//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_response_dto_output_stops_inner.g.dart';

/// RouteResponseDtoOutputStopsInner
///
/// Properties:
/// * [sequence] 
/// * [role] 
/// * [catalogStopPointId] 
/// * [stopPointId] 
/// * [name] 
/// * [type] 
/// * [address] 
/// * [latitude] 
/// * [longitude] 
/// * [note] 
/// * [allowPickup] 
/// * [allowDropoff] 
/// * [distanceMetersFromPrevious] 
/// * [durationSecondsFromPrevious] 
@BuiltValue()
abstract class RouteResponseDtoOutputStopsInner implements Built<RouteResponseDtoOutputStopsInner, RouteResponseDtoOutputStopsInnerBuilder> {
  @BuiltValueField(wireName: r'sequence')
  int get sequence;

  @BuiltValueField(wireName: r'role')
  RouteResponseDtoOutputStopsInnerRoleEnum get role;
  // enum roleEnum {  ORIGIN,  INTERMEDIATE,  DESTINATION,  };

  @BuiltValueField(wireName: r'catalogStopPointId')
  String? get catalogStopPointId;

  @BuiltValueField(wireName: r'stopPointId')
  String? get stopPointId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'type')
  RouteResponseDtoOutputStopsInnerTypeEnum get type;
  // enum typeEnum {  BUS_STATION,  OFFICE,  REST_STOP,  PICKUP_POINT,  };

  @BuiltValueField(wireName: r'address')
  String get address;

  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'allowPickup')
  bool get allowPickup;

  @BuiltValueField(wireName: r'allowDropoff')
  bool get allowDropoff;

  @BuiltValueField(wireName: r'distanceMetersFromPrevious')
  int? get distanceMetersFromPrevious;

  @BuiltValueField(wireName: r'durationSecondsFromPrevious')
  int? get durationSecondsFromPrevious;

  RouteResponseDtoOutputStopsInner._();

  factory RouteResponseDtoOutputStopsInner([void updates(RouteResponseDtoOutputStopsInnerBuilder b)]) = _$RouteResponseDtoOutputStopsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteResponseDtoOutputStopsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteResponseDtoOutputStopsInner> get serializer => _$RouteResponseDtoOutputStopsInnerSerializer();
}

class _$RouteResponseDtoOutputStopsInnerSerializer implements PrimitiveSerializer<RouteResponseDtoOutputStopsInner> {
  @override
  final Iterable<Type> types = const [RouteResponseDtoOutputStopsInner, _$RouteResponseDtoOutputStopsInner];

  @override
  final String wireName = r'RouteResponseDtoOutputStopsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteResponseDtoOutputStopsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sequence';
    yield serializers.serialize(
      object.sequence,
      specifiedType: const FullType(int),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(RouteResponseDtoOutputStopsInnerRoleEnum),
    );
    yield r'catalogStopPointId';
    yield object.catalogStopPointId == null ? null : serializers.serialize(
      object.catalogStopPointId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'stopPointId';
    yield object.stopPointId == null ? null : serializers.serialize(
      object.stopPointId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(RouteResponseDtoOutputStopsInnerTypeEnum),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
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
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
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
    RouteResponseDtoOutputStopsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RouteResponseDtoOutputStopsInnerBuilder result,
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
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteResponseDtoOutputStopsInnerRoleEnum),
          ) as RouteResponseDtoOutputStopsInnerRoleEnum;
          result.role = valueDes;
          break;
        case r'catalogStopPointId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.catalogStopPointId = valueDes;
          break;
        case r'stopPointId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.stopPointId = valueDes;
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
            specifiedType: const FullType(RouteResponseDtoOutputStopsInnerTypeEnum),
          ) as RouteResponseDtoOutputStopsInnerTypeEnum;
          result.type = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.address = valueDes;
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
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
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
  RouteResponseDtoOutputStopsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteResponseDtoOutputStopsInnerBuilder();
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


class RouteResponseDtoOutputStopsInnerRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ORIGIN')
  static const RouteResponseDtoOutputStopsInnerRoleEnum ORIGIN = _$routeResponseDtoOutputStopsInnerRoleEnum_ORIGIN;
  @BuiltValueEnumConst(wireName: r'INTERMEDIATE')
  static const RouteResponseDtoOutputStopsInnerRoleEnum INTERMEDIATE = _$routeResponseDtoOutputStopsInnerRoleEnum_INTERMEDIATE;
  @BuiltValueEnumConst(wireName: r'DESTINATION')
  static const RouteResponseDtoOutputStopsInnerRoleEnum DESTINATION = _$routeResponseDtoOutputStopsInnerRoleEnum_DESTINATION;

  static Serializer<RouteResponseDtoOutputStopsInnerRoleEnum> get serializer => _$routeResponseDtoOutputStopsInnerRoleEnumSerializer;

  const RouteResponseDtoOutputStopsInnerRoleEnum._(String name): super(name);

  static BuiltSet<RouteResponseDtoOutputStopsInnerRoleEnum> get values => _$routeResponseDtoOutputStopsInnerRoleEnumValues;
  static RouteResponseDtoOutputStopsInnerRoleEnum valueOf(String name) => _$routeResponseDtoOutputStopsInnerRoleEnumValueOf(name);
}

class RouteResponseDtoOutputStopsInnerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUS_STATION')
  static const RouteResponseDtoOutputStopsInnerTypeEnum BUS_STATION = _$routeResponseDtoOutputStopsInnerTypeEnum_BUS_STATION;
  @BuiltValueEnumConst(wireName: r'OFFICE')
  static const RouteResponseDtoOutputStopsInnerTypeEnum OFFICE = _$routeResponseDtoOutputStopsInnerTypeEnum_OFFICE;
  @BuiltValueEnumConst(wireName: r'REST_STOP')
  static const RouteResponseDtoOutputStopsInnerTypeEnum REST_STOP = _$routeResponseDtoOutputStopsInnerTypeEnum_REST_STOP;
  @BuiltValueEnumConst(wireName: r'PICKUP_POINT')
  static const RouteResponseDtoOutputStopsInnerTypeEnum PICKUP_POINT = _$routeResponseDtoOutputStopsInnerTypeEnum_PICKUP_POINT;

  static Serializer<RouteResponseDtoOutputStopsInnerTypeEnum> get serializer => _$routeResponseDtoOutputStopsInnerTypeEnumSerializer;

  const RouteResponseDtoOutputStopsInnerTypeEnum._(String name): super(name);

  static BuiltSet<RouteResponseDtoOutputStopsInnerTypeEnum> get values => _$routeResponseDtoOutputStopsInnerTypeEnumValues;
  static RouteResponseDtoOutputStopsInnerTypeEnum valueOf(String name) => _$routeResponseDtoOutputStopsInnerTypeEnumValueOf(name);
}

