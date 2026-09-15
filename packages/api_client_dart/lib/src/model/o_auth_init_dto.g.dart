// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth_init_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OAuthInitDto extends OAuthInitDto {
  @override
  final String? callbackURL;

  factory _$OAuthInitDto([void Function(OAuthInitDtoBuilder)? updates]) =>
      (OAuthInitDtoBuilder()..update(updates))._build();

  _$OAuthInitDto._({this.callbackURL}) : super._();
  @override
  OAuthInitDto rebuild(void Function(OAuthInitDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OAuthInitDtoBuilder toBuilder() => OAuthInitDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OAuthInitDto && callbackURL == other.callbackURL;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callbackURL.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OAuthInitDto')
          ..add('callbackURL', callbackURL))
        .toString();
  }
}

class OAuthInitDtoBuilder
    implements Builder<OAuthInitDto, OAuthInitDtoBuilder> {
  _$OAuthInitDto? _$v;

  String? _callbackURL;
  String? get callbackURL => _$this._callbackURL;
  set callbackURL(String? callbackURL) => _$this._callbackURL = callbackURL;

  OAuthInitDtoBuilder() {
    OAuthInitDto._defaults(this);
  }

  OAuthInitDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callbackURL = $v.callbackURL;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OAuthInitDto other) {
    _$v = other as _$OAuthInitDto;
  }

  @override
  void update(void Function(OAuthInitDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OAuthInitDto build() => _build();

  _$OAuthInitDto _build() {
    final _$result = _$v ??
        _$OAuthInitDto._(
          callbackURL: callbackURL,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
