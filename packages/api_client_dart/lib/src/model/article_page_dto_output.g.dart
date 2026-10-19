// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ArticlePageDtoOutput extends ArticlePageDtoOutput {
  @override
  final BuiltList<ArticlePageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;

  factory _$ArticlePageDtoOutput(
          [void Function(ArticlePageDtoOutputBuilder)? updates]) =>
      (ArticlePageDtoOutputBuilder()..update(updates))._build();

  _$ArticlePageDtoOutput._({required this.items, this.nextCursor}) : super._();
  @override
  ArticlePageDtoOutput rebuild(
          void Function(ArticlePageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ArticlePageDtoOutputBuilder toBuilder() =>
      ArticlePageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArticlePageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'ArticlePageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class ArticlePageDtoOutputBuilder
    implements Builder<ArticlePageDtoOutput, ArticlePageDtoOutputBuilder> {
  _$ArticlePageDtoOutput? _$v;

  ListBuilder<ArticlePageDtoOutputItemsInner>? _items;
  ListBuilder<ArticlePageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<ArticlePageDtoOutputItemsInner>();
  set items(ListBuilder<ArticlePageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  ArticlePageDtoOutputBuilder() {
    ArticlePageDtoOutput._defaults(this);
  }

  ArticlePageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArticlePageDtoOutput other) {
    _$v = other as _$ArticlePageDtoOutput;
  }

  @override
  void update(void Function(ArticlePageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ArticlePageDtoOutput build() => _build();

  _$ArticlePageDtoOutput _build() {
    _$ArticlePageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$ArticlePageDtoOutput._(
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
            r'ArticlePageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
