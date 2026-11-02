// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_loyalty_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PassengerLoyaltyDtoOutputStatusEnum
    _$passengerLoyaltyDtoOutputStatusEnum_ACTIVE =
    const PassengerLoyaltyDtoOutputStatusEnum._('ACTIVE');
const PassengerLoyaltyDtoOutputStatusEnum
    _$passengerLoyaltyDtoOutputStatusEnum_LOCKED =
    const PassengerLoyaltyDtoOutputStatusEnum._('LOCKED');
const PassengerLoyaltyDtoOutputStatusEnum
    _$passengerLoyaltyDtoOutputStatusEnum_DISABLED =
    const PassengerLoyaltyDtoOutputStatusEnum._('DISABLED');

PassengerLoyaltyDtoOutputStatusEnum
    _$passengerLoyaltyDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$passengerLoyaltyDtoOutputStatusEnum_ACTIVE;
    case 'LOCKED':
      return _$passengerLoyaltyDtoOutputStatusEnum_LOCKED;
    case 'DISABLED':
      return _$passengerLoyaltyDtoOutputStatusEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PassengerLoyaltyDtoOutputStatusEnum>
    _$passengerLoyaltyDtoOutputStatusEnumValues = BuiltSet<
        PassengerLoyaltyDtoOutputStatusEnum>(const <PassengerLoyaltyDtoOutputStatusEnum>[
  _$passengerLoyaltyDtoOutputStatusEnum_ACTIVE,
  _$passengerLoyaltyDtoOutputStatusEnum_LOCKED,
  _$passengerLoyaltyDtoOutputStatusEnum_DISABLED,
]);

const PassengerLoyaltyDtoOutputTierEnum
    _$passengerLoyaltyDtoOutputTierEnum_BRONZE =
    const PassengerLoyaltyDtoOutputTierEnum._('BRONZE');
const PassengerLoyaltyDtoOutputTierEnum
    _$passengerLoyaltyDtoOutputTierEnum_SILVER =
    const PassengerLoyaltyDtoOutputTierEnum._('SILVER');
const PassengerLoyaltyDtoOutputTierEnum
    _$passengerLoyaltyDtoOutputTierEnum_GOLD =
    const PassengerLoyaltyDtoOutputTierEnum._('GOLD');
const PassengerLoyaltyDtoOutputTierEnum
    _$passengerLoyaltyDtoOutputTierEnum_PLATINUM =
    const PassengerLoyaltyDtoOutputTierEnum._('PLATINUM');

PassengerLoyaltyDtoOutputTierEnum _$passengerLoyaltyDtoOutputTierEnumValueOf(
    String name) {
  switch (name) {
    case 'BRONZE':
      return _$passengerLoyaltyDtoOutputTierEnum_BRONZE;
    case 'SILVER':
      return _$passengerLoyaltyDtoOutputTierEnum_SILVER;
    case 'GOLD':
      return _$passengerLoyaltyDtoOutputTierEnum_GOLD;
    case 'PLATINUM':
      return _$passengerLoyaltyDtoOutputTierEnum_PLATINUM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PassengerLoyaltyDtoOutputTierEnum>
    _$passengerLoyaltyDtoOutputTierEnumValues = BuiltSet<
        PassengerLoyaltyDtoOutputTierEnum>(const <PassengerLoyaltyDtoOutputTierEnum>[
  _$passengerLoyaltyDtoOutputTierEnum_BRONZE,
  _$passengerLoyaltyDtoOutputTierEnum_SILVER,
  _$passengerLoyaltyDtoOutputTierEnum_GOLD,
  _$passengerLoyaltyDtoOutputTierEnum_PLATINUM,
]);

Serializer<PassengerLoyaltyDtoOutputStatusEnum>
    _$passengerLoyaltyDtoOutputStatusEnumSerializer =
    _$PassengerLoyaltyDtoOutputStatusEnumSerializer();
Serializer<PassengerLoyaltyDtoOutputTierEnum>
    _$passengerLoyaltyDtoOutputTierEnumSerializer =
    _$PassengerLoyaltyDtoOutputTierEnumSerializer();

class _$PassengerLoyaltyDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<PassengerLoyaltyDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'LOCKED': 'LOCKED',
    'DISABLED': 'DISABLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'LOCKED': 'LOCKED',
    'DISABLED': 'DISABLED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PassengerLoyaltyDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'PassengerLoyaltyDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, PassengerLoyaltyDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PassengerLoyaltyDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PassengerLoyaltyDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PassengerLoyaltyDtoOutputTierEnumSerializer
    implements PrimitiveSerializer<PassengerLoyaltyDtoOutputTierEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BRONZE': 'BRONZE',
    'SILVER': 'SILVER',
    'GOLD': 'GOLD',
    'PLATINUM': 'PLATINUM',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BRONZE': 'BRONZE',
    'SILVER': 'SILVER',
    'GOLD': 'GOLD',
    'PLATINUM': 'PLATINUM',
  };

  @override
  final Iterable<Type> types = const <Type>[PassengerLoyaltyDtoOutputTierEnum];
  @override
  final String wireName = 'PassengerLoyaltyDtoOutputTierEnum';

  @override
  Object serialize(
          Serializers serializers, PassengerLoyaltyDtoOutputTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PassengerLoyaltyDtoOutputTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PassengerLoyaltyDtoOutputTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PassengerLoyaltyDtoOutput extends PassengerLoyaltyDtoOutput {
  @override
  final String userId;
  @override
  final String? name;
  @override
  final String email;
  @override
  final PassengerLoyaltyDtoOutputStatusEnum status;
  @override
  final DateTime memberSince;
  @override
  final int availablePoints;
  @override
  final int earned12m;
  @override
  final PassengerLoyaltyDtoOutputTierEnum tier;
  @override
  final PassengerLoyaltyDtoOutputNextTier? nextTier;
  @override
  final int? policyVersion;
  @override
  final PassengerLoyaltyDtoOutputRules? rules;

  factory _$PassengerLoyaltyDtoOutput(
          [void Function(PassengerLoyaltyDtoOutputBuilder)? updates]) =>
      (PassengerLoyaltyDtoOutputBuilder()..update(updates))._build();

  _$PassengerLoyaltyDtoOutput._(
      {required this.userId,
      this.name,
      required this.email,
      required this.status,
      required this.memberSince,
      required this.availablePoints,
      required this.earned12m,
      required this.tier,
      this.nextTier,
      this.policyVersion,
      this.rules})
      : super._();
  @override
  PassengerLoyaltyDtoOutput rebuild(
          void Function(PassengerLoyaltyDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerLoyaltyDtoOutputBuilder toBuilder() =>
      PassengerLoyaltyDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerLoyaltyDtoOutput &&
        userId == other.userId &&
        name == other.name &&
        email == other.email &&
        status == other.status &&
        memberSince == other.memberSince &&
        availablePoints == other.availablePoints &&
        earned12m == other.earned12m &&
        tier == other.tier &&
        nextTier == other.nextTier &&
        policyVersion == other.policyVersion &&
        rules == other.rules;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, memberSince.hashCode);
    _$hash = $jc(_$hash, availablePoints.hashCode);
    _$hash = $jc(_$hash, earned12m.hashCode);
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jc(_$hash, nextTier.hashCode);
    _$hash = $jc(_$hash, policyVersion.hashCode);
    _$hash = $jc(_$hash, rules.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PassengerLoyaltyDtoOutput')
          ..add('userId', userId)
          ..add('name', name)
          ..add('email', email)
          ..add('status', status)
          ..add('memberSince', memberSince)
          ..add('availablePoints', availablePoints)
          ..add('earned12m', earned12m)
          ..add('tier', tier)
          ..add('nextTier', nextTier)
          ..add('policyVersion', policyVersion)
          ..add('rules', rules))
        .toString();
  }
}

class PassengerLoyaltyDtoOutputBuilder
    implements
        Builder<PassengerLoyaltyDtoOutput, PassengerLoyaltyDtoOutputBuilder> {
  _$PassengerLoyaltyDtoOutput? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  PassengerLoyaltyDtoOutputStatusEnum? _status;
  PassengerLoyaltyDtoOutputStatusEnum? get status => _$this._status;
  set status(PassengerLoyaltyDtoOutputStatusEnum? status) =>
      _$this._status = status;

  DateTime? _memberSince;
  DateTime? get memberSince => _$this._memberSince;
  set memberSince(DateTime? memberSince) => _$this._memberSince = memberSince;

  int? _availablePoints;
  int? get availablePoints => _$this._availablePoints;
  set availablePoints(int? availablePoints) =>
      _$this._availablePoints = availablePoints;

  int? _earned12m;
  int? get earned12m => _$this._earned12m;
  set earned12m(int? earned12m) => _$this._earned12m = earned12m;

  PassengerLoyaltyDtoOutputTierEnum? _tier;
  PassengerLoyaltyDtoOutputTierEnum? get tier => _$this._tier;
  set tier(PassengerLoyaltyDtoOutputTierEnum? tier) => _$this._tier = tier;

  PassengerLoyaltyDtoOutputNextTierBuilder? _nextTier;
  PassengerLoyaltyDtoOutputNextTierBuilder get nextTier =>
      _$this._nextTier ??= PassengerLoyaltyDtoOutputNextTierBuilder();
  set nextTier(PassengerLoyaltyDtoOutputNextTierBuilder? nextTier) =>
      _$this._nextTier = nextTier;

  int? _policyVersion;
  int? get policyVersion => _$this._policyVersion;
  set policyVersion(int? policyVersion) =>
      _$this._policyVersion = policyVersion;

  PassengerLoyaltyDtoOutputRulesBuilder? _rules;
  PassengerLoyaltyDtoOutputRulesBuilder get rules =>
      _$this._rules ??= PassengerLoyaltyDtoOutputRulesBuilder();
  set rules(PassengerLoyaltyDtoOutputRulesBuilder? rules) =>
      _$this._rules = rules;

  PassengerLoyaltyDtoOutputBuilder() {
    PassengerLoyaltyDtoOutput._defaults(this);
  }

  PassengerLoyaltyDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _name = $v.name;
      _email = $v.email;
      _status = $v.status;
      _memberSince = $v.memberSince;
      _availablePoints = $v.availablePoints;
      _earned12m = $v.earned12m;
      _tier = $v.tier;
      _nextTier = $v.nextTier?.toBuilder();
      _policyVersion = $v.policyVersion;
      _rules = $v.rules?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PassengerLoyaltyDtoOutput other) {
    _$v = other as _$PassengerLoyaltyDtoOutput;
  }

  @override
  void update(void Function(PassengerLoyaltyDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerLoyaltyDtoOutput build() => _build();

  _$PassengerLoyaltyDtoOutput _build() {
    _$PassengerLoyaltyDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PassengerLoyaltyDtoOutput._(
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'PassengerLoyaltyDtoOutput', 'userId'),
            name: name,
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'PassengerLoyaltyDtoOutput', 'email'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PassengerLoyaltyDtoOutput', 'status'),
            memberSince: BuiltValueNullFieldError.checkNotNull(
                memberSince, r'PassengerLoyaltyDtoOutput', 'memberSince'),
            availablePoints: BuiltValueNullFieldError.checkNotNull(
                availablePoints,
                r'PassengerLoyaltyDtoOutput',
                'availablePoints'),
            earned12m: BuiltValueNullFieldError.checkNotNull(
                earned12m, r'PassengerLoyaltyDtoOutput', 'earned12m'),
            tier: BuiltValueNullFieldError.checkNotNull(
                tier, r'PassengerLoyaltyDtoOutput', 'tier'),
            nextTier: _nextTier?.build(),
            policyVersion: policyVersion,
            rules: _rules?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'nextTier';
        _nextTier?.build();

        _$failedField = 'rules';
        _rules?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PassengerLoyaltyDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
