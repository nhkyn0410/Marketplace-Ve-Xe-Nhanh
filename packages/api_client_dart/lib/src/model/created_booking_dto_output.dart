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

part 'created_booking_dto_output.g.dart';

/// CreatedBookingDtoOutput
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
/// * [discountFunding]
/// * [total]
/// * [cancellationPolicy]
/// * [expiresAt]
/// * [payment]
/// * [tickets]
/// * [refunds]
/// * [tripChanges]
/// * [createdAt]
/// * [accessToken]
@BuiltValue()
abstract class CreatedBookingDtoOutput
    implements Built<CreatedBookingDtoOutput, CreatedBookingDtoOutputBuilder> {
  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'status')
  CreatedBookingDtoOutputStatusEnum get status;
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

  @BuiltValueField(wireName: r'discountFunding')
  CreatedBookingDtoOutputDiscountFundingEnum? get discountFunding;
  // enum discountFundingEnum {  OPERATOR,  PLATFORM,  };

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

  @BuiltValueField(wireName: r'accessToken')
  String get accessToken;

  CreatedBookingDtoOutput._();

  factory CreatedBookingDtoOutput(
          [void updates(CreatedBookingDtoOutputBuilder b)]) =
      _$CreatedBookingDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreatedBookingDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreatedBookingDtoOutput> get serializer =>
      _$CreatedBookingDtoOutputSerializer();
}

class _$CreatedBookingDtoOutputSerializer
    implements PrimitiveSerializer<CreatedBookingDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CreatedBookingDtoOutput,
    _$CreatedBookingDtoOutput
  ];

  @override
  final String wireName = r'CreatedBookingDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreatedBookingDtoOutput object, {
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
      specifiedType: const FullType(CreatedBookingDtoOutputStatusEnum),
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
      specifiedType:
          const FullType(TripSearchResponseDtoOutputItemsInnerPickup),
    );
    yield r'dropoff';
    yield serializers.serialize(
      object.dropoff,
      specifiedType:
          const FullType(TripSearchResponseDtoOutputItemsInnerPickup),
    );
    yield r'contact';
    yield serializers.serialize(
      object.contact,
      specifiedType: const FullType(CreatedBookingDtoOutputContact),
    );
    yield r'passengers';
    yield serializers.serialize(
      object.passengers,
      specifiedType: const FullType(
          BuiltList, [FullType(CreatedBookingDtoOutputPassengersInner)]),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
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
    yield r'discountFunding';
    yield object.discountFunding == null
        ? null
        : serializers.serialize(
            object.discountFunding,
            specifiedType: const FullType.nullable(
                CreatedBookingDtoOutputDiscountFundingEnum),
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
    yield object.payment == null
        ? null
        : serializers.serialize(
            object.payment,
            specifiedType:
                const FullType.nullable(CreatedBookingDtoOutputPayment),
          );
    yield r'tickets';
    yield serializers.serialize(
      object.tickets,
      specifiedType: const FullType(
          BuiltList, [FullType(CreatedBookingDtoOutputTicketsInner)]),
    );
    yield r'refunds';
    yield serializers.serialize(
      object.refunds,
      specifiedType: const FullType(
          BuiltList, [FullType(CreatedBookingDtoOutputRefundsInner)]),
    );
    yield r'tripChanges';
    yield serializers.serialize(
      object.tripChanges,
      specifiedType: const FullType(
          BuiltList, [FullType(CreatedBookingDtoOutputTripChangesInner)]),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'accessToken';
    yield serializers.serialize(
      object.accessToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreatedBookingDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreatedBookingDtoOutputBuilder result,
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
            specifiedType: const FullType(CreatedBookingDtoOutputStatusEnum),
          ) as CreatedBookingDtoOutputStatusEnum;
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
            specifiedType:
                const FullType(TripSearchResponseDtoOutputItemsInnerPickup),
          ) as TripSearchResponseDtoOutputItemsInnerPickup;
          result.pickup.replace(valueDes);
          break;
        case r'dropoff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(TripSearchResponseDtoOutputItemsInnerPickup),
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
            specifiedType: const FullType(
                BuiltList, [FullType(CreatedBookingDtoOutputPassengersInner)]),
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
        case r'discountFunding':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                CreatedBookingDtoOutputDiscountFundingEnum),
          ) as CreatedBookingDtoOutputDiscountFundingEnum?;
          if (valueDes == null) continue;
          result.discountFunding = valueDes;
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
            specifiedType:
                const FullType(PublicTripDtoOutputCancellationPolicy),
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
            specifiedType:
                const FullType.nullable(CreatedBookingDtoOutputPayment),
          ) as CreatedBookingDtoOutputPayment?;
          if (valueDes == null) continue;
          result.payment.replace(valueDes);
          break;
        case r'tickets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(CreatedBookingDtoOutputTicketsInner)]),
          ) as BuiltList<CreatedBookingDtoOutputTicketsInner>;
          result.tickets.replace(valueDes);
          break;
        case r'refunds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(CreatedBookingDtoOutputRefundsInner)]),
          ) as BuiltList<CreatedBookingDtoOutputRefundsInner>;
          result.refunds.replace(valueDes);
          break;
        case r'tripChanges':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(CreatedBookingDtoOutputTripChangesInner)]),
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
        case r'accessToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accessToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreatedBookingDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreatedBookingDtoOutputBuilder();
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

class CreatedBookingDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'PENDING_PAYMENT')
  static const CreatedBookingDtoOutputStatusEnum PENDING_PAYMENT =
      _$createdBookingDtoOutputStatusEnum_PENDING_PAYMENT;
  @BuiltValueEnumConst(wireName: r'PENDING_CONFIRMATION')
  static const CreatedBookingDtoOutputStatusEnum PENDING_CONFIRMATION =
      _$createdBookingDtoOutputStatusEnum_PENDING_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const CreatedBookingDtoOutputStatusEnum PAID =
      _$createdBookingDtoOutputStatusEnum_PAID;
  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const CreatedBookingDtoOutputStatusEnum CONFIRMED =
      _$createdBookingDtoOutputStatusEnum_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'PARTIALLY_CANCELLED')
  static const CreatedBookingDtoOutputStatusEnum PARTIALLY_CANCELLED =
      _$createdBookingDtoOutputStatusEnum_PARTIALLY_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CreatedBookingDtoOutputStatusEnum CANCELLED =
      _$createdBookingDtoOutputStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const CreatedBookingDtoOutputStatusEnum EXPIRED =
      _$createdBookingDtoOutputStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'REFUND_PENDING')
  static const CreatedBookingDtoOutputStatusEnum REFUND_PENDING =
      _$createdBookingDtoOutputStatusEnum_REFUND_PENDING;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const CreatedBookingDtoOutputStatusEnum REFUNDED =
      _$createdBookingDtoOutputStatusEnum_REFUNDED;
  @BuiltValueEnumConst(wireName: r'REFUND_FAILED')
  static const CreatedBookingDtoOutputStatusEnum REFUND_FAILED =
      _$createdBookingDtoOutputStatusEnum_REFUND_FAILED;

  static Serializer<CreatedBookingDtoOutputStatusEnum> get serializer =>
      _$createdBookingDtoOutputStatusEnumSerializer;

  const CreatedBookingDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<CreatedBookingDtoOutputStatusEnum> get values =>
      _$createdBookingDtoOutputStatusEnumValues;
  static CreatedBookingDtoOutputStatusEnum valueOf(String name) =>
      _$createdBookingDtoOutputStatusEnumValueOf(name);
}

class CreatedBookingDtoOutputDiscountFundingEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const CreatedBookingDtoOutputDiscountFundingEnum OPERATOR =
      _$createdBookingDtoOutputDiscountFundingEnum_OPERATOR;
  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const CreatedBookingDtoOutputDiscountFundingEnum PLATFORM =
      _$createdBookingDtoOutputDiscountFundingEnum_PLATFORM;

  static Serializer<CreatedBookingDtoOutputDiscountFundingEnum>
      get serializer => _$createdBookingDtoOutputDiscountFundingEnumSerializer;

  const CreatedBookingDtoOutputDiscountFundingEnum._(String name) : super(name);

  static BuiltSet<CreatedBookingDtoOutputDiscountFundingEnum> get values =>
      _$createdBookingDtoOutputDiscountFundingEnumValues;
  static CreatedBookingDtoOutputDiscountFundingEnum valueOf(String name) =>
      _$createdBookingDtoOutputDiscountFundingEnumValueOf(name);
}
