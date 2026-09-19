// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_verify_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MfaVerifyResponseDtoOutputTokenTypeEnum
    _$mfaVerifyResponseDtoOutputTokenTypeEnum_bearer =
    const MfaVerifyResponseDtoOutputTokenTypeEnum._('bearer');

MfaVerifyResponseDtoOutputTokenTypeEnum
    _$mfaVerifyResponseDtoOutputTokenTypeEnumValueOf(String name) {
  switch (name) {
    case 'bearer':
      return _$mfaVerifyResponseDtoOutputTokenTypeEnum_bearer;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MfaVerifyResponseDtoOutputTokenTypeEnum>
    _$mfaVerifyResponseDtoOutputTokenTypeEnumValues = BuiltSet<
        MfaVerifyResponseDtoOutputTokenTypeEnum>(const <MfaVerifyResponseDtoOutputTokenTypeEnum>[
  _$mfaVerifyResponseDtoOutputTokenTypeEnum_bearer,
]);

const MfaVerifyResponseDtoOutputScopeEnum
    _$mfaVerifyResponseDtoOutputScopeEnum_passenger =
    const MfaVerifyResponseDtoOutputScopeEnum._('passenger');
const MfaVerifyResponseDtoOutputScopeEnum
    _$mfaVerifyResponseDtoOutputScopeEnum_operator_ =
    const MfaVerifyResponseDtoOutputScopeEnum._('operator_');
const MfaVerifyResponseDtoOutputScopeEnum
    _$mfaVerifyResponseDtoOutputScopeEnum_platform =
    const MfaVerifyResponseDtoOutputScopeEnum._('platform');

MfaVerifyResponseDtoOutputScopeEnum
    _$mfaVerifyResponseDtoOutputScopeEnumValueOf(String name) {
  switch (name) {
    case 'passenger':
      return _$mfaVerifyResponseDtoOutputScopeEnum_passenger;
    case 'operator_':
      return _$mfaVerifyResponseDtoOutputScopeEnum_operator_;
    case 'platform':
      return _$mfaVerifyResponseDtoOutputScopeEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MfaVerifyResponseDtoOutputScopeEnum>
    _$mfaVerifyResponseDtoOutputScopeEnumValues = BuiltSet<
        MfaVerifyResponseDtoOutputScopeEnum>(const <MfaVerifyResponseDtoOutputScopeEnum>[
  _$mfaVerifyResponseDtoOutputScopeEnum_passenger,
  _$mfaVerifyResponseDtoOutputScopeEnum_operator_,
  _$mfaVerifyResponseDtoOutputScopeEnum_platform,
]);

const MfaVerifyResponseDtoOutputMfaRequiredEnum
    _$mfaVerifyResponseDtoOutputMfaRequiredEnum_false_ =
    const MfaVerifyResponseDtoOutputMfaRequiredEnum._('false_');

MfaVerifyResponseDtoOutputMfaRequiredEnum
    _$mfaVerifyResponseDtoOutputMfaRequiredEnumValueOf(String name) {
  switch (name) {
    case 'false_':
      return _$mfaVerifyResponseDtoOutputMfaRequiredEnum_false_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MfaVerifyResponseDtoOutputMfaRequiredEnum>
    _$mfaVerifyResponseDtoOutputMfaRequiredEnumValues = BuiltSet<
        MfaVerifyResponseDtoOutputMfaRequiredEnum>(const <MfaVerifyResponseDtoOutputMfaRequiredEnum>[
  _$mfaVerifyResponseDtoOutputMfaRequiredEnum_false_,
]);

Serializer<MfaVerifyResponseDtoOutputTokenTypeEnum>
    _$mfaVerifyResponseDtoOutputTokenTypeEnumSerializer =
    _$MfaVerifyResponseDtoOutputTokenTypeEnumSerializer();
Serializer<MfaVerifyResponseDtoOutputScopeEnum>
    _$mfaVerifyResponseDtoOutputScopeEnumSerializer =
    _$MfaVerifyResponseDtoOutputScopeEnumSerializer();
Serializer<MfaVerifyResponseDtoOutputMfaRequiredEnum>
    _$mfaVerifyResponseDtoOutputMfaRequiredEnumSerializer =
    _$MfaVerifyResponseDtoOutputMfaRequiredEnumSerializer();

class _$MfaVerifyResponseDtoOutputTokenTypeEnumSerializer
    implements PrimitiveSerializer<MfaVerifyResponseDtoOutputTokenTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'bearer': 'Bearer',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Bearer': 'bearer',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MfaVerifyResponseDtoOutputTokenTypeEnum
  ];
  @override
  final String wireName = 'MfaVerifyResponseDtoOutputTokenTypeEnum';

  @override
  Object serialize(Serializers serializers,
          MfaVerifyResponseDtoOutputTokenTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MfaVerifyResponseDtoOutputTokenTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MfaVerifyResponseDtoOutputTokenTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MfaVerifyResponseDtoOutputScopeEnumSerializer
    implements PrimitiveSerializer<MfaVerifyResponseDtoOutputScopeEnum> {
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
    MfaVerifyResponseDtoOutputScopeEnum
  ];
  @override
  final String wireName = 'MfaVerifyResponseDtoOutputScopeEnum';

  @override
  Object serialize(
          Serializers serializers, MfaVerifyResponseDtoOutputScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MfaVerifyResponseDtoOutputScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MfaVerifyResponseDtoOutputScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MfaVerifyResponseDtoOutputMfaRequiredEnumSerializer
    implements PrimitiveSerializer<MfaVerifyResponseDtoOutputMfaRequiredEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'false_': 'false',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'false': 'false_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MfaVerifyResponseDtoOutputMfaRequiredEnum
  ];
  @override
  final String wireName = 'MfaVerifyResponseDtoOutputMfaRequiredEnum';

  @override
  Object serialize(Serializers serializers,
          MfaVerifyResponseDtoOutputMfaRequiredEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MfaVerifyResponseDtoOutputMfaRequiredEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MfaVerifyResponseDtoOutputMfaRequiredEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MfaVerifyResponseDtoOutput extends MfaVerifyResponseDtoOutput {
  @override
  final String accessToken;
  @override
  final MfaVerifyResponseDtoOutputTokenTypeEnum tokenType;
  @override
  final int expiresIn;
  @override
  final MfaVerifyResponseDtoOutputScopeEnum scope;
  @override
  final String role;
  @override
  final String refreshToken;
  @override
  final int refreshExpiresIn;
  @override
  final MfaVerifyResponseDtoOutputMfaRequiredEnum mfaRequired;
  @override
  final BuiltList<String>? backupCodes;

  factory _$MfaVerifyResponseDtoOutput(
          [void Function(MfaVerifyResponseDtoOutputBuilder)? updates]) =>
      (MfaVerifyResponseDtoOutputBuilder()..update(updates))._build();

  _$MfaVerifyResponseDtoOutput._(
      {required this.accessToken,
      required this.tokenType,
      required this.expiresIn,
      required this.scope,
      required this.role,
      required this.refreshToken,
      required this.refreshExpiresIn,
      required this.mfaRequired,
      this.backupCodes})
      : super._();
  @override
  MfaVerifyResponseDtoOutput rebuild(
          void Function(MfaVerifyResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MfaVerifyResponseDtoOutputBuilder toBuilder() =>
      MfaVerifyResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaVerifyResponseDtoOutput &&
        accessToken == other.accessToken &&
        tokenType == other.tokenType &&
        expiresIn == other.expiresIn &&
        scope == other.scope &&
        role == other.role &&
        refreshToken == other.refreshToken &&
        refreshExpiresIn == other.refreshExpiresIn &&
        mfaRequired == other.mfaRequired &&
        backupCodes == other.backupCodes;
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
    _$hash = $jc(_$hash, backupCodes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaVerifyResponseDtoOutput')
          ..add('accessToken', accessToken)
          ..add('tokenType', tokenType)
          ..add('expiresIn', expiresIn)
          ..add('scope', scope)
          ..add('role', role)
          ..add('refreshToken', refreshToken)
          ..add('refreshExpiresIn', refreshExpiresIn)
          ..add('mfaRequired', mfaRequired)
          ..add('backupCodes', backupCodes))
        .toString();
  }
}

class MfaVerifyResponseDtoOutputBuilder
    implements
        Builder<MfaVerifyResponseDtoOutput, MfaVerifyResponseDtoOutputBuilder> {
  _$MfaVerifyResponseDtoOutput? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  MfaVerifyResponseDtoOutputTokenTypeEnum? _tokenType;
  MfaVerifyResponseDtoOutputTokenTypeEnum? get tokenType => _$this._tokenType;
  set tokenType(MfaVerifyResponseDtoOutputTokenTypeEnum? tokenType) =>
      _$this._tokenType = tokenType;

  int? _expiresIn;
  int? get expiresIn => _$this._expiresIn;
  set expiresIn(int? expiresIn) => _$this._expiresIn = expiresIn;

  MfaVerifyResponseDtoOutputScopeEnum? _scope;
  MfaVerifyResponseDtoOutputScopeEnum? get scope => _$this._scope;
  set scope(MfaVerifyResponseDtoOutputScopeEnum? scope) =>
      _$this._scope = scope;

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

  MfaVerifyResponseDtoOutputMfaRequiredEnum? _mfaRequired;
  MfaVerifyResponseDtoOutputMfaRequiredEnum? get mfaRequired =>
      _$this._mfaRequired;
  set mfaRequired(MfaVerifyResponseDtoOutputMfaRequiredEnum? mfaRequired) =>
      _$this._mfaRequired = mfaRequired;

  ListBuilder<String>? _backupCodes;
  ListBuilder<String> get backupCodes =>
      _$this._backupCodes ??= ListBuilder<String>();
  set backupCodes(ListBuilder<String>? backupCodes) =>
      _$this._backupCodes = backupCodes;

  MfaVerifyResponseDtoOutputBuilder() {
    MfaVerifyResponseDtoOutput._defaults(this);
  }

  MfaVerifyResponseDtoOutputBuilder get _$this {
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
      _backupCodes = $v.backupCodes?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaVerifyResponseDtoOutput other) {
    _$v = other as _$MfaVerifyResponseDtoOutput;
  }

  @override
  void update(void Function(MfaVerifyResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaVerifyResponseDtoOutput build() => _build();

  _$MfaVerifyResponseDtoOutput _build() {
    _$MfaVerifyResponseDtoOutput _$result;
    try {
      _$result = _$v ??
          _$MfaVerifyResponseDtoOutput._(
            accessToken: BuiltValueNullFieldError.checkNotNull(
                accessToken, r'MfaVerifyResponseDtoOutput', 'accessToken'),
            tokenType: BuiltValueNullFieldError.checkNotNull(
                tokenType, r'MfaVerifyResponseDtoOutput', 'tokenType'),
            expiresIn: BuiltValueNullFieldError.checkNotNull(
                expiresIn, r'MfaVerifyResponseDtoOutput', 'expiresIn'),
            scope: BuiltValueNullFieldError.checkNotNull(
                scope, r'MfaVerifyResponseDtoOutput', 'scope'),
            role: BuiltValueNullFieldError.checkNotNull(
                role, r'MfaVerifyResponseDtoOutput', 'role'),
            refreshToken: BuiltValueNullFieldError.checkNotNull(
                refreshToken, r'MfaVerifyResponseDtoOutput', 'refreshToken'),
            refreshExpiresIn: BuiltValueNullFieldError.checkNotNull(
                refreshExpiresIn,
                r'MfaVerifyResponseDtoOutput',
                'refreshExpiresIn'),
            mfaRequired: BuiltValueNullFieldError.checkNotNull(
                mfaRequired, r'MfaVerifyResponseDtoOutput', 'mfaRequired'),
            backupCodes: _backupCodes?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'backupCodes';
        _backupCodes?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MfaVerifyResponseDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
