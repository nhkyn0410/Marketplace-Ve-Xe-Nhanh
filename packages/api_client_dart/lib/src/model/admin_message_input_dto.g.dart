// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_message_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMessageInputDto extends AdminMessageInputDto {
  @override
  final String body;
  @override
  final BuiltList<CustomerTicketInputDtoAttachmentsInner>? attachments;
  @override
  final bool? requestInfo;

  factory _$AdminMessageInputDto(
          [void Function(AdminMessageInputDtoBuilder)? updates]) =>
      (AdminMessageInputDtoBuilder()..update(updates))._build();

  _$AdminMessageInputDto._(
      {required this.body, this.attachments, this.requestInfo})
      : super._();
  @override
  AdminMessageInputDto rebuild(
          void Function(AdminMessageInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminMessageInputDtoBuilder toBuilder() =>
      AdminMessageInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMessageInputDto &&
        body == other.body &&
        attachments == other.attachments &&
        requestInfo == other.requestInfo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, attachments.hashCode);
    _$hash = $jc(_$hash, requestInfo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMessageInputDto')
          ..add('body', body)
          ..add('attachments', attachments)
          ..add('requestInfo', requestInfo))
        .toString();
  }
}

class AdminMessageInputDtoBuilder
    implements Builder<AdminMessageInputDto, AdminMessageInputDtoBuilder> {
  _$AdminMessageInputDto? _$v;

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

  bool? _requestInfo;
  bool? get requestInfo => _$this._requestInfo;
  set requestInfo(bool? requestInfo) => _$this._requestInfo = requestInfo;

  AdminMessageInputDtoBuilder() {
    AdminMessageInputDto._defaults(this);
  }

  AdminMessageInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _body = $v.body;
      _attachments = $v.attachments?.toBuilder();
      _requestInfo = $v.requestInfo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMessageInputDto other) {
    _$v = other as _$AdminMessageInputDto;
  }

  @override
  void update(void Function(AdminMessageInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMessageInputDto build() => _build();

  _$AdminMessageInputDto _build() {
    _$AdminMessageInputDto _$result;
    try {
      _$result = _$v ??
          _$AdminMessageInputDto._(
            body: BuiltValueNullFieldError.checkNotNull(
                body, r'AdminMessageInputDto', 'body'),
            attachments: _attachments?.build(),
            requestInfo: requestInfo,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attachments';
        _attachments?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminMessageInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
