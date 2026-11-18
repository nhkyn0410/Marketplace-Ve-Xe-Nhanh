// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_reviews_dto_output_pending.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PassengerReviewsDtoOutputPending
    extends PassengerReviewsDtoOutputPending {
  @override
  final BuiltList<PassengerReviewsDtoOutputPendingItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;

  factory _$PassengerReviewsDtoOutputPending(
          [void Function(PassengerReviewsDtoOutputPendingBuilder)? updates]) =>
      (PassengerReviewsDtoOutputPendingBuilder()..update(updates))._build();

  _$PassengerReviewsDtoOutputPending._(
      {required this.items, this.nextCursor, required this.total})
      : super._();
  @override
  PassengerReviewsDtoOutputPending rebuild(
          void Function(PassengerReviewsDtoOutputPendingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PassengerReviewsDtoOutputPendingBuilder toBuilder() =>
      PassengerReviewsDtoOutputPendingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PassengerReviewsDtoOutputPending &&
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
    return (newBuiltValueToStringHelper(r'PassengerReviewsDtoOutputPending')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total))
        .toString();
  }
}

class PassengerReviewsDtoOutputPendingBuilder
    implements
        Builder<PassengerReviewsDtoOutputPending,
            PassengerReviewsDtoOutputPendingBuilder> {
  _$PassengerReviewsDtoOutputPending? _$v;

  ListBuilder<PassengerReviewsDtoOutputPendingItemsInner>? _items;
  ListBuilder<PassengerReviewsDtoOutputPendingItemsInner> get items =>
      _$this._items ??=
          ListBuilder<PassengerReviewsDtoOutputPendingItemsInner>();
  set items(ListBuilder<PassengerReviewsDtoOutputPendingItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  PassengerReviewsDtoOutputPendingBuilder() {
    PassengerReviewsDtoOutputPending._defaults(this);
  }

  PassengerReviewsDtoOutputPendingBuilder get _$this {
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
  void replace(PassengerReviewsDtoOutputPending other) {
    _$v = other as _$PassengerReviewsDtoOutputPending;
  }

  @override
  void update(void Function(PassengerReviewsDtoOutputPendingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PassengerReviewsDtoOutputPending build() => _build();

  _$PassengerReviewsDtoOutputPending _build() {
    _$PassengerReviewsDtoOutputPending _$result;
    try {
      _$result = _$v ??
          _$PassengerReviewsDtoOutputPending._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'PassengerReviewsDtoOutputPending', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PassengerReviewsDtoOutputPending', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
