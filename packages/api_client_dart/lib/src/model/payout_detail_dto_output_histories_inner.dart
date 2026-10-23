//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_detail_dto_output_histories_inner.g.dart';

/// PayoutDetailDtoOutputHistoriesInner
///
/// Properties:
/// * [fromStatus] 
/// * [toStatus] 
/// * [reason] 
/// * [actor] 
/// * [createdAt] 
@BuiltValue()
abstract class PayoutDetailDtoOutputHistoriesInner implements Built<PayoutDetailDtoOutputHistoriesInner, PayoutDetailDtoOutputHistoriesInnerBuilder> {
  @BuiltValueField(wireName: r'fromStatus')
  PayoutDetailDtoOutputHistoriesInnerFromStatusEnum? get fromStatus;
  // enum fromStatusEnum {  PENDING_REVIEW,  ON_HOLD,  READY_TO_TRANSFER,  TRANSFERRING,  PAID,  FAILED,  CANCELLED,  };

  @BuiltValueField(wireName: r'toStatus')
  PayoutDetailDtoOutputHistoriesInnerToStatusEnum get toStatus;
  // enum toStatusEnum {  PENDING_REVIEW,  ON_HOLD,  READY_TO_TRANSFER,  TRANSFERRING,  PAID,  FAILED,  CANCELLED,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'actor')
  String? get actor;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  PayoutDetailDtoOutputHistoriesInner._();

  factory PayoutDetailDtoOutputHistoriesInner([void updates(PayoutDetailDtoOutputHistoriesInnerBuilder b)]) = _$PayoutDetailDtoOutputHistoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PayoutDetailDtoOutputHistoriesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PayoutDetailDtoOutputHistoriesInner> get serializer => _$PayoutDetailDtoOutputHistoriesInnerSerializer();
}

class _$PayoutDetailDtoOutputHistoriesInnerSerializer implements PrimitiveSerializer<PayoutDetailDtoOutputHistoriesInner> {
  @override
  final Iterable<Type> types = const [PayoutDetailDtoOutputHistoriesInner, _$PayoutDetailDtoOutputHistoriesInner];

  @override
  final String wireName = r'PayoutDetailDtoOutputHistoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PayoutDetailDtoOutputHistoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fromStatus';
    yield object.fromStatus == null ? null : serializers.serialize(
      object.fromStatus,
      specifiedType: const FullType.nullable(PayoutDetailDtoOutputHistoriesInnerFromStatusEnum),
    );
    yield r'toStatus';
    yield serializers.serialize(
      object.toStatus,
      specifiedType: const FullType(PayoutDetailDtoOutputHistoriesInnerToStatusEnum),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'actor';
    yield object.actor == null ? null : serializers.serialize(
      object.actor,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PayoutDetailDtoOutputHistoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PayoutDetailDtoOutputHistoriesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fromStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PayoutDetailDtoOutputHistoriesInnerFromStatusEnum),
          ) as PayoutDetailDtoOutputHistoriesInnerFromStatusEnum?;
          if (valueDes == null) continue;
          result.fromStatus = valueDes;
          break;
        case r'toStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PayoutDetailDtoOutputHistoriesInnerToStatusEnum),
          ) as PayoutDetailDtoOutputHistoriesInnerToStatusEnum;
          result.toStatus = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'actor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.actor = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PayoutDetailDtoOutputHistoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PayoutDetailDtoOutputHistoriesInnerBuilder();
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


class PayoutDetailDtoOutputHistoriesInnerFromStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_REVIEW')
  static const PayoutDetailDtoOutputHistoriesInnerFromStatusEnum PENDING_REVIEW = _$payoutDetailDtoOutputHistoriesInnerFromStatusEnum_PENDING_REVIEW;
  @BuiltValueEnumConst(wireName: r'ON_HOLD')
  static const PayoutDetailDtoOutputHistoriesInnerFromStatusEnum ON_HOLD = _$payoutDetailDtoOutputHistoriesInnerFromStatusEnum_ON_HOLD;
  @BuiltValueEnumConst(wireName: r'READY_TO_TRANSFER')
  static const PayoutDetailDtoOutputHistoriesInnerFromStatusEnum READY_TO_TRANSFER = _$payoutDetailDtoOutputHistoriesInnerFromStatusEnum_READY_TO_TRANSFER;
  @BuiltValueEnumConst(wireName: r'TRANSFERRING')
  static const PayoutDetailDtoOutputHistoriesInnerFromStatusEnum TRANSFERRING = _$payoutDetailDtoOutputHistoriesInnerFromStatusEnum_TRANSFERRING;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const PayoutDetailDtoOutputHistoriesInnerFromStatusEnum PAID = _$payoutDetailDtoOutputHistoriesInnerFromStatusEnum_PAID;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const PayoutDetailDtoOutputHistoriesInnerFromStatusEnum FAILED = _$payoutDetailDtoOutputHistoriesInnerFromStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const PayoutDetailDtoOutputHistoriesInnerFromStatusEnum CANCELLED = _$payoutDetailDtoOutputHistoriesInnerFromStatusEnum_CANCELLED;

  static Serializer<PayoutDetailDtoOutputHistoriesInnerFromStatusEnum> get serializer => _$payoutDetailDtoOutputHistoriesInnerFromStatusEnumSerializer;

  const PayoutDetailDtoOutputHistoriesInnerFromStatusEnum._(String name): super(name);

  static BuiltSet<PayoutDetailDtoOutputHistoriesInnerFromStatusEnum> get values => _$payoutDetailDtoOutputHistoriesInnerFromStatusEnumValues;
  static PayoutDetailDtoOutputHistoriesInnerFromStatusEnum valueOf(String name) => _$payoutDetailDtoOutputHistoriesInnerFromStatusEnumValueOf(name);
}

class PayoutDetailDtoOutputHistoriesInnerToStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_REVIEW')
  static const PayoutDetailDtoOutputHistoriesInnerToStatusEnum PENDING_REVIEW = _$payoutDetailDtoOutputHistoriesInnerToStatusEnum_PENDING_REVIEW;
  @BuiltValueEnumConst(wireName: r'ON_HOLD')
  static const PayoutDetailDtoOutputHistoriesInnerToStatusEnum ON_HOLD = _$payoutDetailDtoOutputHistoriesInnerToStatusEnum_ON_HOLD;
  @BuiltValueEnumConst(wireName: r'READY_TO_TRANSFER')
  static const PayoutDetailDtoOutputHistoriesInnerToStatusEnum READY_TO_TRANSFER = _$payoutDetailDtoOutputHistoriesInnerToStatusEnum_READY_TO_TRANSFER;
  @BuiltValueEnumConst(wireName: r'TRANSFERRING')
  static const PayoutDetailDtoOutputHistoriesInnerToStatusEnum TRANSFERRING = _$payoutDetailDtoOutputHistoriesInnerToStatusEnum_TRANSFERRING;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const PayoutDetailDtoOutputHistoriesInnerToStatusEnum PAID = _$payoutDetailDtoOutputHistoriesInnerToStatusEnum_PAID;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const PayoutDetailDtoOutputHistoriesInnerToStatusEnum FAILED = _$payoutDetailDtoOutputHistoriesInnerToStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const PayoutDetailDtoOutputHistoriesInnerToStatusEnum CANCELLED = _$payoutDetailDtoOutputHistoriesInnerToStatusEnum_CANCELLED;

  static Serializer<PayoutDetailDtoOutputHistoriesInnerToStatusEnum> get serializer => _$payoutDetailDtoOutputHistoriesInnerToStatusEnumSerializer;

  const PayoutDetailDtoOutputHistoriesInnerToStatusEnum._(String name): super(name);

  static BuiltSet<PayoutDetailDtoOutputHistoriesInnerToStatusEnum> get values => _$payoutDetailDtoOutputHistoriesInnerToStatusEnumValues;
  static PayoutDetailDtoOutputHistoriesInnerToStatusEnum valueOf(String name) => _$payoutDetailDtoOutputHistoriesInnerToStatusEnumValueOf(name);
}

