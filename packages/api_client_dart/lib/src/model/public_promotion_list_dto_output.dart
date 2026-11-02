//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/public_promotion_list_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_promotion_list_dto_output.g.dart';

/// PublicPromotionListDtoOutput
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class PublicPromotionListDtoOutput implements Built<PublicPromotionListDtoOutput, PublicPromotionListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PublicPromotionListDtoOutputItemsInner> get items;

  PublicPromotionListDtoOutput._();

  factory PublicPromotionListDtoOutput([void updates(PublicPromotionListDtoOutputBuilder b)]) = _$PublicPromotionListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicPromotionListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicPromotionListDtoOutput> get serializer => _$PublicPromotionListDtoOutputSerializer();
}

class _$PublicPromotionListDtoOutputSerializer implements PrimitiveSerializer<PublicPromotionListDtoOutput> {
  @override
  final Iterable<Type> types = const [PublicPromotionListDtoOutput, _$PublicPromotionListDtoOutput];

  @override
  final String wireName = r'PublicPromotionListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicPromotionListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(PublicPromotionListDtoOutputItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicPromotionListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicPromotionListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PublicPromotionListDtoOutputItemsInner)]),
          ) as BuiltList<PublicPromotionListDtoOutputItemsInner>;
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
  PublicPromotionListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicPromotionListDtoOutputBuilder();
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


