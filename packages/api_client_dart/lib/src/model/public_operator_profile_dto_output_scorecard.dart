//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_operator_profile_dto_output_scorecard.g.dart';

/// PublicOperatorProfileDtoOutputScorecard
///
/// Properties:
/// * [averageRating] 
/// * [reviewCount] 
/// * [operatorCancellationRate] 
/// * [refundBookingRate] 
/// * [disputeBookingRate] 
/// * [checkInRate] 
/// * [noShowRate] 
@BuiltValue()
abstract class PublicOperatorProfileDtoOutputScorecard implements Built<PublicOperatorProfileDtoOutputScorecard, PublicOperatorProfileDtoOutputScorecardBuilder> {
  @BuiltValueField(wireName: r'averageRating')
  num? get averageRating;

  @BuiltValueField(wireName: r'reviewCount')
  int get reviewCount;

  @BuiltValueField(wireName: r'operatorCancellationRate')
  num? get operatorCancellationRate;

  @BuiltValueField(wireName: r'refundBookingRate')
  num? get refundBookingRate;

  @BuiltValueField(wireName: r'disputeBookingRate')
  num? get disputeBookingRate;

  @BuiltValueField(wireName: r'checkInRate')
  num? get checkInRate;

  @BuiltValueField(wireName: r'noShowRate')
  num? get noShowRate;

  PublicOperatorProfileDtoOutputScorecard._();

  factory PublicOperatorProfileDtoOutputScorecard([void updates(PublicOperatorProfileDtoOutputScorecardBuilder b)]) = _$PublicOperatorProfileDtoOutputScorecard;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicOperatorProfileDtoOutputScorecardBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicOperatorProfileDtoOutputScorecard> get serializer => _$PublicOperatorProfileDtoOutputScorecardSerializer();
}

class _$PublicOperatorProfileDtoOutputScorecardSerializer implements PrimitiveSerializer<PublicOperatorProfileDtoOutputScorecard> {
  @override
  final Iterable<Type> types = const [PublicOperatorProfileDtoOutputScorecard, _$PublicOperatorProfileDtoOutputScorecard];

  @override
  final String wireName = r'PublicOperatorProfileDtoOutputScorecard';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicOperatorProfileDtoOutputScorecard object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'averageRating';
    yield object.averageRating == null ? null : serializers.serialize(
      object.averageRating,
      specifiedType: const FullType.nullable(num),
    );
    yield r'reviewCount';
    yield serializers.serialize(
      object.reviewCount,
      specifiedType: const FullType(int),
    );
    yield r'operatorCancellationRate';
    yield object.operatorCancellationRate == null ? null : serializers.serialize(
      object.operatorCancellationRate,
      specifiedType: const FullType.nullable(num),
    );
    yield r'refundBookingRate';
    yield object.refundBookingRate == null ? null : serializers.serialize(
      object.refundBookingRate,
      specifiedType: const FullType.nullable(num),
    );
    yield r'disputeBookingRate';
    yield object.disputeBookingRate == null ? null : serializers.serialize(
      object.disputeBookingRate,
      specifiedType: const FullType.nullable(num),
    );
    yield r'checkInRate';
    yield object.checkInRate == null ? null : serializers.serialize(
      object.checkInRate,
      specifiedType: const FullType.nullable(num),
    );
    yield r'noShowRate';
    yield object.noShowRate == null ? null : serializers.serialize(
      object.noShowRate,
      specifiedType: const FullType.nullable(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicOperatorProfileDtoOutputScorecard object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicOperatorProfileDtoOutputScorecardBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'averageRating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.averageRating = valueDes;
          break;
        case r'reviewCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.reviewCount = valueDes;
          break;
        case r'operatorCancellationRate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.operatorCancellationRate = valueDes;
          break;
        case r'refundBookingRate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.refundBookingRate = valueDes;
          break;
        case r'disputeBookingRate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.disputeBookingRate = valueDes;
          break;
        case r'checkInRate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.checkInRate = valueDes;
          break;
        case r'noShowRate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.noShowRate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicOperatorProfileDtoOutputScorecard deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicOperatorProfileDtoOutputScorecardBuilder();
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


