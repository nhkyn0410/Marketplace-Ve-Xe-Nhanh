// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth_redirect_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OAuthRedirectResponseDtoOutput extends OAuthRedirectResponseDtoOutput {
  @override
  final String redirectUrl;

  factory _$OAuthRedirectResponseDtoOutput(
          [void Function(OAuthRedirectResponseDtoOutputBuilder)? updates]) =>
      (OAuthRedirectResponseDtoOutputBuilder()..update(updates))._build();

  _$OAuthRedirectResponseDtoOutput._({required this.redirectUrl}) : super._();
  @override
  OAuthRedirectResponseDtoOutput rebuild(
          void Function(OAuthRedirectResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OAuthRedirectResponseDtoOutputBuilder toBuilder() =>
      OAuthRedirectResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OAuthRedirectResponseDtoOutput &&
        redirectUrl == other.redirectUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, redirectUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OAuthRedirectResponseDtoOutput')
          ..add('redirectUrl', redirectUrl))
        .toString();
  }
}

class OAuthRedirectResponseDtoOutputBuilder
    implements
        Builder<OAuthRedirectResponseDtoOutput,
            OAuthRedirectResponseDtoOutputBuilder> {
  _$OAuthRedirectResponseDtoOutput? _$v;

  String? _redirectUrl;
  String? get redirectUrl => _$this._redirectUrl;
  set redirectUrl(String? redirectUrl) => _$this._redirectUrl = redirectUrl;

  OAuthRedirectResponseDtoOutputBuilder() {
    OAuthRedirectResponseDtoOutput._defaults(this);
  }

  OAuthRedirectResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _redirectUrl = $v.redirectUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OAuthRedirectResponseDtoOutput other) {
    _$v = other as _$OAuthRedirectResponseDtoOutput;
  }

  @override
  void update(void Function(OAuthRedirectResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OAuthRedirectResponseDtoOutput build() => _build();

  _$OAuthRedirectResponseDtoOutput _build() {
    final _$result = _$v ??
        _$OAuthRedirectResponseDtoOutput._(
          redirectUrl: BuiltValueNullFieldError.checkNotNull(
              redirectUrl, r'OAuthRedirectResponseDtoOutput', 'redirectUrl'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
