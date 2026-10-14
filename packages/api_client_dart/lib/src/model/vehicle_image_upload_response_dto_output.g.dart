// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_image_upload_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VehicleImageUploadResponseDtoOutput
    extends VehicleImageUploadResponseDtoOutput {
  @override
  final String uploadUrl;
  @override
  final String objectKey;
  @override
  final DateTime expiresAt;

  factory _$VehicleImageUploadResponseDtoOutput(
          [void Function(VehicleImageUploadResponseDtoOutputBuilder)?
              updates]) =>
      (VehicleImageUploadResponseDtoOutputBuilder()..update(updates))._build();

  _$VehicleImageUploadResponseDtoOutput._(
      {required this.uploadUrl,
      required this.objectKey,
      required this.expiresAt})
      : super._();
  @override
  VehicleImageUploadResponseDtoOutput rebuild(
          void Function(VehicleImageUploadResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VehicleImageUploadResponseDtoOutputBuilder toBuilder() =>
      VehicleImageUploadResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VehicleImageUploadResponseDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'VehicleImageUploadResponseDtoOutput')
          ..add('uploadUrl', uploadUrl)
          ..add('objectKey', objectKey)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class VehicleImageUploadResponseDtoOutputBuilder
    implements
        Builder<VehicleImageUploadResponseDtoOutput,
            VehicleImageUploadResponseDtoOutputBuilder> {
  _$VehicleImageUploadResponseDtoOutput? _$v;

  String? _uploadUrl;
  String? get uploadUrl => _$this._uploadUrl;
  set uploadUrl(String? uploadUrl) => _$this._uploadUrl = uploadUrl;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  VehicleImageUploadResponseDtoOutputBuilder() {
    VehicleImageUploadResponseDtoOutput._defaults(this);
  }

  VehicleImageUploadResponseDtoOutputBuilder get _$this {
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
  void replace(VehicleImageUploadResponseDtoOutput other) {
    _$v = other as _$VehicleImageUploadResponseDtoOutput;
  }

  @override
  void update(
      void Function(VehicleImageUploadResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VehicleImageUploadResponseDtoOutput build() => _build();

  _$VehicleImageUploadResponseDtoOutput _build() {
    final _$result = _$v ??
        _$VehicleImageUploadResponseDtoOutput._(
          uploadUrl: BuiltValueNullFieldError.checkNotNull(
              uploadUrl, r'VehicleImageUploadResponseDtoOutput', 'uploadUrl'),
          objectKey: BuiltValueNullFieldError.checkNotNull(
              objectKey, r'VehicleImageUploadResponseDtoOutput', 'objectKey'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'VehicleImageUploadResponseDtoOutput', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
