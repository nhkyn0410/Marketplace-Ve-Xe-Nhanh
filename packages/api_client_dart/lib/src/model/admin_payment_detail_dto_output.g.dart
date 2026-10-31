// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_payment_detail_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminPaymentDetailDtoOutputProviderEnum
    _$adminPaymentDetailDtoOutputProviderEnum_VNPAY =
    const AdminPaymentDetailDtoOutputProviderEnum._('VNPAY');
const AdminPaymentDetailDtoOutputProviderEnum
    _$adminPaymentDetailDtoOutputProviderEnum_MOMO =
    const AdminPaymentDetailDtoOutputProviderEnum._('MOMO');
const AdminPaymentDetailDtoOutputProviderEnum
    _$adminPaymentDetailDtoOutputProviderEnum_PAYOS =
    const AdminPaymentDetailDtoOutputProviderEnum._('PAYOS');
const AdminPaymentDetailDtoOutputProviderEnum
    _$adminPaymentDetailDtoOutputProviderEnum_DEMO =
    const AdminPaymentDetailDtoOutputProviderEnum._('DEMO');

AdminPaymentDetailDtoOutputProviderEnum
    _$adminPaymentDetailDtoOutputProviderEnumValueOf(String name) {
  switch (name) {
    case 'VNPAY':
      return _$adminPaymentDetailDtoOutputProviderEnum_VNPAY;
    case 'MOMO':
      return _$adminPaymentDetailDtoOutputProviderEnum_MOMO;
    case 'PAYOS':
      return _$adminPaymentDetailDtoOutputProviderEnum_PAYOS;
    case 'DEMO':
      return _$adminPaymentDetailDtoOutputProviderEnum_DEMO;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPaymentDetailDtoOutputProviderEnum>
    _$adminPaymentDetailDtoOutputProviderEnumValues = BuiltSet<
        AdminPaymentDetailDtoOutputProviderEnum>(const <AdminPaymentDetailDtoOutputProviderEnum>[
  _$adminPaymentDetailDtoOutputProviderEnum_VNPAY,
  _$adminPaymentDetailDtoOutputProviderEnum_MOMO,
  _$adminPaymentDetailDtoOutputProviderEnum_PAYOS,
  _$adminPaymentDetailDtoOutputProviderEnum_DEMO,
]);

const AdminPaymentDetailDtoOutputStatusEnum
    _$adminPaymentDetailDtoOutputStatusEnum_INITIATED =
    const AdminPaymentDetailDtoOutputStatusEnum._('INITIATED');
const AdminPaymentDetailDtoOutputStatusEnum
    _$adminPaymentDetailDtoOutputStatusEnum_PROCESSING =
    const AdminPaymentDetailDtoOutputStatusEnum._('PROCESSING');
const AdminPaymentDetailDtoOutputStatusEnum
    _$adminPaymentDetailDtoOutputStatusEnum_SUCCESS =
    const AdminPaymentDetailDtoOutputStatusEnum._('SUCCESS');
const AdminPaymentDetailDtoOutputStatusEnum
    _$adminPaymentDetailDtoOutputStatusEnum_FAILED =
    const AdminPaymentDetailDtoOutputStatusEnum._('FAILED');
const AdminPaymentDetailDtoOutputStatusEnum
    _$adminPaymentDetailDtoOutputStatusEnum_EXPIRED =
    const AdminPaymentDetailDtoOutputStatusEnum._('EXPIRED');
const AdminPaymentDetailDtoOutputStatusEnum
    _$adminPaymentDetailDtoOutputStatusEnum_CANCELLED =
    const AdminPaymentDetailDtoOutputStatusEnum._('CANCELLED');
const AdminPaymentDetailDtoOutputStatusEnum
    _$adminPaymentDetailDtoOutputStatusEnum_RECONCILING =
    const AdminPaymentDetailDtoOutputStatusEnum._('RECONCILING');

AdminPaymentDetailDtoOutputStatusEnum
    _$adminPaymentDetailDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'INITIATED':
      return _$adminPaymentDetailDtoOutputStatusEnum_INITIATED;
    case 'PROCESSING':
      return _$adminPaymentDetailDtoOutputStatusEnum_PROCESSING;
    case 'SUCCESS':
      return _$adminPaymentDetailDtoOutputStatusEnum_SUCCESS;
    case 'FAILED':
      return _$adminPaymentDetailDtoOutputStatusEnum_FAILED;
    case 'EXPIRED':
      return _$adminPaymentDetailDtoOutputStatusEnum_EXPIRED;
    case 'CANCELLED':
      return _$adminPaymentDetailDtoOutputStatusEnum_CANCELLED;
    case 'RECONCILING':
      return _$adminPaymentDetailDtoOutputStatusEnum_RECONCILING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPaymentDetailDtoOutputStatusEnum>
    _$adminPaymentDetailDtoOutputStatusEnumValues = BuiltSet<
        AdminPaymentDetailDtoOutputStatusEnum>(const <AdminPaymentDetailDtoOutputStatusEnum>[
  _$adminPaymentDetailDtoOutputStatusEnum_INITIATED,
  _$adminPaymentDetailDtoOutputStatusEnum_PROCESSING,
  _$adminPaymentDetailDtoOutputStatusEnum_SUCCESS,
  _$adminPaymentDetailDtoOutputStatusEnum_FAILED,
  _$adminPaymentDetailDtoOutputStatusEnum_EXPIRED,
  _$adminPaymentDetailDtoOutputStatusEnum_CANCELLED,
  _$adminPaymentDetailDtoOutputStatusEnum_RECONCILING,
]);

Serializer<AdminPaymentDetailDtoOutputProviderEnum>
    _$adminPaymentDetailDtoOutputProviderEnumSerializer =
    _$AdminPaymentDetailDtoOutputProviderEnumSerializer();
Serializer<AdminPaymentDetailDtoOutputStatusEnum>
    _$adminPaymentDetailDtoOutputStatusEnumSerializer =
    _$AdminPaymentDetailDtoOutputStatusEnumSerializer();

class _$AdminPaymentDetailDtoOutputProviderEnumSerializer
    implements PrimitiveSerializer<AdminPaymentDetailDtoOutputProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VNPAY': 'VNPAY',
    'MOMO': 'MOMO',
    'PAYOS': 'PAYOS',
    'DEMO': 'DEMO',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VNPAY': 'VNPAY',
    'MOMO': 'MOMO',
    'PAYOS': 'PAYOS',
    'DEMO': 'DEMO',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminPaymentDetailDtoOutputProviderEnum
  ];
  @override
  final String wireName = 'AdminPaymentDetailDtoOutputProviderEnum';

  @override
  Object serialize(Serializers serializers,
          AdminPaymentDetailDtoOutputProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminPaymentDetailDtoOutputProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminPaymentDetailDtoOutputProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminPaymentDetailDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminPaymentDetailDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INITIATED': 'INITIATED',
    'PROCESSING': 'PROCESSING',
    'SUCCESS': 'SUCCESS',
    'FAILED': 'FAILED',
    'EXPIRED': 'EXPIRED',
    'CANCELLED': 'CANCELLED',
    'RECONCILING': 'RECONCILING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INITIATED': 'INITIATED',
    'PROCESSING': 'PROCESSING',
    'SUCCESS': 'SUCCESS',
    'FAILED': 'FAILED',
    'EXPIRED': 'EXPIRED',
    'CANCELLED': 'CANCELLED',
    'RECONCILING': 'RECONCILING',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminPaymentDetailDtoOutputStatusEnum
  ];
  @override
  final String wireName = 'AdminPaymentDetailDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AdminPaymentDetailDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminPaymentDetailDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminPaymentDetailDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminPaymentDetailDtoOutput extends AdminPaymentDetailDtoOutput {
  @override
  final String paymentId;
  @override
  final String paymentCode;
  @override
  final String bookingId;
  @override
  final String bookingCode;
  @override
  final String operatorId;
  @override
  final String operatorName;
  @override
  final AdminPaymentDetailDtoOutputProviderEnum provider;
  @override
  final int amount;
  @override
  final AdminPaymentDetailDtoOutputStatusEnum status;
  @override
  final String? reconcileReason;
  @override
  final String? failureCode;
  @override
  final bool reconcileResolved;
  @override
  final DateTime createdAt;
  @override
  final DateTime? paidAt;
  @override
  final String? providerTxnId;
  @override
  final DateTime expiresAt;
  @override
  final DateTime? lastCallbackAt;
  @override
  final bool? amountMatches;
  @override
  final AdminPaymentDetailDtoOutputBooking booking;
  @override
  final AdminPaymentDetailDtoOutputAllocation? allocation;
  @override
  final BuiltList<AdminPaymentDetailDtoOutputHistoriesInner> histories;
  @override
  final BuiltList<AdminPaymentDetailDtoOutputTicketsInner> tickets;
  @override
  final BuiltList<AdminPaymentDetailDtoOutputLedgerInner> ledger;
  @override
  final BuiltList<AdminPaymentDetailDtoOutputRefundsInner> refunds;
  @override
  final bool canRefund;

  factory _$AdminPaymentDetailDtoOutput(
          [void Function(AdminPaymentDetailDtoOutputBuilder)? updates]) =>
      (AdminPaymentDetailDtoOutputBuilder()..update(updates))._build();

  _$AdminPaymentDetailDtoOutput._(
      {required this.paymentId,
      required this.paymentCode,
      required this.bookingId,
      required this.bookingCode,
      required this.operatorId,
      required this.operatorName,
      required this.provider,
      required this.amount,
      required this.status,
      this.reconcileReason,
      this.failureCode,
      required this.reconcileResolved,
      required this.createdAt,
      this.paidAt,
      this.providerTxnId,
      required this.expiresAt,
      this.lastCallbackAt,
      this.amountMatches,
      required this.booking,
      this.allocation,
      required this.histories,
      required this.tickets,
      required this.ledger,
      required this.refunds,
      required this.canRefund})
      : super._();
  @override
  AdminPaymentDetailDtoOutput rebuild(
          void Function(AdminPaymentDetailDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPaymentDetailDtoOutputBuilder toBuilder() =>
      AdminPaymentDetailDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPaymentDetailDtoOutput &&
        paymentId == other.paymentId &&
        paymentCode == other.paymentCode &&
        bookingId == other.bookingId &&
        bookingCode == other.bookingCode &&
        operatorId == other.operatorId &&
        operatorName == other.operatorName &&
        provider == other.provider &&
        amount == other.amount &&
        status == other.status &&
        reconcileReason == other.reconcileReason &&
        failureCode == other.failureCode &&
        reconcileResolved == other.reconcileResolved &&
        createdAt == other.createdAt &&
        paidAt == other.paidAt &&
        providerTxnId == other.providerTxnId &&
        expiresAt == other.expiresAt &&
        lastCallbackAt == other.lastCallbackAt &&
        amountMatches == other.amountMatches &&
        booking == other.booking &&
        allocation == other.allocation &&
        histories == other.histories &&
        tickets == other.tickets &&
        ledger == other.ledger &&
        refunds == other.refunds &&
        canRefund == other.canRefund;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentId.hashCode);
    _$hash = $jc(_$hash, paymentCode.hashCode);
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, bookingCode.hashCode);
    _$hash = $jc(_$hash, operatorId.hashCode);
    _$hash = $jc(_$hash, operatorName.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, reconcileReason.hashCode);
    _$hash = $jc(_$hash, failureCode.hashCode);
    _$hash = $jc(_$hash, reconcileResolved.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, paidAt.hashCode);
    _$hash = $jc(_$hash, providerTxnId.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, lastCallbackAt.hashCode);
    _$hash = $jc(_$hash, amountMatches.hashCode);
    _$hash = $jc(_$hash, booking.hashCode);
    _$hash = $jc(_$hash, allocation.hashCode);
    _$hash = $jc(_$hash, histories.hashCode);
    _$hash = $jc(_$hash, tickets.hashCode);
    _$hash = $jc(_$hash, ledger.hashCode);
    _$hash = $jc(_$hash, refunds.hashCode);
    _$hash = $jc(_$hash, canRefund.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPaymentDetailDtoOutput')
          ..add('paymentId', paymentId)
          ..add('paymentCode', paymentCode)
          ..add('bookingId', bookingId)
          ..add('bookingCode', bookingCode)
          ..add('operatorId', operatorId)
          ..add('operatorName', operatorName)
          ..add('provider', provider)
          ..add('amount', amount)
          ..add('status', status)
          ..add('reconcileReason', reconcileReason)
          ..add('failureCode', failureCode)
          ..add('reconcileResolved', reconcileResolved)
          ..add('createdAt', createdAt)
          ..add('paidAt', paidAt)
          ..add('providerTxnId', providerTxnId)
          ..add('expiresAt', expiresAt)
          ..add('lastCallbackAt', lastCallbackAt)
          ..add('amountMatches', amountMatches)
          ..add('booking', booking)
          ..add('allocation', allocation)
          ..add('histories', histories)
          ..add('tickets', tickets)
          ..add('ledger', ledger)
          ..add('refunds', refunds)
          ..add('canRefund', canRefund))
        .toString();
  }
}

class AdminPaymentDetailDtoOutputBuilder
    implements
        Builder<AdminPaymentDetailDtoOutput,
            AdminPaymentDetailDtoOutputBuilder> {
  _$AdminPaymentDetailDtoOutput? _$v;

  String? _paymentId;
  String? get paymentId => _$this._paymentId;
  set paymentId(String? paymentId) => _$this._paymentId = paymentId;

  String? _paymentCode;
  String? get paymentCode => _$this._paymentCode;
  set paymentCode(String? paymentCode) => _$this._paymentCode = paymentCode;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _bookingCode;
  String? get bookingCode => _$this._bookingCode;
  set bookingCode(String? bookingCode) => _$this._bookingCode = bookingCode;

  String? _operatorId;
  String? get operatorId => _$this._operatorId;
  set operatorId(String? operatorId) => _$this._operatorId = operatorId;

  String? _operatorName;
  String? get operatorName => _$this._operatorName;
  set operatorName(String? operatorName) => _$this._operatorName = operatorName;

  AdminPaymentDetailDtoOutputProviderEnum? _provider;
  AdminPaymentDetailDtoOutputProviderEnum? get provider => _$this._provider;
  set provider(AdminPaymentDetailDtoOutputProviderEnum? provider) =>
      _$this._provider = provider;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  AdminPaymentDetailDtoOutputStatusEnum? _status;
  AdminPaymentDetailDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminPaymentDetailDtoOutputStatusEnum? status) =>
      _$this._status = status;

  String? _reconcileReason;
  String? get reconcileReason => _$this._reconcileReason;
  set reconcileReason(String? reconcileReason) =>
      _$this._reconcileReason = reconcileReason;

  String? _failureCode;
  String? get failureCode => _$this._failureCode;
  set failureCode(String? failureCode) => _$this._failureCode = failureCode;

  bool? _reconcileResolved;
  bool? get reconcileResolved => _$this._reconcileResolved;
  set reconcileResolved(bool? reconcileResolved) =>
      _$this._reconcileResolved = reconcileResolved;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _paidAt;
  DateTime? get paidAt => _$this._paidAt;
  set paidAt(DateTime? paidAt) => _$this._paidAt = paidAt;

  String? _providerTxnId;
  String? get providerTxnId => _$this._providerTxnId;
  set providerTxnId(String? providerTxnId) =>
      _$this._providerTxnId = providerTxnId;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DateTime? _lastCallbackAt;
  DateTime? get lastCallbackAt => _$this._lastCallbackAt;
  set lastCallbackAt(DateTime? lastCallbackAt) =>
      _$this._lastCallbackAt = lastCallbackAt;

  bool? _amountMatches;
  bool? get amountMatches => _$this._amountMatches;
  set amountMatches(bool? amountMatches) =>
      _$this._amountMatches = amountMatches;

  AdminPaymentDetailDtoOutputBookingBuilder? _booking;
  AdminPaymentDetailDtoOutputBookingBuilder get booking =>
      _$this._booking ??= AdminPaymentDetailDtoOutputBookingBuilder();
  set booking(AdminPaymentDetailDtoOutputBookingBuilder? booking) =>
      _$this._booking = booking;

  AdminPaymentDetailDtoOutputAllocationBuilder? _allocation;
  AdminPaymentDetailDtoOutputAllocationBuilder get allocation =>
      _$this._allocation ??= AdminPaymentDetailDtoOutputAllocationBuilder();
  set allocation(AdminPaymentDetailDtoOutputAllocationBuilder? allocation) =>
      _$this._allocation = allocation;

  ListBuilder<AdminPaymentDetailDtoOutputHistoriesInner>? _histories;
  ListBuilder<AdminPaymentDetailDtoOutputHistoriesInner> get histories =>
      _$this._histories ??=
          ListBuilder<AdminPaymentDetailDtoOutputHistoriesInner>();
  set histories(
          ListBuilder<AdminPaymentDetailDtoOutputHistoriesInner>? histories) =>
      _$this._histories = histories;

  ListBuilder<AdminPaymentDetailDtoOutputTicketsInner>? _tickets;
  ListBuilder<AdminPaymentDetailDtoOutputTicketsInner> get tickets =>
      _$this._tickets ??=
          ListBuilder<AdminPaymentDetailDtoOutputTicketsInner>();
  set tickets(ListBuilder<AdminPaymentDetailDtoOutputTicketsInner>? tickets) =>
      _$this._tickets = tickets;

  ListBuilder<AdminPaymentDetailDtoOutputLedgerInner>? _ledger;
  ListBuilder<AdminPaymentDetailDtoOutputLedgerInner> get ledger =>
      _$this._ledger ??= ListBuilder<AdminPaymentDetailDtoOutputLedgerInner>();
  set ledger(ListBuilder<AdminPaymentDetailDtoOutputLedgerInner>? ledger) =>
      _$this._ledger = ledger;

  ListBuilder<AdminPaymentDetailDtoOutputRefundsInner>? _refunds;
  ListBuilder<AdminPaymentDetailDtoOutputRefundsInner> get refunds =>
      _$this._refunds ??=
          ListBuilder<AdminPaymentDetailDtoOutputRefundsInner>();
  set refunds(ListBuilder<AdminPaymentDetailDtoOutputRefundsInner>? refunds) =>
      _$this._refunds = refunds;

  bool? _canRefund;
  bool? get canRefund => _$this._canRefund;
  set canRefund(bool? canRefund) => _$this._canRefund = canRefund;

  AdminPaymentDetailDtoOutputBuilder() {
    AdminPaymentDetailDtoOutput._defaults(this);
  }

  AdminPaymentDetailDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentId = $v.paymentId;
      _paymentCode = $v.paymentCode;
      _bookingId = $v.bookingId;
      _bookingCode = $v.bookingCode;
      _operatorId = $v.operatorId;
      _operatorName = $v.operatorName;
      _provider = $v.provider;
      _amount = $v.amount;
      _status = $v.status;
      _reconcileReason = $v.reconcileReason;
      _failureCode = $v.failureCode;
      _reconcileResolved = $v.reconcileResolved;
      _createdAt = $v.createdAt;
      _paidAt = $v.paidAt;
      _providerTxnId = $v.providerTxnId;
      _expiresAt = $v.expiresAt;
      _lastCallbackAt = $v.lastCallbackAt;
      _amountMatches = $v.amountMatches;
      _booking = $v.booking.toBuilder();
      _allocation = $v.allocation?.toBuilder();
      _histories = $v.histories.toBuilder();
      _tickets = $v.tickets.toBuilder();
      _ledger = $v.ledger.toBuilder();
      _refunds = $v.refunds.toBuilder();
      _canRefund = $v.canRefund;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPaymentDetailDtoOutput other) {
    _$v = other as _$AdminPaymentDetailDtoOutput;
  }

  @override
  void update(void Function(AdminPaymentDetailDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPaymentDetailDtoOutput build() => _build();

  _$AdminPaymentDetailDtoOutput _build() {
    _$AdminPaymentDetailDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminPaymentDetailDtoOutput._(
            paymentId: BuiltValueNullFieldError.checkNotNull(
                paymentId, r'AdminPaymentDetailDtoOutput', 'paymentId'),
            paymentCode: BuiltValueNullFieldError.checkNotNull(
                paymentCode, r'AdminPaymentDetailDtoOutput', 'paymentCode'),
            bookingId: BuiltValueNullFieldError.checkNotNull(
                bookingId, r'AdminPaymentDetailDtoOutput', 'bookingId'),
            bookingCode: BuiltValueNullFieldError.checkNotNull(
                bookingCode, r'AdminPaymentDetailDtoOutput', 'bookingCode'),
            operatorId: BuiltValueNullFieldError.checkNotNull(
                operatorId, r'AdminPaymentDetailDtoOutput', 'operatorId'),
            operatorName: BuiltValueNullFieldError.checkNotNull(
                operatorName, r'AdminPaymentDetailDtoOutput', 'operatorName'),
            provider: BuiltValueNullFieldError.checkNotNull(
                provider, r'AdminPaymentDetailDtoOutput', 'provider'),
            amount: BuiltValueNullFieldError.checkNotNull(
                amount, r'AdminPaymentDetailDtoOutput', 'amount'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminPaymentDetailDtoOutput', 'status'),
            reconcileReason: reconcileReason,
            failureCode: failureCode,
            reconcileResolved: BuiltValueNullFieldError.checkNotNull(
                reconcileResolved,
                r'AdminPaymentDetailDtoOutput',
                'reconcileResolved'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'AdminPaymentDetailDtoOutput', 'createdAt'),
            paidAt: paidAt,
            providerTxnId: providerTxnId,
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'AdminPaymentDetailDtoOutput', 'expiresAt'),
            lastCallbackAt: lastCallbackAt,
            amountMatches: amountMatches,
            booking: booking.build(),
            allocation: _allocation?.build(),
            histories: histories.build(),
            tickets: tickets.build(),
            ledger: ledger.build(),
            refunds: refunds.build(),
            canRefund: BuiltValueNullFieldError.checkNotNull(
                canRefund, r'AdminPaymentDetailDtoOutput', 'canRefund'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'booking';
        booking.build();
        _$failedField = 'allocation';
        _allocation?.build();
        _$failedField = 'histories';
        histories.build();
        _$failedField = 'tickets';
        tickets.build();
        _$failedField = 'ledger';
        ledger.build();
        _$failedField = 'refunds';
        refunds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminPaymentDetailDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
