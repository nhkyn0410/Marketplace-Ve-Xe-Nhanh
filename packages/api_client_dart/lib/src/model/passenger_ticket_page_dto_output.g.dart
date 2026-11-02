// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_ticket_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerTicketPageDtoOutput extends PassengerTicketPageDtoOutput {
  @override
  final BuiltList<PassengerTicketPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;

  factory _$PassengerTicketPageDtoOutput(
          [void Function(PassengerTicketPageDtoOutputBuilder)? updates]) =>
      (PassengerTicketPageDtoOutputBuilder()..update(updates))._build();

  _$PassengerTicketPageDtoOutput._({required this.items, this.nextCursor})
      : super._();
  @override
  PassengerTicketPageDtoOutput rebuild(
          void Function(PassengerTicketPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerTicketPageDtoOutputBuilder toBuilder() =>
      PassengerTicketPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerTicketPageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'PassengerTicketPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class PassengerTicketPageDtoOutputBuilder
    implements
        Builder<PassengerTicketPageDtoOutput,
            PassengerTicketPageDtoOutputBuilder> {
  _$PassengerTicketPageDtoOutput? _$v;

  ListBuilder<PassengerTicketPageDtoOutputItemsInner>? _items;
  ListBuilder<PassengerTicketPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<PassengerTicketPageDtoOutputItemsInner>();
  set items(ListBuilder<PassengerTicketPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  PassengerTicketPageDtoOutputBuilder() {
    PassengerTicketPageDtoOutput._defaults(this);
  }

  PassengerTicketPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PassengerTicketPageDtoOutput other) {
    _$v = other as _$PassengerTicketPageDtoOutput;
  }

  @override
  void update(void Function(PassengerTicketPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerTicketPageDtoOutput build() => _build();

  _$PassengerTicketPageDtoOutput _build() {
    _$PassengerTicketPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PassengerTicketPageDtoOutput._(
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
            r'PassengerTicketPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
