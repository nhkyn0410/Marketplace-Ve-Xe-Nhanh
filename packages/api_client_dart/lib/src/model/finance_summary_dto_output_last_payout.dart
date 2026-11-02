//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'finance_summary_dto_output_last_payout.g.dart';

/// FinanceSummaryDtoOutputLastPayout
///
/// Properties:
/// * [payoutId] 
/// * [amount] 
/// * [paidAt] 
@BuiltValue()
abstract class FinanceSummaryDtoOutputLastPayout implements Built<FinanceSummaryDtoOutputLastPayout, FinanceSummaryDtoOutputLastPayoutBuilder> {
  @BuiltValueField(wireName: r'payoutId')
  String get payoutId;

  @BuiltValueField(wireName: r'amount')
  int get amount;

  @BuiltValueField(wireName: r'paidAt')
  DateTime get paidAt;

  FinanceSummaryDtoOutputLastPayout._();

  factory FinanceSummaryDtoOutputLastPayout([void updates(FinanceSummaryDtoOutputLastPayoutBuilder b)]) = _$FinanceSummaryDtoOutputLastPayout;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinanceSummaryDtoOutputLastPayoutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinanceSummaryDtoOutputLastPayout> get serializer => _$FinanceSummaryDtoOutputLastPayoutSerializer();
}

class _$FinanceSummaryDtoOutputLastPayoutSerializer implements PrimitiveSerializer<FinanceSummaryDtoOutputLastPayout> {
  @override
  final Iterable<Type> types = const [FinanceSummaryDtoOutputLastPayout, _$FinanceSummaryDtoOutputLastPayout];

  @override
  final String wireName = r'FinanceSummaryDtoOutputLastPayout';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinanceSummaryDtoOutputLastPayout object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'payoutId';
    yield serializers.serialize(
      object.payoutId,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(int),
    );
    yield r'paidAt';
    yield serializers.serialize(
      object.paidAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FinanceSummaryDtoOutputLastPayout object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FinanceSummaryDtoOutputLastPayoutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'payoutId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.payoutId = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amount = valueDes;
          break;
        case r'paidAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.paidAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FinanceSummaryDtoOutputLastPayout deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinanceSummaryDtoOutputLastPayoutBuilder();
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


