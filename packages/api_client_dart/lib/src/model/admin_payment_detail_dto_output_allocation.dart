//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_payment_detail_dto_output_allocation.g.dart';

/// AdminPaymentDetailDtoOutputAllocation
///
/// Properties:
/// * [commissionAmount] 
/// * [commissionRateBps] 
/// * [operatorNet] 
@BuiltValue()
abstract class AdminPaymentDetailDtoOutputAllocation implements Built<AdminPaymentDetailDtoOutputAllocation, AdminPaymentDetailDtoOutputAllocationBuilder> {
  @BuiltValueField(wireName: r'commissionAmount')
  int get commissionAmount;

  @BuiltValueField(wireName: r'commissionRateBps')
  int? get commissionRateBps;

  @BuiltValueField(wireName: r'operatorNet')
  int get operatorNet;

  AdminPaymentDetailDtoOutputAllocation._();

  factory AdminPaymentDetailDtoOutputAllocation([void updates(AdminPaymentDetailDtoOutputAllocationBuilder b)]) = _$AdminPaymentDetailDtoOutputAllocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPaymentDetailDtoOutputAllocationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPaymentDetailDtoOutputAllocation> get serializer => _$AdminPaymentDetailDtoOutputAllocationSerializer();
}

class _$AdminPaymentDetailDtoOutputAllocationSerializer implements PrimitiveSerializer<AdminPaymentDetailDtoOutputAllocation> {
  @override
  final Iterable<Type> types = const [AdminPaymentDetailDtoOutputAllocation, _$AdminPaymentDetailDtoOutputAllocation];

  @override
  final String wireName = r'AdminPaymentDetailDtoOutputAllocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPaymentDetailDtoOutputAllocation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'commissionAmount';
    yield serializers.serialize(
      object.commissionAmount,
      specifiedType: const FullType(int),
    );
    yield r'commissionRateBps';
    yield object.commissionRateBps == null ? null : serializers.serialize(
      object.commissionRateBps,
      specifiedType: const FullType.nullable(int),
    );
    yield r'operatorNet';
    yield serializers.serialize(
      object.operatorNet,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPaymentDetailDtoOutputAllocation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPaymentDetailDtoOutputAllocationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'commissionAmount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commissionAmount = valueDes;
          break;
        case r'commissionRateBps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.commissionRateBps = valueDes;
          break;
        case r'operatorNet':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.operatorNet = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPaymentDetailDtoOutputAllocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPaymentDetailDtoOutputAllocationBuilder();
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


