// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_challenge_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MfaChallengeResponseMfaRequiredEnum
    _$mfaChallengeResponseMfaRequiredEnum_true_ =
    const MfaChallengeResponseMfaRequiredEnum._('true_');

MfaChallengeResponseMfaRequiredEnum
    _$mfaChallengeResponseMfaRequiredEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$mfaChallengeResponseMfaRequiredEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MfaChallengeResponseMfaRequiredEnum>
    _$mfaChallengeResponseMfaRequiredEnumValues = BuiltSet<
        MfaChallengeResponseMfaRequiredEnum>(const <MfaChallengeResponseMfaRequiredEnum>[
  _$mfaChallengeResponseMfaRequiredEnum_true_,
]);

Serializer<MfaChallengeResponseMfaRequiredEnum>
    _$mfaChallengeResponseMfaRequiredEnumSerializer =
    _$MfaChallengeResponseMfaRequiredEnumSerializer();

class _$MfaChallengeResponseMfaRequiredEnumSerializer
    implements PrimitiveSerializer<MfaChallengeResponseMfaRequiredEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MfaChallengeResponseMfaRequiredEnum
  ];
  @override
  final String wireName = 'MfaChallengeResponseMfaRequiredEnum';

  @override
  Object serialize(
          Serializers serializers, MfaChallengeResponseMfaRequiredEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MfaChallengeResponseMfaRequiredEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MfaChallengeResponseMfaRequiredEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MfaChallengeResponse extends MfaChallengeResponse {
  @override
  final MfaChallengeResponseMfaRequiredEnum mfaRequired;
  @override
  final String challengeToken;
  @override
  final bool enrollmentRequired;
  @override
  final int challengeExpiresIn;
  @override
  final String? otpAuthUri;

  factory _$MfaChallengeResponse(
          [void Function(MfaChallengeResponseBuilder)? updates]) =>
      (MfaChallengeResponseBuilder()..update(updates))._build();

  _$MfaChallengeResponse._(
      {required this.mfaRequired,
      required this.challengeToken,
      required this.enrollmentRequired,
      required this.challengeExpiresIn,
      this.otpAuthUri})
      : super._();
  @override
  MfaChallengeResponse rebuild(
          void Function(MfaChallengeResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MfaChallengeResponseBuilder toBuilder() =>
      MfaChallengeResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaChallengeResponse &&
        mfaRequired == other.mfaRequired &&
        challengeToken == other.challengeToken &&
        enrollmentRequired == other.enrollmentRequired &&
        challengeExpiresIn == other.challengeExpiresIn &&
        otpAuthUri == other.otpAuthUri;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mfaRequired.hashCode);
    _$hash = $jc(_$hash, challengeToken.hashCode);
    _$hash = $jc(_$hash, enrollmentRequired.hashCode);
    _$hash = $jc(_$hash, challengeExpiresIn.hashCode);
    _$hash = $jc(_$hash, otpAuthUri.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaChallengeResponse')
          ..add('mfaRequired', mfaRequired)
          ..add('challengeToken', challengeToken)
          ..add('enrollmentRequired', enrollmentRequired)
          ..add('challengeExpiresIn', challengeExpiresIn)
          ..add('otpAuthUri', otpAuthUri))
        .toString();
  }
}

class MfaChallengeResponseBuilder
    implements Builder<MfaChallengeResponse, MfaChallengeResponseBuilder> {
  _$MfaChallengeResponse? _$v;

  MfaChallengeResponseMfaRequiredEnum? _mfaRequired;
  MfaChallengeResponseMfaRequiredEnum? get mfaRequired => _$this._mfaRequired;
  set mfaRequired(MfaChallengeResponseMfaRequiredEnum? mfaRequired) =>
      _$this._mfaRequired = mfaRequired;

  String? _challengeToken;
  String? get challengeToken => _$this._challengeToken;
  set challengeToken(String? challengeToken) =>
      _$this._challengeToken = challengeToken;

  bool? _enrollmentRequired;
  bool? get enrollmentRequired => _$this._enrollmentRequired;
  set enrollmentRequired(bool? enrollmentRequired) =>
      _$this._enrollmentRequired = enrollmentRequired;

  int? _challengeExpiresIn;
  int? get challengeExpiresIn => _$this._challengeExpiresIn;
  set challengeExpiresIn(int? challengeExpiresIn) =>
      _$this._challengeExpiresIn = challengeExpiresIn;

  String? _otpAuthUri;
  String? get otpAuthUri => _$this._otpAuthUri;
  set otpAuthUri(String? otpAuthUri) => _$this._otpAuthUri = otpAuthUri;

  MfaChallengeResponseBuilder() {
    MfaChallengeResponse._defaults(this);
  }

  MfaChallengeResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mfaRequired = $v.mfaRequired;
      _challengeToken = $v.challengeToken;
      _enrollmentRequired = $v.enrollmentRequired;
      _challengeExpiresIn = $v.challengeExpiresIn;
      _otpAuthUri = $v.otpAuthUri;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaChallengeResponse other) {
    _$v = other as _$MfaChallengeResponse;
  }

  @override
  void update(void Function(MfaChallengeResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaChallengeResponse build() => _build();

  _$MfaChallengeResponse _build() {
    final _$result = _$v ??
        _$MfaChallengeResponse._(
          mfaRequired: BuiltValueNullFieldError.checkNotNull(
              mfaRequired, r'MfaChallengeResponse', 'mfaRequired'),
          challengeToken: BuiltValueNullFieldError.checkNotNull(
              challengeToken, r'MfaChallengeResponse', 'challengeToken'),
          enrollmentRequired: BuiltValueNullFieldError.checkNotNull(
              enrollmentRequired,
              r'MfaChallengeResponse',
              'enrollmentRequired'),
          challengeExpiresIn: BuiltValueNullFieldError.checkNotNull(
              challengeExpiresIn,
              r'MfaChallengeResponse',
              'challengeExpiresIn'),
          otpAuthUri: otpAuthUri,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
