//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/trip_sales_dto_output_changes_inner_before_stops_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trip_passenger_list_dto_output_items_inner.g.dart';

/// TripPassengerListDtoOutputItemsInner
///
/// Properties:
/// * [seatCode] 
/// * [passengerName] 
/// * [companionName] 
/// * [phoneMasked] 
/// * [bookingId] 
/// * [bookingCode] 
/// * [guest] 
/// * [pickup] 
/// * [dropoff] 
/// * [ticketCode] 
/// * [ticketStatus] 
@BuiltValue()
abstract class TripPassengerListDtoOutputItemsInner implements Built<TripPassengerListDtoOutputItemsInner, TripPassengerListDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'passengerName')
  String get passengerName;

  @BuiltValueField(wireName: r'companionName')
  String? get companionName;

  @BuiltValueField(wireName: r'phoneMasked')
  String? get phoneMasked;

  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'guest')
  bool get guest;

  @BuiltValueField(wireName: r'pickup')
  TripSalesDtoOutputChangesInnerBeforeStopsInner get pickup;

  @BuiltValueField(wireName: r'dropoff')
  TripSalesDtoOutputChangesInnerBeforeStopsInner get dropoff;

  @BuiltValueField(wireName: r'ticketCode')
  String get ticketCode;

  @BuiltValueField(wireName: r'ticketStatus')
  TripPassengerListDtoOutputItemsInnerTicketStatusEnum get ticketStatus;
  // enum ticketStatusEnum {  VALID,  CANCELLED,  CHECKED_IN,  NO_SHOW,  USED,  REFUNDED,  };

  TripPassengerListDtoOutputItemsInner._();

  factory TripPassengerListDtoOutputItemsInner([void updates(TripPassengerListDtoOutputItemsInnerBuilder b)]) = _$TripPassengerListDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TripPassengerListDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TripPassengerListDtoOutputItemsInner> get serializer => _$TripPassengerListDtoOutputItemsInnerSerializer();
}

class _$TripPassengerListDtoOutputItemsInnerSerializer implements PrimitiveSerializer<TripPassengerListDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [TripPassengerListDtoOutputItemsInner, _$TripPassengerListDtoOutputItemsInner];

  @override
  final String wireName = r'TripPassengerListDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TripPassengerListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'seatCode';
    yield serializers.serialize(
      object.seatCode,
      specifiedType: const FullType(String),
    );
    yield r'passengerName';
    yield serializers.serialize(
      object.passengerName,
      specifiedType: const FullType(String),
    );
    yield r'companionName';
    yield object.companionName == null ? null : serializers.serialize(
      object.companionName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'phoneMasked';
    yield object.phoneMasked == null ? null : serializers.serialize(
      object.phoneMasked,
      specifiedType: const FullType.nullable(String),
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
    yield r'guest';
    yield serializers.serialize(
      object.guest,
      specifiedType: const FullType(bool),
    );
    yield r'pickup';
    yield serializers.serialize(
      object.pickup,
      specifiedType: const FullType(TripSalesDtoOutputChangesInnerBeforeStopsInner),
    );
    yield r'dropoff';
    yield serializers.serialize(
      object.dropoff,
      specifiedType: const FullType(TripSalesDtoOutputChangesInnerBeforeStopsInner),
    );
    yield r'ticketCode';
    yield serializers.serialize(
      object.ticketCode,
      specifiedType: const FullType(String),
    );
    yield r'ticketStatus';
    yield serializers.serialize(
      object.ticketStatus,
      specifiedType: const FullType(TripPassengerListDtoOutputItemsInnerTicketStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TripPassengerListDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TripPassengerListDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'seatCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.seatCode = valueDes;
          break;
        case r'passengerName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.passengerName = valueDes;
          break;
        case r'companionName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.companionName = valueDes;
          break;
        case r'phoneMasked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phoneMasked = valueDes;
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
        case r'guest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.guest = valueDes;
          break;
        case r'pickup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSalesDtoOutputChangesInnerBeforeStopsInner),
          ) as TripSalesDtoOutputChangesInnerBeforeStopsInner;
          result.pickup.replace(valueDes);
          break;
        case r'dropoff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripSalesDtoOutputChangesInnerBeforeStopsInner),
          ) as TripSalesDtoOutputChangesInnerBeforeStopsInner;
          result.dropoff.replace(valueDes);
          break;
        case r'ticketCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticketCode = valueDes;
          break;
        case r'ticketStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TripPassengerListDtoOutputItemsInnerTicketStatusEnum),
          ) as TripPassengerListDtoOutputItemsInnerTicketStatusEnum;
          result.ticketStatus = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TripPassengerListDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TripPassengerListDtoOutputItemsInnerBuilder();
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


class TripPassengerListDtoOutputItemsInnerTicketStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALID')
  static const TripPassengerListDtoOutputItemsInnerTicketStatusEnum VALID = _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_VALID;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const TripPassengerListDtoOutputItemsInnerTicketStatusEnum CANCELLED = _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CHECKED_IN')
  static const TripPassengerListDtoOutputItemsInnerTicketStatusEnum CHECKED_IN = _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_CHECKED_IN;
  @BuiltValueEnumConst(wireName: r'NO_SHOW')
  static const TripPassengerListDtoOutputItemsInnerTicketStatusEnum NO_SHOW = _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_NO_SHOW;
  @BuiltValueEnumConst(wireName: r'USED')
  static const TripPassengerListDtoOutputItemsInnerTicketStatusEnum USED = _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_USED;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const TripPassengerListDtoOutputItemsInnerTicketStatusEnum REFUNDED = _$tripPassengerListDtoOutputItemsInnerTicketStatusEnum_REFUNDED;

  static Serializer<TripPassengerListDtoOutputItemsInnerTicketStatusEnum> get serializer => _$tripPassengerListDtoOutputItemsInnerTicketStatusEnumSerializer;

  const TripPassengerListDtoOutputItemsInnerTicketStatusEnum._(String name): super(name);

  static BuiltSet<TripPassengerListDtoOutputItemsInnerTicketStatusEnum> get values => _$tripPassengerListDtoOutputItemsInnerTicketStatusEnumValues;
  static TripPassengerListDtoOutputItemsInnerTicketStatusEnum valueOf(String name) => _$tripPassengerListDtoOutputItemsInnerTicketStatusEnumValueOf(name);
}

