//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_search_response_dto_output_items_inner_amenities_inner.g.dart';

/// TripSearchResponseDtoOutputItemsInnerAmenitiesInner
///
/// Properties:
/// * [id] 
/// * [name] 
@BuiltValue()
abstract class TripSearchResponseDtoOutputItemsInnerAmenitiesInner implements Built<TripSearchResponseDtoOutputItemsInnerAmenitiesInner, TripSearchResponseDtoOutputItemsInnerAmenitiesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  TripSearchResponseDtoOutputItemsInnerAmenitiesInner._();

  factory TripSearchResponseDtoOutputItemsInnerAmenitiesInner([void updates(TripSearchResponseDtoOutputItemsInnerAmenitiesInnerBuilder b)]) = _$TripSearchResponseDtoOutputItemsInnerAmenitiesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripSearchResponseDtoOutputItemsInnerAmenitiesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripSearchResponseDtoOutputItemsInnerAmenitiesInner> get serializer => _$TripSearchResponseDtoOutputItemsInnerAmenitiesInnerSerializer();
}

class _$TripSearchResponseDtoOutputItemsInnerAmenitiesInnerSerializer implements PrimitiveSerializer<TripSearchResponseDtoOutputItemsInnerAmenitiesInner> {
  @override
  final Iterable<Type> types = const [TripSearchResponseDtoOutputItemsInnerAmenitiesInner, _$TripSearchResponseDtoOutputItemsInnerAmenitiesInner];

  @override
  final String wireName = r'TripSearchResponseDtoOutputItemsInnerAmenitiesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripSearchResponseDtoOutputItemsInnerAmenitiesInner object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    TripSearchResponseDtoOutputItemsInnerAmenitiesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripSearchResponseDtoOutputItemsInnerAmenitiesInnerBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripSearchResponseDtoOutputItemsInnerAmenitiesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripSearchResponseDtoOutputItemsInnerAmenitiesInnerBuilder();
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


