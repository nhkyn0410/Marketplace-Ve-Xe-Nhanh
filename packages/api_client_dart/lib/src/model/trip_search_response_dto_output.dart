//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/trip_search_response_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/trip_search_response_dto_output_facets.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_search_response_dto_output.g.dart';

/// TripSearchResponseDtoOutput
///
/// Properties:
/// * [items] 
/// * [total] 
/// * [page] 
/// * [limit] 
/// * [facets] 
@BuiltValue()
abstract class TripSearchResponseDtoOutput implements Built<TripSearchResponseDtoOutput, TripSearchResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<TripSearchResponseDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'limit')
  int get limit;

  @BuiltValueField(wireName: r'facets')
  TripSearchResponseDtoOutputFacets get facets;

  TripSearchResponseDtoOutput._();

  factory TripSearchResponseDtoOutput([void updates(TripSearchResponseDtoOutputBuilder b)]) = _$TripSearchResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripSearchResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripSearchResponseDtoOutput> get serializer => _$TripSearchResponseDtoOutputSerializer();
}

class _$TripSearchResponseDtoOutputSerializer implements PrimitiveSerializer<TripSearchResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [TripSearchResponseDtoOutput, _$TripSearchResponseDtoOutput];

  @override
  final String wireName = r'TripSearchResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripSearchResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(TripSearchResponseDtoOutputItemsInner)]),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'limit';
    yield serializers.serialize(
      object.limit,
      specifiedType: const FullType(int),
    );
    yield r'facets';
    yield serializers.serialize(
      object.facets,
      specifiedType: const FullType(TripSearchResponseDtoOutputFacets),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripSearchResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripSearchResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TripSearchResponseDtoOutputItemsInner)]),
          ) as BuiltList<TripSearchResponseDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        case r'limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.limit = valueDes;
          break;
        case r'facets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSearchResponseDtoOutputFacets),
          ) as TripSearchResponseDtoOutputFacets;
          result.facets.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripSearchResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripSearchResponseDtoOutputBuilder();
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


