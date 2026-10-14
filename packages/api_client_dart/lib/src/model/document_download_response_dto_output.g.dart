// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_download_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DocumentDownloadResponseDtoOutput
    extends DocumentDownloadResponseDtoOutput {
  @override
  final String url;
  @override
  final DateTime expiresAt;

  factory _$DocumentDownloadResponseDtoOutput(
          [void Function(DocumentDownloadResponseDtoOutputBuilder)? updates]) =>
      (DocumentDownloadResponseDtoOutputBuilder()..update(updates))._build();

  _$DocumentDownloadResponseDtoOutput._(
      {required this.url, required this.expiresAt})
      : super._();
  @override
  DocumentDownloadResponseDtoOutput rebuild(
          void Function(DocumentDownloadResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DocumentDownloadResponseDtoOutputBuilder toBuilder() =>
      DocumentDownloadResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DocumentDownloadResponseDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'DocumentDownloadResponseDtoOutput')
          ..add('url', url)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class DocumentDownloadResponseDtoOutputBuilder
    implements
        Builder<DocumentDownloadResponseDtoOutput,
            DocumentDownloadResponseDtoOutputBuilder> {
  _$DocumentDownloadResponseDtoOutput? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DocumentDownloadResponseDtoOutputBuilder() {
    DocumentDownloadResponseDtoOutput._defaults(this);
  }

  DocumentDownloadResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DocumentDownloadResponseDtoOutput other) {
    _$v = other as _$DocumentDownloadResponseDtoOutput;
  }

  @override
  void update(
      void Function(DocumentDownloadResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DocumentDownloadResponseDtoOutput build() => _build();

  _$DocumentDownloadResponseDtoOutput _build() {
    final _$result = _$v ??
        _$DocumentDownloadResponseDtoOutput._(
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'DocumentDownloadResponseDtoOutput', 'url'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'DocumentDownloadResponseDtoOutput', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
