// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_office_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SalesOfficeListDtoOutputItemsInner
    extends SalesOfficeListDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String address;
  @override
  final bool active;
  @override
  final int version;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$SalesOfficeListDtoOutputItemsInner(
          [void Function(SalesOfficeListDtoOutputItemsInnerBuilder)?
              updates]) =>
      (SalesOfficeListDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$SalesOfficeListDtoOutputItemsInner._(
      {required this.id,
      required this.code,
      required this.name,
      required this.address,
      required this.active,
      required this.version,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  SalesOfficeListDtoOutputItemsInner rebuild(
          void Function(SalesOfficeListDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SalesOfficeListDtoOutputItemsInnerBuilder toBuilder() =>
      SalesOfficeListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalesOfficeListDtoOutputItemsInner &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        address == other.address &&
        active == other.active &&
        version == other.version &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SalesOfficeListDtoOutputItemsInner')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('address', address)
          ..add('active', active)
          ..add('version', version)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class SalesOfficeListDtoOutputItemsInnerBuilder
    implements
        Builder<SalesOfficeListDtoOutputItemsInner,
            SalesOfficeListDtoOutputItemsInnerBuilder> {
  _$SalesOfficeListDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  SalesOfficeListDtoOutputItemsInnerBuilder() {
    SalesOfficeListDtoOutputItemsInner._defaults(this);
  }

  SalesOfficeListDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _address = $v.address;
      _active = $v.active;
      _version = $v.version;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalesOfficeListDtoOutputItemsInner other) {
    _$v = other as _$SalesOfficeListDtoOutputItemsInner;
  }

  @override
  void update(
      void Function(SalesOfficeListDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalesOfficeListDtoOutputItemsInner build() => _build();

  _$SalesOfficeListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$SalesOfficeListDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'SalesOfficeListDtoOutputItemsInner', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'SalesOfficeListDtoOutputItemsInner', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'SalesOfficeListDtoOutputItemsInner', 'name'),
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'SalesOfficeListDtoOutputItemsInner', 'address'),
          active: BuiltValueNullFieldError.checkNotNull(
              active, r'SalesOfficeListDtoOutputItemsInner', 'active'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'SalesOfficeListDtoOutputItemsInner', 'version'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'SalesOfficeListDtoOutputItemsInner', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'SalesOfficeListDtoOutputItemsInner', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
