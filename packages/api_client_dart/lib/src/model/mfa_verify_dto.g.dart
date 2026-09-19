// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_verify_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaVerifyDto extends MfaVerifyDto {
  @override
  final String challengeToken;
  @override
  final String code;

  factory _$MfaVerifyDto([void Function(MfaVerifyDtoBuilder)? updates]) =>
      (MfaVerifyDtoBuilder()..update(updates))._build();

  _$MfaVerifyDto._({required this.challengeToken, required this.code})
      : super._();
  @override
  MfaVerifyDto rebuild(void Function(MfaVerifyDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MfaVerifyDtoBuilder toBuilder() => MfaVerifyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaVerifyDto &&
        challengeToken == other.challengeToken &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, challengeToken.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaVerifyDto')
          ..add('challengeToken', challengeToken)
          ..add('code', code))
        .toString();
  }
}

class MfaVerifyDtoBuilder
    implements Builder<MfaVerifyDto, MfaVerifyDtoBuilder> {
  _$MfaVerifyDto? _$v;

  String? _challengeToken;
  String? get challengeToken => _$this._challengeToken;
  set challengeToken(String? challengeToken) =>
      _$this._challengeToken = challengeToken;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  MfaVerifyDtoBuilder() {
    MfaVerifyDto._defaults(this);
  }

  MfaVerifyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _challengeToken = $v.challengeToken;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaVerifyDto other) {
    _$v = other as _$MfaVerifyDto;
  }

  @override
  void update(void Function(MfaVerifyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaVerifyDto build() => _build();

  _$MfaVerifyDto _build() {
    final _$result = _$v ??
        _$MfaVerifyDto._(
          challengeToken: BuiltValueNullFieldError.checkNotNull(
              challengeToken, r'MfaVerifyDto', 'challengeToken'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'MfaVerifyDto', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
