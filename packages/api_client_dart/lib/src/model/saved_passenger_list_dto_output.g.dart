// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_passenger_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SavedPassengerListDtoOutput extends SavedPassengerListDtoOutput {
  @override
  final BuiltList<SavedPassengerListDtoOutputItemsInner> items;

  factory _$SavedPassengerListDtoOutput(
          [void Function(SavedPassengerListDtoOutputBuilder)? updates]) =>
      (SavedPassengerListDtoOutputBuilder()..update(updates))._build();

  _$SavedPassengerListDtoOutput._({required this.items}) : super._();
  @override
  SavedPassengerListDtoOutput rebuild(
          void Function(SavedPassengerListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SavedPassengerListDtoOutputBuilder toBuilder() =>
      SavedPassengerListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SavedPassengerListDtoOutput && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SavedPassengerListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class SavedPassengerListDtoOutputBuilder
    implements
        Builder<SavedPassengerListDtoOutput,
            SavedPassengerListDtoOutputBuilder> {
  _$SavedPassengerListDtoOutput? _$v;

  ListBuilder<SavedPassengerListDtoOutputItemsInner>? _items;
  ListBuilder<SavedPassengerListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<SavedPassengerListDtoOutputItemsInner>();
  set items(ListBuilder<SavedPassengerListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  SavedPassengerListDtoOutputBuilder() {
    SavedPassengerListDtoOutput._defaults(this);
  }

  SavedPassengerListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SavedPassengerListDtoOutput other) {
    _$v = other as _$SavedPassengerListDtoOutput;
  }

  @override
  void update(void Function(SavedPassengerListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SavedPassengerListDtoOutput build() => _build();

  _$SavedPassengerListDtoOutput _build() {
    _$SavedPassengerListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$SavedPassengerListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SavedPassengerListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
