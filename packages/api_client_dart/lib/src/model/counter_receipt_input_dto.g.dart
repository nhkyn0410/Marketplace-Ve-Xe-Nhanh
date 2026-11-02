// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_receipt_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CounterReceiptInputDtoMethodEnum _$counterReceiptInputDtoMethodEnum_CASH =
    const CounterReceiptInputDtoMethodEnum._('CASH');
const CounterReceiptInputDtoMethodEnum
    _$counterReceiptInputDtoMethodEnum_BANK_TRANSFER =
    const CounterReceiptInputDtoMethodEnum._('BANK_TRANSFER');

CounterReceiptInputDtoMethodEnum _$counterReceiptInputDtoMethodEnumValueOf(
    String name) {
  switch (name) {
    case 'CASH':
      return _$counterReceiptInputDtoMethodEnum_CASH;
    case 'BANK_TRANSFER':
      return _$counterReceiptInputDtoMethodEnum_BANK_TRANSFER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CounterReceiptInputDtoMethodEnum>
    _$counterReceiptInputDtoMethodEnumValues = BuiltSet<
        CounterReceiptInputDtoMethodEnum>(const <CounterReceiptInputDtoMethodEnum>[
  _$counterReceiptInputDtoMethodEnum_CASH,
  _$counterReceiptInputDtoMethodEnum_BANK_TRANSFER,
]);

Serializer<CounterReceiptInputDtoMethodEnum>
    _$counterReceiptInputDtoMethodEnumSerializer =
    _$CounterReceiptInputDtoMethodEnumSerializer();

class _$CounterReceiptInputDtoMethodEnumSerializer
    implements PrimitiveSerializer<CounterReceiptInputDtoMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CASH': 'CASH',
    'BANK_TRANSFER': 'BANK_TRANSFER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CASH': 'CASH',
    'BANK_TRANSFER': 'BANK_TRANSFER',
  };

  @override
  final Iterable<Type> types = const <Type>[CounterReceiptInputDtoMethodEnum];
  @override
  final String wireName = 'CounterReceiptInputDtoMethodEnum';

  @override
  Object serialize(
          Serializers serializers, CounterReceiptInputDtoMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CounterReceiptInputDtoMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CounterReceiptInputDtoMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CounterReceiptInputDto extends CounterReceiptInputDto {
  @override
  final String idempotencyKey;
  @override
  final CounterReceiptInputDtoMethodEnum method;
  @override
  final String amount;
  @override
  final String? reference;

  factory _$CounterReceiptInputDto(
          [void Function(CounterReceiptInputDtoBuilder)? updates]) =>
      (CounterReceiptInputDtoBuilder()..update(updates))._build();

  _$CounterReceiptInputDto._(
      {required this.idempotencyKey,
      required this.method,
      required this.amount,
      this.reference})
      : super._();
  @override
  CounterReceiptInputDto rebuild(
          void Function(CounterReceiptInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterReceiptInputDtoBuilder toBuilder() =>
      CounterReceiptInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterReceiptInputDto &&
        idempotencyKey == other.idempotencyKey &&
        method == other.method &&
        amount == other.amount &&
        reference == other.reference;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idempotencyKey.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CounterReceiptInputDto')
          ..add('idempotencyKey', idempotencyKey)
          ..add('method', method)
          ..add('amount', amount)
          ..add('reference', reference))
        .toString();
  }
}

class CounterReceiptInputDtoBuilder
    implements Builder<CounterReceiptInputDto, CounterReceiptInputDtoBuilder> {
  _$CounterReceiptInputDto? _$v;

  String? _idempotencyKey;
  String? get idempotencyKey => _$this._idempotencyKey;
  set idempotencyKey(String? idempotencyKey) =>
      _$this._idempotencyKey = idempotencyKey;

  CounterReceiptInputDtoMethodEnum? _method;
  CounterReceiptInputDtoMethodEnum? get method => _$this._method;
  set method(CounterReceiptInputDtoMethodEnum? method) =>
      _$this._method = method;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  CounterReceiptInputDtoBuilder() {
    CounterReceiptInputDto._defaults(this);
  }

  CounterReceiptInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idempotencyKey = $v.idempotencyKey;
      _method = $v.method;
      _amount = $v.amount;
      _reference = $v.reference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterReceiptInputDto other) {
    _$v = other as _$CounterReceiptInputDto;
  }

  @override
  void update(void Function(CounterReceiptInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterReceiptInputDto build() => _build();

  _$CounterReceiptInputDto _build() {
    final _$result = _$v ??
        _$CounterReceiptInputDto._(
          idempotencyKey: BuiltValueNullFieldError.checkNotNull(
              idempotencyKey, r'CounterReceiptInputDto', 'idempotencyKey'),
          method: BuiltValueNullFieldError.checkNotNull(
              method, r'CounterReceiptInputDto', 'method'),
          amount: BuiltValueNullFieldError.checkNotNull(
              amount, r'CounterReceiptInputDto', 'amount'),
          reference: reference,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
