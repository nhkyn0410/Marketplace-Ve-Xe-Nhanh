// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_assignment_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TripAssignmentPageDtoOutput extends TripAssignmentPageDtoOutput {
  @override
  final BuiltList<TripAssignmentPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;

  factory _$TripAssignmentPageDtoOutput(
          [void Function(TripAssignmentPageDtoOutputBuilder)? updates]) =>
      (TripAssignmentPageDtoOutputBuilder()..update(updates))._build();

  _$TripAssignmentPageDtoOutput._({required this.items, this.nextCursor})
      : super._();
  @override
  TripAssignmentPageDtoOutput rebuild(
          void Function(TripAssignmentPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TripAssignmentPageDtoOutputBuilder toBuilder() =>
      TripAssignmentPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TripAssignmentPageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'TripAssignmentPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class TripAssignmentPageDtoOutputBuilder
    implements
        Builder<TripAssignmentPageDtoOutput,
            TripAssignmentPageDtoOutputBuilder> {
  _$TripAssignmentPageDtoOutput? _$v;

  ListBuilder<TripAssignmentPageDtoOutputItemsInner>? _items;
  ListBuilder<TripAssignmentPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<TripAssignmentPageDtoOutputItemsInner>();
  set items(ListBuilder<TripAssignmentPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  TripAssignmentPageDtoOutputBuilder() {
    TripAssignmentPageDtoOutput._defaults(this);
  }

  TripAssignmentPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TripAssignmentPageDtoOutput other) {
    _$v = other as _$TripAssignmentPageDtoOutput;
  }

  @override
  void update(void Function(TripAssignmentPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TripAssignmentPageDtoOutput build() => _build();

  _$TripAssignmentPageDtoOutput _build() {
    _$TripAssignmentPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$TripAssignmentPageDtoOutput._(
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
            r'TripAssignmentPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
