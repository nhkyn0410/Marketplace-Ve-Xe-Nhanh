//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/created_booking_dto_output_trip.dart';
import 'package:api_client_dart/src/model/trip_search_response_dto_output_items_inner_pickup.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_response_dto_output.g.dart';

/// TicketResponseDtoOutput
///
/// Properties:
/// * [ticketId] 
/// * [ticketCode] 
/// * [status] 
/// * [seatCode] 
/// * [seatType] 
/// * [passengerName] 
/// * [bookingId] 
/// * [bookingCode] 
/// * [bookingStatus] 
/// * [trip] 
/// * [pickup] 
/// * [dropoff] 
/// * [qrToken] 
/// * [issuedAt] 
/// * [checkedInAt] 
@BuiltValue()
abstract class TicketResponseDtoOutput implements Built<TicketResponseDtoOutput, TicketResponseDtoOutputBuilder> {
  @BuiltValueField(wireName: r'ticketId')
  String get ticketId;

  @BuiltValueField(wireName: r'ticketCode')
  String get ticketCode;

  @BuiltValueField(wireName: r'status')
  TicketResponseDtoOutputStatusEnum get status;
  // enum statusEnum {  VALID,  CANCELLED,  CHECKED_IN,  NO_SHOW,  USED,  REFUNDED,  };

  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'seatType')
  TicketResponseDtoOutputSeatTypeEnum get seatType;
  // enum seatTypeEnum {  SEAT,  BED,  BED_DOUBLE,  CABIN,  CABIN_DOUBLE,  };

  @BuiltValueField(wireName: r'passengerName')
  String get passengerName;

  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'bookingStatus')
  TicketResponseDtoOutputBookingStatusEnum get bookingStatus;
  // enum bookingStatusEnum {  PENDING_PAYMENT,  PENDING_CONFIRMATION,  PAID,  CONFIRMED,  PARTIALLY_CANCELLED,  CANCELLED,  EXPIRED,  REFUND_PENDING,  REFUNDED,  REFUND_FAILED,  };

  @BuiltValueField(wireName: r'trip')
  CreatedBookingDtoOutputTrip get trip;

  @BuiltValueField(wireName: r'pickup')
  TripSearchResponseDtoOutputItemsInnerPickup get pickup;

  @BuiltValueField(wireName: r'dropoff')
  TripSearchResponseDtoOutputItemsInnerPickup get dropoff;

  @BuiltValueField(wireName: r'qrToken')
  String get qrToken;

  @BuiltValueField(wireName: r'issuedAt')
  DateTime get issuedAt;

  @BuiltValueField(wireName: r'checkedInAt')
  DateTime? get checkedInAt;

  TicketResponseDtoOutput._();

  factory TicketResponseDtoOutput([void updates(TicketResponseDtoOutputBuilder b)]) = _$TicketResponseDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketResponseDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketResponseDtoOutput> get serializer => _$TicketResponseDtoOutputSerializer();
}

class _$TicketResponseDtoOutputSerializer implements PrimitiveSerializer<TicketResponseDtoOutput> {
  @override
  final Iterable<Type> types = const [TicketResponseDtoOutput, _$TicketResponseDtoOutput];

  @override
  final String wireName = r'TicketResponseDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ticketId';
    yield serializers.serialize(
      object.ticketId,
      specifiedType: const FullType(String),
    );
    yield r'ticketCode';
    yield serializers.serialize(
      object.ticketCode,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(TicketResponseDtoOutputStatusEnum),
    );
    yield r'seatCode';
    yield serializers.serialize(
      object.seatCode,
      specifiedType: const FullType(String),
    );
    yield r'seatType';
    yield serializers.serialize(
      object.seatType,
      specifiedType: const FullType(TicketResponseDtoOutputSeatTypeEnum),
    );
    yield r'passengerName';
    yield serializers.serialize(
      object.passengerName,
      specifiedType: const FullType(String),
    );
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
    yield r'bookingStatus';
    yield serializers.serialize(
      object.bookingStatus,
      specifiedType: const FullType(TicketResponseDtoOutputBookingStatusEnum),
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
    yield r'qrToken';
    yield serializers.serialize(
      object.qrToken,
      specifiedType: const FullType(String),
    );
    yield r'issuedAt';
    yield serializers.serialize(
      object.issuedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'checkedInAt';
    yield object.checkedInAt == null ? null : serializers.serialize(
      object.checkedInAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketResponseDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketResponseDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ticketId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticketId = valueDes;
          break;
        case r'ticketCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticketCode = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketResponseDtoOutputStatusEnum),
          ) as TicketResponseDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'seatCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.seatCode = valueDes;
          break;
        case r'seatType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketResponseDtoOutputSeatTypeEnum),
          ) as TicketResponseDtoOutputSeatTypeEnum;
          result.seatType = valueDes;
          break;
        case r'passengerName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.passengerName = valueDes;
          break;
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
        case r'bookingStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketResponseDtoOutputBookingStatusEnum),
          ) as TicketResponseDtoOutputBookingStatusEnum;
          result.bookingStatus = valueDes;
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
        case r'qrToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.qrToken = valueDes;
          break;
        case r'issuedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.issuedAt = valueDes;
          break;
        case r'checkedInAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.checkedInAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TicketResponseDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketResponseDtoOutputBuilder();
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


class TicketResponseDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALID')
  static const TicketResponseDtoOutputStatusEnum VALID = _$ticketResponseDtoOutputStatusEnum_VALID;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const TicketResponseDtoOutputStatusEnum CANCELLED = _$ticketResponseDtoOutputStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CHECKED_IN')
  static const TicketResponseDtoOutputStatusEnum CHECKED_IN = _$ticketResponseDtoOutputStatusEnum_CHECKED_IN;
  @BuiltValueEnumConst(wireName: r'NO_SHOW')
  static const TicketResponseDtoOutputStatusEnum NO_SHOW = _$ticketResponseDtoOutputStatusEnum_NO_SHOW;
  @BuiltValueEnumConst(wireName: r'USED')
  static const TicketResponseDtoOutputStatusEnum USED = _$ticketResponseDtoOutputStatusEnum_USED;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const TicketResponseDtoOutputStatusEnum REFUNDED = _$ticketResponseDtoOutputStatusEnum_REFUNDED;

  static Serializer<TicketResponseDtoOutputStatusEnum> get serializer => _$ticketResponseDtoOutputStatusEnumSerializer;

  const TicketResponseDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<TicketResponseDtoOutputStatusEnum> get values => _$ticketResponseDtoOutputStatusEnumValues;
  static TicketResponseDtoOutputStatusEnum valueOf(String name) => _$ticketResponseDtoOutputStatusEnumValueOf(name);
}

class TicketResponseDtoOutputSeatTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SEAT')
  static const TicketResponseDtoOutputSeatTypeEnum SEAT = _$ticketResponseDtoOutputSeatTypeEnum_SEAT;
  @BuiltValueEnumConst(wireName: r'BED')
  static const TicketResponseDtoOutputSeatTypeEnum BED = _$ticketResponseDtoOutputSeatTypeEnum_BED;
  @BuiltValueEnumConst(wireName: r'BED_DOUBLE')
  static const TicketResponseDtoOutputSeatTypeEnum BED_DOUBLE = _$ticketResponseDtoOutputSeatTypeEnum_BED_DOUBLE;
  @BuiltValueEnumConst(wireName: r'CABIN')
  static const TicketResponseDtoOutputSeatTypeEnum CABIN = _$ticketResponseDtoOutputSeatTypeEnum_CABIN;
  @BuiltValueEnumConst(wireName: r'CABIN_DOUBLE')
  static const TicketResponseDtoOutputSeatTypeEnum CABIN_DOUBLE = _$ticketResponseDtoOutputSeatTypeEnum_CABIN_DOUBLE;

  static Serializer<TicketResponseDtoOutputSeatTypeEnum> get serializer => _$ticketResponseDtoOutputSeatTypeEnumSerializer;

  const TicketResponseDtoOutputSeatTypeEnum._(String name): super(name);

  static BuiltSet<TicketResponseDtoOutputSeatTypeEnum> get values => _$ticketResponseDtoOutputSeatTypeEnumValues;
  static TicketResponseDtoOutputSeatTypeEnum valueOf(String name) => _$ticketResponseDtoOutputSeatTypeEnumValueOf(name);
}

class TicketResponseDtoOutputBookingStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_PAYMENT')
  static const TicketResponseDtoOutputBookingStatusEnum PENDING_PAYMENT = _$ticketResponseDtoOutputBookingStatusEnum_PENDING_PAYMENT;
  @BuiltValueEnumConst(wireName: r'PENDING_CONFIRMATION')
  static const TicketResponseDtoOutputBookingStatusEnum PENDING_CONFIRMATION = _$ticketResponseDtoOutputBookingStatusEnum_PENDING_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const TicketResponseDtoOutputBookingStatusEnum PAID = _$ticketResponseDtoOutputBookingStatusEnum_PAID;
  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const TicketResponseDtoOutputBookingStatusEnum CONFIRMED = _$ticketResponseDtoOutputBookingStatusEnum_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'PARTIALLY_CANCELLED')
  static const TicketResponseDtoOutputBookingStatusEnum PARTIALLY_CANCELLED = _$ticketResponseDtoOutputBookingStatusEnum_PARTIALLY_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const TicketResponseDtoOutputBookingStatusEnum CANCELLED = _$ticketResponseDtoOutputBookingStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const TicketResponseDtoOutputBookingStatusEnum EXPIRED = _$ticketResponseDtoOutputBookingStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'REFUND_PENDING')
  static const TicketResponseDtoOutputBookingStatusEnum REFUND_PENDING = _$ticketResponseDtoOutputBookingStatusEnum_REFUND_PENDING;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const TicketResponseDtoOutputBookingStatusEnum REFUNDED = _$ticketResponseDtoOutputBookingStatusEnum_REFUNDED;
  @BuiltValueEnumConst(wireName: r'REFUND_FAILED')
  static const TicketResponseDtoOutputBookingStatusEnum REFUND_FAILED = _$ticketResponseDtoOutputBookingStatusEnum_REFUND_FAILED;

  static Serializer<TicketResponseDtoOutputBookingStatusEnum> get serializer => _$ticketResponseDtoOutputBookingStatusEnumSerializer;

  const TicketResponseDtoOutputBookingStatusEnum._(String name): super(name);

  static BuiltSet<TicketResponseDtoOutputBookingStatusEnum> get values => _$ticketResponseDtoOutputBookingStatusEnumValues;
  static TicketResponseDtoOutputBookingStatusEnum valueOf(String name) => _$ticketResponseDtoOutputBookingStatusEnumValueOf(name);
}

