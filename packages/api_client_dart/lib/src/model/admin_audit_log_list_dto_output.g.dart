// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_audit_log_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAuditLogListDtoOutput extends AdminAuditLogListDtoOutput {
  @override
  final BuiltList<AdminAuditLogListDtoOutputItemsInner> items;
  @override
  final String? nextCursor;
  @override
  final int total;

  factory _$AdminAuditLogListDtoOutput(
          [void Function(AdminAuditLogListDtoOutputBuilder)? updates]) =>
      (AdminAuditLogListDtoOutputBuilder()..update(updates))._build();

  _$AdminAuditLogListDtoOutput._(
      {required this.items, this.nextCursor, required this.total})
      : super._();
  @override
  AdminAuditLogListDtoOutput rebuild(
          void Function(AdminAuditLogListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAuditLogListDtoOutputBuilder toBuilder() =>
      AdminAuditLogListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAuditLogListDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminAuditLogListDtoOutput')
          ..add('items', items)
          ..add('nextCursor', nextCursor)
          ..add('total', total))
        .toString();
  }
}

class AdminAuditLogListDtoOutputBuilder
    implements
        Builder<AdminAuditLogListDtoOutput, AdminAuditLogListDtoOutputBuilder> {
  _$AdminAuditLogListDtoOutput? _$v;

  ListBuilder<AdminAuditLogListDtoOutputItemsInner>? _items;
  ListBuilder<AdminAuditLogListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminAuditLogListDtoOutputItemsInner>();
  set items(ListBuilder<AdminAuditLogListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  AdminAuditLogListDtoOutputBuilder() {
    AdminAuditLogListDtoOutput._defaults(this);
  }

  AdminAuditLogListDtoOutputBuilder get _$this {
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
  void replace(AdminAuditLogListDtoOutput other) {
    _$v = other as _$AdminAuditLogListDtoOutput;
  }

  @override
  void update(void Function(AdminAuditLogListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAuditLogListDtoOutput build() => _build();

  _$AdminAuditLogListDtoOutput _build() {
    _$AdminAuditLogListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminAuditLogListDtoOutput._(
            items: items.build(),
            nextCursor: nextCursor,
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminAuditLogListDtoOutput', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminAuditLogListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
