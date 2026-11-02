// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MessageInputDto extends MessageInputDto {
  @override
  final String body;
  @override
  final BuiltList<CustomerTicketInputDtoAttachmentsInner>? attachments;

  factory _$MessageInputDto([void Function(MessageInputDtoBuilder)? updates]) =>
      (MessageInputDtoBuilder()..update(updates))._build();

  _$MessageInputDto._({required this.body, this.attachments}) : super._();
  @override
  MessageInputDto rebuild(void Function(MessageInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MessageInputDtoBuilder toBuilder() => MessageInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MessageInputDto &&
        body == other.body &&
        attachments == other.attachments;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, attachments.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MessageInputDto')
          ..add('body', body)
          ..add('attachments', attachments))
        .toString();
  }
}

class MessageInputDtoBuilder
    implements Builder<MessageInputDto, MessageInputDtoBuilder> {
  _$MessageInputDto? _$v;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  ListBuilder<CustomerTicketInputDtoAttachmentsInner>? _attachments;
  ListBuilder<CustomerTicketInputDtoAttachmentsInner> get attachments =>
      _$this._attachments ??=
          ListBuilder<CustomerTicketInputDtoAttachmentsInner>();
  set attachments(
          ListBuilder<CustomerTicketInputDtoAttachmentsInner>? attachments) =>
      _$this._attachments = attachments;

  MessageInputDtoBuilder() {
    MessageInputDto._defaults(this);
  }

  MessageInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _body = $v.body;
      _attachments = $v.attachments?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MessageInputDto other) {
    _$v = other as _$MessageInputDto;
  }

  @override
  void update(void Function(MessageInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MessageInputDto build() => _build();

  _$MessageInputDto _build() {
    _$MessageInputDto _$result;
    try {
      _$result = _$v ??
          _$MessageInputDto._(
            body: BuiltValueNullFieldError.checkNotNull(
                body, r'MessageInputDto', 'body'),
            attachments: _attachments?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attachments';
        _attachments?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MessageInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
