// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_commission_settlement_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterCommissionSettlementInputDto
    extends CounterCommissionSettlementInputDto {
  @override
  final String operatorId;
  @override
  final String idempotencyKey;
  @override
  final String amount;
  @override
  final String reference;
  @override
  final String reason;

  factory _$CounterCommissionSettlementInputDto(
          [void Function(CounterCommissionSettlementInputDtoBuilder)?
              updates]) =>
      (CounterCommissionSettlementInputDtoBuilder()..update(updates))._build();

  _$CounterCommissionSettlementInputDto._(
      {required this.operatorId,
      required this.idempotencyKey,
      required this.amount,
      required this.reference,
      required this.reason})
      : super._();
  @override
  CounterCommissionSettlementInputDto rebuild(
          void Function(CounterCommissionSettlementInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterCommissionSettlementInputDtoBuilder toBuilder() =>
      CounterCommissionSettlementInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterCommissionSettlementInputDto &&
        operatorId == other.operatorId &&
        idempotencyKey == other.idempotencyKey &&
        amount == other.amount &&
        reference == other.reference &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, idempotencyKey.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CounterCommissionSettlementInputDto')
          ..add('operatorId', operatorId)
          ..add('idempotencyKey', idempotencyKey)
          ..add('amount', amount)
          ..add('reference', reference)
          ..add('reason', reason))
        .toString();
  }
}

class CounterCommissionSettlementInputDtoBuilder
    implements
        Builder<CounterCommissionSettlementInputDto,
            CounterCommissionSettlementInputDtoBuilder> {
  _$CounterCommissionSettlementInputDto? _$v;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _idempotencyKey;
  String? get idempotencyKey => _$this._idempotencyKey;
  set idempotencyKey(String? idempotencyKey) =>
      _$this._idempotencyKey = idempotencyKey;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CounterCommissionSettlementInputDtoBuilder() {
    CounterCommissionSettlementInputDto._defaults(this);
  }

  CounterCommissionSettlementInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operatorId = $v.operatorId;
      _idempotencyKey = $v.idempotencyKey;
      _amount = $v.amount;
      _reference = $v.reference;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterCommissionSettlementInputDto other) {
    _$v = other as _$CounterCommissionSettlementInputDto;
  }

  @override
  void update(
      void Function(CounterCommissionSettlementInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterCommissionSettlementInputDto build() => _build();

  _$CounterCommissionSettlementInputDto _build() {
    final _$result = _$v ??
        _$CounterCommissionSettlementInputDto._(
          operatorId: BuiltValueNullFieldError.checkNotNull(
              operatorId, r'CounterCommissionSettlementInputDto', 'operatorId'),
          idempotencyKey: BuiltValueNullFieldError.checkNotNull(idempotencyKey,
              r'CounterCommissionSettlementInputDto', 'idempotencyKey'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'CounterCommissionSettlementInputDto', 'amount'),
          reference: BuiltValueNullFieldError.checkNotNull(
              reference, r'CounterCommissionSettlementInputDto', 'reference'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'CounterCommissionSettlementInputDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
