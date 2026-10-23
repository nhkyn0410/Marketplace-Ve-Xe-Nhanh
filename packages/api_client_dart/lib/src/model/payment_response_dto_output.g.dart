// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_response_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PaymentResponseDtoOutputProviderEnum
    _$paymentResponseDtoOutputProviderEnum_VNPAY =
    const PaymentResponseDtoOutputProviderEnum._('VNPAY');
const PaymentResponseDtoOutputProviderEnum
    _$paymentResponseDtoOutputProviderEnum_MOMO =
    const PaymentResponseDtoOutputProviderEnum._('MOMO');

PaymentResponseDtoOutputProviderEnum
    _$paymentResponseDtoOutputProviderEnumValueOf(String name) {
  switch (name) {
    case 'VNPAY':
      return _$paymentResponseDtoOutputProviderEnum_VNPAY;
    case 'MOMO':
      return _$paymentResponseDtoOutputProviderEnum_MOMO;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentResponseDtoOutputProviderEnum>
    _$paymentResponseDtoOutputProviderEnumValues = BuiltSet<
        PaymentResponseDtoOutputProviderEnum>(const <PaymentResponseDtoOutputProviderEnum>[
  _$paymentResponseDtoOutputProviderEnum_VNPAY,
  _$paymentResponseDtoOutputProviderEnum_MOMO,
]);

const PaymentResponseDtoOutputStatusEnum
    _$paymentResponseDtoOutputStatusEnum_INITIATED =
    const PaymentResponseDtoOutputStatusEnum._('INITIATED');
const PaymentResponseDtoOutputStatusEnum
    _$paymentResponseDtoOutputStatusEnum_PROCESSING =
    const PaymentResponseDtoOutputStatusEnum._('PROCESSING');
const PaymentResponseDtoOutputStatusEnum
    _$paymentResponseDtoOutputStatusEnum_SUCCESS =
    const PaymentResponseDtoOutputStatusEnum._('SUCCESS');
const PaymentResponseDtoOutputStatusEnum
    _$paymentResponseDtoOutputStatusEnum_FAILED =
    const PaymentResponseDtoOutputStatusEnum._('FAILED');
const PaymentResponseDtoOutputStatusEnum
    _$paymentResponseDtoOutputStatusEnum_EXPIRED =
    const PaymentResponseDtoOutputStatusEnum._('EXPIRED');
const PaymentResponseDtoOutputStatusEnum
    _$paymentResponseDtoOutputStatusEnum_CANCELLED =
    const PaymentResponseDtoOutputStatusEnum._('CANCELLED');
const PaymentResponseDtoOutputStatusEnum
    _$paymentResponseDtoOutputStatusEnum_RECONCILING =
    const PaymentResponseDtoOutputStatusEnum._('RECONCILING');

PaymentResponseDtoOutputStatusEnum _$paymentResponseDtoOutputStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'INITIATED':
      return _$paymentResponseDtoOutputStatusEnum_INITIATED;
    case 'PROCESSING':
      return _$paymentResponseDtoOutputStatusEnum_PROCESSING;
    case 'SUCCESS':
      return _$paymentResponseDtoOutputStatusEnum_SUCCESS;
    case 'FAILED':
      return _$paymentResponseDtoOutputStatusEnum_FAILED;
    case 'EXPIRED':
      return _$paymentResponseDtoOutputStatusEnum_EXPIRED;
    case 'CANCELLED':
      return _$paymentResponseDtoOutputStatusEnum_CANCELLED;
    case 'RECONCILING':
      return _$paymentResponseDtoOutputStatusEnum_RECONCILING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentResponseDtoOutputStatusEnum>
    _$paymentResponseDtoOutputStatusEnumValues = BuiltSet<
        PaymentResponseDtoOutputStatusEnum>(const <PaymentResponseDtoOutputStatusEnum>[
  _$paymentResponseDtoOutputStatusEnum_INITIATED,
  _$paymentResponseDtoOutputStatusEnum_PROCESSING,
  _$paymentResponseDtoOutputStatusEnum_SUCCESS,
  _$paymentResponseDtoOutputStatusEnum_FAILED,
  _$paymentResponseDtoOutputStatusEnum_EXPIRED,
  _$paymentResponseDtoOutputStatusEnum_CANCELLED,
  _$paymentResponseDtoOutputStatusEnum_RECONCILING,
]);

Serializer<PaymentResponseDtoOutputProviderEnum>
    _$paymentResponseDtoOutputProviderEnumSerializer =
    _$PaymentResponseDtoOutputProviderEnumSerializer();
Serializer<PaymentResponseDtoOutputStatusEnum>
    _$paymentResponseDtoOutputStatusEnumSerializer =
    _$PaymentResponseDtoOutputStatusEnumSerializer();

class _$PaymentResponseDtoOutputProviderEnumSerializer
    implements PrimitiveSerializer<PaymentResponseDtoOutputProviderEnum> {
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
    PaymentResponseDtoOutputProviderEnum
  ];
  @override
  final String wireName = 'PaymentResponseDtoOutputProviderEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentResponseDtoOutputProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentResponseDtoOutputProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentResponseDtoOutputProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentResponseDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<PaymentResponseDtoOutputStatusEnum> {
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
  final Iterable<Type> types = const <Type>[PaymentResponseDtoOutputStatusEnum];
  @override
  final String wireName = 'PaymentResponseDtoOutputStatusEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentResponseDtoOutputStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentResponseDtoOutputStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentResponseDtoOutputStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentResponseDtoOutput extends PaymentResponseDtoOutput {
  @override
  final String paymentId;
  @override
  final String paymentCode;
  @override
  final PaymentResponseDtoOutputProviderEnum provider;
  @override
  final PaymentResponseDtoOutputStatusEnum status;
  @override
  final int amount;
  @override
  final String paymentUrl;
  @override
  final DateTime expiresAt;

  factory _$PaymentResponseDtoOutput(
          [void Function(PaymentResponseDtoOutputBuilder)? updates]) =>
      (PaymentResponseDtoOutputBuilder()..update(updates))._build();

  _$PaymentResponseDtoOutput._(
      {required this.paymentId,
      required this.paymentCode,
      required this.provider,
      required this.status,
      required this.amount,
      required this.paymentUrl,
      required this.expiresAt})
      : super._();
  @override
  PaymentResponseDtoOutput rebuild(
          void Function(PaymentResponseDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentResponseDtoOutputBuilder toBuilder() =>
      PaymentResponseDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentResponseDtoOutput &&
        paymentId == other.paymentId &&
        paymentCode == other.paymentCode &&
        provider == other.provider &&
        status == other.status &&
        amount == other.amount &&
        paymentUrl == other.paymentUrl &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentId.hashCode);
    _$hash = $jc(_$hash, paymentCode.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, paymentUrl.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentResponseDtoOutput')
          ..add('paymentId', paymentId)
          ..add('paymentCode', paymentCode)
          ..add('provider', provider)
          ..add('status', status)
          ..add('amount', amount)
          ..add('paymentUrl', paymentUrl)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class PaymentResponseDtoOutputBuilder
    implements
        Builder<PaymentResponseDtoOutput, PaymentResponseDtoOutputBuilder> {
  _$PaymentResponseDtoOutput? _$v;

  String? _paymentId;
  String? get paymentId => _$this._paymentId;
  set paymentId(String? paymentId) => _$this._paymentId = paymentId;

  String? _paymentCode;
  String? get paymentCode => _$this._paymentCode;
  set paymentCode(String? paymentCode) => _$this._paymentCode = paymentCode;

  PaymentResponseDtoOutputProviderEnum? _provider;
  PaymentResponseDtoOutputProviderEnum? get provider => _$this._provider;
  set provider(PaymentResponseDtoOutputProviderEnum? provider) =>
      _$this._provider = provider;

  PaymentResponseDtoOutputStatusEnum? _status;
  PaymentResponseDtoOutputStatusEnum? get status => _$this._status;
  set status(PaymentResponseDtoOutputStatusEnum? status) =>
      _$this._status = status;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  String? _paymentUrl;
  String? get paymentUrl => _$this._paymentUrl;
  set paymentUrl(String? paymentUrl) => _$this._paymentUrl = paymentUrl;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  PaymentResponseDtoOutputBuilder() {
    PaymentResponseDtoOutput._defaults(this);
  }

  PaymentResponseDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentId = $v.paymentId;
      _paymentCode = $v.paymentCode;
      _provider = $v.provider;
      _status = $v.status;
      _amount = $v.amount;
      _paymentUrl = $v.paymentUrl;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentResponseDtoOutput other) {
    _$v = other as _$PaymentResponseDtoOutput;
  }

  @override
  void update(void Function(PaymentResponseDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentResponseDtoOutput build() => _build();

  _$PaymentResponseDtoOutput _build() {
    final _$result = _$v ??
        _$PaymentResponseDtoOutput._(
          paymentId: BuiltValueNullFieldError.checkNotNull(
              paymentId, r'PaymentResponseDtoOutput', 'paymentId'),
          paymentCode: BuiltValueNullFieldError.checkNotNull(
              paymentCode, r'PaymentResponseDtoOutput', 'paymentCode'),
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'PaymentResponseDtoOutput', 'provider'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'PaymentResponseDtoOutput', 'status'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'PaymentResponseDtoOutput', 'amount'),
          paymentUrl: BuiltValueNullFieldError.checkNotNull(
              paymentUrl, r'PaymentResponseDtoOutput', 'paymentUrl'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'PaymentResponseDtoOutput', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
