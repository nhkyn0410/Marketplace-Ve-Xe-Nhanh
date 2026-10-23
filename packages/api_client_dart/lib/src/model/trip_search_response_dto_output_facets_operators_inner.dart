//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_search_response_dto_output_facets_operators_inner.g.dart';

/// TripSearchResponseDtoOutputFacetsOperatorsInner
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [count] 
@BuiltValue()
abstract class TripSearchResponseDtoOutputFacetsOperatorsInner implements Built<TripSearchResponseDtoOutputFacetsOperatorsInner, TripSearchResponseDtoOutputFacetsOperatorsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'count')
  int get count;

  TripSearchResponseDtoOutputFacetsOperatorsInner._();

  factory TripSearchResponseDtoOutputFacetsOperatorsInner([void updates(TripSearchResponseDtoOutputFacetsOperatorsInnerBuilder b)]) = _$TripSearchResponseDtoOutputFacetsOperatorsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripSearchResponseDtoOutputFacetsOperatorsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripSearchResponseDtoOutputFacetsOperatorsInner> get serializer => _$TripSearchResponseDtoOutputFacetsOperatorsInnerSerializer();
}

class _$TripSearchResponseDtoOutputFacetsOperatorsInnerSerializer implements PrimitiveSerializer<TripSearchResponseDtoOutputFacetsOperatorsInner> {
  @override
  final Iterable<Type> types = const [TripSearchResponseDtoOutputFacetsOperatorsInner, _$TripSearchResponseDtoOutputFacetsOperatorsInner];

  @override
  final String wireName = r'TripSearchResponseDtoOutputFacetsOperatorsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripSearchResponseDtoOutputFacetsOperatorsInner object, {
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
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripSearchResponseDtoOutputFacetsOperatorsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripSearchResponseDtoOutputFacetsOperatorsInnerBuilder result,
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
  TripSearchResponseDtoOutputFacetsOperatorsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripSearchResponseDtoOutputFacetsOperatorsInnerBuilder();
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


