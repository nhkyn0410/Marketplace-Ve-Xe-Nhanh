// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_article_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminArticlePageDtoOutput extends AdminArticlePageDtoOutput {
  @override
  final BuiltList<AdminArticlePageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;

  factory _$AdminArticlePageDtoOutput(
          [void Function(AdminArticlePageDtoOutputBuilder)? updates]) =>
      (AdminArticlePageDtoOutputBuilder()..update(updates))._build();

  _$AdminArticlePageDtoOutput._(
      {required this.items, this.nextCursor, required this.total})
      : super._();
  @override
  AdminArticlePageDtoOutput rebuild(
          void Function(AdminArticlePageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminArticlePageDtoOutputBuilder toBuilder() =>
      AdminArticlePageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminArticlePageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminArticlePageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total))
        .toString();
  }
}

class AdminArticlePageDtoOutputBuilder
    implements
        Builder<AdminArticlePageDtoOutput, AdminArticlePageDtoOutputBuilder> {
  _$AdminArticlePageDtoOutput? _$v;

  ListBuilder<AdminArticlePageDtoOutputItemsInner>? _items;
  ListBuilder<AdminArticlePageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminArticlePageDtoOutputItemsInner>();
  set items(ListBuilder<AdminArticlePageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  AdminArticlePageDtoOutputBuilder() {
    AdminArticlePageDtoOutput._defaults(this);
  }

  AdminArticlePageDtoOutputBuilder get _$this {
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
  void replace(AdminArticlePageDtoOutput other) {
    _$v = other as _$AdminArticlePageDtoOutput;
  }

  @override
  void update(void Function(AdminArticlePageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminArticlePageDtoOutput build() => _build();

  _$AdminArticlePageDtoOutput _build() {
    _$AdminArticlePageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminArticlePageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminArticlePageDtoOutput', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminArticlePageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
