// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_detail_dto_output_payments_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TicketDetailDtoOutputPaymentsInnerProviderEnum
    _$ticketDetailDtoOutputPaymentsInnerProviderEnum_VNPAY =
    const TicketDetailDtoOutputPaymentsInnerProviderEnum._('VNPAY');
const TicketDetailDtoOutputPaymentsInnerProviderEnum
    _$ticketDetailDtoOutputPaymentsInnerProviderEnum_MOMO =
    const TicketDetailDtoOutputPaymentsInnerProviderEnum._('MOMO');

TicketDetailDtoOutputPaymentsInnerProviderEnum
    _$ticketDetailDtoOutputPaymentsInnerProviderEnumValueOf(String name) {
  switch (name) {
    case 'VNPAY':
      return _$ticketDetailDtoOutputPaymentsInnerProviderEnum_VNPAY;
    case 'MOMO':
      return _$ticketDetailDtoOutputPaymentsInnerProviderEnum_MOMO;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TicketDetailDtoOutputPaymentsInnerProviderEnum>
    _$ticketDetailDtoOutputPaymentsInnerProviderEnumValues = BuiltSet<
        TicketDetailDtoOutputPaymentsInnerProviderEnum>(const <TicketDetailDtoOutputPaymentsInnerProviderEnum>[
  _$ticketDetailDtoOutputPaymentsInnerProviderEnum_VNPAY,
  _$ticketDetailDtoOutputPaymentsInnerProviderEnum_MOMO,
]);

const TicketDetailDtoOutputPaymentsInnerStatusEnum
    _$ticketDetailDtoOutputPaymentsInnerStatusEnum_INITIATED =
    const TicketDetailDtoOutputPaymentsInnerStatusEnum._('INITIATED');
const TicketDetailDtoOutputPaymentsInnerStatusEnum
    _$ticketDetailDtoOutputPaymentsInnerStatusEnum_PROCESSING =
    const TicketDetailDtoOutputPaymentsInnerStatusEnum._('PROCESSING');
const TicketDetailDtoOutputPaymentsInnerStatusEnum
    _$ticketDetailDtoOutputPaymentsInnerStatusEnum_SUCCESS =
    const TicketDetailDtoOutputPaymentsInnerStatusEnum._('SUCCESS');
const TicketDetailDtoOutputPaymentsInnerStatusEnum
    _$ticketDetailDtoOutputPaymentsInnerStatusEnum_FAILED =
    const TicketDetailDtoOutputPaymentsInnerStatusEnum._('FAILED');
const TicketDetailDtoOutputPaymentsInnerStatusEnum
    _$ticketDetailDtoOutputPaymentsInnerStatusEnum_EXPIRED =
    const TicketDetailDtoOutputPaymentsInnerStatusEnum._('EXPIRED');
const TicketDetailDtoOutputPaymentsInnerStatusEnum
    _$ticketDetailDtoOutputPaymentsInnerStatusEnum_CANCELLED =
    const TicketDetailDtoOutputPaymentsInnerStatusEnum._('CANCELLED');
const TicketDetailDtoOutputPaymentsInnerStatusEnum
    _$ticketDetailDtoOutputPaymentsInnerStatusEnum_RECONCILING =
    const TicketDetailDtoOutputPaymentsInnerStatusEnum._('RECONCILING');

TicketDetailDtoOutputPaymentsInnerStatusEnum
    _$ticketDetailDtoOutputPaymentsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'INITIATED':
      return _$ticketDetailDtoOutputPaymentsInnerStatusEnum_INITIATED;
    case 'PROCESSING':
      return _$ticketDetailDtoOutputPaymentsInnerStatusEnum_PROCESSING;
    case 'SUCCESS':
      return _$ticketDetailDtoOutputPaymentsInnerStatusEnum_SUCCESS;
    case 'FAILED':
      return _$ticketDetailDtoOutputPaymentsInnerStatusEnum_FAILED;
    case 'EXPIRED':
      return _$ticketDetailDtoOutputPaymentsInnerStatusEnum_EXPIRED;
    case 'CANCELLED':
      return _$ticketDetailDtoOutputPaymentsInnerStatusEnum_CANCELLED;
    case 'RECONCILING':
      return _$ticketDetailDtoOutputPaymentsInnerStatusEnum_RECONCILING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TicketDetailDtoOutputPaymentsInnerStatusEnum>
    _$ticketDetailDtoOutputPaymentsInnerStatusEnumValues = BuiltSet<
        TicketDetailDtoOutputPaymentsInnerStatusEnum>(const <TicketDetailDtoOutputPaymentsInnerStatusEnum>[
  _$ticketDetailDtoOutputPaymentsInnerStatusEnum_INITIATED,
  _$ticketDetailDtoOutputPaymentsInnerStatusEnum_PROCESSING,
  _$ticketDetailDtoOutputPaymentsInnerStatusEnum_SUCCESS,
  _$ticketDetailDtoOutputPaymentsInnerStatusEnum_FAILED,
  _$ticketDetailDtoOutputPaymentsInnerStatusEnum_EXPIRED,
  _$ticketDetailDtoOutputPaymentsInnerStatusEnum_CANCELLED,
  _$ticketDetailDtoOutputPaymentsInnerStatusEnum_RECONCILING,
]);

Serializer<TicketDetailDtoOutputPaymentsInnerProviderEnum>
    _$ticketDetailDtoOutputPaymentsInnerProviderEnumSerializer =
    _$TicketDetailDtoOutputPaymentsInnerProviderEnumSerializer();
Serializer<TicketDetailDtoOutputPaymentsInnerStatusEnum>
    _$ticketDetailDtoOutputPaymentsInnerStatusEnumSerializer =
    _$TicketDetailDtoOutputPaymentsInnerStatusEnumSerializer();

class _$TicketDetailDtoOutputPaymentsInnerProviderEnumSerializer
    implements
        PrimitiveSerializer<TicketDetailDtoOutputPaymentsInnerProviderEnum> {
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
    TicketDetailDtoOutputPaymentsInnerProviderEnum
  ];
  @override
  final String wireName = 'TicketDetailDtoOutputPaymentsInnerProviderEnum';

  @override
  Object serialize(Serializers serializers,
          TicketDetailDtoOutputPaymentsInnerProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TicketDetailDtoOutputPaymentsInnerProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TicketDetailDtoOutputPaymentsInnerProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TicketDetailDtoOutputPaymentsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<TicketDetailDtoOutputPaymentsInnerStatusEnum> {
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
    TicketDetailDtoOutputPaymentsInnerStatusEnum
  ];
  @override
  final String wireName = 'TicketDetailDtoOutputPaymentsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          TicketDetailDtoOutputPaymentsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TicketDetailDtoOutputPaymentsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TicketDetailDtoOutputPaymentsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TicketDetailDtoOutputPaymentsInner
    extends TicketDetailDtoOutputPaymentsInner {
  @override
  final String paymentId;
  @override
  final String paymentCode;
  @override
  final TicketDetailDtoOutputPaymentsInnerProviderEnum provider;
  @override
  final TicketDetailDtoOutputPaymentsInnerStatusEnum status;
  @override
  final int amount;

  factory _$TicketDetailDtoOutputPaymentsInner(
          [void Function(TicketDetailDtoOutputPaymentsInnerBuilder)?
              updates]) =>
      (TicketDetailDtoOutputPaymentsInnerBuilder()..update(updates))._build();

  _$TicketDetailDtoOutputPaymentsInner._(
      {required this.paymentId,
      required this.paymentCode,
      required this.provider,
      required this.status,
      required this.amount})
      : super._();
  @override
  TicketDetailDtoOutputPaymentsInner rebuild(
          void Function(TicketDetailDtoOutputPaymentsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketDetailDtoOutputPaymentsInnerBuilder toBuilder() =>
      TicketDetailDtoOutputPaymentsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketDetailDtoOutputPaymentsInner &&
        paymentId == other.paymentId &&
        paymentCode == other.paymentCode &&
        provider == other.provider &&
        status == other.status &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentId.hashCode);
    _$hash = $jc(_$hash, paymentCode.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketDetailDtoOutputPaymentsInner')
          ..add('paymentId', paymentId)
          ..add('paymentCode', paymentCode)
          ..add('provider', provider)
          ..add('status', status)
          ..add('amount', amount))
        .toString();
  }
}

class TicketDetailDtoOutputPaymentsInnerBuilder
    implements
        Builder<TicketDetailDtoOutputPaymentsInner,
            TicketDetailDtoOutputPaymentsInnerBuilder> {
  _$TicketDetailDtoOutputPaymentsInner? _$v;

  String? _paymentId;
  String? get paymentId => _$this._paymentId;
  set paymentId(String? paymentId) => _$this._paymentId = paymentId;

  String? _paymentCode;
  String? get paymentCode => _$this._paymentCode;
  set paymentCode(String? paymentCode) => _$this._paymentCode = paymentCode;

  TicketDetailDtoOutputPaymentsInnerProviderEnum? _provider;
  TicketDetailDtoOutputPaymentsInnerProviderEnum? get provider =>
      _$this._provider;
  set provider(TicketDetailDtoOutputPaymentsInnerProviderEnum? provider) =>
      _$this._provider = provider;

  TicketDetailDtoOutputPaymentsInnerStatusEnum? _status;
  TicketDetailDtoOutputPaymentsInnerStatusEnum? get status => _$this._status;
  set status(TicketDetailDtoOutputPaymentsInnerStatusEnum? status) =>
      _$this._status = status;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  TicketDetailDtoOutputPaymentsInnerBuilder() {
    TicketDetailDtoOutputPaymentsInner._defaults(this);
  }

  TicketDetailDtoOutputPaymentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentId = $v.paymentId;
      _paymentCode = $v.paymentCode;
      _provider = $v.provider;
      _status = $v.status;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketDetailDtoOutputPaymentsInner other) {
    _$v = other as _$TicketDetailDtoOutputPaymentsInner;
  }

  @override
  void update(
      void Function(TicketDetailDtoOutputPaymentsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketDetailDtoOutputPaymentsInner build() => _build();

  _$TicketDetailDtoOutputPaymentsInner _build() {
    final _$result = _$v ??
        _$TicketDetailDtoOutputPaymentsInner._(
          paymentId: BuiltValueNullFieldError.checkNotNull(
              paymentId, r'TicketDetailDtoOutputPaymentsInner', 'paymentId'),
          paymentCode: BuiltValueNullFieldError.checkNotNull(paymentCode,
              r'TicketDetailDtoOutputPaymentsInner', 'paymentCode'),
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'TicketDetailDtoOutputPaymentsInner', 'provider'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'TicketDetailDtoOutputPaymentsInner', 'status'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'TicketDetailDtoOutputPaymentsInner', 'amount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
