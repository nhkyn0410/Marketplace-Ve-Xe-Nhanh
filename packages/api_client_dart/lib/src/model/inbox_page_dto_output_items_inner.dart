//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inbox_page_dto_output_items_inner.g.dart';

/// InboxPageDtoOutputItemsInner
///
/// Properties:
/// * [id] 
/// * [kind] 
/// * [title] 
/// * [body] 
/// * [linkType] 
/// * [linkTarget] 
/// * [createdAt] 
/// * [readAt] 
@BuiltValue()
abstract class InboxPageDtoOutputItemsInner implements Built<InboxPageDtoOutputItemsInner, InboxPageDtoOutputItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  InboxPageDtoOutputItemsInnerKindEnum get kind;
  // enum kindEnum {  BOOKING_CONFIRMED,  TICKETS_CANCELLED,  REFUND_SUCCEEDED,  TRIP_CHANGED,  TRIP_CANCELLED,  MANUAL_REFUND,  CASE_UPDATED,  OPERATIONS_ALERT,  LOYALTY_UPDATED,  PROMOTION,  SERVICE_NOTICE,  NEWS,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'body')
  String get body;

  @BuiltValueField(wireName: r'linkType')
  InboxPageDtoOutputItemsInnerLinkTypeEnum? get linkType;
  // enum linkTypeEnum {  PROMOTION,  ARTICLE,  BOOKING,  };

  @BuiltValueField(wireName: r'linkTarget')
  String? get linkTarget;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'readAt')
  DateTime? get readAt;

  InboxPageDtoOutputItemsInner._();

  factory InboxPageDtoOutputItemsInner([void updates(InboxPageDtoOutputItemsInnerBuilder b)]) = _$InboxPageDtoOutputItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InboxPageDtoOutputItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InboxPageDtoOutputItemsInner> get serializer => _$InboxPageDtoOutputItemsInnerSerializer();
}

class _$InboxPageDtoOutputItemsInnerSerializer implements PrimitiveSerializer<InboxPageDtoOutputItemsInner> {
  @override
  final Iterable<Type> types = const [InboxPageDtoOutputItemsInner, _$InboxPageDtoOutputItemsInner];

  @override
  final String wireName = r'InboxPageDtoOutputItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InboxPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(InboxPageDtoOutputItemsInnerKindEnum),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
    yield r'linkType';
    yield object.linkType == null ? null : serializers.serialize(
      object.linkType,
      specifiedType: const FullType.nullable(InboxPageDtoOutputItemsInnerLinkTypeEnum),
    );
    yield r'linkTarget';
    yield object.linkTarget == null ? null : serializers.serialize(
      object.linkTarget,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'readAt';
    yield object.readAt == null ? null : serializers.serialize(
      object.readAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InboxPageDtoOutputItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InboxPageDtoOutputItemsInnerBuilder result,
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InboxPageDtoOutputItemsInnerKindEnum),
          ) as InboxPageDtoOutputItemsInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.body = valueDes;
          break;
        case r'linkType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(InboxPageDtoOutputItemsInnerLinkTypeEnum),
          ) as InboxPageDtoOutputItemsInnerLinkTypeEnum?;
          if (valueDes == null) continue;
          result.linkType = valueDes;
          break;
        case r'linkTarget':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.linkTarget = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'readAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.readAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InboxPageDtoOutputItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InboxPageDtoOutputItemsInnerBuilder();
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


class InboxPageDtoOutputItemsInnerKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BOOKING_CONFIRMED')
  static const InboxPageDtoOutputItemsInnerKindEnum BOOKING_CONFIRMED = _$inboxPageDtoOutputItemsInnerKindEnum_BOOKING_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'TICKETS_CANCELLED')
  static const InboxPageDtoOutputItemsInnerKindEnum TICKETS_CANCELLED = _$inboxPageDtoOutputItemsInnerKindEnum_TICKETS_CANCELLED;
  @BuiltValueEnumConst(wireName: r'REFUND_SUCCEEDED')
  static const InboxPageDtoOutputItemsInnerKindEnum REFUND_SUCCEEDED = _$inboxPageDtoOutputItemsInnerKindEnum_REFUND_SUCCEEDED;
  @BuiltValueEnumConst(wireName: r'TRIP_CHANGED')
  static const InboxPageDtoOutputItemsInnerKindEnum TRIP_CHANGED = _$inboxPageDtoOutputItemsInnerKindEnum_TRIP_CHANGED;
  @BuiltValueEnumConst(wireName: r'TRIP_CANCELLED')
  static const InboxPageDtoOutputItemsInnerKindEnum TRIP_CANCELLED = _$inboxPageDtoOutputItemsInnerKindEnum_TRIP_CANCELLED;
  @BuiltValueEnumConst(wireName: r'MANUAL_REFUND')
  static const InboxPageDtoOutputItemsInnerKindEnum MANUAL_REFUND = _$inboxPageDtoOutputItemsInnerKindEnum_MANUAL_REFUND;
  @BuiltValueEnumConst(wireName: r'CASE_UPDATED')
  static const InboxPageDtoOutputItemsInnerKindEnum CASE_UPDATED = _$inboxPageDtoOutputItemsInnerKindEnum_CASE_UPDATED;
  @BuiltValueEnumConst(wireName: r'OPERATIONS_ALERT')
  static const InboxPageDtoOutputItemsInnerKindEnum OPERATIONS_ALERT = _$inboxPageDtoOutputItemsInnerKindEnum_OPERATIONS_ALERT;
  @BuiltValueEnumConst(wireName: r'LOYALTY_UPDATED')
  static const InboxPageDtoOutputItemsInnerKindEnum LOYALTY_UPDATED = _$inboxPageDtoOutputItemsInnerKindEnum_LOYALTY_UPDATED;
  @BuiltValueEnumConst(wireName: r'PROMOTION')
  static const InboxPageDtoOutputItemsInnerKindEnum PROMOTION = _$inboxPageDtoOutputItemsInnerKindEnum_PROMOTION;
  @BuiltValueEnumConst(wireName: r'SERVICE_NOTICE')
  static const InboxPageDtoOutputItemsInnerKindEnum SERVICE_NOTICE = _$inboxPageDtoOutputItemsInnerKindEnum_SERVICE_NOTICE;
  @BuiltValueEnumConst(wireName: r'NEWS')
  static const InboxPageDtoOutputItemsInnerKindEnum NEWS = _$inboxPageDtoOutputItemsInnerKindEnum_NEWS;

  static Serializer<InboxPageDtoOutputItemsInnerKindEnum> get serializer => _$inboxPageDtoOutputItemsInnerKindEnumSerializer;

  const InboxPageDtoOutputItemsInnerKindEnum._(String name): super(name);

  static BuiltSet<InboxPageDtoOutputItemsInnerKindEnum> get values => _$inboxPageDtoOutputItemsInnerKindEnumValues;
  static InboxPageDtoOutputItemsInnerKindEnum valueOf(String name) => _$inboxPageDtoOutputItemsInnerKindEnumValueOf(name);
}

class InboxPageDtoOutputItemsInnerLinkTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PROMOTION')
  static const InboxPageDtoOutputItemsInnerLinkTypeEnum PROMOTION = _$inboxPageDtoOutputItemsInnerLinkTypeEnum_PROMOTION;
  @BuiltValueEnumConst(wireName: r'ARTICLE')
  static const InboxPageDtoOutputItemsInnerLinkTypeEnum ARTICLE = _$inboxPageDtoOutputItemsInnerLinkTypeEnum_ARTICLE;
  @BuiltValueEnumConst(wireName: r'BOOKING')
  static const InboxPageDtoOutputItemsInnerLinkTypeEnum BOOKING = _$inboxPageDtoOutputItemsInnerLinkTypeEnum_BOOKING;

  static Serializer<InboxPageDtoOutputItemsInnerLinkTypeEnum> get serializer => _$inboxPageDtoOutputItemsInnerLinkTypeEnumSerializer;

  const InboxPageDtoOutputItemsInnerLinkTypeEnum._(String name): super(name);

  static BuiltSet<InboxPageDtoOutputItemsInnerLinkTypeEnum> get values => _$inboxPageDtoOutputItemsInnerLinkTypeEnumValues;
  static InboxPageDtoOutputItemsInnerLinkTypeEnum valueOf(String name) => _$inboxPageDtoOutputItemsInnerLinkTypeEnumValueOf(name);
}

