//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'popular_route_list_response_dto_output_items_inner.g.dart';

/// PopularRouteListResponseDtoOutputItemsInner
///
/// Properties:
/// * [originProvinceId] 
/// * [originName] 
/// * [destinationProvinceId] 
/// * [destinationName] 
/// * [distanceMeters] 
/// * [durationSeconds] 
/// * [minPrice] 
/// * [vehicleTypeNames] 
/// * [nextDepartureAt] 
/// * [operatorCount] 
/// * [averageRating] 
/// * [reviewCount] 
@BuiltValue()
abstract class PopularRouteListResponseDtoOutputItemsInner implements Built<PopularRouteListResponseDtoOutputItemsInner, PopularRouteListResponseDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'originProvinceId')
  String get originProvinceId;

  @BuiltValueField(wireName: r'originName')
  String get originName;

  @BuiltValueField(wireName: r'destinationProvinceId')
  String get destinationProvinceId;

  @BuiltValueField(wireName: r'destinationName')
  String get destinationName;

  @BuiltValueField(wireName: r'distanceMeters')
  int get distanceMeters;

  @BuiltValueField(wireName: r'durationSeconds')
  int get durationSeconds;

  @BuiltValueField(wireName: r'minPrice')
  int? get minPrice;

  @BuiltValueField(wireName: r'vehicleTypeNames')
  BuiltList<String> get vehicleTypeNames;

  @BuiltValueField(wireName: r'nextDepartureAt')
  DateTime? get nextDepartureAt;

  @BuiltValueField(wireName: r'operatorCount')
  int get operatorCount;

  @BuiltValueField(wireName: r'averageRating')
  num? get averageRating;

  @BuiltValueField(wireName: r'reviewCount')
  int get reviewCount;

  PopularRouteListResponseDtoOutputItemsInner._();

  factory PopularRouteListResponseDtoOutputItemsInner([void updates(PopularRouteListResponseDtoOutputItemsInnerBuilder b)]) = _$PopularRouteListResponseDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PopularRouteListResponseDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PopularRouteListResponseDtoOutputItemsInner> get serializer => _$PopularRouteListResponseDtoOutputItemsInnerSerializer();
}

class _$PopularRouteListResponseDtoOutputItemsInnerSerializer implements PrimitiveSerializer<PopularRouteListResponseDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [PopularRouteListResponseDtoOutputItemsInner, _$PopularRouteListResponseDtoOutputItemsInner];

  @override
  final String wireName = r'PopularRouteListResponseDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PopularRouteListResponseDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'originProvinceId';
    yield serializers.serialize(
      object.originProvinceId,
      specifiedType: const FullType(String),
    );
    yield r'originName';
    yield serializers.serialize(
      object.originName,
      specifiedType: const FullType(String),
    );
    yield r'destinationProvinceId';
    yield serializers.serialize(
      object.destinationProvinceId,
      specifiedType: const FullType(String),
    );
    yield r'destinationName';
    yield serializers.serialize(
      object.destinationName,
      specifiedType: const FullType(String),
    );
    yield r'distanceMeters';
    yield serializers.serialize(
      object.distanceMeters,
      specifiedType: const FullType(int),
    );
    yield r'durationSeconds';
    yield serializers.serialize(
      object.durationSeconds,
      specifiedType: const FullType(int),
    );
    yield r'minPrice';
    yield object.minPrice == null ? null : serializers.serialize(
      object.minPrice,
      specifiedType: const FullType.nullable(int),
    );
    yield r'vehicleTypeNames';
    yield serializers.serialize(
      object.vehicleTypeNames,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'nextDepartureAt';
    yield object.nextDepartureAt == null ? null : serializers.serialize(
      object.nextDepartureAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'operatorCount';
    yield serializers.serialize(
      object.operatorCount,
      specifiedType: const FullType(int),
    );
    yield r'averageRating';
    yield object.averageRating == null ? null : serializers.serialize(
      object.averageRating,
      specifiedType: const FullType.nullable(num),
    );
    yield r'reviewCount';
    yield serializers.serialize(
      object.reviewCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PopularRouteListResponseDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PopularRouteListResponseDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'originProvinceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originProvinceId = valueDes;
          break;
        case r'originName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originName = valueDes;
          break;
        case r'destinationProvinceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.destinationProvinceId = valueDes;
          break;
        case r'destinationName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.destinationName = valueDes;
          break;
        case r'distanceMeters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distanceMeters = valueDes;
          break;
        case r'durationSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationSeconds = valueDes;
          break;
        case r'minPrice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.minPrice = valueDes;
          break;
        case r'vehicleTypeNames':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.vehicleTypeNames.replace(valueDes);
          break;
        case r'nextDepartureAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.nextDepartureAt = valueDes;
          break;
        case r'operatorCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.operatorCount = valueDes;
          break;
        case r'averageRating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.averageRating = valueDes;
          break;
        case r'reviewCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.reviewCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PopularRouteListResponseDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PopularRouteListResponseDtoOutputItemsInnerBuilder();
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


