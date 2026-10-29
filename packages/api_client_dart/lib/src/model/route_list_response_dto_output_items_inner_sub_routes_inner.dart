//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_list_response_dto_output_items_inner_sub_routes_inner.g.dart';

/// RouteListResponseDtoOutputItemsInnerSubRoutesInner
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [nameSource] 
/// * [status] 
/// * [totalDistanceMeters] 
/// * [totalDurationSeconds] 
/// * [metricsSource] 
/// * [parentRouteId] 
/// * [createdAt] 
/// * [updatedAt] 
/// * [stopCount] 
/// * [originName] 
/// * [destinationName] 
@BuiltValue()
abstract class RouteListResponseDtoOutputItemsInnerSubRoutesInner implements Built<RouteListResponseDtoOutputItemsInnerSubRoutesInner, RouteListResponseDtoOutputItemsInnerSubRoutesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'nameSource')
  RouteListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnum get nameSource;
  // enum nameSourceEnum {  AUTO,  MANUAL,  };

  @BuiltValueField(wireName: r'status')
  RouteListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  DRAFT,  };

  @BuiltValueField(wireName: r'totalDistanceMeters')
  int get totalDistanceMeters;

  @BuiltValueField(wireName: r'totalDurationSeconds')
  int get totalDurationSeconds;

  @BuiltValueField(wireName: r'metricsSource')
  RouteListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnum get metricsSource;
  // enum metricsSourceEnum {  GOONG,  ESTIMATE,  };

  @BuiltValueField(wireName: r'parentRouteId')
  String? get parentRouteId;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'stopCount')
  int get stopCount;

  @BuiltValueField(wireName: r'originName')
  String get originName;

  @BuiltValueField(wireName: r'destinationName')
  String get destinationName;

  RouteListResponseDtoOutputItemsInnerSubRoutesInner._();

  factory RouteListResponseDtoOutputItemsInnerSubRoutesInner([void updates(RouteListResponseDtoOutputItemsInnerSubRoutesInnerBuilder b)]) = _$RouteListResponseDtoOutputItemsInnerSubRoutesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteListResponseDtoOutputItemsInnerSubRoutesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteListResponseDtoOutputItemsInnerSubRoutesInner> get serializer => _$RouteListResponseDtoOutputItemsInnerSubRoutesInnerSerializer();
}

class _$RouteListResponseDtoOutputItemsInnerSubRoutesInnerSerializer implements PrimitiveSerializer<RouteListResponseDtoOutputItemsInnerSubRoutesInner> {
  @override
  final Iterable<Type> types = const [RouteListResponseDtoOutputItemsInnerSubRoutesInner, _$RouteListResponseDtoOutputItemsInnerSubRoutesInner];

  @override
  final String wireName = r'RouteListResponseDtoOutputItemsInnerSubRoutesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteListResponseDtoOutputItemsInnerSubRoutesInner object, {
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
    yield r'nameSource';
    yield serializers.serialize(
      object.nameSource,
      specifiedType: const FullType(RouteListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(RouteListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnum),
    );
    yield r'totalDistanceMeters';
    yield serializers.serialize(
      object.totalDistanceMeters,
      specifiedType: const FullType(int),
    );
    yield r'totalDurationSeconds';
    yield serializers.serialize(
      object.totalDurationSeconds,
      specifiedType: const FullType(int),
    );
    yield r'metricsSource';
    yield serializers.serialize(
      object.metricsSource,
      specifiedType: const FullType(RouteListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnum),
    );
    yield r'parentRouteId';
    yield object.parentRouteId == null ? null : serializers.serialize(
      object.parentRouteId,
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
    yield r'stopCount';
    yield serializers.serialize(
      object.stopCount,
      specifiedType: const FullType(int),
    );
    yield r'originName';
    yield serializers.serialize(
      object.originName,
      specifiedType: const FullType(String),
    );
    yield r'destinationName';
    yield serializers.serialize(
      object.destinationName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RouteListResponseDtoOutputItemsInnerSubRoutesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RouteListResponseDtoOutputItemsInnerSubRoutesInnerBuilder result,
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
        case r'nameSource':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnum),
          ) as RouteListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnum;
          result.nameSource = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnum),
          ) as RouteListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'totalDistanceMeters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalDistanceMeters = valueDes;
          break;
        case r'totalDurationSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalDurationSeconds = valueDes;
          break;
        case r'metricsSource':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnum),
          ) as RouteListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnum;
          result.metricsSource = valueDes;
          break;
        case r'parentRouteId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.parentRouteId = valueDes;
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
        case r'stopCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stopCount = valueDes;
          break;
        case r'originName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originName = valueDes;
          break;
        case r'destinationName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.destinationName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RouteListResponseDtoOutputItemsInnerSubRoutesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteListResponseDtoOutputItemsInnerSubRoutesInnerBuilder();
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


class RouteListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AUTO')
  static const RouteListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnum AUTO = _$routeListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnum_AUTO;
  @BuiltValueEnumConst(wireName: r'MANUAL')
  static const RouteListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnum MANUAL = _$routeListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnum_MANUAL;

  static Serializer<RouteListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnum> get serializer => _$routeListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnumSerializer;

  const RouteListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnum._(String name): super(name);

  static BuiltSet<RouteListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnum> get values => _$routeListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnumValues;
  static RouteListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnum valueOf(String name) => _$routeListResponseDtoOutputItemsInnerSubRoutesInnerNameSourceEnumValueOf(name);
}

class RouteListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const RouteListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnum ACTIVE = _$routeListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const RouteListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnum INACTIVE = _$routeListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnum_INACTIVE;
  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const RouteListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnum DRAFT = _$routeListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnum_DRAFT;

  static Serializer<RouteListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnum> get serializer => _$routeListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnumSerializer;

  const RouteListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnum._(String name): super(name);

  static BuiltSet<RouteListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnum> get values => _$routeListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnumValues;
  static RouteListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnum valueOf(String name) => _$routeListResponseDtoOutputItemsInnerSubRoutesInnerStatusEnumValueOf(name);
}

class RouteListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GOONG')
  static const RouteListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnum GOONG = _$routeListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnum_GOONG;
  @BuiltValueEnumConst(wireName: r'ESTIMATE')
  static const RouteListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnum ESTIMATE = _$routeListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnum_ESTIMATE;

  static Serializer<RouteListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnum> get serializer => _$routeListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnumSerializer;

  const RouteListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnum._(String name): super(name);

  static BuiltSet<RouteListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnum> get values => _$routeListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnumValues;
  static RouteListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnum valueOf(String name) => _$routeListResponseDtoOutputItemsInnerSubRoutesInnerMetricsSourceEnumValueOf(name);
}

