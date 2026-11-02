//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operator_booking_detail_dto_output_seats_inner.g.dart';

/// OperatorBookingDetailDtoOutputSeatsInner
///
/// Properties:
/// * [seatCode] 
/// * [seatType] 
/// * [passengerName] 
/// * [companionName] 
/// * [phoneMasked] 
/// * [ticketCode] 
/// * [ticketStatus] 
@BuiltValue()
abstract class OperatorBookingDetailDtoOutputSeatsInner implements Built<OperatorBookingDetailDtoOutputSeatsInner, OperatorBookingDetailDtoOutputSeatsInnerBuilder> {
  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'seatType')
  OperatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum get seatType;
  // enum seatTypeEnum {  SEAT,  BED,  BED_DOUBLE,  CABIN,  CABIN_DOUBLE,  };

  @BuiltValueField(wireName: r'passengerName')
  String get passengerName;

  @BuiltValueField(wireName: r'companionName')
  String? get companionName;

  @BuiltValueField(wireName: r'phoneMasked')
  String? get phoneMasked;

  @BuiltValueField(wireName: r'ticketCode')
  String? get ticketCode;

  @BuiltValueField(wireName: r'ticketStatus')
  OperatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum? get ticketStatus;
  // enum ticketStatusEnum {  VALID,  CANCELLED,  CHECKED_IN,  NO_SHOW,  USED,  REFUNDED,  };

  OperatorBookingDetailDtoOutputSeatsInner._();

  factory OperatorBookingDetailDtoOutputSeatsInner([void updates(OperatorBookingDetailDtoOutputSeatsInnerBuilder b)]) = _$OperatorBookingDetailDtoOutputSeatsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperatorBookingDetailDtoOutputSeatsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperatorBookingDetailDtoOutputSeatsInner> get serializer => _$OperatorBookingDetailDtoOutputSeatsInnerSerializer();
}

class _$OperatorBookingDetailDtoOutputSeatsInnerSerializer implements PrimitiveSerializer<OperatorBookingDetailDtoOutputSeatsInner> {
  @override
  final Iterable<Type> types = const [OperatorBookingDetailDtoOutputSeatsInner, _$OperatorBookingDetailDtoOutputSeatsInner];

  @override
  final String wireName = r'OperatorBookingDetailDtoOutputSeatsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperatorBookingDetailDtoOutputSeatsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'seatCode';
    yield serializers.serialize(
      object.seatCode,
      specifiedType: const FullType(String),
    );
    yield r'seatType';
    yield serializers.serialize(
      object.seatType,
      specifiedType: const FullType(OperatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum),
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
    yield r'ticketCode';
    yield object.ticketCode == null ? null : serializers.serialize(
      object.ticketCode,
      specifiedType: const FullType.nullable(String),
    );
    yield r'ticketStatus';
    yield object.ticketStatus == null ? null : serializers.serialize(
      object.ticketStatus,
      specifiedType: const FullType.nullable(OperatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperatorBookingDetailDtoOutputSeatsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperatorBookingDetailDtoOutputSeatsInnerBuilder result,
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
        case r'seatType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum),
          ) as OperatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum;
          result.seatType = valueDes;
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
        case r'ticketCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ticketCode = valueDes;
          break;
        case r'ticketStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OperatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum),
          ) as OperatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum?;
          if (valueDes == null) continue;
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
  OperatorBookingDetailDtoOutputSeatsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperatorBookingDetailDtoOutputSeatsInnerBuilder();
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


class OperatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SEAT')
  static const OperatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum SEAT = _$operatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum_SEAT;
  @BuiltValueEnumConst(wireName: r'BED')
  static const OperatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum BED = _$operatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum_BED;
  @BuiltValueEnumConst(wireName: r'BED_DOUBLE')
  static const OperatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum BED_DOUBLE = _$operatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum_BED_DOUBLE;
  @BuiltValueEnumConst(wireName: r'CABIN')
  static const OperatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum CABIN = _$operatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum_CABIN;
  @BuiltValueEnumConst(wireName: r'CABIN_DOUBLE')
  static const OperatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum CABIN_DOUBLE = _$operatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum_CABIN_DOUBLE;

  static Serializer<OperatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum> get serializer => _$operatorBookingDetailDtoOutputSeatsInnerSeatTypeEnumSerializer;

  const OperatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum._(String name): super(name);

  static BuiltSet<OperatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum> get values => _$operatorBookingDetailDtoOutputSeatsInnerSeatTypeEnumValues;
  static OperatorBookingDetailDtoOutputSeatsInnerSeatTypeEnum valueOf(String name) => _$operatorBookingDetailDtoOutputSeatsInnerSeatTypeEnumValueOf(name);
}

class OperatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALID')
  static const OperatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum VALID = _$operatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum_VALID;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const OperatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum CANCELLED = _$operatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CHECKED_IN')
  static const OperatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum CHECKED_IN = _$operatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum_CHECKED_IN;
  @BuiltValueEnumConst(wireName: r'NO_SHOW')
  static const OperatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum NO_SHOW = _$operatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum_NO_SHOW;
  @BuiltValueEnumConst(wireName: r'USED')
  static const OperatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum USED = _$operatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum_USED;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const OperatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum REFUNDED = _$operatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum_REFUNDED;

  static Serializer<OperatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum> get serializer => _$operatorBookingDetailDtoOutputSeatsInnerTicketStatusEnumSerializer;

  const OperatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum._(String name): super(name);

  static BuiltSet<OperatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum> get values => _$operatorBookingDetailDtoOutputSeatsInnerTicketStatusEnumValues;
  static OperatorBookingDetailDtoOutputSeatsInnerTicketStatusEnum valueOf(String name) => _$operatorBookingDetailDtoOutputSeatsInnerTicketStatusEnumValueOf(name);
}

