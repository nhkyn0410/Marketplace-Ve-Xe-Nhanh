//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_detail_dto_output_cancellation_tiers_inner.g.dart';

/// DisputeDetailDtoOutputCancellationTiersInner
///
/// Properties:
/// * [minHoursBefore] 
/// * [refundPercent] 
@BuiltValue()
abstract class DisputeDetailDtoOutputCancellationTiersInner implements Built<DisputeDetailDtoOutputCancellationTiersInner, DisputeDetailDtoOutputCancellationTiersInnerBuilder> {
  @BuiltValueField(wireName: r'minHoursBefore')
  num get minHoursBefore;

  @BuiltValueField(wireName: r'refundPercent')
  num get refundPercent;

  DisputeDetailDtoOutputCancellationTiersInner._();

  factory DisputeDetailDtoOutputCancellationTiersInner([void updates(DisputeDetailDtoOutputCancellationTiersInnerBuilder b)]) = _$DisputeDetailDtoOutputCancellationTiersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeDetailDtoOutputCancellationTiersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeDetailDtoOutputCancellationTiersInner> get serializer => _$DisputeDetailDtoOutputCancellationTiersInnerSerializer();
}

class _$DisputeDetailDtoOutputCancellationTiersInnerSerializer implements PrimitiveSerializer<DisputeDetailDtoOutputCancellationTiersInner> {
  @override
  final Iterable<Type> types = const [DisputeDetailDtoOutputCancellationTiersInner, _$DisputeDetailDtoOutputCancellationTiersInner];

  @override
  final String wireName = r'DisputeDetailDtoOutputCancellationTiersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeDetailDtoOutputCancellationTiersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'minHoursBefore';
    yield serializers.serialize(
      object.minHoursBefore,
      specifiedType: const FullType(num),
    );
    yield r'refundPercent';
    yield serializers.serialize(
      object.refundPercent,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeDetailDtoOutputCancellationTiersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeDetailDtoOutputCancellationTiersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'minHoursBefore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.minHoursBefore = valueDes;
          break;
        case r'refundPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.refundPercent = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeDetailDtoOutputCancellationTiersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeDetailDtoOutputCancellationTiersInnerBuilder();
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


