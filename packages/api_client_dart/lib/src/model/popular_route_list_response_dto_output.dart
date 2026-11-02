//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/popular_route_list_response_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'popular_route_list_response_dto_output.g.dart';

/// PopularRouteListResponseDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class PopularRouteListResponseDtoOutput implements Built<PopularRouteListResponseDtoOutput, PopularRouteListResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PopularRouteListResponseDtoOutputItemsInner> get items;

  PopularRouteListResponseDtoOutput._();

  factory PopularRouteListResponseDtoOutput([void updates(PopularRouteListResponseDtoOutputBuilder b)]) = _$PopularRouteListResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PopularRouteListResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PopularRouteListResponseDtoOutput> get serializer => _$PopularRouteListResponseDtoOutputSerializer();
}

class _$PopularRouteListResponseDtoOutputSerializer implements PrimitiveSerializer<PopularRouteListResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [PopularRouteListResponseDtoOutput, _$PopularRouteListResponseDtoOutput];

  @override
  final String wireName = r'PopularRouteListResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PopularRouteListResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(PopularRouteListResponseDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PopularRouteListResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PopularRouteListResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PopularRouteListResponseDtoOutputItemsInner)]),
          ) as BuiltList<PopularRouteListResponseDtoOutputItemsInner>;
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
  PopularRouteListResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PopularRouteListResponseDtoOutputBuilder();
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


