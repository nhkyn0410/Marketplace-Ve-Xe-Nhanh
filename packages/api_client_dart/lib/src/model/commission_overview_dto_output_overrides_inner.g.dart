// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_overview_dto_output_overrides_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CommissionOverviewDtoOutputOverridesInnerChannelEnum
    _$commissionOverviewDtoOutputOverridesInnerChannelEnum_ONLINE =
    const CommissionOverviewDtoOutputOverridesInnerChannelEnum._('ONLINE');
const CommissionOverviewDtoOutputOverridesInnerChannelEnum
    _$commissionOverviewDtoOutputOverridesInnerChannelEnum_COUNTER =
    const CommissionOverviewDtoOutputOverridesInnerChannelEnum._('COUNTER');

CommissionOverviewDtoOutputOverridesInnerChannelEnum
    _$commissionOverviewDtoOutputOverridesInnerChannelEnumValueOf(String name) {
  switch (name) {
    case 'ONLINE':
      return _$commissionOverviewDtoOutputOverridesInnerChannelEnum_ONLINE;
    case 'COUNTER':
      return _$commissionOverviewDtoOutputOverridesInnerChannelEnum_COUNTER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CommissionOverviewDtoOutputOverridesInnerChannelEnum>
    _$commissionOverviewDtoOutputOverridesInnerChannelEnumValues = BuiltSet<
        CommissionOverviewDtoOutputOverridesInnerChannelEnum>(const <CommissionOverviewDtoOutputOverridesInnerChannelEnum>[
  _$commissionOverviewDtoOutputOverridesInnerChannelEnum_ONLINE,
  _$commissionOverviewDtoOutputOverridesInnerChannelEnum_COUNTER,
]);

const CommissionOverviewDtoOutputOverridesInnerStatusEnum
    _$commissionOverviewDtoOutputOverridesInnerStatusEnum_ACTIVE =
    const CommissionOverviewDtoOutputOverridesInnerStatusEnum._('ACTIVE');
const CommissionOverviewDtoOutputOverridesInnerStatusEnum
    _$commissionOverviewDtoOutputOverridesInnerStatusEnum_CANCELLED =
    const CommissionOverviewDtoOutputOverridesInnerStatusEnum._('CANCELLED');

CommissionOverviewDtoOutputOverridesInnerStatusEnum
    _$commissionOverviewDtoOutputOverridesInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$commissionOverviewDtoOutputOverridesInnerStatusEnum_ACTIVE;
    case 'CANCELLED':
      return _$commissionOverviewDtoOutputOverridesInnerStatusEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CommissionOverviewDtoOutputOverridesInnerStatusEnum>
    _$commissionOverviewDtoOutputOverridesInnerStatusEnumValues = BuiltSet<
        CommissionOverviewDtoOutputOverridesInnerStatusEnum>(const <CommissionOverviewDtoOutputOverridesInnerStatusEnum>[
  _$commissionOverviewDtoOutputOverridesInnerStatusEnum_ACTIVE,
  _$commissionOverviewDtoOutputOverridesInnerStatusEnum_CANCELLED,
]);

const CommissionOverviewDtoOutputOverridesInnerStateEnum
    _$commissionOverviewDtoOutputOverridesInnerStateEnum_SCHEDULED =
    const CommissionOverviewDtoOutputOverridesInnerStateEnum._('SCHEDULED');
const CommissionOverviewDtoOutputOverridesInnerStateEnum
    _$commissionOverviewDtoOutputOverridesInnerStateEnum_ACTIVE =
    const CommissionOverviewDtoOutputOverridesInnerStateEnum._('ACTIVE');
const CommissionOverviewDtoOutputOverridesInnerStateEnum
    _$commissionOverviewDtoOutputOverridesInnerStateEnum_EXPIRED =
    const CommissionOverviewDtoOutputOverridesInnerStateEnum._('EXPIRED');
const CommissionOverviewDtoOutputOverridesInnerStateEnum
    _$commissionOverviewDtoOutputOverridesInnerStateEnum_CANCELLED =
    const CommissionOverviewDtoOutputOverridesInnerStateEnum._('CANCELLED');

CommissionOverviewDtoOutputOverridesInnerStateEnum
    _$commissionOverviewDtoOutputOverridesInnerStateEnumValueOf(String name) {
  switch (name) {
    case 'SCHEDULED':
      return _$commissionOverviewDtoOutputOverridesInnerStateEnum_SCHEDULED;
    case 'ACTIVE':
      return _$commissionOverviewDtoOutputOverridesInnerStateEnum_ACTIVE;
    case 'EXPIRED':
      return _$commissionOverviewDtoOutputOverridesInnerStateEnum_EXPIRED;
    case 'CANCELLED':
      return _$commissionOverviewDtoOutputOverridesInnerStateEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CommissionOverviewDtoOutputOverridesInnerStateEnum>
    _$commissionOverviewDtoOutputOverridesInnerStateEnumValues = BuiltSet<
        CommissionOverviewDtoOutputOverridesInnerStateEnum>(const <CommissionOverviewDtoOutputOverridesInnerStateEnum>[
  _$commissionOverviewDtoOutputOverridesInnerStateEnum_SCHEDULED,
  _$commissionOverviewDtoOutputOverridesInnerStateEnum_ACTIVE,
  _$commissionOverviewDtoOutputOverridesInnerStateEnum_EXPIRED,
  _$commissionOverviewDtoOutputOverridesInnerStateEnum_CANCELLED,
]);

Serializer<CommissionOverviewDtoOutputOverridesInnerChannelEnum>
    _$commissionOverviewDtoOutputOverridesInnerChannelEnumSerializer =
    _$CommissionOverviewDtoOutputOverridesInnerChannelEnumSerializer();
Serializer<CommissionOverviewDtoOutputOverridesInnerStatusEnum>
    _$commissionOverviewDtoOutputOverridesInnerStatusEnumSerializer =
    _$CommissionOverviewDtoOutputOverridesInnerStatusEnumSerializer();
Serializer<CommissionOverviewDtoOutputOverridesInnerStateEnum>
    _$commissionOverviewDtoOutputOverridesInnerStateEnumSerializer =
    _$CommissionOverviewDtoOutputOverridesInnerStateEnumSerializer();

class _$CommissionOverviewDtoOutputOverridesInnerChannelEnumSerializer
    implements
        PrimitiveSerializer<
            CommissionOverviewDtoOutputOverridesInnerChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ONLINE': 'ONLINE',
    'COUNTER': 'COUNTER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ONLINE': 'ONLINE',
    'COUNTER': 'COUNTER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CommissionOverviewDtoOutputOverridesInnerChannelEnum
  ];
  @override
  final String wireName =
      'CommissionOverviewDtoOutputOverridesInnerChannelEnum';

  @override
  Object serialize(Serializers serializers,
          CommissionOverviewDtoOutputOverridesInnerChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CommissionOverviewDtoOutputOverridesInnerChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CommissionOverviewDtoOutputOverridesInnerChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CommissionOverviewDtoOutputOverridesInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            CommissionOverviewDtoOutputOverridesInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CommissionOverviewDtoOutputOverridesInnerStatusEnum
  ];
  @override
  final String wireName = 'CommissionOverviewDtoOutputOverridesInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          CommissionOverviewDtoOutputOverridesInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CommissionOverviewDtoOutputOverridesInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CommissionOverviewDtoOutputOverridesInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CommissionOverviewDtoOutputOverridesInnerStateEnumSerializer
    implements
        PrimitiveSerializer<
            CommissionOverviewDtoOutputOverridesInnerStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SCHEDULED': 'SCHEDULED',
    'ACTIVE': 'ACTIVE',
    'EXPIRED': 'EXPIRED',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SCHEDULED': 'SCHEDULED',
    'ACTIVE': 'ACTIVE',
    'EXPIRED': 'EXPIRED',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CommissionOverviewDtoOutputOverridesInnerStateEnum
  ];
  @override
  final String wireName = 'CommissionOverviewDtoOutputOverridesInnerStateEnum';

  @override
  Object serialize(Serializers serializers,
          CommissionOverviewDtoOutputOverridesInnerStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CommissionOverviewDtoOutputOverridesInnerStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CommissionOverviewDtoOutputOverridesInnerStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CommissionOverviewDtoOutputOverridesInner
    extends CommissionOverviewDtoOutputOverridesInner {
  @override
  final String id;
  @override
  final String operatorId;
  @override
  final CommissionOverviewDtoOutputOverridesInnerChannelEnum channel;
  @override
  final String operatorName;
  @override
  final String operatorSlug;
  @override
  final int rateBps;
  @override
  final DateTime effectiveFrom;
  @override
  final DateTime? effectiveTo;
  @override
  final CommissionOverviewDtoOutputOverridesInnerStatusEnum status;
  @override
  final CommissionOverviewDtoOutputOverridesInnerStateEnum state;
  @override
  final String reason;
  @override
  final String? cancelReason;
  @override
  final String? createdBy;
  @override
  final DateTime createdAt;

  factory _$CommissionOverviewDtoOutputOverridesInner(
          [void Function(CommissionOverviewDtoOutputOverridesInnerBuilder)?
              updates]) =>
      (CommissionOverviewDtoOutputOverridesInnerBuilder()..update(updates))
          ._build();

  _$CommissionOverviewDtoOutputOverridesInner._(
      {required this.id,
      required this.operatorId,
      required this.channel,
      required this.operatorName,
      required this.operatorSlug,
      required this.rateBps,
      required this.effectiveFrom,
      this.effectiveTo,
      required this.status,
      required this.state,
      required this.reason,
      this.cancelReason,
      this.createdBy,
      required this.createdAt})
      : super._();
  @override
  CommissionOverviewDtoOutputOverridesInner rebuild(
          void Function(CommissionOverviewDtoOutputOverridesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionOverviewDtoOutputOverridesInnerBuilder toBuilder() =>
      CommissionOverviewDtoOutputOverridesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionOverviewDtoOutputOverridesInner &&
        id == other.id &&
        operatorId == other.operatorId &&
        channel == other.channel &&
        operatorName == other.operatorName &&
        operatorSlug == other.operatorSlug &&
        rateBps == other.rateBps &&
        effectiveFrom == other.effectiveFrom &&
        effectiveTo == other.effectiveTo &&
        status == other.status &&
        state == other.state &&
        reason == other.reason &&
        cancelReason == other.cancelReason &&
        createdBy == other.createdBy &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, operatorSlug.hashCode);
    _$hash = $jc(_$hash, rateBps.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, effectiveTo.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, cancelReason.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CommissionOverviewDtoOutputOverridesInner')
          ..add('id', id)
          ..add('operatorId', operatorId)
          ..add('channel', channel)
          ..add('operatorName', operatorName)
          ..add('operatorSlug', operatorSlug)
          ..add('rateBps', rateBps)
          ..add('effectiveFrom', effectiveFrom)
          ..add('effectiveTo', effectiveTo)
          ..add('status', status)
          ..add('state', state)
          ..add('reason', reason)
          ..add('cancelReason', cancelReason)
          ..add('createdBy', createdBy)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class CommissionOverviewDtoOutputOverridesInnerBuilder
    implements
        Builder<CommissionOverviewDtoOutputOverridesInner,
            CommissionOverviewDtoOutputOverridesInnerBuilder> {
  _$CommissionOverviewDtoOutputOverridesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  CommissionOverviewDtoOutputOverridesInnerChannelEnum? _channel;
  CommissionOverviewDtoOutputOverridesInnerChannelEnum? get channel =>
      _$this._channel;
  set channel(CommissionOverviewDtoOutputOverridesInnerChannelEnum? channel) =>
      _$this._channel = channel;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  String? _operatorSlug;
  String? get operatorSlug => _$this._operatorSlug;
  set operatorSlug(String? operatorSlug) => _$this._operatorSlug = operatorSlug;

  int? _rateBps;
  int? get rateBps => _$this._rateBps;
  set rateBps(int? rateBps) => _$this._rateBps = rateBps;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  DateTime? _effectiveTo;
  DateTime? get effectiveTo => _$this._effectiveTo;
  set effectiveTo(DateTime? effectiveTo) => _$this._effectiveTo = effectiveTo;

  CommissionOverviewDtoOutputOverridesInnerStatusEnum? _status;
  CommissionOverviewDtoOutputOverridesInnerStatusEnum? get status =>
      _$this._status;
  set status(CommissionOverviewDtoOutputOverridesInnerStatusEnum? status) =>
      _$this._status = status;

  CommissionOverviewDtoOutputOverridesInnerStateEnum? _state;
  CommissionOverviewDtoOutputOverridesInnerStateEnum? get state =>
      _$this._state;
  set state(CommissionOverviewDtoOutputOverridesInnerStateEnum? state) =>
      _$this._state = state;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _cancelReason;
  String? get cancelReason => _$this._cancelReason;
  set cancelReason(String? cancelReason) => _$this._cancelReason = cancelReason;

  String? _createdBy;
  String? get createdBy => _$this._createdBy;
  set createdBy(String? createdBy) => _$this._createdBy = createdBy;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  CommissionOverviewDtoOutputOverridesInnerBuilder() {
    CommissionOverviewDtoOutputOverridesInner._defaults(this);
  }

  CommissionOverviewDtoOutputOverridesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _operatorId = $v.operatorId;
      _channel = $v.channel;
      _operatorName = $v.operatorName;
      _operatorSlug = $v.operatorSlug;
      _rateBps = $v.rateBps;
      _effectiveFrom = $v.effectiveFrom;
      _effectiveTo = $v.effectiveTo;
      _status = $v.status;
      _state = $v.state;
      _reason = $v.reason;
      _cancelReason = $v.cancelReason;
      _createdBy = $v.createdBy;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionOverviewDtoOutputOverridesInner other) {
    _$v = other as _$CommissionOverviewDtoOutputOverridesInner;
  }

  @override
  void update(
      void Function(CommissionOverviewDtoOutputOverridesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionOverviewDtoOutputOverridesInner build() => _build();

  _$CommissionOverviewDtoOutputOverridesInner _build() {
    final _$result = _$v ??
        _$CommissionOverviewDtoOutputOverridesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CommissionOverviewDtoOutputOverridesInner', 'id'),
          operatorId: BuiltValueNullFieldError.checkNotNull(operatorId,
              r'CommissionOverviewDtoOutputOverridesInner', 'operatorId'),
          channel: BuiltValueNullFieldError.checkNotNull(
              channel, r'CommissionOverviewDtoOutputOverridesInner', 'channel'),
          operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
              r'CommissionOverviewDtoOutputOverridesInner', 'operatorName'),
          operatorSlug: BuiltValueNullFieldError.checkNotNull(operatorSlug,
              r'CommissionOverviewDtoOutputOverridesInner', 'operatorSlug'),
          rateBps: BuiltValueNullFieldError.checkNotNull(
              rateBps, r'CommissionOverviewDtoOutputOverridesInner', 'rateBps'),
          effectiveFrom: BuiltValueNullFieldError.checkNotNull(effectiveFrom,
              r'CommissionOverviewDtoOutputOverridesInner', 'effectiveFrom'),
          effectiveTo: effectiveTo,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CommissionOverviewDtoOutputOverridesInner', 'status'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'CommissionOverviewDtoOutputOverridesInner', 'state'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'CommissionOverviewDtoOutputOverridesInner', 'reason'),
          cancelReason: cancelReason,
          createdBy: createdBy,
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'CommissionOverviewDtoOutputOverridesInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
