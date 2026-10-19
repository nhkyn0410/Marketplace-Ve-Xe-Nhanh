// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignee_list_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssigneeListDtoOutputItemsInner
    extends AssigneeListDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String username;
  @override
  final String role;

  factory _$AssigneeListDtoOutputItemsInner(
          [void Function(AssigneeListDtoOutputItemsInnerBuilder)? updates]) =>
      (AssigneeListDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$AssigneeListDtoOutputItemsInner._(
      {required this.id, required this.username, required this.role})
      : super._();
  @override
  AssigneeListDtoOutputItemsInner rebuild(
          void Function(AssigneeListDtoOutputItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssigneeListDtoOutputItemsInnerBuilder toBuilder() =>
      AssigneeListDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssigneeListDtoOutputItemsInner &&
        id == other.id &&
        username == other.username &&
        role == other.role;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssigneeListDtoOutputItemsInner')
          ..add('id', id)
          ..add('username', username)
          ..add('role', role))
        .toString();
  }
}

class AssigneeListDtoOutputItemsInnerBuilder
    implements
        Builder<AssigneeListDtoOutputItemsInner,
            AssigneeListDtoOutputItemsInnerBuilder> {
  _$AssigneeListDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  AssigneeListDtoOutputItemsInnerBuilder() {
    AssigneeListDtoOutputItemsInner._defaults(this);
  }

  AssigneeListDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _username = $v.username;
      _role = $v.role;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssigneeListDtoOutputItemsInner other) {
    _$v = other as _$AssigneeListDtoOutputItemsInner;
  }

  @override
  void update(void Function(AssigneeListDtoOutputItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssigneeListDtoOutputItemsInner build() => _build();

  _$AssigneeListDtoOutputItemsInner _build() {
    final _$result = _$v ??
        _$AssigneeListDtoOutputItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AssigneeListDtoOutputItemsInner', 'id'),
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'AssigneeListDtoOutputItemsInner', 'username'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'AssigneeListDtoOutputItemsInner', 'role'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
