// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_contact_dto_output_passengers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BookingContactDtoOutputPassengersInner
    extends BookingContactDtoOutputPassengersInner {
  @override
  final String seatCode;
  @override
  final String? phone;

  factory _$BookingContactDtoOutputPassengersInner(
          [void Function(BookingContactDtoOutputPassengersInnerBuilder)?
              updates]) =>
      (BookingContactDtoOutputPassengersInnerBuilder()..update(updates))
          ._build();

  _$BookingContactDtoOutputPassengersInner._(
      {required this.seatCode, this.phone})
      : super._();
  @override
  BookingContactDtoOutputPassengersInner rebuild(
          void Function(BookingContactDtoOutputPassengersInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BookingContactDtoOutputPassengersInnerBuilder toBuilder() =>
      BookingContactDtoOutputPassengersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookingContactDtoOutputPassengersInner &&
        seatCode == other.seatCode &&
        phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, seatCode.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'BookingContactDtoOutputPassengersInner')
          ..add('seatCode', seatCode)
          ..add('phone', phone))
        .toString();
  }
}

class BookingContactDtoOutputPassengersInnerBuilder
    implements
        Builder<BookingContactDtoOutputPassengersInner,
            BookingContactDtoOutputPassengersInnerBuilder> {
  _$BookingContactDtoOutputPassengersInner? _$v;

  String? _seatCode;
  String? get seatCode => _$this._seatCode;
  set seatCode(String? seatCode) => _$this._seatCode = seatCode;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  BookingContactDtoOutputPassengersInnerBuilder() {
    BookingContactDtoOutputPassengersInner._defaults(this);
  }

  BookingContactDtoOutputPassengersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _seatCode = $v.seatCode;
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BookingContactDtoOutputPassengersInner other) {
    _$v = other as _$BookingContactDtoOutputPassengersInner;
  }

  @override
  void update(
      void Function(BookingContactDtoOutputPassengersInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BookingContactDtoOutputPassengersInner build() => _build();

  _$BookingContactDtoOutputPassengersInner _build() {
    final _$result = _$v ??
        _$BookingContactDtoOutputPassengersInner._(
          seatCode: BuiltValueNullFieldError.checkNotNull(
              seatCode, r'BookingContactDtoOutputPassengersInner', 'seatCode'),
          phone: phone,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
