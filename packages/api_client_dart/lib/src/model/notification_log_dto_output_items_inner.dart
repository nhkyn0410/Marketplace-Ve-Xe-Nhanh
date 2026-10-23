//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_log_dto_output_items_inner.g.dart';

/// NotificationLogDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [notificationId] 
/// * [kind] 
/// * [channel] 
/// * [recipientMasked] 
/// * [status] 
/// * [attempts] 
/// * [lastError] 
/// * [createdAt] 
/// * [sentAt] 
@BuiltValue()
abstract class NotificationLogDtoOutputItemsInner implements Built<NotificationLogDtoOutputItemsInner, NotificationLogDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'notificationId')
  String get notificationId;

  @BuiltValueField(wireName: r'kind')
  NotificationLogDtoOutputItemsInnerKindEnum get kind;
  // enum kindEnum {  BOOKING_CONFIRMED,  TICKETS_CANCELLED,  REFUND_SUCCEEDED,  TRIP_CHANGED,  TRIP_CANCELLED,  MANUAL_REFUND,  CASE_UPDATED,  OPERATIONS_ALERT,  LOYALTY_UPDATED,  PROMOTION,  };

  @BuiltValueField(wireName: r'channel')
  NotificationLogDtoOutputItemsInnerChannelEnum get channel;
  // enum channelEnum {  EMAIL,  PUSH,  SMS,  };

  @BuiltValueField(wireName: r'recipientMasked')
  String get recipientMasked;

  @BuiltValueField(wireName: r'status')
  NotificationLogDtoOutputItemsInnerStatusEnum get status;
  // enum statusEnum {  PENDING,  SENT,  FAILED,  SKIPPED,  };

  @BuiltValueField(wireName: r'attempts')
  int get attempts;

  @BuiltValueField(wireName: r'lastError')
  String? get lastError;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'sentAt')
  DateTime? get sentAt;

  NotificationLogDtoOutputItemsInner._();

  factory NotificationLogDtoOutputItemsInner([void updates(NotificationLogDtoOutputItemsInnerBuilder b)]) = _$NotificationLogDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationLogDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationLogDtoOutputItemsInner> get serializer => _$NotificationLogDtoOutputItemsInnerSerializer();
}

class _$NotificationLogDtoOutputItemsInnerSerializer implements PrimitiveSerializer<NotificationLogDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [NotificationLogDtoOutputItemsInner, _$NotificationLogDtoOutputItemsInner];

  @override
  final String wireName = r'NotificationLogDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationLogDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'notificationId';
    yield serializers.serialize(
      object.notificationId,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(NotificationLogDtoOutputItemsInnerKindEnum),
    );
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(NotificationLogDtoOutputItemsInnerChannelEnum),
    );
    yield r'recipientMasked';
    yield serializers.serialize(
      object.recipientMasked,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(NotificationLogDtoOutputItemsInnerStatusEnum),
    );
    yield r'attempts';
    yield serializers.serialize(
      object.attempts,
      specifiedType: const FullType(int),
    );
    yield r'lastError';
    yield object.lastError == null ? null : serializers.serialize(
      object.lastError,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'sentAt';
    yield object.sentAt == null ? null : serializers.serialize(
      object.sentAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationLogDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationLogDtoOutputItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'notificationId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notificationId = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NotificationLogDtoOutputItemsInnerKindEnum),
          ) as NotificationLogDtoOutputItemsInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NotificationLogDtoOutputItemsInnerChannelEnum),
          ) as NotificationLogDtoOutputItemsInnerChannelEnum;
          result.channel = valueDes;
          break;
        case r'recipientMasked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.recipientMasked = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NotificationLogDtoOutputItemsInnerStatusEnum),
          ) as NotificationLogDtoOutputItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'attempts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.attempts = valueDes;
          break;
        case r'lastError':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lastError = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'sentAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.sentAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationLogDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationLogDtoOutputItemsInnerBuilder();
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


class NotificationLogDtoOutputItemsInnerKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BOOKING_CONFIRMED')
  static const NotificationLogDtoOutputItemsInnerKindEnum BOOKING_CONFIRMED = _$notificationLogDtoOutputItemsInnerKindEnum_BOOKING_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'TICKETS_CANCELLED')
  static const NotificationLogDtoOutputItemsInnerKindEnum TICKETS_CANCELLED = _$notificationLogDtoOutputItemsInnerKindEnum_TICKETS_CANCELLED;
  @BuiltValueEnumConst(wireName: r'REFUND_SUCCEEDED')
  static const NotificationLogDtoOutputItemsInnerKindEnum REFUND_SUCCEEDED = _$notificationLogDtoOutputItemsInnerKindEnum_REFUND_SUCCEEDED;
  @BuiltValueEnumConst(wireName: r'TRIP_CHANGED')
  static const NotificationLogDtoOutputItemsInnerKindEnum TRIP_CHANGED = _$notificationLogDtoOutputItemsInnerKindEnum_TRIP_CHANGED;
  @BuiltValueEnumConst(wireName: r'TRIP_CANCELLED')
  static const NotificationLogDtoOutputItemsInnerKindEnum TRIP_CANCELLED = _$notificationLogDtoOutputItemsInnerKindEnum_TRIP_CANCELLED;
  @BuiltValueEnumConst(wireName: r'MANUAL_REFUND')
  static const NotificationLogDtoOutputItemsInnerKindEnum MANUAL_REFUND = _$notificationLogDtoOutputItemsInnerKindEnum_MANUAL_REFUND;
  @BuiltValueEnumConst(wireName: r'CASE_UPDATED')
  static const NotificationLogDtoOutputItemsInnerKindEnum CASE_UPDATED = _$notificationLogDtoOutputItemsInnerKindEnum_CASE_UPDATED;
  @BuiltValueEnumConst(wireName: r'OPERATIONS_ALERT')
  static const NotificationLogDtoOutputItemsInnerKindEnum OPERATIONS_ALERT = _$notificationLogDtoOutputItemsInnerKindEnum_OPERATIONS_ALERT;
  @BuiltValueEnumConst(wireName: r'LOYALTY_UPDATED')
  static const NotificationLogDtoOutputItemsInnerKindEnum LOYALTY_UPDATED = _$notificationLogDtoOutputItemsInnerKindEnum_LOYALTY_UPDATED;
  @BuiltValueEnumConst(wireName: r'PROMOTION')
  static const NotificationLogDtoOutputItemsInnerKindEnum PROMOTION = _$notificationLogDtoOutputItemsInnerKindEnum_PROMOTION;

  static Serializer<NotificationLogDtoOutputItemsInnerKindEnum> get serializer => _$notificationLogDtoOutputItemsInnerKindEnumSerializer;

  const NotificationLogDtoOutputItemsInnerKindEnum._(String name): super(name);

  static BuiltSet<NotificationLogDtoOutputItemsInnerKindEnum> get values => _$notificationLogDtoOutputItemsInnerKindEnumValues;
  static NotificationLogDtoOutputItemsInnerKindEnum valueOf(String name) => _$notificationLogDtoOutputItemsInnerKindEnumValueOf(name);
}

class NotificationLogDtoOutputItemsInnerChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'EMAIL')
  static const NotificationLogDtoOutputItemsInnerChannelEnum EMAIL = _$notificationLogDtoOutputItemsInnerChannelEnum_EMAIL;
  @BuiltValueEnumConst(wireName: r'PUSH')
  static const NotificationLogDtoOutputItemsInnerChannelEnum PUSH = _$notificationLogDtoOutputItemsInnerChannelEnum_PUSH;
  @BuiltValueEnumConst(wireName: r'SMS')
  static const NotificationLogDtoOutputItemsInnerChannelEnum SMS = _$notificationLogDtoOutputItemsInnerChannelEnum_SMS;

  static Serializer<NotificationLogDtoOutputItemsInnerChannelEnum> get serializer => _$notificationLogDtoOutputItemsInnerChannelEnumSerializer;

  const NotificationLogDtoOutputItemsInnerChannelEnum._(String name): super(name);

  static BuiltSet<NotificationLogDtoOutputItemsInnerChannelEnum> get values => _$notificationLogDtoOutputItemsInnerChannelEnumValues;
  static NotificationLogDtoOutputItemsInnerChannelEnum valueOf(String name) => _$notificationLogDtoOutputItemsInnerChannelEnumValueOf(name);
}

class NotificationLogDtoOutputItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const NotificationLogDtoOutputItemsInnerStatusEnum PENDING = _$notificationLogDtoOutputItemsInnerStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'SENT')
  static const NotificationLogDtoOutputItemsInnerStatusEnum SENT = _$notificationLogDtoOutputItemsInnerStatusEnum_SENT;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const NotificationLogDtoOutputItemsInnerStatusEnum FAILED = _$notificationLogDtoOutputItemsInnerStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'SKIPPED')
  static const NotificationLogDtoOutputItemsInnerStatusEnum SKIPPED = _$notificationLogDtoOutputItemsInnerStatusEnum_SKIPPED;

  static Serializer<NotificationLogDtoOutputItemsInnerStatusEnum> get serializer => _$notificationLogDtoOutputItemsInnerStatusEnumSerializer;

  const NotificationLogDtoOutputItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<NotificationLogDtoOutputItemsInnerStatusEnum> get values => _$notificationLogDtoOutputItemsInnerStatusEnumValues;
  static NotificationLogDtoOutputItemsInnerStatusEnum valueOf(String name) => _$notificationLogDtoOutputItemsInnerStatusEnumValueOf(name);
}

