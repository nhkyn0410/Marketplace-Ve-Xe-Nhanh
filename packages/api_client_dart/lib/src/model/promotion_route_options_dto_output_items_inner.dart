//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'promotion_route_options_dto_output_items_inner.g.dart';

/// PromotionRouteOptionsDtoOutputItemsInner
///
/// Properties:
/// * [routeId]
/// * [routeName]
/// * [operatorName]
@BuiltValue()
abstract class PromotionRouteOptionsDtoOutputItemsInner
    implements
        Built<PromotionRouteOptionsDtoOutputItemsInner,
            PromotionRouteOptionsDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'routeId')
  String get routeId;

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  PromotionRouteOptionsDtoOutputItemsInner._();

  factory PromotionRouteOptionsDtoOutputItemsInner(
          [void updates(PromotionRouteOptionsDtoOutputItemsInnerBuilder b)]) =
      _$PromotionRouteOptionsDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PromotionRouteOptionsDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PromotionRouteOptionsDtoOutputItemsInner> get serializer =>
      _$PromotionRouteOptionsDtoOutputItemsInnerSerializer();
}

class _$PromotionRouteOptionsDtoOutputItemsInnerSerializer
    implements PrimitiveSerializer<PromotionRouteOptionsDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [
    PromotionRouteOptionsDtoOutputItemsInner,
    _$PromotionRouteOptionsDtoOutputItemsInner
  ];

  @override
  final String wireName = r'PromotionRouteOptionsDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PromotionRouteOptionsDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'routeId';
    yield serializers.serialize(
      object.routeId,
      specifiedType: const FullType(String),
    );
    yield r'routeName';
    yield serializers.serialize(
      object.routeName,
      specifiedType: const FullType(String),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PromotionRouteOptionsDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PromotionRouteOptionsDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'routeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeId = valueDes;
          break;
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeName = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PromotionRouteOptionsDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PromotionRouteOptionsDtoOutputItemsInnerBuilder();
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
