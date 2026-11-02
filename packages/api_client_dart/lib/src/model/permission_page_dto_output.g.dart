// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PermissionPageDtoOutput extends PermissionPageDtoOutput {
  @override
  final BuiltList<PermissionPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;

  factory _$PermissionPageDtoOutput(
          [void Function(PermissionPageDtoOutputBuilder)? updates]) =>
      (PermissionPageDtoOutputBuilder()..update(updates))._build();

  _$PermissionPageDtoOutput._(
      {required this.items, this.nextCursor, required this.total})
      : super._();
  @override
  PermissionPageDtoOutput rebuild(
          void Function(PermissionPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PermissionPageDtoOutputBuilder toBuilder() =>
      PermissionPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PermissionPageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'PermissionPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total))
        .toString();
  }
}

class PermissionPageDtoOutputBuilder
    implements
        Builder<PermissionPageDtoOutput, PermissionPageDtoOutputBuilder> {
  _$PermissionPageDtoOutput? _$v;

  ListBuilder<PermissionPageDtoOutputItemsInner>? _items;
  ListBuilder<PermissionPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<PermissionPageDtoOutputItemsInner>();
  set items(ListBuilder<PermissionPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  PermissionPageDtoOutputBuilder() {
    PermissionPageDtoOutput._defaults(this);
  }

  PermissionPageDtoOutputBuilder get _$this {
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
  void replace(PermissionPageDtoOutput other) {
    _$v = other as _$PermissionPageDtoOutput;
  }

  @override
  void update(void Function(PermissionPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PermissionPageDtoOutput build() => _build();

  _$PermissionPageDtoOutput _build() {
    _$PermissionPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$PermissionPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'PermissionPageDtoOutput', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PermissionPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
