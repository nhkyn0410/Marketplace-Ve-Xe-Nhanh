// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_token_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CredentialTokenResponseTokenTypeEnum
    _$credentialTokenResponseTokenTypeEnum_bearer =
    const CredentialTokenResponseTokenTypeEnum._('bearer');

CredentialTokenResponseTokenTypeEnum
    _$credentialTokenResponseTokenTypeEnumValueOf(String name) {
  switch (name) {
    case 'bearer':
      return _$credentialTokenResponseTokenTypeEnum_bearer;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CredentialTokenResponseTokenTypeEnum>
    _$credentialTokenResponseTokenTypeEnumValues = BuiltSet<
        CredentialTokenResponseTokenTypeEnum>(const <CredentialTokenResponseTokenTypeEnum>[
  _$credentialTokenResponseTokenTypeEnum_bearer,
]);

const CredentialTokenResponseScopeEnum
    _$credentialTokenResponseScopeEnum_passenger =
    const CredentialTokenResponseScopeEnum._('passenger');
const CredentialTokenResponseScopeEnum
    _$credentialTokenResponseScopeEnum_operator_ =
    const CredentialTokenResponseScopeEnum._('operator_');
const CredentialTokenResponseScopeEnum
    _$credentialTokenResponseScopeEnum_platform =
    const CredentialTokenResponseScopeEnum._('platform');

CredentialTokenResponseScopeEnum _$credentialTokenResponseScopeEnumValueOf(
    String name) {
  switch (name) {
    case 'passenger':
      return _$credentialTokenResponseScopeEnum_passenger;
    case 'operator_':
      return _$credentialTokenResponseScopeEnum_operator_;
    case 'platform':
      return _$credentialTokenResponseScopeEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CredentialTokenResponseScopeEnum>
    _$credentialTokenResponseScopeEnumValues = BuiltSet<
        CredentialTokenResponseScopeEnum>(const <CredentialTokenResponseScopeEnum>[
  _$credentialTokenResponseScopeEnum_passenger,
  _$credentialTokenResponseScopeEnum_operator_,
  _$credentialTokenResponseScopeEnum_platform,
]);

const CredentialTokenResponseMfaRequiredEnum
    _$credentialTokenResponseMfaRequiredEnum_false_ =
    const CredentialTokenResponseMfaRequiredEnum._('false_');

CredentialTokenResponseMfaRequiredEnum
    _$credentialTokenResponseMfaRequiredEnumValueOf(String name) {
  switch (name) {
    case 'false_':
      return _$credentialTokenResponseMfaRequiredEnum_false_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CredentialTokenResponseMfaRequiredEnum>
    _$credentialTokenResponseMfaRequiredEnumValues = BuiltSet<
        CredentialTokenResponseMfaRequiredEnum>(const <CredentialTokenResponseMfaRequiredEnum>[
  _$credentialTokenResponseMfaRequiredEnum_false_,
]);

Serializer<CredentialTokenResponseTokenTypeEnum>
    _$credentialTokenResponseTokenTypeEnumSerializer =
    _$CredentialTokenResponseTokenTypeEnumSerializer();
Serializer<CredentialTokenResponseScopeEnum>
    _$credentialTokenResponseScopeEnumSerializer =
    _$CredentialTokenResponseScopeEnumSerializer();
Serializer<CredentialTokenResponseMfaRequiredEnum>
    _$credentialTokenResponseMfaRequiredEnumSerializer =
    _$CredentialTokenResponseMfaRequiredEnumSerializer();

class _$CredentialTokenResponseTokenTypeEnumSerializer
    implements PrimitiveSerializer<CredentialTokenResponseTokenTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'bearer': 'Bearer',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Bearer': 'bearer',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CredentialTokenResponseTokenTypeEnum
  ];
  @override
  final String wireName = 'CredentialTokenResponseTokenTypeEnum';

  @override
  Object serialize(
          Serializers serializers, CredentialTokenResponseTokenTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CredentialTokenResponseTokenTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CredentialTokenResponseTokenTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CredentialTokenResponseScopeEnumSerializer
    implements PrimitiveSerializer<CredentialTokenResponseScopeEnum> {
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
  final Iterable<Type> types = const <Type>[CredentialTokenResponseScopeEnum];
  @override
  final String wireName = 'CredentialTokenResponseScopeEnum';

  @override
  Object serialize(
          Serializers serializers, CredentialTokenResponseScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CredentialTokenResponseScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CredentialTokenResponseScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CredentialTokenResponseMfaRequiredEnumSerializer
    implements PrimitiveSerializer<CredentialTokenResponseMfaRequiredEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'false_': 'false',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'false': 'false_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CredentialTokenResponseMfaRequiredEnum
  ];
  @override
  final String wireName = 'CredentialTokenResponseMfaRequiredEnum';

  @override
  Object serialize(Serializers serializers,
          CredentialTokenResponseMfaRequiredEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CredentialTokenResponseMfaRequiredEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CredentialTokenResponseMfaRequiredEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CredentialTokenResponse extends CredentialTokenResponse {
  @override
  final String accessToken;
  @override
  final CredentialTokenResponseTokenTypeEnum tokenType;
  @override
  final int expiresIn;
  @override
  final CredentialTokenResponseScopeEnum scope;
  @override
  final String role;
  @override
  final String refreshToken;
  @override
  final int refreshExpiresIn;
  @override
  final CredentialTokenResponseMfaRequiredEnum mfaRequired;

  factory _$CredentialTokenResponse(
          [void Function(CredentialTokenResponseBuilder)? updates]) =>
      (CredentialTokenResponseBuilder()..update(updates))._build();

  _$CredentialTokenResponse._(
      {required this.accessToken,
      required this.tokenType,
      required this.expiresIn,
      required this.scope,
      required this.role,
      required this.refreshToken,
      required this.refreshExpiresIn,
      required this.mfaRequired})
      : super._();
  @override
  CredentialTokenResponse rebuild(
          void Function(CredentialTokenResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CredentialTokenResponseBuilder toBuilder() =>
      CredentialTokenResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CredentialTokenResponse &&
        accessToken == other.accessToken &&
        tokenType == other.tokenType &&
        expiresIn == other.expiresIn &&
        scope == other.scope &&
        role == other.role &&
        refreshToken == other.refreshToken &&
        refreshExpiresIn == other.refreshExpiresIn &&
        mfaRequired == other.mfaRequired;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, tokenType.hashCode);
    _$hash = $jc(_$hash, expiresIn.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, refreshExpiresIn.hashCode);
    _$hash = $jc(_$hash, mfaRequired.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CredentialTokenResponse')
          ..add('accessToken', accessToken)
          ..add('tokenType', tokenType)
          ..add('expiresIn', expiresIn)
          ..add('scope', scope)
          ..add('role', role)
          ..add('refreshToken', refreshToken)
          ..add('refreshExpiresIn', refreshExpiresIn)
          ..add('mfaRequired', mfaRequired))
        .toString();
  }
}

class CredentialTokenResponseBuilder
    implements
        Builder<CredentialTokenResponse, CredentialTokenResponseBuilder> {
  _$CredentialTokenResponse? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  CredentialTokenResponseTokenTypeEnum? _tokenType;
  CredentialTokenResponseTokenTypeEnum? get tokenType => _$this._tokenType;
  set tokenType(CredentialTokenResponseTokenTypeEnum? tokenType) =>
      _$this._tokenType = tokenType;

  int? _expiresIn;
  int? get expiresIn => _$this._expiresIn;
  set expiresIn(int? expiresIn) => _$this._expiresIn = expiresIn;

  CredentialTokenResponseScopeEnum? _scope;
  CredentialTokenResponseScopeEnum? get scope => _$this._scope;
  set scope(CredentialTokenResponseScopeEnum? scope) => _$this._scope = scope;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  int? _refreshExpiresIn;
  int? get refreshExpiresIn => _$this._refreshExpiresIn;
  set refreshExpiresIn(int? refreshExpiresIn) =>
      _$this._refreshExpiresIn = refreshExpiresIn;

  CredentialTokenResponseMfaRequiredEnum? _mfaRequired;
  CredentialTokenResponseMfaRequiredEnum? get mfaRequired =>
      _$this._mfaRequired;
  set mfaRequired(CredentialTokenResponseMfaRequiredEnum? mfaRequired) =>
      _$this._mfaRequired = mfaRequired;

  CredentialTokenResponseBuilder() {
    CredentialTokenResponse._defaults(this);
  }

  CredentialTokenResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessToken = $v.accessToken;
      _tokenType = $v.tokenType;
      _expiresIn = $v.expiresIn;
      _scope = $v.scope;
      _role = $v.role;
      _refreshToken = $v.refreshToken;
      _refreshExpiresIn = $v.refreshExpiresIn;
      _mfaRequired = $v.mfaRequired;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CredentialTokenResponse other) {
    _$v = other as _$CredentialTokenResponse;
  }

  @override
  void update(void Function(CredentialTokenResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CredentialTokenResponse build() => _build();

  _$CredentialTokenResponse _build() {
    final _$result = _$v ??
        _$CredentialTokenResponse._(
          accessToken: BuiltValueNullFieldError.checkNotNull(
              accessToken, r'CredentialTokenResponse', 'accessToken'),
          tokenType: BuiltValueNullFieldError.checkNotNull(
              tokenType, r'CredentialTokenResponse', 'tokenType'),
          expiresIn: BuiltValueNullFieldError.checkNotNull(
              expiresIn, r'CredentialTokenResponse', 'expiresIn'),
          scope: BuiltValueNullFieldError.checkNotNull(
              scope, r'CredentialTokenResponse', 'scope'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'CredentialTokenResponse', 'role'),
          refreshToken: BuiltValueNullFieldError.checkNotNull(
              refreshToken, r'CredentialTokenResponse', 'refreshToken'),
          refreshExpiresIn: BuiltValueNullFieldError.checkNotNull(
              refreshExpiresIn, r'CredentialTokenResponse', 'refreshExpiresIn'),
          mfaRequired: BuiltValueNullFieldError.checkNotNull(
              mfaRequired, r'CredentialTokenResponse', 'mfaRequired'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
