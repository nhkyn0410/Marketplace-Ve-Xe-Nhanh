//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/promotion_page_dto_output_stats.dart';
import 'package:api_client_dart/src/model/promotion_page_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'promotion_page_dto_output.g.dart';

/// PromotionPageDtoOutput
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
/// * [total] 
/// * [stats] 
@BuiltValue()
abstract class PromotionPageDtoOutput implements Built<PromotionPageDtoOutput, PromotionPageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PromotionPageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'stats')
  PromotionPageDtoOutputStats get stats;

  PromotionPageDtoOutput._();

  factory PromotionPageDtoOutput([void updates(PromotionPageDtoOutputBuilder b)]) = _$PromotionPageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PromotionPageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PromotionPageDtoOutput> get serializer => _$PromotionPageDtoOutputSerializer();
}

class _$PromotionPageDtoOutputSerializer implements PrimitiveSerializer<PromotionPageDtoOutput> {
  @override
  final Iterable<Type> types = const [PromotionPageDtoOutput, _$PromotionPageDtoOutput];

  @override
  final String wireName = r'PromotionPageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PromotionPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(PromotionPageDtoOutputItemsInner)]),
    );
    yield r'nextCursor';
    yield object.nextCursor == null ? null : serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType.nullable(String),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'stats';
    yield serializers.serialize(
      object.stats,
      specifiedType: const FullType(PromotionPageDtoOutputStats),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PromotionPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PromotionPageDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PromotionPageDtoOutputItemsInner)]),
          ) as BuiltList<PromotionPageDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'stats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PromotionPageDtoOutputStats),
          ) as PromotionPageDtoOutputStats;
          result.stats.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PromotionPageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PromotionPageDtoOutputBuilder();
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


