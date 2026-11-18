//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/passenger_reviews_dto_output_pending_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_reviews_dto_output_pending.g.dart';

/// PassengerReviewsDtoOutputPending
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
/// * [total] 
@BuiltValue()
abstract class PassengerReviewsDtoOutputPending implements Built<PassengerReviewsDtoOutputPending, PassengerReviewsDtoOutputPendingBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PassengerReviewsDtoOutputPendingItemsInner> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  @BuiltValueField(wireName: r'total')
  int get total;

  PassengerReviewsDtoOutputPending._();

  factory PassengerReviewsDtoOutputPending([void updates(PassengerReviewsDtoOutputPendingBuilder b)]) = _$PassengerReviewsDtoOutputPending;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerReviewsDtoOutputPendingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerReviewsDtoOutputPending> get serializer => _$PassengerReviewsDtoOutputPendingSerializer();
}

class _$PassengerReviewsDtoOutputPendingSerializer implements PrimitiveSerializer<PassengerReviewsDtoOutputPending> {
  @override
  final Iterable<Type> types = const [PassengerReviewsDtoOutputPending, _$PassengerReviewsDtoOutputPending];

  @override
  final String wireName = r'PassengerReviewsDtoOutputPending';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerReviewsDtoOutputPending object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(PassengerReviewsDtoOutputPendingItemsInner)]),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    PassengerReviewsDtoOutputPending object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PassengerReviewsDtoOutputPendingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PassengerReviewsDtoOutputPendingItemsInner)]),
          ) as BuiltList<PassengerReviewsDtoOutputPendingItemsInner>;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PassengerReviewsDtoOutputPending deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerReviewsDtoOutputPendingBuilder();
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


