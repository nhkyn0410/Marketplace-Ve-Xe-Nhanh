// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_booking_input_dto_passengers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterBookingInputDtoPassengersInner
    extends CounterBookingInputDtoPassengersInner {
  @override
  final String seatCode;
  @override
  final String fullName;
  @override
  final String? phone;
  @override
  final String? companionName;

  factory _$CounterBookingInputDtoPassengersInner(
          [void Function(CounterBookingInputDtoPassengersInnerBuilder)?
              updates]) =>
      (CounterBookingInputDtoPassengersInnerBuilder()..update(updates))
          ._build();

  _$CounterBookingInputDtoPassengersInner._(
      {required this.seatCode,
      required this.fullName,
      this.phone,
      this.companionName})
      : super._();
  @override
  CounterBookingInputDtoPassengersInner rebuild(
          void Function(CounterBookingInputDtoPassengersInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterBookingInputDtoPassengersInnerBuilder toBuilder() =>
      CounterBookingInputDtoPassengersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterBookingInputDtoPassengersInner &&
        seatCode == other.seatCode &&
        fullName == other.fullName &&
        phone == other.phone &&
        companionName == other.companionName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, seatCode.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, companionName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CounterBookingInputDtoPassengersInner')
          ..add('seatCode', seatCode)
          ..add('fullName', fullName)
          ..add('phone', phone)
          ..add('companionName', companionName))
        .toString();
  }
}

class CounterBookingInputDtoPassengersInnerBuilder
    implements
        Builder<CounterBookingInputDtoPassengersInner,
            CounterBookingInputDtoPassengersInnerBuilder> {
  _$CounterBookingInputDtoPassengersInner? _$v;

  String? _seatCode;
  String? get seatCode => _$this._seatCode;
  set seatCode(String? seatCode) => _$this._seatCode = seatCode;

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

  CounterBookingInputDtoPassengersInnerBuilder() {
    CounterBookingInputDtoPassengersInner._defaults(this);
  }

  CounterBookingInputDtoPassengersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _seatCode = $v.seatCode;
      _fullName = $v.fullName;
      _phone = $v.phone;
      _companionName = $v.companionName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterBookingInputDtoPassengersInner other) {
    _$v = other as _$CounterBookingInputDtoPassengersInner;
  }

  @override
  void update(
      void Function(CounterBookingInputDtoPassengersInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterBookingInputDtoPassengersInner build() => _build();

  _$CounterBookingInputDtoPassengersInner _build() {
    final _$result = _$v ??
        _$CounterBookingInputDtoPassengersInner._(
          seatCode: BuiltValueNullFieldError.checkNotNull(
              seatCode, r'CounterBookingInputDtoPassengersInner', 'seatCode'),
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'CounterBookingInputDtoPassengersInner', 'fullName'),
          phone: phone,
          companionName: companionName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
