//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'counter_booking_dto_output_receipts_inner.g.dart';

/// CounterBookingDtoOutputReceiptsInner
///
/// Properties:
/// * [id] 
/// * [method] 
/// * [amount] 
/// * [reference] 
/// * [status] 
/// * [exceptionReason] 
/// * [createdAt] 
@BuiltValue()
abstract class CounterBookingDtoOutputReceiptsInner implements Built<CounterBookingDtoOutputReceiptsInner, CounterBookingDtoOutputReceiptsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'method')
  CounterBookingDtoOutputReceiptsInnerMethodEnum get method;
  // enum methodEnum {  CASH,  BANK_TRANSFER,  };

  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'reference')
  String? get reference;

  @BuiltValueField(wireName: r'status')
  CounterBookingDtoOutputReceiptsInnerStatusEnum get status;
  // enum statusEnum {  COMPLETED,  EXCEPTION,  };

  @BuiltValueField(wireName: r'exceptionReason')
  String? get exceptionReason;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  CounterBookingDtoOutputReceiptsInner._();

  factory CounterBookingDtoOutputReceiptsInner([void updates(CounterBookingDtoOutputReceiptsInnerBuilder b)]) = _$CounterBookingDtoOutputReceiptsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CounterBookingDtoOutputReceiptsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CounterBookingDtoOutputReceiptsInner> get serializer => _$CounterBookingDtoOutputReceiptsInnerSerializer();
}

class _$CounterBookingDtoOutputReceiptsInnerSerializer implements PrimitiveSerializer<CounterBookingDtoOutputReceiptsInner> {
  @override
  final Iterable<Type> types = const [CounterBookingDtoOutputReceiptsInner, _$CounterBookingDtoOutputReceiptsInner];

  @override
  final String wireName = r'CounterBookingDtoOutputReceiptsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CounterBookingDtoOutputReceiptsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(CounterBookingDtoOutputReceiptsInnerMethodEnum),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield object.reference == null ? null : serializers.serialize(
      object.reference,
      specifiedType: const FullType.nullable(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CounterBookingDtoOutputReceiptsInnerStatusEnum),
    );
    yield r'exceptionReason';
    yield object.exceptionReason == null ? null : serializers.serialize(
      object.exceptionReason,
      specifiedType: const FullType.nullable(String),
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
    CounterBookingDtoOutputReceiptsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CounterBookingDtoOutputReceiptsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CounterBookingDtoOutputReceiptsInnerMethodEnum),
          ) as CounterBookingDtoOutputReceiptsInnerMethodEnum;
          result.method = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reference = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CounterBookingDtoOutputReceiptsInnerStatusEnum),
          ) as CounterBookingDtoOutputReceiptsInnerStatusEnum;
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
  CounterBookingDtoOutputReceiptsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CounterBookingDtoOutputReceiptsInnerBuilder();
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


class CounterBookingDtoOutputReceiptsInnerMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CASH')
  static const CounterBookingDtoOutputReceiptsInnerMethodEnum CASH = _$counterBookingDtoOutputReceiptsInnerMethodEnum_CASH;
  @BuiltValueEnumConst(wireName: r'BANK_TRANSFER')
  static const CounterBookingDtoOutputReceiptsInnerMethodEnum BANK_TRANSFER = _$counterBookingDtoOutputReceiptsInnerMethodEnum_BANK_TRANSFER;

  static Serializer<CounterBookingDtoOutputReceiptsInnerMethodEnum> get serializer => _$counterBookingDtoOutputReceiptsInnerMethodEnumSerializer;

  const CounterBookingDtoOutputReceiptsInnerMethodEnum._(String name): super(name);

  static BuiltSet<CounterBookingDtoOutputReceiptsInnerMethodEnum> get values => _$counterBookingDtoOutputReceiptsInnerMethodEnumValues;
  static CounterBookingDtoOutputReceiptsInnerMethodEnum valueOf(String name) => _$counterBookingDtoOutputReceiptsInnerMethodEnumValueOf(name);
}

class CounterBookingDtoOutputReceiptsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const CounterBookingDtoOutputReceiptsInnerStatusEnum COMPLETED = _$counterBookingDtoOutputReceiptsInnerStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'EXCEPTION')
  static const CounterBookingDtoOutputReceiptsInnerStatusEnum EXCEPTION = _$counterBookingDtoOutputReceiptsInnerStatusEnum_EXCEPTION;

  static Serializer<CounterBookingDtoOutputReceiptsInnerStatusEnum> get serializer => _$counterBookingDtoOutputReceiptsInnerStatusEnumSerializer;

  const CounterBookingDtoOutputReceiptsInnerStatusEnum._(String name): super(name);

  static BuiltSet<CounterBookingDtoOutputReceiptsInnerStatusEnum> get values => _$counterBookingDtoOutputReceiptsInnerStatusEnumValues;
  static CounterBookingDtoOutputReceiptsInnerStatusEnum valueOf(String name) => _$counterBookingDtoOutputReceiptsInnerStatusEnumValueOf(name);
}

