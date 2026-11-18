// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_provider_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PaymentProviderListDtoOutputItemsInnerProviderEnum
    _$paymentProviderListDtoOutputItemsInnerProviderEnum_VNPAY =
    const PaymentProviderListDtoOutputItemsInnerProviderEnum._('VNPAY');
const PaymentProviderListDtoOutputItemsInnerProviderEnum
    _$paymentProviderListDtoOutputItemsInnerProviderEnum_MOMO =
    const PaymentProviderListDtoOutputItemsInnerProviderEnum._('MOMO');
const PaymentProviderListDtoOutputItemsInnerProviderEnum
    _$paymentProviderListDtoOutputItemsInnerProviderEnum_PAYOS =
    const PaymentProviderListDtoOutputItemsInnerProviderEnum._('PAYOS');
const PaymentProviderListDtoOutputItemsInnerProviderEnum
    _$paymentProviderListDtoOutputItemsInnerProviderEnum_DEMO =
    const PaymentProviderListDtoOutputItemsInnerProviderEnum._('DEMO');

PaymentProviderListDtoOutputItemsInnerProviderEnum
    _$paymentProviderListDtoOutputItemsInnerProviderEnumValueOf(String name) {
  switch (name) {
    case 'VNPAY':
      return _$paymentProviderListDtoOutputItemsInnerProviderEnum_VNPAY;
    case 'MOMO':
      return _$paymentProviderListDtoOutputItemsInnerProviderEnum_MOMO;
    case 'PAYOS':
      return _$paymentProviderListDtoOutputItemsInnerProviderEnum_PAYOS;
    case 'DEMO':
      return _$paymentProviderListDtoOutputItemsInnerProviderEnum_DEMO;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentProviderListDtoOutputItemsInnerProviderEnum>
    _$paymentProviderListDtoOutputItemsInnerProviderEnumValues = BuiltSet<
        PaymentProviderListDtoOutputItemsInnerProviderEnum>(const <PaymentProviderListDtoOutputItemsInnerProviderEnum>[
  _$paymentProviderListDtoOutputItemsInnerProviderEnum_VNPAY,
  _$paymentProviderListDtoOutputItemsInnerProviderEnum_MOMO,
  _$paymentProviderListDtoOutputItemsInnerProviderEnum_PAYOS,
  _$paymentProviderListDtoOutputItemsInnerProviderEnum_DEMO,
]);

Serializer<PaymentProviderListDtoOutputItemsInnerProviderEnum>
    _$paymentProviderListDtoOutputItemsInnerProviderEnumSerializer =
    _$PaymentProviderListDtoOutputItemsInnerProviderEnumSerializer();

class _$PaymentProviderListDtoOutputItemsInnerProviderEnumSerializer
    implements
        PrimitiveSerializer<
            PaymentProviderListDtoOutputItemsInnerProviderEnum> {
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
    PaymentProviderListDtoOutputItemsInnerProviderEnum
  ];
  @override
  final String wireName = 'PaymentProviderListDtoOutputItemsInnerProviderEnum';

  @override
  Object serialize(Serializers serializers,
          PaymentProviderListDtoOutputItemsInnerProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentProviderListDtoOutputItemsInnerProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentProviderListDtoOutputItemsInnerProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentProviderListDtoOutputItemsInner
    extends PaymentProviderListDtoOutputItemsInner {
  @override
  final PaymentProviderListDtoOutputItemsInnerProviderEnum provider;
  @override
  final bool enabled;

  factory _$PaymentProviderListDtoOutputItemsInner(
          [void Function(PaymentProviderListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (PaymentProviderListDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$PaymentProviderListDtoOutputItemsInner._(
      {required this.provider, required this.enabled})
      : super._();
  @override
  PaymentProviderListDtoOutputItemsInner rebuild(
          void Function(PaymentProviderListDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentProviderListDtoOutputItemsInnerBuilder toBuilder() =>
      PaymentProviderListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentProviderListDtoOutputItemsInner &&
        provider == other.provider &&
        enabled == other.enabled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PaymentProviderListDtoOutputItemsInner')
          ..add('provider', provider)
          ..add('enabled', enabled))
        .toString();
  }
}

class PaymentProviderListDtoOutputItemsInnerBuilder
    implements
        Builder<PaymentProviderListDtoOutputItemsInner,
            PaymentProviderListDtoOutputItemsInnerBuilder> {
  _$PaymentProviderListDtoOutputItemsInner? _$v;

  PaymentProviderListDtoOutputItemsInnerProviderEnum? _provider;
  PaymentProviderListDtoOutputItemsInnerProviderEnum? get provider =>
      _$this._provider;
  set provider(PaymentProviderListDtoOutputItemsInnerProviderEnum? provider) =>
      _$this._provider = provider;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  PaymentProviderListDtoOutputItemsInnerBuilder() {
    PaymentProviderListDtoOutputItemsInner._defaults(this);
  }

  PaymentProviderListDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _provider = $v.provider;
      _enabled = $v.enabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentProviderListDtoOutputItemsInner other) {
    _$v = other as _$PaymentProviderListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(PaymentProviderListDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentProviderListDtoOutputItemsInner build() => _build();

  _$PaymentProviderListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$PaymentProviderListDtoOutputItemsInner._(
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'PaymentProviderListDtoOutputItemsInner', 'provider'),
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'PaymentProviderListDtoOutputItemsInner', 'enabled'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
