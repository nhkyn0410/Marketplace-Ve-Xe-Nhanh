// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_upload_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AttachmentUploadResponseDtoOutput
    extends AttachmentUploadResponseDtoOutput {
  @override
  final String uploadUrl;
  @override
  final String objectKey;
  @override
  final DateTime expiresAt;

  factory _$AttachmentUploadResponseDtoOutput(
          [void Function(AttachmentUploadResponseDtoOutputBuilder)? updates]) =>
      (AttachmentUploadResponseDtoOutputBuilder()..update(updates))._build();

  _$AttachmentUploadResponseDtoOutput._(
      {required this.uploadUrl,
      required this.objectKey,
      required this.expiresAt})
      : super._();
  @override
  AttachmentUploadResponseDtoOutput rebuild(
          void Function(AttachmentUploadResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AttachmentUploadResponseDtoOutputBuilder toBuilder() =>
      AttachmentUploadResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AttachmentUploadResponseDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AttachmentUploadResponseDtoOutput')
          ..add('uploadUrl', uploadUrl)
          ..add('objectKey', objectKey)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class AttachmentUploadResponseDtoOutputBuilder
    implements
        Builder<AttachmentUploadResponseDtoOutput,
            AttachmentUploadResponseDtoOutputBuilder> {
  _$AttachmentUploadResponseDtoOutput? _$v;

  String? _uploadUrl;
  String? get uploadUrl => _$this._uploadUrl;
  set uploadUrl(String? uploadUrl) => _$this._uploadUrl = uploadUrl;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  AttachmentUploadResponseDtoOutputBuilder() {
    AttachmentUploadResponseDtoOutput._defaults(this);
  }

  AttachmentUploadResponseDtoOutputBuilder get _$this {
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
  void replace(AttachmentUploadResponseDtoOutput other) {
    _$v = other as _$AttachmentUploadResponseDtoOutput;
  }

  @override
  void update(
      void Function(AttachmentUploadResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AttachmentUploadResponseDtoOutput build() => _build();

  _$AttachmentUploadResponseDtoOutput _build() {
    final _$result = _$v ??
        _$AttachmentUploadResponseDtoOutput._(
          uploadUrl: BuiltValueNullFieldError.checkNotNull(
              uploadUrl, r'AttachmentUploadResponseDtoOutput', 'uploadUrl'),
          objectKey: BuiltValueNullFieldError.checkNotNull(
              objectKey, r'AttachmentUploadResponseDtoOutput', 'objectKey'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'AttachmentUploadResponseDtoOutput', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
