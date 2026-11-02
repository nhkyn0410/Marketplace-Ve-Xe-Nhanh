//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'created_booking_dto_output_refunds_inner.g.dart';

/// CreatedBookingDtoOutputRefundsInner
///
/// Properties:
/// * [refundCode] 
/// * [amount] 
/// * [status] 
/// * [createdAt] 
@BuiltValue()
abstract class CreatedBookingDtoOutputRefundsInner implements Built<CreatedBookingDtoOutputRefundsInner, CreatedBookingDtoOutputRefundsInnerBuilder> {
  @BuiltValueField(wireName: r'refundCode')
  String get refundCode;

  @BuiltValueField(wireName: r'amount')
  int get amount;

  @BuiltValueField(wireName: r'status')
  CreatedBookingDtoOutputRefundsInnerStatusEnum get status;
  // enum statusEnum {  REQUESTED,  APPROVED,  PROCESSING,  SUCCESS,  FAILED,  REJECTED,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  CreatedBookingDtoOutputRefundsInner._();

  factory CreatedBookingDtoOutputRefundsInner([void updates(CreatedBookingDtoOutputRefundsInnerBuilder b)]) = _$CreatedBookingDtoOutputRefundsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreatedBookingDtoOutputRefundsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreatedBookingDtoOutputRefundsInner> get serializer => _$CreatedBookingDtoOutputRefundsInnerSerializer();
}

class _$CreatedBookingDtoOutputRefundsInnerSerializer implements PrimitiveSerializer<CreatedBookingDtoOutputRefundsInner> {
  @override
  final Iterable<Type> types = const [CreatedBookingDtoOutputRefundsInner, _$CreatedBookingDtoOutputRefundsInner];

  @override
  final String wireName = r'CreatedBookingDtoOutputRefundsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreatedBookingDtoOutputRefundsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'refundCode';
    yield serializers.serialize(
      object.refundCode,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CreatedBookingDtoOutputRefundsInnerStatusEnum),
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
    CreatedBookingDtoOutputRefundsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreatedBookingDtoOutputRefundsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'refundCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refundCode = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amount = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreatedBookingDtoOutputRefundsInnerStatusEnum),
          ) as CreatedBookingDtoOutputRefundsInnerStatusEnum;
          result.status = valueDes;
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
  CreatedBookingDtoOutputRefundsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreatedBookingDtoOutputRefundsInnerBuilder();
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


class CreatedBookingDtoOutputRefundsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUESTED')
  static const CreatedBookingDtoOutputRefundsInnerStatusEnum REQUESTED = _$createdBookingDtoOutputRefundsInnerStatusEnum_REQUESTED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const CreatedBookingDtoOutputRefundsInnerStatusEnum APPROVED = _$createdBookingDtoOutputRefundsInnerStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const CreatedBookingDtoOutputRefundsInnerStatusEnum PROCESSING = _$createdBookingDtoOutputRefundsInnerStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const CreatedBookingDtoOutputRefundsInnerStatusEnum SUCCESS = _$createdBookingDtoOutputRefundsInnerStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const CreatedBookingDtoOutputRefundsInnerStatusEnum FAILED = _$createdBookingDtoOutputRefundsInnerStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const CreatedBookingDtoOutputRefundsInnerStatusEnum REJECTED = _$createdBookingDtoOutputRefundsInnerStatusEnum_REJECTED;

  static Serializer<CreatedBookingDtoOutputRefundsInnerStatusEnum> get serializer => _$createdBookingDtoOutputRefundsInnerStatusEnumSerializer;

  const CreatedBookingDtoOutputRefundsInnerStatusEnum._(String name): super(name);

  static BuiltSet<CreatedBookingDtoOutputRefundsInnerStatusEnum> get values => _$createdBookingDtoOutputRefundsInnerStatusEnumValues;
  static CreatedBookingDtoOutputRefundsInnerStatusEnum valueOf(String name) => _$createdBookingDtoOutputRefundsInnerStatusEnumValueOf(name);
}

