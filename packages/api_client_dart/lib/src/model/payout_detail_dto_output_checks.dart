//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_detail_dto_output_checks.g.dart';

/// PayoutDetailDtoOutputChecks
///
/// Properties:
/// * [ledgerMatches] 
/// * [noPendingRefunds] 
/// * [bankVerified] 
@BuiltValue()
abstract class PayoutDetailDtoOutputChecks implements Built<PayoutDetailDtoOutputChecks, PayoutDetailDtoOutputChecksBuilder> {
  @BuiltValueField(wireName: r'ledgerMatches')
  bool get ledgerMatches;

  @BuiltValueField(wireName: r'noPendingRefunds')
  bool get noPendingRefunds;

  @BuiltValueField(wireName: r'bankVerified')
  bool get bankVerified;

  PayoutDetailDtoOutputChecks._();

  factory PayoutDetailDtoOutputChecks([void updates(PayoutDetailDtoOutputChecksBuilder b)]) = _$PayoutDetailDtoOutputChecks;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PayoutDetailDtoOutputChecksBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PayoutDetailDtoOutputChecks> get serializer => _$PayoutDetailDtoOutputChecksSerializer();
}

class _$PayoutDetailDtoOutputChecksSerializer implements PrimitiveSerializer<PayoutDetailDtoOutputChecks> {
  @override
  final Iterable<Type> types = const [PayoutDetailDtoOutputChecks, _$PayoutDetailDtoOutputChecks];

  @override
  final String wireName = r'PayoutDetailDtoOutputChecks';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PayoutDetailDtoOutputChecks object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ledgerMatches';
    yield serializers.serialize(
      object.ledgerMatches,
      specifiedType: const FullType(bool),
    );
    yield r'noPendingRefunds';
    yield serializers.serialize(
      object.noPendingRefunds,
      specifiedType: const FullType(bool),
    );
    yield r'bankVerified';
    yield serializers.serialize(
      object.bankVerified,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PayoutDetailDtoOutputChecks object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PayoutDetailDtoOutputChecksBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ledgerMatches':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ledgerMatches = valueDes;
          break;
        case r'noPendingRefunds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.noPendingRefunds = valueDes;
          break;
        case r'bankVerified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.bankVerified = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PayoutDetailDtoOutputChecks deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PayoutDetailDtoOutputChecksBuilder();
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


