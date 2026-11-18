//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_search_response_dto_output_facets_pickup_points_inner.g.dart';

/// TripSearchResponseDtoOutputFacetsPickupPointsInner
///
/// Properties:
/// * [name] 
/// * [count] 
@BuiltValue()
abstract class TripSearchResponseDtoOutputFacetsPickupPointsInner implements Built<TripSearchResponseDtoOutputFacetsPickupPointsInner, TripSearchResponseDtoOutputFacetsPickupPointsInnerBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'count')
  int get count;

  TripSearchResponseDtoOutputFacetsPickupPointsInner._();

  factory TripSearchResponseDtoOutputFacetsPickupPointsInner([void updates(TripSearchResponseDtoOutputFacetsPickupPointsInnerBuilder b)]) = _$TripSearchResponseDtoOutputFacetsPickupPointsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripSearchResponseDtoOutputFacetsPickupPointsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripSearchResponseDtoOutputFacetsPickupPointsInner> get serializer => _$TripSearchResponseDtoOutputFacetsPickupPointsInnerSerializer();
}

class _$TripSearchResponseDtoOutputFacetsPickupPointsInnerSerializer implements PrimitiveSerializer<TripSearchResponseDtoOutputFacetsPickupPointsInner> {
  @override
  final Iterable<Type> types = const [TripSearchResponseDtoOutputFacetsPickupPointsInner, _$TripSearchResponseDtoOutputFacetsPickupPointsInner];

  @override
  final String wireName = r'TripSearchResponseDtoOutputFacetsPickupPointsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripSearchResponseDtoOutputFacetsPickupPointsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripSearchResponseDtoOutputFacetsPickupPointsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripSearchResponseDtoOutputFacetsPickupPointsInnerBuilder result,
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
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripSearchResponseDtoOutputFacetsPickupPointsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripSearchResponseDtoOutputFacetsPickupPointsInnerBuilder();
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


