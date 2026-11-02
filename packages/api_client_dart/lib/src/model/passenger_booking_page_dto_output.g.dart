// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_booking_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerBookingPageDtoOutput extends PassengerBookingPageDtoOutput {
  @override
  final BuiltList<PassengerBookingPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;

  factory _$PassengerBookingPageDtoOutput(
          [void Function(PassengerBookingPageDtoOutputBuilder)? updates]) =>
      (PassengerBookingPageDtoOutputBuilder()..update(updates))._build();

  _$PassengerBookingPageDtoOutput._({required this.items, this.nextCursor})
      : super._();
  @override
  PassengerBookingPageDtoOutput rebuild(
          void Function(PassengerBookingPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerBookingPageDtoOutputBuilder toBuilder() =>
      PassengerBookingPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerBookingPageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'PassengerBookingPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class PassengerBookingPageDtoOutputBuilder
    implements
        Builder<PassengerBookingPageDtoOutput,
            PassengerBookingPageDtoOutputBuilder> {
  _$PassengerBookingPageDtoOutput? _$v;

  ListBuilder<PassengerBookingPageDtoOutputItemsInner>? _items;
  ListBuilder<PassengerBookingPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<PassengerBookingPageDtoOutputItemsInner>();
  set items(ListBuilder<PassengerBookingPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  PassengerBookingPageDtoOutputBuilder() {
    PassengerBookingPageDtoOutput._defaults(this);
  }

  PassengerBookingPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PassengerBookingPageDtoOutput other) {
    _$v = other as _$PassengerBookingPageDtoOutput;
  }

  @override
  void update(void Function(PassengerBookingPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerBookingPageDtoOutput build() => _build();

  _$PassengerBookingPageDtoOutput _build() {
    _$PassengerBookingPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PassengerBookingPageDtoOutput._(
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
            r'PassengerBookingPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
