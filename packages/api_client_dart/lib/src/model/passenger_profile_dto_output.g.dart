// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_profile_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerProfileDtoOutput extends PassengerProfileDtoOutput {
  @override
  final String userId;
  @override
  final String? name;
  @override
  final String email;
  @override
  final bool emailVerified;
  @override
  final String? phone;
  @override
  final Date? dateOfBirth;
  @override
  final String? image;

  factory _$PassengerProfileDtoOutput(
          [void Function(PassengerProfileDtoOutputBuilder)? updates]) =>
      (PassengerProfileDtoOutputBuilder()..update(updates))._build();

  _$PassengerProfileDtoOutput._(
      {required this.userId,
      this.name,
      required this.email,
      required this.emailVerified,
      this.phone,
      this.dateOfBirth,
      this.image})
      : super._();
  @override
  PassengerProfileDtoOutput rebuild(
          void Function(PassengerProfileDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerProfileDtoOutputBuilder toBuilder() =>
      PassengerProfileDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerProfileDtoOutput &&
        userId == other.userId &&
        name == other.name &&
        email == other.email &&
        emailVerified == other.emailVerified &&
        phone == other.phone &&
        dateOfBirth == other.dateOfBirth &&
        image == other.image;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, emailVerified.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, dateOfBirth.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PassengerProfileDtoOutput')
          ..add('userId', userId)
          ..add('name', name)
          ..add('email', email)
          ..add('emailVerified', emailVerified)
          ..add('phone', phone)
          ..add('dateOfBirth', dateOfBirth)
          ..add('image', image))
        .toString();
  }
}

class PassengerProfileDtoOutputBuilder
    implements
        Builder<PassengerProfileDtoOutput, PassengerProfileDtoOutputBuilder> {
  _$PassengerProfileDtoOutput? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  bool? _emailVerified;
  bool? get emailVerified => _$this._emailVerified;
  set emailVerified(bool? emailVerified) =>
      _$this._emailVerified = emailVerified;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  Date? _dateOfBirth;
  Date? get dateOfBirth => _$this._dateOfBirth;
  set dateOfBirth(Date? dateOfBirth) => _$this._dateOfBirth = dateOfBirth;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  PassengerProfileDtoOutputBuilder() {
    PassengerProfileDtoOutput._defaults(this);
  }

  PassengerProfileDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _name = $v.name;
      _email = $v.email;
      _emailVerified = $v.emailVerified;
      _phone = $v.phone;
      _dateOfBirth = $v.dateOfBirth;
      _image = $v.image;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PassengerProfileDtoOutput other) {
    _$v = other as _$PassengerProfileDtoOutput;
  }

  @override
  void update(void Function(PassengerProfileDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerProfileDtoOutput build() => _build();

  _$PassengerProfileDtoOutput _build() {
    final _$result = _$v ??
        _$PassengerProfileDtoOutput._(
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'PassengerProfileDtoOutput', 'userId'),
          name: name,
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'PassengerProfileDtoOutput', 'email'),
          emailVerified: BuiltValueNullFieldError.checkNotNull(
              emailVerified, r'PassengerProfileDtoOutput', 'emailVerified'),
          phone: phone,
          dateOfBirth: dateOfBirth,
          image: image,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
