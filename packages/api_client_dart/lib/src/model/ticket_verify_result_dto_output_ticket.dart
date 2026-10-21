//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/trip_manifest_dto_output_passengers_inner_pickup.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_verify_result_dto_output_ticket.g.dart';

/// TicketVerifyResultDtoOutputTicket
///
/// Properties:
/// * [ticketId]
/// * [ticketCode]
/// * [seatCode]
/// * [passengerName]
/// * [phoneMasked]
/// * [pickup]
/// * [dropoff]
/// * [status]
/// * [checkedInAt]
@BuiltValue()
abstract class TicketVerifyResultDtoOutputTicket
    implements
        Built<TicketVerifyResultDtoOutputTicket,
            TicketVerifyResultDtoOutputTicketBuilder> {
  @BuiltValueField(wireName: r'ticketId')
  String get ticketId;

  @BuiltValueField(wireName: r'ticketCode')
  String get ticketCode;

  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'passengerName')
  String get passengerName;

  @BuiltValueField(wireName: r'phoneMasked')
  String get phoneMasked;

  @BuiltValueField(wireName: r'pickup')
  TripManifestDtoOutputPassengersInnerPickup get pickup;

  @BuiltValueField(wireName: r'dropoff')
  TripManifestDtoOutputPassengersInnerPickup get dropoff;

  @BuiltValueField(wireName: r'status')
  TicketVerifyResultDtoOutputTicketStatusEnum get status;
  // enum statusEnum {  VALID,  CANCELLED,  CHECKED_IN,  NO_SHOW,  USED,  REFUNDED,  };

  @BuiltValueField(wireName: r'checkedInAt')
  DateTime? get checkedInAt;

  TicketVerifyResultDtoOutputTicket._();

  factory TicketVerifyResultDtoOutputTicket(
          [void updates(TicketVerifyResultDtoOutputTicketBuilder b)]) =
      _$TicketVerifyResultDtoOutputTicket;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketVerifyResultDtoOutputTicketBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketVerifyResultDtoOutputTicket> get serializer =>
      _$TicketVerifyResultDtoOutputTicketSerializer();
}

class _$TicketVerifyResultDtoOutputTicketSerializer
    implements PrimitiveSerializer<TicketVerifyResultDtoOutputTicket> {
  @override
  final Iterable<Type> types = const [
    TicketVerifyResultDtoOutputTicket,
    _$TicketVerifyResultDtoOutputTicket
  ];

  @override
  final String wireName = r'TicketVerifyResultDtoOutputTicket';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketVerifyResultDtoOutputTicket object, {
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
    yield r'phoneMasked';
    yield serializers.serialize(
      object.phoneMasked,
      specifiedType: const FullType(String),
    );
    yield r'pickup';
    yield serializers.serialize(
      object.pickup,
      specifiedType: const FullType(TripManifestDtoOutputPassengersInnerPickup),
    );
    yield r'dropoff';
    yield serializers.serialize(
      object.dropoff,
      specifiedType: const FullType(TripManifestDtoOutputPassengersInnerPickup),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType:
          const FullType(TicketVerifyResultDtoOutputTicketStatusEnum),
    );
    yield r'checkedInAt';
    yield object.checkedInAt == null
        ? null
        : serializers.serialize(
            object.checkedInAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketVerifyResultDtoOutputTicket object, {
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
    required TicketVerifyResultDtoOutputTicketBuilder result,
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
        case r'phoneMasked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phoneMasked = valueDes;
          break;
        case r'pickup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(TripManifestDtoOutputPassengersInnerPickup),
          ) as TripManifestDtoOutputPassengersInnerPickup;
          result.pickup.replace(valueDes);
          break;
        case r'dropoff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(TripManifestDtoOutputPassengersInnerPickup),
          ) as TripManifestDtoOutputPassengersInnerPickup;
          result.dropoff.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(TicketVerifyResultDtoOutputTicketStatusEnum),
          ) as TicketVerifyResultDtoOutputTicketStatusEnum;
          result.status = valueDes;
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
  TicketVerifyResultDtoOutputTicket deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketVerifyResultDtoOutputTicketBuilder();
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

class TicketVerifyResultDtoOutputTicketStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'VALID')
  static const TicketVerifyResultDtoOutputTicketStatusEnum VALID =
      _$ticketVerifyResultDtoOutputTicketStatusEnum_VALID;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const TicketVerifyResultDtoOutputTicketStatusEnum CANCELLED =
      _$ticketVerifyResultDtoOutputTicketStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CHECKED_IN')
  static const TicketVerifyResultDtoOutputTicketStatusEnum CHECKED_IN =
      _$ticketVerifyResultDtoOutputTicketStatusEnum_CHECKED_IN;
  @BuiltValueEnumConst(wireName: r'NO_SHOW')
  static const TicketVerifyResultDtoOutputTicketStatusEnum NO_SHOW =
      _$ticketVerifyResultDtoOutputTicketStatusEnum_NO_SHOW;
  @BuiltValueEnumConst(wireName: r'USED')
  static const TicketVerifyResultDtoOutputTicketStatusEnum USED =
      _$ticketVerifyResultDtoOutputTicketStatusEnum_USED;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const TicketVerifyResultDtoOutputTicketStatusEnum REFUNDED =
      _$ticketVerifyResultDtoOutputTicketStatusEnum_REFUNDED;

  static Serializer<TicketVerifyResultDtoOutputTicketStatusEnum>
      get serializer => _$ticketVerifyResultDtoOutputTicketStatusEnumSerializer;

  const TicketVerifyResultDtoOutputTicketStatusEnum._(String name)
      : super(name);

  static BuiltSet<TicketVerifyResultDtoOutputTicketStatusEnum> get values =>
      _$ticketVerifyResultDtoOutputTicketStatusEnumValues;
  static TicketVerifyResultDtoOutputTicketStatusEnum valueOf(String name) =>
      _$ticketVerifyResultDtoOutputTicketStatusEnumValueOf(name);
}
