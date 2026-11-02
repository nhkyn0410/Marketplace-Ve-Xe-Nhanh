// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_rule_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CommissionRuleDtoOutputChannelEnum
    _$commissionRuleDtoOutputChannelEnum_ONLINE =
    const CommissionRuleDtoOutputChannelEnum._('ONLINE');
const CommissionRuleDtoOutputChannelEnum
    _$commissionRuleDtoOutputChannelEnum_COUNTER =
    const CommissionRuleDtoOutputChannelEnum._('COUNTER');

CommissionRuleDtoOutputChannelEnum _$commissionRuleDtoOutputChannelEnumValueOf(
    String name) {
  switch (name) {
    case 'ONLINE':
      return _$commissionRuleDtoOutputChannelEnum_ONLINE;
    case 'COUNTER':
      return _$commissionRuleDtoOutputChannelEnum_COUNTER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CommissionRuleDtoOutputChannelEnum>
    _$commissionRuleDtoOutputChannelEnumValues = BuiltSet<
        CommissionRuleDtoOutputChannelEnum>(const <CommissionRuleDtoOutputChannelEnum>[
  _$commissionRuleDtoOutputChannelEnum_ONLINE,
  _$commissionRuleDtoOutputChannelEnum_COUNTER,
]);

const CommissionRuleDtoOutputStatusEnum
    _$commissionRuleDtoOutputStatusEnum_ACTIVE =
    const CommissionRuleDtoOutputStatusEnum._('ACTIVE');
const CommissionRuleDtoOutputStatusEnum
    _$commissionRuleDtoOutputStatusEnum_CANCELLED =
    const CommissionRuleDtoOutputStatusEnum._('CANCELLED');

CommissionRuleDtoOutputStatusEnum _$commissionRuleDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ACTIVE':
      return _$commissionRuleDtoOutputStatusEnum_ACTIVE;
    case 'CANCELLED':
      return _$commissionRuleDtoOutputStatusEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CommissionRuleDtoOutputStatusEnum>
    _$commissionRuleDtoOutputStatusEnumValues = BuiltSet<
        CommissionRuleDtoOutputStatusEnum>(const <CommissionRuleDtoOutputStatusEnum>[
  _$commissionRuleDtoOutputStatusEnum_ACTIVE,
  _$commissionRuleDtoOutputStatusEnum_CANCELLED,
]);

const CommissionRuleDtoOutputStateEnum
    _$commissionRuleDtoOutputStateEnum_SCHEDULED =
    const CommissionRuleDtoOutputStateEnum._('SCHEDULED');
const CommissionRuleDtoOutputStateEnum
    _$commissionRuleDtoOutputStateEnum_ACTIVE =
    const CommissionRuleDtoOutputStateEnum._('ACTIVE');
const CommissionRuleDtoOutputStateEnum
    _$commissionRuleDtoOutputStateEnum_EXPIRED =
    const CommissionRuleDtoOutputStateEnum._('EXPIRED');
const CommissionRuleDtoOutputStateEnum
    _$commissionRuleDtoOutputStateEnum_CANCELLED =
    const CommissionRuleDtoOutputStateEnum._('CANCELLED');

CommissionRuleDtoOutputStateEnum _$commissionRuleDtoOutputStateEnumValueOf(
    String name) {
  switch (name) {
    case 'SCHEDULED':
      return _$commissionRuleDtoOutputStateEnum_SCHEDULED;
    case 'ACTIVE':
      return _$commissionRuleDtoOutputStateEnum_ACTIVE;
    case 'EXPIRED':
      return _$commissionRuleDtoOutputStateEnum_EXPIRED;
    case 'CANCELLED':
      return _$commissionRuleDtoOutputStateEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CommissionRuleDtoOutputStateEnum>
    _$commissionRuleDtoOutputStateEnumValues = BuiltSet<
        CommissionRuleDtoOutputStateEnum>(const <CommissionRuleDtoOutputStateEnum>[
  _$commissionRuleDtoOutputStateEnum_SCHEDULED,
  _$commissionRuleDtoOutputStateEnum_ACTIVE,
  _$commissionRuleDtoOutputStateEnum_EXPIRED,
  _$commissionRuleDtoOutputStateEnum_CANCELLED,
]);

Serializer<CommissionRuleDtoOutputChannelEnum>
    _$commissionRuleDtoOutputChannelEnumSerializer =
    _$CommissionRuleDtoOutputChannelEnumSerializer();
Serializer<CommissionRuleDtoOutputStatusEnum>
    _$commissionRuleDtoOutputStatusEnumSerializer =
    _$CommissionRuleDtoOutputStatusEnumSerializer();
Serializer<CommissionRuleDtoOutputStateEnum>
    _$commissionRuleDtoOutputStateEnumSerializer =
    _$CommissionRuleDtoOutputStateEnumSerializer();

class _$CommissionRuleDtoOutputChannelEnumSerializer
    implements PrimitiveSerializer<CommissionRuleDtoOutputChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ONLINE': 'ONLINE',
    'COUNTER': 'COUNTER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ONLINE': 'ONLINE',
    'COUNTER': 'COUNTER',
  };

  @override
  final Iterable<Type> types = const <Type>[CommissionRuleDtoOutputChannelEnum];
  @override
  final String wireName = 'CommissionRuleDtoOutputChannelEnum';

  @override
  Object serialize(
          Serializers serializers, CommissionRuleDtoOutputChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CommissionRuleDtoOutputChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CommissionRuleDtoOutputChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CommissionRuleDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<CommissionRuleDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[CommissionRuleDtoOutputStatusEnum];
  @override
  final String wireName = 'CommissionRuleDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, CommissionRuleDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CommissionRuleDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CommissionRuleDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CommissionRuleDtoOutputStateEnumSerializer
    implements PrimitiveSerializer<CommissionRuleDtoOutputStateEnum> {
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
  final Iterable<Type> types = const <Type>[CommissionRuleDtoOutputStateEnum];
  @override
  final String wireName = 'CommissionRuleDtoOutputStateEnum';

  @override
  Object serialize(
          Serializers serializers, CommissionRuleDtoOutputStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CommissionRuleDtoOutputStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CommissionRuleDtoOutputStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CommissionRuleDtoOutput extends CommissionRuleDtoOutput {
  @override
  final String id;
  @override
  final String operatorId;
  @override
  final CommissionRuleDtoOutputChannelEnum channel;
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
  final CommissionRuleDtoOutputStatusEnum status;
  @override
  final CommissionRuleDtoOutputStateEnum state;
  @override
  final String reason;
  @override
  final String? cancelReason;
  @override
  final String? createdBy;
  @override
  final DateTime createdAt;

  factory _$CommissionRuleDtoOutput(
          [void Function(CommissionRuleDtoOutputBuilder)? updates]) =>
      (CommissionRuleDtoOutputBuilder()..update(updates))._build();

  _$CommissionRuleDtoOutput._(
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
  CommissionRuleDtoOutput rebuild(
          void Function(CommissionRuleDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionRuleDtoOutputBuilder toBuilder() =>
      CommissionRuleDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionRuleDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'CommissionRuleDtoOutput')
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

class CommissionRuleDtoOutputBuilder
    implements
        Builder<CommissionRuleDtoOutput, CommissionRuleDtoOutputBuilder> {
  _$CommissionRuleDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  CommissionRuleDtoOutputChannelEnum? _channel;
  CommissionRuleDtoOutputChannelEnum? get channel => _$this._channel;
  set channel(CommissionRuleDtoOutputChannelEnum? channel) =>
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

  CommissionRuleDtoOutputStatusEnum? _status;
  CommissionRuleDtoOutputStatusEnum? get status => _$this._status;
  set status(CommissionRuleDtoOutputStatusEnum? status) =>
      _$this._status = status;

  CommissionRuleDtoOutputStateEnum? _state;
  CommissionRuleDtoOutputStateEnum? get state => _$this._state;
  set state(CommissionRuleDtoOutputStateEnum? state) => _$this._state = state;

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

  CommissionRuleDtoOutputBuilder() {
    CommissionRuleDtoOutput._defaults(this);
  }

  CommissionRuleDtoOutputBuilder get _$this {
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
  void replace(CommissionRuleDtoOutput other) {
    _$v = other as _$CommissionRuleDtoOutput;
  }

  @override
  void update(void Function(CommissionRuleDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionRuleDtoOutput build() => _build();

  _$CommissionRuleDtoOutput _build() {
    final _$result = _$v ??
        _$CommissionRuleDtoOutput._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CommissionRuleDtoOutput', 'id'),
          operatorId: BuiltValueNullFieldError.checkNotNull(
              operatorId, r'CommissionRuleDtoOutput', 'operatorId'),
          channel: BuiltValueNullFieldError.checkNotNull(
              channel, r'CommissionRuleDtoOutput', 'channel'),
          operatorName: BuiltValueNullFieldError.checkNotNull(
              operatorName, r'CommissionRuleDtoOutput', 'operatorName'),
          operatorSlug: BuiltValueNullFieldError.checkNotNull(
              operatorSlug, r'CommissionRuleDtoOutput', 'operatorSlug'),
          rateBps: BuiltValueNullFieldError.checkNotNull(
              rateBps, r'CommissionRuleDtoOutput', 'rateBps'),
          effectiveFrom: BuiltValueNullFieldError.checkNotNull(
              effectiveFrom, r'CommissionRuleDtoOutput', 'effectiveFrom'),
          effectiveTo: effectiveTo,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CommissionRuleDtoOutput', 'status'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'CommissionRuleDtoOutput', 'state'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'CommissionRuleDtoOutput', 'reason'),
          cancelReason: cancelReason,
          createdBy: createdBy,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CommissionRuleDtoOutput', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
