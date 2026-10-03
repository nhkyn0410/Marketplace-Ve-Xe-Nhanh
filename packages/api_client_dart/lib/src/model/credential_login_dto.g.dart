// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_login_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CredentialLoginDto extends CredentialLoginDto {
  @override
  final String identifier;
  @override
  final String password;

  factory _$CredentialLoginDto(
          [void Function(CredentialLoginDtoBuilder)? updates]) =>
      (CredentialLoginDtoBuilder()..update(updates))._build();

  _$CredentialLoginDto._({required this.identifier, required this.password})
      : super._();
  @override
  CredentialLoginDto rebuild(
          void Function(CredentialLoginDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CredentialLoginDtoBuilder toBuilder() =>
      CredentialLoginDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CredentialLoginDto &&
        identifier == other.identifier &&
        password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, identifier.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CredentialLoginDto')
          ..add('identifier', identifier)
          ..add('password', password))
        .toString();
  }
}

class CredentialLoginDtoBuilder
    implements Builder<CredentialLoginDto, CredentialLoginDtoBuilder> {
  _$CredentialLoginDto? _$v;

  String? _identifier;
  String? get identifier => _$this._identifier;
  set identifier(String? identifier) => _$this._identifier = identifier;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  CredentialLoginDtoBuilder() {
    CredentialLoginDto._defaults(this);
  }

  CredentialLoginDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _identifier = $v.identifier;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CredentialLoginDto other) {
    _$v = other as _$CredentialLoginDto;
  }

  @override
  void update(void Function(CredentialLoginDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CredentialLoginDto build() => _build();

  _$CredentialLoginDto _build() {
    final _$result = _$v ??
        _$CredentialLoginDto._(
          identifier: BuiltValueNullFieldError.checkNotNull(
              identifier, r'CredentialLoginDto', 'identifier'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'CredentialLoginDto', 'password'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
