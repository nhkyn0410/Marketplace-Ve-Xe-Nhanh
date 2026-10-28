// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_trip_list_dto_output_items_inner_seats_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum
    _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_SEAT =
    const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum._('SEAT');
const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum
    _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_BED =
    const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum._('BED');
const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum
    _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_BED_DOUBLE =
    const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum._('BED_DOUBLE');
const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum
    _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_CABIN =
    const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum._('CABIN');
const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum
    _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_CABIN_DOUBLE =
    const CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum._(
        'CABIN_DOUBLE');

CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum
    _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'SEAT':
      return _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_SEAT;
    case 'BED':
      return _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_BED;
    case 'BED_DOUBLE':
      return _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_BED_DOUBLE;
    case 'CABIN':
      return _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_CABIN;
    case 'CABIN_DOUBLE':
      return _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_CABIN_DOUBLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum>
    _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnumValues = BuiltSet<
        CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum>(const <CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum>[
  _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_SEAT,
  _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_BED,
  _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_BED_DOUBLE,
  _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_CABIN,
  _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnum_CABIN_DOUBLE,
]);

Serializer<CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum>
    _$counterTripListDtoOutputItemsInnerSeatsInnerTypeEnumSerializer =
    _$CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnumSerializer();

class _$CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<
            CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum> {
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
    CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum
  ];
  @override
  final String wireName =
      'CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CounterTripListDtoOutputItemsInnerSeatsInner
    extends CounterTripListDtoOutputItemsInnerSeatsInner {
  @override
  final String code;
  @override
  final CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum type;
  @override
  final String status;
  @override
  final String? price;

  factory _$CounterTripListDtoOutputItemsInnerSeatsInner(
          [void Function(CounterTripListDtoOutputItemsInnerSeatsInnerBuilder)?
              updates]) =>
      (CounterTripListDtoOutputItemsInnerSeatsInnerBuilder()..update(updates))
          ._build();

  _$CounterTripListDtoOutputItemsInnerSeatsInner._(
      {required this.code,
      required this.type,
      required this.status,
      this.price})
      : super._();
  @override
  CounterTripListDtoOutputItemsInnerSeatsInner rebuild(
          void Function(CounterTripListDtoOutputItemsInnerSeatsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterTripListDtoOutputItemsInnerSeatsInnerBuilder toBuilder() =>
      CounterTripListDtoOutputItemsInnerSeatsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterTripListDtoOutputItemsInnerSeatsInner &&
        code == other.code &&
        type == other.type &&
        status == other.status &&
        price == other.price;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CounterTripListDtoOutputItemsInnerSeatsInner')
          ..add('code', code)
          ..add('type', type)
          ..add('status', status)
          ..add('price', price))
        .toString();
  }
}

class CounterTripListDtoOutputItemsInnerSeatsInnerBuilder
    implements
        Builder<CounterTripListDtoOutputItemsInnerSeatsInner,
            CounterTripListDtoOutputItemsInnerSeatsInnerBuilder> {
  _$CounterTripListDtoOutputItemsInnerSeatsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum? _type;
  CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum? get type =>
      _$this._type;
  set type(CounterTripListDtoOutputItemsInnerSeatsInnerTypeEnum? type) =>
      _$this._type = type;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _price;
  String? get price => _$this._price;
  set price(String? price) => _$this._price = price;

  CounterTripListDtoOutputItemsInnerSeatsInnerBuilder() {
    CounterTripListDtoOutputItemsInnerSeatsInner._defaults(this);
  }

  CounterTripListDtoOutputItemsInnerSeatsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _type = $v.type;
      _status = $v.status;
      _price = $v.price;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterTripListDtoOutputItemsInnerSeatsInner other) {
    _$v = other as _$CounterTripListDtoOutputItemsInnerSeatsInner;
  }

  @override
  void update(
      void Function(CounterTripListDtoOutputItemsInnerSeatsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterTripListDtoOutputItemsInnerSeatsInner build() => _build();

  _$CounterTripListDtoOutputItemsInnerSeatsInner _build() {
    final _$result = _$v ??
        _$CounterTripListDtoOutputItemsInnerSeatsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'CounterTripListDtoOutputItemsInnerSeatsInner', 'code'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CounterTripListDtoOutputItemsInnerSeatsInner', 'type'),
          status: BuiltValueNullFieldError.checkNotNull(status,
              r'CounterTripListDtoOutputItemsInnerSeatsInner', 'status'),
          price: price,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
