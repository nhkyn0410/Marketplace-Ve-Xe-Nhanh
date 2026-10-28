// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_hold_dto_output_seats_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CounterHoldDtoOutputSeatsInnerTypeEnum
    _$counterHoldDtoOutputSeatsInnerTypeEnum_SEAT =
    const CounterHoldDtoOutputSeatsInnerTypeEnum._('SEAT');
const CounterHoldDtoOutputSeatsInnerTypeEnum
    _$counterHoldDtoOutputSeatsInnerTypeEnum_BED =
    const CounterHoldDtoOutputSeatsInnerTypeEnum._('BED');
const CounterHoldDtoOutputSeatsInnerTypeEnum
    _$counterHoldDtoOutputSeatsInnerTypeEnum_BED_DOUBLE =
    const CounterHoldDtoOutputSeatsInnerTypeEnum._('BED_DOUBLE');
const CounterHoldDtoOutputSeatsInnerTypeEnum
    _$counterHoldDtoOutputSeatsInnerTypeEnum_CABIN =
    const CounterHoldDtoOutputSeatsInnerTypeEnum._('CABIN');
const CounterHoldDtoOutputSeatsInnerTypeEnum
    _$counterHoldDtoOutputSeatsInnerTypeEnum_CABIN_DOUBLE =
    const CounterHoldDtoOutputSeatsInnerTypeEnum._('CABIN_DOUBLE');

CounterHoldDtoOutputSeatsInnerTypeEnum
    _$counterHoldDtoOutputSeatsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'SEAT':
      return _$counterHoldDtoOutputSeatsInnerTypeEnum_SEAT;
    case 'BED':
      return _$counterHoldDtoOutputSeatsInnerTypeEnum_BED;
    case 'BED_DOUBLE':
      return _$counterHoldDtoOutputSeatsInnerTypeEnum_BED_DOUBLE;
    case 'CABIN':
      return _$counterHoldDtoOutputSeatsInnerTypeEnum_CABIN;
    case 'CABIN_DOUBLE':
      return _$counterHoldDtoOutputSeatsInnerTypeEnum_CABIN_DOUBLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CounterHoldDtoOutputSeatsInnerTypeEnum>
    _$counterHoldDtoOutputSeatsInnerTypeEnumValues = BuiltSet<
        CounterHoldDtoOutputSeatsInnerTypeEnum>(const <CounterHoldDtoOutputSeatsInnerTypeEnum>[
  _$counterHoldDtoOutputSeatsInnerTypeEnum_SEAT,
  _$counterHoldDtoOutputSeatsInnerTypeEnum_BED,
  _$counterHoldDtoOutputSeatsInnerTypeEnum_BED_DOUBLE,
  _$counterHoldDtoOutputSeatsInnerTypeEnum_CABIN,
  _$counterHoldDtoOutputSeatsInnerTypeEnum_CABIN_DOUBLE,
]);

Serializer<CounterHoldDtoOutputSeatsInnerTypeEnum>
    _$counterHoldDtoOutputSeatsInnerTypeEnumSerializer =
    _$CounterHoldDtoOutputSeatsInnerTypeEnumSerializer();

class _$CounterHoldDtoOutputSeatsInnerTypeEnumSerializer
    implements PrimitiveSerializer<CounterHoldDtoOutputSeatsInnerTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SEAT': 'SEAT',
    'BED': 'BED',
    'BED_DOUBLE': 'BED_DOUBLE',
    'CABIN': 'CABIN',
    'CABIN_DOUBLE': 'CABIN_DOUBLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SEAT': 'SEAT',
    'BED': 'BED',
    'BED_DOUBLE': 'BED_DOUBLE',
    'CABIN': 'CABIN',
    'CABIN_DOUBLE': 'CABIN_DOUBLE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CounterHoldDtoOutputSeatsInnerTypeEnum
  ];
  @override
  final String wireName = 'CounterHoldDtoOutputSeatsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          CounterHoldDtoOutputSeatsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CounterHoldDtoOutputSeatsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CounterHoldDtoOutputSeatsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CounterHoldDtoOutputSeatsInner extends CounterHoldDtoOutputSeatsInner {
  @override
  final String code;
  @override
  final CounterHoldDtoOutputSeatsInnerTypeEnum type;
  @override
  final String price;

  factory _$CounterHoldDtoOutputSeatsInner(
          [void Function(CounterHoldDtoOutputSeatsInnerBuilder)? updates]) =>
      (CounterHoldDtoOutputSeatsInnerBuilder()..update(updates))._build();

  _$CounterHoldDtoOutputSeatsInner._(
      {required this.code, required this.type, required this.price})
      : super._();
  @override
  CounterHoldDtoOutputSeatsInner rebuild(
          void Function(CounterHoldDtoOutputSeatsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterHoldDtoOutputSeatsInnerBuilder toBuilder() =>
      CounterHoldDtoOutputSeatsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterHoldDtoOutputSeatsInner &&
        code == other.code &&
        type == other.type &&
        price == other.price;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CounterHoldDtoOutputSeatsInner')
          ..add('code', code)
          ..add('type', type)
          ..add('price', price))
        .toString();
  }
}

class CounterHoldDtoOutputSeatsInnerBuilder
    implements
        Builder<CounterHoldDtoOutputSeatsInner,
            CounterHoldDtoOutputSeatsInnerBuilder> {
  _$CounterHoldDtoOutputSeatsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  CounterHoldDtoOutputSeatsInnerTypeEnum? _type;
  CounterHoldDtoOutputSeatsInnerTypeEnum? get type => _$this._type;
  set type(CounterHoldDtoOutputSeatsInnerTypeEnum? type) => _$this._type = type;

  String? _price;
  String? get price => _$this._price;
  set price(String? price) => _$this._price = price;

  CounterHoldDtoOutputSeatsInnerBuilder() {
    CounterHoldDtoOutputSeatsInner._defaults(this);
  }

  CounterHoldDtoOutputSeatsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _type = $v.type;
      _price = $v.price;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterHoldDtoOutputSeatsInner other) {
    _$v = other as _$CounterHoldDtoOutputSeatsInner;
  }

  @override
  void update(void Function(CounterHoldDtoOutputSeatsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterHoldDtoOutputSeatsInner build() => _build();

  _$CounterHoldDtoOutputSeatsInner _build() {
    final _$result = _$v ??
        _$CounterHoldDtoOutputSeatsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'CounterHoldDtoOutputSeatsInner', 'code'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CounterHoldDtoOutputSeatsInner', 'type'),
          price: BuiltValueNullFieldError.checkNotNull(
              price, r'CounterHoldDtoOutputSeatsInner', 'price'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
