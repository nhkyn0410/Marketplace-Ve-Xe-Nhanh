//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_search_response_dto_output_items_inner_operator.g.dart';

/// TripSearchResponseDtoOutputItemsInnerOperator
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [slug] 
@BuiltValue()
abstract class TripSearchResponseDtoOutputItemsInnerOperator implements Built<TripSearchResponseDtoOutputItemsInnerOperator, TripSearchResponseDtoOutputItemsInnerOperatorBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'slug')
  String get slug;

  TripSearchResponseDtoOutputItemsInnerOperator._();

  factory TripSearchResponseDtoOutputItemsInnerOperator([void updates(TripSearchResponseDtoOutputItemsInnerOperatorBuilder b)]) = _$TripSearchResponseDtoOutputItemsInnerOperator;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripSearchResponseDtoOutputItemsInnerOperatorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripSearchResponseDtoOutputItemsInnerOperator> get serializer => _$TripSearchResponseDtoOutputItemsInnerOperatorSerializer();
}

class _$TripSearchResponseDtoOutputItemsInnerOperatorSerializer implements PrimitiveSerializer<TripSearchResponseDtoOutputItemsInnerOperator> {
  @override
  final Iterable<Type> types = const [TripSearchResponseDtoOutputItemsInnerOperator, _$TripSearchResponseDtoOutputItemsInnerOperator];

  @override
  final String wireName = r'TripSearchResponseDtoOutputItemsInnerOperator';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripSearchResponseDtoOutputItemsInnerOperator object, {
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
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripSearchResponseDtoOutputItemsInnerOperator object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripSearchResponseDtoOutputItemsInnerOperatorBuilder result,
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
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripSearchResponseDtoOutputItemsInnerOperator deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripSearchResponseDtoOutputItemsInnerOperatorBuilder();
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


