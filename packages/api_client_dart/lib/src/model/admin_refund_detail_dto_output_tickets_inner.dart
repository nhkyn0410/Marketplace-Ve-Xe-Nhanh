//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_refund_detail_dto_output_tickets_inner.g.dart';

/// AdminRefundDetailDtoOutputTicketsInner
///
/// Properties:
/// * [ticketCode] 
/// * [seatCode] 
/// * [status] 
@BuiltValue()
abstract class AdminRefundDetailDtoOutputTicketsInner implements Built<AdminRefundDetailDtoOutputTicketsInner, AdminRefundDetailDtoOutputTicketsInnerBuilder> {
  @BuiltValueField(wireName: r'ticketCode')
  String get ticketCode;

  @BuiltValueField(wireName: r'seatCode')
  String get seatCode;

  @BuiltValueField(wireName: r'status')
  AdminRefundDetailDtoOutputTicketsInnerStatusEnum get status;
  // enum statusEnum {  VALID,  CANCELLED,  CHECKED_IN,  NO_SHOW,  USED,  REFUNDED,  };

  AdminRefundDetailDtoOutputTicketsInner._();

  factory AdminRefundDetailDtoOutputTicketsInner([void updates(AdminRefundDetailDtoOutputTicketsInnerBuilder b)]) = _$AdminRefundDetailDtoOutputTicketsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRefundDetailDtoOutputTicketsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRefundDetailDtoOutputTicketsInner> get serializer => _$AdminRefundDetailDtoOutputTicketsInnerSerializer();
}

class _$AdminRefundDetailDtoOutputTicketsInnerSerializer implements PrimitiveSerializer<AdminRefundDetailDtoOutputTicketsInner> {
  @override
  final Iterable<Type> types = const [AdminRefundDetailDtoOutputTicketsInner, _$AdminRefundDetailDtoOutputTicketsInner];

  @override
  final String wireName = r'AdminRefundDetailDtoOutputTicketsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRefundDetailDtoOutputTicketsInner object, {
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
      specifiedType: const FullType(AdminRefundDetailDtoOutputTicketsInnerStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRefundDetailDtoOutputTicketsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRefundDetailDtoOutputTicketsInnerBuilder result,
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
            specifiedType: const FullType(AdminRefundDetailDtoOutputTicketsInnerStatusEnum),
          ) as AdminRefundDetailDtoOutputTicketsInnerStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRefundDetailDtoOutputTicketsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRefundDetailDtoOutputTicketsInnerBuilder();
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


class AdminRefundDetailDtoOutputTicketsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALID')
  static const AdminRefundDetailDtoOutputTicketsInnerStatusEnum VALID = _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_VALID;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const AdminRefundDetailDtoOutputTicketsInnerStatusEnum CANCELLED = _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'CHECKED_IN')
  static const AdminRefundDetailDtoOutputTicketsInnerStatusEnum CHECKED_IN = _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_CHECKED_IN;
  @BuiltValueEnumConst(wireName: r'NO_SHOW')
  static const AdminRefundDetailDtoOutputTicketsInnerStatusEnum NO_SHOW = _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_NO_SHOW;
  @BuiltValueEnumConst(wireName: r'USED')
  static const AdminRefundDetailDtoOutputTicketsInnerStatusEnum USED = _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_USED;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const AdminRefundDetailDtoOutputTicketsInnerStatusEnum REFUNDED = _$adminRefundDetailDtoOutputTicketsInnerStatusEnum_REFUNDED;

  static Serializer<AdminRefundDetailDtoOutputTicketsInnerStatusEnum> get serializer => _$adminRefundDetailDtoOutputTicketsInnerStatusEnumSerializer;

  const AdminRefundDetailDtoOutputTicketsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminRefundDetailDtoOutputTicketsInnerStatusEnum> get values => _$adminRefundDetailDtoOutputTicketsInnerStatusEnumValues;
  static AdminRefundDetailDtoOutputTicketsInnerStatusEnum valueOf(String name) => _$adminRefundDetailDtoOutputTicketsInnerStatusEnumValueOf(name);
}

