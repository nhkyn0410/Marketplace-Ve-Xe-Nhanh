//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'created_booking_dto_output_tickets_inner.g.dart';

/// CreatedBookingDtoOutputTicketsInner
///
/// Properties:
/// * [ticketId] 
/// * [ticketCode] 
/// * [seatCode] 
/// * [passengerName] 
/// * [status] 
/// * [qrToken] 
@BuiltValue()
abstract class CreatedBookingDtoOutputTicketsInner implements Built<CreatedBookingDtoOutputTicketsInner, CreatedBookingDtoOutputTicketsInnerBuilder> {
  @BuiltValueField(wireName: r'ticketId')
  String get ticketId;

  @BuiltValueField(wireName: r'ticketCode')
  String get ticketCode;

  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'passengerName')
  String get passengerName;

  @BuiltValueField(wireName: r'status')
  CreatedBookingDtoOutputTicketsInnerStatusEnum get status;
  // enum statusEnum {  VALID,  CANCELLED,  CHECKED_IN,  NO_SHOW,  USED,  REFUNDED,  };

  @BuiltValueField(wireName: r'qrToken')
  String get qrToken;

  CreatedBookingDtoOutputTicketsInner._();

  factory CreatedBookingDtoOutputTicketsInner([void updates(CreatedBookingDtoOutputTicketsInnerBuilder b)]) = _$CreatedBookingDtoOutputTicketsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreatedBookingDtoOutputTicketsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreatedBookingDtoOutputTicketsInner> get serializer => _$CreatedBookingDtoOutputTicketsInnerSerializer();
}

class _$CreatedBookingDtoOutputTicketsInnerSerializer implements PrimitiveSerializer<CreatedBookingDtoOutputTicketsInner> {
  @override
  final Iterable<Type> types = const [CreatedBookingDtoOutputTicketsInner, _$CreatedBookingDtoOutputTicketsInner];

  @override
  final String wireName = r'CreatedBookingDtoOutputTicketsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreatedBookingDtoOutputTicketsInner object, {
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CreatedBookingDtoOutputTicketsInnerStatusEnum),
    );
    yield r'qrToken';
    yield serializers.serialize(
      object.qrToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreatedBookingDtoOutputTicketsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreatedBookingDtoOutputTicketsInnerBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreatedBookingDtoOutputTicketsInnerStatusEnum),
          ) as CreatedBookingDtoOutputTicketsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'qrToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.qrToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreatedBookingDtoOutputTicketsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreatedBookingDtoOutputTicketsInnerBuilder();
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


class CreatedBookingDtoOutputTicketsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALID')
  static const CreatedBookingDtoOutputTicketsInnerStatusEnum VALID = _$createdBookingDtoOutputTicketsInnerStatusEnum_VALID;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CreatedBookingDtoOutputTicketsInnerStatusEnum CANCELLED = _$createdBookingDtoOutputTicketsInnerStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CHECKED_IN')
  static const CreatedBookingDtoOutputTicketsInnerStatusEnum CHECKED_IN = _$createdBookingDtoOutputTicketsInnerStatusEnum_CHECKED_IN;
  @BuiltValueEnumConst(wireName: r'NO_SHOW')
  static const CreatedBookingDtoOutputTicketsInnerStatusEnum NO_SHOW = _$createdBookingDtoOutputTicketsInnerStatusEnum_NO_SHOW;
  @BuiltValueEnumConst(wireName: r'USED')
  static const CreatedBookingDtoOutputTicketsInnerStatusEnum USED = _$createdBookingDtoOutputTicketsInnerStatusEnum_USED;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const CreatedBookingDtoOutputTicketsInnerStatusEnum REFUNDED = _$createdBookingDtoOutputTicketsInnerStatusEnum_REFUNDED;

  static Serializer<CreatedBookingDtoOutputTicketsInnerStatusEnum> get serializer => _$createdBookingDtoOutputTicketsInnerStatusEnumSerializer;

  const CreatedBookingDtoOutputTicketsInnerStatusEnum._(String name): super(name);

  static BuiltSet<CreatedBookingDtoOutputTicketsInnerStatusEnum> get values => _$createdBookingDtoOutputTicketsInnerStatusEnumValues;
  static CreatedBookingDtoOutputTicketsInnerStatusEnum valueOf(String name) => _$createdBookingDtoOutputTicketsInnerStatusEnumValueOf(name);
}

