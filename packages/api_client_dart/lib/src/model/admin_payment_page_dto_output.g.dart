// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_payment_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPaymentPageDtoOutput extends AdminPaymentPageDtoOutput {
  @override
  final BuiltList<AdminPaymentPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;
  @override
  final int reconcileOpen;

  factory _$AdminPaymentPageDtoOutput(
          [void Function(AdminPaymentPageDtoOutputBuilder)? updates]) =>
      (AdminPaymentPageDtoOutputBuilder()..update(updates))._build();

  _$AdminPaymentPageDtoOutput._(
      {required this.items,
      this.nextCursor,
      required this.total,
      required this.reconcileOpen})
      : super._();
  @override
  AdminPaymentPageDtoOutput rebuild(
          void Function(AdminPaymentPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPaymentPageDtoOutputBuilder toBuilder() =>
      AdminPaymentPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPaymentPageDtoOutput &&
        items == other.items &&
        nextCursor == other.nextCursor &&
        total == other.total &&
        reconcileOpen == other.reconcileOpen;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, reconcileOpen.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPaymentPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total)
          ..add('reconcileOpen', reconcileOpen))
        .toString();
  }
}

class AdminPaymentPageDtoOutputBuilder
    implements
        Builder<AdminPaymentPageDtoOutput, AdminPaymentPageDtoOutputBuilder> {
  _$AdminPaymentPageDtoOutput? _$v;

  ListBuilder<AdminPaymentPageDtoOutputItemsInner>? _items;
  ListBuilder<AdminPaymentPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminPaymentPageDtoOutputItemsInner>();
  set items(ListBuilder<AdminPaymentPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _reconcileOpen;
  int? get reconcileOpen => _$this._reconcileOpen;
  set reconcileOpen(int? reconcileOpen) =>
      _$this._reconcileOpen = reconcileOpen;

  AdminPaymentPageDtoOutputBuilder() {
    AdminPaymentPageDtoOutput._defaults(this);
  }

  AdminPaymentPageDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _total = $v.total;
      _reconcileOpen = $v.reconcileOpen;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPaymentPageDtoOutput other) {
    _$v = other as _$AdminPaymentPageDtoOutput;
  }

  @override
  void update(void Function(AdminPaymentPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPaymentPageDtoOutput build() => _build();

  _$AdminPaymentPageDtoOutput _build() {
    _$AdminPaymentPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminPaymentPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminPaymentPageDtoOutput', 'total'),
            reconcileOpen: BuiltValueNullFieldError.checkNotNull(
                reconcileOpen, r'AdminPaymentPageDtoOutput', 'reconcileOpen'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminPaymentPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
