// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verify_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OtpVerifyDto extends OtpVerifyDto {
  @override
  final String email;
  @override
  final String otp;

  factory _$OtpVerifyDto([void Function(OtpVerifyDtoBuilder)? updates]) =>
      (OtpVerifyDtoBuilder()..update(updates))._build();

  _$OtpVerifyDto._({required this.email, required this.otp}) : super._();
  @override
  OtpVerifyDto rebuild(void Function(OtpVerifyDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OtpVerifyDtoBuilder toBuilder() => OtpVerifyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OtpVerifyDto && email == other.email && otp == other.otp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, otp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OtpVerifyDto')
          ..add('email', email)
          ..add('otp', otp))
        .toString();
  }
}

class OtpVerifyDtoBuilder
    implements Builder<OtpVerifyDto, OtpVerifyDtoBuilder> {
  _$OtpVerifyDto? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _otp;
  String? get otp => _$this._otp;
  set otp(String? otp) => _$this._otp = otp;

  OtpVerifyDtoBuilder() {
    OtpVerifyDto._defaults(this);
  }

  OtpVerifyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _otp = $v.otp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OtpVerifyDto other) {
    _$v = other as _$OtpVerifyDto;
  }

  @override
  void update(void Function(OtpVerifyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OtpVerifyDto build() => _build();

  _$OtpVerifyDto _build() {
    final _$result = _$v ??
        _$OtpVerifyDto._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'OtpVerifyDto', 'email'),
          otp: BuiltValueNullFieldError.checkNotNull(
              otp, r'OtpVerifyDto', 'otp'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
