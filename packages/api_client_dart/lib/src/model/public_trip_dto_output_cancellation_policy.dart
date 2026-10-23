//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client_dart/src/model/public_trip_dto_output_cancellation_policy_tiers_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_trip_dto_output_cancellation_policy.g.dart';

/// PublicTripDtoOutputCancellationPolicy
///
/// Properties:
/// * [tiers] 
@BuiltValue()
abstract class PublicTripDtoOutputCancellationPolicy implements Built<PublicTripDtoOutputCancellationPolicy, PublicTripDtoOutputCancellationPolicyBuilder> {
  @BuiltValueField(wireName: r'tiers')
  BuiltList<PublicTripDtoOutputCancellationPolicyTiersInner> get tiers;

  PublicTripDtoOutputCancellationPolicy._();

  factory PublicTripDtoOutputCancellationPolicy([void updates(PublicTripDtoOutputCancellationPolicyBuilder b)]) = _$PublicTripDtoOutputCancellationPolicy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicTripDtoOutputCancellationPolicyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicTripDtoOutputCancellationPolicy> get serializer => _$PublicTripDtoOutputCancellationPolicySerializer();
}

class _$PublicTripDtoOutputCancellationPolicySerializer implements PrimitiveSerializer<PublicTripDtoOutputCancellationPolicy> {
  @override
  final Iterable<Type> types = const [PublicTripDtoOutputCancellationPolicy, _$PublicTripDtoOutputCancellationPolicy];

  @override
  final String wireName = r'PublicTripDtoOutputCancellationPolicy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicTripDtoOutputCancellationPolicy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tiers';
    yield serializers.serialize(
      object.tiers,
      specifiedType: const FullType(BuiltList, [FullType(PublicTripDtoOutputCancellationPolicyTiersInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicTripDtoOutputCancellationPolicy object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicTripDtoOutputCancellationPolicyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tiers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PublicTripDtoOutputCancellationPolicyTiersInner)]),
          ) as BuiltList<PublicTripDtoOutputCancellationPolicyTiersInner>;
          result.tiers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicTripDtoOutputCancellationPolicy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicTripDtoOutputCancellationPolicyBuilder();
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


