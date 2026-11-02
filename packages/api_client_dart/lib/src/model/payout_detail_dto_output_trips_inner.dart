//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payout_detail_dto_output_trips_inner.g.dart';

/// PayoutDetailDtoOutputTripsInner
///
/// Properties:
/// * [tripId] 
/// * [departureAt] 
/// * [routeName] 
/// * [vehiclePlateNumber] 
/// * [bookingCount] 
/// * [grossAmount] 
/// * [commissionAmount] 
/// * [refundAdjustmentAmount] 
/// * [amount] 
@BuiltValue()
abstract class PayoutDetailDtoOutputTripsInner implements Built<PayoutDetailDtoOutputTripsInner, PayoutDetailDtoOutputTripsInnerBuilder> {
  @BuiltValueField(wireName: r'tripId')
  String? get tripId;

  @BuiltValueField(wireName: r'departureAt')
  DateTime? get departureAt;

  @BuiltValueField(wireName: r'routeName')
  String? get routeName;

  @BuiltValueField(wireName: r'vehiclePlateNumber')
  String? get vehiclePlateNumber;

  @BuiltValueField(wireName: r'bookingCount')
  int get bookingCount;

  @BuiltValueField(wireName: r'grossAmount')
  int get grossAmount;

  @BuiltValueField(wireName: r'commissionAmount')
  int get commissionAmount;

  @BuiltValueField(wireName: r'refundAdjustmentAmount')
  int get refundAdjustmentAmount;

  @BuiltValueField(wireName: r'amount')
  int get amount;

  PayoutDetailDtoOutputTripsInner._();

  factory PayoutDetailDtoOutputTripsInner([void updates(PayoutDetailDtoOutputTripsInnerBuilder b)]) = _$PayoutDetailDtoOutputTripsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PayoutDetailDtoOutputTripsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PayoutDetailDtoOutputTripsInner> get serializer => _$PayoutDetailDtoOutputTripsInnerSerializer();
}

class _$PayoutDetailDtoOutputTripsInnerSerializer implements PrimitiveSerializer<PayoutDetailDtoOutputTripsInner> {
  @override
  final Iterable<Type> types = const [PayoutDetailDtoOutputTripsInner, _$PayoutDetailDtoOutputTripsInner];

  @override
  final String wireName = r'PayoutDetailDtoOutputTripsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PayoutDetailDtoOutputTripsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tripId';
    yield object.tripId == null ? null : serializers.serialize(
      object.tripId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'departureAt';
    yield object.departureAt == null ? null : serializers.serialize(
      object.departureAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'routeName';
    yield object.routeName == null ? null : serializers.serialize(
      object.routeName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'vehiclePlateNumber';
    yield object.vehiclePlateNumber == null ? null : serializers.serialize(
      object.vehiclePlateNumber,
      specifiedType: const FullType.nullable(String),
    );
    yield r'bookingCount';
    yield serializers.serialize(
      object.bookingCount,
      specifiedType: const FullType(int),
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
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PayoutDetailDtoOutputTripsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PayoutDetailDtoOutputTripsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tripId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.tripId = valueDes;
          break;
        case r'departureAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.departureAt = valueDes;
          break;
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.routeName = valueDes;
          break;
        case r'vehiclePlateNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehiclePlateNumber = valueDes;
          break;
        case r'bookingCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.bookingCount = valueDes;
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
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PayoutDetailDtoOutputTripsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PayoutDetailDtoOutputTripsInnerBuilder();
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


