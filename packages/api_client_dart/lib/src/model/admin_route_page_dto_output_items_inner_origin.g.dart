// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_route_page_dto_output_items_inner_origin.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRoutePageDtoOutputItemsInnerOrigin
    extends AdminRoutePageDtoOutputItemsInnerOrigin {
  @override
  final String id;
  @override
  final String name;

  factory _$AdminRoutePageDtoOutputItemsInnerOrigin(
          [void Function(AdminRoutePageDtoOutputItemsInnerOriginBuilder)?
              updates]) =>
      (AdminRoutePageDtoOutputItemsInnerOriginBuilder()..update(updates))
          ._build();

  _$AdminRoutePageDtoOutputItemsInnerOrigin._(
      {required this.id, required this.name})
      : super._();
  @override
  AdminRoutePageDtoOutputItemsInnerOrigin rebuild(
          void Function(AdminRoutePageDtoOutputItemsInnerOriginBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminRoutePageDtoOutputItemsInnerOriginBuilder toBuilder() =>
      AdminRoutePageDtoOutputItemsInnerOriginBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRoutePageDtoOutputItemsInnerOrigin &&
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
            r'AdminRoutePageDtoOutputItemsInnerOrigin')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class AdminRoutePageDtoOutputItemsInnerOriginBuilder
    implements
        Builder<AdminRoutePageDtoOutputItemsInnerOrigin,
            AdminRoutePageDtoOutputItemsInnerOriginBuilder> {
  _$AdminRoutePageDtoOutputItemsInnerOrigin? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminRoutePageDtoOutputItemsInnerOriginBuilder() {
    AdminRoutePageDtoOutputItemsInnerOrigin._defaults(this);
  }

  AdminRoutePageDtoOutputItemsInnerOriginBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRoutePageDtoOutputItemsInnerOrigin other) {
    _$v = other as _$AdminRoutePageDtoOutputItemsInnerOrigin;
  }

  @override
  void update(
      void Function(AdminRoutePageDtoOutputItemsInnerOriginBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRoutePageDtoOutputItemsInnerOrigin build() => _build();

  _$AdminRoutePageDtoOutputItemsInnerOrigin _build() {
    final _$result = _$v ??
        _$AdminRoutePageDtoOutputItemsInnerOrigin._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminRoutePageDtoOutputItemsInnerOrigin', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminRoutePageDtoOutputItemsInnerOrigin', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
