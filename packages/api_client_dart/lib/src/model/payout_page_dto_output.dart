//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/payout_page_dto_output_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_page_dto_output.g.dart';

/// PayoutPageDtoOutput
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class PayoutPageDtoOutput implements Built<PayoutPageDtoOutput, PayoutPageDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PayoutPageDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  PayoutPageDtoOutput._();

  factory PayoutPageDtoOutput([void updates(PayoutPageDtoOutputBuilder b)]) = _$PayoutPageDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PayoutPageDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PayoutPageDtoOutput> get serializer => _$PayoutPageDtoOutputSerializer();
}

class _$PayoutPageDtoOutputSerializer implements PrimitiveSerializer<PayoutPageDtoOutput> {
  @override
  final Iterable<Type> types = const [PayoutPageDtoOutput, _$PayoutPageDtoOutput];

  @override
  final String wireName = r'PayoutPageDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PayoutPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(PayoutPageDtoOutputItemsInner)]),
    );
    yield r'nextCursor';
    yield object.nextCursor == null ? null : serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PayoutPageDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PayoutPageDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PayoutPageDtoOutputItemsInner)]),
          ) as BuiltList<PayoutPageDtoOutputItemsInner>;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PayoutPageDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PayoutPageDtoOutputBuilder();
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


