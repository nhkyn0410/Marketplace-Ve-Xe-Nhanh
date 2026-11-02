// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_booking_dto_output_payment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreatedBookingDtoOutputPaymentProviderEnum
    _$createdBookingDtoOutputPaymentProviderEnum_VNPAY =
    const CreatedBookingDtoOutputPaymentProviderEnum._('VNPAY');
const CreatedBookingDtoOutputPaymentProviderEnum
    _$createdBookingDtoOutputPaymentProviderEnum_MOMO =
    const CreatedBookingDtoOutputPaymentProviderEnum._('MOMO');
const CreatedBookingDtoOutputPaymentProviderEnum
    _$createdBookingDtoOutputPaymentProviderEnum_PAYOS =
    const CreatedBookingDtoOutputPaymentProviderEnum._('PAYOS');
const CreatedBookingDtoOutputPaymentProviderEnum
    _$createdBookingDtoOutputPaymentProviderEnum_DEMO =
    const CreatedBookingDtoOutputPaymentProviderEnum._('DEMO');

CreatedBookingDtoOutputPaymentProviderEnum
    _$createdBookingDtoOutputPaymentProviderEnumValueOf(String name) {
  switch (name) {
    case 'VNPAY':
      return _$createdBookingDtoOutputPaymentProviderEnum_VNPAY;
    case 'MOMO':
      return _$createdBookingDtoOutputPaymentProviderEnum_MOMO;
    case 'PAYOS':
      return _$createdBookingDtoOutputPaymentProviderEnum_PAYOS;
    case 'DEMO':
      return _$createdBookingDtoOutputPaymentProviderEnum_DEMO;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreatedBookingDtoOutputPaymentProviderEnum>
    _$createdBookingDtoOutputPaymentProviderEnumValues = BuiltSet<
        CreatedBookingDtoOutputPaymentProviderEnum>(const <CreatedBookingDtoOutputPaymentProviderEnum>[
  _$createdBookingDtoOutputPaymentProviderEnum_VNPAY,
  _$createdBookingDtoOutputPaymentProviderEnum_MOMO,
  _$createdBookingDtoOutputPaymentProviderEnum_PAYOS,
  _$createdBookingDtoOutputPaymentProviderEnum_DEMO,
]);

const CreatedBookingDtoOutputPaymentStatusEnum
    _$createdBookingDtoOutputPaymentStatusEnum_INITIATED =
    const CreatedBookingDtoOutputPaymentStatusEnum._('INITIATED');
const CreatedBookingDtoOutputPaymentStatusEnum
    _$createdBookingDtoOutputPaymentStatusEnum_PROCESSING =
    const CreatedBookingDtoOutputPaymentStatusEnum._('PROCESSING');
const CreatedBookingDtoOutputPaymentStatusEnum
    _$createdBookingDtoOutputPaymentStatusEnum_SUCCESS =
    const CreatedBookingDtoOutputPaymentStatusEnum._('SUCCESS');
const CreatedBookingDtoOutputPaymentStatusEnum
    _$createdBookingDtoOutputPaymentStatusEnum_FAILED =
    const CreatedBookingDtoOutputPaymentStatusEnum._('FAILED');
const CreatedBookingDtoOutputPaymentStatusEnum
    _$createdBookingDtoOutputPaymentStatusEnum_EXPIRED =
    const CreatedBookingDtoOutputPaymentStatusEnum._('EXPIRED');
const CreatedBookingDtoOutputPaymentStatusEnum
    _$createdBookingDtoOutputPaymentStatusEnum_CANCELLED =
    const CreatedBookingDtoOutputPaymentStatusEnum._('CANCELLED');
const CreatedBookingDtoOutputPaymentStatusEnum
    _$createdBookingDtoOutputPaymentStatusEnum_RECONCILING =
    const CreatedBookingDtoOutputPaymentStatusEnum._('RECONCILING');

CreatedBookingDtoOutputPaymentStatusEnum
    _$createdBookingDtoOutputPaymentStatusEnumValueOf(String name) {
  switch (name) {
    case 'INITIATED':
      return _$createdBookingDtoOutputPaymentStatusEnum_INITIATED;
    case 'PROCESSING':
      return _$createdBookingDtoOutputPaymentStatusEnum_PROCESSING;
    case 'SUCCESS':
      return _$createdBookingDtoOutputPaymentStatusEnum_SUCCESS;
    case 'FAILED':
      return _$createdBookingDtoOutputPaymentStatusEnum_FAILED;
    case 'EXPIRED':
      return _$createdBookingDtoOutputPaymentStatusEnum_EXPIRED;
    case 'CANCELLED':
      return _$createdBookingDtoOutputPaymentStatusEnum_CANCELLED;
    case 'RECONCILING':
      return _$createdBookingDtoOutputPaymentStatusEnum_RECONCILING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreatedBookingDtoOutputPaymentStatusEnum>
    _$createdBookingDtoOutputPaymentStatusEnumValues = BuiltSet<
        CreatedBookingDtoOutputPaymentStatusEnum>(const <CreatedBookingDtoOutputPaymentStatusEnum>[
  _$createdBookingDtoOutputPaymentStatusEnum_INITIATED,
  _$createdBookingDtoOutputPaymentStatusEnum_PROCESSING,
  _$createdBookingDtoOutputPaymentStatusEnum_SUCCESS,
  _$createdBookingDtoOutputPaymentStatusEnum_FAILED,
  _$createdBookingDtoOutputPaymentStatusEnum_EXPIRED,
  _$createdBookingDtoOutputPaymentStatusEnum_CANCELLED,
  _$createdBookingDtoOutputPaymentStatusEnum_RECONCILING,
]);

Serializer<CreatedBookingDtoOutputPaymentProviderEnum>
    _$createdBookingDtoOutputPaymentProviderEnumSerializer =
    _$CreatedBookingDtoOutputPaymentProviderEnumSerializer();
Serializer<CreatedBookingDtoOutputPaymentStatusEnum>
    _$createdBookingDtoOutputPaymentStatusEnumSerializer =
    _$CreatedBookingDtoOutputPaymentStatusEnumSerializer();

class _$CreatedBookingDtoOutputPaymentProviderEnumSerializer
    implements PrimitiveSerializer<CreatedBookingDtoOutputPaymentProviderEnum> {
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
    CreatedBookingDtoOutputPaymentProviderEnum
  ];
  @override
  final String wireName = 'CreatedBookingDtoOutputPaymentProviderEnum';

  @override
  Object serialize(Serializers serializers,
          CreatedBookingDtoOutputPaymentProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreatedBookingDtoOutputPaymentProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreatedBookingDtoOutputPaymentProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreatedBookingDtoOutputPaymentStatusEnumSerializer
    implements PrimitiveSerializer<CreatedBookingDtoOutputPaymentStatusEnum> {
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
    CreatedBookingDtoOutputPaymentStatusEnum
  ];
  @override
  final String wireName = 'CreatedBookingDtoOutputPaymentStatusEnum';

  @override
  Object serialize(Serializers serializers,
          CreatedBookingDtoOutputPaymentStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreatedBookingDtoOutputPaymentStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreatedBookingDtoOutputPaymentStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreatedBookingDtoOutputPayment extends CreatedBookingDtoOutputPayment {
  @override
  final String paymentCode;
  @override
  final CreatedBookingDtoOutputPaymentProviderEnum provider;
  @override
  final CreatedBookingDtoOutputPaymentStatusEnum status;
  @override
  final int amount;
  @override
  final DateTime? paidAt;

  factory _$CreatedBookingDtoOutputPayment(
          [void Function(CreatedBookingDtoOutputPaymentBuilder)? updates]) =>
      (CreatedBookingDtoOutputPaymentBuilder()..update(updates))._build();

  _$CreatedBookingDtoOutputPayment._(
      {required this.paymentCode,
      required this.provider,
      required this.status,
      required this.amount,
      this.paidAt})
      : super._();
  @override
  CreatedBookingDtoOutputPayment rebuild(
          void Function(CreatedBookingDtoOutputPaymentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreatedBookingDtoOutputPaymentBuilder toBuilder() =>
      CreatedBookingDtoOutputPaymentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreatedBookingDtoOutputPayment &&
        paymentCode == other.paymentCode &&
        provider == other.provider &&
        status == other.status &&
        amount == other.amount &&
        paidAt == other.paidAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentCode.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, paidAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreatedBookingDtoOutputPayment')
          ..add('paymentCode', paymentCode)
          ..add('provider', provider)
          ..add('status', status)
          ..add('amount', amount)
          ..add('paidAt', paidAt))
        .toString();
  }
}

class CreatedBookingDtoOutputPaymentBuilder
    implements
        Builder<CreatedBookingDtoOutputPayment,
            CreatedBookingDtoOutputPaymentBuilder> {
  _$CreatedBookingDtoOutputPayment? _$v;

  String? _paymentCode;
  String? get paymentCode => _$this._paymentCode;
  set paymentCode(String? paymentCode) => _$this._paymentCode = paymentCode;

  CreatedBookingDtoOutputPaymentProviderEnum? _provider;
  CreatedBookingDtoOutputPaymentProviderEnum? get provider => _$this._provider;
  set provider(CreatedBookingDtoOutputPaymentProviderEnum? provider) =>
      _$this._provider = provider;

  CreatedBookingDtoOutputPaymentStatusEnum? _status;
  CreatedBookingDtoOutputPaymentStatusEnum? get status => _$this._status;
  set status(CreatedBookingDtoOutputPaymentStatusEnum? status) =>
      _$this._status = status;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  DateTime? _paidAt;
  DateTime? get paidAt => _$this._paidAt;
  set paidAt(DateTime? paidAt) => _$this._paidAt = paidAt;

  CreatedBookingDtoOutputPaymentBuilder() {
    CreatedBookingDtoOutputPayment._defaults(this);
  }

  CreatedBookingDtoOutputPaymentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentCode = $v.paymentCode;
      _provider = $v.provider;
      _status = $v.status;
      _amount = $v.amount;
      _paidAt = $v.paidAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreatedBookingDtoOutputPayment other) {
    _$v = other as _$CreatedBookingDtoOutputPayment;
  }

  @override
  void update(void Function(CreatedBookingDtoOutputPaymentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreatedBookingDtoOutputPayment build() => _build();

  _$CreatedBookingDtoOutputPayment _build() {
    final _$result = _$v ??
        _$CreatedBookingDtoOutputPayment._(
          paymentCode: BuiltValueNullFieldError.checkNotNull(
              paymentCode, r'CreatedBookingDtoOutputPayment', 'paymentCode'),
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'CreatedBookingDtoOutputPayment', 'provider'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CreatedBookingDtoOutputPayment', 'status'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'CreatedBookingDtoOutputPayment', 'amount'),
          paidAt: paidAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
