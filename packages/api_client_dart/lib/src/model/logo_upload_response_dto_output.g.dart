// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logo_upload_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LogoUploadResponseDtoOutput extends LogoUploadResponseDtoOutput {
  @override
  final String uploadUrl;
  @override
  final String objectKey;
  @override
  final DateTime expiresAt;

  factory _$LogoUploadResponseDtoOutput(
          [void Function(LogoUploadResponseDtoOutputBuilder)? updates]) =>
      (LogoUploadResponseDtoOutputBuilder()..update(updates))._build();

  _$LogoUploadResponseDtoOutput._(
      {required this.uploadUrl,
      required this.objectKey,
      required this.expiresAt})
      : super._();
  @override
  LogoUploadResponseDtoOutput rebuild(
          void Function(LogoUploadResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LogoUploadResponseDtoOutputBuilder toBuilder() =>
      LogoUploadResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LogoUploadResponseDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'LogoUploadResponseDtoOutput')
          ..add('uploadUrl', uploadUrl)
          ..add('objectKey', objectKey)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class LogoUploadResponseDtoOutputBuilder
    implements
        Builder<LogoUploadResponseDtoOutput,
            LogoUploadResponseDtoOutputBuilder> {
  _$LogoUploadResponseDtoOutput? _$v;

  String? _uploadUrl;
  String? get uploadUrl => _$this._uploadUrl;
  set uploadUrl(String? uploadUrl) => _$this._uploadUrl = uploadUrl;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  LogoUploadResponseDtoOutputBuilder() {
    LogoUploadResponseDtoOutput._defaults(this);
  }

  LogoUploadResponseDtoOutputBuilder get _$this {
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
  void replace(LogoUploadResponseDtoOutput other) {
    _$v = other as _$LogoUploadResponseDtoOutput;
  }

  @override
  void update(void Function(LogoUploadResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LogoUploadResponseDtoOutput build() => _build();

  _$LogoUploadResponseDtoOutput _build() {
    final _$result = _$v ??
        _$LogoUploadResponseDtoOutput._(
          uploadUrl: BuiltValueNullFieldError.checkNotNull(
              uploadUrl, r'LogoUploadResponseDtoOutput', 'uploadUrl'),
          objectKey: BuiltValueNullFieldError.checkNotNull(
              objectKey, r'LogoUploadResponseDtoOutput', 'objectKey'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'LogoUploadResponseDtoOutput', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
