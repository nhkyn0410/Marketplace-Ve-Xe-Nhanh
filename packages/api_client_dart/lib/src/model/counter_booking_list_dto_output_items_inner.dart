//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/counter_booking_dto_output_receipts_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/counter_booking_dto_output_trip.dart';
import 'package:api_client_dart/src/model/counter_booking_dto_output_contact.dart';
import 'package:api_client_dart/src/model/counter_booking_dto_output_tickets_inner.dart';
import 'package:api_client_dart/src/model/counter_booking_dto_output_passengers_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_booking_list_dto_output_items_inner.g.dart';

/// CounterBookingListDtoOutputItemsInner
///
/// Properties:
/// * [bookingId] 
/// * [bookingCode] 
/// * [officeId] 
/// * [seller] 
/// * [status] 
/// * [tripId] 
/// * [trip] 
/// * [contact] 
/// * [passengers] 
/// * [total] 
/// * [expiresAt] 
/// * [createdAt] 
/// * [tickets] 
/// * [receipts] 
@BuiltValue()
abstract class CounterBookingListDtoOutputItemsInner implements Built<CounterBookingListDtoOutputItemsInner, CounterBookingListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'officeId')
  String get officeId;

  @BuiltValueField(wireName: r'seller')
  String get seller;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'tripId')
  String get tripId;

  @BuiltValueField(wireName: r'trip')
  CounterBookingDtoOutputTrip get trip;

  @BuiltValueField(wireName: r'contact')
  CounterBookingDtoOutputContact get contact;

  @BuiltValueField(wireName: r'passengers')
  BuiltList<CounterBookingDtoOutputPassengersInner> get passengers;

  @BuiltValueField(wireName: r'total')
  String get total;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'tickets')
  BuiltList<CounterBookingDtoOutputTicketsInner> get tickets;

  @BuiltValueField(wireName: r'receipts')
  BuiltList<CounterBookingDtoOutputReceiptsInner> get receipts;

  CounterBookingListDtoOutputItemsInner._();

  factory CounterBookingListDtoOutputItemsInner([void updates(CounterBookingListDtoOutputItemsInnerBuilder b)]) = _$CounterBookingListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterBookingListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterBookingListDtoOutputItemsInner> get serializer => _$CounterBookingListDtoOutputItemsInnerSerializer();
}

class _$CounterBookingListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<CounterBookingListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [CounterBookingListDtoOutputItemsInner, _$CounterBookingListDtoOutputItemsInner];

  @override
  final String wireName = r'CounterBookingListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterBookingListDtoOutputItemsInner object, {
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
    yield r'officeId';
    yield serializers.serialize(
      object.officeId,
      specifiedType: const FullType(String),
    );
    yield r'seller';
    yield serializers.serialize(
      object.seller,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'tripId';
    yield serializers.serialize(
      object.tripId,
      specifiedType: const FullType(String),
    );
    yield r'trip';
    yield serializers.serialize(
      object.trip,
      specifiedType: const FullType(CounterBookingDtoOutputTrip),
    );
    yield r'contact';
    yield serializers.serialize(
      object.contact,
      specifiedType: const FullType(CounterBookingDtoOutputContact),
    );
    yield r'passengers';
    yield serializers.serialize(
      object.passengers,
      specifiedType: const FullType(BuiltList, [FullType(CounterBookingDtoOutputPassengersInner)]),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'tickets';
    yield serializers.serialize(
      object.tickets,
      specifiedType: const FullType(BuiltList, [FullType(CounterBookingDtoOutputTicketsInner)]),
    );
    yield r'receipts';
    yield serializers.serialize(
      object.receipts,
      specifiedType: const FullType(BuiltList, [FullType(CounterBookingDtoOutputReceiptsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterBookingListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterBookingListDtoOutputItemsInnerBuilder result,
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
        case r'officeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.officeId = valueDes;
          break;
        case r'seller':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.seller = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
            specifiedType: const FullType(CounterBookingDtoOutputTrip),
          ) as CounterBookingDtoOutputTrip;
          result.trip.replace(valueDes);
          break;
        case r'contact':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CounterBookingDtoOutputContact),
          ) as CounterBookingDtoOutputContact;
          result.contact.replace(valueDes);
          break;
        case r'passengers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CounterBookingDtoOutputPassengersInner)]),
          ) as BuiltList<CounterBookingDtoOutputPassengersInner>;
          result.passengers.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.total = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'tickets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CounterBookingDtoOutputTicketsInner)]),
          ) as BuiltList<CounterBookingDtoOutputTicketsInner>;
          result.tickets.replace(valueDes);
          break;
        case r'receipts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CounterBookingDtoOutputReceiptsInner)]),
          ) as BuiltList<CounterBookingDtoOutputReceiptsInner>;
          result.receipts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterBookingListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterBookingListDtoOutputItemsInnerBuilder();
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


