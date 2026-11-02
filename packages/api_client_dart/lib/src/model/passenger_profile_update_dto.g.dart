// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_profile_update_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerProfileUpdateDto extends PassengerProfileUpdateDto {
  @override
  final String? name;
  @override
  final String? phone;
  @override
  final Date? dateOfBirth;

  factory _$PassengerProfileUpdateDto(
          [void Function(PassengerProfileUpdateDtoBuilder)? updates]) =>
      (PassengerProfileUpdateDtoBuilder()..update(updates))._build();

  _$PassengerProfileUpdateDto._({this.name, this.phone, this.dateOfBirth})
      : super._();
  @override
  PassengerProfileUpdateDto rebuild(
          void Function(PassengerProfileUpdateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerProfileUpdateDtoBuilder toBuilder() =>
      PassengerProfileUpdateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerProfileUpdateDto &&
        name == other.name &&
        phone == other.phone &&
        dateOfBirth == other.dateOfBirth;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, dateOfBirth.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PassengerProfileUpdateDto')
          ..add('name', name)
          ..add('phone', phone)
          ..add('dateOfBirth', dateOfBirth))
        .toString();
  }
}

class PassengerProfileUpdateDtoBuilder
    implements
        Builder<PassengerProfileUpdateDto, PassengerProfileUpdateDtoBuilder> {
  _$PassengerProfileUpdateDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  Date? _dateOfBirth;
  Date? get dateOfBirth => _$this._dateOfBirth;
  set dateOfBirth(Date? dateOfBirth) => _$this._dateOfBirth = dateOfBirth;

  PassengerProfileUpdateDtoBuilder() {
    PassengerProfileUpdateDto._defaults(this);
  }

  PassengerProfileUpdateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _phone = $v.phone;
      _dateOfBirth = $v.dateOfBirth;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PassengerProfileUpdateDto other) {
    _$v = other as _$PassengerProfileUpdateDto;
  }

  @override
  void update(void Function(PassengerProfileUpdateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerProfileUpdateDto build() => _build();

  _$PassengerProfileUpdateDto _build() {
    final _$result = _$v ??
        _$PassengerProfileUpdateDto._(
          name: name,
          phone: phone,
          dateOfBirth: dateOfBirth,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
