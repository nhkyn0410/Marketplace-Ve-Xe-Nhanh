//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_response_dto_output_sub_routes_inner_fare.g.dart';

/// RouteResponseDtoOutputSubRoutesInnerFare
///
/// Properties:
/// * [id] 
/// * [status] 
/// * [minPrice] 
/// * [maxPrice] 
@BuiltValue()
abstract class RouteResponseDtoOutputSubRoutesInnerFare implements Built<RouteResponseDtoOutputSubRoutesInnerFare, RouteResponseDtoOutputSubRoutesInnerFareBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  RouteResponseDtoOutputSubRoutesInnerFareStatusEnum get status;
  // enum statusEnum {  ACTIVE,  INACTIVE,  };

  @BuiltValueField(wireName: r'minPrice')
  int? get minPrice;

  @BuiltValueField(wireName: r'maxPrice')
  int? get maxPrice;

  RouteResponseDtoOutputSubRoutesInnerFare._();

  factory RouteResponseDtoOutputSubRoutesInnerFare([void updates(RouteResponseDtoOutputSubRoutesInnerFareBuilder b)]) = _$RouteResponseDtoOutputSubRoutesInnerFare;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteResponseDtoOutputSubRoutesInnerFareBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteResponseDtoOutputSubRoutesInnerFare> get serializer => _$RouteResponseDtoOutputSubRoutesInnerFareSerializer();
}

class _$RouteResponseDtoOutputSubRoutesInnerFareSerializer implements PrimitiveSerializer<RouteResponseDtoOutputSubRoutesInnerFare> {
  @override
  final Iterable<Type> types = const [RouteResponseDtoOutputSubRoutesInnerFare, _$RouteResponseDtoOutputSubRoutesInnerFare];

  @override
  final String wireName = r'RouteResponseDtoOutputSubRoutesInnerFare';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteResponseDtoOutputSubRoutesInnerFare object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(RouteResponseDtoOutputSubRoutesInnerFareStatusEnum),
    );
    yield r'minPrice';
    yield object.minPrice == null ? null : serializers.serialize(
      object.minPrice,
      specifiedType: const FullType.nullable(int),
    );
    yield r'maxPrice';
    yield object.maxPrice == null ? null : serializers.serialize(
      object.maxPrice,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RouteResponseDtoOutputSubRoutesInnerFare object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RouteResponseDtoOutputSubRoutesInnerFareBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteResponseDtoOutputSubRoutesInnerFareStatusEnum),
          ) as RouteResponseDtoOutputSubRoutesInnerFareStatusEnum;
          result.status = valueDes;
          break;
        case r'minPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.minPrice = valueDes;
          break;
        case r'maxPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxPrice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RouteResponseDtoOutputSubRoutesInnerFare deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteResponseDtoOutputSubRoutesInnerFareBuilder();
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


class RouteResponseDtoOutputSubRoutesInnerFareStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const RouteResponseDtoOutputSubRoutesInnerFareStatusEnum ACTIVE = _$routeResponseDtoOutputSubRoutesInnerFareStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'INACTIVE')
  static const RouteResponseDtoOutputSubRoutesInnerFareStatusEnum INACTIVE = _$routeResponseDtoOutputSubRoutesInnerFareStatusEnum_INACTIVE;

  static Serializer<RouteResponseDtoOutputSubRoutesInnerFareStatusEnum> get serializer => _$routeResponseDtoOutputSubRoutesInnerFareStatusEnumSerializer;

  const RouteResponseDtoOutputSubRoutesInnerFareStatusEnum._(String name): super(name);

  static BuiltSet<RouteResponseDtoOutputSubRoutesInnerFareStatusEnum> get values => _$routeResponseDtoOutputSubRoutesInnerFareStatusEnumValues;
  static RouteResponseDtoOutputSubRoutesInnerFareStatusEnum valueOf(String name) => _$routeResponseDtoOutputSubRoutesInnerFareStatusEnumValueOf(name);
}

