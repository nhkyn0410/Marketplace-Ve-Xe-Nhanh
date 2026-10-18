//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_refund_detail_dto_output_histories_inner.g.dart';

/// AdminRefundDetailDtoOutputHistoriesInner
///
/// Properties:
/// * [fromStatus] 
/// * [toStatus] 
/// * [reason] 
/// * [actor] 
/// * [createdAt] 
@BuiltValue()
abstract class AdminRefundDetailDtoOutputHistoriesInner implements Built<AdminRefundDetailDtoOutputHistoriesInner, AdminRefundDetailDtoOutputHistoriesInnerBuilder> {
  @BuiltValueField(wireName: r'fromStatus')
  AdminRefundDetailDtoOutputHistoriesInnerFromStatusEnum? get fromStatus;
  // enum fromStatusEnum {  REQUESTED,  APPROVED,  PROCESSING,  SUCCESS,  FAILED,  REJECTED,  };

  @BuiltValueField(wireName: r'toStatus')
  AdminRefundDetailDtoOutputHistoriesInnerToStatusEnum get toStatus;
  // enum toStatusEnum {  REQUESTED,  APPROVED,  PROCESSING,  SUCCESS,  FAILED,  REJECTED,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'actor')
  String? get actor;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  AdminRefundDetailDtoOutputHistoriesInner._();

  factory AdminRefundDetailDtoOutputHistoriesInner([void updates(AdminRefundDetailDtoOutputHistoriesInnerBuilder b)]) = _$AdminRefundDetailDtoOutputHistoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRefundDetailDtoOutputHistoriesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRefundDetailDtoOutputHistoriesInner> get serializer => _$AdminRefundDetailDtoOutputHistoriesInnerSerializer();
}

class _$AdminRefundDetailDtoOutputHistoriesInnerSerializer implements PrimitiveSerializer<AdminRefundDetailDtoOutputHistoriesInner> {
  @override
  final Iterable<Type> types = const [AdminRefundDetailDtoOutputHistoriesInner, _$AdminRefundDetailDtoOutputHistoriesInner];

  @override
  final String wireName = r'AdminRefundDetailDtoOutputHistoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRefundDetailDtoOutputHistoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fromStatus';
    yield object.fromStatus == null ? null : serializers.serialize(
      object.fromStatus,
      specifiedType: const FullType.nullable(AdminRefundDetailDtoOutputHistoriesInnerFromStatusEnum),
    );
    yield r'toStatus';
    yield serializers.serialize(
      object.toStatus,
      specifiedType: const FullType(AdminRefundDetailDtoOutputHistoriesInnerToStatusEnum),
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
    AdminRefundDetailDtoOutputHistoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRefundDetailDtoOutputHistoriesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fromStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminRefundDetailDtoOutputHistoriesInnerFromStatusEnum),
          ) as AdminRefundDetailDtoOutputHistoriesInnerFromStatusEnum?;
          if (valueDes == null) continue;
          result.fromStatus = valueDes;
          break;
        case r'toStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminRefundDetailDtoOutputHistoriesInnerToStatusEnum),
          ) as AdminRefundDetailDtoOutputHistoriesInnerToStatusEnum;
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
  AdminRefundDetailDtoOutputHistoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRefundDetailDtoOutputHistoriesInnerBuilder();
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


class AdminRefundDetailDtoOutputHistoriesInnerFromStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUESTED')
  static const AdminRefundDetailDtoOutputHistoriesInnerFromStatusEnum REQUESTED = _$adminRefundDetailDtoOutputHistoriesInnerFromStatusEnum_REQUESTED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const AdminRefundDetailDtoOutputHistoriesInnerFromStatusEnum APPROVED = _$adminRefundDetailDtoOutputHistoriesInnerFromStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const AdminRefundDetailDtoOutputHistoriesInnerFromStatusEnum PROCESSING = _$adminRefundDetailDtoOutputHistoriesInnerFromStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const AdminRefundDetailDtoOutputHistoriesInnerFromStatusEnum SUCCESS = _$adminRefundDetailDtoOutputHistoriesInnerFromStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const AdminRefundDetailDtoOutputHistoriesInnerFromStatusEnum FAILED = _$adminRefundDetailDtoOutputHistoriesInnerFromStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const AdminRefundDetailDtoOutputHistoriesInnerFromStatusEnum REJECTED = _$adminRefundDetailDtoOutputHistoriesInnerFromStatusEnum_REJECTED;

  static Serializer<AdminRefundDetailDtoOutputHistoriesInnerFromStatusEnum> get serializer => _$adminRefundDetailDtoOutputHistoriesInnerFromStatusEnumSerializer;

  const AdminRefundDetailDtoOutputHistoriesInnerFromStatusEnum._(String name): super(name);

  static BuiltSet<AdminRefundDetailDtoOutputHistoriesInnerFromStatusEnum> get values => _$adminRefundDetailDtoOutputHistoriesInnerFromStatusEnumValues;
  static AdminRefundDetailDtoOutputHistoriesInnerFromStatusEnum valueOf(String name) => _$adminRefundDetailDtoOutputHistoriesInnerFromStatusEnumValueOf(name);
}

class AdminRefundDetailDtoOutputHistoriesInnerToStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUESTED')
  static const AdminRefundDetailDtoOutputHistoriesInnerToStatusEnum REQUESTED = _$adminRefundDetailDtoOutputHistoriesInnerToStatusEnum_REQUESTED;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const AdminRefundDetailDtoOutputHistoriesInnerToStatusEnum APPROVED = _$adminRefundDetailDtoOutputHistoriesInnerToStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const AdminRefundDetailDtoOutputHistoriesInnerToStatusEnum PROCESSING = _$adminRefundDetailDtoOutputHistoriesInnerToStatusEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const AdminRefundDetailDtoOutputHistoriesInnerToStatusEnum SUCCESS = _$adminRefundDetailDtoOutputHistoriesInnerToStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const AdminRefundDetailDtoOutputHistoriesInnerToStatusEnum FAILED = _$adminRefundDetailDtoOutputHistoriesInnerToStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const AdminRefundDetailDtoOutputHistoriesInnerToStatusEnum REJECTED = _$adminRefundDetailDtoOutputHistoriesInnerToStatusEnum_REJECTED;

  static Serializer<AdminRefundDetailDtoOutputHistoriesInnerToStatusEnum> get serializer => _$adminRefundDetailDtoOutputHistoriesInnerToStatusEnumSerializer;

  const AdminRefundDetailDtoOutputHistoriesInnerToStatusEnum._(String name): super(name);

  static BuiltSet<AdminRefundDetailDtoOutputHistoriesInnerToStatusEnum> get values => _$adminRefundDetailDtoOutputHistoriesInnerToStatusEnumValues;
  static AdminRefundDetailDtoOutputHistoriesInnerToStatusEnum valueOf(String name) => _$adminRefundDetailDtoOutputHistoriesInnerToStatusEnumValueOf(name);
}

