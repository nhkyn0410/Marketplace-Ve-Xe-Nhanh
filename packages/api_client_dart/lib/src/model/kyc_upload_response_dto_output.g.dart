// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_upload_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$KycUploadResponseDtoOutput extends KycUploadResponseDtoOutput {
  @override
  final String uploadUrl;
  @override
  final String objectKey;
  @override
  final DateTime expiresAt;

  factory _$KycUploadResponseDtoOutput(
          [void Function(KycUploadResponseDtoOutputBuilder)? updates]) =>
      (KycUploadResponseDtoOutputBuilder()..update(updates))._build();

  _$KycUploadResponseDtoOutput._(
      {required this.uploadUrl,
      required this.objectKey,
      required this.expiresAt})
      : super._();
  @override
  KycUploadResponseDtoOutput rebuild(
          void Function(KycUploadResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KycUploadResponseDtoOutputBuilder toBuilder() =>
      KycUploadResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KycUploadResponseDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'KycUploadResponseDtoOutput')
          ..add('uploadUrl', uploadUrl)
          ..add('objectKey', objectKey)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class KycUploadResponseDtoOutputBuilder
    implements
        Builder<KycUploadResponseDtoOutput, KycUploadResponseDtoOutputBuilder> {
  _$KycUploadResponseDtoOutput? _$v;

  String? _uploadUrl;
  String? get uploadUrl => _$this._uploadUrl;
  set uploadUrl(String? uploadUrl) => _$this._uploadUrl = uploadUrl;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  KycUploadResponseDtoOutputBuilder() {
    KycUploadResponseDtoOutput._defaults(this);
  }

  KycUploadResponseDtoOutputBuilder get _$this {
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
  void replace(KycUploadResponseDtoOutput other) {
    _$v = other as _$KycUploadResponseDtoOutput;
  }

  @override
  void update(void Function(KycUploadResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  KycUploadResponseDtoOutput build() => _build();

  _$KycUploadResponseDtoOutput _build() {
    final _$result = _$v ??
        _$KycUploadResponseDtoOutput._(
          uploadUrl: BuiltValueNullFieldError.checkNotNull(
              uploadUrl, r'KycUploadResponseDtoOutput', 'uploadUrl'),
          objectKey: BuiltValueNullFieldError.checkNotNull(
              objectKey, r'KycUploadResponseDtoOutput', 'objectKey'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'KycUploadResponseDtoOutput', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
