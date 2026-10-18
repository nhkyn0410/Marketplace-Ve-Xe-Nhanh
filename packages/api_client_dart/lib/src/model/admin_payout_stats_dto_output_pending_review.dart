//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_payout_stats_dto_output_pending_review.g.dart';

/// AdminPayoutStatsDtoOutputPendingReview
///
/// Properties:
/// * [count] 
/// * [amount] 
@BuiltValue()
abstract class AdminPayoutStatsDtoOutputPendingReview implements Built<AdminPayoutStatsDtoOutputPendingReview, AdminPayoutStatsDtoOutputPendingReviewBuilder> {
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'amount')
  int get amount;

  AdminPayoutStatsDtoOutputPendingReview._();

  factory AdminPayoutStatsDtoOutputPendingReview([void updates(AdminPayoutStatsDtoOutputPendingReviewBuilder b)]) = _$AdminPayoutStatsDtoOutputPendingReview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPayoutStatsDtoOutputPendingReviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPayoutStatsDtoOutputPendingReview> get serializer => _$AdminPayoutStatsDtoOutputPendingReviewSerializer();
}

class _$AdminPayoutStatsDtoOutputPendingReviewSerializer implements PrimitiveSerializer<AdminPayoutStatsDtoOutputPendingReview> {
  @override
  final Iterable<Type> types = const [AdminPayoutStatsDtoOutputPendingReview, _$AdminPayoutStatsDtoOutputPendingReview];

  @override
  final String wireName = r'AdminPayoutStatsDtoOutputPendingReview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPayoutStatsDtoOutputPendingReview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPayoutStatsDtoOutputPendingReview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPayoutStatsDtoOutputPendingReviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPayoutStatsDtoOutputPendingReview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPayoutStatsDtoOutputPendingReviewBuilder();
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


