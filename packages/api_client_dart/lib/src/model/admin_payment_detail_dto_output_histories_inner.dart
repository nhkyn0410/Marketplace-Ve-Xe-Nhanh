//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_payment_detail_dto_output_histories_inner.g.dart';

/// AdminPaymentDetailDtoOutputHistoriesInner
///
/// Properties:
/// * [fromStatus] 
/// * [toStatus] 
/// * [reason] 
/// * [actor] 
/// * [createdAt] 
@BuiltValue()
abstract class AdminPaymentDetailDtoOutputHistoriesInner implements Built<AdminPaymentDetailDtoOutputHistoriesInner, AdminPaymentDetailDtoOutputHistoriesInnerBuilder> {
  @BuiltValueField(wireName: r'fromStatus')
  AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum? get fromStatus;
  // enum fromStatusEnum {  INITIATED,  PROCESSING,  SUCCESS,  FAILED,  EXPIRED,  CANCELLED,  RECONCILING,  };

  @BuiltValueField(wireName: r'toStatus')
  AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum get toStatus;
  // enum toStatusEnum {  INITIATED,  PROCESSING,  SUCCESS,  FAILED,  EXPIRED,  CANCELLED,  RECONCILING,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'actor')
  String? get actor;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  AdminPaymentDetailDtoOutputHistoriesInner._();

  factory AdminPaymentDetailDtoOutputHistoriesInner([void updates(AdminPaymentDetailDtoOutputHistoriesInnerBuilder b)]) = _$AdminPaymentDetailDtoOutputHistoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPaymentDetailDtoOutputHistoriesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPaymentDetailDtoOutputHistoriesInner> get serializer => _$AdminPaymentDetailDtoOutputHistoriesInnerSerializer();
}

class _$AdminPaymentDetailDtoOutputHistoriesInnerSerializer implements PrimitiveSerializer<AdminPaymentDetailDtoOutputHistoriesInner> {
  @override
  final Iterable<Type> types = const [AdminPaymentDetailDtoOutputHistoriesInner, _$AdminPaymentDetailDtoOutputHistoriesInner];

  @override
  final String wireName = r'AdminPaymentDetailDtoOutputHistoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPaymentDetailDtoOutputHistoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fromStatus';
    yield object.fromStatus == null ? null : serializers.serialize(
      object.fromStatus,
      specifiedType: const FullType.nullable(AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum),
    );
    yield r'toStatus';
    yield serializers.serialize(
      object.toStatus,
      specifiedType: const FullType(AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'actor';
    yield object.actor == null ? null : serializers.serialize(
      object.actor,
      specifiedType: const FullType.nullable(String),
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
    AdminPaymentDetailDtoOutputHistoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminPaymentDetailDtoOutputHistoriesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fromStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum),
          ) as AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum?;
          if (valueDes == null) continue;
          result.fromStatus = valueDes;
          break;
        case r'toStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum),
          ) as AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum;
          result.toStatus = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'actor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.actor = valueDes;
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
  AdminPaymentDetailDtoOutputHistoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPaymentDetailDtoOutputHistoriesInnerBuilder();
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


class AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INITIATED')
  static const AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum INITIATED = _$adminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum_INITIATED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum PROCESSING = _$adminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum SUCCESS = _$adminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum FAILED = _$adminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum EXPIRED = _$adminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum CANCELLED = _$adminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'RECONCILING')
  static const AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum RECONCILING = _$adminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum_RECONCILING;

  static Serializer<AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum> get serializer => _$adminPaymentDetailDtoOutputHistoriesInnerFromStatusEnumSerializer;

  const AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum._(String name): super(name);

  static BuiltSet<AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum> get values => _$adminPaymentDetailDtoOutputHistoriesInnerFromStatusEnumValues;
  static AdminPaymentDetailDtoOutputHistoriesInnerFromStatusEnum valueOf(String name) => _$adminPaymentDetailDtoOutputHistoriesInnerFromStatusEnumValueOf(name);
}

class AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INITIATED')
  static const AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum INITIATED = _$adminPaymentDetailDtoOutputHistoriesInnerToStatusEnum_INITIATED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum PROCESSING = _$adminPaymentDetailDtoOutputHistoriesInnerToStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum SUCCESS = _$adminPaymentDetailDtoOutputHistoriesInnerToStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum FAILED = _$adminPaymentDetailDtoOutputHistoriesInnerToStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum EXPIRED = _$adminPaymentDetailDtoOutputHistoriesInnerToStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum CANCELLED = _$adminPaymentDetailDtoOutputHistoriesInnerToStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'RECONCILING')
  static const AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum RECONCILING = _$adminPaymentDetailDtoOutputHistoriesInnerToStatusEnum_RECONCILING;

  static Serializer<AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum> get serializer => _$adminPaymentDetailDtoOutputHistoriesInnerToStatusEnumSerializer;

  const AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum._(String name): super(name);

  static BuiltSet<AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum> get values => _$adminPaymentDetailDtoOutputHistoriesInnerToStatusEnumValues;
  static AdminPaymentDetailDtoOutputHistoriesInnerToStatusEnum valueOf(String name) => _$adminPaymentDetailDtoOutputHistoriesInnerToStatusEnumValueOf(name);
}

