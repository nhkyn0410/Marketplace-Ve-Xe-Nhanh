//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_payment_detail_dto_output_tickets_inner.g.dart';

/// AdminPaymentDetailDtoOutputTicketsInner
///
/// Properties:
/// * [ticketCode] 
/// * [seatCode] 
/// * [status] 
/// * [issuedAt] 
@BuiltValue()
abstract class AdminPaymentDetailDtoOutputTicketsInner implements Built<AdminPaymentDetailDtoOutputTicketsInner, AdminPaymentDetailDtoOutputTicketsInnerBuilder> {
  @BuiltValueField(wireName: r'ticketCode')
  String get ticketCode;

  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'status')
  AdminPaymentDetailDtoOutputTicketsInnerStatusEnum get status;
  // enum statusEnum {  VALID,  CANCELLED,  CHECKED_IN,  NO_SHOW,  USED,  REFUNDED,  };

  @BuiltValueField(wireName: r'issuedAt')
  DateTime get issuedAt;

  AdminPaymentDetailDtoOutputTicketsInner._();

  factory AdminPaymentDetailDtoOutputTicketsInner([void updates(AdminPaymentDetailDtoOutputTicketsInnerBuilder b)]) = _$AdminPaymentDetailDtoOutputTicketsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPaymentDetailDtoOutputTicketsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPaymentDetailDtoOutputTicketsInner> get serializer => _$AdminPaymentDetailDtoOutputTicketsInnerSerializer();
}

class _$AdminPaymentDetailDtoOutputTicketsInnerSerializer implements PrimitiveSerializer<AdminPaymentDetailDtoOutputTicketsInner> {
  @override
  final Iterable<Type> types = const [AdminPaymentDetailDtoOutputTicketsInner, _$AdminPaymentDetailDtoOutputTicketsInner];

  @override
  final String wireName = r'AdminPaymentDetailDtoOutputTicketsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPaymentDetailDtoOutputTicketsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminPaymentDetailDtoOutputTicketsInnerStatusEnum),
    );
    yield r'issuedAt';
    yield serializers.serialize(
      object.issuedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPaymentDetailDtoOutputTicketsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPaymentDetailDtoOutputTicketsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPaymentDetailDtoOutputTicketsInnerStatusEnum),
          ) as AdminPaymentDetailDtoOutputTicketsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'issuedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.issuedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPaymentDetailDtoOutputTicketsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPaymentDetailDtoOutputTicketsInnerBuilder();
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


class AdminPaymentDetailDtoOutputTicketsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALID')
  static const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum VALID = _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_VALID;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum CANCELLED = _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CHECKED_IN')
  static const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum CHECKED_IN = _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_CHECKED_IN;
  @BuiltValueEnumConst(wireName: r'NO_SHOW')
  static const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum NO_SHOW = _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_NO_SHOW;
  @BuiltValueEnumConst(wireName: r'USED')
  static const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum USED = _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_USED;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum REFUNDED = _$adminPaymentDetailDtoOutputTicketsInnerStatusEnum_REFUNDED;

  static Serializer<AdminPaymentDetailDtoOutputTicketsInnerStatusEnum> get serializer => _$adminPaymentDetailDtoOutputTicketsInnerStatusEnumSerializer;

  const AdminPaymentDetailDtoOutputTicketsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminPaymentDetailDtoOutputTicketsInnerStatusEnum> get values => _$adminPaymentDetailDtoOutputTicketsInnerStatusEnumValues;
  static AdminPaymentDetailDtoOutputTicketsInnerStatusEnum valueOf(String name) => _$adminPaymentDetailDtoOutputTicketsInnerStatusEnumValueOf(name);
}

