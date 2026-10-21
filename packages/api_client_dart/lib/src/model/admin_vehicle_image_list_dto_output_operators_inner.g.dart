// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_vehicle_image_list_dto_output_operators_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminVehicleImageListDtoOutputOperatorsInner
    extends AdminVehicleImageListDtoOutputOperatorsInner {
  @override
  final String id;
  @override
  final String name;

  factory _$AdminVehicleImageListDtoOutputOperatorsInner(
          [void Function(AdminVehicleImageListDtoOutputOperatorsInnerBuilder)?
              updates]) =>
      (AdminVehicleImageListDtoOutputOperatorsInnerBuilder()..update(updates))
          ._build();

  _$AdminVehicleImageListDtoOutputOperatorsInner._(
      {required this.id, required this.name})
      : super._();
  @override
  AdminVehicleImageListDtoOutputOperatorsInner rebuild(
          void Function(AdminVehicleImageListDtoOutputOperatorsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminVehicleImageListDtoOutputOperatorsInnerBuilder toBuilder() =>
      AdminVehicleImageListDtoOutputOperatorsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminVehicleImageListDtoOutputOperatorsInner &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminVehicleImageListDtoOutputOperatorsInner')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class AdminVehicleImageListDtoOutputOperatorsInnerBuilder
    implements
        Builder<AdminVehicleImageListDtoOutputOperatorsInner,
            AdminVehicleImageListDtoOutputOperatorsInnerBuilder> {
  _$AdminVehicleImageListDtoOutputOperatorsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminVehicleImageListDtoOutputOperatorsInnerBuilder() {
    AdminVehicleImageListDtoOutputOperatorsInner._defaults(this);
  }

  AdminVehicleImageListDtoOutputOperatorsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminVehicleImageListDtoOutputOperatorsInner other) {
    _$v = other as _$AdminVehicleImageListDtoOutputOperatorsInner;
  }

  @override
  void update(
      void Function(AdminVehicleImageListDtoOutputOperatorsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminVehicleImageListDtoOutputOperatorsInner build() => _build();

  _$AdminVehicleImageListDtoOutputOperatorsInner _build() {
    final _$result = _$v ??
        _$AdminVehicleImageListDtoOutputOperatorsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminVehicleImageListDtoOutputOperatorsInner', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminVehicleImageListDtoOutputOperatorsInner', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
