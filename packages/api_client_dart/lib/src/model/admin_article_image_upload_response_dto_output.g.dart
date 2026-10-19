// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_article_image_upload_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminArticleImageUploadResponseDtoOutput
    extends AdminArticleImageUploadResponseDtoOutput {
  @override
  final String uploadUrl;
  @override
  final String objectKey;
  @override
  final String publicUrl;
  @override
  final DateTime expiresAt;

  factory _$AdminArticleImageUploadResponseDtoOutput(
          [void Function(AdminArticleImageUploadResponseDtoOutputBuilder)?
              updates]) =>
      (AdminArticleImageUploadResponseDtoOutputBuilder()..update(updates))
          ._build();

  _$AdminArticleImageUploadResponseDtoOutput._(
      {required this.uploadUrl,
      required this.objectKey,
      required this.publicUrl,
      required this.expiresAt})
      : super._();
  @override
  AdminArticleImageUploadResponseDtoOutput rebuild(
          void Function(AdminArticleImageUploadResponseDtoOutputBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminArticleImageUploadResponseDtoOutputBuilder toBuilder() =>
      AdminArticleImageUploadResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminArticleImageUploadResponseDtoOutput &&
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
    return (newBuiltValueToStringHelper(
            r'AdminArticleImageUploadResponseDtoOutput')
          ..add('uploadUrl', uploadUrl)
          ..add('objectKey', objectKey)
          ..add('publicUrl', publicUrl)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class AdminArticleImageUploadResponseDtoOutputBuilder
    implements
        Builder<AdminArticleImageUploadResponseDtoOutput,
            AdminArticleImageUploadResponseDtoOutputBuilder> {
  _$AdminArticleImageUploadResponseDtoOutput? _$v;

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

  AdminArticleImageUploadResponseDtoOutputBuilder() {
    AdminArticleImageUploadResponseDtoOutput._defaults(this);
  }

  AdminArticleImageUploadResponseDtoOutputBuilder get _$this {
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
  void replace(AdminArticleImageUploadResponseDtoOutput other) {
    _$v = other as _$AdminArticleImageUploadResponseDtoOutput;
  }

  @override
  void update(
      void Function(AdminArticleImageUploadResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminArticleImageUploadResponseDtoOutput build() => _build();

  _$AdminArticleImageUploadResponseDtoOutput _build() {
    final _$result = _$v ??
        _$AdminArticleImageUploadResponseDtoOutput._(
          uploadUrl: BuiltValueNullFieldError.checkNotNull(uploadUrl,
              r'AdminArticleImageUploadResponseDtoOutput', 'uploadUrl'),
          objectKey: BuiltValueNullFieldError.checkNotNull(objectKey,
              r'AdminArticleImageUploadResponseDtoOutput', 'objectKey'),
          publicUrl: BuiltValueNullFieldError.checkNotNull(publicUrl,
              r'AdminArticleImageUploadResponseDtoOutput', 'publicUrl'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(expiresAt,
              r'AdminArticleImageUploadResponseDtoOutput', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
