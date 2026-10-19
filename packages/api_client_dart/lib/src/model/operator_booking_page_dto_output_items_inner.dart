//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/operator_booking_page_dto_output_items_inner_payment.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/operator_booking_page_dto_output_items_inner_trip.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_booking_page_dto_output_items_inner.g.dart';

/// OperatorBookingPageDtoOutputItemsInner
///
/// Properties:
/// * [bookingId] 
/// * [bookingCode] 
/// * [status] 
/// * [createdAt] 
/// * [contactName] 
/// * [contactPhoneMasked] 
/// * [guest] 
/// * [trip] 
/// * [seatCodes] 
/// * [cancelledTicketCount] 
/// * [total] 
/// * [payment] 
@BuiltValue()
abstract class OperatorBookingPageDtoOutputItemsInner implements Built<OperatorBookingPageDtoOutputItemsInner, OperatorBookingPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'status')
  OperatorBookingPageDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  PENDING_PAYMENT,  PENDING_CONFIRMATION,  PAID,  CONFIRMED,  PARTIALLY_CANCELLED,  CANCELLED,  EXPIRED,  REFUND_PENDING,  REFUNDED,  REFUND_FAILED,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'contactName')
  String get contactName;

  @BuiltValueField(wireName: r'contactPhoneMasked')
  String get contactPhoneMasked;

  @BuiltValueField(wireName: r'guest')
  bool get guest;

  @BuiltValueField(wireName: r'trip')
  OperatorBookingPageDtoOutputItemsInnerTrip get trip;

  @BuiltValueField(wireName: r'seatCodes')
  BuiltList<String> get seatCodes;

  @BuiltValueField(wireName: r'cancelledTicketCount')
  int get cancelledTicketCount;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'payment')
  OperatorBookingPageDtoOutputItemsInnerPayment? get payment;

  OperatorBookingPageDtoOutputItemsInner._();

  factory OperatorBookingPageDtoOutputItemsInner([void updates(OperatorBookingPageDtoOutputItemsInnerBuilder b)]) = _$OperatorBookingPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorBookingPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorBookingPageDtoOutputItemsInner> get serializer => _$OperatorBookingPageDtoOutputItemsInnerSerializer();
}

class _$OperatorBookingPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<OperatorBookingPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [OperatorBookingPageDtoOutputItemsInner, _$OperatorBookingPageDtoOutputItemsInner];

  @override
  final String wireName = r'OperatorBookingPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorBookingPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'bookingId';
    yield serializers.serialize(
      object.bookingId,
      specifiedType: const FullType(String),
    );
    yield r'bookingCode';
    yield serializers.serialize(
      object.bookingCode,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(OperatorBookingPageDtoOutputItemsInnerStatusEnum),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'contactName';
    yield serializers.serialize(
      object.contactName,
      specifiedType: const FullType(String),
    );
    yield r'contactPhoneMasked';
    yield serializers.serialize(
      object.contactPhoneMasked,
      specifiedType: const FullType(String),
    );
    yield r'guest';
    yield serializers.serialize(
      object.guest,
      specifiedType: const FullType(bool),
    );
    yield r'trip';
    yield serializers.serialize(
      object.trip,
      specifiedType: const FullType(OperatorBookingPageDtoOutputItemsInnerTrip),
    );
    yield r'seatCodes';
    yield serializers.serialize(
      object.seatCodes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'cancelledTicketCount';
    yield serializers.serialize(
      object.cancelledTicketCount,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'payment';
    yield object.payment == null ? null : serializers.serialize(
      object.payment,
      specifiedType: const FullType.nullable(OperatorBookingPageDtoOutputItemsInnerPayment),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorBookingPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorBookingPageDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bookingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingId = valueDes;
          break;
        case r'bookingCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingCode = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperatorBookingPageDtoOutputItemsInnerStatusEnum),
          ) as OperatorBookingPageDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'contactName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contactName = valueDes;
          break;
        case r'contactPhoneMasked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contactPhoneMasked = valueDes;
          break;
        case r'guest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.guest = valueDes;
          break;
        case r'trip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperatorBookingPageDtoOutputItemsInnerTrip),
          ) as OperatorBookingPageDtoOutputItemsInnerTrip;
          result.trip.replace(valueDes);
          break;
        case r'seatCodes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.seatCodes.replace(valueDes);
          break;
        case r'cancelledTicketCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cancelledTicketCount = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'payment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OperatorBookingPageDtoOutputItemsInnerPayment),
          ) as OperatorBookingPageDtoOutputItemsInnerPayment?;
          if (valueDes == null) continue;
          result.payment.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorBookingPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorBookingPageDtoOutputItemsInnerBuilder();
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


class OperatorBookingPageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_PAYMENT')
  static const OperatorBookingPageDtoOutputItemsInnerStatusEnum PENDING_PAYMENT = _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PENDING_PAYMENT;
  @BuiltValueEnumConst(wireName: r'PENDING_CONFIRMATION')
  static const OperatorBookingPageDtoOutputItemsInnerStatusEnum PENDING_CONFIRMATION = _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PENDING_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const OperatorBookingPageDtoOutputItemsInnerStatusEnum PAID = _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PAID;
  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const OperatorBookingPageDtoOutputItemsInnerStatusEnum CONFIRMED = _$operatorBookingPageDtoOutputItemsInnerStatusEnum_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'PARTIALLY_CANCELLED')
  static const OperatorBookingPageDtoOutputItemsInnerStatusEnum PARTIALLY_CANCELLED = _$operatorBookingPageDtoOutputItemsInnerStatusEnum_PARTIALLY_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const OperatorBookingPageDtoOutputItemsInnerStatusEnum CANCELLED = _$operatorBookingPageDtoOutputItemsInnerStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const OperatorBookingPageDtoOutputItemsInnerStatusEnum EXPIRED = _$operatorBookingPageDtoOutputItemsInnerStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'REFUND_PENDING')
  static const OperatorBookingPageDtoOutputItemsInnerStatusEnum REFUND_PENDING = _$operatorBookingPageDtoOutputItemsInnerStatusEnum_REFUND_PENDING;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const OperatorBookingPageDtoOutputItemsInnerStatusEnum REFUNDED = _$operatorBookingPageDtoOutputItemsInnerStatusEnum_REFUNDED;
  @BuiltValueEnumConst(wireName: r'REFUND_FAILED')
  static const OperatorBookingPageDtoOutputItemsInnerStatusEnum REFUND_FAILED = _$operatorBookingPageDtoOutputItemsInnerStatusEnum_REFUND_FAILED;

  static Serializer<OperatorBookingPageDtoOutputItemsInnerStatusEnum> get serializer => _$operatorBookingPageDtoOutputItemsInnerStatusEnumSerializer;

  const OperatorBookingPageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<OperatorBookingPageDtoOutputItemsInnerStatusEnum> get values => _$operatorBookingPageDtoOutputItemsInnerStatusEnumValues;
  static OperatorBookingPageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$operatorBookingPageDtoOutputItemsInnerStatusEnumValueOf(name);
}

