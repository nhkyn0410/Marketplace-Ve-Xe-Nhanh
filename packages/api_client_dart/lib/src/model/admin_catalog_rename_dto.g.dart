// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_catalog_rename_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCatalogRenameDto extends AdminCatalogRenameDto {
  @override
  final String name;

  factory _$AdminCatalogRenameDto(
          [void Function(AdminCatalogRenameDtoBuilder)? updates]) =>
      (AdminCatalogRenameDtoBuilder()..update(updates))._build();

  _$AdminCatalogRenameDto._({required this.name}) : super._();
  @override
  AdminCatalogRenameDto rebuild(
          void Function(AdminCatalogRenameDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminCatalogRenameDtoBuilder toBuilder() =>
      AdminCatalogRenameDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCatalogRenameDto && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCatalogRenameDto')
          ..add('name', name))
        .toString();
  }
}

class AdminCatalogRenameDtoBuilder
    implements Builder<AdminCatalogRenameDto, AdminCatalogRenameDtoBuilder> {
  _$AdminCatalogRenameDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminCatalogRenameDtoBuilder() {
    AdminCatalogRenameDto._defaults(this);
  }

  AdminCatalogRenameDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCatalogRenameDto other) {
    _$v = other as _$AdminCatalogRenameDto;
  }

  @override
  void update(void Function(AdminCatalogRenameDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCatalogRenameDto build() => _build();

  _$AdminCatalogRenameDto _build() {
    final _$result = _$v ??
        _$AdminCatalogRenameDto._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminCatalogRenameDto', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
