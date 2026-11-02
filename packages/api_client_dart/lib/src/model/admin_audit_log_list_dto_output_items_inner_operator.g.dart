// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_audit_log_list_dto_output_items_inner_operator.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAuditLogListDtoOutputItemsInnerOperator
    extends AdminAuditLogListDtoOutputItemsInnerOperator {
  @override
  final String id;
  @override
  final String name;

  factory _$AdminAuditLogListDtoOutputItemsInnerOperator(
          [void Function(AdminAuditLogListDtoOutputItemsInnerOperatorBuilder)?
              updates]) =>
      (AdminAuditLogListDtoOutputItemsInnerOperatorBuilder()..update(updates))
          ._build();

  _$AdminAuditLogListDtoOutputItemsInnerOperator._(
      {required this.id, required this.name})
      : super._();
  @override
  AdminAuditLogListDtoOutputItemsInnerOperator rebuild(
          void Function(AdminAuditLogListDtoOutputItemsInnerOperatorBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAuditLogListDtoOutputItemsInnerOperatorBuilder toBuilder() =>
      AdminAuditLogListDtoOutputItemsInnerOperatorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAuditLogListDtoOutputItemsInnerOperator &&
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
            r'AdminAuditLogListDtoOutputItemsInnerOperator')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class AdminAuditLogListDtoOutputItemsInnerOperatorBuilder
    implements
        Builder<AdminAuditLogListDtoOutputItemsInnerOperator,
            AdminAuditLogListDtoOutputItemsInnerOperatorBuilder> {
  _$AdminAuditLogListDtoOutputItemsInnerOperator? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminAuditLogListDtoOutputItemsInnerOperatorBuilder() {
    AdminAuditLogListDtoOutputItemsInnerOperator._defaults(this);
  }

  AdminAuditLogListDtoOutputItemsInnerOperatorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAuditLogListDtoOutputItemsInnerOperator other) {
    _$v = other as _$AdminAuditLogListDtoOutputItemsInnerOperator;
  }

  @override
  void update(
      void Function(AdminAuditLogListDtoOutputItemsInnerOperatorBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAuditLogListDtoOutputItemsInnerOperator build() => _build();

  _$AdminAuditLogListDtoOutputItemsInnerOperator _build() {
    final _$result = _$v ??
        _$AdminAuditLogListDtoOutputItemsInnerOperator._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminAuditLogListDtoOutputItemsInnerOperator', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AdminAuditLogListDtoOutputItemsInnerOperator', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
