//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/finance_summary_dto_output_last_payout.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'finance_summary_dto_output.g.dart';

/// FinanceSummaryDtoOutput
///
/// Properties:
/// * [heldBalance] 
/// * [eligibleAmount] 
/// * [pendingAmount] 
/// * [lastPayout] 
/// * [payoutDelayDays] 
@BuiltValue()
abstract class FinanceSummaryDtoOutput implements Built<FinanceSummaryDtoOutput, FinanceSummaryDtoOutputBuilder> {
  @BuiltValueField(wireName: r'heldBalance')
  int get heldBalance;

  @BuiltValueField(wireName: r'eligibleAmount')
  int get eligibleAmount;

  @BuiltValueField(wireName: r'pendingAmount')
  int get pendingAmount;

  @BuiltValueField(wireName: r'lastPayout')
  FinanceSummaryDtoOutputLastPayout? get lastPayout;

  @BuiltValueField(wireName: r'payoutDelayDays')
  int get payoutDelayDays;

  FinanceSummaryDtoOutput._();

  factory FinanceSummaryDtoOutput([void updates(FinanceSummaryDtoOutputBuilder b)]) = _$FinanceSummaryDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinanceSummaryDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinanceSummaryDtoOutput> get serializer => _$FinanceSummaryDtoOutputSerializer();
}

class _$FinanceSummaryDtoOutputSerializer implements PrimitiveSerializer<FinanceSummaryDtoOutput> {
  @override
  final Iterable<Type> types = const [FinanceSummaryDtoOutput, _$FinanceSummaryDtoOutput];

  @override
  final String wireName = r'FinanceSummaryDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinanceSummaryDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'heldBalance';
    yield serializers.serialize(
      object.heldBalance,
      specifiedType: const FullType(int),
    );
    yield r'eligibleAmount';
    yield serializers.serialize(
      object.eligibleAmount,
      specifiedType: const FullType(int),
    );
    yield r'pendingAmount';
    yield serializers.serialize(
      object.pendingAmount,
      specifiedType: const FullType(int),
    );
    yield r'lastPayout';
    yield object.lastPayout == null ? null : serializers.serialize(
      object.lastPayout,
      specifiedType: const FullType.nullable(FinanceSummaryDtoOutputLastPayout),
    );
    yield r'payoutDelayDays';
    yield serializers.serialize(
      object.payoutDelayDays,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FinanceSummaryDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FinanceSummaryDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'heldBalance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.heldBalance = valueDes;
          break;
        case r'eligibleAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.eligibleAmount = valueDes;
          break;
        case r'pendingAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingAmount = valueDes;
          break;
        case r'lastPayout':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FinanceSummaryDtoOutputLastPayout),
          ) as FinanceSummaryDtoOutputLastPayout?;
          if (valueDes == null) continue;
          result.lastPayout.replace(valueDes);
          break;
        case r'payoutDelayDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.payoutDelayDays = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FinanceSummaryDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinanceSummaryDtoOutputBuilder();
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


