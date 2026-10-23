// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_contact_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BookingContactDtoOutput extends BookingContactDtoOutput {
  @override
  final String fullName;
  @override
  final String phone;
  @override
  final String email;
  @override
  final BuiltList<BookingContactDtoOutputPassengersInner> passengers;

  factory _$BookingContactDtoOutput(
          [void Function(BookingContactDtoOutputBuilder)? updates]) =>
      (BookingContactDtoOutputBuilder()..update(updates))._build();

  _$BookingContactDtoOutput._(
      {required this.fullName,
      required this.phone,
      required this.email,
      required this.passengers})
      : super._();
  @override
  BookingContactDtoOutput rebuild(
          void Function(BookingContactDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BookingContactDtoOutputBuilder toBuilder() =>
      BookingContactDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookingContactDtoOutput &&
        fullName == other.fullName &&
        phone == other.phone &&
        email == other.email &&
        passengers == other.passengers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, passengers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BookingContactDtoOutput')
          ..add('fullName', fullName)
          ..add('phone', phone)
          ..add('email', email)
          ..add('passengers', passengers))
        .toString();
  }
}

class BookingContactDtoOutputBuilder
    implements
        Builder<BookingContactDtoOutput, BookingContactDtoOutputBuilder> {
  _$BookingContactDtoOutput? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  ListBuilder<BookingContactDtoOutputPassengersInner>? _passengers;
  ListBuilder<BookingContactDtoOutputPassengersInner> get passengers =>
      _$this._passengers ??=
          ListBuilder<BookingContactDtoOutputPassengersInner>();
  set passengers(
          ListBuilder<BookingContactDtoOutputPassengersInner>? passengers) =>
      _$this._passengers = passengers;

  BookingContactDtoOutputBuilder() {
    BookingContactDtoOutput._defaults(this);
  }

  BookingContactDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _phone = $v.phone;
      _email = $v.email;
      _passengers = $v.passengers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BookingContactDtoOutput other) {
    _$v = other as _$BookingContactDtoOutput;
  }

  @override
  void update(void Function(BookingContactDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BookingContactDtoOutput build() => _build();

  _$BookingContactDtoOutput _build() {
    _$BookingContactDtoOutput _$result;
    try {
      _$result = _$v ??
          _$BookingContactDtoOutput._(
            fullName: BuiltValueNullFieldError.checkNotNull(
                fullName, r'BookingContactDtoOutput', 'fullName'),
            phone: BuiltValueNullFieldError.checkNotNull(
                phone, r'BookingContactDtoOutput', 'phone'),
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'BookingContactDtoOutput', 'email'),
            passengers: passengers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'passengers';
        passengers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BookingContactDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
