// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ward_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminWardPageDtoOutput extends AdminWardPageDtoOutput {
  @override
  final BuiltList<AdminWardPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;

  factory _$AdminWardPageDtoOutput(
          [void Function(AdminWardPageDtoOutputBuilder)? updates]) =>
      (AdminWardPageDtoOutputBuilder()..update(updates))._build();

  _$AdminWardPageDtoOutput._(
      {required this.items, this.nextCursor, required this.total})
      : super._();
  @override
  AdminWardPageDtoOutput rebuild(
          void Function(AdminWardPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminWardPageDtoOutputBuilder toBuilder() =>
      AdminWardPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminWardPageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminWardPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total))
        .toString();
  }
}

class AdminWardPageDtoOutputBuilder
    implements Builder<AdminWardPageDtoOutput, AdminWardPageDtoOutputBuilder> {
  _$AdminWardPageDtoOutput? _$v;

  ListBuilder<AdminWardPageDtoOutputItemsInner>? _items;
  ListBuilder<AdminWardPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminWardPageDtoOutputItemsInner>();
  set items(ListBuilder<AdminWardPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  AdminWardPageDtoOutputBuilder() {
    AdminWardPageDtoOutput._defaults(this);
  }

  AdminWardPageDtoOutputBuilder get _$this {
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
  void replace(AdminWardPageDtoOutput other) {
    _$v = other as _$AdminWardPageDtoOutput;
  }

  @override
  void update(void Function(AdminWardPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminWardPageDtoOutput build() => _build();

  _$AdminWardPageDtoOutput _build() {
    _$AdminWardPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminWardPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminWardPageDtoOutput', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminWardPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
