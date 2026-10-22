//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/promotion_route_options_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'promotion_route_options_dto_output.g.dart';

/// PromotionRouteOptionsDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class PromotionRouteOptionsDtoOutput implements Built<PromotionRouteOptionsDtoOutput, PromotionRouteOptionsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PromotionRouteOptionsDtoOutputItemsInner> get items;

  PromotionRouteOptionsDtoOutput._();

  factory PromotionRouteOptionsDtoOutput([void updates(PromotionRouteOptionsDtoOutputBuilder b)]) = _$PromotionRouteOptionsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PromotionRouteOptionsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PromotionRouteOptionsDtoOutput> get serializer => _$PromotionRouteOptionsDtoOutputSerializer();
}

class _$PromotionRouteOptionsDtoOutputSerializer implements PrimitiveSerializer<PromotionRouteOptionsDtoOutput> {
  @override
  final Iterable<Type> types = const [PromotionRouteOptionsDtoOutput, _$PromotionRouteOptionsDtoOutput];

  @override
  final String wireName = r'PromotionRouteOptionsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PromotionRouteOptionsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(PromotionRouteOptionsDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PromotionRouteOptionsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PromotionRouteOptionsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PromotionRouteOptionsDtoOutputItemsInner)]),
          ) as BuiltList<PromotionRouteOptionsDtoOutputItemsInner>;
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
  PromotionRouteOptionsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PromotionRouteOptionsDtoOutputBuilder();
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


