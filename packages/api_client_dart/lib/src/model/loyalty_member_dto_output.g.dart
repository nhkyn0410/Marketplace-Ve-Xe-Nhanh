// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_member_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LoyaltyMemberDtoOutputStatusEnum
    _$loyaltyMemberDtoOutputStatusEnum_ACTIVE =
    const LoyaltyMemberDtoOutputStatusEnum._('ACTIVE');
const LoyaltyMemberDtoOutputStatusEnum
    _$loyaltyMemberDtoOutputStatusEnum_LOCKED =
    const LoyaltyMemberDtoOutputStatusEnum._('LOCKED');
const LoyaltyMemberDtoOutputStatusEnum
    _$loyaltyMemberDtoOutputStatusEnum_DISABLED =
    const LoyaltyMemberDtoOutputStatusEnum._('DISABLED');

LoyaltyMemberDtoOutputStatusEnum _$loyaltyMemberDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ACTIVE':
      return _$loyaltyMemberDtoOutputStatusEnum_ACTIVE;
    case 'LOCKED':
      return _$loyaltyMemberDtoOutputStatusEnum_LOCKED;
    case 'DISABLED':
      return _$loyaltyMemberDtoOutputStatusEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LoyaltyMemberDtoOutputStatusEnum>
    _$loyaltyMemberDtoOutputStatusEnumValues = BuiltSet<
        LoyaltyMemberDtoOutputStatusEnum>(const <LoyaltyMemberDtoOutputStatusEnum>[
  _$loyaltyMemberDtoOutputStatusEnum_ACTIVE,
  _$loyaltyMemberDtoOutputStatusEnum_LOCKED,
  _$loyaltyMemberDtoOutputStatusEnum_DISABLED,
]);

const LoyaltyMemberDtoOutputTierEnum _$loyaltyMemberDtoOutputTierEnum_BRONZE =
    const LoyaltyMemberDtoOutputTierEnum._('BRONZE');
const LoyaltyMemberDtoOutputTierEnum _$loyaltyMemberDtoOutputTierEnum_SILVER =
    const LoyaltyMemberDtoOutputTierEnum._('SILVER');
const LoyaltyMemberDtoOutputTierEnum _$loyaltyMemberDtoOutputTierEnum_GOLD =
    const LoyaltyMemberDtoOutputTierEnum._('GOLD');
const LoyaltyMemberDtoOutputTierEnum _$loyaltyMemberDtoOutputTierEnum_PLATINUM =
    const LoyaltyMemberDtoOutputTierEnum._('PLATINUM');

LoyaltyMemberDtoOutputTierEnum _$loyaltyMemberDtoOutputTierEnumValueOf(
    String name) {
  switch (name) {
    case 'BRONZE':
      return _$loyaltyMemberDtoOutputTierEnum_BRONZE;
    case 'SILVER':
      return _$loyaltyMemberDtoOutputTierEnum_SILVER;
    case 'GOLD':
      return _$loyaltyMemberDtoOutputTierEnum_GOLD;
    case 'PLATINUM':
      return _$loyaltyMemberDtoOutputTierEnum_PLATINUM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LoyaltyMemberDtoOutputTierEnum>
    _$loyaltyMemberDtoOutputTierEnumValues = BuiltSet<
        LoyaltyMemberDtoOutputTierEnum>(const <LoyaltyMemberDtoOutputTierEnum>[
  _$loyaltyMemberDtoOutputTierEnum_BRONZE,
  _$loyaltyMemberDtoOutputTierEnum_SILVER,
  _$loyaltyMemberDtoOutputTierEnum_GOLD,
  _$loyaltyMemberDtoOutputTierEnum_PLATINUM,
]);

Serializer<LoyaltyMemberDtoOutputStatusEnum>
    _$loyaltyMemberDtoOutputStatusEnumSerializer =
    _$LoyaltyMemberDtoOutputStatusEnumSerializer();
Serializer<LoyaltyMemberDtoOutputTierEnum>
    _$loyaltyMemberDtoOutputTierEnumSerializer =
    _$LoyaltyMemberDtoOutputTierEnumSerializer();

class _$LoyaltyMemberDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<LoyaltyMemberDtoOutputStatusEnum> {
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
  final Iterable<Type> types = const <Type>[LoyaltyMemberDtoOutputStatusEnum];
  @override
  final String wireName = 'LoyaltyMemberDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, LoyaltyMemberDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LoyaltyMemberDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LoyaltyMemberDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LoyaltyMemberDtoOutputTierEnumSerializer
    implements PrimitiveSerializer<LoyaltyMemberDtoOutputTierEnum> {
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
  final Iterable<Type> types = const <Type>[LoyaltyMemberDtoOutputTierEnum];
  @override
  final String wireName = 'LoyaltyMemberDtoOutputTierEnum';

  @override
  Object serialize(
          Serializers serializers, LoyaltyMemberDtoOutputTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LoyaltyMemberDtoOutputTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LoyaltyMemberDtoOutputTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LoyaltyMemberDtoOutput extends LoyaltyMemberDtoOutput {
  @override
  final String userId;
  @override
  final String? name;
  @override
  final String email;
  @override
  final LoyaltyMemberDtoOutputStatusEnum status;
  @override
  final DateTime memberSince;
  @override
  final int availablePoints;
  @override
  final int earned12m;
  @override
  final LoyaltyMemberDtoOutputTierEnum tier;
  @override
  final LoyaltyMemberDtoOutputNextTier? nextTier;
  @override
  final int? policyVersion;

  factory _$LoyaltyMemberDtoOutput(
          [void Function(LoyaltyMemberDtoOutputBuilder)? updates]) =>
      (LoyaltyMemberDtoOutputBuilder()..update(updates))._build();

  _$LoyaltyMemberDtoOutput._(
      {required this.userId,
      this.name,
      required this.email,
      required this.status,
      required this.memberSince,
      required this.availablePoints,
      required this.earned12m,
      required this.tier,
      this.nextTier,
      this.policyVersion})
      : super._();
  @override
  LoyaltyMemberDtoOutput rebuild(
          void Function(LoyaltyMemberDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoyaltyMemberDtoOutputBuilder toBuilder() =>
      LoyaltyMemberDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoyaltyMemberDtoOutput &&
        userId == other.userId &&
        name == other.name &&
        email == other.email &&
        status == other.status &&
        memberSince == other.memberSince &&
        availablePoints == other.availablePoints &&
        earned12m == other.earned12m &&
        tier == other.tier &&
        nextTier == other.nextTier &&
        policyVersion == other.policyVersion;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoyaltyMemberDtoOutput')
          ..add('userId', userId)
          ..add('name', name)
          ..add('email', email)
          ..add('status', status)
          ..add('memberSince', memberSince)
          ..add('availablePoints', availablePoints)
          ..add('earned12m', earned12m)
          ..add('tier', tier)
          ..add('nextTier', nextTier)
          ..add('policyVersion', policyVersion))
        .toString();
  }
}

class LoyaltyMemberDtoOutputBuilder
    implements Builder<LoyaltyMemberDtoOutput, LoyaltyMemberDtoOutputBuilder> {
  _$LoyaltyMemberDtoOutput? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  LoyaltyMemberDtoOutputStatusEnum? _status;
  LoyaltyMemberDtoOutputStatusEnum? get status => _$this._status;
  set status(LoyaltyMemberDtoOutputStatusEnum? status) =>
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

  LoyaltyMemberDtoOutputTierEnum? _tier;
  LoyaltyMemberDtoOutputTierEnum? get tier => _$this._tier;
  set tier(LoyaltyMemberDtoOutputTierEnum? tier) => _$this._tier = tier;

  LoyaltyMemberDtoOutputNextTierBuilder? _nextTier;
  LoyaltyMemberDtoOutputNextTierBuilder get nextTier =>
      _$this._nextTier ??= LoyaltyMemberDtoOutputNextTierBuilder();
  set nextTier(LoyaltyMemberDtoOutputNextTierBuilder? nextTier) =>
      _$this._nextTier = nextTier;

  int? _policyVersion;
  int? get policyVersion => _$this._policyVersion;
  set policyVersion(int? policyVersion) =>
      _$this._policyVersion = policyVersion;

  LoyaltyMemberDtoOutputBuilder() {
    LoyaltyMemberDtoOutput._defaults(this);
  }

  LoyaltyMemberDtoOutputBuilder get _$this {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoyaltyMemberDtoOutput other) {
    _$v = other as _$LoyaltyMemberDtoOutput;
  }

  @override
  void update(void Function(LoyaltyMemberDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoyaltyMemberDtoOutput build() => _build();

  _$LoyaltyMemberDtoOutput _build() {
    _$LoyaltyMemberDtoOutput _$result;
    try {
      _$result = _$v ??
          _$LoyaltyMemberDtoOutput._(
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'LoyaltyMemberDtoOutput', 'userId'),
            name: name,
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'LoyaltyMemberDtoOutput', 'email'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'LoyaltyMemberDtoOutput', 'status'),
            memberSince: BuiltValueNullFieldError.checkNotNull(
                memberSince, r'LoyaltyMemberDtoOutput', 'memberSince'),
            availablePoints: BuiltValueNullFieldError.checkNotNull(
                availablePoints, r'LoyaltyMemberDtoOutput', 'availablePoints'),
            earned12m: BuiltValueNullFieldError.checkNotNull(
                earned12m, r'LoyaltyMemberDtoOutput', 'earned12m'),
            tier: BuiltValueNullFieldError.checkNotNull(
                tier, r'LoyaltyMemberDtoOutput', 'tier'),
            nextTier: _nextTier?.build(),
            policyVersion: policyVersion,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'nextTier';
        _nextTier?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LoyaltyMemberDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
