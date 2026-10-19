// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_refund_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRefundPageDtoOutput extends AdminRefundPageDtoOutput {
  @override
  final BuiltList<AdminRefundPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;

  factory _$AdminRefundPageDtoOutput(
          [void Function(AdminRefundPageDtoOutputBuilder)? updates]) =>
      (AdminRefundPageDtoOutputBuilder()..update(updates))._build();

  _$AdminRefundPageDtoOutput._(
      {required this.items, this.nextCursor, required this.total})
      : super._();
  @override
  AdminRefundPageDtoOutput rebuild(
          void Function(AdminRefundPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminRefundPageDtoOutputBuilder toBuilder() =>
      AdminRefundPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRefundPageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminRefundPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total))
        .toString();
  }
}

class AdminRefundPageDtoOutputBuilder
    implements
        Builder<AdminRefundPageDtoOutput, AdminRefundPageDtoOutputBuilder> {
  _$AdminRefundPageDtoOutput? _$v;

  ListBuilder<AdminRefundPageDtoOutputItemsInner>? _items;
  ListBuilder<AdminRefundPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminRefundPageDtoOutputItemsInner>();
  set items(ListBuilder<AdminRefundPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  AdminRefundPageDtoOutputBuilder() {
    AdminRefundPageDtoOutput._defaults(this);
  }

  AdminRefundPageDtoOutputBuilder get _$this {
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
  void replace(AdminRefundPageDtoOutput other) {
    _$v = other as _$AdminRefundPageDtoOutput;
  }

  @override
  void update(void Function(AdminRefundPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRefundPageDtoOutput build() => _build();

  _$AdminRefundPageDtoOutput _build() {
    _$AdminRefundPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminRefundPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminRefundPageDtoOutput', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminRefundPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
