//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_overview_dto_output_queues.g.dart';

/// AdminOverviewDtoOutputQueues
///
/// Properties:
/// * [payoutsPendingReview] 
/// * [refundsFailed] 
/// * [reconcileOpen] 
@BuiltValue()
abstract class AdminOverviewDtoOutputQueues implements Built<AdminOverviewDtoOutputQueues, AdminOverviewDtoOutputQueuesBuilder> {
  @BuiltValueField(wireName: r'payoutsPendingReview')
  int get payoutsPendingReview;

  @BuiltValueField(wireName: r'refundsFailed')
  int get refundsFailed;

  @BuiltValueField(wireName: r'reconcileOpen')
  int get reconcileOpen;

  AdminOverviewDtoOutputQueues._();

  factory AdminOverviewDtoOutputQueues([void updates(AdminOverviewDtoOutputQueuesBuilder b)]) = _$AdminOverviewDtoOutputQueues;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOverviewDtoOutputQueuesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOverviewDtoOutputQueues> get serializer => _$AdminOverviewDtoOutputQueuesSerializer();
}

class _$AdminOverviewDtoOutputQueuesSerializer implements PrimitiveSerializer<AdminOverviewDtoOutputQueues> {
  @override
  final Iterable<Type> types = const [AdminOverviewDtoOutputQueues, _$AdminOverviewDtoOutputQueues];

  @override
  final String wireName = r'AdminOverviewDtoOutputQueues';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOverviewDtoOutputQueues object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'payoutsPendingReview';
    yield serializers.serialize(
      object.payoutsPendingReview,
      specifiedType: const FullType(int),
    );
    yield r'refundsFailed';
    yield serializers.serialize(
      object.refundsFailed,
      specifiedType: const FullType(int),
    );
    yield r'reconcileOpen';
    yield serializers.serialize(
      object.reconcileOpen,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOverviewDtoOutputQueues object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOverviewDtoOutputQueuesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'payoutsPendingReview':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.payoutsPendingReview = valueDes;
          break;
        case r'refundsFailed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundsFailed = valueDes;
          break;
        case r'reconcileOpen':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.reconcileOpen = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOverviewDtoOutputQueues deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOverviewDtoOutputQueuesBuilder();
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


