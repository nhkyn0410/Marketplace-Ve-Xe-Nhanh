//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_booking_detail_dto_output_histories_inner.g.dart';

/// OperatorBookingDetailDtoOutputHistoriesInner
///
/// Properties:
/// * [fromStatus] 
/// * [toStatus] 
/// * [reason] 
/// * [actor] 
/// * [createdAt] 
@BuiltValue()
abstract class OperatorBookingDetailDtoOutputHistoriesInner implements Built<OperatorBookingDetailDtoOutputHistoriesInner, OperatorBookingDetailDtoOutputHistoriesInnerBuilder> {
  @BuiltValueField(wireName: r'fromStatus')
  OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum? get fromStatus;
  // enum fromStatusEnum {  PENDING_PAYMENT,  PENDING_CONFIRMATION,  PAID,  CONFIRMED,  PARTIALLY_CANCELLED,  CANCELLED,  EXPIRED,  REFUND_PENDING,  REFUNDED,  REFUND_FAILED,  };

  @BuiltValueField(wireName: r'toStatus')
  OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum get toStatus;
  // enum toStatusEnum {  PENDING_PAYMENT,  PENDING_CONFIRMATION,  PAID,  CONFIRMED,  PARTIALLY_CANCELLED,  CANCELLED,  EXPIRED,  REFUND_PENDING,  REFUNDED,  REFUND_FAILED,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'actor')
  String get actor;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  OperatorBookingDetailDtoOutputHistoriesInner._();

  factory OperatorBookingDetailDtoOutputHistoriesInner([void updates(OperatorBookingDetailDtoOutputHistoriesInnerBuilder b)]) = _$OperatorBookingDetailDtoOutputHistoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorBookingDetailDtoOutputHistoriesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorBookingDetailDtoOutputHistoriesInner> get serializer => _$OperatorBookingDetailDtoOutputHistoriesInnerSerializer();
}

class _$OperatorBookingDetailDtoOutputHistoriesInnerSerializer implements PrimitiveSerializer<OperatorBookingDetailDtoOutputHistoriesInner> {
  @override
  final Iterable<Type> types = const [OperatorBookingDetailDtoOutputHistoriesInner, _$OperatorBookingDetailDtoOutputHistoriesInner];

  @override
  final String wireName = r'OperatorBookingDetailDtoOutputHistoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorBookingDetailDtoOutputHistoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fromStatus';
    yield object.fromStatus == null ? null : serializers.serialize(
      object.fromStatus,
      specifiedType: const FullType.nullable(OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum),
    );
    yield r'toStatus';
    yield serializers.serialize(
      object.toStatus,
      specifiedType: const FullType(OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'actor';
    yield serializers.serialize(
      object.actor,
      specifiedType: const FullType(String),
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
    OperatorBookingDetailDtoOutputHistoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorBookingDetailDtoOutputHistoriesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fromStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum),
          ) as OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum?;
          if (valueDes == null) continue;
          result.fromStatus = valueDes;
          break;
        case r'toStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum),
          ) as OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum;
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
            specifiedType: const FullType(String),
          ) as String;
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
  OperatorBookingDetailDtoOutputHistoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorBookingDetailDtoOutputHistoriesInnerBuilder();
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


class OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_PAYMENT')
  static const OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum PENDING_PAYMENT = _$operatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum_PENDING_PAYMENT;
  @BuiltValueEnumConst(wireName: r'PENDING_CONFIRMATION')
  static const OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum PENDING_CONFIRMATION = _$operatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum_PENDING_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum PAID = _$operatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum_PAID;
  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum CONFIRMED = _$operatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'PARTIALLY_CANCELLED')
  static const OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum PARTIALLY_CANCELLED = _$operatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum_PARTIALLY_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum CANCELLED = _$operatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum EXPIRED = _$operatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'REFUND_PENDING')
  static const OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum REFUND_PENDING = _$operatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum_REFUND_PENDING;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum REFUNDED = _$operatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum_REFUNDED;
  @BuiltValueEnumConst(wireName: r'REFUND_FAILED')
  static const OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum REFUND_FAILED = _$operatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum_REFUND_FAILED;

  static Serializer<OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum> get serializer => _$operatorBookingDetailDtoOutputHistoriesInnerFromStatusEnumSerializer;

  const OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum._(String name): super(name);

  static BuiltSet<OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum> get values => _$operatorBookingDetailDtoOutputHistoriesInnerFromStatusEnumValues;
  static OperatorBookingDetailDtoOutputHistoriesInnerFromStatusEnum valueOf(String name) => _$operatorBookingDetailDtoOutputHistoriesInnerFromStatusEnumValueOf(name);
}

class OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_PAYMENT')
  static const OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum PENDING_PAYMENT = _$operatorBookingDetailDtoOutputHistoriesInnerToStatusEnum_PENDING_PAYMENT;
  @BuiltValueEnumConst(wireName: r'PENDING_CONFIRMATION')
  static const OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum PENDING_CONFIRMATION = _$operatorBookingDetailDtoOutputHistoriesInnerToStatusEnum_PENDING_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum PAID = _$operatorBookingDetailDtoOutputHistoriesInnerToStatusEnum_PAID;
  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum CONFIRMED = _$operatorBookingDetailDtoOutputHistoriesInnerToStatusEnum_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'PARTIALLY_CANCELLED')
  static const OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum PARTIALLY_CANCELLED = _$operatorBookingDetailDtoOutputHistoriesInnerToStatusEnum_PARTIALLY_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum CANCELLED = _$operatorBookingDetailDtoOutputHistoriesInnerToStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum EXPIRED = _$operatorBookingDetailDtoOutputHistoriesInnerToStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'REFUND_PENDING')
  static const OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum REFUND_PENDING = _$operatorBookingDetailDtoOutputHistoriesInnerToStatusEnum_REFUND_PENDING;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum REFUNDED = _$operatorBookingDetailDtoOutputHistoriesInnerToStatusEnum_REFUNDED;
  @BuiltValueEnumConst(wireName: r'REFUND_FAILED')
  static const OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum REFUND_FAILED = _$operatorBookingDetailDtoOutputHistoriesInnerToStatusEnum_REFUND_FAILED;

  static Serializer<OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum> get serializer => _$operatorBookingDetailDtoOutputHistoriesInnerToStatusEnumSerializer;

  const OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum._(String name): super(name);

  static BuiltSet<OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum> get values => _$operatorBookingDetailDtoOutputHistoriesInnerToStatusEnumValues;
  static OperatorBookingDetailDtoOutputHistoriesInnerToStatusEnum valueOf(String name) => _$operatorBookingDetailDtoOutputHistoriesInnerToStatusEnumValueOf(name);
}

