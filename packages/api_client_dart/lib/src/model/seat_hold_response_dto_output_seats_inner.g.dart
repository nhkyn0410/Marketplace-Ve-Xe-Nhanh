// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_hold_response_dto_output_seats_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SeatHoldResponseDtoOutputSeatsInnerTypeEnum
    _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_SEAT =
    const SeatHoldResponseDtoOutputSeatsInnerTypeEnum._('SEAT');
const SeatHoldResponseDtoOutputSeatsInnerTypeEnum
    _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_BED =
    const SeatHoldResponseDtoOutputSeatsInnerTypeEnum._('BED');
const SeatHoldResponseDtoOutputSeatsInnerTypeEnum
    _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_BED_DOUBLE =
    const SeatHoldResponseDtoOutputSeatsInnerTypeEnum._('BED_DOUBLE');
const SeatHoldResponseDtoOutputSeatsInnerTypeEnum
    _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_CABIN =
    const SeatHoldResponseDtoOutputSeatsInnerTypeEnum._('CABIN');
const SeatHoldResponseDtoOutputSeatsInnerTypeEnum
    _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_CABIN_DOUBLE =
    const SeatHoldResponseDtoOutputSeatsInnerTypeEnum._('CABIN_DOUBLE');

SeatHoldResponseDtoOutputSeatsInnerTypeEnum
    _$seatHoldResponseDtoOutputSeatsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'SEAT':
      return _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_SEAT;
    case 'BED':
      return _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_BED;
    case 'BED_DOUBLE':
      return _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_BED_DOUBLE;
    case 'CABIN':
      return _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_CABIN;
    case 'CABIN_DOUBLE':
      return _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_CABIN_DOUBLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SeatHoldResponseDtoOutputSeatsInnerTypeEnum>
    _$seatHoldResponseDtoOutputSeatsInnerTypeEnumValues = BuiltSet<
        SeatHoldResponseDtoOutputSeatsInnerTypeEnum>(const <SeatHoldResponseDtoOutputSeatsInnerTypeEnum>[
  _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_SEAT,
  _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_BED,
  _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_BED_DOUBLE,
  _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_CABIN,
  _$seatHoldResponseDtoOutputSeatsInnerTypeEnum_CABIN_DOUBLE,
]);

Serializer<SeatHoldResponseDtoOutputSeatsInnerTypeEnum>
    _$seatHoldResponseDtoOutputSeatsInnerTypeEnumSerializer =
    _$SeatHoldResponseDtoOutputSeatsInnerTypeEnumSerializer();

class _$SeatHoldResponseDtoOutputSeatsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<SeatHoldResponseDtoOutputSeatsInnerTypeEnum> {
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
    SeatHoldResponseDtoOutputSeatsInnerTypeEnum
  ];
  @override
  final String wireName = 'SeatHoldResponseDtoOutputSeatsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          SeatHoldResponseDtoOutputSeatsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SeatHoldResponseDtoOutputSeatsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SeatHoldResponseDtoOutputSeatsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SeatHoldResponseDtoOutputSeatsInner
    extends SeatHoldResponseDtoOutputSeatsInner {
  @override
  final String code;
  @override
  final SeatHoldResponseDtoOutputSeatsInnerTypeEnum type;
  @override
  final int price;

  factory _$SeatHoldResponseDtoOutputSeatsInner(
          [void Function(SeatHoldResponseDtoOutputSeatsInnerBuilder)?
              updates]) =>
      (SeatHoldResponseDtoOutputSeatsInnerBuilder()..update(updates))._build();

  _$SeatHoldResponseDtoOutputSeatsInner._(
      {required this.code, required this.type, required this.price})
      : super._();
  @override
  SeatHoldResponseDtoOutputSeatsInner rebuild(
          void Function(SeatHoldResponseDtoOutputSeatsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SeatHoldResponseDtoOutputSeatsInnerBuilder toBuilder() =>
      SeatHoldResponseDtoOutputSeatsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SeatHoldResponseDtoOutputSeatsInner &&
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
    return (newBuiltValueToStringHelper(r'SeatHoldResponseDtoOutputSeatsInner')
          ..add('code', code)
          ..add('type', type)
          ..add('price', price))
        .toString();
  }
}

class SeatHoldResponseDtoOutputSeatsInnerBuilder
    implements
        Builder<SeatHoldResponseDtoOutputSeatsInner,
            SeatHoldResponseDtoOutputSeatsInnerBuilder> {
  _$SeatHoldResponseDtoOutputSeatsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  SeatHoldResponseDtoOutputSeatsInnerTypeEnum? _type;
  SeatHoldResponseDtoOutputSeatsInnerTypeEnum? get type => _$this._type;
  set type(SeatHoldResponseDtoOutputSeatsInnerTypeEnum? type) =>
      _$this._type = type;

  int? _price;
  int? get price => _$this._price;
  set price(int? price) => _$this._price = price;

  SeatHoldResponseDtoOutputSeatsInnerBuilder() {
    SeatHoldResponseDtoOutputSeatsInner._defaults(this);
  }

  SeatHoldResponseDtoOutputSeatsInnerBuilder get _$this {
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
  void replace(SeatHoldResponseDtoOutputSeatsInner other) {
    _$v = other as _$SeatHoldResponseDtoOutputSeatsInner;
  }

  @override
  void update(
      void Function(SeatHoldResponseDtoOutputSeatsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SeatHoldResponseDtoOutputSeatsInner build() => _build();

  _$SeatHoldResponseDtoOutputSeatsInner _build() {
    final _$result = _$v ??
        _$SeatHoldResponseDtoOutputSeatsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'SeatHoldResponseDtoOutputSeatsInner', 'code'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'SeatHoldResponseDtoOutputSeatsInner', 'type'),
          price: BuiltValueNullFieldError.checkNotNull(
              price, r'SeatHoldResponseDtoOutputSeatsInner', 'price'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
