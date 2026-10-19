// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_shared_stop_point_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSharedStopPointListDtoOutput
    extends AdminSharedStopPointListDtoOutput {
  @override
  final BuiltList<AdminSharedStopPointListDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;

  factory _$AdminSharedStopPointListDtoOutput(
          [void Function(AdminSharedStopPointListDtoOutputBuilder)? updates]) =>
      (AdminSharedStopPointListDtoOutputBuilder()..update(updates))._build();

  _$AdminSharedStopPointListDtoOutput._(
      {required this.items, this.nextCursor, required this.total})
      : super._();
  @override
  AdminSharedStopPointListDtoOutput rebuild(
          void Function(AdminSharedStopPointListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSharedStopPointListDtoOutputBuilder toBuilder() =>
      AdminSharedStopPointListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSharedStopPointListDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminSharedStopPointListDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total))
        .toString();
  }
}

class AdminSharedStopPointListDtoOutputBuilder
    implements
        Builder<AdminSharedStopPointListDtoOutput,
            AdminSharedStopPointListDtoOutputBuilder> {
  _$AdminSharedStopPointListDtoOutput? _$v;

  ListBuilder<AdminSharedStopPointListDtoOutputItemsInner>? _items;
  ListBuilder<AdminSharedStopPointListDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<AdminSharedStopPointListDtoOutputItemsInner>();
  set items(ListBuilder<AdminSharedStopPointListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  AdminSharedStopPointListDtoOutputBuilder() {
    AdminSharedStopPointListDtoOutput._defaults(this);
  }

  AdminSharedStopPointListDtoOutputBuilder get _$this {
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
  void replace(AdminSharedStopPointListDtoOutput other) {
    _$v = other as _$AdminSharedStopPointListDtoOutput;
  }

  @override
  void update(
      void Function(AdminSharedStopPointListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSharedStopPointListDtoOutput build() => _build();

  _$AdminSharedStopPointListDtoOutput _build() {
    _$AdminSharedStopPointListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminSharedStopPointListDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminSharedStopPointListDtoOutput', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminSharedStopPointListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
