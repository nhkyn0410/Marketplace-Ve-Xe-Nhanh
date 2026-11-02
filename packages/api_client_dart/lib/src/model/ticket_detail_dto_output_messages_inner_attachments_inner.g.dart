// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_detail_dto_output_messages_inner_attachments_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TicketDetailDtoOutputMessagesInnerAttachmentsInner
    extends TicketDetailDtoOutputMessagesInnerAttachmentsInner {
  @override
  final String attachmentId;
  @override
  final String fileName;
  @override
  final String contentType;
  @override
  final int sizeBytes;

  factory _$TicketDetailDtoOutputMessagesInnerAttachmentsInner(
          [void Function(
                  TicketDetailDtoOutputMessagesInnerAttachmentsInnerBuilder)?
              updates]) =>
      (TicketDetailDtoOutputMessagesInnerAttachmentsInnerBuilder()
            ..update(updates))
          ._build();

  _$TicketDetailDtoOutputMessagesInnerAttachmentsInner._(
      {required this.attachmentId,
      required this.fileName,
      required this.contentType,
      required this.sizeBytes})
      : super._();
  @override
  TicketDetailDtoOutputMessagesInnerAttachmentsInner rebuild(
          void Function(
                  TicketDetailDtoOutputMessagesInnerAttachmentsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketDetailDtoOutputMessagesInnerAttachmentsInnerBuilder toBuilder() =>
      TicketDetailDtoOutputMessagesInnerAttachmentsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketDetailDtoOutputMessagesInnerAttachmentsInner &&
        attachmentId == other.attachmentId &&
        fileName == other.fileName &&
        contentType == other.contentType &&
        sizeBytes == other.sizeBytes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attachmentId.hashCode);
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'TicketDetailDtoOutputMessagesInnerAttachmentsInner')
          ..add('attachmentId', attachmentId)
          ..add('fileName', fileName)
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class TicketDetailDtoOutputMessagesInnerAttachmentsInnerBuilder
    implements
        Builder<TicketDetailDtoOutputMessagesInnerAttachmentsInner,
            TicketDetailDtoOutputMessagesInnerAttachmentsInnerBuilder> {
  _$TicketDetailDtoOutputMessagesInnerAttachmentsInner? _$v;

  String? _attachmentId;
  String? get attachmentId => _$this._attachmentId;
  set attachmentId(String? attachmentId) => _$this._attachmentId = attachmentId;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  TicketDetailDtoOutputMessagesInnerAttachmentsInnerBuilder() {
    TicketDetailDtoOutputMessagesInnerAttachmentsInner._defaults(this);
  }

  TicketDetailDtoOutputMessagesInnerAttachmentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attachmentId = $v.attachmentId;
      _fileName = $v.fileName;
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketDetailDtoOutputMessagesInnerAttachmentsInner other) {
    _$v = other as _$TicketDetailDtoOutputMessagesInnerAttachmentsInner;
  }

  @override
  void update(
      void Function(TicketDetailDtoOutputMessagesInnerAttachmentsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketDetailDtoOutputMessagesInnerAttachmentsInner build() => _build();

  _$TicketDetailDtoOutputMessagesInnerAttachmentsInner _build() {
    final _$result = _$v ??
        _$TicketDetailDtoOutputMessagesInnerAttachmentsInner._(
          attachmentId: BuiltValueNullFieldError.checkNotNull(
              attachmentId,
              r'TicketDetailDtoOutputMessagesInnerAttachmentsInner',
              'attachmentId'),
          fileName: BuiltValueNullFieldError.checkNotNull(
              fileName,
              r'TicketDetailDtoOutputMessagesInnerAttachmentsInner',
              'fileName'),
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType,
              r'TicketDetailDtoOutputMessagesInnerAttachmentsInner',
              'contentType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes,
              r'TicketDetailDtoOutputMessagesInnerAttachmentsInner',
              'sizeBytes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
