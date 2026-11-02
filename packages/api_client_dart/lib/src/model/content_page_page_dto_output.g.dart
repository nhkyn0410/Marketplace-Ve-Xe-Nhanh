// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_page_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContentPagePageDtoOutput extends ContentPagePageDtoOutput {
  @override
  final BuiltList<ContentPagePageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;

  factory _$ContentPagePageDtoOutput(
          [void Function(ContentPagePageDtoOutputBuilder)? updates]) =>
      (ContentPagePageDtoOutputBuilder()..update(updates))._build();

  _$ContentPagePageDtoOutput._(
      {required this.items, this.nextCursor, required this.total})
      : super._();
  @override
  ContentPagePageDtoOutput rebuild(
          void Function(ContentPagePageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContentPagePageDtoOutputBuilder toBuilder() =>
      ContentPagePageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContentPagePageDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContentPagePageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total))
        .toString();
  }
}

class ContentPagePageDtoOutputBuilder
    implements
        Builder<ContentPagePageDtoOutput, ContentPagePageDtoOutputBuilder> {
  _$ContentPagePageDtoOutput? _$v;

  ListBuilder<ContentPagePageDtoOutputItemsInner>? _items;
  ListBuilder<ContentPagePageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<ContentPagePageDtoOutputItemsInner>();
  set items(ListBuilder<ContentPagePageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  ContentPagePageDtoOutputBuilder() {
    ContentPagePageDtoOutput._defaults(this);
  }

  ContentPagePageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContentPagePageDtoOutput other) {
    _$v = other as _$ContentPagePageDtoOutput;
  }

  @override
  void update(void Function(ContentPagePageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContentPagePageDtoOutput build() => _build();

  _$ContentPagePageDtoOutput _build() {
    _$ContentPagePageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$ContentPagePageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'ContentPagePageDtoOutput', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ContentPagePageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
