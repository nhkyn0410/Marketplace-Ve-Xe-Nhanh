// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_url_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DownloadUrlResponseDtoOutput extends DownloadUrlResponseDtoOutput {
  @override
  final String url;
  @override
  final DateTime expiresAt;

  factory _$DownloadUrlResponseDtoOutput(
          [void Function(DownloadUrlResponseDtoOutputBuilder)? updates]) =>
      (DownloadUrlResponseDtoOutputBuilder()..update(updates))._build();

  _$DownloadUrlResponseDtoOutput._({required this.url, required this.expiresAt})
      : super._();
  @override
  DownloadUrlResponseDtoOutput rebuild(
          void Function(DownloadUrlResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DownloadUrlResponseDtoOutputBuilder toBuilder() =>
      DownloadUrlResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DownloadUrlResponseDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'DownloadUrlResponseDtoOutput')
          ..add('url', url)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class DownloadUrlResponseDtoOutputBuilder
    implements
        Builder<DownloadUrlResponseDtoOutput,
            DownloadUrlResponseDtoOutputBuilder> {
  _$DownloadUrlResponseDtoOutput? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DownloadUrlResponseDtoOutputBuilder() {
    DownloadUrlResponseDtoOutput._defaults(this);
  }

  DownloadUrlResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DownloadUrlResponseDtoOutput other) {
    _$v = other as _$DownloadUrlResponseDtoOutput;
  }

  @override
  void update(void Function(DownloadUrlResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DownloadUrlResponseDtoOutput build() => _build();

  _$DownloadUrlResponseDtoOutput _build() {
    final _$result = _$v ??
        _$DownloadUrlResponseDtoOutput._(
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'DownloadUrlResponseDtoOutput', 'url'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'DownloadUrlResponseDtoOutput', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
