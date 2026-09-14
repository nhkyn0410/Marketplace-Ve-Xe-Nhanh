// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AuthTokenResponseDtoOutputTokenTypeEnum
    _$authTokenResponseDtoOutputTokenTypeEnum_bearer =
    const AuthTokenResponseDtoOutputTokenTypeEnum._('bearer');

AuthTokenResponseDtoOutputTokenTypeEnum
    _$authTokenResponseDtoOutputTokenTypeEnumValueOf(String name) {
  switch (name) {
    case 'bearer':
      return _$authTokenResponseDtoOutputTokenTypeEnum_bearer;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AuthTokenResponseDtoOutputTokenTypeEnum>
    _$authTokenResponseDtoOutputTokenTypeEnumValues = BuiltSet<
        AuthTokenResponseDtoOutputTokenTypeEnum>(const <AuthTokenResponseDtoOutputTokenTypeEnum>[
  _$authTokenResponseDtoOutputTokenTypeEnum_bearer,
]);

const AuthTokenResponseDtoOutputScopeEnum
    _$authTokenResponseDtoOutputScopeEnum_passenger =
    const AuthTokenResponseDtoOutputScopeEnum._('passenger');
const AuthTokenResponseDtoOutputScopeEnum
    _$authTokenResponseDtoOutputScopeEnum_operator_ =
    const AuthTokenResponseDtoOutputScopeEnum._('operator_');
const AuthTokenResponseDtoOutputScopeEnum
    _$authTokenResponseDtoOutputScopeEnum_platform =
    const AuthTokenResponseDtoOutputScopeEnum._('platform');

AuthTokenResponseDtoOutputScopeEnum
    _$authTokenResponseDtoOutputScopeEnumValueOf(String name) {
  switch (name) {
    case 'passenger':
      return _$authTokenResponseDtoOutputScopeEnum_passenger;
    case 'operator_':
      return _$authTokenResponseDtoOutputScopeEnum_operator_;
    case 'platform':
      return _$authTokenResponseDtoOutputScopeEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AuthTokenResponseDtoOutputScopeEnum>
    _$authTokenResponseDtoOutputScopeEnumValues = BuiltSet<
        AuthTokenResponseDtoOutputScopeEnum>(const <AuthTokenResponseDtoOutputScopeEnum>[
  _$authTokenResponseDtoOutputScopeEnum_passenger,
  _$authTokenResponseDtoOutputScopeEnum_operator_,
  _$authTokenResponseDtoOutputScopeEnum_platform,
]);

Serializer<AuthTokenResponseDtoOutputTokenTypeEnum>
    _$authTokenResponseDtoOutputTokenTypeEnumSerializer =
    _$AuthTokenResponseDtoOutputTokenTypeEnumSerializer();
Serializer<AuthTokenResponseDtoOutputScopeEnum>
    _$authTokenResponseDtoOutputScopeEnumSerializer =
    _$AuthTokenResponseDtoOutputScopeEnumSerializer();

class _$AuthTokenResponseDtoOutputTokenTypeEnumSerializer
    implements PrimitiveSerializer<AuthTokenResponseDtoOutputTokenTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'bearer': 'Bearer',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Bearer': 'bearer',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AuthTokenResponseDtoOutputTokenTypeEnum
  ];
  @override
  final String wireName = 'AuthTokenResponseDtoOutputTokenTypeEnum';

  @override
  Object serialize(Serializers serializers,
          AuthTokenResponseDtoOutputTokenTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AuthTokenResponseDtoOutputTokenTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AuthTokenResponseDtoOutputTokenTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AuthTokenResponseDtoOutputScopeEnumSerializer
    implements PrimitiveSerializer<AuthTokenResponseDtoOutputScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'passenger': 'passenger',
    'operator_': 'operator',
    'platform': 'platform',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'passenger': 'passenger',
    'operator': 'operator_',
    'platform': 'platform',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AuthTokenResponseDtoOutputScopeEnum
  ];
  @override
  final String wireName = 'AuthTokenResponseDtoOutputScopeEnum';

  @override
  Object serialize(
          Serializers serializers, AuthTokenResponseDtoOutputScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AuthTokenResponseDtoOutputScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AuthTokenResponseDtoOutputScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AuthTokenResponseDtoOutput extends AuthTokenResponseDtoOutput {
  @override
  final String accessToken;
  @override
  final AuthTokenResponseDtoOutputTokenTypeEnum tokenType;
  @override
  final int expiresIn;
  @override
  final AuthTokenResponseDtoOutputScopeEnum scope;
  @override
  final String role;

  factory _$AuthTokenResponseDtoOutput(
          [void Function(AuthTokenResponseDtoOutputBuilder)? updates]) =>
      (AuthTokenResponseDtoOutputBuilder()..update(updates))._build();

  _$AuthTokenResponseDtoOutput._(
      {required this.accessToken,
      required this.tokenType,
      required this.expiresIn,
      required this.scope,
      required this.role})
      : super._();
  @override
  AuthTokenResponseDtoOutput rebuild(
          void Function(AuthTokenResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthTokenResponseDtoOutputBuilder toBuilder() =>
      AuthTokenResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthTokenResponseDtoOutput &&
        accessToken == other.accessToken &&
        tokenType == other.tokenType &&
        expiresIn == other.expiresIn &&
        scope == other.scope &&
        role == other.role;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, tokenType.hashCode);
    _$hash = $jc(_$hash, expiresIn.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthTokenResponseDtoOutput')
          ..add('accessToken', accessToken)
          ..add('tokenType', tokenType)
          ..add('expiresIn', expiresIn)
          ..add('scope', scope)
          ..add('role', role))
        .toString();
  }
}

class AuthTokenResponseDtoOutputBuilder
    implements
        Builder<AuthTokenResponseDtoOutput, AuthTokenResponseDtoOutputBuilder> {
  _$AuthTokenResponseDtoOutput? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  AuthTokenResponseDtoOutputTokenTypeEnum? _tokenType;
  AuthTokenResponseDtoOutputTokenTypeEnum? get tokenType => _$this._tokenType;
  set tokenType(AuthTokenResponseDtoOutputTokenTypeEnum? tokenType) =>
      _$this._tokenType = tokenType;

  int? _expiresIn;
  int? get expiresIn => _$this._expiresIn;
  set expiresIn(int? expiresIn) => _$this._expiresIn = expiresIn;

  AuthTokenResponseDtoOutputScopeEnum? _scope;
  AuthTokenResponseDtoOutputScopeEnum? get scope => _$this._scope;
  set scope(AuthTokenResponseDtoOutputScopeEnum? scope) =>
      _$this._scope = scope;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  AuthTokenResponseDtoOutputBuilder() {
    AuthTokenResponseDtoOutput._defaults(this);
  }

  AuthTokenResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessToken = $v.accessToken;
      _tokenType = $v.tokenType;
      _expiresIn = $v.expiresIn;
      _scope = $v.scope;
      _role = $v.role;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthTokenResponseDtoOutput other) {
    _$v = other as _$AuthTokenResponseDtoOutput;
  }

  @override
  void update(void Function(AuthTokenResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthTokenResponseDtoOutput build() => _build();

  _$AuthTokenResponseDtoOutput _build() {
    final _$result = _$v ??
        _$AuthTokenResponseDtoOutput._(
          accessToken: BuiltValueNullFieldError.checkNotNull(
              accessToken, r'AuthTokenResponseDtoOutput', 'accessToken'),
          tokenType: BuiltValueNullFieldError.checkNotNull(
              tokenType, r'AuthTokenResponseDtoOutput', 'tokenType'),
          expiresIn: BuiltValueNullFieldError.checkNotNull(
              expiresIn, r'AuthTokenResponseDtoOutput', 'expiresIn'),
          scope: BuiltValueNullFieldError.checkNotNull(
              scope, r'AuthTokenResponseDtoOutput', 'scope'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'AuthTokenResponseDtoOutput', 'role'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
