// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_booking_dto_output_contact.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreatedBookingDtoOutputContact extends CreatedBookingDtoOutputContact {
  @override
  final String fullName;
  @override
  final String phone;
  @override
  final String email;

  factory _$CreatedBookingDtoOutputContact(
          [void Function(CreatedBookingDtoOutputContactBuilder)? updates]) =>
      (CreatedBookingDtoOutputContactBuilder()..update(updates))._build();

  _$CreatedBookingDtoOutputContact._(
      {required this.fullName, required this.phone, required this.email})
      : super._();
  @override
  CreatedBookingDtoOutputContact rebuild(
          void Function(CreatedBookingDtoOutputContactBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreatedBookingDtoOutputContactBuilder toBuilder() =>
      CreatedBookingDtoOutputContactBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreatedBookingDtoOutputContact &&
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
    return (newBuiltValueToStringHelper(r'CreatedBookingDtoOutputContact')
          ..add('fullName', fullName)
          ..add('phone', phone)
          ..add('email', email))
        .toString();
  }
}

class CreatedBookingDtoOutputContactBuilder
    implements
        Builder<CreatedBookingDtoOutputContact,
            CreatedBookingDtoOutputContactBuilder> {
  _$CreatedBookingDtoOutputContact? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  CreatedBookingDtoOutputContactBuilder() {
    CreatedBookingDtoOutputContact._defaults(this);
  }

  CreatedBookingDtoOutputContactBuilder get _$this {
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
  void replace(CreatedBookingDtoOutputContact other) {
    _$v = other as _$CreatedBookingDtoOutputContact;
  }

  @override
  void update(void Function(CreatedBookingDtoOutputContactBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreatedBookingDtoOutputContact build() => _build();

  _$CreatedBookingDtoOutputContact _build() {
    final _$result = _$v ??
        _$CreatedBookingDtoOutputContact._(
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'CreatedBookingDtoOutputContact', 'fullName'),
          phone: BuiltValueNullFieldError.checkNotNull(
              phone, r'CreatedBookingDtoOutputContact', 'phone'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'CreatedBookingDtoOutputContact', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
