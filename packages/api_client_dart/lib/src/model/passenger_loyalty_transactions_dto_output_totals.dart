//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_loyalty_transactions_dto_output_totals.g.dart';

/// PassengerLoyaltyTransactionsDtoOutputTotals
///
/// Properties:
/// * [earned]
/// * [redeemed]
/// * [expired]
@BuiltValue()
abstract class PassengerLoyaltyTransactionsDtoOutputTotals
    implements
        Built<PassengerLoyaltyTransactionsDtoOutputTotals,
            PassengerLoyaltyTransactionsDtoOutputTotalsBuilder> {
  @BuiltValueField(wireName: r'earned')
  int get earned;

  @BuiltValueField(wireName: r'redeemed')
  int get redeemed;

  @BuiltValueField(wireName: r'expired')
  int get expired;

  PassengerLoyaltyTransactionsDtoOutputTotals._();

  factory PassengerLoyaltyTransactionsDtoOutputTotals(
          [void updates(
              PassengerLoyaltyTransactionsDtoOutputTotalsBuilder b)]) =
      _$PassengerLoyaltyTransactionsDtoOutputTotals;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerLoyaltyTransactionsDtoOutputTotalsBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerLoyaltyTransactionsDtoOutputTotals>
      get serializer =>
          _$PassengerLoyaltyTransactionsDtoOutputTotalsSerializer();
}

class _$PassengerLoyaltyTransactionsDtoOutputTotalsSerializer
    implements
        PrimitiveSerializer<PassengerLoyaltyTransactionsDtoOutputTotals> {
  @override
  final Iterable<Type> types = const [
    PassengerLoyaltyTransactionsDtoOutputTotals,
    _$PassengerLoyaltyTransactionsDtoOutputTotals
  ];

  @override
  final String wireName = r'PassengerLoyaltyTransactionsDtoOutputTotals';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerLoyaltyTransactionsDtoOutputTotals object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'earned';
    yield serializers.serialize(
      object.earned,
      specifiedType: const FullType(int),
    );
    yield r'redeemed';
    yield serializers.serialize(
      object.redeemed,
      specifiedType: const FullType(int),
    );
    yield r'expired';
    yield serializers.serialize(
      object.expired,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PassengerLoyaltyTransactionsDtoOutputTotals object, {
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
    required PassengerLoyaltyTransactionsDtoOutputTotalsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'earned':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.earned = valueDes;
          break;
        case r'redeemed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.redeemed = valueDes;
          break;
        case r'expired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expired = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PassengerLoyaltyTransactionsDtoOutputTotals deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerLoyaltyTransactionsDtoOutputTotalsBuilder();
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
