//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/place_suggestion_list_response_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'place_suggestion_list_response_dto_output.g.dart';

/// PlaceSuggestionListResponseDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class PlaceSuggestionListResponseDtoOutput implements Built<PlaceSuggestionListResponseDtoOutput, PlaceSuggestionListResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PlaceSuggestionListResponseDtoOutputItemsInner> get items;

  PlaceSuggestionListResponseDtoOutput._();

  factory PlaceSuggestionListResponseDtoOutput([void updates(PlaceSuggestionListResponseDtoOutputBuilder b)]) = _$PlaceSuggestionListResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlaceSuggestionListResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlaceSuggestionListResponseDtoOutput> get serializer => _$PlaceSuggestionListResponseDtoOutputSerializer();
}

class _$PlaceSuggestionListResponseDtoOutputSerializer implements PrimitiveSerializer<PlaceSuggestionListResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [PlaceSuggestionListResponseDtoOutput, _$PlaceSuggestionListResponseDtoOutput];

  @override
  final String wireName = r'PlaceSuggestionListResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlaceSuggestionListResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(PlaceSuggestionListResponseDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PlaceSuggestionListResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PlaceSuggestionListResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PlaceSuggestionListResponseDtoOutputItemsInner)]),
          ) as BuiltList<PlaceSuggestionListResponseDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlaceSuggestionListResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlaceSuggestionListResponseDtoOutputBuilder();
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


