//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_payment_detail_dto_output_booking.g.dart';

/// AdminPaymentDetailDtoOutputBooking
///
/// Properties:
/// * [status] 
/// * [routeName] 
/// * [departureAt] 
/// * [contactName] 
/// * [seatCodes] 
/// * [subtotal] 
/// * [serviceFee] 
/// * [discount] 
/// * [total] 
/// * [createdAt] 
@BuiltValue()
abstract class AdminPaymentDetailDtoOutputBooking implements Built<AdminPaymentDetailDtoOutputBooking, AdminPaymentDetailDtoOutputBookingBuilder> {
  @BuiltValueField(wireName: r'status')
  AdminPaymentDetailDtoOutputBookingStatusEnum get status;
  // enum statusEnum {  PENDING_PAYMENT,  PENDING_CONFIRMATION,  PAID,  CONFIRMED,  PARTIALLY_CANCELLED,  CANCELLED,  EXPIRED,  REFUND_PENDING,  REFUNDED,  REFUND_FAILED,  };

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'contactName')
  String get contactName;

  @BuiltValueField(wireName: r'seatCodes')
  BuiltList<String> get seatCodes;

  @BuiltValueField(wireName: r'subtotal')
  int get subtotal;

  @BuiltValueField(wireName: r'serviceFee')
  int get serviceFee;

  @BuiltValueField(wireName: r'discount')
  int get discount;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  AdminPaymentDetailDtoOutputBooking._();

  factory AdminPaymentDetailDtoOutputBooking([void updates(AdminPaymentDetailDtoOutputBookingBuilder b)]) = _$AdminPaymentDetailDtoOutputBooking;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPaymentDetailDtoOutputBookingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPaymentDetailDtoOutputBooking> get serializer => _$AdminPaymentDetailDtoOutputBookingSerializer();
}

class _$AdminPaymentDetailDtoOutputBookingSerializer implements PrimitiveSerializer<AdminPaymentDetailDtoOutputBooking> {
  @override
  final Iterable<Type> types = const [AdminPaymentDetailDtoOutputBooking, _$AdminPaymentDetailDtoOutputBooking];

  @override
  final String wireName = r'AdminPaymentDetailDtoOutputBooking';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPaymentDetailDtoOutputBooking object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminPaymentDetailDtoOutputBookingStatusEnum),
    );
    yield r'routeName';
    yield serializers.serialize(
      object.routeName,
      specifiedType: const FullType(String),
    );
    yield r'departureAt';
    yield serializers.serialize(
      object.departureAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'contactName';
    yield serializers.serialize(
      object.contactName,
      specifiedType: const FullType(String),
    );
    yield r'seatCodes';
    yield serializers.serialize(
      object.seatCodes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
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
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPaymentDetailDtoOutputBooking object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPaymentDetailDtoOutputBookingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPaymentDetailDtoOutputBookingStatusEnum),
          ) as AdminPaymentDetailDtoOutputBookingStatusEnum;
          result.status = valueDes;
          break;
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeName = valueDes;
          break;
        case r'departureAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.departureAt = valueDes;
          break;
        case r'contactName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contactName = valueDes;
          break;
        case r'seatCodes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.seatCodes.replace(valueDes);
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
  AdminPaymentDetailDtoOutputBooking deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPaymentDetailDtoOutputBookingBuilder();
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


class AdminPaymentDetailDtoOutputBookingStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_PAYMENT')
  static const AdminPaymentDetailDtoOutputBookingStatusEnum PENDING_PAYMENT = _$adminPaymentDetailDtoOutputBookingStatusEnum_PENDING_PAYMENT;
  @BuiltValueEnumConst(wireName: r'PENDING_CONFIRMATION')
  static const AdminPaymentDetailDtoOutputBookingStatusEnum PENDING_CONFIRMATION = _$adminPaymentDetailDtoOutputBookingStatusEnum_PENDING_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const AdminPaymentDetailDtoOutputBookingStatusEnum PAID = _$adminPaymentDetailDtoOutputBookingStatusEnum_PAID;
  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const AdminPaymentDetailDtoOutputBookingStatusEnum CONFIRMED = _$adminPaymentDetailDtoOutputBookingStatusEnum_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'PARTIALLY_CANCELLED')
  static const AdminPaymentDetailDtoOutputBookingStatusEnum PARTIALLY_CANCELLED = _$adminPaymentDetailDtoOutputBookingStatusEnum_PARTIALLY_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const AdminPaymentDetailDtoOutputBookingStatusEnum CANCELLED = _$adminPaymentDetailDtoOutputBookingStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const AdminPaymentDetailDtoOutputBookingStatusEnum EXPIRED = _$adminPaymentDetailDtoOutputBookingStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'REFUND_PENDING')
  static const AdminPaymentDetailDtoOutputBookingStatusEnum REFUND_PENDING = _$adminPaymentDetailDtoOutputBookingStatusEnum_REFUND_PENDING;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const AdminPaymentDetailDtoOutputBookingStatusEnum REFUNDED = _$adminPaymentDetailDtoOutputBookingStatusEnum_REFUNDED;
  @BuiltValueEnumConst(wireName: r'REFUND_FAILED')
  static const AdminPaymentDetailDtoOutputBookingStatusEnum REFUND_FAILED = _$adminPaymentDetailDtoOutputBookingStatusEnum_REFUND_FAILED;

  static Serializer<AdminPaymentDetailDtoOutputBookingStatusEnum> get serializer => _$adminPaymentDetailDtoOutputBookingStatusEnumSerializer;

  const AdminPaymentDetailDtoOutputBookingStatusEnum._(String name): super(name);

  static BuiltSet<AdminPaymentDetailDtoOutputBookingStatusEnum> get values => _$adminPaymentDetailDtoOutputBookingStatusEnumValues;
  static AdminPaymentDetailDtoOutputBookingStatusEnum valueOf(String name) => _$adminPaymentDetailDtoOutputBookingStatusEnumValueOf(name);
}

