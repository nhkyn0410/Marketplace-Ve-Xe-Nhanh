//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client_dart/src/model/ticket_detail_dto_output_messages_inner_attachments_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ticket_detail_dto_output_messages_inner.g.dart';

/// TicketDetailDtoOutputMessagesInner
///
/// Properties:
/// * [messageId] 
/// * [party] 
/// * [authorName] 
/// * [body] 
/// * [createdAt] 
/// * [attachments] 
@BuiltValue()
abstract class TicketDetailDtoOutputMessagesInner implements Built<TicketDetailDtoOutputMessagesInner, TicketDetailDtoOutputMessagesInnerBuilder> {
  @BuiltValueField(wireName: r'messageId')
  String get messageId;

  @BuiltValueField(wireName: r'party')
  TicketDetailDtoOutputMessagesInnerPartyEnum get party;
  // enum partyEnum {  PASSENGER,  GUEST,  OPERATOR,  PLATFORM,  SYSTEM,  };

  @BuiltValueField(wireName: r'authorName')
  String get authorName;

  @BuiltValueField(wireName: r'body')
  String get body;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'attachments')
  BuiltList<TicketDetailDtoOutputMessagesInnerAttachmentsInner> get attachments;

  TicketDetailDtoOutputMessagesInner._();

  factory TicketDetailDtoOutputMessagesInner([void updates(TicketDetailDtoOutputMessagesInnerBuilder b)]) = _$TicketDetailDtoOutputMessagesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TicketDetailDtoOutputMessagesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TicketDetailDtoOutputMessagesInner> get serializer => _$TicketDetailDtoOutputMessagesInnerSerializer();
}

class _$TicketDetailDtoOutputMessagesInnerSerializer implements PrimitiveSerializer<TicketDetailDtoOutputMessagesInner> {
  @override
  final Iterable<Type> types = const [TicketDetailDtoOutputMessagesInner, _$TicketDetailDtoOutputMessagesInner];

  @override
  final String wireName = r'TicketDetailDtoOutputMessagesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TicketDetailDtoOutputMessagesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'messageId';
    yield serializers.serialize(
      object.messageId,
      specifiedType: const FullType(String),
    );
    yield r'party';
    yield serializers.serialize(
      object.party,
      specifiedType: const FullType(TicketDetailDtoOutputMessagesInnerPartyEnum),
    );
    yield r'authorName';
    yield serializers.serialize(
      object.authorName,
      specifiedType: const FullType(String),
    );
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'attachments';
    yield serializers.serialize(
      object.attachments,
      specifiedType: const FullType(BuiltList, [FullType(TicketDetailDtoOutputMessagesInnerAttachmentsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TicketDetailDtoOutputMessagesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TicketDetailDtoOutputMessagesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'messageId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.messageId = valueDes;
          break;
        case r'party':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TicketDetailDtoOutputMessagesInnerPartyEnum),
          ) as TicketDetailDtoOutputMessagesInnerPartyEnum;
          result.party = valueDes;
          break;
        case r'authorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.authorName = valueDes;
          break;
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.body = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'attachments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TicketDetailDtoOutputMessagesInnerAttachmentsInner)]),
          ) as BuiltList<TicketDetailDtoOutputMessagesInnerAttachmentsInner>;
          result.attachments.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TicketDetailDtoOutputMessagesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TicketDetailDtoOutputMessagesInnerBuilder();
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


class TicketDetailDtoOutputMessagesInnerPartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PASSENGER')
  static const TicketDetailDtoOutputMessagesInnerPartyEnum PASSENGER = _$ticketDetailDtoOutputMessagesInnerPartyEnum_PASSENGER;
  @BuiltValueEnumConst(wireName: r'GUEST')
  static const TicketDetailDtoOutputMessagesInnerPartyEnum GUEST = _$ticketDetailDtoOutputMessagesInnerPartyEnum_GUEST;
  @BuiltValueEnumConst(wireName: r'OPERATOR')
  static const TicketDetailDtoOutputMessagesInnerPartyEnum OPERATOR = _$ticketDetailDtoOutputMessagesInnerPartyEnum_OPERATOR;
  @BuiltValueEnumConst(wireName: r'PLATFORM')
  static const TicketDetailDtoOutputMessagesInnerPartyEnum PLATFORM = _$ticketDetailDtoOutputMessagesInnerPartyEnum_PLATFORM;
  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const TicketDetailDtoOutputMessagesInnerPartyEnum SYSTEM = _$ticketDetailDtoOutputMessagesInnerPartyEnum_SYSTEM;

  static Serializer<TicketDetailDtoOutputMessagesInnerPartyEnum> get serializer => _$ticketDetailDtoOutputMessagesInnerPartyEnumSerializer;

  const TicketDetailDtoOutputMessagesInnerPartyEnum._(String name): super(name);

  static BuiltSet<TicketDetailDtoOutputMessagesInnerPartyEnum> get values => _$ticketDetailDtoOutputMessagesInnerPartyEnumValues;
  static TicketDetailDtoOutputMessagesInnerPartyEnum valueOf(String name) => _$ticketDetailDtoOutputMessagesInnerPartyEnumValueOf(name);
}

