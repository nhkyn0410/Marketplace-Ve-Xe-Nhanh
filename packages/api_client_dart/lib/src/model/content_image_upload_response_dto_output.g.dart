// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_image_upload_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContentImageUploadResponseDtoOutput
    extends ContentImageUploadResponseDtoOutput {
  @override
  final String uploadUrl;
  @override
  final String objectKey;
  @override
  final String publicUrl;
  @override
  final DateTime expiresAt;

  factory _$ContentImageUploadResponseDtoOutput(
          [void Function(ContentImageUploadResponseDtoOutputBuilder)?
              updates]) =>
      (ContentImageUploadResponseDtoOutputBuilder()..update(updates))._build();

  _$ContentImageUploadResponseDtoOutput._(
      {required this.uploadUrl,
      required this.objectKey,
      required this.publicUrl,
      required this.expiresAt})
      : super._();
  @override
  ContentImageUploadResponseDtoOutput rebuild(
          void Function(ContentImageUploadResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContentImageUploadResponseDtoOutputBuilder toBuilder() =>
      ContentImageUploadResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContentImageUploadResponseDtoOutput &&
        uploadUrl == other.uploadUrl &&
        objectKey == other.objectKey &&
        publicUrl == other.publicUrl &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, uploadUrl.hashCode);
    _$hash = $jc(_$hash, objectKey.hashCode);
    _$hash = $jc(_$hash, publicUrl.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContentImageUploadResponseDtoOutput')
          ..add('uploadUrl', uploadUrl)
          ..add('objectKey', objectKey)
          ..add('publicUrl', publicUrl)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class ContentImageUploadResponseDtoOutputBuilder
    implements
        Builder<ContentImageUploadResponseDtoOutput,
            ContentImageUploadResponseDtoOutputBuilder> {
  _$ContentImageUploadResponseDtoOutput? _$v;

  String? _uploadUrl;
  String? get uploadUrl => _$this._uploadUrl;
  set uploadUrl(String? uploadUrl) => _$this._uploadUrl = uploadUrl;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  String? _publicUrl;
  String? get publicUrl => _$this._publicUrl;
  set publicUrl(String? publicUrl) => _$this._publicUrl = publicUrl;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  ContentImageUploadResponseDtoOutputBuilder() {
    ContentImageUploadResponseDtoOutput._defaults(this);
  }

  ContentImageUploadResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uploadUrl = $v.uploadUrl;
      _objectKey = $v.objectKey;
      _publicUrl = $v.publicUrl;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContentImageUploadResponseDtoOutput other) {
    _$v = other as _$ContentImageUploadResponseDtoOutput;
  }

  @override
  void update(
      void Function(ContentImageUploadResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContentImageUploadResponseDtoOutput build() => _build();

  _$ContentImageUploadResponseDtoOutput _build() {
    final _$result = _$v ??
        _$ContentImageUploadResponseDtoOutput._(
          uploadUrl: BuiltValueNullFieldError.checkNotNull(
              uploadUrl, r'ContentImageUploadResponseDtoOutput', 'uploadUrl'),
          objectKey: BuiltValueNullFieldError.checkNotNull(
              objectKey, r'ContentImageUploadResponseDtoOutput', 'objectKey'),
          publicUrl: BuiltValueNullFieldError.checkNotNull(
              publicUrl, r'ContentImageUploadResponseDtoOutput', 'publicUrl'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'ContentImageUploadResponseDtoOutput', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
