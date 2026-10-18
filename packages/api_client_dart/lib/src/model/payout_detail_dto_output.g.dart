// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_detail_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PayoutDetailDtoOutputStatusEnum
    _$payoutDetailDtoOutputStatusEnum_PENDING_REVIEW =
    const PayoutDetailDtoOutputStatusEnum._('PENDING_REVIEW');
const PayoutDetailDtoOutputStatusEnum
    _$payoutDetailDtoOutputStatusEnum_ON_HOLD =
    const PayoutDetailDtoOutputStatusEnum._('ON_HOLD');
const PayoutDetailDtoOutputStatusEnum
    _$payoutDetailDtoOutputStatusEnum_READY_TO_TRANSFER =
    const PayoutDetailDtoOutputStatusEnum._('READY_TO_TRANSFER');
const PayoutDetailDtoOutputStatusEnum
    _$payoutDetailDtoOutputStatusEnum_TRANSFERRING =
    const PayoutDetailDtoOutputStatusEnum._('TRANSFERRING');
const PayoutDetailDtoOutputStatusEnum _$payoutDetailDtoOutputStatusEnum_PAID =
    const PayoutDetailDtoOutputStatusEnum._('PAID');
const PayoutDetailDtoOutputStatusEnum _$payoutDetailDtoOutputStatusEnum_FAILED =
    const PayoutDetailDtoOutputStatusEnum._('FAILED');
const PayoutDetailDtoOutputStatusEnum
    _$payoutDetailDtoOutputStatusEnum_CANCELLED =
    const PayoutDetailDtoOutputStatusEnum._('CANCELLED');

PayoutDetailDtoOutputStatusEnum _$payoutDetailDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'PENDING_REVIEW':
      return _$payoutDetailDtoOutputStatusEnum_PENDING_REVIEW;
    case 'ON_HOLD':
      return _$payoutDetailDtoOutputStatusEnum_ON_HOLD;
    case 'READY_TO_TRANSFER':
      return _$payoutDetailDtoOutputStatusEnum_READY_TO_TRANSFER;
    case 'TRANSFERRING':
      return _$payoutDetailDtoOutputStatusEnum_TRANSFERRING;
    case 'PAID':
      return _$payoutDetailDtoOutputStatusEnum_PAID;
    case 'FAILED':
      return _$payoutDetailDtoOutputStatusEnum_FAILED;
    case 'CANCELLED':
      return _$payoutDetailDtoOutputStatusEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PayoutDetailDtoOutputStatusEnum>
    _$payoutDetailDtoOutputStatusEnumValues = BuiltSet<
        PayoutDetailDtoOutputStatusEnum>(const <PayoutDetailDtoOutputStatusEnum>[
  _$payoutDetailDtoOutputStatusEnum_PENDING_REVIEW,
  _$payoutDetailDtoOutputStatusEnum_ON_HOLD,
  _$payoutDetailDtoOutputStatusEnum_READY_TO_TRANSFER,
  _$payoutDetailDtoOutputStatusEnum_TRANSFERRING,
  _$payoutDetailDtoOutputStatusEnum_PAID,
  _$payoutDetailDtoOutputStatusEnum_FAILED,
  _$payoutDetailDtoOutputStatusEnum_CANCELLED,
]);

Serializer<PayoutDetailDtoOutputStatusEnum>
    _$payoutDetailDtoOutputStatusEnumSerializer =
    _$PayoutDetailDtoOutputStatusEnumSerializer();

class _$PayoutDetailDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<PayoutDetailDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING_REVIEW': 'PENDING_REVIEW',
    'ON_HOLD': 'ON_HOLD',
    'READY_TO_TRANSFER': 'READY_TO_TRANSFER',
    'TRANSFERRING': 'TRANSFERRING',
    'PAID': 'PAID',
    'FAILED': 'FAILED',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING_REVIEW': 'PENDING_REVIEW',
    'ON_HOLD': 'ON_HOLD',
    'READY_TO_TRANSFER': 'READY_TO_TRANSFER',
    'TRANSFERRING': 'TRANSFERRING',
    'PAID': 'PAID',
    'FAILED': 'FAILED',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[PayoutDetailDtoOutputStatusEnum];
  @override
  final String wireName = 'PayoutDetailDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, PayoutDetailDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PayoutDetailDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PayoutDetailDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PayoutDetailDtoOutput extends PayoutDetailDtoOutput {
  @override
  final String payoutId;
  @override
  final String payoutCode;
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final Date period;
  @override
  final PayoutDetailDtoOutputStatusEnum status;
  @override
  final int grossAmount;
  @override
  final int commissionAmount;
  @override
  final int refundAmount;
  @override
  final int adjustmentAmount;
  @override
  final int amount;
  @override
  final int? commissionRateBps;
  @override
  final String? holdReason;
  @override
  final PayoutPageDtoOutputItemsInnerBank? bank;
  @override
  final DateTime? paidAt;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<PayoutDetailDtoOutputTripsInner> trips;
  @override
  final PayoutDetailDtoOutputChecks checks;
  @override
  final String? bankReference;
  @override
  final DateTime? transferredAt;
  @override
  final String? confirmationNote;
  @override
  final String? cancelReason;
  @override
  final BuiltList<PayoutDetailDtoOutputHistoriesInner> histories;

  factory _$PayoutDetailDtoOutput(
          [void Function(PayoutDetailDtoOutputBuilder)? updates]) =>
      (PayoutDetailDtoOutputBuilder()..update(updates))._build();

  _$PayoutDetailDtoOutput._(
      {required this.payoutId,
      required this.payoutCode,
      required this.operatorId,
      required this.operatorName,
      required this.period,
      required this.status,
      required this.grossAmount,
      required this.commissionAmount,
      required this.refundAmount,
      required this.adjustmentAmount,
      required this.amount,
      this.commissionRateBps,
      this.holdReason,
      this.bank,
      this.paidAt,
      required this.createdAt,
      required this.trips,
      required this.checks,
      this.bankReference,
      this.transferredAt,
      this.confirmationNote,
      this.cancelReason,
      required this.histories})
      : super._();
  @override
  PayoutDetailDtoOutput rebuild(
          void Function(PayoutDetailDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PayoutDetailDtoOutputBuilder toBuilder() =>
      PayoutDetailDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutDetailDtoOutput &&
        payoutId == other.payoutId &&
        payoutCode == other.payoutCode &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        period == other.period &&
        status == other.status &&
        grossAmount == other.grossAmount &&
        commissionAmount == other.commissionAmount &&
        refundAmount == other.refundAmount &&
        adjustmentAmount == other.adjustmentAmount &&
        amount == other.amount &&
        commissionRateBps == other.commissionRateBps &&
        holdReason == other.holdReason &&
        bank == other.bank &&
        paidAt == other.paidAt &&
        createdAt == other.createdAt &&
        trips == other.trips &&
        checks == other.checks &&
        bankReference == other.bankReference &&
        transferredAt == other.transferredAt &&
        confirmationNote == other.confirmationNote &&
        cancelReason == other.cancelReason &&
        histories == other.histories;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, payoutId.hashCode);
    _$hash = $jc(_$hash, payoutCode.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, grossAmount.hashCode);
    _$hash = $jc(_$hash, commissionAmount.hashCode);
    _$hash = $jc(_$hash, refundAmount.hashCode);
    _$hash = $jc(_$hash, adjustmentAmount.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, commissionRateBps.hashCode);
    _$hash = $jc(_$hash, holdReason.hashCode);
    _$hash = $jc(_$hash, bank.hashCode);
    _$hash = $jc(_$hash, paidAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, trips.hashCode);
    _$hash = $jc(_$hash, checks.hashCode);
    _$hash = $jc(_$hash, bankReference.hashCode);
    _$hash = $jc(_$hash, transferredAt.hashCode);
    _$hash = $jc(_$hash, confirmationNote.hashCode);
    _$hash = $jc(_$hash, cancelReason.hashCode);
    _$hash = $jc(_$hash, histories.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PayoutDetailDtoOutput')
          ..add('payoutId', payoutId)
          ..add('payoutCode', payoutCode)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('period', period)
          ..add('status', status)
          ..add('grossAmount', grossAmount)
          ..add('commissionAmount', commissionAmount)
          ..add('refundAmount', refundAmount)
          ..add('adjustmentAmount', adjustmentAmount)
          ..add('amount', amount)
          ..add('commissionRateBps', commissionRateBps)
          ..add('holdReason', holdReason)
          ..add('bank', bank)
          ..add('paidAt', paidAt)
          ..add('createdAt', createdAt)
          ..add('trips', trips)
          ..add('checks', checks)
          ..add('bankReference', bankReference)
          ..add('transferredAt', transferredAt)
          ..add('confirmationNote', confirmationNote)
          ..add('cancelReason', cancelReason)
          ..add('histories', histories))
        .toString();
  }
}

class PayoutDetailDtoOutputBuilder
    implements Builder<PayoutDetailDtoOutput, PayoutDetailDtoOutputBuilder> {
  _$PayoutDetailDtoOutput? _$v;

  String? _payoutId;
  String? get payoutId => _$this._payoutId;
  set payoutId(String? payoutId) => _$this._payoutId = payoutId;

  String? _payoutCode;
  String? get payoutCode => _$this._payoutCode;
  set payoutCode(String? payoutCode) => _$this._payoutCode = payoutCode;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  Date? _period;
  Date? get period => _$this._period;
  set period(Date? period) => _$this._period = period;

  PayoutDetailDtoOutputStatusEnum? _status;
  PayoutDetailDtoOutputStatusEnum? get status => _$this._status;
  set status(PayoutDetailDtoOutputStatusEnum? status) =>
      _$this._status = status;

  int? _grossAmount;
  int? get grossAmount => _$this._grossAmount;
  set grossAmount(int? grossAmount) => _$this._grossAmount = grossAmount;

  int? _commissionAmount;
  int? get commissionAmount => _$this._commissionAmount;
  set commissionAmount(int? commissionAmount) =>
      _$this._commissionAmount = commissionAmount;

  int? _refundAmount;
  int? get refundAmount => _$this._refundAmount;
  set refundAmount(int? refundAmount) => _$this._refundAmount = refundAmount;

  int? _adjustmentAmount;
  int? get adjustmentAmount => _$this._adjustmentAmount;
  set adjustmentAmount(int? adjustmentAmount) =>
      _$this._adjustmentAmount = adjustmentAmount;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  int? _commissionRateBps;
  int? get commissionRateBps => _$this._commissionRateBps;
  set commissionRateBps(int? commissionRateBps) =>
      _$this._commissionRateBps = commissionRateBps;

  String? _holdReason;
  String? get holdReason => _$this._holdReason;
  set holdReason(String? holdReason) => _$this._holdReason = holdReason;

  PayoutPageDtoOutputItemsInnerBankBuilder? _bank;
  PayoutPageDtoOutputItemsInnerBankBuilder get bank =>
      _$this._bank ??= PayoutPageDtoOutputItemsInnerBankBuilder();
  set bank(PayoutPageDtoOutputItemsInnerBankBuilder? bank) =>
      _$this._bank = bank;

  DateTime? _paidAt;
  DateTime? get paidAt => _$this._paidAt;
  set paidAt(DateTime? paidAt) => _$this._paidAt = paidAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<PayoutDetailDtoOutputTripsInner>? _trips;
  ListBuilder<PayoutDetailDtoOutputTripsInner> get trips =>
      _$this._trips ??= ListBuilder<PayoutDetailDtoOutputTripsInner>();
  set trips(ListBuilder<PayoutDetailDtoOutputTripsInner>? trips) =>
      _$this._trips = trips;

  PayoutDetailDtoOutputChecksBuilder? _checks;
  PayoutDetailDtoOutputChecksBuilder get checks =>
      _$this._checks ??= PayoutDetailDtoOutputChecksBuilder();
  set checks(PayoutDetailDtoOutputChecksBuilder? checks) =>
      _$this._checks = checks;

  String? _bankReference;
  String? get bankReference => _$this._bankReference;
  set bankReference(String? bankReference) =>
      _$this._bankReference = bankReference;

  DateTime? _transferredAt;
  DateTime? get transferredAt => _$this._transferredAt;
  set transferredAt(DateTime? transferredAt) =>
      _$this._transferredAt = transferredAt;

  String? _confirmationNote;
  String? get confirmationNote => _$this._confirmationNote;
  set confirmationNote(String? confirmationNote) =>
      _$this._confirmationNote = confirmationNote;

  String? _cancelReason;
  String? get cancelReason => _$this._cancelReason;
  set cancelReason(String? cancelReason) => _$this._cancelReason = cancelReason;

  ListBuilder<PayoutDetailDtoOutputHistoriesInner>? _histories;
  ListBuilder<PayoutDetailDtoOutputHistoriesInner> get histories =>
      _$this._histories ??= ListBuilder<PayoutDetailDtoOutputHistoriesInner>();
  set histories(ListBuilder<PayoutDetailDtoOutputHistoriesInner>? histories) =>
      _$this._histories = histories;

  PayoutDetailDtoOutputBuilder() {
    PayoutDetailDtoOutput._defaults(this);
  }

  PayoutDetailDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _payoutId = $v.payoutId;
      _payoutCode = $v.payoutCode;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _period = $v.period;
      _status = $v.status;
      _grossAmount = $v.grossAmount;
      _commissionAmount = $v.commissionAmount;
      _refundAmount = $v.refundAmount;
      _adjustmentAmount = $v.adjustmentAmount;
      _amount = $v.amount;
      _commissionRateBps = $v.commissionRateBps;
      _holdReason = $v.holdReason;
      _bank = $v.bank?.toBuilder();
      _paidAt = $v.paidAt;
      _createdAt = $v.createdAt;
      _trips = $v.trips.toBuilder();
      _checks = $v.checks.toBuilder();
      _bankReference = $v.bankReference;
      _transferredAt = $v.transferredAt;
      _confirmationNote = $v.confirmationNote;
      _cancelReason = $v.cancelReason;
      _histories = $v.histories.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutDetailDtoOutput other) {
    _$v = other as _$PayoutDetailDtoOutput;
  }

  @override
  void update(void Function(PayoutDetailDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutDetailDtoOutput build() => _build();

  _$PayoutDetailDtoOutput _build() {
    _$PayoutDetailDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PayoutDetailDtoOutput._(
            payoutId: BuiltValueNullFieldError.checkNotNull(
                payoutId, r'PayoutDetailDtoOutput', 'payoutId'),
            payoutCode: BuiltValueNullFieldError.checkNotNull(
                payoutCode, r'PayoutDetailDtoOutput', 'payoutCode'),
            operatorId: BuiltValueNullFieldError.checkNotNull(
                operatorId, r'PayoutDetailDtoOutput', 'operatorId'),
            operatorName: BuiltValueNullFieldError.checkNotNull(
                operatorName, r'PayoutDetailDtoOutput', 'operatorName'),
            period: BuiltValueNullFieldError.checkNotNull(
                period, r'PayoutDetailDtoOutput', 'period'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PayoutDetailDtoOutput', 'status'),
            grossAmount: BuiltValueNullFieldError.checkNotNull(
                grossAmount, r'PayoutDetailDtoOutput', 'grossAmount'),
            commissionAmount: BuiltValueNullFieldError.checkNotNull(
                commissionAmount, r'PayoutDetailDtoOutput', 'commissionAmount'),
            refundAmount: BuiltValueNullFieldError.checkNotNull(
                refundAmount, r'PayoutDetailDtoOutput', 'refundAmount'),
            adjustmentAmount: BuiltValueNullFieldError.checkNotNull(
                adjustmentAmount, r'PayoutDetailDtoOutput', 'adjustmentAmount'),
            amount: BuiltValueNullFieldError.checkNotNull(
                amount, r'PayoutDetailDtoOutput', 'amount'),
            commissionRateBps: commissionRateBps,
            holdReason: holdReason,
            bank: _bank?.build(),
            paidAt: paidAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'PayoutDetailDtoOutput', 'createdAt'),
            trips: trips.build(),
            checks: checks.build(),
            bankReference: bankReference,
            transferredAt: transferredAt,
            confirmationNote: confirmationNote,
            cancelReason: cancelReason,
            histories: histories.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'bank';
        _bank?.build();

        _$failedField = 'trips';
        trips.build();
        _$failedField = 'checks';
        checks.build();

        _$failedField = 'histories';
        histories.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PayoutDetailDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
