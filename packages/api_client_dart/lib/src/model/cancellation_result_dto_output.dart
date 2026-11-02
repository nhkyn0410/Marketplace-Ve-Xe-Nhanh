//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/cancellation_result_dto_output_booking.dart';
import 'package:api_client_dart/src/model/cancellation_result_dto_output_refund.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancellation_result_dto_output.g.dart';

/// CancellationResultDtoOutput
///
/// Properties:
/// * [booking] 
/// * [refund] 
@BuiltValue()
abstract class CancellationResultDtoOutput implements Built<CancellationResultDtoOutput, CancellationResultDtoOutputBuilder> {
  @BuiltValueField(wireName: r'booking')
  CancellationResultDtoOutputBooking get booking;

  @BuiltValueField(wireName: r'refund')
  CancellationResultDtoOutputRefund? get refund;

  CancellationResultDtoOutput._();

  factory CancellationResultDtoOutput([void updates(CancellationResultDtoOutputBuilder b)]) = _$CancellationResultDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancellationResultDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancellationResultDtoOutput> get serializer => _$CancellationResultDtoOutputSerializer();
}

class _$CancellationResultDtoOutputSerializer implements PrimitiveSerializer<CancellationResultDtoOutput> {
  @override
  final Iterable<Type> types = const [CancellationResultDtoOutput, _$CancellationResultDtoOutput];

  @override
  final String wireName = r'CancellationResultDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancellationResultDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'booking';
    yield serializers.serialize(
      object.booking,
      specifiedType: const FullType(CancellationResultDtoOutputBooking),
    );
    yield r'refund';
    yield object.refund == null ? null : serializers.serialize(
      object.refund,
      specifiedType: const FullType.nullable(CancellationResultDtoOutputRefund),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CancellationResultDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancellationResultDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'booking':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CancellationResultDtoOutputBooking),
          ) as CancellationResultDtoOutputBooking;
          result.booking.replace(valueDes);
          break;
        case r'refund':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CancellationResultDtoOutputRefund),
          ) as CancellationResultDtoOutputRefund?;
          if (valueDes == null) continue;
          result.refund.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CancellationResultDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancellationResultDtoOutputBuilder();
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


