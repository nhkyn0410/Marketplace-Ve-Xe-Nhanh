// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_download_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$KycDownloadResponseDtoOutput extends KycDownloadResponseDtoOutput {
  @override
  final String url;
  @override
  final DateTime expiresAt;

  factory _$KycDownloadResponseDtoOutput(
          [void Function(KycDownloadResponseDtoOutputBuilder)? updates]) =>
      (KycDownloadResponseDtoOutputBuilder()..update(updates))._build();

  _$KycDownloadResponseDtoOutput._({required this.url, required this.expiresAt})
      : super._();
  @override
  KycDownloadResponseDtoOutput rebuild(
          void Function(KycDownloadResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KycDownloadResponseDtoOutputBuilder toBuilder() =>
      KycDownloadResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KycDownloadResponseDtoOutput &&
        url == other.url &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'KycDownloadResponseDtoOutput')
          ..add('url', url)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class KycDownloadResponseDtoOutputBuilder
    implements
        Builder<KycDownloadResponseDtoOutput,
            KycDownloadResponseDtoOutputBuilder> {
  _$KycDownloadResponseDtoOutput? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  KycDownloadResponseDtoOutputBuilder() {
    KycDownloadResponseDtoOutput._defaults(this);
  }

  KycDownloadResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(KycDownloadResponseDtoOutput other) {
    _$v = other as _$KycDownloadResponseDtoOutput;
  }

  @override
  void update(void Function(KycDownloadResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  KycDownloadResponseDtoOutput build() => _build();

  _$KycDownloadResponseDtoOutput _build() {
    final _$result = _$v ??
        _$KycDownloadResponseDtoOutput._(
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'KycDownloadResponseDtoOutput', 'url'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'KycDownloadResponseDtoOutput', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
