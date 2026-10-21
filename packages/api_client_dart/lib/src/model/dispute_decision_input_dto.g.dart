// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_decision_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeDecisionInputDtoDecisionEnum
    _$disputeDecisionInputDtoDecisionEnum_REFUND =
    const DisputeDecisionInputDtoDecisionEnum._('REFUND');
const DisputeDecisionInputDtoDecisionEnum
    _$disputeDecisionInputDtoDecisionEnum_NO_REFUND =
    const DisputeDecisionInputDtoDecisionEnum._('NO_REFUND');
const DisputeDecisionInputDtoDecisionEnum
    _$disputeDecisionInputDtoDecisionEnum_OTHER =
    const DisputeDecisionInputDtoDecisionEnum._('OTHER');

DisputeDecisionInputDtoDecisionEnum
    _$disputeDecisionInputDtoDecisionEnumValueOf(String name) {
  switch (name) {
    case 'REFUND':
      return _$disputeDecisionInputDtoDecisionEnum_REFUND;
    case 'NO_REFUND':
      return _$disputeDecisionInputDtoDecisionEnum_NO_REFUND;
    case 'OTHER':
      return _$disputeDecisionInputDtoDecisionEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeDecisionInputDtoDecisionEnum>
    _$disputeDecisionInputDtoDecisionEnumValues = BuiltSet<
        DisputeDecisionInputDtoDecisionEnum>(const <DisputeDecisionInputDtoDecisionEnum>[
  _$disputeDecisionInputDtoDecisionEnum_REFUND,
  _$disputeDecisionInputDtoDecisionEnum_NO_REFUND,
  _$disputeDecisionInputDtoDecisionEnum_OTHER,
]);

Serializer<DisputeDecisionInputDtoDecisionEnum>
    _$disputeDecisionInputDtoDecisionEnumSerializer =
    _$DisputeDecisionInputDtoDecisionEnumSerializer();

class _$DisputeDecisionInputDtoDecisionEnumSerializer
    implements PrimitiveSerializer<DisputeDecisionInputDtoDecisionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REFUND': 'REFUND',
    'NO_REFUND': 'NO_REFUND',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REFUND': 'REFUND',
    'NO_REFUND': 'NO_REFUND',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DisputeDecisionInputDtoDecisionEnum
  ];
  @override
  final String wireName = 'DisputeDecisionInputDtoDecisionEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeDecisionInputDtoDecisionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeDecisionInputDtoDecisionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeDecisionInputDtoDecisionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeDecisionInputDto extends DisputeDecisionInputDto {
  @override
  final DisputeDecisionInputDtoDecisionEnum decision;
  @override
  final int? amount;
  @override
  final String reason;

  factory _$DisputeDecisionInputDto(
          [void Function(DisputeDecisionInputDtoBuilder)? updates]) =>
      (DisputeDecisionInputDtoBuilder()..update(updates))._build();

  _$DisputeDecisionInputDto._(
      {required this.decision, this.amount, required this.reason})
      : super._();
  @override
  DisputeDecisionInputDto rebuild(
          void Function(DisputeDecisionInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeDecisionInputDtoBuilder toBuilder() =>
      DisputeDecisionInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeDecisionInputDto &&
        decision == other.decision &&
        amount == other.amount &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, decision.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeDecisionInputDto')
          ..add('decision', decision)
          ..add('amount', amount)
          ..add('reason', reason))
        .toString();
  }
}

class DisputeDecisionInputDtoBuilder
    implements
        Builder<DisputeDecisionInputDto, DisputeDecisionInputDtoBuilder> {
  _$DisputeDecisionInputDto? _$v;

  DisputeDecisionInputDtoDecisionEnum? _decision;
  DisputeDecisionInputDtoDecisionEnum? get decision => _$this._decision;
  set decision(DisputeDecisionInputDtoDecisionEnum? decision) =>
      _$this._decision = decision;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DisputeDecisionInputDtoBuilder() {
    DisputeDecisionInputDto._defaults(this);
  }

  DisputeDecisionInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _decision = $v.decision;
      _amount = $v.amount;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeDecisionInputDto other) {
    _$v = other as _$DisputeDecisionInputDto;
  }

  @override
  void update(void Function(DisputeDecisionInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeDecisionInputDto build() => _build();

  _$DisputeDecisionInputDto _build() {
    final _$result = _$v ??
        _$DisputeDecisionInputDto._(
          decision: BuiltValueNullFieldError.checkNotNull(
              decision, r'DisputeDecisionInputDto', 'decision'),
          amount: amount,
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'DisputeDecisionInputDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
