// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_operator_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOperatorPageDtoOutput extends AdminOperatorPageDtoOutput {
  @override
  final BuiltList<AdminOperatorPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;

  factory _$AdminOperatorPageDtoOutput(
          [void Function(AdminOperatorPageDtoOutputBuilder)? updates]) =>
      (AdminOperatorPageDtoOutputBuilder()..update(updates))._build();

  _$AdminOperatorPageDtoOutput._(
      {required this.items, this.nextCursor, required this.total})
      : super._();
  @override
  AdminOperatorPageDtoOutput rebuild(
          void Function(AdminOperatorPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOperatorPageDtoOutputBuilder toBuilder() =>
      AdminOperatorPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOperatorPageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminOperatorPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total))
        .toString();
  }
}

class AdminOperatorPageDtoOutputBuilder
    implements
        Builder<AdminOperatorPageDtoOutput, AdminOperatorPageDtoOutputBuilder> {
  _$AdminOperatorPageDtoOutput? _$v;

  ListBuilder<AdminOperatorPageDtoOutputItemsInner>? _items;
  ListBuilder<AdminOperatorPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminOperatorPageDtoOutputItemsInner>();
  set items(ListBuilder<AdminOperatorPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  AdminOperatorPageDtoOutputBuilder() {
    AdminOperatorPageDtoOutput._defaults(this);
  }

  AdminOperatorPageDtoOutputBuilder get _$this {
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
  void replace(AdminOperatorPageDtoOutput other) {
    _$v = other as _$AdminOperatorPageDtoOutput;
  }

  @override
  void update(void Function(AdminOperatorPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOperatorPageDtoOutput build() => _build();

  _$AdminOperatorPageDtoOutput _build() {
    _$AdminOperatorPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminOperatorPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminOperatorPageDtoOutput', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminOperatorPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
