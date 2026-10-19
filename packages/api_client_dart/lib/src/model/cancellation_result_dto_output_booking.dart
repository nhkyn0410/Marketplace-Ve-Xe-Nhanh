//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/created_booking_dto_output_refunds_inner.dart';
import 'package:api_client_dart/src/model/created_booking_dto_output_contact.dart';
import 'package:api_client_dart/src/model/created_booking_dto_output_payment.dart';
import 'package:api_client_dart/src/model/created_booking_dto_output_tickets_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/created_booking_dto_output_passengers_inner.dart';
import 'package:api_client_dart/src/model/created_booking_dto_output_trip.dart';
import 'package:api_client_dart/src/model/created_booking_dto_output_trip_changes_inner.dart';
import 'package:api_client_dart/src/model/public_trip_dto_output_cancellation_policy.dart';
import 'package:api_client_dart/src/model/trip_search_response_dto_output_items_inner_pickup.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancellation_result_dto_output_booking.g.dart';

/// CancellationResultDtoOutputBooking
///
/// Properties:
/// * [bookingId] 
/// * [bookingCode] 
/// * [status] 
/// * [tripId] 
/// * [trip] 
/// * [pickup] 
/// * [dropoff] 
/// * [contact] 
/// * [passengers] 
/// * [note] 
/// * [subtotal] 
/// * [serviceFee] 
/// * [discount] 
/// * [total] 
/// * [cancellationPolicy] 
/// * [expiresAt] 
/// * [payment] 
/// * [tickets] 
/// * [refunds] 
/// * [tripChanges] 
/// * [createdAt] 
@BuiltValue()
abstract class CancellationResultDtoOutputBooking implements Built<CancellationResultDtoOutputBooking, CancellationResultDtoOutputBookingBuilder> {
  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'status')
  CancellationResultDtoOutputBookingStatusEnum get status;
  // enum statusEnum {  PENDING_PAYMENT,  PENDING_CONFIRMATION,  PAID,  CONFIRMED,  PARTIALLY_CANCELLED,  CANCELLED,  EXPIRED,  REFUND_PENDING,  REFUNDED,  REFUND_FAILED,  };

  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'trip')
  CreatedBookingDtoOutputTrip get trip;

  @BuiltValueField(wireName: r'pickup')
  TripSearchResponseDtoOutputItemsInnerPickup get pickup;

  @BuiltValueField(wireName: r'dropoff')
  TripSearchResponseDtoOutputItemsInnerPickup get dropoff;

  @BuiltValueField(wireName: r'contact')
  CreatedBookingDtoOutputContact get contact;

  @BuiltValueField(wireName: r'passengers')
  BuiltList<CreatedBookingDtoOutputPassengersInner> get passengers;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'subtotal')
  int get subtotal;

  @BuiltValueField(wireName: r'serviceFee')
  int get serviceFee;

  @BuiltValueField(wireName: r'discount')
  int get discount;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'cancellationPolicy')
  PublicTripDtoOutputCancellationPolicy get cancellationPolicy;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'payment')
  CreatedBookingDtoOutputPayment? get payment;

  @BuiltValueField(wireName: r'tickets')
  BuiltList<CreatedBookingDtoOutputTicketsInner> get tickets;

  @BuiltValueField(wireName: r'refunds')
  BuiltList<CreatedBookingDtoOutputRefundsInner> get refunds;

  @BuiltValueField(wireName: r'tripChanges')
  BuiltList<CreatedBookingDtoOutputTripChangesInner> get tripChanges;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  CancellationResultDtoOutputBooking._();

  factory CancellationResultDtoOutputBooking([void updates(CancellationResultDtoOutputBookingBuilder b)]) = _$CancellationResultDtoOutputBooking;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancellationResultDtoOutputBookingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancellationResultDtoOutputBooking> get serializer => _$CancellationResultDtoOutputBookingSerializer();
}

class _$CancellationResultDtoOutputBookingSerializer implements PrimitiveSerializer<CancellationResultDtoOutputBooking> {
  @override
  final Iterable<Type> types = const [CancellationResultDtoOutputBooking, _$CancellationResultDtoOutputBooking];

  @override
  final String wireName = r'CancellationResultDtoOutputBooking';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancellationResultDtoOutputBooking object, {
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
      specifiedType: const FullType(CancellationResultDtoOutputBookingStatusEnum),
    );
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'trip';
    yield serializers.serialize(
      object.trip,
      specifiedType: const FullType(CreatedBookingDtoOutputTrip),
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
    yield r'contact';
    yield serializers.serialize(
      object.contact,
      specifiedType: const FullType(CreatedBookingDtoOutputContact),
    );
    yield r'passengers';
    yield serializers.serialize(
      object.passengers,
      specifiedType: const FullType(BuiltList, [FullType(CreatedBookingDtoOutputPassengersInner)]),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
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
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'cancellationPolicy';
    yield serializers.serialize(
      object.cancellationPolicy,
      specifiedType: const FullType(PublicTripDtoOutputCancellationPolicy),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'payment';
    yield object.payment == null ? null : serializers.serialize(
      object.payment,
      specifiedType: const FullType.nullable(CreatedBookingDtoOutputPayment),
    );
    yield r'tickets';
    yield serializers.serialize(
      object.tickets,
      specifiedType: const FullType(BuiltList, [FullType(CreatedBookingDtoOutputTicketsInner)]),
    );
    yield r'refunds';
    yield serializers.serialize(
      object.refunds,
      specifiedType: const FullType(BuiltList, [FullType(CreatedBookingDtoOutputRefundsInner)]),
    );
    yield r'tripChanges';
    yield serializers.serialize(
      object.tripChanges,
      specifiedType: const FullType(BuiltList, [FullType(CreatedBookingDtoOutputTripChangesInner)]),
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
    CancellationResultDtoOutputBooking object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancellationResultDtoOutputBookingBuilder result,
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
            specifiedType: const FullType(CancellationResultDtoOutputBookingStatusEnum),
          ) as CancellationResultDtoOutputBookingStatusEnum;
          result.status = valueDes;
          break;
        case r'tripId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tripId = valueDes;
          break;
        case r'trip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreatedBookingDtoOutputTrip),
          ) as CreatedBookingDtoOutputTrip;
          result.trip.replace(valueDes);
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
        case r'contact':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreatedBookingDtoOutputContact),
          ) as CreatedBookingDtoOutputContact;
          result.contact.replace(valueDes);
          break;
        case r'passengers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreatedBookingDtoOutputPassengersInner)]),
          ) as BuiltList<CreatedBookingDtoOutputPassengersInner>;
          result.passengers.replace(valueDes);
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
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
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'cancellationPolicy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicTripDtoOutputCancellationPolicy),
          ) as PublicTripDtoOutputCancellationPolicy;
          result.cancellationPolicy.replace(valueDes);
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'payment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CreatedBookingDtoOutputPayment),
          ) as CreatedBookingDtoOutputPayment?;
          if (valueDes == null) continue;
          result.payment.replace(valueDes);
          break;
        case r'tickets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreatedBookingDtoOutputTicketsInner)]),
          ) as BuiltList<CreatedBookingDtoOutputTicketsInner>;
          result.tickets.replace(valueDes);
          break;
        case r'refunds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreatedBookingDtoOutputRefundsInner)]),
          ) as BuiltList<CreatedBookingDtoOutputRefundsInner>;
          result.refunds.replace(valueDes);
          break;
        case r'tripChanges':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CreatedBookingDtoOutputTripChangesInner)]),
          ) as BuiltList<CreatedBookingDtoOutputTripChangesInner>;
          result.tripChanges.replace(valueDes);
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
  CancellationResultDtoOutputBooking deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancellationResultDtoOutputBookingBuilder();
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


class CancellationResultDtoOutputBookingStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_PAYMENT')
  static const CancellationResultDtoOutputBookingStatusEnum PENDING_PAYMENT = _$cancellationResultDtoOutputBookingStatusEnum_PENDING_PAYMENT;
  @BuiltValueEnumConst(wireName: r'PENDING_CONFIRMATION')
  static const CancellationResultDtoOutputBookingStatusEnum PENDING_CONFIRMATION = _$cancellationResultDtoOutputBookingStatusEnum_PENDING_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const CancellationResultDtoOutputBookingStatusEnum PAID = _$cancellationResultDtoOutputBookingStatusEnum_PAID;
  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const CancellationResultDtoOutputBookingStatusEnum CONFIRMED = _$cancellationResultDtoOutputBookingStatusEnum_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'PARTIALLY_CANCELLED')
  static const CancellationResultDtoOutputBookingStatusEnum PARTIALLY_CANCELLED = _$cancellationResultDtoOutputBookingStatusEnum_PARTIALLY_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CancellationResultDtoOutputBookingStatusEnum CANCELLED = _$cancellationResultDtoOutputBookingStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const CancellationResultDtoOutputBookingStatusEnum EXPIRED = _$cancellationResultDtoOutputBookingStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'REFUND_PENDING')
  static const CancellationResultDtoOutputBookingStatusEnum REFUND_PENDING = _$cancellationResultDtoOutputBookingStatusEnum_REFUND_PENDING;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const CancellationResultDtoOutputBookingStatusEnum REFUNDED = _$cancellationResultDtoOutputBookingStatusEnum_REFUNDED;
  @BuiltValueEnumConst(wireName: r'REFUND_FAILED')
  static const CancellationResultDtoOutputBookingStatusEnum REFUND_FAILED = _$cancellationResultDtoOutputBookingStatusEnum_REFUND_FAILED;

  static Serializer<CancellationResultDtoOutputBookingStatusEnum> get serializer => _$cancellationResultDtoOutputBookingStatusEnumSerializer;

  const CancellationResultDtoOutputBookingStatusEnum._(String name): super(name);

  static BuiltSet<CancellationResultDtoOutputBookingStatusEnum> get values => _$cancellationResultDtoOutputBookingStatusEnumValues;
  static CancellationResultDtoOutputBookingStatusEnum valueOf(String name) => _$cancellationResultDtoOutputBookingStatusEnumValueOf(name);
}

