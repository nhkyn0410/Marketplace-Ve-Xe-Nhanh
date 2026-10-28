// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_booking_dto_output_passengers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterBookingDtoOutputPassengersInner
    extends CounterBookingDtoOutputPassengersInner {
  @override
  final String seatCode;
  @override
  final String fullName;
  @override
  final String price;

  factory _$CounterBookingDtoOutputPassengersInner(
          [void Function(CounterBookingDtoOutputPassengersInnerBuilder)?
              updates]) =>
      (CounterBookingDtoOutputPassengersInnerBuilder()..update(updates))
          ._build();

  _$CounterBookingDtoOutputPassengersInner._(
      {required this.seatCode, required this.fullName, required this.price})
      : super._();
  @override
  CounterBookingDtoOutputPassengersInner rebuild(
          void Function(CounterBookingDtoOutputPassengersInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterBookingDtoOutputPassengersInnerBuilder toBuilder() =>
      CounterBookingDtoOutputPassengersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterBookingDtoOutputPassengersInner &&
        seatCode == other.seatCode &&
        fullName == other.fullName &&
        price == other.price;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, seatCode.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CounterBookingDtoOutputPassengersInner')
          ..add('seatCode', seatCode)
          ..add('fullName', fullName)
          ..add('price', price))
        .toString();
  }
}

class CounterBookingDtoOutputPassengersInnerBuilder
    implements
        Builder<CounterBookingDtoOutputPassengersInner,
            CounterBookingDtoOutputPassengersInnerBuilder> {
  _$CounterBookingDtoOutputPassengersInner? _$v;

  String? _seatCode;
  String? get seatCode => _$this._seatCode;
  set seatCode(String? seatCode) => _$this._seatCode = seatCode;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _price;
  String? get price => _$this._price;
  set price(String? price) => _$this._price = price;

  CounterBookingDtoOutputPassengersInnerBuilder() {
    CounterBookingDtoOutputPassengersInner._defaults(this);
  }

  CounterBookingDtoOutputPassengersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _seatCode = $v.seatCode;
      _fullName = $v.fullName;
      _price = $v.price;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterBookingDtoOutputPassengersInner other) {
    _$v = other as _$CounterBookingDtoOutputPassengersInner;
  }

  @override
  void update(
      void Function(CounterBookingDtoOutputPassengersInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterBookingDtoOutputPassengersInner build() => _build();

  _$CounterBookingDtoOutputPassengersInner _build() {
    final _$result = _$v ??
        _$CounterBookingDtoOutputPassengersInner._(
          seatCode: BuiltValueNullFieldError.checkNotNull(
              seatCode, r'CounterBookingDtoOutputPassengersInner', 'seatCode'),
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'CounterBookingDtoOutputPassengersInner', 'fullName'),
          price: BuiltValueNullFieldError.checkNotNull(
              price, r'CounterBookingDtoOutputPassengersInner', 'price'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
