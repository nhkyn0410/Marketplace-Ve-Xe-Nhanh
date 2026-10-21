// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TicketPageDtoOutput extends TicketPageDtoOutput {
  @override
  final BuiltList<CustomerTicketListDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;
  @override
  final int unclassified;

  factory _$TicketPageDtoOutput(
          [void Function(TicketPageDtoOutputBuilder)? updates]) =>
      (TicketPageDtoOutputBuilder()..update(updates))._build();

  _$TicketPageDtoOutput._(
      {required this.items,
      this.nextCursor,
      required this.total,
      required this.unclassified})
      : super._();
  @override
  TicketPageDtoOutput rebuild(
          void Function(TicketPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketPageDtoOutputBuilder toBuilder() =>
      TicketPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TicketPageDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor &&
        total == other.total &&
        unclassified == other.unclassified;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, unclassified.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TicketPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total)
          ..add('unclassified', unclassified))
        .toString();
  }
}

class TicketPageDtoOutputBuilder
    implements Builder<TicketPageDtoOutput, TicketPageDtoOutputBuilder> {
  _$TicketPageDtoOutput? _$v;

  ListBuilder<CustomerTicketListDtoOutputItemsInner>? _items;
  ListBuilder<CustomerTicketListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<CustomerTicketListDtoOutputItemsInner>();
  set items(ListBuilder<CustomerTicketListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _unclassified;
  int? get unclassified => _$this._unclassified;
  set unclassified(int? unclassified) => _$this._unclassified = unclassified;

  TicketPageDtoOutputBuilder() {
    TicketPageDtoOutput._defaults(this);
  }

  TicketPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _total = $v.total;
      _unclassified = $v.unclassified;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TicketPageDtoOutput other) {
    _$v = other as _$TicketPageDtoOutput;
  }

  @override
  void update(void Function(TicketPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TicketPageDtoOutput build() => _build();

  _$TicketPageDtoOutput _build() {
    _$TicketPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$TicketPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'TicketPageDtoOutput', 'total'),
            unclassified: BuiltValueNullFieldError.checkNotNull(
                unclassified, r'TicketPageDtoOutput', 'unclassified'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TicketPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
