// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_trip_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterTripListDtoOutput extends CounterTripListDtoOutput {
  @override
  final BuiltList<CounterTripListDtoOutputItemsInner> items;

  factory _$CounterTripListDtoOutput(
          [void Function(CounterTripListDtoOutputBuilder)? updates]) =>
      (CounterTripListDtoOutputBuilder()..update(updates))._build();

  _$CounterTripListDtoOutput._({required this.items}) : super._();
  @override
  CounterTripListDtoOutput rebuild(
          void Function(CounterTripListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterTripListDtoOutputBuilder toBuilder() =>
      CounterTripListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterTripListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'CounterTripListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class CounterTripListDtoOutputBuilder
    implements
        Builder<CounterTripListDtoOutput, CounterTripListDtoOutputBuilder> {
  _$CounterTripListDtoOutput? _$v;

  ListBuilder<CounterTripListDtoOutputItemsInner>? _items;
  ListBuilder<CounterTripListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<CounterTripListDtoOutputItemsInner>();
  set items(ListBuilder<CounterTripListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  CounterTripListDtoOutputBuilder() {
    CounterTripListDtoOutput._defaults(this);
  }

  CounterTripListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterTripListDtoOutput other) {
    _$v = other as _$CounterTripListDtoOutput;
  }

  @override
  void update(void Function(CounterTripListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterTripListDtoOutput build() => _build();

  _$CounterTripListDtoOutput _build() {
    _$CounterTripListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$CounterTripListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CounterTripListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
