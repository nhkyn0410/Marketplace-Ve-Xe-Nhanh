//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/cancellation_quote_dto_output_tickets_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/cancellation_quote_dto_output_tier.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancellation_quote_dto_output.g.dart';

/// CancellationQuoteDtoOutput
///
/// Properties:
/// * [tickets] 
/// * [tier] 
/// * [refundPercent] 
/// * [selectedTotal] 
/// * [refundAmount] 
/// * [nonRefundable] 
@BuiltValue()
abstract class CancellationQuoteDtoOutput implements Built<CancellationQuoteDtoOutput, CancellationQuoteDtoOutputBuilder> {
  @BuiltValueField(wireName: r'tickets')
  BuiltList<CancellationQuoteDtoOutputTicketsInner> get tickets;

  @BuiltValueField(wireName: r'tier')
  CancellationQuoteDtoOutputTier? get tier;

  @BuiltValueField(wireName: r'refundPercent')
  int get refundPercent;

  @BuiltValueField(wireName: r'selectedTotal')
  int get selectedTotal;

  @BuiltValueField(wireName: r'refundAmount')
  int get refundAmount;

  @BuiltValueField(wireName: r'nonRefundable')
  int get nonRefundable;

  CancellationQuoteDtoOutput._();

  factory CancellationQuoteDtoOutput([void updates(CancellationQuoteDtoOutputBuilder b)]) = _$CancellationQuoteDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancellationQuoteDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancellationQuoteDtoOutput> get serializer => _$CancellationQuoteDtoOutputSerializer();
}

class _$CancellationQuoteDtoOutputSerializer implements PrimitiveSerializer<CancellationQuoteDtoOutput> {
  @override
  final Iterable<Type> types = const [CancellationQuoteDtoOutput, _$CancellationQuoteDtoOutput];

  @override
  final String wireName = r'CancellationQuoteDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancellationQuoteDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tickets';
    yield serializers.serialize(
      object.tickets,
      specifiedType: const FullType(BuiltList, [FullType(CancellationQuoteDtoOutputTicketsInner)]),
    );
    yield r'tier';
    yield object.tier == null ? null : serializers.serialize(
      object.tier,
      specifiedType: const FullType.nullable(CancellationQuoteDtoOutputTier),
    );
    yield r'refundPercent';
    yield serializers.serialize(
      object.refundPercent,
      specifiedType: const FullType(int),
    );
    yield r'selectedTotal';
    yield serializers.serialize(
      object.selectedTotal,
      specifiedType: const FullType(int),
    );
    yield r'refundAmount';
    yield serializers.serialize(
      object.refundAmount,
      specifiedType: const FullType(int),
    );
    yield r'nonRefundable';
    yield serializers.serialize(
      object.nonRefundable,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CancellationQuoteDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancellationQuoteDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tickets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CancellationQuoteDtoOutputTicketsInner)]),
          ) as BuiltList<CancellationQuoteDtoOutputTicketsInner>;
          result.tickets.replace(valueDes);
          break;
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CancellationQuoteDtoOutputTier),
          ) as CancellationQuoteDtoOutputTier?;
          if (valueDes == null) continue;
          result.tier.replace(valueDes);
          break;
        case r'refundPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundPercent = valueDes;
          break;
        case r'selectedTotal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.selectedTotal = valueDes;
          break;
        case r'refundAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundAmount = valueDes;
          break;
        case r'nonRefundable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nonRefundable = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CancellationQuoteDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancellationQuoteDtoOutputBuilder();
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


