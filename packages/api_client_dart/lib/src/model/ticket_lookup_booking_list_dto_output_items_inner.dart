//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_lookup_booking_list_dto_output_items_inner.g.dart';

/// TicketLookupBookingListDtoOutputItemsInner
///
/// Properties:
/// * [bookingId] 
/// * [bookingCode] 
/// * [status] 
/// * [routeName] 
/// * [operatorName] 
/// * [departureAt] 
/// * [ticketCount] 
/// * [total] 
/// * [bookedWithAccount] 
/// * [createdAt] 
@BuiltValue()
abstract class TicketLookupBookingListDtoOutputItemsInner implements Built<TicketLookupBookingListDtoOutputItemsInner, TicketLookupBookingListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'status')
  TicketLookupBookingListDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  PENDING_PAYMENT,  PENDING_CONFIRMATION,  PAID,  CONFIRMED,  PARTIALLY_CANCELLED,  CANCELLED,  EXPIRED,  REFUND_PENDING,  REFUNDED,  REFUND_FAILED,  };

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'ticketCount')
  int get ticketCount;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'bookedWithAccount')
  bool get bookedWithAccount;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  TicketLookupBookingListDtoOutputItemsInner._();

  factory TicketLookupBookingListDtoOutputItemsInner([void updates(TicketLookupBookingListDtoOutputItemsInnerBuilder b)]) = _$TicketLookupBookingListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketLookupBookingListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketLookupBookingListDtoOutputItemsInner> get serializer => _$TicketLookupBookingListDtoOutputItemsInnerSerializer();
}

class _$TicketLookupBookingListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<TicketLookupBookingListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [TicketLookupBookingListDtoOutputItemsInner, _$TicketLookupBookingListDtoOutputItemsInner];

  @override
  final String wireName = r'TicketLookupBookingListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketLookupBookingListDtoOutputItemsInner object, {
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
      specifiedType: const FullType(TicketLookupBookingListDtoOutputItemsInnerStatusEnum),
    );
    yield r'routeName';
    yield serializers.serialize(
      object.routeName,
      specifiedType: const FullType(String),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
      specifiedType: const FullType(String),
    );
    yield r'departureAt';
    yield serializers.serialize(
      object.departureAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'ticketCount';
    yield serializers.serialize(
      object.ticketCount,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'bookedWithAccount';
    yield serializers.serialize(
      object.bookedWithAccount,
      specifiedType: const FullType(bool),
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
    TicketLookupBookingListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketLookupBookingListDtoOutputItemsInnerBuilder result,
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
            specifiedType: const FullType(TicketLookupBookingListDtoOutputItemsInnerStatusEnum),
          ) as TicketLookupBookingListDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeName = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
          break;
        case r'departureAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.departureAt = valueDes;
          break;
        case r'ticketCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ticketCount = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'bookedWithAccount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.bookedWithAccount = valueDes;
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
  TicketLookupBookingListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketLookupBookingListDtoOutputItemsInnerBuilder();
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


class TicketLookupBookingListDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_PAYMENT')
  static const TicketLookupBookingListDtoOutputItemsInnerStatusEnum PENDING_PAYMENT = _$ticketLookupBookingListDtoOutputItemsInnerStatusEnum_PENDING_PAYMENT;
  @BuiltValueEnumConst(wireName: r'PENDING_CONFIRMATION')
  static const TicketLookupBookingListDtoOutputItemsInnerStatusEnum PENDING_CONFIRMATION = _$ticketLookupBookingListDtoOutputItemsInnerStatusEnum_PENDING_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const TicketLookupBookingListDtoOutputItemsInnerStatusEnum PAID = _$ticketLookupBookingListDtoOutputItemsInnerStatusEnum_PAID;
  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const TicketLookupBookingListDtoOutputItemsInnerStatusEnum CONFIRMED = _$ticketLookupBookingListDtoOutputItemsInnerStatusEnum_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'PARTIALLY_CANCELLED')
  static const TicketLookupBookingListDtoOutputItemsInnerStatusEnum PARTIALLY_CANCELLED = _$ticketLookupBookingListDtoOutputItemsInnerStatusEnum_PARTIALLY_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const TicketLookupBookingListDtoOutputItemsInnerStatusEnum CANCELLED = _$ticketLookupBookingListDtoOutputItemsInnerStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const TicketLookupBookingListDtoOutputItemsInnerStatusEnum EXPIRED = _$ticketLookupBookingListDtoOutputItemsInnerStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'REFUND_PENDING')
  static const TicketLookupBookingListDtoOutputItemsInnerStatusEnum REFUND_PENDING = _$ticketLookupBookingListDtoOutputItemsInnerStatusEnum_REFUND_PENDING;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const TicketLookupBookingListDtoOutputItemsInnerStatusEnum REFUNDED = _$ticketLookupBookingListDtoOutputItemsInnerStatusEnum_REFUNDED;
  @BuiltValueEnumConst(wireName: r'REFUND_FAILED')
  static const TicketLookupBookingListDtoOutputItemsInnerStatusEnum REFUND_FAILED = _$ticketLookupBookingListDtoOutputItemsInnerStatusEnum_REFUND_FAILED;

  static Serializer<TicketLookupBookingListDtoOutputItemsInnerStatusEnum> get serializer => _$ticketLookupBookingListDtoOutputItemsInnerStatusEnumSerializer;

  const TicketLookupBookingListDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<TicketLookupBookingListDtoOutputItemsInnerStatusEnum> get values => _$ticketLookupBookingListDtoOutputItemsInnerStatusEnumValues;
  static TicketLookupBookingListDtoOutputItemsInnerStatusEnum valueOf(String name) => _$ticketLookupBookingListDtoOutputItemsInnerStatusEnumValueOf(name);
}

