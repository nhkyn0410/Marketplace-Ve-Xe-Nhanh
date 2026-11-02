//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/featured_operator_list_response_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'featured_operator_list_response_dto_output.g.dart';

/// FeaturedOperatorListResponseDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class FeaturedOperatorListResponseDtoOutput implements Built<FeaturedOperatorListResponseDtoOutput, FeaturedOperatorListResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<FeaturedOperatorListResponseDtoOutputItemsInner> get items;

  FeaturedOperatorListResponseDtoOutput._();

  factory FeaturedOperatorListResponseDtoOutput([void updates(FeaturedOperatorListResponseDtoOutputBuilder b)]) = _$FeaturedOperatorListResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FeaturedOperatorListResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FeaturedOperatorListResponseDtoOutput> get serializer => _$FeaturedOperatorListResponseDtoOutputSerializer();
}

class _$FeaturedOperatorListResponseDtoOutputSerializer implements PrimitiveSerializer<FeaturedOperatorListResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [FeaturedOperatorListResponseDtoOutput, _$FeaturedOperatorListResponseDtoOutput];

  @override
  final String wireName = r'FeaturedOperatorListResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FeaturedOperatorListResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(FeaturedOperatorListResponseDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FeaturedOperatorListResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FeaturedOperatorListResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FeaturedOperatorListResponseDtoOutputItemsInner)]),
          ) as BuiltList<FeaturedOperatorListResponseDtoOutputItemsInner>;
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
  FeaturedOperatorListResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FeaturedOperatorListResponseDtoOutputBuilder();
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


