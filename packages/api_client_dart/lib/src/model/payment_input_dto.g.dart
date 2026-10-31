// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PaymentInputDtoProviderEnum _$paymentInputDtoProviderEnum_VNPAY =
    const PaymentInputDtoProviderEnum._('VNPAY');
const PaymentInputDtoProviderEnum _$paymentInputDtoProviderEnum_MOMO =
    const PaymentInputDtoProviderEnum._('MOMO');
const PaymentInputDtoProviderEnum _$paymentInputDtoProviderEnum_PAYOS =
    const PaymentInputDtoProviderEnum._('PAYOS');
const PaymentInputDtoProviderEnum _$paymentInputDtoProviderEnum_DEMO =
    const PaymentInputDtoProviderEnum._('DEMO');

PaymentInputDtoProviderEnum _$paymentInputDtoProviderEnumValueOf(String name) {
  switch (name) {
    case 'VNPAY':
      return _$paymentInputDtoProviderEnum_VNPAY;
    case 'MOMO':
      return _$paymentInputDtoProviderEnum_MOMO;
    case 'PAYOS':
      return _$paymentInputDtoProviderEnum_PAYOS;
    case 'DEMO':
      return _$paymentInputDtoProviderEnum_DEMO;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentInputDtoProviderEnum>
    _$paymentInputDtoProviderEnumValues =
    BuiltSet<PaymentInputDtoProviderEnum>(const <PaymentInputDtoProviderEnum>[
  _$paymentInputDtoProviderEnum_VNPAY,
  _$paymentInputDtoProviderEnum_MOMO,
  _$paymentInputDtoProviderEnum_PAYOS,
  _$paymentInputDtoProviderEnum_DEMO,
]);

Serializer<PaymentInputDtoProviderEnum>
    _$paymentInputDtoProviderEnumSerializer =
    _$PaymentInputDtoProviderEnumSerializer();

class _$PaymentInputDtoProviderEnumSerializer
    implements PrimitiveSerializer<PaymentInputDtoProviderEnum> {
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
  final Iterable<Type> types = const <Type>[PaymentInputDtoProviderEnum];
  @override
  final String wireName = 'PaymentInputDtoProviderEnum';

  @override
  Object serialize(Serializers serializers, PaymentInputDtoProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentInputDtoProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentInputDtoProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentInputDto extends PaymentInputDto {
  @override
  final PaymentInputDtoProviderEnum provider;

  factory _$PaymentInputDto([void Function(PaymentInputDtoBuilder)? updates]) =>
      (PaymentInputDtoBuilder()..update(updates))._build();

  _$PaymentInputDto._({required this.provider}) : super._();
  @override
  PaymentInputDto rebuild(void Function(PaymentInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentInputDtoBuilder toBuilder() => PaymentInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentInputDto && provider == other.provider;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentInputDto')
          ..add('provider', provider))
        .toString();
  }
}

class PaymentInputDtoBuilder
    implements Builder<PaymentInputDto, PaymentInputDtoBuilder> {
  _$PaymentInputDto? _$v;

  PaymentInputDtoProviderEnum? _provider;
  PaymentInputDtoProviderEnum? get provider => _$this._provider;
  set provider(PaymentInputDtoProviderEnum? provider) =>
      _$this._provider = provider;

  PaymentInputDtoBuilder() {
    PaymentInputDto._defaults(this);
  }

  PaymentInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _provider = $v.provider;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentInputDto other) {
    _$v = other as _$PaymentInputDto;
  }

  @override
  void update(void Function(PaymentInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentInputDto build() => _build();

  _$PaymentInputDto _build() {
    final _$result = _$v ??
        _$PaymentInputDto._(
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'PaymentInputDto', 'provider'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
