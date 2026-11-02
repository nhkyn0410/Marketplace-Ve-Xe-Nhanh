// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_support_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerSupportPageDtoOutput extends PassengerSupportPageDtoOutput {
  @override
  final BuiltList<PassengerSupportPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;

  factory _$PassengerSupportPageDtoOutput(
          [void Function(PassengerSupportPageDtoOutputBuilder)? updates]) =>
      (PassengerSupportPageDtoOutputBuilder()..update(updates))._build();

  _$PassengerSupportPageDtoOutput._({required this.items, this.nextCursor})
      : super._();
  @override
  PassengerSupportPageDtoOutput rebuild(
          void Function(PassengerSupportPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerSupportPageDtoOutputBuilder toBuilder() =>
      PassengerSupportPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerSupportPageDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PassengerSupportPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class PassengerSupportPageDtoOutputBuilder
    implements
        Builder<PassengerSupportPageDtoOutput,
            PassengerSupportPageDtoOutputBuilder> {
  _$PassengerSupportPageDtoOutput? _$v;

  ListBuilder<PassengerSupportPageDtoOutputItemsInner>? _items;
  ListBuilder<PassengerSupportPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<PassengerSupportPageDtoOutputItemsInner>();
  set items(ListBuilder<PassengerSupportPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  PassengerSupportPageDtoOutputBuilder() {
    PassengerSupportPageDtoOutput._defaults(this);
  }

  PassengerSupportPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PassengerSupportPageDtoOutput other) {
    _$v = other as _$PassengerSupportPageDtoOutput;
  }

  @override
  void update(void Function(PassengerSupportPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerSupportPageDtoOutput build() => _build();

  _$PassengerSupportPageDtoOutput _build() {
    _$PassengerSupportPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PassengerSupportPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PassengerSupportPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
