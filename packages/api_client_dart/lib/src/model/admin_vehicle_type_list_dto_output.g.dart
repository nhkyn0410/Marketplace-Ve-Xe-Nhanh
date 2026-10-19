// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_vehicle_type_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminVehicleTypeListDtoOutput extends AdminVehicleTypeListDtoOutput {
  @override
  final BuiltList<AdminVehicleTypeListDtoOutputItemsInner> items;

  factory _$AdminVehicleTypeListDtoOutput(
          [void Function(AdminVehicleTypeListDtoOutputBuilder)? updates]) =>
      (AdminVehicleTypeListDtoOutputBuilder()..update(updates))._build();

  _$AdminVehicleTypeListDtoOutput._({required this.items}) : super._();
  @override
  AdminVehicleTypeListDtoOutput rebuild(
          void Function(AdminVehicleTypeListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminVehicleTypeListDtoOutputBuilder toBuilder() =>
      AdminVehicleTypeListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminVehicleTypeListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'AdminVehicleTypeListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class AdminVehicleTypeListDtoOutputBuilder
    implements
        Builder<AdminVehicleTypeListDtoOutput,
            AdminVehicleTypeListDtoOutputBuilder> {
  _$AdminVehicleTypeListDtoOutput? _$v;

  ListBuilder<AdminVehicleTypeListDtoOutputItemsInner>? _items;
  ListBuilder<AdminVehicleTypeListDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminVehicleTypeListDtoOutputItemsInner>();
  set items(ListBuilder<AdminVehicleTypeListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  AdminVehicleTypeListDtoOutputBuilder() {
    AdminVehicleTypeListDtoOutput._defaults(this);
  }

  AdminVehicleTypeListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminVehicleTypeListDtoOutput other) {
    _$v = other as _$AdminVehicleTypeListDtoOutput;
  }

  @override
  void update(void Function(AdminVehicleTypeListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminVehicleTypeListDtoOutput build() => _build();

  _$AdminVehicleTypeListDtoOutput _build() {
    _$AdminVehicleTypeListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminVehicleTypeListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminVehicleTypeListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
