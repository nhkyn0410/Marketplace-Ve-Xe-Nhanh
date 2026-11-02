// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evidence_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EvidenceInputDto extends EvidenceInputDto {
  @override
  final String body;
  @override
  final BuiltList<CustomerTicketInputDtoAttachmentsInner>? attachments;

  factory _$EvidenceInputDto(
          [void Function(EvidenceInputDtoBuilder)? updates]) =>
      (EvidenceInputDtoBuilder()..update(updates))._build();

  _$EvidenceInputDto._({required this.body, this.attachments}) : super._();
  @override
  EvidenceInputDto rebuild(void Function(EvidenceInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EvidenceInputDtoBuilder toBuilder() =>
      EvidenceInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EvidenceInputDto &&
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
    return (newBuiltValueToStringHelper(r'EvidenceInputDto')
          ..add('body', body)
          ..add('attachments', attachments))
        .toString();
  }
}

class EvidenceInputDtoBuilder
    implements Builder<EvidenceInputDto, EvidenceInputDtoBuilder> {
  _$EvidenceInputDto? _$v;

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

  EvidenceInputDtoBuilder() {
    EvidenceInputDto._defaults(this);
  }

  EvidenceInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _body = $v.body;
      _attachments = $v.attachments?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EvidenceInputDto other) {
    _$v = other as _$EvidenceInputDto;
  }

  @override
  void update(void Function(EvidenceInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EvidenceInputDto build() => _build();

  _$EvidenceInputDto _build() {
    _$EvidenceInputDto _$result;
    try {
      _$result = _$v ??
          _$EvidenceInputDto._(
            body: BuiltValueNullFieldError.checkNotNull(
                body, r'EvidenceInputDto', 'body'),
            attachments: _attachments?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attachments';
        _attachments?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'EvidenceInputDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
