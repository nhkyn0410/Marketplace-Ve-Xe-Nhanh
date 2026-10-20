// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_passenger_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SavedPassengerDtoOutput extends SavedPassengerDtoOutput {
  @override
  final String passengerId;
  @override
  final String fullName;
  @override
  final String? phone;

  factory _$SavedPassengerDtoOutput(
          [void Function(SavedPassengerDtoOutputBuilder)? updates]) =>
      (SavedPassengerDtoOutputBuilder()..update(updates))._build();

  _$SavedPassengerDtoOutput._(
      {required this.passengerId, required this.fullName, this.phone})
      : super._();
  @override
  SavedPassengerDtoOutput rebuild(
          void Function(SavedPassengerDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SavedPassengerDtoOutputBuilder toBuilder() =>
      SavedPassengerDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SavedPassengerDtoOutput &&
        passengerId == other.passengerId &&
        fullName == other.fullName &&
        phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, passengerId.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SavedPassengerDtoOutput')
          ..add('passengerId', passengerId)
          ..add('fullName', fullName)
          ..add('phone', phone))
        .toString();
  }
}

class SavedPassengerDtoOutputBuilder
    implements
        Builder<SavedPassengerDtoOutput, SavedPassengerDtoOutputBuilder> {
  _$SavedPassengerDtoOutput? _$v;

  String? _passengerId;
  String? get passengerId => _$this._passengerId;
  set passengerId(String? passengerId) => _$this._passengerId = passengerId;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  SavedPassengerDtoOutputBuilder() {
    SavedPassengerDtoOutput._defaults(this);
  }

  SavedPassengerDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _passengerId = $v.passengerId;
      _fullName = $v.fullName;
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SavedPassengerDtoOutput other) {
    _$v = other as _$SavedPassengerDtoOutput;
  }

  @override
  void update(void Function(SavedPassengerDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SavedPassengerDtoOutput build() => _build();

  _$SavedPassengerDtoOutput _build() {
    final _$result = _$v ??
        _$SavedPassengerDtoOutput._(
          passengerId: BuiltValueNullFieldError.checkNotNull(
              passengerId, r'SavedPassengerDtoOutput', 'passengerId'),
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'SavedPassengerDtoOutput', 'fullName'),
          phone: phone,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
