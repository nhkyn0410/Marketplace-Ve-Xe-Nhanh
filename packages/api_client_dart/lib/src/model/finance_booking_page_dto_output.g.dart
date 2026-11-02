// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_booking_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FinanceBookingPageDtoOutput extends FinanceBookingPageDtoOutput {
  @override
  final BuiltList<FinanceBookingPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;

  factory _$FinanceBookingPageDtoOutput(
          [void Function(FinanceBookingPageDtoOutputBuilder)? updates]) =>
      (FinanceBookingPageDtoOutputBuilder()..update(updates))._build();

  _$FinanceBookingPageDtoOutput._({required this.items, this.nextCursor})
      : super._();
  @override
  FinanceBookingPageDtoOutput rebuild(
          void Function(FinanceBookingPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinanceBookingPageDtoOutputBuilder toBuilder() =>
      FinanceBookingPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinanceBookingPageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'FinanceBookingPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class FinanceBookingPageDtoOutputBuilder
    implements
        Builder<FinanceBookingPageDtoOutput,
            FinanceBookingPageDtoOutputBuilder> {
  _$FinanceBookingPageDtoOutput? _$v;

  ListBuilder<FinanceBookingPageDtoOutputItemsInner>? _items;
  ListBuilder<FinanceBookingPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<FinanceBookingPageDtoOutputItemsInner>();
  set items(ListBuilder<FinanceBookingPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  FinanceBookingPageDtoOutputBuilder() {
    FinanceBookingPageDtoOutput._defaults(this);
  }

  FinanceBookingPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FinanceBookingPageDtoOutput other) {
    _$v = other as _$FinanceBookingPageDtoOutput;
  }

  @override
  void update(void Function(FinanceBookingPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FinanceBookingPageDtoOutput build() => _build();

  _$FinanceBookingPageDtoOutput _build() {
    _$FinanceBookingPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$FinanceBookingPageDtoOutput._(
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
            r'FinanceBookingPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
