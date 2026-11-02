// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_booking_dto_output_passengers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum
    _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_SEAT =
    const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum._('SEAT');
const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum
    _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_BED =
    const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum._('BED');
const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum
    _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_BED_DOUBLE =
    const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum._('BED_DOUBLE');
const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum
    _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_CABIN =
    const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum._('CABIN');
const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum
    _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_CABIN_DOUBLE =
    const CreatedBookingDtoOutputPassengersInnerSeatTypeEnum._('CABIN_DOUBLE');

CreatedBookingDtoOutputPassengersInnerSeatTypeEnum
    _$createdBookingDtoOutputPassengersInnerSeatTypeEnumValueOf(String name) {
  switch (name) {
    case 'SEAT':
      return _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_SEAT;
    case 'BED':
      return _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_BED;
    case 'BED_DOUBLE':
      return _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_BED_DOUBLE;
    case 'CABIN':
      return _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_CABIN;
    case 'CABIN_DOUBLE':
      return _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_CABIN_DOUBLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreatedBookingDtoOutputPassengersInnerSeatTypeEnum>
    _$createdBookingDtoOutputPassengersInnerSeatTypeEnumValues = BuiltSet<
        CreatedBookingDtoOutputPassengersInnerSeatTypeEnum>(const <CreatedBookingDtoOutputPassengersInnerSeatTypeEnum>[
  _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_SEAT,
  _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_BED,
  _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_BED_DOUBLE,
  _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_CABIN,
  _$createdBookingDtoOutputPassengersInnerSeatTypeEnum_CABIN_DOUBLE,
]);

Serializer<CreatedBookingDtoOutputPassengersInnerSeatTypeEnum>
    _$createdBookingDtoOutputPassengersInnerSeatTypeEnumSerializer =
    _$CreatedBookingDtoOutputPassengersInnerSeatTypeEnumSerializer();

class _$CreatedBookingDtoOutputPassengersInnerSeatTypeEnumSerializer
    implements
        PrimitiveSerializer<
            CreatedBookingDtoOutputPassengersInnerSeatTypeEnum> {
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
    CreatedBookingDtoOutputPassengersInnerSeatTypeEnum
  ];
  @override
  final String wireName = 'CreatedBookingDtoOutputPassengersInnerSeatTypeEnum';

  @override
  Object serialize(Serializers serializers,
          CreatedBookingDtoOutputPassengersInnerSeatTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreatedBookingDtoOutputPassengersInnerSeatTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreatedBookingDtoOutputPassengersInnerSeatTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreatedBookingDtoOutputPassengersInner
    extends CreatedBookingDtoOutputPassengersInner {
  @override
  final String seatCode;
  @override
  final CreatedBookingDtoOutputPassengersInnerSeatTypeEnum seatType;
  @override
  final String fullName;
  @override
  final String? phone;
  @override
  final String? companionName;
  @override
  final int price;

  factory _$CreatedBookingDtoOutputPassengersInner(
          [void Function(CreatedBookingDtoOutputPassengersInnerBuilder)?
              updates]) =>
      (CreatedBookingDtoOutputPassengersInnerBuilder()..update(updates))
          ._build();

  _$CreatedBookingDtoOutputPassengersInner._(
      {required this.seatCode,
      required this.seatType,
      required this.fullName,
      this.phone,
      this.companionName,
      required this.price})
      : super._();
  @override
  CreatedBookingDtoOutputPassengersInner rebuild(
          void Function(CreatedBookingDtoOutputPassengersInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreatedBookingDtoOutputPassengersInnerBuilder toBuilder() =>
      CreatedBookingDtoOutputPassengersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreatedBookingDtoOutputPassengersInner &&
        seatCode == other.seatCode &&
        seatType == other.seatType &&
        fullName == other.fullName &&
        phone == other.phone &&
        companionName == other.companionName &&
        price == other.price;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, seatCode.hashCode);
    _$hash = $jc(_$hash, seatType.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, companionName.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CreatedBookingDtoOutputPassengersInner')
          ..add('seatCode', seatCode)
          ..add('seatType', seatType)
          ..add('fullName', fullName)
          ..add('phone', phone)
          ..add('companionName', companionName)
          ..add('price', price))
        .toString();
  }
}

class CreatedBookingDtoOutputPassengersInnerBuilder
    implements
        Builder<CreatedBookingDtoOutputPassengersInner,
            CreatedBookingDtoOutputPassengersInnerBuilder> {
  _$CreatedBookingDtoOutputPassengersInner? _$v;

  String? _seatCode;
  String? get seatCode => _$this._seatCode;
  set seatCode(String? seatCode) => _$this._seatCode = seatCode;

  CreatedBookingDtoOutputPassengersInnerSeatTypeEnum? _seatType;
  CreatedBookingDtoOutputPassengersInnerSeatTypeEnum? get seatType =>
      _$this._seatType;
  set seatType(CreatedBookingDtoOutputPassengersInnerSeatTypeEnum? seatType) =>
      _$this._seatType = seatType;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _companionName;
  String? get companionName => _$this._companionName;
  set companionName(String? companionName) =>
      _$this._companionName = companionName;

  int? _price;
  int? get price => _$this._price;
  set price(int? price) => _$this._price = price;

  CreatedBookingDtoOutputPassengersInnerBuilder() {
    CreatedBookingDtoOutputPassengersInner._defaults(this);
  }

  CreatedBookingDtoOutputPassengersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _seatCode = $v.seatCode;
      _seatType = $v.seatType;
      _fullName = $v.fullName;
      _phone = $v.phone;
      _companionName = $v.companionName;
      _price = $v.price;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreatedBookingDtoOutputPassengersInner other) {
    _$v = other as _$CreatedBookingDtoOutputPassengersInner;
  }

  @override
  void update(
      void Function(CreatedBookingDtoOutputPassengersInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreatedBookingDtoOutputPassengersInner build() => _build();

  _$CreatedBookingDtoOutputPassengersInner _build() {
    final _$result = _$v ??
        _$CreatedBookingDtoOutputPassengersInner._(
          seatCode: BuiltValueNullFieldError.checkNotNull(
              seatCode, r'CreatedBookingDtoOutputPassengersInner', 'seatCode'),
          seatType: BuiltValueNullFieldError.checkNotNull(
              seatType, r'CreatedBookingDtoOutputPassengersInner', 'seatType'),
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'CreatedBookingDtoOutputPassengersInner', 'fullName'),
          phone: phone,
          companionName: companionName,
          price: BuiltValueNullFieldError.checkNotNull(
              price, r'CreatedBookingDtoOutputPassengersInner', 'price'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
