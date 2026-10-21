// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PayoutPageDtoOutputItemsInnerStatusEnum
    _$payoutPageDtoOutputItemsInnerStatusEnum_PENDING_REVIEW =
    const PayoutPageDtoOutputItemsInnerStatusEnum._('PENDING_REVIEW');
const PayoutPageDtoOutputItemsInnerStatusEnum
    _$payoutPageDtoOutputItemsInnerStatusEnum_ON_HOLD =
    const PayoutPageDtoOutputItemsInnerStatusEnum._('ON_HOLD');
const PayoutPageDtoOutputItemsInnerStatusEnum
    _$payoutPageDtoOutputItemsInnerStatusEnum_READY_TO_TRANSFER =
    const PayoutPageDtoOutputItemsInnerStatusEnum._('READY_TO_TRANSFER');
const PayoutPageDtoOutputItemsInnerStatusEnum
    _$payoutPageDtoOutputItemsInnerStatusEnum_TRANSFERRING =
    const PayoutPageDtoOutputItemsInnerStatusEnum._('TRANSFERRING');
const PayoutPageDtoOutputItemsInnerStatusEnum
    _$payoutPageDtoOutputItemsInnerStatusEnum_PAID =
    const PayoutPageDtoOutputItemsInnerStatusEnum._('PAID');
const PayoutPageDtoOutputItemsInnerStatusEnum
    _$payoutPageDtoOutputItemsInnerStatusEnum_FAILED =
    const PayoutPageDtoOutputItemsInnerStatusEnum._('FAILED');
const PayoutPageDtoOutputItemsInnerStatusEnum
    _$payoutPageDtoOutputItemsInnerStatusEnum_CANCELLED =
    const PayoutPageDtoOutputItemsInnerStatusEnum._('CANCELLED');

PayoutPageDtoOutputItemsInnerStatusEnum
    _$payoutPageDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'PENDING_REVIEW':
      return _$payoutPageDtoOutputItemsInnerStatusEnum_PENDING_REVIEW;
    case 'ON_HOLD':
      return _$payoutPageDtoOutputItemsInnerStatusEnum_ON_HOLD;
    case 'READY_TO_TRANSFER':
      return _$payoutPageDtoOutputItemsInnerStatusEnum_READY_TO_TRANSFER;
    case 'TRANSFERRING':
      return _$payoutPageDtoOutputItemsInnerStatusEnum_TRANSFERRING;
    case 'PAID':
      return _$payoutPageDtoOutputItemsInnerStatusEnum_PAID;
    case 'FAILED':
      return _$payoutPageDtoOutputItemsInnerStatusEnum_FAILED;
    case 'CANCELLED':
      return _$payoutPageDtoOutputItemsInnerStatusEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PayoutPageDtoOutputItemsInnerStatusEnum>
    _$payoutPageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        PayoutPageDtoOutputItemsInnerStatusEnum>(const <PayoutPageDtoOutputItemsInnerStatusEnum>[
  _$payoutPageDtoOutputItemsInnerStatusEnum_PENDING_REVIEW,
  _$payoutPageDtoOutputItemsInnerStatusEnum_ON_HOLD,
  _$payoutPageDtoOutputItemsInnerStatusEnum_READY_TO_TRANSFER,
  _$payoutPageDtoOutputItemsInnerStatusEnum_TRANSFERRING,
  _$payoutPageDtoOutputItemsInnerStatusEnum_PAID,
  _$payoutPageDtoOutputItemsInnerStatusEnum_FAILED,
  _$payoutPageDtoOutputItemsInnerStatusEnum_CANCELLED,
]);

Serializer<PayoutPageDtoOutputItemsInnerStatusEnum>
    _$payoutPageDtoOutputItemsInnerStatusEnumSerializer =
    _$PayoutPageDtoOutputItemsInnerStatusEnumSerializer();

class _$PayoutPageDtoOutputItemsInnerStatusEnumSerializer
    implements PrimitiveSerializer<PayoutPageDtoOutputItemsInnerStatusEnum> {
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
  final Iterable<Type> types = const <Type>[
    PayoutPageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'PayoutPageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          PayoutPageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PayoutPageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PayoutPageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PayoutPageDtoOutputItemsInner extends PayoutPageDtoOutputItemsInner {
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
  final PayoutPageDtoOutputItemsInnerStatusEnum status;
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

  factory _$PayoutPageDtoOutputItemsInner(
          [void Function(PayoutPageDtoOutputItemsInnerBuilder)? updates]) =>
      (PayoutPageDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$PayoutPageDtoOutputItemsInner._(
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
      required this.createdAt})
      : super._();
  @override
  PayoutPageDtoOutputItemsInner rebuild(
          void Function(PayoutPageDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PayoutPageDtoOutputItemsInnerBuilder toBuilder() =>
      PayoutPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PayoutPageDtoOutputItemsInner &&
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
        createdAt == other.createdAt;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PayoutPageDtoOutputItemsInner')
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
          ..add('createdAt', createdAt))
        .toString();
  }
}

class PayoutPageDtoOutputItemsInnerBuilder
    implements
        Builder<PayoutPageDtoOutputItemsInner,
            PayoutPageDtoOutputItemsInnerBuilder> {
  _$PayoutPageDtoOutputItemsInner? _$v;

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

  PayoutPageDtoOutputItemsInnerStatusEnum? _status;
  PayoutPageDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(PayoutPageDtoOutputItemsInnerStatusEnum? status) =>
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

  PayoutPageDtoOutputItemsInnerBuilder() {
    PayoutPageDtoOutputItemsInner._defaults(this);
  }

  PayoutPageDtoOutputItemsInnerBuilder get _$this {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PayoutPageDtoOutputItemsInner other) {
    _$v = other as _$PayoutPageDtoOutputItemsInner;
  }

  @override
  void update(void Function(PayoutPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PayoutPageDtoOutputItemsInner build() => _build();

  _$PayoutPageDtoOutputItemsInner _build() {
    _$PayoutPageDtoOutputItemsInner _$result;
    try {
      _$result = _$v ??
          _$PayoutPageDtoOutputItemsInner._(
            payoutId: BuiltValueNullFieldError.checkNotNull(
                payoutId, r'PayoutPageDtoOutputItemsInner', 'payoutId'),
            payoutCode: BuiltValueNullFieldError.checkNotNull(
                payoutCode, r'PayoutPageDtoOutputItemsInner', 'payoutCode'),
            operatorId: BuiltValueNullFieldError.checkNotNull(
                operatorId, r'PayoutPageDtoOutputItemsInner', 'operatorId'),
            operatorName: BuiltValueNullFieldError.checkNotNull(
                operatorName, r'PayoutPageDtoOutputItemsInner', 'operatorName'),
            period: BuiltValueNullFieldError.checkNotNull(
                period, r'PayoutPageDtoOutputItemsInner', 'period'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PayoutPageDtoOutputItemsInner', 'status'),
            grossAmount: BuiltValueNullFieldError.checkNotNull(
                grossAmount, r'PayoutPageDtoOutputItemsInner', 'grossAmount'),
            commissionAmount: BuiltValueNullFieldError.checkNotNull(
                commissionAmount,
                r'PayoutPageDtoOutputItemsInner',
                'commissionAmount'),
            refundAmount: BuiltValueNullFieldError.checkNotNull(
                refundAmount, r'PayoutPageDtoOutputItemsInner', 'refundAmount'),
            adjustmentAmount: BuiltValueNullFieldError.checkNotNull(
                adjustmentAmount,
                r'PayoutPageDtoOutputItemsInner',
                'adjustmentAmount'),
            amount: BuiltValueNullFieldError.checkNotNull(
                amount, r'PayoutPageDtoOutputItemsInner', 'amount'),
            commissionRateBps: commissionRateBps,
            holdReason: holdReason,
            bank: _bank?.build(),
            paidAt: paidAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'PayoutPageDtoOutputItemsInner', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'bank';
        _bank?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PayoutPageDtoOutputItemsInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
