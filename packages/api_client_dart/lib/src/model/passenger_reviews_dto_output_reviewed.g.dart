// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_reviews_dto_output_reviewed.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerReviewsDtoOutputReviewed
    extends PassengerReviewsDtoOutputReviewed {
  @override
  final BuiltList<PassengerReviewsDtoOutputReviewedItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;

  factory _$PassengerReviewsDtoOutputReviewed(
          [void Function(PassengerReviewsDtoOutputReviewedBuilder)? updates]) =>
      (PassengerReviewsDtoOutputReviewedBuilder()..update(updates))._build();

  _$PassengerReviewsDtoOutputReviewed._(
      {required this.items, this.nextCursor, required this.total})
      : super._();
  @override
  PassengerReviewsDtoOutputReviewed rebuild(
          void Function(PassengerReviewsDtoOutputReviewedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerReviewsDtoOutputReviewedBuilder toBuilder() =>
      PassengerReviewsDtoOutputReviewedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerReviewsDtoOutputReviewed &&
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
    return (newBuiltValueToStringHelper(r'PassengerReviewsDtoOutputReviewed')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total))
        .toString();
  }
}

class PassengerReviewsDtoOutputReviewedBuilder
    implements
        Builder<PassengerReviewsDtoOutputReviewed,
            PassengerReviewsDtoOutputReviewedBuilder> {
  _$PassengerReviewsDtoOutputReviewed? _$v;

  ListBuilder<PassengerReviewsDtoOutputReviewedItemsInner>? _items;
  ListBuilder<PassengerReviewsDtoOutputReviewedItemsInner> get items =>
      _$this._items ??=
          ListBuilder<PassengerReviewsDtoOutputReviewedItemsInner>();
  set items(ListBuilder<PassengerReviewsDtoOutputReviewedItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  PassengerReviewsDtoOutputReviewedBuilder() {
    PassengerReviewsDtoOutputReviewed._defaults(this);
  }

  PassengerReviewsDtoOutputReviewedBuilder get _$this {
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
  void replace(PassengerReviewsDtoOutputReviewed other) {
    _$v = other as _$PassengerReviewsDtoOutputReviewed;
  }

  @override
  void update(
      void Function(PassengerReviewsDtoOutputReviewedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerReviewsDtoOutputReviewed build() => _build();

  _$PassengerReviewsDtoOutputReviewed _build() {
    _$PassengerReviewsDtoOutputReviewed _$result;
    try {
      _$result = _$v ??
          _$PassengerReviewsDtoOutputReviewed._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'PassengerReviewsDtoOutputReviewed', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PassengerReviewsDtoOutputReviewed', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
