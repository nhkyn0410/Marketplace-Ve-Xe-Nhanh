// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_passenger_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPassengerPageDtoOutput extends AdminPassengerPageDtoOutput {
  @override
  final BuiltList<AdminPassengerPageDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;

  factory _$AdminPassengerPageDtoOutput(
          [void Function(AdminPassengerPageDtoOutputBuilder)? updates]) =>
      (AdminPassengerPageDtoOutputBuilder()..update(updates))._build();

  _$AdminPassengerPageDtoOutput._(
      {required this.items, this.nextCursor, required this.total})
      : super._();
  @override
  AdminPassengerPageDtoOutput rebuild(
          void Function(AdminPassengerPageDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPassengerPageDtoOutputBuilder toBuilder() =>
      AdminPassengerPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPassengerPageDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminPassengerPageDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total))
        .toString();
  }
}

class AdminPassengerPageDtoOutputBuilder
    implements
        Builder<AdminPassengerPageDtoOutput,
            AdminPassengerPageDtoOutputBuilder> {
  _$AdminPassengerPageDtoOutput? _$v;

  ListBuilder<AdminPassengerPageDtoOutputItemsInner>? _items;
  ListBuilder<AdminPassengerPageDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminPassengerPageDtoOutputItemsInner>();
  set items(ListBuilder<AdminPassengerPageDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  AdminPassengerPageDtoOutputBuilder() {
    AdminPassengerPageDtoOutput._defaults(this);
  }

  AdminPassengerPageDtoOutputBuilder get _$this {
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
  void replace(AdminPassengerPageDtoOutput other) {
    _$v = other as _$AdminPassengerPageDtoOutput;
  }

  @override
  void update(void Function(AdminPassengerPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPassengerPageDtoOutput build() => _build();

  _$AdminPassengerPageDtoOutput _build() {
    _$AdminPassengerPageDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminPassengerPageDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminPassengerPageDtoOutput', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminPassengerPageDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
