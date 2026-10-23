// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_upload_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DocumentUploadResponseDtoOutput
    extends DocumentUploadResponseDtoOutput {
  @override
  final String uploadUrl;
  @override
  final String objectKey;
  @override
  final DateTime expiresAt;

  factory _$DocumentUploadResponseDtoOutput(
          [void Function(DocumentUploadResponseDtoOutputBuilder)? updates]) =>
      (DocumentUploadResponseDtoOutputBuilder()..update(updates))._build();

  _$DocumentUploadResponseDtoOutput._(
      {required this.uploadUrl,
      required this.objectKey,
      required this.expiresAt})
      : super._();
  @override
  DocumentUploadResponseDtoOutput rebuild(
          void Function(DocumentUploadResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DocumentUploadResponseDtoOutputBuilder toBuilder() =>
      DocumentUploadResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DocumentUploadResponseDtoOutput &&
        uploadUrl == other.uploadUrl &&
        objectKey == other.objectKey &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, uploadUrl.hashCode);
    _$hash = $jc(_$hash, objectKey.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DocumentUploadResponseDtoOutput')
          ..add('uploadUrl', uploadUrl)
          ..add('objectKey', objectKey)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class DocumentUploadResponseDtoOutputBuilder
    implements
        Builder<DocumentUploadResponseDtoOutput,
            DocumentUploadResponseDtoOutputBuilder> {
  _$DocumentUploadResponseDtoOutput? _$v;

  String? _uploadUrl;
  String? get uploadUrl => _$this._uploadUrl;
  set uploadUrl(String? uploadUrl) => _$this._uploadUrl = uploadUrl;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DocumentUploadResponseDtoOutputBuilder() {
    DocumentUploadResponseDtoOutput._defaults(this);
  }

  DocumentUploadResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uploadUrl = $v.uploadUrl;
      _objectKey = $v.objectKey;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DocumentUploadResponseDtoOutput other) {
    _$v = other as _$DocumentUploadResponseDtoOutput;
  }

  @override
  void update(void Function(DocumentUploadResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DocumentUploadResponseDtoOutput build() => _build();

  _$DocumentUploadResponseDtoOutput _build() {
    final _$result = _$v ??
        _$DocumentUploadResponseDtoOutput._(
          uploadUrl: BuiltValueNullFieldError.checkNotNull(
              uploadUrl, r'DocumentUploadResponseDtoOutput', 'uploadUrl'),
          objectKey: BuiltValueNullFieldError.checkNotNull(
              objectKey, r'DocumentUploadResponseDtoOutput', 'objectKey'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'DocumentUploadResponseDtoOutput', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
