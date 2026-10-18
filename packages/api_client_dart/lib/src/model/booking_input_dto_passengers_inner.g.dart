// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_input_dto_passengers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BookingInputDtoPassengersInner extends BookingInputDtoPassengersInner {
  @override
  final String seatCode;
  @override
  final String fullName;
  @override
  final String? phone;

  factory _$BookingInputDtoPassengersInner(
          [void Function(BookingInputDtoPassengersInnerBuilder)? updates]) =>
      (BookingInputDtoPassengersInnerBuilder()..update(updates))._build();

  _$BookingInputDtoPassengersInner._(
      {required this.seatCode, required this.fullName, this.phone})
      : super._();
  @override
  BookingInputDtoPassengersInner rebuild(
          void Function(BookingInputDtoPassengersInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BookingInputDtoPassengersInnerBuilder toBuilder() =>
      BookingInputDtoPassengersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookingInputDtoPassengersInner &&
        seatCode == other.seatCode &&
        fullName == other.fullName &&
        phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, seatCode.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BookingInputDtoPassengersInner')
          ..add('seatCode', seatCode)
          ..add('fullName', fullName)
          ..add('phone', phone))
        .toString();
  }
}

class BookingInputDtoPassengersInnerBuilder
    implements
        Builder<BookingInputDtoPassengersInner,
            BookingInputDtoPassengersInnerBuilder> {
  _$BookingInputDtoPassengersInner? _$v;

  String? _seatCode;
  String? get seatCode => _$this._seatCode;
  set seatCode(String? seatCode) => _$this._seatCode = seatCode;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  BookingInputDtoPassengersInnerBuilder() {
    BookingInputDtoPassengersInner._defaults(this);
  }

  BookingInputDtoPassengersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _seatCode = $v.seatCode;
      _fullName = $v.fullName;
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BookingInputDtoPassengersInner other) {
    _$v = other as _$BookingInputDtoPassengersInner;
  }

  @override
  void update(void Function(BookingInputDtoPassengersInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BookingInputDtoPassengersInner build() => _build();

  _$BookingInputDtoPassengersInner _build() {
    final _$result = _$v ??
        _$BookingInputDtoPassengersInner._(
          seatCode: BuiltValueNullFieldError.checkNotNull(
              seatCode, r'BookingInputDtoPassengersInner', 'seatCode'),
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'BookingInputDtoPassengersInner', 'fullName'),
          phone: phone,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
