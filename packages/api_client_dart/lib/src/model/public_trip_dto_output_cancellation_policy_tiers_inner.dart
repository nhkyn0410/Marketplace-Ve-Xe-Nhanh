//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_trip_dto_output_cancellation_policy_tiers_inner.g.dart';

/// PublicTripDtoOutputCancellationPolicyTiersInner
///
/// Properties:
/// * [minHoursBefore] 
/// * [refundPercent] 
@BuiltValue()
abstract class PublicTripDtoOutputCancellationPolicyTiersInner implements Built<PublicTripDtoOutputCancellationPolicyTiersInner, PublicTripDtoOutputCancellationPolicyTiersInnerBuilder> {
  @BuiltValueField(wireName: r'minHoursBefore')
  int get minHoursBefore;

  @BuiltValueField(wireName: r'refundPercent')
  int get refundPercent;

  PublicTripDtoOutputCancellationPolicyTiersInner._();

  factory PublicTripDtoOutputCancellationPolicyTiersInner([void updates(PublicTripDtoOutputCancellationPolicyTiersInnerBuilder b)]) = _$PublicTripDtoOutputCancellationPolicyTiersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicTripDtoOutputCancellationPolicyTiersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicTripDtoOutputCancellationPolicyTiersInner> get serializer => _$PublicTripDtoOutputCancellationPolicyTiersInnerSerializer();
}

class _$PublicTripDtoOutputCancellationPolicyTiersInnerSerializer implements PrimitiveSerializer<PublicTripDtoOutputCancellationPolicyTiersInner> {
  @override
  final Iterable<Type> types = const [PublicTripDtoOutputCancellationPolicyTiersInner, _$PublicTripDtoOutputCancellationPolicyTiersInner];

  @override
  final String wireName = r'PublicTripDtoOutputCancellationPolicyTiersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicTripDtoOutputCancellationPolicyTiersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'minHoursBefore';
    yield serializers.serialize(
      object.minHoursBefore,
      specifiedType: const FullType(int),
    );
    yield r'refundPercent';
    yield serializers.serialize(
      object.refundPercent,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicTripDtoOutputCancellationPolicyTiersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicTripDtoOutputCancellationPolicyTiersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'minHoursBefore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minHoursBefore = valueDes;
          break;
        case r'refundPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
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
  PublicTripDtoOutputCancellationPolicyTiersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicTripDtoOutputCancellationPolicyTiersInnerBuilder();
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


