// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_log_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationLogDtoOutput extends NotificationLogDtoOutput {
  @override
  final BuiltList<NotificationLogDtoOutputItemsInner> items;
  @override
  final int total;
  @override
  final int offset;
  @override
  final int limit;

  factory _$NotificationLogDtoOutput(
          [void Function(NotificationLogDtoOutputBuilder)? updates]) =>
      (NotificationLogDtoOutputBuilder()..update(updates))._build();

  _$NotificationLogDtoOutput._(
      {required this.items,
      required this.total,
      required this.offset,
      required this.limit})
      : super._();
  @override
  NotificationLogDtoOutput rebuild(
          void Function(NotificationLogDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationLogDtoOutputBuilder toBuilder() =>
      NotificationLogDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationLogDtoOutput &&
        items == other.items &&
        total == other.total &&
        offset == other.offset &&
        limit == other.limit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, offset.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationLogDtoOutput')
          ..add('items', items)
          ..add('total', total)
          ..add('offset', offset)
          ..add('limit', limit))
        .toString();
  }
}

class NotificationLogDtoOutputBuilder
    implements
        Builder<NotificationLogDtoOutput, NotificationLogDtoOutputBuilder> {
  _$NotificationLogDtoOutput? _$v;

  ListBuilder<NotificationLogDtoOutputItemsInner>? _items;
  ListBuilder<NotificationLogDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<NotificationLogDtoOutputItemsInner>();
  set items(ListBuilder<NotificationLogDtoOutputItemsInner>? items) =>
      _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _offset;
  int? get offset => _$this._offset;
  set offset(int? offset) => _$this._offset = offset;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  NotificationLogDtoOutputBuilder() {
    NotificationLogDtoOutput._defaults(this);
  }

  NotificationLogDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _offset = $v.offset;
      _limit = $v.limit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationLogDtoOutput other) {
    _$v = other as _$NotificationLogDtoOutput;
  }

  @override
  void update(void Function(NotificationLogDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationLogDtoOutput build() => _build();

  _$NotificationLogDtoOutput _build() {
    _$NotificationLogDtoOutput _$result;
    try {
      _$result = _$v ??
          _$NotificationLogDtoOutput._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'NotificationLogDtoOutput', 'total'),
            offset: BuiltValueNullFieldError.checkNotNull(
                offset, r'NotificationLogDtoOutput', 'offset'),
            limit: BuiltValueNullFieldError.checkNotNull(
                limit, r'NotificationLogDtoOutput', 'limit'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'NotificationLogDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
