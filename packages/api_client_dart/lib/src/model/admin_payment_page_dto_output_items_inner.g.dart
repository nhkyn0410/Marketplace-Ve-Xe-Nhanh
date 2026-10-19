// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_payment_page_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminPaymentPageDtoOutputItemsInnerProviderEnum
    _$adminPaymentPageDtoOutputItemsInnerProviderEnum_VNPAY =
    const AdminPaymentPageDtoOutputItemsInnerProviderEnum._('VNPAY');
const AdminPaymentPageDtoOutputItemsInnerProviderEnum
    _$adminPaymentPageDtoOutputItemsInnerProviderEnum_MOMO =
    const AdminPaymentPageDtoOutputItemsInnerProviderEnum._('MOMO');

AdminPaymentPageDtoOutputItemsInnerProviderEnum
    _$adminPaymentPageDtoOutputItemsInnerProviderEnumValueOf(String name) {
  switch (name) {
    case 'VNPAY':
      return _$adminPaymentPageDtoOutputItemsInnerProviderEnum_VNPAY;
    case 'MOMO':
      return _$adminPaymentPageDtoOutputItemsInnerProviderEnum_MOMO;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPaymentPageDtoOutputItemsInnerProviderEnum>
    _$adminPaymentPageDtoOutputItemsInnerProviderEnumValues = BuiltSet<
        AdminPaymentPageDtoOutputItemsInnerProviderEnum>(const <AdminPaymentPageDtoOutputItemsInnerProviderEnum>[
  _$adminPaymentPageDtoOutputItemsInnerProviderEnum_VNPAY,
  _$adminPaymentPageDtoOutputItemsInnerProviderEnum_MOMO,
]);

const AdminPaymentPageDtoOutputItemsInnerStatusEnum
    _$adminPaymentPageDtoOutputItemsInnerStatusEnum_INITIATED =
    const AdminPaymentPageDtoOutputItemsInnerStatusEnum._('INITIATED');
const AdminPaymentPageDtoOutputItemsInnerStatusEnum
    _$adminPaymentPageDtoOutputItemsInnerStatusEnum_PROCESSING =
    const AdminPaymentPageDtoOutputItemsInnerStatusEnum._('PROCESSING');
const AdminPaymentPageDtoOutputItemsInnerStatusEnum
    _$adminPaymentPageDtoOutputItemsInnerStatusEnum_SUCCESS =
    const AdminPaymentPageDtoOutputItemsInnerStatusEnum._('SUCCESS');
const AdminPaymentPageDtoOutputItemsInnerStatusEnum
    _$adminPaymentPageDtoOutputItemsInnerStatusEnum_FAILED =
    const AdminPaymentPageDtoOutputItemsInnerStatusEnum._('FAILED');
const AdminPaymentPageDtoOutputItemsInnerStatusEnum
    _$adminPaymentPageDtoOutputItemsInnerStatusEnum_EXPIRED =
    const AdminPaymentPageDtoOutputItemsInnerStatusEnum._('EXPIRED');
const AdminPaymentPageDtoOutputItemsInnerStatusEnum
    _$adminPaymentPageDtoOutputItemsInnerStatusEnum_CANCELLED =
    const AdminPaymentPageDtoOutputItemsInnerStatusEnum._('CANCELLED');
const AdminPaymentPageDtoOutputItemsInnerStatusEnum
    _$adminPaymentPageDtoOutputItemsInnerStatusEnum_RECONCILING =
    const AdminPaymentPageDtoOutputItemsInnerStatusEnum._('RECONCILING');

AdminPaymentPageDtoOutputItemsInnerStatusEnum
    _$adminPaymentPageDtoOutputItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'INITIATED':
      return _$adminPaymentPageDtoOutputItemsInnerStatusEnum_INITIATED;
    case 'PROCESSING':
      return _$adminPaymentPageDtoOutputItemsInnerStatusEnum_PROCESSING;
    case 'SUCCESS':
      return _$adminPaymentPageDtoOutputItemsInnerStatusEnum_SUCCESS;
    case 'FAILED':
      return _$adminPaymentPageDtoOutputItemsInnerStatusEnum_FAILED;
    case 'EXPIRED':
      return _$adminPaymentPageDtoOutputItemsInnerStatusEnum_EXPIRED;
    case 'CANCELLED':
      return _$adminPaymentPageDtoOutputItemsInnerStatusEnum_CANCELLED;
    case 'RECONCILING':
      return _$adminPaymentPageDtoOutputItemsInnerStatusEnum_RECONCILING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPaymentPageDtoOutputItemsInnerStatusEnum>
    _$adminPaymentPageDtoOutputItemsInnerStatusEnumValues = BuiltSet<
        AdminPaymentPageDtoOutputItemsInnerStatusEnum>(const <AdminPaymentPageDtoOutputItemsInnerStatusEnum>[
  _$adminPaymentPageDtoOutputItemsInnerStatusEnum_INITIATED,
  _$adminPaymentPageDtoOutputItemsInnerStatusEnum_PROCESSING,
  _$adminPaymentPageDtoOutputItemsInnerStatusEnum_SUCCESS,
  _$adminPaymentPageDtoOutputItemsInnerStatusEnum_FAILED,
  _$adminPaymentPageDtoOutputItemsInnerStatusEnum_EXPIRED,
  _$adminPaymentPageDtoOutputItemsInnerStatusEnum_CANCELLED,
  _$adminPaymentPageDtoOutputItemsInnerStatusEnum_RECONCILING,
]);

Serializer<AdminPaymentPageDtoOutputItemsInnerProviderEnum>
    _$adminPaymentPageDtoOutputItemsInnerProviderEnumSerializer =
    _$AdminPaymentPageDtoOutputItemsInnerProviderEnumSerializer();
Serializer<AdminPaymentPageDtoOutputItemsInnerStatusEnum>
    _$adminPaymentPageDtoOutputItemsInnerStatusEnumSerializer =
    _$AdminPaymentPageDtoOutputItemsInnerStatusEnumSerializer();

class _$AdminPaymentPageDtoOutputItemsInnerProviderEnumSerializer
    implements
        PrimitiveSerializer<AdminPaymentPageDtoOutputItemsInnerProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VNPAY': 'VNPAY',
    'MOMO': 'MOMO',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VNPAY': 'VNPAY',
    'MOMO': 'MOMO',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminPaymentPageDtoOutputItemsInnerProviderEnum
  ];
  @override
  final String wireName = 'AdminPaymentPageDtoOutputItemsInnerProviderEnum';

  @override
  Object serialize(Serializers serializers,
          AdminPaymentPageDtoOutputItemsInnerProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminPaymentPageDtoOutputItemsInnerProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminPaymentPageDtoOutputItemsInnerProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminPaymentPageDtoOutputItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminPaymentPageDtoOutputItemsInnerStatusEnum> {
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
    AdminPaymentPageDtoOutputItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminPaymentPageDtoOutputItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminPaymentPageDtoOutputItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminPaymentPageDtoOutputItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminPaymentPageDtoOutputItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminPaymentPageDtoOutputItemsInner
    extends AdminPaymentPageDtoOutputItemsInner {
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
  final AdminPaymentPageDtoOutputItemsInnerProviderEnum provider;
  @override
  final int amount;
  @override
  final AdminPaymentPageDtoOutputItemsInnerStatusEnum status;
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

  factory _$AdminPaymentPageDtoOutputItemsInner(
          [void Function(AdminPaymentPageDtoOutputItemsInnerBuilder)?
              updates]) =>
      (AdminPaymentPageDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$AdminPaymentPageDtoOutputItemsInner._(
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
      this.paidAt})
      : super._();
  @override
  AdminPaymentPageDtoOutputItemsInner rebuild(
          void Function(AdminPaymentPageDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPaymentPageDtoOutputItemsInnerBuilder toBuilder() =>
      AdminPaymentPageDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPaymentPageDtoOutputItemsInner &&
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
        paidAt == other.paidAt;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPaymentPageDtoOutputItemsInner')
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
          ..add('paidAt', paidAt))
        .toString();
  }
}

class AdminPaymentPageDtoOutputItemsInnerBuilder
    implements
        Builder<AdminPaymentPageDtoOutputItemsInner,
            AdminPaymentPageDtoOutputItemsInnerBuilder> {
  _$AdminPaymentPageDtoOutputItemsInner? _$v;

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

  AdminPaymentPageDtoOutputItemsInnerProviderEnum? _provider;
  AdminPaymentPageDtoOutputItemsInnerProviderEnum? get provider =>
      _$this._provider;
  set provider(AdminPaymentPageDtoOutputItemsInnerProviderEnum? provider) =>
      _$this._provider = provider;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  AdminPaymentPageDtoOutputItemsInnerStatusEnum? _status;
  AdminPaymentPageDtoOutputItemsInnerStatusEnum? get status => _$this._status;
  set status(AdminPaymentPageDtoOutputItemsInnerStatusEnum? status) =>
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

  AdminPaymentPageDtoOutputItemsInnerBuilder() {
    AdminPaymentPageDtoOutputItemsInner._defaults(this);
  }

  AdminPaymentPageDtoOutputItemsInnerBuilder get _$this {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPaymentPageDtoOutputItemsInner other) {
    _$v = other as _$AdminPaymentPageDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(AdminPaymentPageDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPaymentPageDtoOutputItemsInner build() => _build();

  _$AdminPaymentPageDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$AdminPaymentPageDtoOutputItemsInner._(
          paymentId: BuiltValueNullFieldError.checkNotNull(
              paymentId, r'AdminPaymentPageDtoOutputItemsInner', 'paymentId'),
          paymentCode: BuiltValueNullFieldError.checkNotNull(paymentCode,
              r'AdminPaymentPageDtoOutputItemsInner', 'paymentCode'),
          bookingId: BuiltValueNullFieldError.checkNotNull(
              bookingId, r'AdminPaymentPageDtoOutputItemsInner', 'bookingId'),
          bookingCode: BuiltValueNullFieldError.checkNotNull(bookingCode,
              r'AdminPaymentPageDtoOutputItemsInner', 'bookingCode'),
          operatorId: BuiltValueNullFieldError.checkNotNull(
              operatorId, r'AdminPaymentPageDtoOutputItemsInner', 'operatorId'),
          operatorName: BuiltValueNullFieldError.checkNotNull(operatorName,
              r'AdminPaymentPageDtoOutputItemsInner', 'operatorName'),
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'AdminPaymentPageDtoOutputItemsInner', 'provider'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'AdminPaymentPageDtoOutputItemsInner', 'amount'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminPaymentPageDtoOutputItemsInner', 'status'),
          reconcileReason: reconcileReason,
          failureCode: failureCode,
          reconcileResolved: BuiltValueNullFieldError.checkNotNull(
              reconcileResolved,
              r'AdminPaymentPageDtoOutputItemsInner',
              'reconcileResolved'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminPaymentPageDtoOutputItemsInner', 'createdAt'),
          paidAt: paidAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
