//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/admin_payout_stats_dto_output_pending_review.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_payout_stats_dto_output.g.dart';

/// AdminPayoutStatsDtoOutput
///
/// Properties:
/// * [pendingReview] 
/// * [readyToTransfer] 
/// * [onHold] 
/// * [paidThisMonth] 
@BuiltValue()
abstract class AdminPayoutStatsDtoOutput implements Built<AdminPayoutStatsDtoOutput, AdminPayoutStatsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'pendingReview')
  AdminPayoutStatsDtoOutputPendingReview get pendingReview;

  @BuiltValueField(wireName: r'readyToTransfer')
  AdminPayoutStatsDtoOutputPendingReview get readyToTransfer;

  @BuiltValueField(wireName: r'onHold')
  AdminPayoutStatsDtoOutputPendingReview get onHold;

  @BuiltValueField(wireName: r'paidThisMonth')
  AdminPayoutStatsDtoOutputPendingReview get paidThisMonth;

  AdminPayoutStatsDtoOutput._();

  factory AdminPayoutStatsDtoOutput([void updates(AdminPayoutStatsDtoOutputBuilder b)]) = _$AdminPayoutStatsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPayoutStatsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPayoutStatsDtoOutput> get serializer => _$AdminPayoutStatsDtoOutputSerializer();
}

class _$AdminPayoutStatsDtoOutputSerializer implements PrimitiveSerializer<AdminPayoutStatsDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminPayoutStatsDtoOutput, _$AdminPayoutStatsDtoOutput];

  @override
  final String wireName = r'AdminPayoutStatsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPayoutStatsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pendingReview';
    yield serializers.serialize(
      object.pendingReview,
      specifiedType: const FullType(AdminPayoutStatsDtoOutputPendingReview),
    );
    yield r'readyToTransfer';
    yield serializers.serialize(
      object.readyToTransfer,
      specifiedType: const FullType(AdminPayoutStatsDtoOutputPendingReview),
    );
    yield r'onHold';
    yield serializers.serialize(
      object.onHold,
      specifiedType: const FullType(AdminPayoutStatsDtoOutputPendingReview),
    );
    yield r'paidThisMonth';
    yield serializers.serialize(
      object.paidThisMonth,
      specifiedType: const FullType(AdminPayoutStatsDtoOutputPendingReview),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPayoutStatsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPayoutStatsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pendingReview':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPayoutStatsDtoOutputPendingReview),
          ) as AdminPayoutStatsDtoOutputPendingReview;
          result.pendingReview.replace(valueDes);
          break;
        case r'readyToTransfer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPayoutStatsDtoOutputPendingReview),
          ) as AdminPayoutStatsDtoOutputPendingReview;
          result.readyToTransfer.replace(valueDes);
          break;
        case r'onHold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPayoutStatsDtoOutputPendingReview),
          ) as AdminPayoutStatsDtoOutputPendingReview;
          result.onHold.replace(valueDes);
          break;
        case r'paidThisMonth':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPayoutStatsDtoOutputPendingReview),
          ) as AdminPayoutStatsDtoOutputPendingReview;
          result.paidThisMonth.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPayoutStatsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPayoutStatsDtoOutputBuilder();
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


