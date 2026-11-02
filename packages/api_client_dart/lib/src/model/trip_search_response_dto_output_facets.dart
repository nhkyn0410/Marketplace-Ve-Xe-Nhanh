//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/trip_search_response_dto_output_facets_operators_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_search_response_dto_output_facets.g.dart';

/// TripSearchResponseDtoOutputFacets
///
/// Properties:
/// * [operators] 
/// * [priceMin] 
/// * [priceMax] 
@BuiltValue()
abstract class TripSearchResponseDtoOutputFacets implements Built<TripSearchResponseDtoOutputFacets, TripSearchResponseDtoOutputFacetsBuilder> {
  @BuiltValueField(wireName: r'operators')
  BuiltList<TripSearchResponseDtoOutputFacetsOperatorsInner> get operators;

  @BuiltValueField(wireName: r'priceMin')
  int? get priceMin;

  @BuiltValueField(wireName: r'priceMax')
  int? get priceMax;

  TripSearchResponseDtoOutputFacets._();

  factory TripSearchResponseDtoOutputFacets([void updates(TripSearchResponseDtoOutputFacetsBuilder b)]) = _$TripSearchResponseDtoOutputFacets;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripSearchResponseDtoOutputFacetsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripSearchResponseDtoOutputFacets> get serializer => _$TripSearchResponseDtoOutputFacetsSerializer();
}

class _$TripSearchResponseDtoOutputFacetsSerializer implements PrimitiveSerializer<TripSearchResponseDtoOutputFacets> {
  @override
  final Iterable<Type> types = const [TripSearchResponseDtoOutputFacets, _$TripSearchResponseDtoOutputFacets];

  @override
  final String wireName = r'TripSearchResponseDtoOutputFacets';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripSearchResponseDtoOutputFacets object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'operators';
    yield serializers.serialize(
      object.operators,
      specifiedType: const FullType(BuiltList, [FullType(TripSearchResponseDtoOutputFacetsOperatorsInner)]),
    );
    yield r'priceMin';
    yield object.priceMin == null ? null : serializers.serialize(
      object.priceMin,
      specifiedType: const FullType.nullable(int),
    );
    yield r'priceMax';
    yield object.priceMax == null ? null : serializers.serialize(
      object.priceMax,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripSearchResponseDtoOutputFacets object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripSearchResponseDtoOutputFacetsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'operators':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TripSearchResponseDtoOutputFacetsOperatorsInner)]),
          ) as BuiltList<TripSearchResponseDtoOutputFacetsOperatorsInner>;
          result.operators.replace(valueDes);
          break;
        case r'priceMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.priceMin = valueDes;
          break;
        case r'priceMax':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.priceMax = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripSearchResponseDtoOutputFacets deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripSearchResponseDtoOutputFacetsBuilder();
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


