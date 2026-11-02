//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_operator_profile_dto_output_reviews_inner.g.dart';

/// PublicOperatorProfileDtoOutputReviewsInner
///
/// Properties:
/// * [reviewId] 
/// * [authorName] 
/// * [rating] 
/// * [comment] 
/// * [operatorReply] 
/// * [operatorRepliedAt] 
/// * [createdAt] 
@BuiltValue()
abstract class PublicOperatorProfileDtoOutputReviewsInner implements Built<PublicOperatorProfileDtoOutputReviewsInner, PublicOperatorProfileDtoOutputReviewsInnerBuilder> {
  @BuiltValueField(wireName: r'reviewId')
  String get reviewId;

  @BuiltValueField(wireName: r'authorName')
  String get authorName;

  @BuiltValueField(wireName: r'rating')
  int get rating;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  @BuiltValueField(wireName: r'operatorReply')
  String? get operatorReply;

  @BuiltValueField(wireName: r'operatorRepliedAt')
  DateTime? get operatorRepliedAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  PublicOperatorProfileDtoOutputReviewsInner._();

  factory PublicOperatorProfileDtoOutputReviewsInner([void updates(PublicOperatorProfileDtoOutputReviewsInnerBuilder b)]) = _$PublicOperatorProfileDtoOutputReviewsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicOperatorProfileDtoOutputReviewsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicOperatorProfileDtoOutputReviewsInner> get serializer => _$PublicOperatorProfileDtoOutputReviewsInnerSerializer();
}

class _$PublicOperatorProfileDtoOutputReviewsInnerSerializer implements PrimitiveSerializer<PublicOperatorProfileDtoOutputReviewsInner> {
  @override
  final Iterable<Type> types = const [PublicOperatorProfileDtoOutputReviewsInner, _$PublicOperatorProfileDtoOutputReviewsInner];

  @override
  final String wireName = r'PublicOperatorProfileDtoOutputReviewsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicOperatorProfileDtoOutputReviewsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reviewId';
    yield serializers.serialize(
      object.reviewId,
      specifiedType: const FullType(String),
    );
    yield r'authorName';
    yield serializers.serialize(
      object.authorName,
      specifiedType: const FullType(String),
    );
    yield r'rating';
    yield serializers.serialize(
      object.rating,
      specifiedType: const FullType(int),
    );
    yield r'comment';
    yield object.comment == null ? null : serializers.serialize(
      object.comment,
      specifiedType: const FullType.nullable(String),
    );
    yield r'operatorReply';
    yield object.operatorReply == null ? null : serializers.serialize(
      object.operatorReply,
      specifiedType: const FullType.nullable(String),
    );
    yield r'operatorRepliedAt';
    yield object.operatorRepliedAt == null ? null : serializers.serialize(
      object.operatorRepliedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicOperatorProfileDtoOutputReviewsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicOperatorProfileDtoOutputReviewsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reviewId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reviewId = valueDes;
          break;
        case r'authorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.authorName = valueDes;
          break;
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rating = valueDes;
          break;
        case r'comment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.comment = valueDes;
          break;
        case r'operatorReply':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.operatorReply = valueDes;
          break;
        case r'operatorRepliedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.operatorRepliedAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicOperatorProfileDtoOutputReviewsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicOperatorProfileDtoOutputReviewsInnerBuilder();
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


