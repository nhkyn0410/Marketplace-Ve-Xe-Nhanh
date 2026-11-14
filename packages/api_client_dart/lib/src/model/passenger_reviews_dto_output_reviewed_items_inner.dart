//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'passenger_reviews_dto_output_reviewed_items_inner.g.dart';

/// PassengerReviewsDtoOutputReviewedItemsInner
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
/// * [createdAt] 
@BuiltValue()
abstract class PassengerReviewsDtoOutputReviewedItemsInner implements Built<PassengerReviewsDtoOutputReviewedItemsInner, PassengerReviewsDtoOutputReviewedItemsInnerBuilder> {
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
  PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum get status;
  // enum statusEnum {  VISIBLE,  HELD,  HIDDEN,  };

  @BuiltValueField(wireName: r'operatorReply')
  String? get operatorReply;

  @BuiltValueField(wireName: r'operatorRepliedAt')
  DateTime? get operatorRepliedAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  PassengerReviewsDtoOutputReviewedItemsInner._();

  factory PassengerReviewsDtoOutputReviewedItemsInner([void updates(PassengerReviewsDtoOutputReviewedItemsInnerBuilder b)]) = _$PassengerReviewsDtoOutputReviewedItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PassengerReviewsDtoOutputReviewedItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PassengerReviewsDtoOutputReviewedItemsInner> get serializer => _$PassengerReviewsDtoOutputReviewedItemsInnerSerializer();
}

class _$PassengerReviewsDtoOutputReviewedItemsInnerSerializer implements PrimitiveSerializer<PassengerReviewsDtoOutputReviewedItemsInner> {
  @override
  final Iterable<Type> types = const [PassengerReviewsDtoOutputReviewedItemsInner, _$PassengerReviewsDtoOutputReviewedItemsInner];

  @override
  final String wireName = r'PassengerReviewsDtoOutputReviewedItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PassengerReviewsDtoOutputReviewedItemsInner object, {
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
      specifiedType: const FullType(PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum),
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
    PassengerReviewsDtoOutputReviewedItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PassengerReviewsDtoOutputReviewedItemsInnerBuilder result,
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
            specifiedType: const FullType(PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum),
          ) as PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum;
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
  PassengerReviewsDtoOutputReviewedItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PassengerReviewsDtoOutputReviewedItemsInnerBuilder();
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


class PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VISIBLE')
  static const PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum VISIBLE = _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnum_VISIBLE;
  @BuiltValueEnumConst(wireName: r'HELD')
  static const PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum HELD = _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnum_HELD;
  @BuiltValueEnumConst(wireName: r'HIDDEN')
  static const PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum HIDDEN = _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnum_HIDDEN;

  static Serializer<PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum> get serializer => _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnumSerializer;

  const PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum> get values => _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnumValues;
  static PassengerReviewsDtoOutputReviewedItemsInnerStatusEnum valueOf(String name) => _$passengerReviewsDtoOutputReviewedItemsInnerStatusEnumValueOf(name);
}

