// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_transaction_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum
    _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_EARN =
    const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum._('EARN');
const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum
    _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_REDEEM =
    const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum._('REDEEM');
const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum
    _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_EXPIRE =
    const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum._('EXPIRE');
const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum
    _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_ADJUST =
    const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum._('ADJUST');
const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum
    _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_REVERSAL =
    const LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum._('REVERSAL');

LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum
    _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'EARN':
      return _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_EARN;
    case 'REDEEM':
      return _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_REDEEM;
    case 'EXPIRE':
      return _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_EXPIRE;
    case 'ADJUST':
      return _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_ADJUST;
    case 'REVERSAL':
      return _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_REVERSAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum>
    _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnumValues = BuiltSet<
        LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum>(const <LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum>[
  _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_EARN,
  _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_REDEEM,
  _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_EXPIRE,
  _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_ADJUST,
  _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnum_REVERSAL,
]);

const LoyaltyTransactionPageDtoOutputItemsInnerTierEnum
    _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_BRONZE =
    const LoyaltyTransactionPageDtoOutputItemsInnerTierEnum._('BRONZE');
const LoyaltyTransactionPageDtoOutputItemsInnerTierEnum
    _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_SILVER =
    const LoyaltyTransactionPageDtoOutputItemsInnerTierEnum._('SILVER');
const LoyaltyTransactionPageDtoOutputItemsInnerTierEnum
    _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_GOLD =
    const LoyaltyTransactionPageDtoOutputItemsInnerTierEnum._('GOLD');
const LoyaltyTransactionPageDtoOutputItemsInnerTierEnum
    _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_PLATINUM =
    const LoyaltyTransactionPageDtoOutputItemsInnerTierEnum._('PLATINUM');

LoyaltyTransactionPageDtoOutputItemsInnerTierEnum
    _$loyaltyTransactionPageDtoOutputItemsInnerTierEnumValueOf(String name) {
  switch (name) {
    case 'BRONZE':
      return _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_BRONZE;
    case 'SILVER':
      return _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_SILVER;
    case 'GOLD':
      return _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_GOLD;
    case 'PLATINUM':
      return _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_PLATINUM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LoyaltyTransactionPageDtoOutputItemsInnerTierEnum>
    _$loyaltyTransactionPageDtoOutputItemsInnerTierEnumValues = BuiltSet<
        LoyaltyTransactionPageDtoOutputItemsInnerTierEnum>(const <LoyaltyTransactionPageDtoOutputItemsInnerTierEnum>[
  _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_BRONZE,
  _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_SILVER,
  _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_GOLD,
  _$loyaltyTransactionPageDtoOutputItemsInnerTierEnum_PLATINUM,
]);

Serializer<LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum>
    _$loyaltyTransactionPageDtoOutputItemsInnerTypeEnumSerializer =
    _$LoyaltyTransactionPageDtoOutputItemsInnerTypeEnumSerializer();
Serializer<LoyaltyTransactionPageDtoOutputItemsInnerTierEnum>
    _$loyaltyTransactionPageDtoOutputItemsInnerTierEnumSerializer =
    _$LoyaltyTransactionPageDtoOutputItemsInnerTierEnumSerializer();

class _$LoyaltyTransactionPageDtoOutputItemsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'EARN': 'EARN',
    'REDEEM': 'REDEEM',
    'EXPIRE': 'EXPIRE',
    'ADJUST': 'ADJUST',
    'REVERSAL': 'REVERSAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'EARN': 'EARN',
    'REDEEM': 'REDEEM',
    'EXPIRE': 'EXPIRE',
    'ADJUST': 'ADJUST',
    'REVERSAL': 'REVERSAL',
  };

  @override
  final Iterable<Type> types = const <Type>[
    LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum
  ];
  @override
  final String wireName = 'LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LoyaltyTransactionPageDtoOutputItemsInnerTierEnumSerializer
    implements
        PrimitiveSerializer<LoyaltyTransactionPageDtoOutputItemsInnerTierEnum> {
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
  final Iterable<Type> types = const <Type>[
    LoyaltyTransactionPageDtoOutputItemsInnerTierEnum
  ];
  @override
  final String wireName = 'LoyaltyTransactionPageDtoOutputItemsInnerTierEnum';

  @override
  Object serialize(Serializers serializers,
          LoyaltyTransactionPageDtoOutputItemsInnerTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LoyaltyTransactionPageDtoOutputItemsInnerTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LoyaltyTransactionPageDtoOutputItemsInnerTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LoyaltyTransactionPageDtoOutputItemsInner
    extends LoyaltyTransactionPageDtoOutputItemsInner {
  @override
  final String id;
  @override
  final LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum type;
  @override
  final int points;
  @override
  final LoyaltyTransactionPageDtoOutputItemsInnerTierEnum tier;
  @override
  final String sourceLabel;
  @override
  final String? reason;
  @override
  final int? policyVersion;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime createdAt;

  factory _$LoyaltyTransactionPageDtoOutputItemsInner(
          [void Function(LoyaltyTransactionPageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (LoyaltyTransactionPageDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$LoyaltyTransactionPageDtoOutputItemsInner._(
      {required this.id,
      required this.type,
      required this.points,
      required this.tier,
      required this.sourceLabel,
      this.reason,
      this.policyVersion,
      this.expiresAt,
      required this.createdAt})
      : super._();
  @override
  LoyaltyTransactionPageDtoOutputItemsInner rebuild(
          void Function(LoyaltyTransactionPageDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoyaltyTransactionPageDtoOutputItemsInnerBuilder toBuilder() =>
      LoyaltyTransactionPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoyaltyTransactionPageDtoOutputItemsInner &&
        id == other.id &&
        type == other.type &&
        points == other.points &&
        tier == other.tier &&
        sourceLabel == other.sourceLabel &&
        reason == other.reason &&
        policyVersion == other.policyVersion &&
        expiresAt == other.expiresAt &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jc(_$hash, sourceLabel.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, policyVersion.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'LoyaltyTransactionPageDtoOutputItemsInner')
          ..add('id', id)
          ..add('type', type)
          ..add('points', points)
          ..add('tier', tier)
          ..add('sourceLabel', sourceLabel)
          ..add('reason', reason)
          ..add('policyVersion', policyVersion)
          ..add('expiresAt', expiresAt)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class LoyaltyTransactionPageDtoOutputItemsInnerBuilder
    implements
        Builder<LoyaltyTransactionPageDtoOutputItemsInner,
            LoyaltyTransactionPageDtoOutputItemsInnerBuilder> {
  _$LoyaltyTransactionPageDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum? _type;
  LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum? get type => _$this._type;
  set type(LoyaltyTransactionPageDtoOutputItemsInnerTypeEnum? type) =>
      _$this._type = type;

  int? _points;
  int? get points => _$this._points;
  set points(int? points) => _$this._points = points;

  LoyaltyTransactionPageDtoOutputItemsInnerTierEnum? _tier;
  LoyaltyTransactionPageDtoOutputItemsInnerTierEnum? get tier => _$this._tier;
  set tier(LoyaltyTransactionPageDtoOutputItemsInnerTierEnum? tier) =>
      _$this._tier = tier;

  String? _sourceLabel;
  String? get sourceLabel => _$this._sourceLabel;
  set sourceLabel(String? sourceLabel) => _$this._sourceLabel = sourceLabel;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  int? _policyVersion;
  int? get policyVersion => _$this._policyVersion;
  set policyVersion(int? policyVersion) =>
      _$this._policyVersion = policyVersion;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  LoyaltyTransactionPageDtoOutputItemsInnerBuilder() {
    LoyaltyTransactionPageDtoOutputItemsInner._defaults(this);
  }

  LoyaltyTransactionPageDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _points = $v.points;
      _tier = $v.tier;
      _sourceLabel = $v.sourceLabel;
      _reason = $v.reason;
      _policyVersion = $v.policyVersion;
      _expiresAt = $v.expiresAt;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoyaltyTransactionPageDtoOutputItemsInner other) {
    _$v = other as _$LoyaltyTransactionPageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(LoyaltyTransactionPageDtoOutputItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  LoyaltyTransactionPageDtoOutputItemsInner build() => _build();

  _$LoyaltyTransactionPageDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$LoyaltyTransactionPageDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'LoyaltyTransactionPageDtoOutputItemsInner', 'id'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'LoyaltyTransactionPageDtoOutputItemsInner', 'type'),
          points: BuiltValueNullFieldError.checkNotNull(
              points, r'LoyaltyTransactionPageDtoOutputItemsInner', 'points'),
          tier: BuiltValueNullFieldError.checkNotNull(
              tier, r'LoyaltyTransactionPageDtoOutputItemsInner', 'tier'),
          sourceLabel: BuiltValueNullFieldError.checkNotNull(sourceLabel,
              r'LoyaltyTransactionPageDtoOutputItemsInner', 'sourceLabel'),
          reason: reason,
          policyVersion: policyVersion,
          expiresAt: expiresAt,
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'LoyaltyTransactionPageDtoOutputItemsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
