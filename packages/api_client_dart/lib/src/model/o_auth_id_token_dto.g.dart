// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth_id_token_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OAuthIdTokenDto extends OAuthIdTokenDto {
  @override
  final String idToken;

  factory _$OAuthIdTokenDto([void Function(OAuthIdTokenDtoBuilder)? updates]) =>
      (OAuthIdTokenDtoBuilder()..update(updates))._build();

  _$OAuthIdTokenDto._({required this.idToken}) : super._();
  @override
  OAuthIdTokenDto rebuild(void Function(OAuthIdTokenDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OAuthIdTokenDtoBuilder toBuilder() => OAuthIdTokenDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OAuthIdTokenDto && idToken == other.idToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OAuthIdTokenDto')
          ..add('idToken', idToken))
        .toString();
  }
}

class OAuthIdTokenDtoBuilder
    implements Builder<OAuthIdTokenDto, OAuthIdTokenDtoBuilder> {
  _$OAuthIdTokenDto? _$v;

  String? _idToken;
  String? get idToken => _$this._idToken;
  set idToken(String? idToken) => _$this._idToken = idToken;

  OAuthIdTokenDtoBuilder() {
    OAuthIdTokenDto._defaults(this);
  }

  OAuthIdTokenDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idToken = $v.idToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OAuthIdTokenDto other) {
    _$v = other as _$OAuthIdTokenDto;
  }

  @override
  void update(void Function(OAuthIdTokenDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OAuthIdTokenDto build() => _build();

  _$OAuthIdTokenDto _build() {
    final _$result = _$v ??
        _$OAuthIdTokenDto._(
          idToken: BuiltValueNullFieldError.checkNotNull(
              idToken, r'OAuthIdTokenDto', 'idToken'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
