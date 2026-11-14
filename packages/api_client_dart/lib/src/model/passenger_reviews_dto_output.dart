//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/passenger_reviews_dto_output_pending.dart';
import 'package:api_client_dart/src/model/passenger_reviews_dto_output_reviewed.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_reviews_dto_output.g.dart';

/// PassengerReviewsDtoOutput
///
/// Properties:
/// * [pending] 
/// * [reviewed] 
@BuiltValue()
abstract class PassengerReviewsDtoOutput implements Built<PassengerReviewsDtoOutput, PassengerReviewsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'pending')
  PassengerReviewsDtoOutputPending get pending;

  @BuiltValueField(wireName: r'reviewed')
  PassengerReviewsDtoOutputReviewed get reviewed;

  PassengerReviewsDtoOutput._();

  factory PassengerReviewsDtoOutput([void updates(PassengerReviewsDtoOutputBuilder b)]) = _$PassengerReviewsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerReviewsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerReviewsDtoOutput> get serializer => _$PassengerReviewsDtoOutputSerializer();
}

class _$PassengerReviewsDtoOutputSerializer implements PrimitiveSerializer<PassengerReviewsDtoOutput> {
  @override
  final Iterable<Type> types = const [PassengerReviewsDtoOutput, _$PassengerReviewsDtoOutput];

  @override
  final String wireName = r'PassengerReviewsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerReviewsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pending';
    yield serializers.serialize(
      object.pending,
      specifiedType: const FullType(PassengerReviewsDtoOutputPending),
    );
    yield r'reviewed';
    yield serializers.serialize(
      object.reviewed,
      specifiedType: const FullType(PassengerReviewsDtoOutputReviewed),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PassengerReviewsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PassengerReviewsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pending':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PassengerReviewsDtoOutputPending),
          ) as PassengerReviewsDtoOutputPending;
          result.pending.replace(valueDes);
          break;
        case r'reviewed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PassengerReviewsDtoOutputReviewed),
          ) as PassengerReviewsDtoOutputReviewed;
          result.reviewed.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PassengerReviewsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerReviewsDtoOutputBuilder();
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


