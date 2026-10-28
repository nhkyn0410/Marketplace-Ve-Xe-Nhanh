// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_rule_create_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CommissionRuleCreateDtoChannelEnum
    _$commissionRuleCreateDtoChannelEnum_ONLINE =
    const CommissionRuleCreateDtoChannelEnum._('ONLINE');
const CommissionRuleCreateDtoChannelEnum
    _$commissionRuleCreateDtoChannelEnum_COUNTER =
    const CommissionRuleCreateDtoChannelEnum._('COUNTER');

CommissionRuleCreateDtoChannelEnum _$commissionRuleCreateDtoChannelEnumValueOf(
    String name) {
  switch (name) {
    case 'ONLINE':
      return _$commissionRuleCreateDtoChannelEnum_ONLINE;
    case 'COUNTER':
      return _$commissionRuleCreateDtoChannelEnum_COUNTER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CommissionRuleCreateDtoChannelEnum>
    _$commissionRuleCreateDtoChannelEnumValues = BuiltSet<
        CommissionRuleCreateDtoChannelEnum>(const <CommissionRuleCreateDtoChannelEnum>[
  _$commissionRuleCreateDtoChannelEnum_ONLINE,
  _$commissionRuleCreateDtoChannelEnum_COUNTER,
]);

Serializer<CommissionRuleCreateDtoChannelEnum>
    _$commissionRuleCreateDtoChannelEnumSerializer =
    _$CommissionRuleCreateDtoChannelEnumSerializer();

class _$CommissionRuleCreateDtoChannelEnumSerializer
    implements PrimitiveSerializer<CommissionRuleCreateDtoChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ONLINE': 'ONLINE',
    'COUNTER': 'COUNTER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ONLINE': 'ONLINE',
    'COUNTER': 'COUNTER',
  };

  @override
  final Iterable<Type> types = const <Type>[CommissionRuleCreateDtoChannelEnum];
  @override
  final String wireName = 'CommissionRuleCreateDtoChannelEnum';

  @override
  Object serialize(
          Serializers serializers, CommissionRuleCreateDtoChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CommissionRuleCreateDtoChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CommissionRuleCreateDtoChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CommissionRuleCreateDto extends CommissionRuleCreateDto {
  @override
  final String operatorId;
  @override
  final CommissionRuleCreateDtoChannelEnum? channel;
  @override
  final int rateBps;
  @override
  final DateTime effectiveFrom;
  @override
  final DateTime? effectiveTo;
  @override
  final String reason;

  factory _$CommissionRuleCreateDto(
          [void Function(CommissionRuleCreateDtoBuilder)? updates]) =>
      (CommissionRuleCreateDtoBuilder()..update(updates))._build();

  _$CommissionRuleCreateDto._(
      {required this.operatorId,
      this.channel,
      required this.rateBps,
      required this.effectiveFrom,
      this.effectiveTo,
      required this.reason})
      : super._();
  @override
  CommissionRuleCreateDto rebuild(
          void Function(CommissionRuleCreateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionRuleCreateDtoBuilder toBuilder() =>
      CommissionRuleCreateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionRuleCreateDto &&
        operatorId == other.operatorId &&
        channel == other.channel &&
        rateBps == other.rateBps &&
        effectiveFrom == other.effectiveFrom &&
        effectiveTo == other.effectiveTo &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, rateBps.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, effectiveTo.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionRuleCreateDto')
          ..add('operatorId', operatorId)
          ..add('channel', channel)
          ..add('rateBps', rateBps)
          ..add('effectiveFrom', effectiveFrom)
          ..add('effectiveTo', effectiveTo)
          ..add('reason', reason))
        .toString();
  }
}

class CommissionRuleCreateDtoBuilder
    implements
        Builder<CommissionRuleCreateDto, CommissionRuleCreateDtoBuilder> {
  _$CommissionRuleCreateDto? _$v;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  CommissionRuleCreateDtoChannelEnum? _channel;
  CommissionRuleCreateDtoChannelEnum? get channel => _$this._channel;
  set channel(CommissionRuleCreateDtoChannelEnum? channel) =>
      _$this._channel = channel;

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

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CommissionRuleCreateDtoBuilder() {
    CommissionRuleCreateDto._defaults(this);
  }

  CommissionRuleCreateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operatorId = $v.operatorId;
      _channel = $v.channel;
      _rateBps = $v.rateBps;
      _effectiveFrom = $v.effectiveFrom;
      _effectiveTo = $v.effectiveTo;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionRuleCreateDto other) {
    _$v = other as _$CommissionRuleCreateDto;
  }

  @override
  void update(void Function(CommissionRuleCreateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionRuleCreateDto build() => _build();

  _$CommissionRuleCreateDto _build() {
    final _$result = _$v ??
        _$CommissionRuleCreateDto._(
          operatorId: BuiltValueNullFieldError.checkNotNull(
              operatorId, r'CommissionRuleCreateDto', 'operatorId'),
          channel: channel,
          rateBps: BuiltValueNullFieldError.checkNotNull(
              rateBps, r'CommissionRuleCreateDto', 'rateBps'),
          effectiveFrom: BuiltValueNullFieldError.checkNotNull(
              effectiveFrom, r'CommissionRuleCreateDto', 'effectiveFrom'),
          effectiveTo: effectiveTo,
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'CommissionRuleCreateDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
