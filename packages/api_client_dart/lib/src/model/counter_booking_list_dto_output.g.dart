// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_booking_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterBookingListDtoOutput extends CounterBookingListDtoOutput {
  @override
  final BuiltList<CounterBookingListDtoOutputItemsInner> items;
  @override
  final String? nextCursor;

  factory _$CounterBookingListDtoOutput(
          [void Function(CounterBookingListDtoOutputBuilder)? updates]) =>
      (CounterBookingListDtoOutputBuilder()..update(updates))._build();

  _$CounterBookingListDtoOutput._({required this.items, this.nextCursor})
      : super._();
  @override
  CounterBookingListDtoOutput rebuild(
          void Function(CounterBookingListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterBookingListDtoOutputBuilder toBuilder() =>
      CounterBookingListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterBookingListDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'CounterBookingListDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class CounterBookingListDtoOutputBuilder
    implements
        Builder<CounterBookingListDtoOutput,
            CounterBookingListDtoOutputBuilder> {
  _$CounterBookingListDtoOutput? _$v;

  ListBuilder<CounterBookingListDtoOutputItemsInner>? _items;
  ListBuilder<CounterBookingListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<CounterBookingListDtoOutputItemsInner>();
  set items(ListBuilder<CounterBookingListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  CounterBookingListDtoOutputBuilder() {
    CounterBookingListDtoOutput._defaults(this);
  }

  CounterBookingListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterBookingListDtoOutput other) {
    _$v = other as _$CounterBookingListDtoOutput;
  }

  @override
  void update(void Function(CounterBookingListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterBookingListDtoOutput build() => _build();

  _$CounterBookingListDtoOutput _build() {
    _$CounterBookingListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CounterBookingListDtoOutput._(
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
            r'CounterBookingListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
