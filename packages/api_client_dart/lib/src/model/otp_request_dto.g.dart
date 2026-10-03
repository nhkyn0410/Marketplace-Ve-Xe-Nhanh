// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OtpRequestDto extends OtpRequestDto {
  @override
  final String email;

  factory _$OtpRequestDto([void Function(OtpRequestDtoBuilder)? updates]) =>
      (OtpRequestDtoBuilder()..update(updates))._build();

  _$OtpRequestDto._({required this.email}) : super._();
  @override
  OtpRequestDto rebuild(void Function(OtpRequestDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OtpRequestDtoBuilder toBuilder() => OtpRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OtpRequestDto && email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OtpRequestDto')..add('email', email))
        .toString();
  }
}

class OtpRequestDtoBuilder
    implements Builder<OtpRequestDto, OtpRequestDtoBuilder> {
  _$OtpRequestDto? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  OtpRequestDtoBuilder() {
    OtpRequestDto._defaults(this);
  }

  OtpRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OtpRequestDto other) {
    _$v = other as _$OtpRequestDto;
  }

  @override
  void update(void Function(OtpRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OtpRequestDto build() => _build();

  _$OtpRequestDto _build() {
    final _$result = _$v ??
        _$OtpRequestDto._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'OtpRequestDto', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
