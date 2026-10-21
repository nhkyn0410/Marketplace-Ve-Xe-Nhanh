// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_booking_page_dto_output_items_inner_payment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum
    _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnum_VNPAY =
    const OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum._('VNPAY');
const OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum
    _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnum_MOMO =
    const OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum._('MOMO');

OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum
    _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnumValueOf(
        String name) {
  switch (name) {
    case 'VNPAY':
      return _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnum_VNPAY;
    case 'MOMO':
      return _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnum_MOMO;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum>
    _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnumValues =
    BuiltSet<
        OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum>(const <OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum>[
  _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnum_VNPAY,
  _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnum_MOMO,
]);

const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_INITIATED =
    const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum._(
        'INITIATED');
const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_PROCESSING =
    const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum._(
        'PROCESSING');
const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_SUCCESS =
    const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum._('SUCCESS');
const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_FAILED =
    const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum._('FAILED');
const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_EXPIRED =
    const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum._('EXPIRED');
const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_CANCELLED =
    const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum._(
        'CANCELLED');
const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_RECONCILING =
    const OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum._(
        'RECONCILING');

OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum
    _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'INITIATED':
      return _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_INITIATED;
    case 'PROCESSING':
      return _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_PROCESSING;
    case 'SUCCESS':
      return _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_SUCCESS;
    case 'FAILED':
      return _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_FAILED;
    case 'EXPIRED':
      return _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_EXPIRED;
    case 'CANCELLED':
      return _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_CANCELLED;
    case 'RECONCILING':
      return _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_RECONCILING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum>
    _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnumValues = BuiltSet<
        OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum>(const <OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum>[
  _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_INITIATED,
  _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_PROCESSING,
  _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_SUCCESS,
  _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_FAILED,
  _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_EXPIRED,
  _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_CANCELLED,
  _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnum_RECONCILING,
]);

Serializer<OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum>
    _$operatorBookingPageDtoOutputItemsInnerPaymentProviderEnumSerializer =
    _$OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnumSerializer();
Serializer<OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum>
    _$operatorBookingPageDtoOutputItemsInnerPaymentStatusEnumSerializer =
    _$OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnumSerializer();

class _$OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnumSerializer
    implements
        PrimitiveSerializer<
            OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum> {
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
    OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum
  ];
  @override
  final String wireName =
      'OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum';

  @override
  Object serialize(Serializers serializers,
          OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnumSerializer
    implements
        PrimitiveSerializer<
            OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum> {
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
    OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum
  ];
  @override
  final String wireName =
      'OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum';

  @override
  Object serialize(Serializers serializers,
          OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OperatorBookingPageDtoOutputItemsInnerPayment
    extends OperatorBookingPageDtoOutputItemsInnerPayment {
  @override
  final OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum provider;
  @override
  final OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum status;
  @override
  final DateTime? paidAt;

  factory _$OperatorBookingPageDtoOutputItemsInnerPayment(
          [void Function(OperatorBookingPageDtoOutputItemsInnerPaymentBuilder)?
              updates]) =>
      (OperatorBookingPageDtoOutputItemsInnerPaymentBuilder()..update(updates))
          ._build();

  _$OperatorBookingPageDtoOutputItemsInnerPayment._(
      {required this.provider, required this.status, this.paidAt})
      : super._();
  @override
  OperatorBookingPageDtoOutputItemsInnerPayment rebuild(
          void Function(OperatorBookingPageDtoOutputItemsInnerPaymentBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperatorBookingPageDtoOutputItemsInnerPaymentBuilder toBuilder() =>
      OperatorBookingPageDtoOutputItemsInnerPaymentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperatorBookingPageDtoOutputItemsInnerPayment &&
        provider == other.provider &&
        status == other.status &&
        paidAt == other.paidAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, paidAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'OperatorBookingPageDtoOutputItemsInnerPayment')
          ..add('provider', provider)
          ..add('status', status)
          ..add('paidAt', paidAt))
        .toString();
  }
}

class OperatorBookingPageDtoOutputItemsInnerPaymentBuilder
    implements
        Builder<OperatorBookingPageDtoOutputItemsInnerPayment,
            OperatorBookingPageDtoOutputItemsInnerPaymentBuilder> {
  _$OperatorBookingPageDtoOutputItemsInnerPayment? _$v;

  OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum? _provider;
  OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum? get provider =>
      _$this._provider;
  set provider(
          OperatorBookingPageDtoOutputItemsInnerPaymentProviderEnum?
              provider) =>
      _$this._provider = provider;

  OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum? _status;
  OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum? get status =>
      _$this._status;
  set status(OperatorBookingPageDtoOutputItemsInnerPaymentStatusEnum? status) =>
      _$this._status = status;

  DateTime? _paidAt;
  DateTime? get paidAt => _$this._paidAt;
  set paidAt(DateTime? paidAt) => _$this._paidAt = paidAt;

  OperatorBookingPageDtoOutputItemsInnerPaymentBuilder() {
    OperatorBookingPageDtoOutputItemsInnerPayment._defaults(this);
  }

  OperatorBookingPageDtoOutputItemsInnerPaymentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _provider = $v.provider;
      _status = $v.status;
      _paidAt = $v.paidAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperatorBookingPageDtoOutputItemsInnerPayment other) {
    _$v = other as _$OperatorBookingPageDtoOutputItemsInnerPayment;
  }

  @override
  void update(
      void Function(OperatorBookingPageDtoOutputItemsInnerPaymentBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  OperatorBookingPageDtoOutputItemsInnerPayment build() => _build();

  _$OperatorBookingPageDtoOutputItemsInnerPayment _build() {
    final _$result = _$v ??
        _$OperatorBookingPageDtoOutputItemsInnerPayment._(
          provider: BuiltValueNullFieldError.checkNotNull(provider,
              r'OperatorBookingPageDtoOutputItemsInnerPayment', 'provider'),
          status: BuiltValueNullFieldError.checkNotNull(status,
              r'OperatorBookingPageDtoOutputItemsInnerPayment', 'status'),
          paidAt: paidAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
