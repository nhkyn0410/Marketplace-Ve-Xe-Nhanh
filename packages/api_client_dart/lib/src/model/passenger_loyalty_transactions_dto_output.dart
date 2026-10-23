//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/passenger_loyalty_transactions_dto_output_totals.dart';
import 'package:api_client_dart/src/model/passenger_loyalty_transactions_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_loyalty_transactions_dto_output.g.dart';

/// PassengerLoyaltyTransactionsDtoOutput
///
/// Properties:
/// * [items] 
/// * [total] 
/// * [totals] 
@BuiltValue()
abstract class PassengerLoyaltyTransactionsDtoOutput implements Built<PassengerLoyaltyTransactionsDtoOutput, PassengerLoyaltyTransactionsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PassengerLoyaltyTransactionsDtoOutputItemsInner> get items;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'totals')
  PassengerLoyaltyTransactionsDtoOutputTotals get totals;

  PassengerLoyaltyTransactionsDtoOutput._();

  factory PassengerLoyaltyTransactionsDtoOutput([void updates(PassengerLoyaltyTransactionsDtoOutputBuilder b)]) = _$PassengerLoyaltyTransactionsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerLoyaltyTransactionsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerLoyaltyTransactionsDtoOutput> get serializer => _$PassengerLoyaltyTransactionsDtoOutputSerializer();
}

class _$PassengerLoyaltyTransactionsDtoOutputSerializer implements PrimitiveSerializer<PassengerLoyaltyTransactionsDtoOutput> {
  @override
  final Iterable<Type> types = const [PassengerLoyaltyTransactionsDtoOutput, _$PassengerLoyaltyTransactionsDtoOutput];

  @override
  final String wireName = r'PassengerLoyaltyTransactionsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerLoyaltyTransactionsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(PassengerLoyaltyTransactionsDtoOutputItemsInner)]),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'totals';
    yield serializers.serialize(
      object.totals,
      specifiedType: const FullType(PassengerLoyaltyTransactionsDtoOutputTotals),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PassengerLoyaltyTransactionsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PassengerLoyaltyTransactionsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PassengerLoyaltyTransactionsDtoOutputItemsInner)]),
          ) as BuiltList<PassengerLoyaltyTransactionsDtoOutputItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'totals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PassengerLoyaltyTransactionsDtoOutputTotals),
          ) as PassengerLoyaltyTransactionsDtoOutputTotals;
          result.totals.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PassengerLoyaltyTransactionsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerLoyaltyTransactionsDtoOutputBuilder();
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


