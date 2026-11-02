//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/customer_review_dto_output_review.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_review_dto_output.g.dart';

/// CustomerReviewDtoOutput
///
/// Properties:
/// * [review] 
/// * [canReview] 
@BuiltValue()
abstract class CustomerReviewDtoOutput implements Built<CustomerReviewDtoOutput, CustomerReviewDtoOutputBuilder> {
  @BuiltValueField(wireName: r'review')
  CustomerReviewDtoOutputReview? get review;

  @BuiltValueField(wireName: r'canReview')
  bool get canReview;

  CustomerReviewDtoOutput._();

  factory CustomerReviewDtoOutput([void updates(CustomerReviewDtoOutputBuilder b)]) = _$CustomerReviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerReviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerReviewDtoOutput> get serializer => _$CustomerReviewDtoOutputSerializer();
}

class _$CustomerReviewDtoOutputSerializer implements PrimitiveSerializer<CustomerReviewDtoOutput> {
  @override
  final Iterable<Type> types = const [CustomerReviewDtoOutput, _$CustomerReviewDtoOutput];

  @override
  final String wireName = r'CustomerReviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerReviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'review';
    yield object.review == null ? null : serializers.serialize(
      object.review,
      specifiedType: const FullType.nullable(CustomerReviewDtoOutputReview),
    );
    yield r'canReview';
    yield serializers.serialize(
      object.canReview,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerReviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerReviewDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'review':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CustomerReviewDtoOutputReview),
          ) as CustomerReviewDtoOutputReview?;
          if (valueDes == null) continue;
          result.review.replace(valueDes);
          break;
        case r'canReview':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canReview = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerReviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerReviewDtoOutputBuilder();
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


