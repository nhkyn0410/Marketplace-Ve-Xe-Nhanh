//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancellation_result_dto_output_refund.g.dart';

/// CancellationResultDtoOutputRefund
///
/// Properties:
/// * [refundCode] 
/// * [amount] 
/// * [status] 
@BuiltValue()
abstract class CancellationResultDtoOutputRefund implements Built<CancellationResultDtoOutputRefund, CancellationResultDtoOutputRefundBuilder> {
  @BuiltValueField(wireName: r'refundCode')
  String get refundCode;

  @BuiltValueField(wireName: r'amount')
  int get amount;

  @BuiltValueField(wireName: r'status')
  CancellationResultDtoOutputRefundStatusEnum get status;
  // enum statusEnum {  REQUESTED,  APPROVED,  PROCESSING,  SUCCESS,  FAILED,  REJECTED,  };

  CancellationResultDtoOutputRefund._();

  factory CancellationResultDtoOutputRefund([void updates(CancellationResultDtoOutputRefundBuilder b)]) = _$CancellationResultDtoOutputRefund;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancellationResultDtoOutputRefundBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancellationResultDtoOutputRefund> get serializer => _$CancellationResultDtoOutputRefundSerializer();
}

class _$CancellationResultDtoOutputRefundSerializer implements PrimitiveSerializer<CancellationResultDtoOutputRefund> {
  @override
  final Iterable<Type> types = const [CancellationResultDtoOutputRefund, _$CancellationResultDtoOutputRefund];

  @override
  final String wireName = r'CancellationResultDtoOutputRefund';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancellationResultDtoOutputRefund object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'refundCode';
    yield serializers.serialize(
      object.refundCode,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CancellationResultDtoOutputRefundStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CancellationResultDtoOutputRefund object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancellationResultDtoOutputRefundBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'refundCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refundCode = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amount = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CancellationResultDtoOutputRefundStatusEnum),
          ) as CancellationResultDtoOutputRefundStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CancellationResultDtoOutputRefund deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancellationResultDtoOutputRefundBuilder();
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


class CancellationResultDtoOutputRefundStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUESTED')
  static const CancellationResultDtoOutputRefundStatusEnum REQUESTED = _$cancellationResultDtoOutputRefundStatusEnum_REQUESTED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const CancellationResultDtoOutputRefundStatusEnum APPROVED = _$cancellationResultDtoOutputRefundStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const CancellationResultDtoOutputRefundStatusEnum PROCESSING = _$cancellationResultDtoOutputRefundStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const CancellationResultDtoOutputRefundStatusEnum SUCCESS = _$cancellationResultDtoOutputRefundStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const CancellationResultDtoOutputRefundStatusEnum FAILED = _$cancellationResultDtoOutputRefundStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const CancellationResultDtoOutputRefundStatusEnum REJECTED = _$cancellationResultDtoOutputRefundStatusEnum_REJECTED;

  static Serializer<CancellationResultDtoOutputRefundStatusEnum> get serializer => _$cancellationResultDtoOutputRefundStatusEnumSerializer;

  const CancellationResultDtoOutputRefundStatusEnum._(String name): super(name);

  static BuiltSet<CancellationResultDtoOutputRefundStatusEnum> get values => _$cancellationResultDtoOutputRefundStatusEnumValues;
  static CancellationResultDtoOutputRefundStatusEnum valueOf(String name) => _$cancellationResultDtoOutputRefundStatusEnumValueOf(name);
}

