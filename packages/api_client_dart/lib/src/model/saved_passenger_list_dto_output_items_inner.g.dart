// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_passenger_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SavedPassengerListDtoOutputItemsInner
    extends SavedPassengerListDtoOutputItemsInner {
  @override
  final String passengerId;
  @override
  final String fullName;
  @override
  final String? phone;

  factory _$SavedPassengerListDtoOutputItemsInner(
          [void Function(SavedPassengerListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (SavedPassengerListDtoOutputItemsInnerBuilder()..update(updates))
          ._build();

  _$SavedPassengerListDtoOutputItemsInner._(
      {required this.passengerId, required this.fullName, this.phone})
      : super._();
  @override
  SavedPassengerListDtoOutputItemsInner rebuild(
          void Function(SavedPassengerListDtoOutputItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SavedPassengerListDtoOutputItemsInnerBuilder toBuilder() =>
      SavedPassengerListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SavedPassengerListDtoOutputItemsInner &&
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
    return (newBuiltValueToStringHelper(
            r'SavedPassengerListDtoOutputItemsInner')
          ..add('passengerId', passengerId)
          ..add('fullName', fullName)
          ..add('phone', phone))
        .toString();
  }
}

class SavedPassengerListDtoOutputItemsInnerBuilder
    implements
        Builder<SavedPassengerListDtoOutputItemsInner,
            SavedPassengerListDtoOutputItemsInnerBuilder> {
  _$SavedPassengerListDtoOutputItemsInner? _$v;

  String? _passengerId;
  String? get passengerId => _$this._passengerId;
  set passengerId(String? passengerId) => _$this._passengerId = passengerId;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  SavedPassengerListDtoOutputItemsInnerBuilder() {
    SavedPassengerListDtoOutputItemsInner._defaults(this);
  }

  SavedPassengerListDtoOutputItemsInnerBuilder get _$this {
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
  void replace(SavedPassengerListDtoOutputItemsInner other) {
    _$v = other as _$SavedPassengerListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(SavedPassengerListDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SavedPassengerListDtoOutputItemsInner build() => _build();

  _$SavedPassengerListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$SavedPassengerListDtoOutputItemsInner._(
          passengerId: BuiltValueNullFieldError.checkNotNull(passengerId,
              r'SavedPassengerListDtoOutputItemsInner', 'passengerId'),
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'SavedPassengerListDtoOutputItemsInner', 'fullName'),
          phone: phone,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
