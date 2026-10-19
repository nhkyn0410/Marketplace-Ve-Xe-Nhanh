// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_amenity_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAmenityListDtoOutput extends AdminAmenityListDtoOutput {
  @override
  final BuiltList<AdminAmenityListDtoOutputItemsInner> items;

  factory _$AdminAmenityListDtoOutput(
          [void Function(AdminAmenityListDtoOutputBuilder)? updates]) =>
      (AdminAmenityListDtoOutputBuilder()..update(updates))._build();

  _$AdminAmenityListDtoOutput._({required this.items}) : super._();
  @override
  AdminAmenityListDtoOutput rebuild(
          void Function(AdminAmenityListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAmenityListDtoOutputBuilder toBuilder() =>
      AdminAmenityListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAmenityListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'AdminAmenityListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class AdminAmenityListDtoOutputBuilder
    implements
        Builder<AdminAmenityListDtoOutput, AdminAmenityListDtoOutputBuilder> {
  _$AdminAmenityListDtoOutput? _$v;

  ListBuilder<AdminAmenityListDtoOutputItemsInner>? _items;
  ListBuilder<AdminAmenityListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminAmenityListDtoOutputItemsInner>();
  set items(ListBuilder<AdminAmenityListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  AdminAmenityListDtoOutputBuilder() {
    AdminAmenityListDtoOutput._defaults(this);
  }

  AdminAmenityListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAmenityListDtoOutput other) {
    _$v = other as _$AdminAmenityListDtoOutput;
  }

  @override
  void update(void Function(AdminAmenityListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAmenityListDtoOutput build() => _build();

  _$AdminAmenityListDtoOutput _build() {
    _$AdminAmenityListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminAmenityListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminAmenityListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
