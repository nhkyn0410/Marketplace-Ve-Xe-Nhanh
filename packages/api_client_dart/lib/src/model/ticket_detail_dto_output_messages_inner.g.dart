// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_detail_dto_output_messages_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TicketDetailDtoOutputMessagesInnerPartyEnum
    _$ticketDetailDtoOutputMessagesInnerPartyEnum_PASSENGER =
    const TicketDetailDtoOutputMessagesInnerPartyEnum._('PASSENGER');
const TicketDetailDtoOutputMessagesInnerPartyEnum
    _$ticketDetailDtoOutputMessagesInnerPartyEnum_GUEST =
    const TicketDetailDtoOutputMessagesInnerPartyEnum._('GUEST');
const TicketDetailDtoOutputMessagesInnerPartyEnum
    _$ticketDetailDtoOutputMessagesInnerPartyEnum_OPERATOR =
    const TicketDetailDtoOutputMessagesInnerPartyEnum._('OPERATOR');
const TicketDetailDtoOutputMessagesInnerPartyEnum
    _$ticketDetailDtoOutputMessagesInnerPartyEnum_PLATFORM =
    const TicketDetailDtoOutputMessagesInnerPartyEnum._('PLATFORM');
const TicketDetailDtoOutputMessagesInnerPartyEnum
    _$ticketDetailDtoOutputMessagesInnerPartyEnum_SYSTEM =
    const TicketDetailDtoOutputMessagesInnerPartyEnum._('SYSTEM');

TicketDetailDtoOutputMessagesInnerPartyEnum
    _$ticketDetailDtoOutputMessagesInnerPartyEnumValueOf(String name) {
  switch (name) {
    case 'PASSENGER':
      return _$ticketDetailDtoOutputMessagesInnerPartyEnum_PASSENGER;
    case 'GUEST':
      return _$ticketDetailDtoOutputMessagesInnerPartyEnum_GUEST;
    case 'OPERATOR':
      return _$ticketDetailDtoOutputMessagesInnerPartyEnum_OPERATOR;
    case 'PLATFORM':
      return _$ticketDetailDtoOutputMessagesInnerPartyEnum_PLATFORM;
    case 'SYSTEM':
      return _$ticketDetailDtoOutputMessagesInnerPartyEnum_SYSTEM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TicketDetailDtoOutputMessagesInnerPartyEnum>
    _$ticketDetailDtoOutputMessagesInnerPartyEnumValues = BuiltSet<
        TicketDetailDtoOutputMessagesInnerPartyEnum>(const <TicketDetailDtoOutputMessagesInnerPartyEnum>[
  _$ticketDetailDtoOutputMessagesInnerPartyEnum_PASSENGER,
  _$ticketDetailDtoOutputMessagesInnerPartyEnum_GUEST,
  _$ticketDetailDtoOutputMessagesInnerPartyEnum_OPERATOR,
  _$ticketDetailDtoOutputMessagesInnerPartyEnum_PLATFORM,
  _$ticketDetailDtoOutputMessagesInnerPartyEnum_SYSTEM,
]);

Serializer<TicketDetailDtoOutputMessagesInnerPartyEnum>
    _$ticketDetailDtoOutputMessagesInnerPartyEnumSerializer =
    _$TicketDetailDtoOutputMessagesInnerPartyEnumSerializer();

class _$TicketDetailDtoOutputMessagesInnerPartyEnumSerializer
    implements
        PrimitiveSerializer<TicketDetailDtoOutputMessagesInnerPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PASSENGER': 'PASSENGER',
    'GUEST': 'GUEST',
    'OPERATOR': 'OPERATOR',
    'PLATFORM': 'PLATFORM',
    'SYSTEM': 'SYSTEM',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PASSENGER': 'PASSENGER',
    'GUEST': 'GUEST',
    'OPERATOR': 'OPERATOR',
    'PLATFORM': 'PLATFORM',
    'SYSTEM': 'SYSTEM',
  };

  @override
  final Iterable<Type> types = const <Type>[
    TicketDetailDtoOutputMessagesInnerPartyEnum
  ];
  @override
  final String wireName = 'TicketDetailDtoOutputMessagesInnerPartyEnum';

  @override
  Object serialize(Serializers serializers,
          TicketDetailDtoOutputMessagesInnerPartyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TicketDetailDtoOutputMessagesInnerPartyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TicketDetailDtoOutputMessagesInnerPartyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TicketDetailDtoOutputMessagesInner
    extends TicketDetailDtoOutputMessagesInner {
  @override
  final String messageId;
  @override
  final TicketDetailDtoOutputMessagesInnerPartyEnum party;
  @override
  final String authorName;
  @override
  final String body;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<TicketDetailDtoOutputMessagesInnerAttachmentsInner>
      attachments;

  factory _$TicketDetailDtoOutputMessagesInner(
          [void Function(TicketDetailDtoOutputMessagesInnerBuilder)?
              updates]) =>
      (TicketDetailDtoOutputMessagesInnerBuilder()..update(updates))._build();

  _$TicketDetailDtoOutputMessagesInner._(
      {required this.messageId,
      required this.party,
      required this.authorName,
      required this.body,
      required this.createdAt,
      required this.attachments})
      : super._();
  @override
  TicketDetailDtoOutputMessagesInner rebuild(
          void Function(TicketDetailDtoOutputMessagesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketDetailDtoOutputMessagesInnerBuilder toBuilder() =>
      TicketDetailDtoOutputMessagesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketDetailDtoOutputMessagesInner &&
        messageId == other.messageId &&
        party == other.party &&
        authorName == other.authorName &&
        body == other.body &&
        createdAt == other.createdAt &&
        attachments == other.attachments;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, messageId.hashCode);
    _$hash = $jc(_$hash, party.hashCode);
    _$hash = $jc(_$hash, authorName.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, attachments.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketDetailDtoOutputMessagesInner')
          ..add('messageId', messageId)
          ..add('party', party)
          ..add('authorName', authorName)
          ..add('body', body)
          ..add('createdAt', createdAt)
          ..add('attachments', attachments))
        .toString();
  }
}

class TicketDetailDtoOutputMessagesInnerBuilder
    implements
        Builder<TicketDetailDtoOutputMessagesInner,
            TicketDetailDtoOutputMessagesInnerBuilder> {
  _$TicketDetailDtoOutputMessagesInner? _$v;

  String? _messageId;
  String? get messageId => _$this._messageId;
  set messageId(String? messageId) => _$this._messageId = messageId;

  TicketDetailDtoOutputMessagesInnerPartyEnum? _party;
  TicketDetailDtoOutputMessagesInnerPartyEnum? get party => _$this._party;
  set party(TicketDetailDtoOutputMessagesInnerPartyEnum? party) =>
      _$this._party = party;

  String? _authorName;
  String? get authorName => _$this._authorName;
  set authorName(String? authorName) => _$this._authorName = authorName;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<TicketDetailDtoOutputMessagesInnerAttachmentsInner>? _attachments;
  ListBuilder<TicketDetailDtoOutputMessagesInnerAttachmentsInner>
      get attachments => _$this._attachments ??=
          ListBuilder<TicketDetailDtoOutputMessagesInnerAttachmentsInner>();
  set attachments(
          ListBuilder<TicketDetailDtoOutputMessagesInnerAttachmentsInner>?
              attachments) =>
      _$this._attachments = attachments;

  TicketDetailDtoOutputMessagesInnerBuilder() {
    TicketDetailDtoOutputMessagesInner._defaults(this);
  }

  TicketDetailDtoOutputMessagesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _messageId = $v.messageId;
      _party = $v.party;
      _authorName = $v.authorName;
      _body = $v.body;
      _createdAt = $v.createdAt;
      _attachments = $v.attachments.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketDetailDtoOutputMessagesInner other) {
    _$v = other as _$TicketDetailDtoOutputMessagesInner;
  }

  @override
  void update(
      void Function(TicketDetailDtoOutputMessagesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketDetailDtoOutputMessagesInner build() => _build();

  _$TicketDetailDtoOutputMessagesInner _build() {
    _$TicketDetailDtoOutputMessagesInner _$result;
    try {
      _$result = _$v ??
          _$TicketDetailDtoOutputMessagesInner._(
            messageId: BuiltValueNullFieldError.checkNotNull(
                messageId, r'TicketDetailDtoOutputMessagesInner', 'messageId'),
            party: BuiltValueNullFieldError.checkNotNull(
                party, r'TicketDetailDtoOutputMessagesInner', 'party'),
            authorName: BuiltValueNullFieldError.checkNotNull(authorName,
                r'TicketDetailDtoOutputMessagesInner', 'authorName'),
            body: BuiltValueNullFieldError.checkNotNull(
                body, r'TicketDetailDtoOutputMessagesInner', 'body'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'TicketDetailDtoOutputMessagesInner', 'createdAt'),
            attachments: attachments.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attachments';
        attachments.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TicketDetailDtoOutputMessagesInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
