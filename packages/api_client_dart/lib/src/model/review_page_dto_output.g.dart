// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReviewPageDtoOutput extends ReviewPageDtoOutput {
  @override
  final BuiltList<ReviewPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;
  @override
  final num? average;
  @override
  final int validCount;

  factory _$ReviewPageDtoOutput(
          [void Function(ReviewPageDtoOutputBuilder)? updates]) =>
      (ReviewPageDtoOutputBuilder()..update(updates))._build();

  _$ReviewPageDtoOutput._(
      {required this.items,
      this.nextCursor,
      required this.total,
      this.average,
      required this.validCount})
      : super._();
  @override
  ReviewPageDtoOutput rebuild(
          void Function(ReviewPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewPageDtoOutputBuilder toBuilder() =>
      ReviewPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewPageDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor &&
        total == other.total &&
        average == other.average &&
        validCount == other.validCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, average.hashCode);
    _$hash = $jc(_$hash, validCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total)
          ..add('average', average)
          ..add('validCount', validCount))
        .toString();
  }
}

class ReviewPageDtoOutputBuilder
    implements Builder<ReviewPageDtoOutput, ReviewPageDtoOutputBuilder> {
  _$ReviewPageDtoOutput? _$v;

  ListBuilder<ReviewPageDtoOutputItemsInner>? _items;
  ListBuilder<ReviewPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<ReviewPageDtoOutputItemsInner>();
  set items(ListBuilder<ReviewPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  num? _average;
  num? get average => _$this._average;
  set average(num? average) => _$this._average = average;

  int? _validCount;
  int? get validCount => _$this._validCount;
  set validCount(int? validCount) => _$this._validCount = validCount;

  ReviewPageDtoOutputBuilder() {
    ReviewPageDtoOutput._defaults(this);
  }

  ReviewPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _total = $v.total;
      _average = $v.average;
      _validCount = $v.validCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewPageDtoOutput other) {
    _$v = other as _$ReviewPageDtoOutput;
  }

  @override
  void update(void Function(ReviewPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewPageDtoOutput build() => _build();

  _$ReviewPageDtoOutput _build() {
    _$ReviewPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$ReviewPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'ReviewPageDtoOutput', 'total'),
            average: average,
            validCount: BuiltValueNullFieldError.checkNotNull(
                validCount, r'ReviewPageDtoOutput', 'validCount'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ReviewPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
