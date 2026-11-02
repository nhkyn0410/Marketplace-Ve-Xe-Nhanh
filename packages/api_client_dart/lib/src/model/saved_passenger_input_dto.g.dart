// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_passenger_input_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SavedPassengerInputDto extends SavedPassengerInputDto {
  @override
  final String fullName;
  @override
  final String? phone;

  factory _$SavedPassengerInputDto(
          [void Function(SavedPassengerInputDtoBuilder)? updates]) =>
      (SavedPassengerInputDtoBuilder()..update(updates))._build();

  _$SavedPassengerInputDto._({required this.fullName, this.phone}) : super._();
  @override
  SavedPassengerInputDto rebuild(
          void Function(SavedPassengerInputDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SavedPassengerInputDtoBuilder toBuilder() =>
      SavedPassengerInputDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SavedPassengerInputDto &&
        fullName == other.fullName &&
        phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SavedPassengerInputDto')
          ..add('fullName', fullName)
          ..add('phone', phone))
        .toString();
  }
}

class SavedPassengerInputDtoBuilder
    implements Builder<SavedPassengerInputDto, SavedPassengerInputDtoBuilder> {
  _$SavedPassengerInputDto? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  SavedPassengerInputDtoBuilder() {
    SavedPassengerInputDto._defaults(this);
  }

  SavedPassengerInputDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SavedPassengerInputDto other) {
    _$v = other as _$SavedPassengerInputDto;
  }

  @override
  void update(void Function(SavedPassengerInputDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SavedPassengerInputDto build() => _build();

  _$SavedPassengerInputDto _build() {
    final _$result = _$v ??
        _$SavedPassengerInputDto._(
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'SavedPassengerInputDto', 'fullName'),
          phone: phone,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
