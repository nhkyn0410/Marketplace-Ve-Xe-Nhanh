// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_province_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminProvincePageDtoOutput extends AdminProvincePageDtoOutput {
  @override
  final BuiltList<AdminProvincePageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;

  factory _$AdminProvincePageDtoOutput(
          [void Function(AdminProvincePageDtoOutputBuilder)? updates]) =>
      (AdminProvincePageDtoOutputBuilder()..update(updates))._build();

  _$AdminProvincePageDtoOutput._(
      {required this.items, this.nextCursor, required this.total})
      : super._();
  @override
  AdminProvincePageDtoOutput rebuild(
          void Function(AdminProvincePageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminProvincePageDtoOutputBuilder toBuilder() =>
      AdminProvincePageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminProvincePageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminProvincePageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total))
        .toString();
  }
}

class AdminProvincePageDtoOutputBuilder
    implements
        Builder<AdminProvincePageDtoOutput, AdminProvincePageDtoOutputBuilder> {
  _$AdminProvincePageDtoOutput? _$v;

  ListBuilder<AdminProvincePageDtoOutputItemsInner>? _items;
  ListBuilder<AdminProvincePageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminProvincePageDtoOutputItemsInner>();
  set items(ListBuilder<AdminProvincePageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  AdminProvincePageDtoOutputBuilder() {
    AdminProvincePageDtoOutput._defaults(this);
  }

  AdminProvincePageDtoOutputBuilder get _$this {
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
  void replace(AdminProvincePageDtoOutput other) {
    _$v = other as _$AdminProvincePageDtoOutput;
  }

  @override
  void update(void Function(AdminProvincePageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminProvincePageDtoOutput build() => _build();

  _$AdminProvincePageDtoOutput _build() {
    _$AdminProvincePageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminProvincePageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminProvincePageDtoOutput', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminProvincePageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
