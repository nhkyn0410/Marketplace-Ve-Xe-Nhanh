// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_platform_account_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPlatformAccountListDtoOutput
    extends AdminPlatformAccountListDtoOutput {
  @override
  final BuiltList<AdminPlatformAccountListDtoOutputItemsInner> items;

  factory _$AdminPlatformAccountListDtoOutput(
          [void Function(AdminPlatformAccountListDtoOutputBuilder)? updates]) =>
      (AdminPlatformAccountListDtoOutputBuilder()..update(updates))._build();

  _$AdminPlatformAccountListDtoOutput._({required this.items}) : super._();
  @override
  AdminPlatformAccountListDtoOutput rebuild(
          void Function(AdminPlatformAccountListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminPlatformAccountListDtoOutputBuilder toBuilder() =>
      AdminPlatformAccountListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPlatformAccountListDtoOutput && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPlatformAccountListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class AdminPlatformAccountListDtoOutputBuilder
    implements
        Builder<AdminPlatformAccountListDtoOutput,
            AdminPlatformAccountListDtoOutputBuilder> {
  _$AdminPlatformAccountListDtoOutput? _$v;

  ListBuilder<AdminPlatformAccountListDtoOutputItemsInner>? _items;
  ListBuilder<AdminPlatformAccountListDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<AdminPlatformAccountListDtoOutputItemsInner>();
  set items(ListBuilder<AdminPlatformAccountListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  AdminPlatformAccountListDtoOutputBuilder() {
    AdminPlatformAccountListDtoOutput._defaults(this);
  }

  AdminPlatformAccountListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPlatformAccountListDtoOutput other) {
    _$v = other as _$AdminPlatformAccountListDtoOutput;
  }

  @override
  void update(
      void Function(AdminPlatformAccountListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPlatformAccountListDtoOutput build() => _build();

  _$AdminPlatformAccountListDtoOutput _build() {
    _$AdminPlatformAccountListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminPlatformAccountListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminPlatformAccountListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
