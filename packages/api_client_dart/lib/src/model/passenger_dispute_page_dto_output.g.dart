// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_dispute_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerDisputePageDtoOutput extends PassengerDisputePageDtoOutput {
  @override
  final BuiltList<PassengerDisputePageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;

  factory _$PassengerDisputePageDtoOutput(
          [void Function(PassengerDisputePageDtoOutputBuilder)? updates]) =>
      (PassengerDisputePageDtoOutputBuilder()..update(updates))._build();

  _$PassengerDisputePageDtoOutput._({required this.items, this.nextCursor})
      : super._();
  @override
  PassengerDisputePageDtoOutput rebuild(
          void Function(PassengerDisputePageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerDisputePageDtoOutputBuilder toBuilder() =>
      PassengerDisputePageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerDisputePageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'PassengerDisputePageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class PassengerDisputePageDtoOutputBuilder
    implements
        Builder<PassengerDisputePageDtoOutput,
            PassengerDisputePageDtoOutputBuilder> {
  _$PassengerDisputePageDtoOutput? _$v;

  ListBuilder<PassengerDisputePageDtoOutputItemsInner>? _items;
  ListBuilder<PassengerDisputePageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<PassengerDisputePageDtoOutputItemsInner>();
  set items(ListBuilder<PassengerDisputePageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  PassengerDisputePageDtoOutputBuilder() {
    PassengerDisputePageDtoOutput._defaults(this);
  }

  PassengerDisputePageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PassengerDisputePageDtoOutput other) {
    _$v = other as _$PassengerDisputePageDtoOutput;
  }

  @override
  void update(void Function(PassengerDisputePageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerDisputePageDtoOutput build() => _build();

  _$PassengerDisputePageDtoOutput _build() {
    _$PassengerDisputePageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PassengerDisputePageDtoOutput._(
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
            r'PassengerDisputePageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
