//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/counter_booking_list_dto_output_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_receipt_result_dto_output.g.dart';

/// CounterReceiptResultDtoOutput
///
/// Properties:
/// * [receiptId] 
/// * [status] 
/// * [exceptionReason] 
/// * [booking] 
@BuiltValue()
abstract class CounterReceiptResultDtoOutput implements Built<CounterReceiptResultDtoOutput, CounterReceiptResultDtoOutputBuilder> {
  @BuiltValueField(wireName: r'receiptId')
  String get receiptId;

  @BuiltValueField(wireName: r'status')
  CounterReceiptResultDtoOutputStatusEnum get status;
  // enum statusEnum {  COMPLETED,  EXCEPTION,  };

  @BuiltValueField(wireName: r'exceptionReason')
  String? get exceptionReason;

  @BuiltValueField(wireName: r'booking')
  CounterBookingListDtoOutputItemsInner get booking;

  CounterReceiptResultDtoOutput._();

  factory CounterReceiptResultDtoOutput([void updates(CounterReceiptResultDtoOutputBuilder b)]) = _$CounterReceiptResultDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterReceiptResultDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterReceiptResultDtoOutput> get serializer => _$CounterReceiptResultDtoOutputSerializer();
}

class _$CounterReceiptResultDtoOutputSerializer implements PrimitiveSerializer<CounterReceiptResultDtoOutput> {
  @override
  final Iterable<Type> types = const [CounterReceiptResultDtoOutput, _$CounterReceiptResultDtoOutput];

  @override
  final String wireName = r'CounterReceiptResultDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterReceiptResultDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'receiptId';
    yield serializers.serialize(
      object.receiptId,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CounterReceiptResultDtoOutputStatusEnum),
    );
    yield r'exceptionReason';
    yield object.exceptionReason == null ? null : serializers.serialize(
      object.exceptionReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'booking';
    yield serializers.serialize(
      object.booking,
      specifiedType: const FullType(CounterBookingListDtoOutputItemsInner),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CounterReceiptResultDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterReceiptResultDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'receiptId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.receiptId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CounterReceiptResultDtoOutputStatusEnum),
          ) as CounterReceiptResultDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'exceptionReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.exceptionReason = valueDes;
          break;
        case r'booking':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CounterBookingListDtoOutputItemsInner),
          ) as CounterBookingListDtoOutputItemsInner;
          result.booking.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CounterReceiptResultDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterReceiptResultDtoOutputBuilder();
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


class CounterReceiptResultDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const CounterReceiptResultDtoOutputStatusEnum COMPLETED = _$counterReceiptResultDtoOutputStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'EXCEPTION')
  static const CounterReceiptResultDtoOutputStatusEnum EXCEPTION = _$counterReceiptResultDtoOutputStatusEnum_EXCEPTION;

  static Serializer<CounterReceiptResultDtoOutputStatusEnum> get serializer => _$counterReceiptResultDtoOutputStatusEnumSerializer;

  const CounterReceiptResultDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<CounterReceiptResultDtoOutputStatusEnum> get values => _$counterReceiptResultDtoOutputStatusEnumValues;
  static CounterReceiptResultDtoOutputStatusEnum valueOf(String name) => _$counterReceiptResultDtoOutputStatusEnumValueOf(name);
}

