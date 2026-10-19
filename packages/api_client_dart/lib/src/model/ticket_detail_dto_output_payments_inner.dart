//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_detail_dto_output_payments_inner.g.dart';

/// TicketDetailDtoOutputPaymentsInner
///
/// Properties:
/// * [paymentId] 
/// * [paymentCode] 
/// * [provider] 
/// * [status] 
/// * [amount] 
@BuiltValue()
abstract class TicketDetailDtoOutputPaymentsInner implements Built<TicketDetailDtoOutputPaymentsInner, TicketDetailDtoOutputPaymentsInnerBuilder> {
  @BuiltValueField(wireName: r'paymentId')
  String get paymentId;

  @BuiltValueField(wireName: r'paymentCode')
  String get paymentCode;

  @BuiltValueField(wireName: r'provider')
  TicketDetailDtoOutputPaymentsInnerProviderEnum get provider;
  // enum providerEnum {  VNPAY,  MOMO,  };

  @BuiltValueField(wireName: r'status')
  TicketDetailDtoOutputPaymentsInnerStatusEnum get status;
  // enum statusEnum {  INITIATED,  PROCESSING,  SUCCESS,  FAILED,  EXPIRED,  CANCELLED,  RECONCILING,  };

  @BuiltValueField(wireName: r'amount')
  int get amount;

  TicketDetailDtoOutputPaymentsInner._();

  factory TicketDetailDtoOutputPaymentsInner([void updates(TicketDetailDtoOutputPaymentsInnerBuilder b)]) = _$TicketDetailDtoOutputPaymentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketDetailDtoOutputPaymentsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketDetailDtoOutputPaymentsInner> get serializer => _$TicketDetailDtoOutputPaymentsInnerSerializer();
}

class _$TicketDetailDtoOutputPaymentsInnerSerializer implements PrimitiveSerializer<TicketDetailDtoOutputPaymentsInner> {
  @override
  final Iterable<Type> types = const [TicketDetailDtoOutputPaymentsInner, _$TicketDetailDtoOutputPaymentsInner];

  @override
  final String wireName = r'TicketDetailDtoOutputPaymentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketDetailDtoOutputPaymentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'paymentId';
    yield serializers.serialize(
      object.paymentId,
      specifiedType: const FullType(String),
    );
    yield r'paymentCode';
    yield serializers.serialize(
      object.paymentCode,
      specifiedType: const FullType(String),
    );
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(TicketDetailDtoOutputPaymentsInnerProviderEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(TicketDetailDtoOutputPaymentsInnerStatusEnum),
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
    TicketDetailDtoOutputPaymentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketDetailDtoOutputPaymentsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'paymentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentId = valueDes;
          break;
        case r'paymentCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentCode = valueDes;
          break;
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketDetailDtoOutputPaymentsInnerProviderEnum),
          ) as TicketDetailDtoOutputPaymentsInnerProviderEnum;
          result.provider = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketDetailDtoOutputPaymentsInnerStatusEnum),
          ) as TicketDetailDtoOutputPaymentsInnerStatusEnum;
          result.status = valueDes;
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
  TicketDetailDtoOutputPaymentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketDetailDtoOutputPaymentsInnerBuilder();
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


class TicketDetailDtoOutputPaymentsInnerProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VNPAY')
  static const TicketDetailDtoOutputPaymentsInnerProviderEnum VNPAY = _$ticketDetailDtoOutputPaymentsInnerProviderEnum_VNPAY;
  @BuiltValueEnumConst(wireName: r'MOMO')
  static const TicketDetailDtoOutputPaymentsInnerProviderEnum MOMO = _$ticketDetailDtoOutputPaymentsInnerProviderEnum_MOMO;

  static Serializer<TicketDetailDtoOutputPaymentsInnerProviderEnum> get serializer => _$ticketDetailDtoOutputPaymentsInnerProviderEnumSerializer;

  const TicketDetailDtoOutputPaymentsInnerProviderEnum._(String name): super(name);

  static BuiltSet<TicketDetailDtoOutputPaymentsInnerProviderEnum> get values => _$ticketDetailDtoOutputPaymentsInnerProviderEnumValues;
  static TicketDetailDtoOutputPaymentsInnerProviderEnum valueOf(String name) => _$ticketDetailDtoOutputPaymentsInnerProviderEnumValueOf(name);
}

class TicketDetailDtoOutputPaymentsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INITIATED')
  static const TicketDetailDtoOutputPaymentsInnerStatusEnum INITIATED = _$ticketDetailDtoOutputPaymentsInnerStatusEnum_INITIATED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const TicketDetailDtoOutputPaymentsInnerStatusEnum PROCESSING = _$ticketDetailDtoOutputPaymentsInnerStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const TicketDetailDtoOutputPaymentsInnerStatusEnum SUCCESS = _$ticketDetailDtoOutputPaymentsInnerStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const TicketDetailDtoOutputPaymentsInnerStatusEnum FAILED = _$ticketDetailDtoOutputPaymentsInnerStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const TicketDetailDtoOutputPaymentsInnerStatusEnum EXPIRED = _$ticketDetailDtoOutputPaymentsInnerStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const TicketDetailDtoOutputPaymentsInnerStatusEnum CANCELLED = _$ticketDetailDtoOutputPaymentsInnerStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'RECONCILING')
  static const TicketDetailDtoOutputPaymentsInnerStatusEnum RECONCILING = _$ticketDetailDtoOutputPaymentsInnerStatusEnum_RECONCILING;

  static Serializer<TicketDetailDtoOutputPaymentsInnerStatusEnum> get serializer => _$ticketDetailDtoOutputPaymentsInnerStatusEnumSerializer;

  const TicketDetailDtoOutputPaymentsInnerStatusEnum._(String name): super(name);

  static BuiltSet<TicketDetailDtoOutputPaymentsInnerStatusEnum> get values => _$ticketDetailDtoOutputPaymentsInnerStatusEnumValues;
  static TicketDetailDtoOutputPaymentsInnerStatusEnum valueOf(String name) => _$ticketDetailDtoOutputPaymentsInnerStatusEnumValueOf(name);
}

