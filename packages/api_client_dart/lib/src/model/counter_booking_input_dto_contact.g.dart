// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_booking_input_dto_contact.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterBookingInputDtoContact extends CounterBookingInputDtoContact {
  @override
  final String fullName;
  @override
  final String phone;
  @override
  final String? email;

  factory _$CounterBookingInputDtoContact(
          [void Function(CounterBookingInputDtoContactBuilder)? updates]) =>
      (CounterBookingInputDtoContactBuilder()..update(updates))._build();

  _$CounterBookingInputDtoContact._(
      {required this.fullName, required this.phone, this.email})
      : super._();
  @override
  CounterBookingInputDtoContact rebuild(
          void Function(CounterBookingInputDtoContactBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterBookingInputDtoContactBuilder toBuilder() =>
      CounterBookingInputDtoContactBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterBookingInputDtoContact &&
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
    return (newBuiltValueToStringHelper(r'CounterBookingInputDtoContact')
          ..add('fullName', fullName)
          ..add('phone', phone)
          ..add('email', email))
        .toString();
  }
}

class CounterBookingInputDtoContactBuilder
    implements
        Builder<CounterBookingInputDtoContact,
            CounterBookingInputDtoContactBuilder> {
  _$CounterBookingInputDtoContact? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  CounterBookingInputDtoContactBuilder() {
    CounterBookingInputDtoContact._defaults(this);
  }

  CounterBookingInputDtoContactBuilder get _$this {
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
  void replace(CounterBookingInputDtoContact other) {
    _$v = other as _$CounterBookingInputDtoContact;
  }

  @override
  void update(void Function(CounterBookingInputDtoContactBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterBookingInputDtoContact build() => _build();

  _$CounterBookingInputDtoContact _build() {
    final _$result = _$v ??
        _$CounterBookingInputDtoContact._(
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'CounterBookingInputDtoContact', 'fullName'),
          phone: BuiltValueNullFieldError.checkNotNull(
              phone, r'CounterBookingInputDtoContact', 'phone'),
          email: email,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
