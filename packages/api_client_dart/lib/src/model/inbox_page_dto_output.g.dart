// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InboxPageDtoOutput extends InboxPageDtoOutput {
  @override
  final BuiltList<InboxPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int unreadCount;

  factory _$InboxPageDtoOutput(
          [void Function(InboxPageDtoOutputBuilder)? updates]) =>
      (InboxPageDtoOutputBuilder()..update(updates))._build();

  _$InboxPageDtoOutput._(
      {required this.items, this.nextCursor, required this.unreadCount})
      : super._();
  @override
  InboxPageDtoOutput rebuild(
          void Function(InboxPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InboxPageDtoOutputBuilder toBuilder() =>
      InboxPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InboxPageDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor &&
        unreadCount == other.unreadCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, unreadCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InboxPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('unreadCount', unreadCount))
        .toString();
  }
}

class InboxPageDtoOutputBuilder
    implements Builder<InboxPageDtoOutput, InboxPageDtoOutputBuilder> {
  _$InboxPageDtoOutput? _$v;

  ListBuilder<InboxPageDtoOutputItemsInner>? _items;
  ListBuilder<InboxPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<InboxPageDtoOutputItemsInner>();
  set items(ListBuilder<InboxPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _unreadCount;
  int? get unreadCount => _$this._unreadCount;
  set unreadCount(int? unreadCount) => _$this._unreadCount = unreadCount;

  InboxPageDtoOutputBuilder() {
    InboxPageDtoOutput._defaults(this);
  }

  InboxPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _unreadCount = $v.unreadCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InboxPageDtoOutput other) {
    _$v = other as _$InboxPageDtoOutput;
  }

  @override
  void update(void Function(InboxPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InboxPageDtoOutput build() => _build();

  _$InboxPageDtoOutput _build() {
    _$InboxPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$InboxPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            unreadCount: BuiltValueNullFieldError.checkNotNull(
                unreadCount, r'InboxPageDtoOutput', 'unreadCount'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InboxPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
