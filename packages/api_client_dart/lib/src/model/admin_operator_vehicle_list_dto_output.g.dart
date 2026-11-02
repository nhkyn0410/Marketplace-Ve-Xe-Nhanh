// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_operator_vehicle_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOperatorVehicleListDtoOutput
    extends AdminOperatorVehicleListDtoOutput {
  @override
  final BuiltList<AdminOperatorVehicleListDtoOutputItemsInner> items;

  factory _$AdminOperatorVehicleListDtoOutput(
          [void Function(AdminOperatorVehicleListDtoOutputBuilder)? updates]) =>
      (AdminOperatorVehicleListDtoOutputBuilder()..update(updates))._build();

  _$AdminOperatorVehicleListDtoOutput._({required this.items}) : super._();
  @override
  AdminOperatorVehicleListDtoOutput rebuild(
          void Function(AdminOperatorVehicleListDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOperatorVehicleListDtoOutputBuilder toBuilder() =>
      AdminOperatorVehicleListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOperatorVehicleListDtoOutput && items == other.items;
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
    return (newBuiltValueToStringHelper(r'AdminOperatorVehicleListDtoOutput')
          ..add('items', items))
        .toString();
  }
}

class AdminOperatorVehicleListDtoOutputBuilder
    implements
        Builder<AdminOperatorVehicleListDtoOutput,
            AdminOperatorVehicleListDtoOutputBuilder> {
  _$AdminOperatorVehicleListDtoOutput? _$v;

  ListBuilder<AdminOperatorVehicleListDtoOutputItemsInner>? _items;
  ListBuilder<AdminOperatorVehicleListDtoOutputItemsInner> get items =>
      _$this._items ??=
          ListBuilder<AdminOperatorVehicleListDtoOutputItemsInner>();
  set items(ListBuilder<AdminOperatorVehicleListDtoOutputItemsInner>? items) =>
      _$this._items = items;

  AdminOperatorVehicleListDtoOutputBuilder() {
    AdminOperatorVehicleListDtoOutput._defaults(this);
  }

  AdminOperatorVehicleListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOperatorVehicleListDtoOutput other) {
    _$v = other as _$AdminOperatorVehicleListDtoOutput;
  }

  @override
  void update(
      void Function(AdminOperatorVehicleListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOperatorVehicleListDtoOutput build() => _build();

  _$AdminOperatorVehicleListDtoOutput _build() {
    _$AdminOperatorVehicleListDtoOutput _$result;
    try {
      _$result = _$v ??
          _$AdminOperatorVehicleListDtoOutput._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminOperatorVehicleListDtoOutput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
