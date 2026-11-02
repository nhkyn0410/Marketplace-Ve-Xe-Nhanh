// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PromotionPageDtoOutput extends PromotionPageDtoOutput {
  @override
  final BuiltList<PromotionPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;
  @override
  final PromotionPageDtoOutputStats stats;

  factory _$PromotionPageDtoOutput(
          [void Function(PromotionPageDtoOutputBuilder)? updates]) =>
      (PromotionPageDtoOutputBuilder()..update(updates))._build();

  _$PromotionPageDtoOutput._(
      {required this.items,
      this.nextCursor,
      required this.total,
      required this.stats})
      : super._();
  @override
  PromotionPageDtoOutput rebuild(
          void Function(PromotionPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PromotionPageDtoOutputBuilder toBuilder() =>
      PromotionPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PromotionPageDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor &&
        total == other.total &&
        stats == other.stats;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, stats.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PromotionPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total)
          ..add('stats', stats))
        .toString();
  }
}

class PromotionPageDtoOutputBuilder
    implements Builder<PromotionPageDtoOutput, PromotionPageDtoOutputBuilder> {
  _$PromotionPageDtoOutput? _$v;

  ListBuilder<PromotionPageDtoOutputItemsInner>? _items;
  ListBuilder<PromotionPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<PromotionPageDtoOutputItemsInner>();
  set items(ListBuilder<PromotionPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  PromotionPageDtoOutputStatsBuilder? _stats;
  PromotionPageDtoOutputStatsBuilder get stats =>
      _$this._stats ??= PromotionPageDtoOutputStatsBuilder();
  set stats(PromotionPageDtoOutputStatsBuilder? stats) => _$this._stats = stats;

  PromotionPageDtoOutputBuilder() {
    PromotionPageDtoOutput._defaults(this);
  }

  PromotionPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _total = $v.total;
      _stats = $v.stats.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PromotionPageDtoOutput other) {
    _$v = other as _$PromotionPageDtoOutput;
  }

  @override
  void update(void Function(PromotionPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PromotionPageDtoOutput build() => _build();

  _$PromotionPageDtoOutput _build() {
    _$PromotionPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PromotionPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'PromotionPageDtoOutput', 'total'),
            stats: stats.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();

        _$failedField = 'stats';
        stats.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PromotionPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
