//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'review_page_dto_output_items_inner.g.dart';

/// ReviewPageDtoOutputItemsInner
///
/// Properties:
/// * [reviewId] 
/// * [bookingId] 
/// * [bookingCode] 
/// * [operatorId] 
/// * [operatorName] 
/// * [authorName] 
/// * [rating] 
/// * [comment] 
/// * [routeName] 
/// * [departureAt] 
/// * [status] 
/// * [operatorReply] 
/// * [operatorRepliedAt] 
/// * [operatorReportedAt] 
/// * [operatorReportReason] 
/// * [moderationReason] 
/// * [signals] 
/// * [createdAt] 
@BuiltValue()
abstract class ReviewPageDtoOutputItemsInner implements Built<ReviewPageDtoOutputItemsInner, ReviewPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'reviewId')
  String get reviewId;

  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'bookingCode')
  String get bookingCode;

  @BuiltValueField(wireName: r'operatorId')
  String get operatorId;

  @BuiltValueField(wireName: r'operatorName')
  String get operatorName;

  @BuiltValueField(wireName: r'authorName')
  String get authorName;

  @BuiltValueField(wireName: r'rating')
  int get rating;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  @BuiltValueField(wireName: r'routeName')
  String get routeName;

  @BuiltValueField(wireName: r'departureAt')
  DateTime get departureAt;

  @BuiltValueField(wireName: r'status')
  ReviewPageDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  VISIBLE,  HELD,  HIDDEN,  };

  @BuiltValueField(wireName: r'operatorReply')
  String? get operatorReply;

  @BuiltValueField(wireName: r'operatorRepliedAt')
  DateTime? get operatorRepliedAt;

  @BuiltValueField(wireName: r'operatorReportedAt')
  DateTime? get operatorReportedAt;

  @BuiltValueField(wireName: r'operatorReportReason')
  String? get operatorReportReason;

  @BuiltValueField(wireName: r'moderationReason')
  String? get moderationReason;

  @BuiltValueField(wireName: r'signals')
  BuiltList<ReviewPageDtoOutputItemsInnerSignalsEnum> get signals;
  // enum signalsEnum {  SPAM,  OPERATOR_REPORTED,  DISPUTED,  REPEATED,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  ReviewPageDtoOutputItemsInner._();

  factory ReviewPageDtoOutputItemsInner([void updates(ReviewPageDtoOutputItemsInnerBuilder b)]) = _$ReviewPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReviewPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReviewPageDtoOutputItemsInner> get serializer => _$ReviewPageDtoOutputItemsInnerSerializer();
}

class _$ReviewPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<ReviewPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [ReviewPageDtoOutputItemsInner, _$ReviewPageDtoOutputItemsInner];

  @override
  final String wireName = r'ReviewPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReviewPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reviewId';
    yield serializers.serialize(
      object.reviewId,
      specifiedType: const FullType(String),
    );
    yield r'bookingId';
    yield serializers.serialize(
      object.bookingId,
      specifiedType: const FullType(String),
    );
    yield r'bookingCode';
    yield serializers.serialize(
      object.bookingCode,
      specifiedType: const FullType(String),
    );
    yield r'operatorId';
    yield serializers.serialize(
      object.operatorId,
      specifiedType: const FullType(String),
    );
    yield r'operatorName';
    yield serializers.serialize(
      object.operatorName,
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
    yield r'routeName';
    yield serializers.serialize(
      object.routeName,
      specifiedType: const FullType(String),
    );
    yield r'departureAt';
    yield serializers.serialize(
      object.departureAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ReviewPageDtoOutputItemsInnerStatusEnum),
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
    yield r'operatorReportedAt';
    yield object.operatorReportedAt == null ? null : serializers.serialize(
      object.operatorReportedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'operatorReportReason';
    yield object.operatorReportReason == null ? null : serializers.serialize(
      object.operatorReportReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'moderationReason';
    yield object.moderationReason == null ? null : serializers.serialize(
      object.moderationReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'signals';
    yield serializers.serialize(
      object.signals,
      specifiedType: const FullType(BuiltList, [FullType(ReviewPageDtoOutputItemsInnerSignalsEnum)]),
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
    ReviewPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReviewPageDtoOutputItemsInnerBuilder result,
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
        case r'bookingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingId = valueDes;
          break;
        case r'bookingCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingCode = valueDes;
          break;
        case r'operatorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorId = valueDes;
          break;
        case r'operatorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.operatorName = valueDes;
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
        case r'routeName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.routeName = valueDes;
          break;
        case r'departureAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.departureAt = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReviewPageDtoOutputItemsInnerStatusEnum),
          ) as ReviewPageDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
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
        case r'operatorReportedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.operatorReportedAt = valueDes;
          break;
        case r'operatorReportReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.operatorReportReason = valueDes;
          break;
        case r'moderationReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.moderationReason = valueDes;
          break;
        case r'signals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ReviewPageDtoOutputItemsInnerSignalsEnum)]),
          ) as BuiltList<ReviewPageDtoOutputItemsInnerSignalsEnum>;
          result.signals.replace(valueDes);
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
  ReviewPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReviewPageDtoOutputItemsInnerBuilder();
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


class ReviewPageDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VISIBLE')
  static const ReviewPageDtoOutputItemsInnerStatusEnum VISIBLE = _$reviewPageDtoOutputItemsInnerStatusEnum_VISIBLE;
  @BuiltValueEnumConst(wireName: r'HELD')
  static const ReviewPageDtoOutputItemsInnerStatusEnum HELD = _$reviewPageDtoOutputItemsInnerStatusEnum_HELD;
  @BuiltValueEnumConst(wireName: r'HIDDEN')
  static const ReviewPageDtoOutputItemsInnerStatusEnum HIDDEN = _$reviewPageDtoOutputItemsInnerStatusEnum_HIDDEN;

  static Serializer<ReviewPageDtoOutputItemsInnerStatusEnum> get serializer => _$reviewPageDtoOutputItemsInnerStatusEnumSerializer;

  const ReviewPageDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<ReviewPageDtoOutputItemsInnerStatusEnum> get values => _$reviewPageDtoOutputItemsInnerStatusEnumValues;
  static ReviewPageDtoOutputItemsInnerStatusEnum valueOf(String name) => _$reviewPageDtoOutputItemsInnerStatusEnumValueOf(name);
}

class ReviewPageDtoOutputItemsInnerSignalsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SPAM')
  static const ReviewPageDtoOutputItemsInnerSignalsEnum SPAM = _$reviewPageDtoOutputItemsInnerSignalsEnum_SPAM;
  @BuiltValueEnumConst(wireName: r'OPERATOR_REPORTED')
  static const ReviewPageDtoOutputItemsInnerSignalsEnum OPERATOR_REPORTED = _$reviewPageDtoOutputItemsInnerSignalsEnum_OPERATOR_REPORTED;
  @BuiltValueEnumConst(wireName: r'DISPUTED')
  static const ReviewPageDtoOutputItemsInnerSignalsEnum DISPUTED = _$reviewPageDtoOutputItemsInnerSignalsEnum_DISPUTED;
  @BuiltValueEnumConst(wireName: r'REPEATED')
  static const ReviewPageDtoOutputItemsInnerSignalsEnum REPEATED = _$reviewPageDtoOutputItemsInnerSignalsEnum_REPEATED;

  static Serializer<ReviewPageDtoOutputItemsInnerSignalsEnum> get serializer => _$reviewPageDtoOutputItemsInnerSignalsEnumSerializer;

  const ReviewPageDtoOutputItemsInnerSignalsEnum._(String name): super(name);

  static BuiltSet<ReviewPageDtoOutputItemsInnerSignalsEnum> get values => _$reviewPageDtoOutputItemsInnerSignalsEnumValues;
  static ReviewPageDtoOutputItemsInnerSignalsEnum valueOf(String name) => _$reviewPageDtoOutputItemsInnerSignalsEnumValueOf(name);
}

