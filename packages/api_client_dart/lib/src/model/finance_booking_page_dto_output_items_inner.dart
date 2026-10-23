//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/finance_booking_page_dto_output_items_inner_trip.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'finance_booking_page_dto_output_items_inner.g.dart';

/// FinanceBookingPageDtoOutputItemsInner
///
/// Properties:
/// * [bookingId] 
/// * [bookingCode] 
/// * [trip] 
/// * [grossAmount] 
/// * [commissionAmount] 
/// * [refundAdjustmentAmount] 
/// * [netAmount] 
/// * [state] 
/// * [eligibleAt] 
@BuiltValue()
abstract class FinanceBookingPageDtoOutputItemsInner implements Built<FinanceBookingPageDtoOutputItemsInner, FinanceBookingPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'trip')
  FinanceBookingPageDtoOutputItemsInnerTrip get trip;

  @BuiltValueField(wireName: r'grossAmount')
  int get grossAmount;

  @BuiltValueField(wireName: r'commissionAmount')
  int get commissionAmount;

  @BuiltValueField(wireName: r'refundAdjustmentAmount')
  int get refundAdjustmentAmount;

  @BuiltValueField(wireName: r'netAmount')
  int get netAmount;

  @BuiltValueField(wireName: r'state')
  FinanceBookingPageDtoOutputItemsInnerStateEnum get state;
  // enum stateEnum {  WAITING_TRIP,  ON_HOLD,  ELIGIBLE,  IN_PAYOUT,  PAID,  REFUNDED,  };

  @BuiltValueField(wireName: r'eligibleAt')
  DateTime get eligibleAt;

  FinanceBookingPageDtoOutputItemsInner._();

  factory FinanceBookingPageDtoOutputItemsInner([void updates(FinanceBookingPageDtoOutputItemsInnerBuilder b)]) = _$FinanceBookingPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinanceBookingPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinanceBookingPageDtoOutputItemsInner> get serializer => _$FinanceBookingPageDtoOutputItemsInnerSerializer();
}

class _$FinanceBookingPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<FinanceBookingPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [FinanceBookingPageDtoOutputItemsInner, _$FinanceBookingPageDtoOutputItemsInner];

  @override
  final String wireName = r'FinanceBookingPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinanceBookingPageDtoOutputItemsInner object, {
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
    yield r'trip';
    yield serializers.serialize(
      object.trip,
      specifiedType: const FullType(FinanceBookingPageDtoOutputItemsInnerTrip),
    );
    yield r'grossAmount';
    yield serializers.serialize(
      object.grossAmount,
      specifiedType: const FullType(int),
    );
    yield r'commissionAmount';
    yield serializers.serialize(
      object.commissionAmount,
      specifiedType: const FullType(int),
    );
    yield r'refundAdjustmentAmount';
    yield serializers.serialize(
      object.refundAdjustmentAmount,
      specifiedType: const FullType(int),
    );
    yield r'netAmount';
    yield serializers.serialize(
      object.netAmount,
      specifiedType: const FullType(int),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(FinanceBookingPageDtoOutputItemsInnerStateEnum),
    );
    yield r'eligibleAt';
    yield serializers.serialize(
      object.eligibleAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FinanceBookingPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FinanceBookingPageDtoOutputItemsInnerBuilder result,
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
        case r'trip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FinanceBookingPageDtoOutputItemsInnerTrip),
          ) as FinanceBookingPageDtoOutputItemsInnerTrip;
          result.trip.replace(valueDes);
          break;
        case r'grossAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.grossAmount = valueDes;
          break;
        case r'commissionAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commissionAmount = valueDes;
          break;
        case r'refundAdjustmentAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundAdjustmentAmount = valueDes;
          break;
        case r'netAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.netAmount = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FinanceBookingPageDtoOutputItemsInnerStateEnum),
          ) as FinanceBookingPageDtoOutputItemsInnerStateEnum;
          result.state = valueDes;
          break;
        case r'eligibleAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.eligibleAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FinanceBookingPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinanceBookingPageDtoOutputItemsInnerBuilder();
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


class FinanceBookingPageDtoOutputItemsInnerStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WAITING_TRIP')
  static const FinanceBookingPageDtoOutputItemsInnerStateEnum WAITING_TRIP = _$financeBookingPageDtoOutputItemsInnerStateEnum_WAITING_TRIP;
  @BuiltValueEnumConst(wireName: r'ON_HOLD')
  static const FinanceBookingPageDtoOutputItemsInnerStateEnum ON_HOLD = _$financeBookingPageDtoOutputItemsInnerStateEnum_ON_HOLD;
  @BuiltValueEnumConst(wireName: r'ELIGIBLE')
  static const FinanceBookingPageDtoOutputItemsInnerStateEnum ELIGIBLE = _$financeBookingPageDtoOutputItemsInnerStateEnum_ELIGIBLE;
  @BuiltValueEnumConst(wireName: r'IN_PAYOUT')
  static const FinanceBookingPageDtoOutputItemsInnerStateEnum IN_PAYOUT = _$financeBookingPageDtoOutputItemsInnerStateEnum_IN_PAYOUT;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const FinanceBookingPageDtoOutputItemsInnerStateEnum PAID = _$financeBookingPageDtoOutputItemsInnerStateEnum_PAID;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const FinanceBookingPageDtoOutputItemsInnerStateEnum REFUNDED = _$financeBookingPageDtoOutputItemsInnerStateEnum_REFUNDED;

  static Serializer<FinanceBookingPageDtoOutputItemsInnerStateEnum> get serializer => _$financeBookingPageDtoOutputItemsInnerStateEnumSerializer;

  const FinanceBookingPageDtoOutputItemsInnerStateEnum._(String name): super(name);

  static BuiltSet<FinanceBookingPageDtoOutputItemsInnerStateEnum> get values => _$financeBookingPageDtoOutputItemsInnerStateEnumValues;
  static FinanceBookingPageDtoOutputItemsInnerStateEnum valueOf(String name) => _$financeBookingPageDtoOutputItemsInnerStateEnumValueOf(name);
}

