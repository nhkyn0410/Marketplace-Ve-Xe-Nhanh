// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_booking_dto_output_contact.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterBookingDtoOutputContact extends CounterBookingDtoOutputContact {
  @override
  final String fullName;
  @override
  final String phone;
  @override
  final String? email;

  factory _$CounterBookingDtoOutputContact(
          [void Function(CounterBookingDtoOutputContactBuilder)? updates]) =>
      (CounterBookingDtoOutputContactBuilder()..update(updates))._build();

  _$CounterBookingDtoOutputContact._(
      {required this.fullName, required this.phone, this.email})
      : super._();
  @override
  CounterBookingDtoOutputContact rebuild(
          void Function(CounterBookingDtoOutputContactBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterBookingDtoOutputContactBuilder toBuilder() =>
      CounterBookingDtoOutputContactBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterBookingDtoOutputContact &&
        fullName == other.fullName &&
        phone == other.phone &&
        email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CounterBookingDtoOutputContact')
          ..add('fullName', fullName)
          ..add('phone', phone)
          ..add('email', email))
        .toString();
  }
}

class CounterBookingDtoOutputContactBuilder
    implements
        Builder<CounterBookingDtoOutputContact,
            CounterBookingDtoOutputContactBuilder> {
  _$CounterBookingDtoOutputContact? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  CounterBookingDtoOutputContactBuilder() {
    CounterBookingDtoOutputContact._defaults(this);
  }

  CounterBookingDtoOutputContactBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _phone = $v.phone;
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterBookingDtoOutputContact other) {
    _$v = other as _$CounterBookingDtoOutputContact;
  }

  @override
  void update(void Function(CounterBookingDtoOutputContactBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterBookingDtoOutputContact build() => _build();

  _$CounterBookingDtoOutputContact _build() {
    final _$result = _$v ??
        _$CounterBookingDtoOutputContact._(
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'CounterBookingDtoOutputContact', 'fullName'),
          phone: BuiltValueNullFieldError.checkNotNull(
              phone, r'CounterBookingDtoOutputContact', 'phone'),
          email: email,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
