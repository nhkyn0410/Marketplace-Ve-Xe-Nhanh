// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reauth_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReauthDto extends ReauthDto {
  @override
  final String? password;
  @override
  final String? otp;

  factory _$ReauthDto([void Function(ReauthDtoBuilder)? updates]) =>
      (ReauthDtoBuilder()..update(updates))._build();

  _$ReauthDto._({this.password, this.otp}) : super._();
  @override
  ReauthDto rebuild(void Function(ReauthDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReauthDtoBuilder toBuilder() => ReauthDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReauthDto && password == other.password && otp == other.otp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, otp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReauthDto')
          ..add('password', password)
          ..add('otp', otp))
        .toString();
  }
}

class ReauthDtoBuilder implements Builder<ReauthDto, ReauthDtoBuilder> {
  _$ReauthDto? _$v;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _otp;
  String? get otp => _$this._otp;
  set otp(String? otp) => _$this._otp = otp;

  ReauthDtoBuilder() {
    ReauthDto._defaults(this);
  }

  ReauthDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _password = $v.password;
      _otp = $v.otp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReauthDto other) {
    _$v = other as _$ReauthDto;
  }

  @override
  void update(void Function(ReauthDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReauthDto build() => _build();

  _$ReauthDto _build() {
    final _$result = _$v ??
        _$ReauthDto._(
          password: password,
          otp: otp,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
