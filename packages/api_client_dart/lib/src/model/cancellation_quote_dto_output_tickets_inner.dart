//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancellation_quote_dto_output_tickets_inner.g.dart';

/// CancellationQuoteDtoOutputTicketsInner
///
/// Properties:
/// * [ticketId] 
/// * [ticketCode] 
/// * [seatCode] 
/// * [passengerName] 
/// * [status] 
/// * [price] 
/// * [cancellable] 
/// * [reason] 
@BuiltValue()
abstract class CancellationQuoteDtoOutputTicketsInner implements Built<CancellationQuoteDtoOutputTicketsInner, CancellationQuoteDtoOutputTicketsInnerBuilder> {
  @BuiltValueField(wireName: r'ticketId')
  String get ticketId;

  @BuiltValueField(wireName: r'ticketCode')
  String get ticketCode;

  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'passengerName')
  String get passengerName;

  @BuiltValueField(wireName: r'status')
  CancellationQuoteDtoOutputTicketsInnerStatusEnum get status;
  // enum statusEnum {  VALID,  CANCELLED,  CHECKED_IN,  NO_SHOW,  USED,  REFUNDED,  };

  @BuiltValueField(wireName: r'price')
  int get price;

  @BuiltValueField(wireName: r'cancellable')
  bool get cancellable;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  CancellationQuoteDtoOutputTicketsInner._();

  factory CancellationQuoteDtoOutputTicketsInner([void updates(CancellationQuoteDtoOutputTicketsInnerBuilder b)]) = _$CancellationQuoteDtoOutputTicketsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancellationQuoteDtoOutputTicketsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancellationQuoteDtoOutputTicketsInner> get serializer => _$CancellationQuoteDtoOutputTicketsInnerSerializer();
}

class _$CancellationQuoteDtoOutputTicketsInnerSerializer implements PrimitiveSerializer<CancellationQuoteDtoOutputTicketsInner> {
  @override
  final Iterable<Type> types = const [CancellationQuoteDtoOutputTicketsInner, _$CancellationQuoteDtoOutputTicketsInner];

  @override
  final String wireName = r'CancellationQuoteDtoOutputTicketsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancellationQuoteDtoOutputTicketsInner object, {
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
      specifiedType: const FullType(CancellationQuoteDtoOutputTicketsInnerStatusEnum),
    );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(int),
    );
    yield r'cancellable';
    yield serializers.serialize(
      object.cancellable,
      specifiedType: const FullType(bool),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CancellationQuoteDtoOutputTicketsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancellationQuoteDtoOutputTicketsInnerBuilder result,
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
            specifiedType: const FullType(CancellationQuoteDtoOutputTicketsInnerStatusEnum),
          ) as CancellationQuoteDtoOutputTicketsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.price = valueDes;
          break;
        case r'cancellable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.cancellable = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CancellationQuoteDtoOutputTicketsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancellationQuoteDtoOutputTicketsInnerBuilder();
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


class CancellationQuoteDtoOutputTicketsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALID')
  static const CancellationQuoteDtoOutputTicketsInnerStatusEnum VALID = _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_VALID;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CancellationQuoteDtoOutputTicketsInnerStatusEnum CANCELLED = _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CHECKED_IN')
  static const CancellationQuoteDtoOutputTicketsInnerStatusEnum CHECKED_IN = _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_CHECKED_IN;
  @BuiltValueEnumConst(wireName: r'NO_SHOW')
  static const CancellationQuoteDtoOutputTicketsInnerStatusEnum NO_SHOW = _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_NO_SHOW;
  @BuiltValueEnumConst(wireName: r'USED')
  static const CancellationQuoteDtoOutputTicketsInnerStatusEnum USED = _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_USED;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const CancellationQuoteDtoOutputTicketsInnerStatusEnum REFUNDED = _$cancellationQuoteDtoOutputTicketsInnerStatusEnum_REFUNDED;

  static Serializer<CancellationQuoteDtoOutputTicketsInnerStatusEnum> get serializer => _$cancellationQuoteDtoOutputTicketsInnerStatusEnumSerializer;

  const CancellationQuoteDtoOutputTicketsInnerStatusEnum._(String name): super(name);

  static BuiltSet<CancellationQuoteDtoOutputTicketsInnerStatusEnum> get values => _$cancellationQuoteDtoOutputTicketsInnerStatusEnumValues;
  static CancellationQuoteDtoOutputTicketsInnerStatusEnum valueOf(String name) => _$cancellationQuoteDtoOutputTicketsInnerStatusEnumValueOf(name);
}

