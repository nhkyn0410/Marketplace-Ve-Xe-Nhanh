//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_review_dto_output_review.g.dart';

/// CustomerReviewDtoOutputReview
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
abstract class CustomerReviewDtoOutputReview implements Built<CustomerReviewDtoOutputReview, CustomerReviewDtoOutputReviewBuilder> {
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
  CustomerReviewDtoOutputReviewStatusEnum get status;
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
  BuiltList<CustomerReviewDtoOutputReviewSignalsEnum> get signals;
  // enum signalsEnum {  SPAM,  OPERATOR_REPORTED,  DISPUTED,  REPEATED,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  CustomerReviewDtoOutputReview._();

  factory CustomerReviewDtoOutputReview([void updates(CustomerReviewDtoOutputReviewBuilder b)]) = _$CustomerReviewDtoOutputReview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerReviewDtoOutputReviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerReviewDtoOutputReview> get serializer => _$CustomerReviewDtoOutputReviewSerializer();
}

class _$CustomerReviewDtoOutputReviewSerializer implements PrimitiveSerializer<CustomerReviewDtoOutputReview> {
  @override
  final Iterable<Type> types = const [CustomerReviewDtoOutputReview, _$CustomerReviewDtoOutputReview];

  @override
  final String wireName = r'CustomerReviewDtoOutputReview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerReviewDtoOutputReview object, {
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
      specifiedType: const FullType(CustomerReviewDtoOutputReviewStatusEnum),
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
      specifiedType: const FullType(BuiltList, [FullType(CustomerReviewDtoOutputReviewSignalsEnum)]),
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
    CustomerReviewDtoOutputReview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerReviewDtoOutputReviewBuilder result,
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
            specifiedType: const FullType(CustomerReviewDtoOutputReviewStatusEnum),
          ) as CustomerReviewDtoOutputReviewStatusEnum;
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
            specifiedType: const FullType(BuiltList, [FullType(CustomerReviewDtoOutputReviewSignalsEnum)]),
          ) as BuiltList<CustomerReviewDtoOutputReviewSignalsEnum>;
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
  CustomerReviewDtoOutputReview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerReviewDtoOutputReviewBuilder();
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


class CustomerReviewDtoOutputReviewStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VISIBLE')
  static const CustomerReviewDtoOutputReviewStatusEnum VISIBLE = _$customerReviewDtoOutputReviewStatusEnum_VISIBLE;
  @BuiltValueEnumConst(wireName: r'HELD')
  static const CustomerReviewDtoOutputReviewStatusEnum HELD = _$customerReviewDtoOutputReviewStatusEnum_HELD;
  @BuiltValueEnumConst(wireName: r'HIDDEN')
  static const CustomerReviewDtoOutputReviewStatusEnum HIDDEN = _$customerReviewDtoOutputReviewStatusEnum_HIDDEN;

  static Serializer<CustomerReviewDtoOutputReviewStatusEnum> get serializer => _$customerReviewDtoOutputReviewStatusEnumSerializer;

  const CustomerReviewDtoOutputReviewStatusEnum._(String name): super(name);

  static BuiltSet<CustomerReviewDtoOutputReviewStatusEnum> get values => _$customerReviewDtoOutputReviewStatusEnumValues;
  static CustomerReviewDtoOutputReviewStatusEnum valueOf(String name) => _$customerReviewDtoOutputReviewStatusEnumValueOf(name);
}

class CustomerReviewDtoOutputReviewSignalsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SPAM')
  static const CustomerReviewDtoOutputReviewSignalsEnum SPAM = _$customerReviewDtoOutputReviewSignalsEnum_SPAM;
  @BuiltValueEnumConst(wireName: r'OPERATOR_REPORTED')
  static const CustomerReviewDtoOutputReviewSignalsEnum OPERATOR_REPORTED = _$customerReviewDtoOutputReviewSignalsEnum_OPERATOR_REPORTED;
  @BuiltValueEnumConst(wireName: r'DISPUTED')
  static const CustomerReviewDtoOutputReviewSignalsEnum DISPUTED = _$customerReviewDtoOutputReviewSignalsEnum_DISPUTED;
  @BuiltValueEnumConst(wireName: r'REPEATED')
  static const CustomerReviewDtoOutputReviewSignalsEnum REPEATED = _$customerReviewDtoOutputReviewSignalsEnum_REPEATED;

  static Serializer<CustomerReviewDtoOutputReviewSignalsEnum> get serializer => _$customerReviewDtoOutputReviewSignalsEnumSerializer;

  const CustomerReviewDtoOutputReviewSignalsEnum._(String name): super(name);

  static BuiltSet<CustomerReviewDtoOutputReviewSignalsEnum> get values => _$customerReviewDtoOutputReviewSignalsEnumValues;
  static CustomerReviewDtoOutputReviewSignalsEnum valueOf(String name) => _$customerReviewDtoOutputReviewSignalsEnumValueOf(name);
}

