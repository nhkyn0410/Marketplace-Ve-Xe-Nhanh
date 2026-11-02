// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_vehicle_type_update_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminVehicleTypeUpdateDto extends AdminVehicleTypeUpdateDto {
  @override
  final String name;
  @override
  final String? description;

  factory _$AdminVehicleTypeUpdateDto(
          [void Function(AdminVehicleTypeUpdateDtoBuilder)? updates]) =>
      (AdminVehicleTypeUpdateDtoBuilder()..update(updates))._build();

  _$AdminVehicleTypeUpdateDto._({required this.name, this.description})
      : super._();
  @override
  AdminVehicleTypeUpdateDto rebuild(
          void Function(AdminVehicleTypeUpdateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminVehicleTypeUpdateDtoBuilder toBuilder() =>
      AdminVehicleTypeUpdateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminVehicleTypeUpdateDto &&
        name == other.name &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminVehicleTypeUpdateDto')
          ..add('name', name)
          ..add('description', description))
        .toString();
  }
}

class AdminVehicleTypeUpdateDtoBuilder
    implements
        Builder<AdminVehicleTypeUpdateDto, AdminVehicleTypeUpdateDtoBuilder> {
  _$AdminVehicleTypeUpdateDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  AdminVehicleTypeUpdateDtoBuilder() {
    AdminVehicleTypeUpdateDto._defaults(this);
  }

  AdminVehicleTypeUpdateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminVehicleTypeUpdateDto other) {
    _$v = other as _$AdminVehicleTypeUpdateDto;
  }

  @override
  void update(void Function(AdminVehicleTypeUpdateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminVehicleTypeUpdateDto build() => _build();

  _$AdminVehicleTypeUpdateDto _build() {
    final _$result = _$v ??
        _$AdminVehicleTypeUpdateDto._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminVehicleTypeUpdateDto', 'name'),
          description: description,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
