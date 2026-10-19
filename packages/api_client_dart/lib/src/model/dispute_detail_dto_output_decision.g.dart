// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_detail_dto_output_decision.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeDetailDtoOutputDecisionDecisionEnum
    _$disputeDetailDtoOutputDecisionDecisionEnum_REFUND =
    const DisputeDetailDtoOutputDecisionDecisionEnum._('REFUND');
const DisputeDetailDtoOutputDecisionDecisionEnum
    _$disputeDetailDtoOutputDecisionDecisionEnum_NO_REFUND =
    const DisputeDetailDtoOutputDecisionDecisionEnum._('NO_REFUND');
const DisputeDetailDtoOutputDecisionDecisionEnum
    _$disputeDetailDtoOutputDecisionDecisionEnum_OTHER =
    const DisputeDetailDtoOutputDecisionDecisionEnum._('OTHER');

DisputeDetailDtoOutputDecisionDecisionEnum
    _$disputeDetailDtoOutputDecisionDecisionEnumValueOf(String name) {
  switch (name) {
    case 'REFUND':
      return _$disputeDetailDtoOutputDecisionDecisionEnum_REFUND;
    case 'NO_REFUND':
      return _$disputeDetailDtoOutputDecisionDecisionEnum_NO_REFUND;
    case 'OTHER':
      return _$disputeDetailDtoOutputDecisionDecisionEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeDetailDtoOutputDecisionDecisionEnum>
    _$disputeDetailDtoOutputDecisionDecisionEnumValues = BuiltSet<
        DisputeDetailDtoOutputDecisionDecisionEnum>(const <DisputeDetailDtoOutputDecisionDecisionEnum>[
  _$disputeDetailDtoOutputDecisionDecisionEnum_REFUND,
  _$disputeDetailDtoOutputDecisionDecisionEnum_NO_REFUND,
  _$disputeDetailDtoOutputDecisionDecisionEnum_OTHER,
]);

Serializer<DisputeDetailDtoOutputDecisionDecisionEnum>
    _$disputeDetailDtoOutputDecisionDecisionEnumSerializer =
    _$DisputeDetailDtoOutputDecisionDecisionEnumSerializer();

class _$DisputeDetailDtoOutputDecisionDecisionEnumSerializer
    implements PrimitiveSerializer<DisputeDetailDtoOutputDecisionDecisionEnum> {
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
    DisputeDetailDtoOutputDecisionDecisionEnum
  ];
  @override
  final String wireName = 'DisputeDetailDtoOutputDecisionDecisionEnum';

  @override
  Object serialize(Serializers serializers,
          DisputeDetailDtoOutputDecisionDecisionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeDetailDtoOutputDecisionDecisionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeDetailDtoOutputDecisionDecisionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeDetailDtoOutputDecision extends DisputeDetailDtoOutputDecision {
  @override
  final DisputeDetailDtoOutputDecisionDecisionEnum decision;
  @override
  final int? amount;
  @override
  final String reason;
  @override
  final DateTime decidedAt;
  @override
  final DisputeDetailDtoOutputDecisionRefund? refund;

  factory _$DisputeDetailDtoOutputDecision(
          [void Function(DisputeDetailDtoOutputDecisionBuilder)? updates]) =>
      (DisputeDetailDtoOutputDecisionBuilder()..update(updates))._build();

  _$DisputeDetailDtoOutputDecision._(
      {required this.decision,
      this.amount,
      required this.reason,
      required this.decidedAt,
      this.refund})
      : super._();
  @override
  DisputeDetailDtoOutputDecision rebuild(
          void Function(DisputeDetailDtoOutputDecisionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeDetailDtoOutputDecisionBuilder toBuilder() =>
      DisputeDetailDtoOutputDecisionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeDetailDtoOutputDecision &&
        decision == other.decision &&
        amount == other.amount &&
        reason == other.reason &&
        decidedAt == other.decidedAt &&
        refund == other.refund;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, decision.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, decidedAt.hashCode);
    _$hash = $jc(_$hash, refund.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeDetailDtoOutputDecision')
          ..add('decision', decision)
          ..add('amount', amount)
          ..add('reason', reason)
          ..add('decidedAt', decidedAt)
          ..add('refund', refund))
        .toString();
  }
}

class DisputeDetailDtoOutputDecisionBuilder
    implements
        Builder<DisputeDetailDtoOutputDecision,
            DisputeDetailDtoOutputDecisionBuilder> {
  _$DisputeDetailDtoOutputDecision? _$v;

  DisputeDetailDtoOutputDecisionDecisionEnum? _decision;
  DisputeDetailDtoOutputDecisionDecisionEnum? get decision => _$this._decision;
  set decision(DisputeDetailDtoOutputDecisionDecisionEnum? decision) =>
      _$this._decision = decision;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _decidedAt;
  DateTime? get decidedAt => _$this._decidedAt;
  set decidedAt(DateTime? decidedAt) => _$this._decidedAt = decidedAt;

  DisputeDetailDtoOutputDecisionRefundBuilder? _refund;
  DisputeDetailDtoOutputDecisionRefundBuilder get refund =>
      _$this._refund ??= DisputeDetailDtoOutputDecisionRefundBuilder();
  set refund(DisputeDetailDtoOutputDecisionRefundBuilder? refund) =>
      _$this._refund = refund;

  DisputeDetailDtoOutputDecisionBuilder() {
    DisputeDetailDtoOutputDecision._defaults(this);
  }

  DisputeDetailDtoOutputDecisionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _decision = $v.decision;
      _amount = $v.amount;
      _reason = $v.reason;
      _decidedAt = $v.decidedAt;
      _refund = $v.refund?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeDetailDtoOutputDecision other) {
    _$v = other as _$DisputeDetailDtoOutputDecision;
  }

  @override
  void update(void Function(DisputeDetailDtoOutputDecisionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeDetailDtoOutputDecision build() => _build();

  _$DisputeDetailDtoOutputDecision _build() {
    _$DisputeDetailDtoOutputDecision _$result;
    try {
      _$result = _$v ??
          _$DisputeDetailDtoOutputDecision._(
            decision: BuiltValueNullFieldError.checkNotNull(
                decision, r'DisputeDetailDtoOutputDecision', 'decision'),
            amount: amount,
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'DisputeDetailDtoOutputDecision', 'reason'),
            decidedAt: BuiltValueNullFieldError.checkNotNull(
                decidedAt, r'DisputeDetailDtoOutputDecision', 'decidedAt'),
            refund: _refund?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'refund';
        _refund?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DisputeDetailDtoOutputDecision', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
