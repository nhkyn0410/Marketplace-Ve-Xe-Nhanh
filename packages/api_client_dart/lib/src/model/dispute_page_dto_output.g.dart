// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputePageDtoOutput extends DisputePageDtoOutput {
  @override
  final BuiltList<DisputePageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;
  @override
  final int open;

  factory _$DisputePageDtoOutput(
          [void Function(DisputePageDtoOutputBuilder)? updates]) =>
      (DisputePageDtoOutputBuilder()..update(updates))._build();

  _$DisputePageDtoOutput._(
      {required this.items,
      this.nextCursor,
      required this.total,
      required this.open})
      : super._();
  @override
  DisputePageDtoOutput rebuild(
          void Function(DisputePageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputePageDtoOutputBuilder toBuilder() =>
      DisputePageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputePageDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor &&
        total == other.total &&
        open == other.open;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, open.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputePageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total)
          ..add('open', open))
        .toString();
  }
}

class DisputePageDtoOutputBuilder
    implements Builder<DisputePageDtoOutput, DisputePageDtoOutputBuilder> {
  _$DisputePageDtoOutput? _$v;

  ListBuilder<DisputePageDtoOutputItemsInner>? _items;
  ListBuilder<DisputePageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<DisputePageDtoOutputItemsInner>();
  set items(ListBuilder<DisputePageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _open;
  int? get open => _$this._open;
  set open(int? open) => _$this._open = open;

  DisputePageDtoOutputBuilder() {
    DisputePageDtoOutput._defaults(this);
  }

  DisputePageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _total = $v.total;
      _open = $v.open;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputePageDtoOutput other) {
    _$v = other as _$DisputePageDtoOutput;
  }

  @override
  void update(void Function(DisputePageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputePageDtoOutput build() => _build();

  _$DisputePageDtoOutput _build() {
    _$DisputePageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$DisputePageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'DisputePageDtoOutput', 'total'),
            open: BuiltValueNullFieldError.checkNotNull(
                open, r'DisputePageDtoOutput', 'open'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DisputePageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
