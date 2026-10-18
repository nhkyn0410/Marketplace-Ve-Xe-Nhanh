//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/operator_booking_detail_dto_output_seats_inner.dart';
import 'package:api_client_dart/src/model/operator_booking_page_dto_output_items_inner_payment.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/operator_booking_page_dto_output_items_inner_trip.dart';
import 'package:api_client_dart/src/model/public_trip_dto_output_cancellation_policy.dart';
import 'package:api_client_dart/src/model/trip_search_response_dto_output_items_inner_pickup.dart';
import 'package:api_client_dart/src/model/operator_booking_detail_dto_output_histories_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_booking_detail_dto_output.g.dart';

/// OperatorBookingDetailDtoOutput
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
/// * [contactEmailMasked] 
/// * [note] 
/// * [pickup] 
/// * [dropoff] 
/// * [seats] 
/// * [subtotal] 
/// * [serviceFee] 
/// * [discount] 
/// * [cancellationPolicy] 
/// * [histories] 
@BuiltValue()
abstract class OperatorBookingDetailDtoOutput implements Built<OperatorBookingDetailDtoOutput, OperatorBookingDetailDtoOutputBuilder> {
  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'status')
  OperatorBookingDetailDtoOutputStatusEnum get status;
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

  @BuiltValueField(wireName: r'contactEmailMasked')
  String get contactEmailMasked;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'pickup')
  TripSearchResponseDtoOutputItemsInnerPickup get pickup;

  @BuiltValueField(wireName: r'dropoff')
  TripSearchResponseDtoOutputItemsInnerPickup get dropoff;

  @BuiltValueField(wireName: r'seats')
  BuiltList<OperatorBookingDetailDtoOutputSeatsInner> get seats;

  @BuiltValueField(wireName: r'subtotal')
  int get subtotal;

  @BuiltValueField(wireName: r'serviceFee')
  int get serviceFee;

  @BuiltValueField(wireName: r'discount')
  int get discount;

  @BuiltValueField(wireName: r'cancellationPolicy')
  PublicTripDtoOutputCancellationPolicy get cancellationPolicy;

  @BuiltValueField(wireName: r'histories')
  BuiltList<OperatorBookingDetailDtoOutputHistoriesInner> get histories;

  OperatorBookingDetailDtoOutput._();

  factory OperatorBookingDetailDtoOutput([void updates(OperatorBookingDetailDtoOutputBuilder b)]) = _$OperatorBookingDetailDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorBookingDetailDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorBookingDetailDtoOutput> get serializer => _$OperatorBookingDetailDtoOutputSerializer();
}

class _$OperatorBookingDetailDtoOutputSerializer implements PrimitiveSerializer<OperatorBookingDetailDtoOutput> {
  @override
  final Iterable<Type> types = const [OperatorBookingDetailDtoOutput, _$OperatorBookingDetailDtoOutput];

  @override
  final String wireName = r'OperatorBookingDetailDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorBookingDetailDtoOutput object, {
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
      specifiedType: const FullType(OperatorBookingDetailDtoOutputStatusEnum),
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
    yield r'contactEmailMasked';
    yield serializers.serialize(
      object.contactEmailMasked,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
    yield r'pickup';
    yield serializers.serialize(
      object.pickup,
      specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerPickup),
    );
    yield r'dropoff';
    yield serializers.serialize(
      object.dropoff,
      specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerPickup),
    );
    yield r'seats';
    yield serializers.serialize(
      object.seats,
      specifiedType: const FullType(BuiltList, [FullType(OperatorBookingDetailDtoOutputSeatsInner)]),
    );
    yield r'subtotal';
    yield serializers.serialize(
      object.subtotal,
      specifiedType: const FullType(int),
    );
    yield r'serviceFee';
    yield serializers.serialize(
      object.serviceFee,
      specifiedType: const FullType(int),
    );
    yield r'discount';
    yield serializers.serialize(
      object.discount,
      specifiedType: const FullType(int),
    );
    yield r'cancellationPolicy';
    yield serializers.serialize(
      object.cancellationPolicy,
      specifiedType: const FullType(PublicTripDtoOutputCancellationPolicy),
    );
    yield r'histories';
    yield serializers.serialize(
      object.histories,
      specifiedType: const FullType(BuiltList, [FullType(OperatorBookingDetailDtoOutputHistoriesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorBookingDetailDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorBookingDetailDtoOutputBuilder result,
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
            specifiedType: const FullType(OperatorBookingDetailDtoOutputStatusEnum),
          ) as OperatorBookingDetailDtoOutputStatusEnum;
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
        case r'contactEmailMasked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contactEmailMasked = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'pickup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerPickup),
          ) as TripSearchResponseDtoOutputItemsInnerPickup;
          result.pickup.replace(valueDes);
          break;
        case r'dropoff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSearchResponseDtoOutputItemsInnerPickup),
          ) as TripSearchResponseDtoOutputItemsInnerPickup;
          result.dropoff.replace(valueDes);
          break;
        case r'seats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OperatorBookingDetailDtoOutputSeatsInner)]),
          ) as BuiltList<OperatorBookingDetailDtoOutputSeatsInner>;
          result.seats.replace(valueDes);
          break;
        case r'subtotal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.subtotal = valueDes;
          break;
        case r'serviceFee':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.serviceFee = valueDes;
          break;
        case r'discount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.discount = valueDes;
          break;
        case r'cancellationPolicy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicTripDtoOutputCancellationPolicy),
          ) as PublicTripDtoOutputCancellationPolicy;
          result.cancellationPolicy.replace(valueDes);
          break;
        case r'histories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OperatorBookingDetailDtoOutputHistoriesInner)]),
          ) as BuiltList<OperatorBookingDetailDtoOutputHistoriesInner>;
          result.histories.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperatorBookingDetailDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorBookingDetailDtoOutputBuilder();
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


class OperatorBookingDetailDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_PAYMENT')
  static const OperatorBookingDetailDtoOutputStatusEnum PENDING_PAYMENT = _$operatorBookingDetailDtoOutputStatusEnum_PENDING_PAYMENT;
  @BuiltValueEnumConst(wireName: r'PENDING_CONFIRMATION')
  static const OperatorBookingDetailDtoOutputStatusEnum PENDING_CONFIRMATION = _$operatorBookingDetailDtoOutputStatusEnum_PENDING_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const OperatorBookingDetailDtoOutputStatusEnum PAID = _$operatorBookingDetailDtoOutputStatusEnum_PAID;
  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const OperatorBookingDetailDtoOutputStatusEnum CONFIRMED = _$operatorBookingDetailDtoOutputStatusEnum_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'PARTIALLY_CANCELLED')
  static const OperatorBookingDetailDtoOutputStatusEnum PARTIALLY_CANCELLED = _$operatorBookingDetailDtoOutputStatusEnum_PARTIALLY_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const OperatorBookingDetailDtoOutputStatusEnum CANCELLED = _$operatorBookingDetailDtoOutputStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const OperatorBookingDetailDtoOutputStatusEnum EXPIRED = _$operatorBookingDetailDtoOutputStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'REFUND_PENDING')
  static const OperatorBookingDetailDtoOutputStatusEnum REFUND_PENDING = _$operatorBookingDetailDtoOutputStatusEnum_REFUND_PENDING;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const OperatorBookingDetailDtoOutputStatusEnum REFUNDED = _$operatorBookingDetailDtoOutputStatusEnum_REFUNDED;
  @BuiltValueEnumConst(wireName: r'REFUND_FAILED')
  static const OperatorBookingDetailDtoOutputStatusEnum REFUND_FAILED = _$operatorBookingDetailDtoOutputStatusEnum_REFUND_FAILED;

  static Serializer<OperatorBookingDetailDtoOutputStatusEnum> get serializer => _$operatorBookingDetailDtoOutputStatusEnumSerializer;

  const OperatorBookingDetailDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<OperatorBookingDetailDtoOutputStatusEnum> get values => _$operatorBookingDetailDtoOutputStatusEnumValues;
  static OperatorBookingDetailDtoOutputStatusEnum valueOf(String name) => _$operatorBookingDetailDtoOutputStatusEnumValueOf(name);
}

